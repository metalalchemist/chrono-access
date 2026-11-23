-- C1 CPU hooks observe battle state. All speech is deferred to the frame callback.
return function(memory,say,log,charset,data)
    if not data then return function()end end
    local function b(a)return memory.readbyte(a)end
    local function w(a)return b(a)+256*b(a+1)end
    local checks={
        [0xC10000]={0x4C,0x1B,0x00},[0xC11153]={0x22,0xE2,0xFA,0xCF},
        [0xC11713]={0xEE,0xD8,0x99},[0xC1103D]={0x60},[0xC183BB]={0xC2,0x20},
        [0xC1813F]={0x8F,0xEC,0x01,0x7F},[0xC018AB]={0x20,0x64,0x0B},
        [0xCD0261]={0x9C,0xED,0xCC},[0xC25AEA]={0x69,0x00,0x65},
        [0xC15B72]={0xBD,0x9E,0xAD},
        [0xC10EB7]={0x4C,0x3D,0x10},
    }
    for a,values in pairs(checks)do
        for i,v in ipairs(values)do if b(a+i-1)~=v then
            log("Lector de combate no disponible: firma incompatible.");return function()end
        end end
    end
    local folder=assert(debug.getinfo(1,"S").source:sub(2):match("^(.*[/\\])"))
    local model=dofile(folder.."battle-model.lua")(memory,charset,data.name)
    local active,observed,intro,result,ready=false,false,false,false,false
    local previous,cachedRow,lastParty,lastEnemy=nil,nil,{},{}
    local events,messages={},{}
    local effects=dofile(folder.."battle-effects.lua")(memory,model,function(text)
        events[#events+1]=text
    end)
    local parts,count,capturing={},0,false
    local function begin()
        active=true;intro=true;result=false;ready=false;observed=false;previous=nil;cachedRow=nil
        lastParty={};lastEnemy={};parts={};count=0;capturing=false
        effects.reset()
    end
    local function hook(a,fn)memory.registerexec(a,1,fn)end
    hook(0xC10000,begin)
    hook(0xC15B72,function()if active and not result then effects.floating()end end)
    hook(0xC11153,function()if not active then begin()end;observed=true;ready=true end)
    hook(0xC1103D,function()
        if not active then return end
        local state=model.read()
        if state and state.kind=="item"then cachedRow=state end
    end)
    -- The shared C1103D return also runs before the selected tech is updated.
    -- Sample only after C10C83 has finished copying the row and its MP costs.
    hook(0xC10EB7,function()
        if not active then return end
        local state=model.read()
        if state and state.kind=="tech"then cachedRow=state end
    end)
    hook(0xC11713,function()
        local actor=model.party(b(0x7E95D5))
        if actor then
            local a=0x7E93EE+actor.slot*7
            local flags=b(a+1)
            local what="Atacar"
            if math.floor(flags/128)%2==0 then
                if math.floor(flags/64)%2==1 then what=model.item(b(a+6))
                elseif math.floor(flags/32)%2==1 then what=model.tech(b(a+6))end
            end
            events[#events+1]=actor.name..". Acción preparada: "..what.."."
        end
    end)
    hook(0xC183BB,function()
        if active and not result then events[#events+1]="Victoria.";result=true end
    end)
    hook(0xC1813F,function()
        if active and not result then events[#events+1]="Derrota.";result=true end
    end)
    hook(0xC018AB,function()
        if active then events[#events+1]="Fin del combate."end
        active=false;previous=nil;cachedRow=nil;capturing=false
    end)
    hook(0xCD0261,function()
        parts={};count=0
        local id=b(0x7E020C)
        capturing=active and not (w(0x7E020D)==0xCBC9 and (id==11 or id==12))
    end)
    local function battleText()
        return capturing and b(0x7E0212)==0x7E and w(0x7E0210)>=0xB400 and w(0x7E0210)<0xC000
    end
    data.battleGlyph=function(code)
        if not battleText()or count>=4096 then return end
        local char=charset.chars[code]
        if not char then
            char=" [símbolo "..string.format("%03X",code).."] "
            log("Carácter de combate sin identificar: "..string.format("%03X",code))
        end
        parts[#parts+1]=char;count=count+1
    end
    data.battleControl=function(code)
        if not battleText()then return end
        if code==5 or code==6 then parts[#parts+1]=" "
        elseif code==0 or code==3 or (code>=7 and code<=12)then
            local text=table.concat(parts):gsub("%s+"," "):match("^%s*(.-)%s*$")
            if text~=""then messages[#messages+1]=text end
            parts={};count=0
        end
    end
    return function()
        local health={}
        if active and ready and not result then effects.tick()end
        if active and not result and observed then
            for slot=0,2 do
                local p=model.party(slot)
                local old=lastParty[slot]
                if p then
                    if old and old.id==p.id then
                        if p.hp~=old.hp then
                            health[#health+1]=p.hp==0 and p.name.." fuera de combate."or
                                string.format("%s. Vida %d de %d.",p.name,p.hp,p.maxhp)
                        end
                        if p.mp~=old.mp then health[#health+1]=p.name..". Magia "..p.mp.."."end
                    end
                    lastParty[slot]=p
                end
            end
            for slot=3,10 do
                local e=model.enemy(slot)
                local old=lastEnemy[slot]
                if old and old.alive and old.hp>0 and (e.hp==0 or not e.alive)then
                    health[#health+1]=old.name.." fuera de combate."
                end
                lastEnemy[slot]=e
            end
            local state=model.read()
            if b(0x7E9609)==0 and (b(0x7E95DB)==1 or b(0x7E95DB)==2)then
                local kind=b(0x7E95DB)==1 and "tech"or "item"
                state=cachedRow and cachedRow.slot==b(0x7E95D5)and cachedRow.kind==kind and cachedRow or nil
            end
            if state then
                if state.key~=previous then
                    local p=state.actor
                    local prefix=""
                    if intro then
                        local enemies={}
                        for slot=3,10 do
                            local e=lastEnemy[slot]
                            if e.alive and e.hp>0 then enemies[#enemies+1]=e.name end
                        end
                        prefix="Combate. "..(#enemies>0 and "Enemigos: "..table.concat(enemies,", ")..". "or "")
                        intro=false
                    end
                    if state.kind=="commands"then
                        state.text=string.format("Turno de %s. %s Vida %d de %d. Magia %d de %d.",
                            p.name,state.text,p.hp,p.maxhp,p.mp,p.maxmp)
                    end
                    if #events>0 then prefix=table.concat(events," ").." "..prefix;events={}end
                    say(prefix..state.text);previous=state.key
                end
            else previous=nil end
        end
        if #events>0 then say(table.concat(events," "),false);events={}end
        if #messages>0 then say(table.concat(messages," "),false);messages={}end
        if #health>0 then say(table.concat(health," "),false)end
        observed=false
    end
end
