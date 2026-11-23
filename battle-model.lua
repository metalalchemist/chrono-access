-- Verified C1 battle-menu structures for the Magno 101% ROM.
return function(memory,charset,name)
    local m={}
    local function b(a)return memory.readbyte(a)end
    local function w(a)return b(a)+256*b(a+1)end
    local function text(a)
        local t={}
        for i=0,10 do
            local c=b(a+i)
            if c==0 then break end
            if charset.chars[c]then t[#t+1]=charset.chars[c]end
        end
        return table.concat(t):match("^%s*(.-)%s*$")
    end
    function m.tech(id)return text(0xCC15C4+id*11)end
    function m.item(id)return text(0xCC0B5E+id*11)end
    function m.party(slot)
        if slot<0 or slot>2 then return nil end
        local id=b(0x7EAEFF+slot)
        if id>6 then return nil end
        local a=0x7E5E2D+slot*128
        return {slot=slot,id=id,name=name(id),hp=w(a+3),maxhp=w(a+5),mp=w(a+7),maxmp=w(a+9)}
    end
    function m.enemy(slot)
        if slot<3 or slot>10 then return nil end
        local id=b(0x7E984D+slot*2)
        local label=text(0xCC6500+id*11)
        -- Boss HP visibility does not hide their identity.
        if label=="" then label="Enemigo"end
        local a=0x7E5E2D+slot*128
        return {slot=slot,id=id,name=label.." "..(slot-2),hp=w(a+3),maxhp=w(a+5),
            alive=b(0x7EAF02+slot-3)~=0xFF and math.floor(b(0x7EAF15+slot-3)/64)%2==0}
    end
    function m.targets()
        local result,seen={},{}
        local multi=b(0x7EA62E)<0x80 or b(0x7E960C)>=0x80
        for i=0,multi and 10 or 0 do
            local slot=b(0x7EA62D+i)
            if slot<=10 and not seen[slot]then
                local target=slot<3 and m.party(slot)or m.enemy(slot)
                if target then result[#result+1]=target;seen[slot]=true end
            end
        end
        return result
    end
    function m.targetText(target)
        if target.slot<3 then
            return string.format("%s. Vida %d de %d.",target.name,target.hp,target.maxhp)
        end
        -- Match the game's SightScope gate; do not reveal normally hidden enemy HP.
        if b(0x7E9F34)~=0 and b(0x7E9F29+target.slot)~=0 and b(0xE1DE80+target.id)==0 then
            return string.format("%s. Vida %d de %d.",target.name,target.hp,target.maxhp)
        end
        return target.name.."."
    end
    function m.read()
        local slot=b(0x7E95D5)
        local actor=m.party(slot)
        if not actor then return nil end
        local s={actor=actor,slot=slot}
        if b(0x7E9609)~=0 then
            s.kind="target";s.targets=m.targets()
            local parts,ids={},{}
            for _,target in ipairs(s.targets)do
                parts[#parts+1]=m.targetText(target);ids[#ids+1]=target.slot
            end
            s.key="target:"..slot..":"..table.concat(ids,",")..":"..b(0x7E95DB)..":"..b(0x7E9EE3)
            s.text="Objetivo"..(#parts>1 and "s"or "")..". "..table.concat(parts," ")
        elseif b(0x7E95DB)==1 then
            s.kind="tech";s.id=b(0x7E9EE3)
            local index=b(0x7E95DF+slot)+b(0x7E95EB+slot)
            if s.id==0 or s.id>=0x80 then
                if b(0x7EA02A+slot)>0 then return nil end
                s.text="No hay técnicas disponibles."
            else
                -- FC/FD are the visible, nonselectable double/triple headers.
                local category="individuales"
                local base=b(0xCCF38C+slot)
                for row=0,math.min(index,19)do
                    local code=b(0x7E94D0+base+row)
                    if code==0xFC then category="dobles"
                    elseif code==0xFD then category="triples"end
                end
                local parts={"Técnicas "..category..". "..m.tech(s.id)..". Fila "..(index+1).."."}
                -- C10F7E compares these fields to slots 0/1/2, irrespective of
                -- whose menu is open. High-bit values mean no cost field.
                for participant,cost in ipairs({b(0x7E9EE6),b(0x7E9EE8),b(0x7E9EE9)})do
                    local p=m.party(participant-1)
                    if p and cost<0x80 then
                        parts[#parts+1]=string.format("%s: coste %d de magia, disponible %d.",p.name,cost,p.mp)
                    end
                end
                if b(0x7E9EE5)>=0x80 then parts[#parts+1]="No disponible ahora."end
                s.text=table.concat(parts," ")
            end
            s.key="tech:"..slot..":"..index..":"..s.id..":"..s.text
        elseif b(0x7E95DB)==2 then
            s.kind="item"
            local index=b(0x7E95E5)+b(0x7E95E6)
            local a=0x7E1580+index*5
            s.id=b(a)
            if s.id==0 then return nil end
            if index>=242 or s.id==0xFF then s.text="No hay objetos disponibles."
            else
                s.text=string.format("%s. Cantidad %d. Fila %d.",m.item(s.id),b(a+3),index+1)
                if b(a+2)>=0x80 or b(a+3)==0 then s.text=s.text.." No disponible ahora."end
            end
            s.key="item:"..slot..":"..index..":"..s.text
        else
            s.kind="commands"
            local choice=b(0x7E95DC+slot)
            s.text=({"Atacar.","Técnicas.","Objetos."})[choice+1]or "Comando desconocido."
            s.key="commands:"..slot..":"..choice
        end
        return s
    end
    return m
end
