-- Observe native selection only. No input injection or RAM writes.
return function(memory,say,log)
 local checks={
  [0xC26AC8]={0x7B,0xBD,0x02,0x00,0x0A,0xAA},
  [0xC26B5E]={0xC2,0x20,0xA6,0x4E,0xA5,0xF8},
 }
 for a,bytes in pairs(checks)do for i,b in ipairs(bytes)do
  if memory.readbyte(a+i-1)~=b then
   log('Lector del Epoch no disponible: firma incompatible.');return function()end
  end
 end end
 local function word(a)return memory.readbyte(a)+256*memory.readbyte(a+1)end
 local eras={
  [0]='Fin del Tiempo',[1]='2300 después de Cristo. Futuro',
  [2]='1999 después de Cristo. Día de Lavos',[3]='1000 después de Cristo. Presente',
  [4]='600 después de Cristo. Edad Media',[5]='12000 antes de Cristo. Antigüedad',
  [6]='65 millones antes de Cristo. Prehistoria',
 }
 local observed,idle,choice=false,false,nil
 memory.registerexec(0xC26AC8,1,function()observed=true end)
 memory.registerexec(0xC26B5E,1,function()
  observed=true;idle=true
  choice=memory.readbyte(0x7E0000+word(0x7E004E)+0x22)
 end)
 local active,previous,missing=false,nil,0
 return function()
  if observed then
   missing=0
   if idle and eras[choice]and (not active or choice~=previous)then
    say((not active and 'Rueda del tiempo. L y R o las direcciones cambian el destino; A viaja y B cancela. 'or '')..
     'Destino: '..eras[choice]..'.',active)
    active=true;previous=choice
   end
  else
   missing=missing+1
   if missing>6 then active=false;previous=nil end
  end
  observed=false;idle=false
 end
end
