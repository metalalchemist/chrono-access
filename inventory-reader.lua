-- Field inventory, including its native two-confirmation use/move interaction.
return function(memory,say,log,data)
    if not data then return function() end end
    local function b(a)return memory.readbyte(a)end
    local function w(a)return b(a)+256*b(a+1)end
    local checks={
        [0xC2AD4E]={0x28,0x60},[0xC2AA8F]={0x2C,0x1D,0x0D},
        [0xC2AACB]={0x2C,0x1D,0x0D},[0xC2AAA7]={0x8E,0x9C,0x0D},
        [0xC2AAFC]={0x99,0x00,0x25},[0xC2AAFF]={0x20,0x1E,0x82},
        [0xC2AA4D]={0x2C,0x1D,0x0D},[0xC2AB61]={0x60},
        [0xC2B1AE]={0x2C,0x1D,0x0D},[0xC2B231]={0x2C,0x1D,0x0D},
        [0xC2B31C]={0xA9,0x01},[0xC2B352]={0x60},
        [0xC2B1BA]={0x20,0xCC,0xEA},[0xC2B1C7]={0x50,0x03},
        [0xC2AEB4]={0x28,0x60},
    }
    for a,values in pairs(checks)do
        for i,v in ipairs(values)do if b(a+i-1)~=v then
            log("Menú de Objetos no disponible: firma incompatible.");return function()end
        end end
    end
    local row,seen,mode,event,used,swapped=nil,false,nil,nil,nil,false
    local function statTarget()
        local fields={[1]={0,"Fuerza"},[2]={2,"Velocidad"},[6]={3,"Poder mágico"}}
        local field=fields[b(0x7E0DBD)]
        local index=b(0x7E0DBE)
        local char=index<7 and b(0x7E0D5F+index) or 0xFF
        if not field or char>6 then return "" end
        return string.format(" %s actual %d.",field[2],b(0x7E2636+char*0x50+field[1]))
    end
    local function hook(a,fn)memory.registerexec(a,1,fn)end
    hook(0xC2AD4E,function()
        local index=w(0x7E0D26)
        if index<242 then row={index=index,id=b(0x7E2400+index),qty=b(0x7E2500+index)} end
    end)
    hook(0xC2AA8F,function()seen=true;mode="list"end)
    hook(0xC2AACB,function()seen=true;mode="move"end)
    hook(0xC2AAA7,function()
        local i=w(0x7E0D26)
        local id=b(0x7E2400+i)
        if id==0 then event="Casilla vacía seleccionada. Elige otra casilla para intercambiarla."
        elseif id<0xBC then
            event="Seleccionado: "..data.item(id)..
                ". Confirma otra vez para consultar quién puede equiparlo, o elige otra casilla para moverlo."
        elseif math.floor(b(0x7E7700+id)/2)%2==0 then
            event="Seleccionado: "..data.item(id)..
                ". No se puede usar desde este menú. Elige otra casilla para moverlo."
        else
            event="Seleccionado: "..data.item(id)..
                ". Confirma otra vez sobre el mismo objeto para usarlo, o elige otra casilla para moverlo."
        end
    end)
    hook(0xC2AAFC,function()swapped=true end)
    hook(0xC2AAFF,function()
        if swapped then
            local index=w(0x7E0D26)
            if index<242 then
                row={index=index,id=b(0x7E2400+index),qty=b(0x7E2500+index)}
                event="Objetos intercambiados. "..data.item(row.id)..". Cantidad "..row.qty.."."
            end
        else event="Movimiento de objeto cancelado."end
        swapped=false
    end)
    hook(0xC2AA4D,function()seen=true;mode="header"end)
    hook(0xC2AB61,function()event="Inventario ordenado."end)
    hook(0xC2B1AE,function()seen=true;mode="target"end)
    hook(0xC2B231,function()seen=true;mode="stat-target"end)
    hook(0xC2B31C,function()
        local index=w(0x7E0F00)
        if index<242 then used={index=index,id=b(0x7E2400+index)} end
    end)
    hook(0xC2B352,function()
        if used then
            event=string.format("Objeto usado: %s. Quedan %d. %s",data.item(used.id),
                b(0x7E2500+used.index),data.target())..statTarget();used=nil
        end
    end)
    hook(0xC2B1BA,function()event="El objeto no tiene efecto en este destino."end)
    hook(0xC2B1C7,function()event="Selección de destino cerrada."end)
    hook(0xC2AEB4,function()
        local id=b(0x7E04C9)
        local mask,joined=b(0x7E7A00+id),b(0x7E29AF)
        local names={}
        for i=0,6 do
            local flag=b(0xFFF9BB+i)
            if flag>0 and math.floor(mask/flag)%2==1 and math.floor(joined/flag)%2==1 then
                names[#names+1]=data.name(i)
            end
        end
        event=data.item(id)..". Pueden equiparlo: "..(#names>0 and table.concat(names,", ") or "ningún personaje disponible").."."
    end)
    local previous,spoken=nil,nil
    local epoch=data.menuEpoch
    return function()
        if epoch~=data.menuEpoch then previous=nil;spoken=nil;row=nil;epoch=data.menuEpoch end
        local text,desc,id,key
        if seen then
            if mode=="header" then
                local cursor=b(0x7E0054)
                text=cursor==11 and "Objetos. Ordenar inventario." or "Objetos. Lista de objetos."
            elseif mode=="target" or mode=="stat-target" then
                text="Destino. "..data.target()
                if mode=="stat-target" then text=text..statTarget()end
                if mode=="target" and b(0x7E0DBC)==0 then text=text.." No tiene efecto en este destino." end
            elseif row then
                id=row.id
                if id==0 then text="Casilla "..(row.index+1).." vacía."
                else
                    text=string.format("Objetos. %s. Cantidad %d. Casilla %d.",data.item(id),row.qty,row.index+1)
                    if id>=0xBC and math.floor(b(0x7E7700+id)/2)%2==0 then
                        text=text.." No se puede usar desde este menú."
                    end
                    desc=data.descriptions[id]
                end
            end
            key=((mode=="list" or mode=="move") and "list" or mode)..":"..(text or "")
            if mode=="target" or mode=="stat-target" then
                key=mode..":"..b(0x7E0DBE)..":"..math.floor(b(0x7E0DBD)/8)%2
            end
        end
        if event then
            say(event);event=nil
            if mode=="target" or mode=="stat-target" then
                previous=mode..":"..b(0x7E0DBE)..":"..math.floor(b(0x7E0DBD)/8)%2
            elseif mode=="header" then
                previous="header:"..(b(0x7E0054)==11 and "Objetos. Ordenar inventario." or "Objetos. Lista de objetos.")
            elseif key then previous=key end
        elseif text and key~=previous then
            say(text..(desc and (" "..desc) or ""));previous=key;spoken=desc and id or nil
        elseif id and data.descriptions[id] and spoken~=id then
            say(data.descriptions[id],false);spoken=id
        end
        seen=false
    end
end
