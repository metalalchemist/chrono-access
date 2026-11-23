-- Shop-only equipment tasks. Observe native selections and committed changes.
return function(memory,say,log,observer)
 local function b(a)return memory.readbyte(a)end
 local function w(a)return b(a)+256*b(a+1)end
 local checks={
  [0xC2D6C6]={0x2C,0x1D,0x0D},[0xC2D718]={0x2C,0x1D,0x0D},
  [0xC2D77B]={0x2C,0x1D,0x0D},[0xC2E106]={0x28,0x60},
  [0xC2E188]={0x28,0x60},[0xC2D7B5]={0xA2,0x64,0x36},
  [0xC2D7BB]={0x20,0xC2,0xEA},[0xC2D738]={0x4C,0xCC,0xEA},
 }
 for a,bytes in pairs(checks)do for i,v in ipairs(bytes)do
  if b(a+i-1)~=v then log('Equipo de tienda no disponible: firma incompatible.');return function()return false end end
 end end
 local slots={'Arma','Casco','Armadura','Accesorio'}
 local offsets={0x29,0x27,0x28,0x2A}
 local fields={{7,'Ataque'},{8,'Defensa'},{0,'Fuerza'},{2,'Velocidad'},
  {4,'Puntería'},{5,'Evasión'},{3,'Poder mágico'},{1,'Vitalidad'},{6,'Defensa mágica'}}
 local current,event,stage,previous,spoken=nil,nil,nil,nil,nil
 local appendNext=false
 local missing=0
 local function capture(mode)
  stage=mode
  local index=mode=='character'and b(0x7E0054)-12 or b(0x7E0071)
  if index<0 or index>6 then current=nil;return end
  local id=b(0x7E0D5F+index)
  if id>6 then current=nil;return end
  local slot=b(0x7E0077)
  if mode~='character'and not slots[slot+1]then current=nil;return end
  local record=0x7E2600+id*0x50
  local s={mode=mode,char=id,slot=slot,name=observer.name(id),record=record}
  if mode=='slot'then
   s.item=b(record+offsets[slot+1])
   s.text=s.name..'. '..slots[slot+1]..': '..observer.item(s.item)..'.'
  elseif mode=='character'then
   local stats={}
   for _,field in ipairs(fields)do stats[#stats+1]=field[2]..' '..b(record+0x36+field[1])..'.'end
   s.text='Equipo. '..s.name..'. '..table.concat(stats,' ')..
    ' Izquierda y derecha: personaje. A: elegir personaje; B: volver a Comprar y Vender.'
  else
   local row=b(0x7E0FC8)+b(0x7E0054)-4
   local total=b(0x7E0FC6)
   local item=b(0x7E04C9)
   if row<0 or row>=total or item==0 or item~=b(0x7E0F00+row)then current=nil;return end
   s.item=item
   local changes={}
   for _,field in ipairs(fields)do
    local old,new=b(record+0x36+field[1]),b(0x7E9B1C+field[1])
    if old~=new then changes[#changes+1]=string.format('%s de %d a %d; %s %d.',
     field[2],old,new,new>old and 'sube'or 'baja',math.abs(new-old))end
   end
   local old,new=w(record+0x3F),w(0x7E9B25)
   if old~=new then changes[#changes+1]=string.format('Vida de %d a %d; %s %d.',old,new,
    new>old and 'sube'or 'baja',math.abs(new-old))end
   s.text=string.format('%s. %s. %d de %d. Cantidad %d. %s A equipa; B cancela.',
    s.name,observer.item(item),row+1,total,b(0x7E0F62+row),
    #changes>0 and table.concat(changes,' ')or 'Sin cambios en las estadísticas.')
  end
  current=s
 end
 local function hook(a,fn)memory.registerexec(a,1,fn)end
 hook(0xC2D6C6,function()capture('character')end)
 hook(0xC2D718,function()capture('slot')end)
 hook(0xC2E106,function()capture('slot')end)
 hook(0xC2D77B,function()stage='candidate' end)
 hook(0xC2E188,function()if stage=='candidate'then capture('candidate')end end)
 hook(0xC2D7B5,function()
  local slot=b(0x7E0077)
  if slots[slot+1]then event='Equipo cambiado. '..slots[slot+1]..': '..
   observer.item(b(0x7E0000+w(0x7E006F)+offsets[slot+1]))..'.'end
 end)
 hook(0xC2D7BB,function()if not event then event='Cambio de equipo cancelado.'end end)
 hook(0xC2D738,function()event='No hay piezas disponibles para esta ranura.'end)
 return function()
  local s=current;current=nil
  if event then say(event);event=nil;previous=nil;spoken=nil;missing=0;appendNext=true;return true end
  if not s then
   missing=missing+1
   if missing>3 then stage=nil;previous=nil;spoken=nil;appendNext=false end
   return false
  end
  missing=0
  local key=s.mode..':'..s.char..':'..s.text
  if key~=previous then
   local help=s.mode=='slot'and(previous==nil or not previous:find('slot:',1,true))and
    ' Arriba y abajo: pieza; izquierda y derecha: personaje. A: alternativas; B: volver.'or ''
   local desc=s.mode=='candidate'and observer.descriptions[s.item]or nil
   say(s.text..help..(desc and ' '..desc or ''),not appendNext)
   appendNext=false
   previous=key;spoken=desc and s.item or nil
  elseif s.mode=='candidate'and observer.descriptions[s.item]and spoken~=s.item then
   say(observer.descriptions[s.item],false);spoken=s.item
  end
  return true
 end
end
