-- Truce inns: observe each native offer, payment and recovered party.
-- No input injection; a cancelled offer or a script reload cannot announce rest.
return function(memory,say,log)
 log=log or function()end
 local function b(a)return memory.readbyte(a)end
 local function w(a)return b(a)+256*b(a+1)end
 local function gold()return w(0x7E2C53)+65536*b(0x7E2C55)end
 local inns={
  [12]={offer={800,336,848,368},first=1,last=2,bedMap=12,bed={800,32,1024,160}},
  [116]={offer={152,440,200,472},first=2,last=3,bedMap=117,bed={544,48,736,176}}
 }
 local activeInn
 local offered,paid,age,free,idle=nil,false,0,0,0
 local function clear(reason)
  if offered then log('Posada: seguimiento cerrado: '..(reason or 'fin'))end
  offered,paid,age,free,idle=nil,false,0,0,0
  activeInn=nil
 end
 local function recovered()
  local count=0
  for i=0,2 do
   local id=b(0x7E2980+i)
   if id<7 then
    local a=0x7E2600+id*0x50;count=count+1
    -- +3F is a menu-derived cache and can still be FFFF in the field.
    -- The native sleep routine restores the persistent maximum at +5.
    if w(a+5)==0 or w(a+3)~=w(a+5) or w(a+7)~=w(a+9)then return false end
   end
  end
  return count>0
 end
 return function()
  local location=w(0x7E0100)
  local inn=inns[location]
  if not inn and not (paid and activeInn and location==activeInn.bedMap)then
   -- The native sleep sequence reloads its location before returning to bed.
   -- Preserve an observed payment across that transition, bounded in time.
   if not paid then clear('fuera de la posada')
   else age=age+1;free=0;if age>3600 then clear('transición agotada')end end
   return
  end
  local controlled=b(0x7E011F)~=0 and b(0x7E0129)==0 and b(0x7E0162)==0
  if not offered then
   if not inn then return end
   local slot=w(0x7E0197)
   if slot<=126 and slot%2==0 and b(0x7E0162)==2 and b(0x7E0164)==inn.first and b(0x7E0165)==inn.last then
    local x,y=w(0x7E1800+slot)/16,w(0x7E1880+slot)/16
    local box=inn.offer
    if x>=box[1] and x<=box[3] and y>=box[2] and y<=box[4] then
     offered=gold();activeInn=inn;age=0;log('Posada: oferta observada, oro '..offered)
    end
   end
   return
  end
  age=age+1
  if gold()>offered or gold()<offered-10 or age>3600 then clear('estado cambiado');return end
  if gold()==offered-10 and not paid then paid=true;log('Posada: pago nativo observado, fotograma '..age)end
  idle=controlled and not paid and idle+1 or 0
  if idle>=600 then clear('sin pago');return end
  local slot=w(0x7E0197)
  local x,y=w(0x7E1800+slot)/16,w(0x7E1880+slot)/16
  local box=activeInn.bed
  local bedroom=location==activeInn.bedMap and slot<=126 and slot%2==0 and x>=box[1] and x<box[3] and y>=box[2] and y<box[4]
  if paid and controlled and bedroom then
   free=free+1
   if free>=15 and recovered()then
    say('Descanso completado. Pagaste 10 G. Vida y magia del grupo al máximo.',false)
    clear()
   end
  else free=0 end
 end
end
