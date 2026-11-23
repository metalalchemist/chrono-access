-- Native chest outcomes. Read-only; speech is deferred until frame end.
return function(memory,say,log,charset)
 local function b(a)return memory.readbyte(a)end
 local function w(a)return b(a)+256*b(a+1)end
 local function gold()return w(0x7E2C53)+65536*b(0x7E2C55)end
 local checks={[0xC01E6D]={0xA8,0xE2,0x20,0xA9,0x01},
  [0xC01E7F]={0xA8,0xE2,0x20,0xA9,0x04},[0xC01E8D]={0xA9,0x02,0x82,0x7C,0x00}}
 for a,bytes in pairs(checks)do for i,v in ipairs(bytes)do
  if b(a+i-1)~=v then log('Lectura de cofres no disponible: firma incompatible.');return function()end end
 end end
 local pending
 local function owned(id)
  local n=0
  for i=0,241 do if b(0x7E2400+i)==id then n=n+b(0x7E2500+i)end end
  return n
 end
 local function name(id)
  local chars={}
  for i=0,10 do local c=b(0xCC0B5E+id*11+i)
   if charset.chars[c]then chars[#chars+1]=charset.chars[c]end
  end
  local s=table.concat(chars):gsub('^%s+',''):gsub('%s+$','')
  return s~=''and s or 'objeto '..id
 end
 memory.registerexec(0xC01E6D,1,function()
  local id=w(0x7F0200);pending={kind='item',id=id,before=owned(id)}
 end)
 memory.registerexec(0xC01E7F,1,function()pending={kind='gold',before=gold()}end)
 memory.registerexec(0xC01E8D,1,function()pending={kind='empty'}end)
 return function()
  local p=pending;pending=nil;if not p then return end
  if p.kind=='empty'then say('Este cofre ya está abierto.',false)
  elseif p.kind=='gold'then
   local n=gold()-p.before
   if n>0 then say('Cofre. Has obtenido '..n..' G. Dinero '..gold()..' G.',false)
   else say('Cofre abierto. El dinero no aumentó.',false)end
  else
   local n=owned(p.id)-p.before
   if n>0 then say('Cofre. Has obtenido '..name(p.id)..(n>1 and '. Cantidad '..n or '')..'.',false)
   else say('Cofre abierto. No aumentó la cantidad de '..name(p.id)..'.',false)end
  end
 end
end
