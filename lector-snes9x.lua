-- Chrono Trigger (U), Magno 101%. Challenge input is optional and user-triggered.
local source = debug.getinfo(1, "S").source:sub(2)
local folder = assert(source:match("^(.*[/\\])"), "Carga este archivo desde su ruta completa")
local function log(message)
    print(message)
    local file = io.open(folder .. "lector.log", "a")
    if file then file:write(message, "\n"); file:close() end
end
local signature = {0x20,0x84,0xE9,0x20,0xD3,0xE5,0x2C,0x1D,0x0D,
    0x30,0x0B,0xAD,0x81,0x00,0xC5,0x54,0xF0,0x03,0x20,0xC2,0xEA,0x60}
for index, expected in ipairs(signature) do
    if memory.readbyte(0xC2E236 + index - 1) ~= expected then
        error("La rutina del menu no coincide con la ROM soportada. Lector detenido.")
    end
end
local loader = assert(package.loadlib(folder .. "runtime/chrono_prism_v2.dll", "luaopen_chrono_prism"))
local voice = assert(loader(), "No se pudo cargar el modulo de voz Lua 5.1")
local backend = voice.init()
log("Salida de voz: " .. backend)
local roomAudio,walkTrace,challengeAssist=nil,nil,nil
emu.registerexit(function()
    if challengeAssist then challengeAssist.shutdown()end
    if walkTrace then walkTrace.shutdown()end
    if roomAudio then roomAudio.shutdown()end;voice.shutdown()
end)
local function say(text, interrupt)
    log(text)
    voice.speak(text, interrupt ~= false)
end
local charset = dofile(folder .. "magno-charset.lua")
-- Read-only diagnostic: identify the loaded map without moving the player.
do
    local function word(a) return memory.readbyte(a)+256*memory.readbyte(a+1) end
    local leader=word(0x7E0197)
    log(string.format("Ubicacion al recargar: mapa %04X (%d), lider %d, X %.2f, Y %.2f",
        word(0x7E0100),word(0x7E0100),leader,
        word(0x7E1800+leader)/16,word(0x7E1880+leader)/16))
end
local tickName = dofile(folder .. "name-reader.lua")(memory, say, log, charset)
local tickStatus, menuObserver = dofile(folder .. "status-reader.lua")(memory, say, log, charset)
local tickDialogue = dofile(folder .. "dialogue-reader.lua")(memory, say, log, charset, menuObserver)
local tickInventory = dofile(folder .. "inventory-reader.lua")(memory, say, log, menuObserver)
local tickTech = dofile(folder .. "tech-reader.lua")(memory, say, log, charset, menuObserver)
local tickConfig = dofile(folder .. "config-reader.lua")(memory, say, log)
local tickGroup = dofile(folder .. "group-reader.lua")(memory, say, log, menuObserver)
local tickSave = dofile(folder .. "save-reader.lua")(memory, say, log, charset, menuObserver)
local tickLoad = dofile(folder .. "load-reader.lua")(memory, say, log, menuObserver)
local tickShop = dofile(folder .. "shop-reader.lua")(memory, say, log, menuObserver)
local tickTreasure = dofile(folder .. "treasure-reader.lua")(memory, say, log, charset)
local tickBattle = dofile(folder .. "battle-reader.lua")(memory, say, log, charset, menuObserver)
local tickWorld,worldWalkingState = dofile(folder .. "world-reader.lua")(memory, say, log, charset, menuObserver.name,
    function()return input and input.get and input.get()or {}end)
local ok,roomResult=pcall(function()return dofile(folder.."rooms/reader.lua")(memory,folder,log,say,
    function()return input and input.get and input.get()or {}end)end)
if ok then roomAudio=roomResult else log("Audio del cuarto no disponible: "..tostring(roomResult)) end
challengeAssist=dofile(folder..'challenge-assist.lua')(memory,folder,say,log,roomAudio,menuObserver,
    joypad and joypad.set and function(buttons)joypad.set(1,buttons)end or nil)
if emu.registerbefore then emu.registerbefore(function()challengeAssist.before()end)end
walkTrace=dofile(folder..'walk-trace.lua')(memory,folder,say,log,menuObserver,roomAudio,
    function()return joypad and joypad.get and joypad.get(1)or {}end,worldWalkingState)
local bellCue=roomAudio and function(name)roomAudio.cue(name)end or nil
local bikeGame=dofile(folder..'bike-reader.lua')(memory,say,log,bellCue)
local bellGame=dofile(folder.."bell-reader.lua")(memory,folder,say,log,
    function()return input and input.get and input.get()or {}end,bellCue)
local raceGame=dofile(folder.."race-reader.lua")(memory,folder,say,log)
local sodaGame=dofile(folder.."soda-reader.lua")(memory,folder,say,log,bellCue)
local iokaGame=dofile(folder..'ioka-reader.lua')(memory,folder,say,log,bellCue)
local tickDance=dofile(folder..'dance-reader.lua')(memory,say,log)
local horrorsGame=dofile(folder..'horrors-reader.lua')(memory,folder,say,log,
    function()return input and input.get and input.get()or {}end,bellCue)
local tickGato=dofile(folder.."gato-reader.lua")(memory,say,log)
local tickInn=dofile(folder.."inn-reader.lua")(memory,say,log)
local tickEpoch=dofile(folder.."epoch-reader.lua")(memory,say,log)
local labels = {
    [0] = "Activo. Los enemigos pueden actuar mientras eliges tus comandos.",
    [1] = "Lento. Te dan tiempo para elegir objetos y preparar el ataque."
}
local observed = false
local selected = nil
local confirmed = false
local previous = nil
local inMenu = false
local missingFrames = 0

-- This instruction runs AFTER the game's input/cursor update, only in this menu.
-- Speech is deferred until the frame ends, outside the CPU execution callback.
memory.registerexec(0xC2E23C, 1, function()
    observed = true
    selected = memory.readbyte(0x7E0054)
    confirmed = memory.readbyte(0x7E0D1D) >= 0x80
end)

emu.registerafter(function()
    local pressed=input and input.get and input.get()or {}
    challengeAssist.tick(pressed)
    walkTrace.tick(pressed)
    if roomAudio and roomAudio.learnSounds(pressed)then return end
    bikeGame.tick(pressed)
    if bikeGame.active()then
        if roomAudio then roomAudio.tick()end
        return
    end
    if observed then
        missingFrames = 0
        if labels[selected] then
            if not inMenu then
                say("Modo de combate. " .. labels[selected])
            elseif selected ~= previous then
                say(labels[selected])
            end
            inMenu = true
            previous = selected
        elseif previous ~= selected then
            log("Valor de cursor inesperado: " .. tostring(selected))
            previous = selected
        end
        if confirmed then
            say("Modo de combate confirmado.")
            inMenu = false
            previous = nil
        end
    else
        missingFrames = missingFrames + 1
        if missingFrames > 3 then inMenu = false; previous = nil end
    end
    observed = false
    confirmed = false
    tickName()
    tickDialogue()
    tickStatus()
    tickInventory()
    tickTech()
    tickConfig()
    tickGroup()
    tickSave()
    tickLoad()
    tickShop()
    tickTreasure()
    tickBattle()
    tickWorld()
    tickEpoch()
    if roomAudio then roomAudio.tick() end
    bellGame.tick()
    raceGame.tick()
    sodaGame.tick()
    iokaGame.tick()
    tickGato()
    tickInn()
    tickDance()
    horrorsGame.tick()
end)
say("Pulsa Control F1 para aprender los sonidos.")
