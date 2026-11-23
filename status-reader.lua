-- Magno 101%: observe the menu task, never infer selection from controller input.
return function(memory, say, log, charset)
    local function byte(a) return memory.readbyte(a) end
    local function word(a) return byte(a)+256*byte(a+1) end
    local function long(a) return word(a)+65536*byte(a+2) end
    local signatures={
        [0xC2A271]={0x28,0x60},
        [0xC29A23]={0x2C,0x1D,0x0D},
        [0xC29A98]={0xE2,0x20},
        [0xC29C42]={0x2C,0x1D,0x0D},
        [0xC29C79]={0x2C,0x1D,0x0D},
        [0xC29CB5]={0xE2,0x20},
        [0xC29CE1]={0x20,0xFC,0x9C},
        [0xC29CE4]={0x20,0xC2,0xEA},
        [0xC29C8D]={0x4C,0xCC,0xEA},
        [0xC2F308]={0x8D,0x0C,0x02},
        [0xC2FAE8]={0x60},
    }
    for address,values in pairs(signatures) do
        for i,value in ipairs(values) do
            if byte(address+i-1)~=value then
                log("Menú de estado no disponible: firma incompatible.")
                return function() end
            end
        end
    end
    local seen,detail=false,false
    local screen,state
    local capturePreview,preview,event,emptyAttempt
    memory.registerexec(0xC29A23,1,function() seen=true;screen=0;state=1 end)
    for address,s in pairs({[0xC29C42]=1,[0xC29C79]=2,[0xC29CB5]=3}) do
        local stage=s
        memory.registerexec(address,1,function()
            seen=true;screen=1;state=stage
            if stage==3 then preview=capturePreview() end
        end)
    end
    memory.registerexec(0xC2A271,1,function() detail=true end)
    local options={"Equipo y estado","Objetos","Técnicas","Configuración","Grupo","Guardar"}
    local slots={"Arma","Casco","Armadura","Accesorio"}
    local slotOffsets={0x29,0x27,0x28,0x2A}
    local function name(id)
        local result={}
        for i=0,5 do
            local c=byte(0x7E2C23+id*6+i)
            if c==0 or c==0xFF then break end
            result[#result+1]=charset.chars[c] or "?"
        end
        return table.concat(result)
    end
    local function item(id)
        if id==0 then return "ninguno" end
        local ptr=word(0x7E7D00+id*2)
        local result={}
        -- Eleven bytes: an icon and ten name glyphs; names have no terminator.
        for i=0,10 do
            local c=byte(0xCC0000+ptr+i)
            if c==0 then break end
            if charset.chars[c] then result[#result+1]=charset.chars[c] end
        end
        local text=table.concat(result):gsub("^%s+",""):gsub("%s+$","")
        return text~="" and text or ("objeto "..id)
    end
    local descriptions,techDescriptions={},{}
    local descriptionKind="item"
    local descriptionId,descriptionParts,descriptionCount=nil,{},0
    memory.registerexec(0xC2F308,1,function()
        descriptionKind="item"
        descriptionId=byte(0x7E0D77)
        descriptionParts={};descriptionCount=0
    end)
    memory.registerexec(0xC2FAE8,1,function()
        if not descriptionId then return end
        local text=table.concat(descriptionParts):gsub("%s+"," "):match("^%s*(.-)%s*$")
        if text~="" then
            local cache=descriptionKind=="tech" and techDescriptions or descriptions
            cache[descriptionId]=text
        end
        descriptionId=nil
    end)
    local observer={}
    function observer.menuContext()if seen then return screen,state end end
    observer.menuEpoch=0
    memory.registerexec(0xC29A98,1,function()observer.menuEpoch=observer.menuEpoch+1 end)
    observer.item=item;observer.name=name
    observer.descriptions=descriptions;observer.techDescriptions=techDescriptions
    function observer.beginTech(id)
        descriptionKind="tech";descriptionId=id;descriptionParts={};descriptionCount=0
    end
    function observer.character(id)
        if id<0 or id>6 then return nil end
        local a=0x7E2600+id*0x50
        return string.format("%s. Vida %d de %d. Magia %d de %d.",name(id),
            word(a+3),word(a+0x3F),word(a+7),word(a+9))
    end
    function observer.target()
        local all=math.floor(byte(0x7E0DBD)/8)%2==1
        local first,last=byte(0x7E0DBE),byte(0x7E0DBE)
        if all then first=0;last=math.min(byte(0x7E0073),7)-1 end
        local targets={}
        for i=first,last do
            if i<7 then
                local text=observer.character(byte(0x7E0D5F+i))
                if text then targets[#targets+1]=text end
            end
        end
        return (all and "Todo el grupo. " or "")..table.concat(targets," ")
    end
    local function descriptionText()
        return descriptionId and byte(0x7E0212)==0x7E and
            word(0x7E0210)>=0x5E00 and word(0x7E0210)<0x6200
    end
    function observer.glyph(code)
        if observer.saveGlyph then observer.saveGlyph(code)end
        if observer.battleGlyph then observer.battleGlyph(code)end
        if not descriptionText() or descriptionCount>=4096 then return end
        local char=charset.chars[code]
        if not char then
            log("Carácter de descripción sin identificar: "..string.format("%03X",code))
            char=" [símbolo "..string.format("%03X",code).."] "
        end
        descriptionParts[#descriptionParts+1]=char;descriptionCount=descriptionCount+1
    end
    function observer.control(code)
        if observer.saveControl then observer.saveControl(code)end
        if observer.battleControl then observer.battleControl(code)end
        if descriptionText() and (code==5 or code==6) then descriptionParts[#descriptionParts+1]=" " end
    end
    local fields={{7,"Ataque"},{8,"Defensa"},{0,"Fuerza"},{2,"Velocidad"},
        {4,"Puntería"},{5,"Evasión"},{3,"Poder mágico"},{1,"Vitalidad"},{6,"Defensa mágica"}}
    capturePreview=function()
        local index=byte(0x7E0FC8)-4+byte(0x7E0054)
        local total=byte(0x7E0FC6)
        if index<0 or index>=total then return nil end
        local id=byte(0x7E04C9)
        if id==0 or id~=byte(0x7E0F00+index) then return nil end
        local changes={}
        for _,field in ipairs(fields) do
            local old,new=byte(0x7E9AC6+field[1]),byte(0x7E9B1C+field[1])
            if old~=new then
                changes[#changes+1]=string.format("%s de %d a %d; %s %d.",
                    field[2],old,new,new>old and "sube" or "baja",math.abs(new-old))
            end
        end
        local oldHP,newHP=word(0x7E9ACF),word(0x7E9B25)
        if oldHP~=newHP then
            changes[#changes+1]=string.format("Vida de %d a %d; %s %d.",
                oldHP,newHP,newHP>oldHP and "sube" or "baja",math.abs(newHP-oldHP))
        end
        local comparison=#changes>0 and table.concat(changes," ") or "Sin cambios en las estadísticas."
        local text=string.format("%s. %d de %d. Cantidad %d. %s",item(id),index+1,total,
            byte(0x7E0F62+index),comparison)
        return {id=id,key=byte(0x7E9A90)..":"..byte(0x7E0077)..":"..text,text=text}
    end
    memory.registerexec(0xC29CE1,1,function()
        local slot=byte(0x7E0077)
        if slots[slot+1] then
            event="Equipo cambiado. "..slots[slot+1]..": "..
                item(byte(0x7E0000+word(0x7E006F)+slotOffsets[slot+1])).."."
        end
    end)
    memory.registerexec(0xC29CE4,1,function() if not event then event="Cambio de equipo cancelado." end end)
    memory.registerexec(0xC29C8D,1,function() emptyAttempt=true end)
    local function summary()
        local a=0x7E9A90
        local id=byte(a)
        if id>6 then return nil end
        local b=a+0x36 -- equipment-adjusted values committed by C29137
        local h=byte(0x7E0405)*10+byte(0x7E0404)
        local m=byte(0x7E0403)*10+byte(0x7E0402)
        return string.format(
            "%s. Nivel %d. Vida %d de %d. Magia %d de %d. Ataque %d. Defensa %d. "..
            "Fuerza %d. Velocidad %d. Puntería %d. Evasión %d. Poder mágico %d. Vitalidad %d. Defensa mágica %d. "..
            "Experiencia %d. Para el siguiente nivel %d. Arma: %s. Casco: %s. Armadura: %s. Accesorio: %s. "..
            "Dinero %d G. Tiempo %d horas y %d minutos.",
            name(id),byte(a+0x12),word(a+3),word(a+5),word(a+7),word(a+9),
            byte(b+7),byte(b+8),byte(b),byte(b+2),byte(b+4),byte(b+5),byte(b+3),byte(b+1),byte(b+6),
            long(a+0x13),word(a+0x2B),item(byte(a+0x29)),item(byte(a+0x27)),
            item(byte(a+0x28)),item(byte(a+0x2A)),long(0x7E2C53),h,m)
    end
    local previous,previousStats,previousSlot=nil,nil,nil
    local previousPreview,spokenDescription=nil,nil
    local missing=0
    return function()
        if event then say(event);event=nil;previousStats=nil;previousPreview=nil end
        if emptyAttempt then say("No hay piezas disponibles para esta ranura.");emptyAttempt=false end
        if seen then
            missing=0
            if screen==0 and state==1 then
                local choice=byte(0x7E0411)
                if previous~=choice then
                    say("Menú principal. "..(options[choice+1] or "Opción desconocida")..".")
                    previous=choice;previousStats=nil
                end
            elseif screen~=0 then previous=nil end
            -- Detail is also redrawn on the main menu's equipment preview.
            if (detail or previousStats==nil) and ((screen==1 and state~=3) or (screen==0 and byte(0x7E0411)==0)) then
                local text=summary()
                if text and text~=previousStats then say(text,false);previousStats=text end
            end
            if screen==1 and state==2 then
                local slot=byte(0x7E0077)
                local key=byte(0x7E9A90)..":"..slot
                if key~=previousSlot and slots[slot+1] then
                    say(slots[slot+1]..": "..item(byte(0x7E9A90+slotOffsets[slot+1]))..".")
                    previousSlot=key
                end
            else previousSlot=nil end
            if screen==1 and state==3 and preview then
                if previousPreview~=preview.key then
                    local desc=descriptions[preview.id]
                    say(preview.text..(desc and (" "..desc) or ""))
                    previousPreview=preview.key;spokenDescription=desc and preview.id or nil
                elseif descriptions[preview.id] and spokenDescription~=preview.id then
                    say(descriptions[preview.id],false);spokenDescription=preview.id
                end
            else previousPreview=nil;spokenDescription=nil end
        else
            missing=missing+1
            if missing>3 then previous=nil;previousStats=nil;previousSlot=nil;previousPreview=nil;spokenDescription=nil end
        end
        seen=false;detail=false;preview=nil
    end,observer
end
