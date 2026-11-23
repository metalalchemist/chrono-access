-- Verified against the glyph bitmaps in the user's Magno 101% ROM.
-- This translation moves k and replaces several original symbols with accents.
local chars = {}
for i=0,25 do chars[0xA0+i]=string.char(65+i); chars[0xBA+i]=string.char(97+i) end
for i=0,9 do chars[0xD4+i]=tostring(i) end
local special = {
    [0xC4]="é", [0xDE]="!", [0xDF]="?", [0xE0]="-", [0xE1]='"',
    [0xE2]="k", [0xE3]=":", [0xE4]="ñ", [0xE5]="í", [0xE6]="/",
    [0xE7]="¡", [0xE8]=".", [0xE9]=",", [0xEA]="¿", [0xEB]="ó",
    [0xEC]="ú", [0xED]="+", [0xEE]="[nota musical]", [0xEF]=" ",
    [0xF0]="%", [0xF1]="…", [0xF2]="infinito", [0xF3]="á", [0xFF]=" "
}
for code,char in pairs(special) do chars[code]=char end
local labels = {
    [0xDE]="Exclamación de cierre", [0xDF]="Interrogación de cierre", [0xE0]="Guion",
    [0xE1]="Comillas", [0xE3]="Dos puntos", [0xE6]="Barra",
    [0xE7]="Exclamación de apertura", [0xE8]="Punto", [0xE9]="Coma",
    [0xEA]="Interrogación de apertura", [0xED]="Más", [0xEF]="Espacio", [0xFF]="Espacio"
}
for code,char in pairs(chars) do
    if not labels[code] then
        if code>=0xA0 and code<=0xB9 then labels[code]=char.." mayúscula"
        elseif (code>=0xBA and code<=0xD3) or code==0xE2 or code==0xE4 or
            code==0xE5 or code==0xEB or code==0xEC or code==0xF3 then
            labels[code]=char.." minúscula"
        else labels[code]=char end
    end
end
return {chars=chars, labels=labels}
