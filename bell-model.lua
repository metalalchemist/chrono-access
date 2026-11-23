-- Read-only model of the Magno ROM's Leene strength game.
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
 local model={supported=matches(0xC066C6,'c8 ad f2 00 89 80')and
  matches(0xC064A9,'a5 d9 c5 db f0 04 b0 02')}
 -- These complete functions prove the oscillator, >=21 comparison and award path.
 local scripts={
  {0x596,'0e019605240fad1089407714121416010c9c4001711434031015110f121400010c9cc001731434031005110f112189f09605240e0000'},
  {0x98A,'24001e121e000030e30007003389409d1c1489209cc0021214150403e85aad019c400289409d1d141214150408bb1a711b020033dae30100'},
  {0x56E,'121bc80206bb114fc81b581b520000'}
 }
 function model.state()
  if not model.supported or w(0x7E0100)~=5 or b(0x7F2000)~=29 then return nil end
  local slot=w(0x7E0197)
  if slot>126 or slot%2~=0 or w(0x7F2007+slot*16)~=0x596 or
   w(0x7F2343)~=0x98A then return nil end
  for _,s in ipairs(scripts)do if not matches(0x7F2001+s[1],s[2])then return nil end end
  local pc,bell=w(0x7E1180+slot),w(0x7E11B4)
  local phase='idle'
  if bell==0x994 then
   if pc>=0x596 and pc<0x5A2 then phase='prepare'
   elseif pc>=0x5A2 and pc<0x5C4 then phase='swing'
   elseif pc>=0x5C4 and pc<0x5CC then phase='return' end
  elseif bell>=0x997 and bell<=0x9C0 then phase='strike' end
  local count=b(0x7F0228)
  if count>22 then return nil end
  return {phase=phase,counter=count,direction=pc<0x5B2 and 'out' or 'back',
   points=b(0x7F0052),controlled=b(0x7E011F)~=0,dialogue=b(0x7E0129)~=0,
   x=w(0x7E1800+slot)/16,y=w(0x7E1880+slot)/16}
 end
 return model
end
