-- Native party-exchange tasks. No controller interception or game-memory writes.
return function(memory,say,log,data)
 if not data then return function()end end
 local function b(a)return memory.readbyte(a)end
 local signatures={
  [0xC2C627]={0xE2,0x30},[0xC2C63A]={0x4C,0xCC,0xEA},
  [0xC2C660]={0x2C,0x1D,0x0D},[0xC2C6BC]={0x2C,0x1D,0x0D},
  [0xC2C7E3]={0x2C,0x1D,0x0D},[0xC2C854]={0x28,0xA2,0x37,0xFC},
  [0xC2C6B0]={0x4C,0x31,0x8A},[0xC2C6E7]={0x08,0xE2,0x20},
  [0xC2C70C]={0x08,0xE2,0x30},[0xC2C77C]={0x20,0x2B,0xCD},
  [0xC2C7FF]={0x20,0x0E,0xCC},
 }
 for a,values in pairs(signatures)do for i,v in ipairs(values)do
  if b(a+i-1)~=v then log('Menú de Grupo no disponible: firma incompatible.');return function()end end
 end end
 local seen,active,row=false,false,nil
 local previous,missing,intro=nil,0,true
 local events={}
 local swapBefore
 local committed=false
 local function hook(a,fn)memory.registerexec(a,1,fn)end
 local function character(slot)
  if slot<0 or slot>8 then return nil end
  local id=b(0x7E2980+slot)
  if id>6 then return nil end
  local name=data.name(id)
  return name~='' and name or ('Personaje '..(id+1)),id
 end
 local function locked(id)
  local flag=b(0xFFF9BB+id)
  return flag>0 and math.floor(b(0x7F01DF)/flag)%2==1
 end
 local function roster()
  local parts={}
  local reserve=b(0x7E0D36)==0
  for slot=0,reserve and 8 or 2 do
   local name,id=character(slot)
   if name then
    local position=(slot<3 and 'puesto '..(slot+1) or 'reserva '..(slot-2))
    parts[#parts+1]=position..': '..name..(slot<3 and locked(id) and ' (fijo)' or '')
   end
  end
  local text=#parts>0 and table.concat(parts,', ')..'.' or 'Sin personajes disponibles.'
  return text..(reserve and '' or ' La reserva no se cambia desde este menú.')
 end
 local function capture()
  local raw=b(0x7E0F0D)
  local slot=raw%64
  local name,id=character(slot)
  local source=b(0x7E0F00)
  local picked=source<9 and character(source) or nil
  local stage=picked and 'Destino del intercambio. ' or 'Elige un personaje. '
  local text
  if raw>=128 or not name then text='No hay un personaje disponible en esta posición.'
  else
   text=stage..name..'. '..(slot<3 and 'Grupo activo, puesto '..(slot+1)..'.' or 'Reserva, puesto '..(slot-2)..'.')
   if math.floor(raw/64)%2==1 or (slot<3 and locked(id))then text=text..' No se puede cambiar ahora.'end
   if picked then text='Elegido: '..picked..'. '..text end
  end
  row={key=source..':'..raw..':'..text,text=text}
 end
 for _,a in ipairs({0xC2C660,0xC2C6BC,0xC2C7E3})do
  hook(a,function()active=true;seen=true;capture()end)
 end
 hook(0xC2C854,function()if active then seen=true;capture()end end)
 hook(0xC2C6B0,function()active=true;seen=true;capture()end)
 hook(0xC2C627,function()intro=true;previous=nil end)
 hook(0xC2C63A,function()
  events[#events+1]='No hay suficientes personajes disponibles para cambiar el grupo.'
 end)
 hook(0xC2C70C,function()swapBefore=roster()end)
 hook(0xC2C77C,function()
  local after=roster()
  if swapBefore then
   events[#events+1]=swapBefore~=after and ('Grupo cambiado. '..after) or 'El grupo no ha cambiado.'
   committed=true
  end
  swapBefore=nil
 end)
 hook(0xC2C6E7,function()
  if b(0x7E0F00)<9 then
   if not committed then events[#events+1]='Selección cancelada.'end
   row=nil;previous=nil
  else active=false;row=nil;previous=nil;intro=true end
  committed=false
 end)
 hook(0xC2C7FF,function()active=false;row=nil;previous=nil;intro=true end)
 local epoch=data.menuEpoch
 return function()
  if epoch~=data.menuEpoch then
   active=false;row=nil;previous=nil;intro=true;epoch=data.menuEpoch
  end
  if #events>0 then say(table.concat(events,' '));events={}end
  if not seen or not active then
   missing=missing+1
   if missing>3 then previous=nil;intro=true;active=false end
   seen=false;return
  end
  seen=false;missing=0
  if row and row.key~=previous then
   local prefix=''
   if intro then prefix='Grupo. '..roster()..' Elige dos personajes para intercambiarlos. ';intro=false end
   say(prefix..row.text);previous=row.key
  end
 end
end
