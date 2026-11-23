-- Naming screen adapter for the verified Magno ROM. UTF-8 output for Prism.
return function(memory, say, log, charset)
    local expected = {0x20,0x84,0xE9,0x20,0x67,0xE2,0xAD,0xF0,0x00,
        0x29,0x01,0xD0,0x01,0x60,0x20,0x63,0xE3,0x09,0x00,0xD0,0xF8,0x4C,0xB2,0x82}
    for i, value in ipairs(expected) do
        assert(memory.readbyte(0xC2E21E + i - 1) == value,
            "La rutina del nombre no coincide con la ROM soportada")
    end
    local glyphs, descriptions = charset.chars, charset.labels
    local function decodeName()
        local result = {}
        for i = 0, 5 do
            local code = memory.readbyte(0x7E0F00 + i)
            if code == 0 or code == 0xFF then break end
            result[#result+1] = glyphs[code] or (" símbolo " .. string.format("%02X", code) .. " ")
        end
        local text = table.concat(result):gsub("%s+$", "")
        return text ~= "" and text or "vacío"
    end
    local seen, accepted, active = false, false, false
    local lastCell, lastName, absent = nil, nil, 0
    memory.registerexec(0xC2E224, 1, function() seen = true end)
    -- Reached only when the game's name validation succeeded.
    memory.registerexec(0xC2E233, 1, function() accepted = true end)
    return function()
        if seen then
            absent = 0
            local column = memory.readbyte(0x7E0F08)
            local row = memory.readbyte(0x7E0F09)
            if column < 10 and row < 8 then
                local cell = row * 10 + column
                local code = memory.readbyte(0xFFC9AC + cell)
                local letter = descriptions[code] or ("Símbolo " .. string.format("%02X", code))
                local name = decodeName()
                local text = {}
                if not active then
                    text[#text+1] = "Nombre del personaje. Nombre actual: " .. name ..
                        ". Usa la cruceta para elegir una letra, A para escribir, B para borrar y Start para confirmar."
                elseif name ~= lastName then
                    text[#text+1] = "Nombre: " .. name .. "."
                end
                if not active or cell ~= lastCell then text[#text+1] = letter end
                if accepted then
                    text[#text+1] = "Nombre confirmado: " .. name .. "."
                end
                if #text > 0 then say(table.concat(text, " ")) end
                active = not accepted
                lastCell, lastName = cell, name
            else
                log("Coordenadas inesperadas en la cuadrícula del nombre")
            end
        else
            absent = absent + 1
            if absent > 3 then active = false; lastCell = nil; lastName = nil end
        end
        seen, accepted = false, false
    end
end
