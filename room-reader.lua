-- Compatibility entry point; implementation lives in rooms/.
local folder=assert(debug.getinfo(1,"S").source:sub(2):match("^(.*[/\\])"))
return dofile(folder.."rooms/reader.lua")
