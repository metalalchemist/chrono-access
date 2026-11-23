-- Menu techniques only. Combat input and battle targets are separate systems.
return function(memory,say,log,charset,data)
    if not data then return function()end end
    local function b(a)return memory.readbyte(a)end
    local function w(a)return b(a)+256*b(a+1)end
    local checks={
        [0xC2B567]={0x60},[0xC2B72D]={0x28,0x60},
        [0xC2BC57]={0x28,0x60},[0xC2BE51]={0x8D,0x0C,0x02},
        [0xC2B38F]={0x4C,0xCC,0xEA},[0xC2B3EF]={0x4C,0xCC,0xEA},
        [0xC2B406]={0x4C,0xCC,0xEA},[0xC2B437]={0x4C,0xCC,0xEA},
        [0xC2B494]={0x2C,0x1D,0x0D},[0xC2B49C]={0x20,0xC2,0xEA},
        [0xC2B4E3]={0x4C,0xCC,0xEA},[0xC2B516]={0x4C,0x79,0xBE},
    }
    for a,values in pairs(checks)do
        for i,v in ipairs(values)do if b(a+i-1)~=v then
            log("Menú de Técnicas no disponible: firma incompatible.");return function()end
        end end
    end
    local function hook(a,fn)memory.registerexec(a,1,fn)end
    local function techName(id)
        local parts={}
        for i=0,10 do
            local code=b(0xCC15C4+id*11+i)
            if code==0 then break end
            if charset.chars[code]then parts[#parts+1]=charset.chars[code]end
        end
        local text=table.concat(parts):match("^%s*(.-)%s*$")
        return text~="" and text or ("Técnica "..id)
    end
    local costs={}
    hook(0xC2BC57,function()
        local id,char=b(0x7E0F4C),b(0x7E9A90)
        if id<0x80 and char<7 then
            costs[id]=costs[id] or {};costs[id][char]=b(0x7E9890)
        end
    end)
    hook(0xC2BE51,function()data.beginTech(b(0x7E0D77))end)
    local seen,mode,row,event=false,nil,nil,nil
    local tabs={"Individuales","Dobles","Triples"}
    local function caster()
        local index=b(0x7E0419)+b(0x7E041A)
        if index>=7 then return nil end
        local id=b(0x7E0D5F+index)
        if id<7 then return id end
    end
    hook(0xC2B567,function()seen=true;mode="tabs"end)
    hook(0xC2B72D,function()
        seen=true;mode="list"
        local index=b(0x7E0F48)+b(0x7E0F4A)
        local total=b(0x7E0F49)
        local id=b(0x7E0F00+index)
        if index>=total or id>=0x80 then row=nil;return end
        local char=caster()
        if not char then row=nil;return end
        local participants={char}
        if b(0x7E0418)>0 then
            local mask=b(0xCC2963+b(0x7E0F30+index))
            for i=0,6 do
                local flag=b(0xFFF9BB+i)
                if i~=char and flag>0 and math.floor(mask/flag)%2==1 then participants[#participants+1]=i end
            end
        end
        local info={}
        local enough=true
        for _,participant in ipairs(participants)do
            local cost=costs[id] and costs[id][participant]
            local mp=w(0x7E2607+participant*0x50)
            if cost then
                info[#info+1]=string.format("%s: coste %d de magia, disponible %d.",data.name(participant),cost,mp)
                if mp<cost then enough=false end
            else info[#info+1]=data.name(participant)..": coste no disponible." end
        end
        local flags=b(0x7E7700+id)
        local unlearned=b(0x7E0418)==0 and math.floor(flags/64)%2==1
        local usable=math.floor(flags/128)%2==1
        local availability=usable and "Se puede usar desde este menú." or "Solo en combate."
        if unlearned then
            availability="Todavía no aprendida. Faltan "..w(0x7E262D+char*0x50).." puntos de técnica."
        end
        local text=string.format("%s. %d de %d. %s %s",techName(id),index+1,total,
            table.concat(info," "),availability)
        if not enough then text=text.." Magia insuficiente." end
        row={id=id,text=text}
    end)
    hook(0xC2B494,function()seen=true;mode="target"end)
    hook(0xC2B49C,function()event="Selección de técnica cancelada."end)
    hook(0xC2B38F,function()event="No hay técnicas en esta categoría."end)
    hook(0xC2B3EF,function()event="Este personaje está fuera del grupo activo."end)
    hook(0xC2B406,function()
        local flags=b(0x7E7700+b(0x7E0F4C))
        event=math.floor(flags/64)%2==1 and "Todavía no has aprendido esta técnica." or
            "Esta técnica solo se puede usar en combate."
    end)
    hook(0xC2B437,function()event="Magia insuficiente para usar esta técnica."end)
    hook(0xC2B4E3,function()event="No se puede aplicar la técnica a este destino."end)
    hook(0xC2B516,function()
        local index=b(0x7E0F4D)
        local char=index<7 and b(0x7E0D5F+index) or 0xFF
        if char<7 then
            event=string.format("Técnica usada: %s. %s tiene %d de magia. %s",
                techName(b(0x7E0F4C)),data.name(char),w(0x7E2607+char*0x50),data.target())
        end
    end)
    local previous,spoken=nil,nil
    local epoch=data.menuEpoch
    return function()
        if epoch~=data.menuEpoch then previous=nil;spoken=nil;row=nil;epoch=data.menuEpoch end
        local text,id,desc,key
        if seen then
            if mode=="tabs" then
                local char=caster()
                text="Técnicas. "..(tabs[b(0x7E0418)+1] or "Categoría desconocida")..". "..
                    (char and data.name(char)..". " or "")..b(0x7E0F49)..
                    (b(0x7E0F49)==1 and " técnica." or " técnicas.")
            elseif mode=="target" then
                text="Destino de técnica. "..data.target()
                if b(0x7E0DBC)==0 then text=text.." No se puede aplicar aquí."end
            elseif row then text=row.text;id=row.id;desc=data.techDescriptions[id]end
            key=text
            if mode=="target" then key="target:"..b(0x7E0DBE)..":"..math.floor(b(0x7E0DBD)/8)%2 end
        end
        if event then
            say(event);event=nil
            if mode=="target" then
                previous="target:"..b(0x7E0DBE)..":"..math.floor(b(0x7E0DBD)/8)%2
            elseif key then previous=key end
        elseif text and key~=previous then
            say(text..(desc and (" "..desc)or ""));previous=key;spoken=desc and id or nil
        elseif id and data.techDescriptions[id] and spoken~=id then
            say(data.techDescriptions[id],false);spoken=id
        end
        seen=false
    end
end
