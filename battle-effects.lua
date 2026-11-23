-- C15B72 runs once per displayed target, before the floating digits are built.
-- Status names below follow the consumers in C1B0DD/C1BD6F/C1E63B.
return function(memory,model,emit)
    local function b(a)return memory.readbyte(a)end
    local function w(a)return b(a)+256*b(a+1)end
    local function target(slot)return slot<3 and model.party(slot)or model.enemy(slot)end
    local statuses={
        {0x1E,0x80,"Paro"},{0x1E,0x40,"Veneno"},{0x1E,0x20,"Lentitud"},
        {0x1E,0x10,"Pérdida gradual de vida"},{0x1E,0x08,"Silencio"},
        {0x1E,0x04,"Confusión"},{0x1E,0x02,"Sueño"},{0x1E,0x01,"Ceguera"},
        {0x20,0x80,"Prisa",true},{0x20,0x40,"Evasión doble",true},
        {0x21,0x40,"Barrera mágica",true},{0x21,0x04,"Protección física",true},
        {0x21,0x20,"Regeneración de magia",true},
    }
    local previous={}
    local function has(value,mask)return math.floor(value/mask)%2==1 end
    local function reset()previous={}end
    local function floating()
        local offset=w(0x7E0080)
        local pass=b(0x7EA3D3)
        if pass>7 then return end
        local slot=(offset-b(0xCCF829+pass))/4
        if slot<0 or slot>10 or slot~=math.floor(slot)then return end
        local p=target(slot)
        if not p then return end
        local kind=b(0x7EAD9E+offset)
        local value=w(0x7EAD9C+offset)
        local label=({"recupera %d de vida","recupera %d de magia",
            "recibe %d de daño","pierde %d de magia"})[kind]
        if label then emit(p.name..". "..string.format(label,value)..".")
        elseif kind==5 then emit(p.name..". Fallo.")end
    end
    local function tick()
        for slot=0,10 do
            local p=target(slot)
            if p and p.hp>0 and (slot<3 or p.alive)then
                local current={id=p.id}
                local old=previous[slot]
                for i,s in ipairs(statuses)do
                    local a=0x7E5E2D+slot*128+s[1]
                    current[i]=has(b(a),s[2])or (s[4]and has(b(a+5),s[2]))or false
                    if current[i]and (not old or old.id~=p.id or not old[i])then
                        emit(p.name..". Estado: "..s[3]..".")
                    elseif not current[i]and old and old.id==p.id and old[i]then
                        emit(p.name..". Termina: "..s[3]..".")
                    end
                end
                previous[slot]=current
            else previous[slot]=nil end
        end
    end
    return {reset=reset,floating=floating,tick=tick}
end
