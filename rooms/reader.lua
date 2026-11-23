return function(memory,folder,log,say,keys)
 local cfg=dofile(folder.."rooms/audio-config.lua")
 local model=dofile(folder.."rooms/model.lua")(memory)
 model.radius=cfg.radiusPixels
 local loader=assert(package.loadlib(folder.."runtime/chrono_audio.dll","luaopen_chrono_audio"))
 local audio=assert(loader())
 local sounds={"wall_left","wall_right","wall_up","wall_down","wall_hit","object_hit",
  "bed","clock","stairs","connection","person","door","item","sign","furniture","games","bell_timing","enemy","save_point"}
 local ids={};for i,name in ipairs(sounds) do ids[name]=i-1;audio.load(i-1,folder.."runtime/sounds/"..name..".wav") end
 audio.init()
 local fieldSeen=false
 memory.registerexec(0xC0881E,1,function()fieldSeen=true end)
 -- C236B6 is reached only when the overworld rejects a walking step.
 -- Observe that branch rather than treating a stationary player as a collision.
 local worldHit=nil
 local worldSignature={0xBD,0x28,0x00,0x29,0x7F,0x9D,0x28,0x00}
 local worldCompatible=true
 for i,v in ipairs(worldSignature)do
  if memory.readbyte(0xC236B6+i-1)~=v then worldCompatible=false end
 end
 if worldCompatible then memory.registerexec(0xC236B6,1,function()
  local location=memory.readbyte(0x7E0100)+256*memory.readbyte(0x7E0101)
  if (location==500 or location==501) and memory.readbyte(0x7E027C)==1 then
   local slot=memory.readbyte(0x7E004E)+256*memory.readbyte(0x7E004F)
   if slot<=0xFFD7 then
    local facing=memory.readbyte(0x7E0000+slot+0x28)%128
    worldHit={location=location,pan=facing==2 and -1 or facing==3 and 1 or 0}
   end
  end
 end)end
 local lastWorldHit=-1000
 local count,wasActive,lastX,lastY,lastHit,lastScan,nextScan=0,false,nil,nil,-1000,nil,0
 local lastRoom,activeRoom,lastProfile=nil,nil,nil
 local lastGuidance=nil
 local previousKeys,selected,selectionRoom={},nil,nil
 local switchRoom,switchStates=nil,{}
 local guideHeld=false
 local trackedRoom,trackedPositions,lastTrack=nil,{},-1000
 local quietChaseUntil=0
 local function notify(text,sound)
  if cfg.enabled then audio.set(21,ids[sound or "stairs"],cfg.volume,0,false) end
  if say then say(text,false) else log(text) end
 end
 local function gain(distance)
  if distance>cfg.radiusPixels then return 0 end
  local closeness=1-distance/cfg.radiusPixels
  return cfg.volume*(0.08+0.92*closeness^1.5)
 end
 local function update(s)
  lastScan=model.scan(s)
  audio.clear()
  for i,name in ipairs({"left","right","up","down"}) do
   local w=lastScan.walls[name]
   if w and w.kind=="wall" then audio.set(i-1,ids["wall_"..name],gain(w.distance)*0.6,w.pan,true) end
  end
  for i,obj in ipairs(lastScan.objects) do
   if i<=12 then
    local volume=gain(obj.distance)
    if obj.sound=="clock" then volume=volume*cfg.ambientVolume end
    if obj.sound=="furniture" then volume=volume*0.4 end
    audio.set(4+i,ids[obj.sound],volume,obj.pan,true)
   end
  end
 end
 return {
  fieldActive=function()return fieldSeen end,
  learnSounds=function(pressed)
   local held=pressed.control and not pressed.alt and not pressed.shift and pressed.F1 or false
   local open=held and not guideHeld;guideHeld=held
   if not open then return false end
   if not audio.guide then
    if say then say('La guía de sonidos necesita actualizar el módulo de audio.',false)end
    return true
   end
   local entries={}
   for _,entry in ipairs(dofile(folder..'sound-catalog.lua'))do
    entries[#entries+1]={id=assert(ids[entry.sound]),label=entry.label,
     volume=cfg.volume*(entry.ambient and cfg.ambientVolume or entry.gain or 1),pan=entry.pan or 0}
   end
   audio.clear();wasActive=false;activeRoom=nil;lastX,lastY=nil,nil
   audio.guide(entries)
   return true
  end,
  tick=function()
   count=count+1;local s=model.state();local field=fieldSeen;fieldSeen=false
   local now=audio.now()
   local notice,noticeSound=nil,nil
   local location=memory.readbyte(0x7E0100)+256*memory.readbyte(0x7E0101)
   local pressed=keys and keys()or {}
   local modifier=pressed.control and not pressed.alt and not pressed.shift
   local f5=modifier and pressed.F5 and not previousKeys.F5
   local f6=modifier and pressed.F6 and not previousKeys.F6
   previousKeys=pressed
   if s and switchRoom~=s.room then switchRoom=s.room;switchStates={}end
   if field and s and s.enabled then
    if trackedRoom~=s.room then trackedRoom=s.room;trackedPositions={};lastTrack=-1000 end
    if count>=quietChaseUntil and s.profile.trackActors and math.floor(memory.readbyte(0x7F00EC)/16)%2==1 then
     local nearest
     for _,obj in ipairs(model.references(s))do
      local slot=tonumber(obj.key:match('^person:(%d+)$'))
      if slot and s.profile.trackActors[slot] then
       local previous=trackedPositions[slot]
       trackedPositions[slot]={x=obj.x,y=obj.y}
       if previous and math.abs(obj.x-previous.x)+math.abs(obj.y-previous.y)>.1 and
        (not nearest or obj.distance<nearest.distance)then nearest=obj end
      end
     end
     if nearest and count-lastTrack>=90 then
      lastTrack=count
      if say then say('Rata en movimiento. '..model.relative(s,nearest),true)end
     end
    end
    if s.profile.hasSwitches then
     local current={}
     for _,obj in ipairs(model.references(s))do
      if obj.switchPressed~=nil then
       current[obj.key]=obj.switchPressed
       if switchStates[obj.key]~=nil and switchStates[obj.key]~=obj.switchPressed then
        notify(obj.name..'.','sign')
       end
      end
     end
     switchStates=current
    end
   end
   if field and s and s.enabled then
    if selectionRoom~=s.room then selected=nil;selectionRoom=s.room end
    if f5 or f6 then
     local refs=model.references(s);local index=1
     if not selected then
      for i,obj in ipairs(refs)do if obj.sound=='door' then index=i;break end end
     else for i,obj in ipairs(refs)do if obj.key==selected then index=i;break end end end
     if f6 and #refs>0 then index=index%#refs+1 end
     local obj=refs[index]
     if obj then
      selected=obj.key
      local text=s.profile.name..'. '..obj.name..'. '..model.relative(s,obj)
      if say then say(text,false)else log(text)end
     end
    end
   elseif field and s and s.controlled and (f5 or f6) then
    local text=f6 and 'Esta zona todavía no tiene referencias para recorrer. Los diálogos siguen activos.' or
     'Esta zona todavía no tiene referencias de orientación. Los diálogos siguen activos.'
    if say then say(text,false)else log(text)end
   end
   -- The world map does not execute the field-control hook; catch this verified exit.
   if lastProfile and lastRoom and (location==0x1F0 or location==0x1F1 or location==0x1F2 or location==0x1F3) then
    local house=lastProfile.house or "la casa de Crono"
    notice="Has salido "..(house:sub(1,3)=='el ' and 'del '..house:sub(4)or 'de '..house)..". Mapa exterior."
    noticeSound="door"
    lastRoom=false
   elseif location==254 and lastProfile and lastProfile.id=='truce_mayor_upper' then
    if lastRoom~='mayor_demo' then
     notice='Demostración de combate. El juego muestra ejemplos de ataques en área y en línea. Pulsa A para avanzar los textos; aquí no tienes que elegir un enemigo.'
     noticeSound='connection'
    end
    lastRoom='mayor_demo'
   elseif field and s and s.controlled then
    local guidance,guidanceSound=model.guidance(s)
    if s.room and (lastRoom~=s.room or guidance~=lastGuidance) then
     notice="Estás en "..(s.profile.article or (s.room=="bedroom" and "el " or "la "))..s.profile.name..". "..
      (cfg.enabled and "Orientación sonora disponible." or "Los sonidos de orientación están desactivados.")
     if s.room=="ground_floor" and cfg.enabled then notice=notice.." Salida al sur. Escaleras al noreste." end
     if guidance then notice=notice..' '..guidance..' Control F5: consultar referencia. Control F6: siguiente referencia.'end
     if guidanceSound then noticeSound=guidanceSound
     elseif lastRoom==s.room then noticeSound='connection'end
    elseif not s.room and lastRoom then
     local stairs=(lastRoom=='bedroom' or lastRoom=='ground_floor') and
      s.location==2 and s.x>=336 and s.x<=400 and s.y>=224 and s.y<256
     if stairs then
      notice=lastRoom=="bedroom" and "Bajando las escaleras del dormitorio." or "Subiendo las escaleras al dormitorio."
     else
      local article=lastProfile and (lastProfile.article or (lastRoom=='bedroom' and 'el ' or 'la ')) or 'la '
      local from=article=='el ' and 'del ' or 'de '..article
      local interior=lastProfile and lastProfile.house=='la casa de Lucca' and
       (s.location==3 or s.location==4 or s.location==9 or s.location==10)
      notice="Has salido "..from..(lastProfile and lastProfile.name or 'habitación')..'. '..
       (interior and 'Sigues dentro de la casa de Lucca. ' or '')..
       "Esta zona todavía no tiene orientación sonora. Los diálogos siguen activos."
      noticeSound="connection"
     end
    end
    lastRoom=s.room or false
    lastGuidance=guidance
    if s.profile then lastProfile=s.profile end
   end
   local hit=worldHit;worldHit=nil
   if not cfg.enabled or not field or not s or not s.enabled then
    if wasActive then audio.clear();log("Audio del cuarto suspendido") end
    if hit and cfg.enabled and count-lastWorldHit>24 and memory.readbyte(0x7E027C)==1
     and memory.readbyte(0x7E0100)+256*memory.readbyte(0x7E0101)==hit.location then
     audio.set(20,ids.wall_hit,cfg.volume,hit.pan,false);lastWorldHit=count
    end
    if notice then notify(notice,noticeSound) end
    wasActive=false;activeRoom=nil;lastX,lastY=nil,nil;return
   end
   if not wasActive or activeRoom~=s.room then
    log("Audio activo en "..s.profile.name..": proximidad a 4 casillas de 16 pixeles")
    lastX,lastY=nil,nil
    update(s);nextScan=now+1/cfg.updatesPerSecond
   elseif now>=nextScan then update(s);nextScan=now+1/cfg.updatesPerSecond end
   -- Cheap movement check each frame; the terrain scan stays at two updates/sec.
   if lastX and count-lastHit>24 and lastScan then
    local horizontal=s.dx~=0 and math.abs(s.x-lastX)<0.02
    local vertical=s.dy~=0 and math.abs(s.y-lastY)<0.02
    local dir=horizontal and (s.dx>=128 and "left" or "right") or vertical and (s.dy>=128 and "up" or "down")
    if dir then
     local w=model.contact(s,dir)
     if w and w.distance<=4 then
      audio.set(20,ids[w.kind=="object" and "object_hit" or "wall_hit"],cfg.volume,w.pan,false)
      lastHit=count
     end
    end
   end
   lastX,lastY=s.x,s.y;wasActive=true;activeRoom=s.room
   if notice then notify(notice,noticeSound) end
  end,
  quietChase=function(frames)quietChaseUntil=count+frames end,
  cue=function(name)if cfg.enabled and ids[name]then audio.set(22,ids[name],cfg.volume,0,false)end end,
  shutdown=function()audio.shutdown()end,
  model=model
 }
end
