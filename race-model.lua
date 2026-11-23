-- Native Leene race state. No input, memory writes or outcome prediction.
return function(memory)
 local function b(a)return memory.readbyte(a)end
 local function w(a)return b(a)+256*b(a+1)end
 local function matches(address,hex)
  for pair in hex:gmatch('%x%x')do
   if b(address)~=tonumber(pair,16)then return false end
   address=address+1
  end
  return true
 end
 local model={names={'Hojalatón','Moquillo V','A. Gatón','Martini Fiz'},
  supported=matches(0xC06487,'a5d9c5dbf026')}
 local scripts={
  {0x718,'824f8d0020401f0077087706750e021033021233021433021633120b0401031106770b77181406160003751977160210440212440214440216447f1f6f061f770ead80113ce300121901000e7719bb185b141b020033e30100120e0000551218000021751819061a0105bb0c10161a0205bb0d100f1a0305bb0e10081a0405bb0f1001c00a061a0206e301001001c010031a0005751610191a01064f021610111a02064f031610091a03064f041610011003bb12e3010000'},
  {0x635,'710b12080000057508750600'},
  {0x679,'710b120800000675084f020600'},
  {0x6BE,'710b120800000675084f030600'},
  {0x703,'710b120800000675084f040600'},
  {0x56E,'121bc80206bb114fc81b581b520000'}
 }
 function model.state()
  if not model.supported or w(0x7E0100)~=5 or b(0x7F2000)~=29 or
   w(0x7F2181)~=0x718 or w(0x7F2183)~=0x75D then return nil end
  for _,s in ipairs(scripts)do if not matches(0x7F2001+s[1],s[2])then return nil end end
  local slot=w(0x7E0197)
  if slot>126 or slot%2~=0 then return nil end
  local bet,winner=b(0x7F022C),b(0x7F020C)
  local running,pending,latched=b(0x7F021C),b(0x7F0232),b(0x7F0210)
  if bet>4 or winner>4 or running>1 or pending>1 or latched>1 then return nil end
  local pc=w(0x7E1198)
  return {bet=bet,winner=latched==1 and winner or 0,running=running==1,pending=pending==1,
   points=b(0x7F0052),claiming=pc>=0x764 and pc<0x770,
   dialogue=b(0x7E0129)~=0,controlled=b(0x7E011F)~=0,
   near=math.abs(w(0x7E1800+slot)/16-512)<=96 and math.abs(w(0x7E1880+slot)/16-500)<=112}
 end
 return model
end
