-- Read-only: announce the native dance branch, never infer it from input.
return function(memory,say,log)
 local function b(a)return memory.readbyte(a)end
 local function w(a)return b(a)+256*b(a+1)end
 local function matches(a,hex)
  for pair in hex:gmatch('%x%x')do
   if b(a)~=tonumber(pair,16)then return false end;a=a+1
  end
  return true
 end
 -- Op B7 starts a finite animation here, after resolving its native event.
 if not matches(0xC02F48,'9d81179e81169e0116')then
  log('Baile no disponible: firma incompatible.');return function()end
 end
 local function supported()
  return w(0x7E0100)==7 and b(0x7F2000)==16 and
   matches(0x7F220B,'4210e300050033050233050433ad20e301')and
   matches(0x7F221C,'4410e300050044050244050444ad20e301')and
   matches(0x7F222D,'4310e300050055050255050455ad20e301')and
   matches(0x7F223E,'4110e300050066050266050466ad40e301')and
   matches(0x7F2257,'b7150800b7091000b71a0800b71b0800')
 end
 local steps={[0x256]='Y',[0x25A]='R',[0x25E]='L',[0x262]='X'}
 local pending
 memory.registerexec(0xC02F48,1,function()
  if not supported()or w(0x7E016D)~=w(0x7E0197) then return end
  local offset=memory.getregister('y')%65536
  -- Shared functions 3..6 of the party actors; NPC animations are excluded.
  if not steps[offset]or b(0x7F2001+offset)~=0xB7 then return end
  pending=steps[offset]
 end)
 return function()
  if not supported()or b(0x7E0129)~=0 or b(0x7E0162)~=0 then pending=nil;return end
  if pending then say('Baile: paso '..pending..'.',false);pending=nil end
 end
end
