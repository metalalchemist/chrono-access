-- Observe only Gato's native reward script; battle speech stays in battle-reader.
return function(memory,say,log)
 local function b(a)return memory.readbyte(a)end
 local function w(a)return b(a)+256*b(a+1)end
 local function matches(a,hex)
  for pair in hex:gmatch('%x%x')do
   if b(a)~=tonumber(pair,16)then return false end;a=a+1
  end
  return true
 end
 local previous,pending,won=nil,nil,false
 return function()
  if w(0x7E0100)~=6 or b(0x7F2000)~=9 or w(0x7F2101)~=0x1DE or
   not matches(0x7F219A,'e8045b0f0b120bc80206bb5b4fc80b580b5200')then
   previous,pending,won=nil,nil,false;return
  end
  local points=b(0x7F0052)
  local pc=w(0x7E1180)
  if pc>=0x19A and pc<=0x1AC then won=true end
  if previous and points<previous then pending,won=nil,false end
  if previous and points>previous and won then pending=(pending or 0)+points-previous end
  previous=points
  if b(0x7E011F)~=0 and b(0x7E0129)==0 then
   if pending then
    say('Premio de Gato: '..pending..' Puntos de Oro. Tienes '..points..'.')
   elseif won and points==200 then say('Ya tienes el máximo de 200 Puntos de Oro.')end
   pending,won=nil,false
  end
 end
end
