-- Explicit order preserves overlapping sectors and stable references.
local folder=assert(debug.getinfo(1,"S").source:sub(2):match("^(.*[/\\])"))
local profiles={}
local files={
 "dia-lavos",
 "pendientes-1000",
 "pendientes-600",
 "pendientes-2300",
 "ruinas-guarida",
 "zeal",
 "dactil-tirano",
 "laruba",
 "magus",
 "cueva-magica",
 "reptiles",
 "ioka",
 "ruta-tata",
 "denadoro",
 "pueblos",
 "zenan",
 "medina",
 "proto-fabrica",
 "lab32-alcantarillado",
 "arris",
 "futuro",
 "prision",
 "catedral-guardia-casas",
}
for _,name in ipairs(files)do
 for _,profile in ipairs(dofile(folder.."profiles/"..name..".lua"))do
  if profile.location==464 then profile=dofile(folder..'profiles/epoch-time.lua')(profile)end
  profiles[#profiles+1]=profile
 end
end
return profiles
