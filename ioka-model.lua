-- Read-only Ioka party and Hunting Range weather, verified against native events.
return function(memory)
 local function b(a)return memory.readbyte(a)end
 local function w(a)return b(a)+256*b(a+1)end
 local function matches(a,hex)
  for pair in hex:gmatch('%x%x')do
   if b(a)~=tonumber(pair,16)then return false end
   a=a+1
  end
  return true
 end
 local model={supported=matches(0xC06732,'c8a5512980')}
 function model.weather()
  if not model.supported or w(0x7E0100)~=291 or w(0x7F2001)~=0x440 or
   not matches(0x7F2441,'4afa0100366684d14ad80b7e004a21157f00')then return nil end
  local rainy=math.floor(b(0x7F01D1)/16)%2==1
  local effect=b(0x7E0BD8)
  if effect~=b(0x7F1521)or effect~=(rainy and 4 or 0)then return nil end
  return rainy
 end
 function model.party()
  if not model.supported or w(0x7E0100)~=280 or b(0x7F2000)~=23 or
   w(0x7F20E3)~=0x87D or not matches(0x7F287E,
    '771e770d120e0100193f03711e121e09000e040417041a14040426710d771e111c750f00')then return nil end
  local flag,cups,elapsed=b(0x7F021C),b(0x7F021A),b(0x7F0236)
  if flag>1 or cups>32 or elapsed>175 then return nil end
  -- The start flag precedes the helper resetting the previous round count.
  if flag==1 and w(0x7E118C)<0x7AB and cups>0 then return nil end
  return {active=flag==1,cups=cups,elapsed=elapsed,
   dialogue=b(0x7E0129)~=0,menu=b(0x7E0162)~=0,
   dance=w(0x7E1184)>=0x3C9 and w(0x7E1184)<0x3E4}
 end
 function model.free()
  return b(0x7E011F)~=0 and b(0x7E0129)==0 and b(0x7E0162)==0
 end
 return model
end
