-- Capture resolved glyphs, including dictionary expansions and character names.
-- CPU hooks only collect events. Speech runs at the end of the frame.
return function(memory, say, log, charset, menuObserver)
    local checks = {
        {0xC02121, {0x22,0x03,0x00,0xC2,0x60}}, -- field dialogue render request
        {0xC25DC4, {0xC2,0x20,0xA5,0x35,0x0A,0x0A,0x0A}}, -- final glyph
        {0xC25950, {0x85,0x15,0x60}}, -- control-code state
        {0xC021D8, {0xA9,0x07,0x85,0x29,0xA9,0x81,0x85,0x36,0x60}}
    }
    for _, check in ipairs(checks) do
        for i,value in ipairs(check[2]) do
            assert(memory.readbyte(check[1]+i-1)==value,
                "La rutina de diálogo no coincide con la ROM soportada")
        end
    end
    local active, parts, ready, count = false, {}, {}, 0
    local choiceLines,previousChoice={},nil
    local unknown, reported = {}, {}
    local function word(address)
        return memory.readbyte(address)+256*memory.readbyte(address+1)
    end
    local function fieldText()
        return active and memory.readbyte(0x7E0214)==0 and
            memory.readbyte(0x7E0212)==0x7E and word(0x7E0210)>=0xF000
    end
    local function flush()
        local text=table.concat(parts):gsub("%s+", " "):match("^%s*(.-)%s*$")
        if text~="" then ready[#ready+1]=text end
        parts, count = {}, 0
    end
    memory.registerexec(0xC02121,1,function()
        flush()
        choiceLines={};previousChoice=nil
        active=true
    end)
    memory.registerexec(0xC020B2,1,function()
        -- Native renderer clears its line buffer when advancing or paging.
        if active then choiceLines[memory.readbyte(0x7E0131)]={} end
    end)
    memory.registerexec(0xC25DC4,1,function()
        if menuObserver then menuObserver.glyph(word(0x7E0235)) end
        if not fieldText() then return end
        local code=word(0x7E0235)
        local char=charset.chars[code]
        if not char then
            if not reported[code] then unknown[code]=true; reported[code]=true end
            char=" [símbolo "..string.format("%03X",code).."] "
        end
        if count<4096 then
            parts[#parts+1]=char; count=count+1
            -- $0131 is the native field-dialogue line (0..3).
            local line=memory.readbyte(0x7E0131)
            if line<=3 then
                choiceLines[line]=choiceLines[line]or {}
                choiceLines[line][#choiceLines[line]+1]=char
            end
        end
    end)
    memory.registerexec(0xC25950,1,function()
        if menuObserver then menuObserver.control(memory.getregister("a")%256) end
        if not fieldText() then return end
        local code=memory.getregister("a")%256
        if code==5 or code==6 then parts[#parts+1]=" "
        elseif code==0 or code==3 or (code>=7 and code<=12) then flush() end
    end)
    -- Also covers an automatic newline reaching the last line of the box.
    memory.registerexec(0xC021D8,1,function() if active then flush() end end)
    return function()
        if active and memory.readbyte(0x7E0129)==0 then flush(); active=false end
        if #ready>0 then
            say(table.concat(ready,"\n"),false)
            ready={}
        end
        -- Decision boxes expose their real selected line in $0163, with
        -- inclusive bounds $0164/$0165. Never infer a choice from buttons.
        if fieldText() and memory.readbyte(0x7E0162)==2 then
            local selected=memory.readbyte(0x7E0163)
            local first,last=memory.readbyte(0x7E0164),memory.readbyte(0x7E0165)
            if first<=selected and selected<=last and last<=3 and choiceLines[selected] then
                local text=table.concat(choiceLines[selected]):gsub('%s+',' '):match('^%s*(.-)%s*$')
                if text~='' and selected~=previousChoice then
                    say('Opción seleccionada: '..text..(text:match('[.!?]$')and ''or '.'),previousChoice~=nil)
                    previousChoice=selected
                end
            end
        else previousChoice=nil end
        for code in pairs(unknown) do
            log("Carácter de diálogo sin identificar: "..string.format("%03X",code))
            unknown[code]=nil
        end
    end
end
