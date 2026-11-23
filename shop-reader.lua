-- Observe native shop routines; no input or writes to game memory.
return function(memory,say,log,observer)
 local function b(a)return memory.readbyte(a)end
 local function w(a)return b(a)+256*b(a+1)end
 local function long(a)return w(a)+65536*b(a+2)end
 local checks={ [0xC2D54E]={0x2C,0x1D,0x0D},[0xC2D81C]={0xA5,0x54},
  [0xC2D8FF]={0xA5,0x54},[0xC2D620]={0x2C,0x1D,0x0D},
  [0xC2D698]={0x2C,0x1D,0x0D},[0xC2DA33]={0x28,0x60},
  [0xC2D62A]={0x20,0x91,0x87},[0xC2D6A2]={0x20,0xD5,0x87},
  [0xC2D5D6]={0x4C,0xCC,0xEA},[0xC2D686]={0x4C,0xCC,0xEA} }
 for a,values in pairs(checks)do for i,v in ipairs(values)do
  if b(a+i-1)~=v then log('Tienda no disponible: firma incompatible.');return function()end end
 end end
 local folder=assert(debug.getinfo(1,'S').source:sub(2):match('^(.*[/\\])'))
 local tickEquipment=dofile(folder..'shop-equipment-reader.lua')(memory,say,log,observer)
 local current,previous,event=nil,nil,nil
 local active,missing=false,0
 local function capture(mode)
  local id=b(0x7E04C9)
  local price=mode=='sell' and math.floor((w(0x7E7800+id*2)+1)/2) or w(0x7E6E00+id*2)
  current={mode=mode,id=id,price=price,owned=b(0x7E04CA),equipped=b(0x7E0D82),
   qty=b(0x7E04CB),total=long(0x7E1044),gold=long(0x7E2C53),cursor=b(0x7E0054)}
 end
 memory.registerexec(0xC2D54E,1,function()capture('top')end)
 memory.registerexec(0xC2D81C,1,function()capture('buy')end)
 memory.registerexec(0xC2D8FF,1,function()capture('sell')end)
 memory.registerexec(0xC2D620,1,function()capture('buyQty')end)
 memory.registerexec(0xC2D698,1,function()capture('sellQty')end)
 memory.registerexec(0xC2DA33,1,function()
  if current then capture(current.mode)end
 end)
 memory.registerexec(0xC2D62A,1,function()capture('buyQty');event='Compra realizada'end)
 memory.registerexec(0xC2D6A2,1,function()capture('sellQty');event='Venta realizada'end)
 for _,a in ipairs({0xC2D5D6,0xC2D686})do
  memory.registerexec(a,1,function()event='No se puede realizar esta operación'end)
 end
 return function()
  if tickEquipment()then current=nil;previous=nil;active=true;missing=0;event=nil;return end
  local s=current;current=nil
  if not s then missing=missing+1;if missing>3 then active=false;previous=nil end;event=nil;return end
  missing=0
  local key=table.concat({s.mode,s.cursor,s.id,s.qty,s.owned,s.gold},':')
  if event then
   if event:find('No se puede',1,true)then say(event..'.')
   else say(string.format('%s. %d de %s. Total %d G. Dinero %d G.',event,s.qty,
    observer.item(s.id),s.total,long(0x7E2C53)))end
   event=nil;previous=nil;active=true;return
  end
  if key==previous then return end
  previous=key
  local intro=not active and 'Tienda. ' or '';active=true
  if s.mode=='top' then
   local help=intro~='' and ' Izquierda o derecha cambia entre Comprar y Vender. Abajo: Equipo. A entra; B sale.' or ''
   say(intro..(s.cursor==8 and 'Comprar' or s.cursor==9 and 'Vender' or 'Selección '..s.cursor)..'. Dinero '..s.gold..' G.'..help)
  elseif s.mode=='buy' or s.mode=='sell' then
   if s.id==0 then say('Lista vacía. Pulsa B para volver.');return end
   local text=string.format('%s. %s. Precio %d G. En inventario %d. Equipados %d.',
    s.mode=='buy' and 'Comprar' or 'Vender',observer.item(s.id),s.price,s.owned,s.equipped)
   if s.mode=='buy' and s.price>s.gold then text=text..' Dinero insuficiente.'end
   say(text)
  else
   say(string.format('%s %s. Cantidad %d. Total %d G. A confirma; B cancela.',
    s.mode=='buyQty' and 'Comprar' or 'Vender',observer.item(s.id),s.qty,s.total))
  end
 end
end
