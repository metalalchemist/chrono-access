-- Magno soda contest: native input count, timer, result and awarded points.
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
 local model={supported=matches(0xC06732,'c8a5512980')and matches(0xC064A9,'a5d9c5dbf004b002')}
 local script='166e050006bb03e86e00d200031009d205031004bb2300e300771b7524bb1fd200090402340202551007040e33020e54bb20d200060402461004040e454f501d8701121d01024b3f03711b731d191b1a080602263310391a100602283310311a1806022a3310291a2006022c3310211a2806022e3310191a300602303310111a380602323310091a40060234331001114e8703d200060402441004040e4377246f031b4c00027e1b121b080416bb175b05211221c80206bb114fc821582152001003bb21022634022834022a34022c34022e34023034023234023434160049030cd20109d2000604060abb46dae301'
 function model.state()
  if not model.supported or w(0x7E0100)~=439 or b(0x7F2000)~=32 or
   w(0x7F2361)~=0x949 or w(0x7F2363)~=0x951 or not matches(0x7F2952,script)then return nil end
  local pc=w(0x7E11B6)
  local phase='idle'
  if pc>=0x968 and pc<0x991 then phase='prepare'
  elseif pc>=0x991 and pc<0x9E1 then phase='drinking'
  elseif pc>=0x9E1 and pc<0x9F9 then phase='ending'
  elseif pc>=0x9F9 and pc<0xA40 then phase='result' end
  local raw,timer=b(0x7F0236),b(0x7F023A)
  if phase=='drinking'and (raw>80 or timer<1 or timer>80 or b(0x7F0248)~=1)then return nil end
  if phase=='result'and raw>10 then return nil end
  return {phase=phase,raw=raw,timer=timer,
   cups=phase=='drinking'and math.floor(raw/8)or phase=='result'and raw or nil,
   points=b(0x7F0052),controlled=b(0x7E011F)~=0,dialogue=b(0x7E0129)~=0}
 end
 return model
end
