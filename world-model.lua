-- Walking world-map data, verified against C232CD/C239D5/C262AE.
return function(memory,charset,name)
 local m={}
 local function b(a)return memory.readbyte(a)end
 local function w(a)return b(a)+256*b(a+1)end
 local function bit(v,mask)return math.floor(v/mask)%2==1 end
 local function vehicle(e)return e.kind=='dactyl'or e.kind=='epoch'end
 local function boardText(e)return 'Pulsa A para subir al '..(e.kind=='epoch'and 'Epoch.'or 'dáctil.')end
 function m.label(id)
  if id==0 then return nil end
  local a=0xC60000+w(0xC6F400+id*2)
  local parts={}
  local function glyph(code)
   if not charset.chars[code]then return false end
   parts[#parts+1]=charset.chars[code];return true
  end
  for i=1,128 do
   local c=b(a);a=a+1
   if c==0 then return table.concat(parts):gsub('%s+',' '):match('^%s*(.-)%s*$')end
   if c>=0xA0 then if not glyph(c)then return nil end
   elseif c>=0x21 then
    local p=0xDE0000+w(0xDEFA00+(c-0x21)*2)
    local count=b(p);p=p+1
    if count>80 then return nil end
    for j=1,count do
     local code=b(p);p=p+1
     if code==1 or code==2 then code=code*256+b(p);p=p+1 end
     if not glyph(code)then return nil end
    end
   elseif c>=0x13 and c<=0x1A then parts[#parts+1]=name(c==0x1A and 0 or c-0x13)
   elseif c==1 or c==2 then
    local code=c*256+b(a);a=a+1;if not glyph(code)then return nil end
   else return nil end
  end
 end
 function m.state()
  local location=w(0x7E0100)
  if location<496 or location>503 or b(0x7E027C)~=1 then return nil end
  local flying=location==499 and b(0x7E027E)==3 and bit(b(0x7E029E),64)
  if b(0x7E027E)~=0 and not flying then return nil end
  -- Read the vehicle's authoritative position while its task controls flight.
  local x,y=w(flying and 0x7E029A or 0x7E0283),w(flying and 0x7E029C or 0x7E0285)
  if x>=1536 or y>=1024 then return nil end
  return {location=location,x=x,y=y,flying=flying}
 end
 function m.exits(s)
  local exits,groups={},{}
  local count=b(0x7E1B38)
  if count>math.floor(0x380/7)then count=0 end
  for i=0,count-1 do
   local a=0x7E7E00+i*7
   local x,y=b(a)%128,b(a+1)%64
   if bit(b(a),128)and x<96 then
    local id=b(a+2)
    local label=m.label(id)
    if label and label~=''then
     local dest=w(a+3)%512
     if s.location==499 then
      local prehistoric={
       [275]='Choza del cacique de Villa Ioka',
       [276]='Choza suroeste de Villa Ioka',
       [277]='Choza de intercambio de Villa Ioka',
       [278]='Choza de curación de Villa Ioka',
       [279]='Punto de reunión de Villa Ioka',
       [281]='Selva, acceso norte', [282]='Selva, acceso sur',
      }
      label=prehistoric[dest]or label
     end
     if s.location==500 or s.location==501 then
      local antiquity={
       [336]='Puente de Paso de Enhasa',[337]='Pasaje sur de la superficie',
       [351]='Cueva de llegada',[352]='Puente de Paso de Kajar',
       [353]='Puente de Paso sur de Zeal',[354]='Pasaje oriental de la superficie',
       [356]='Pasaje norte de la superficie',[386]='Cueva Terra, entrada sur',
       [388]='Cueva Terra, entrada norte',[389]='Cueva de las islas de Zeal',
      }
      label=antiquity[dest]or label
     end
     if dest==15 then label='Vivienda este de Truce'
     elseif dest==16 then label='Vivienda oeste de Truce'end
     local key=id..':'..dest
     -- Zeal reuses one interior for disconnected cave mouths. Adjacent tiles
     -- of one mouth still share the same native landing coordinates.
     if s.location==501 and dest==389 then
      local ex,ey=b(a+5),b(a+6)
      key=key..':'..ex..':'..ey
      if ey<32 then
       if ex<20 then label='Cueva, entrada desde Kajar'
       elseif ex<40 then label='Cueva, salida a la isla intermedia'
       else label='Cueva, salida a la isla del palacio'end
      elseif ex<20 then label='Cueva, segundo acceso de la isla intermedia'
      else label='Cueva, acceso adicional del sur'end
     end
     local e=groups[key]
     local d=math.abs(x*16+8-s.x)+math.abs(y*16+8-s.y)
     if not e then
      e={key=key,name=label,destination=dest,cells={}};groups[key]=e;exits[#exits+1]=e
     end
     e.cells[#e.cells+1]={x=x,y=y}
     if not e.distance or d<e.distance then e.x=x;e.y=y;e.distance=d end
    end
   end
  end
  -- C230EF..C23118: parked Epoch must belong to this world and be present.
  if not s.flying and b(0x7E027E)==0 and bit(b(0x7E0294),128)and w(0x7E029F)==s.location then
   local px,py=w(0x7E0290),w(0x7E0292)
   if px<1536 and py<1024 then
    exits[#exits+1]={key='vehicle:epoch',kind='epoch',destination=-1,name='Epoch estacionado',px=px,py=py,x=math.floor(px/16),y=math.floor(py/16),cells={},distance=math.abs(px-s.x)+math.abs(py-s.y)}
   end
  end
  -- C23159 checks presence bit 80 on world 499 before native boarding.
  if s.location==499 and not s.flying and b(0x7E027E)==0 and bit(b(0x7E029E),128)then
   local px,py=w(0x7E029A),w(0x7E029C)
   if px<1536 and py<1024 then
    exits[#exits+1]={key='vehicle:dactyl',kind='dactyl',destination=-1,name='Dáctil estacionado',px=px,py=py,x=math.floor(px/16),y=math.floor(py/16),cells={},distance=math.abs(px-s.x)+math.abs(py-s.y)}
   end
  end
  table.sort(exits,function(a,c)if a.distance==c.distance then return a.key<c.key end;return a.distance<c.distance end)
  return exits
 end
 function m.relative(s,e)
  if vehicle(e)then
   if m.canBoard(s,e)then return 'Aquí. '..boardText(e)end
   local parts={};local dx,dy=e.px-s.x,e.py-s.y
   for _,axis in ipairs({{dy,'norte','sur'},{dx,'oeste','este'}})do
    if axis[1]~=0 then parts[#parts+1]=string.format('%.1f',math.abs(axis[1])/16)..(axis[1]<0 and ' al '..axis[2]or ' al '..axis[3])end
   end
   return 'Distancia en casillas: '..table.concat(parts,', ')..'. Acércate; pulsa A cuando esté a tu alcance. Control F7 calcula la ruta.'
  end
  local x,y=math.floor(s.x/16),math.floor(s.y/16)
  local dx,dy=e.x-x,e.y-y
  if dx==0 and dy==0 then
   if s.flying then return 'Sobre el destino. Aterriza en terreno permitido antes de entrar.'end
   if m.atEntrance(e)then return 'Aquí. Pulsa A para entrar.'end
   return 'Entrada próxima. Pulsa Control F7 para alcanzar el punto de acceso.'
  end
  local parts={}
  if dy~=0 then parts[#parts+1]=math.abs(dy)..(dy<0 and ' al norte'or ' al sur')end
  if dx~=0 then parts[#parts+1]=math.abs(dx)..(dx<0 and ' al oeste'or ' al este')end
  return 'Distancia en casillas: '..table.concat(parts,', ')..'.'
 end
 local function prop(tx,ty)
  tx=tx%192;ty=ty%128
  local id=b(0x7E5800+math.floor(ty/2)*96+math.floor(tx/2))
  local v=b(0x7E7000+id*2+ty%2)
  return tx%2==0 and math.floor(v/16)or v%16
 end
 function m.walkable(x,y)
  -- The native walk check tests the two upper samples, AND $0303.
  return prop(x-1,y-1)%4==0 and prop(x,y-1)%4==0
 end
 function m.cover(x,y)
  return bit(prop(x-1,y-1),4)and bit(prop(x,y-1),4)
 end
 function m.atEntrance(e)
  if vehicle(e)then return false end
  local index=w(0x7E1B32)
  if index==0xFFFF or index%7~=0 or index>=b(0x7E1B38)*7 then return false end
  local a=0x7E7E00+index
  return b(a+2)..':'..w(a+3)%512==e.key
 end
 -- Native Dactyl landing gates C24E20..C24E78. The idle task's property
 -- samples include all four corners and its extra obstruction word.
 function m.landing(s,slot)
  if not s or not s.flying or s.location~=499 or not slot or slot<0 or slot>0xFFC8 then return nil end
  local a=0x7E0000+slot
  if w(a)~=0x4CC5 or b(a+2)~=3 or w(a+0x14)~=s.x or w(a+0x18)~=s.y then return nil end
  for _,offset in ipairs({0x22,0x23,0x24,0x25,0x2E,0x2F})do
   if b(a+offset)%8~=0 then return false end
  end
  -- C248E8 rejects overlap with an Epoch present on this same world map.
  if bit(b(0x7E0294),128)and w(0x7E029F)==s.location then
   local dx,dy=w(0x7E0290)-s.x,w(0x7E0292)-s.y
   local width=dx>=0 and w(0xC24950)+w(0xC24946)or w(0xC24948)+w(0xC2494E)
   local height=dy>=0 and w(0xC24954)+w(0xC2494A)or w(0xC2494C)+w(0xC24952)
   if math.abs(dx)<width and math.abs(dy)<height then return false end
  end
  -- C6E74E excludes the rectangle x=[0,14), y=[0,52), in 8px units.
  if math.floor(s.x/8)<14 and math.floor(s.y/8)<52 then return false end
  return true
 end
 function m.landingText(allowed)
  if allowed==nil then return 'Detén el dáctil para comprobar el aterrizaje.'end
  return allowed and 'Puedes aterrizar aquí. Pulsa A.'or 'No puedes aterrizar aquí.'
 end
 -- Same overlap used by C2317D -> C22345, with dimensions from the ROM.
 -- It accepts either side; south has a larger reach, not an exclusive entry.
 function m.canBoard(s,e)
  if not vehicle(e)or s.flying then return false end
  local dx,dy=e.px-s.x,e.py-s.y
  local dimensions=e.kind=='epoch'and 0xC23254 or 0xC2325C
  local width=dx>=0 and w(0xC2324E)+w(dimensions)or w(dimensions+2)+w(0xC2324C)
  local height=dy>=0 and w(0xC23252)+w(dimensions+4)or w(dimensions+6)+w(0xC23250)
  return (dx==0 or math.abs(dx)<width)and(dy==0 or math.abs(dy)<height)
 end
 function m.route(s,e)
  if s.flying then return 'En vuelo. '..m.relative(s,e)..' Vuela hacia el destino y aterriza en terreno permitido; la ruta a pie se calcula después de aterrizar.'end
  local sx,sy=math.floor((s.x+4)/8)%192,math.floor((s.y+4)/8)%128
  local start=sy*192+sx
  local queue,head,previous,step={start},1,{[start]=start},{}
  local moves={{0,-1,'norte'},{0,1,'sur'},{-1,0,'oeste'},{1,0,'este'}}
  local goal={}
  for _,c in ipairs(e.cells)do goal[c.y*96+c.x]=true end
  while head<=#queue do
   local node=queue[head];head=head+1
   local x,y=node%192,math.floor(node/192)
   local reached=vehicle(e)and m.canBoard({x=x*8,y=y*8},e)or
    (not vehicle(e)and goal[math.floor(y/2)*96+math.floor(x/2)]and m.cover(x,y))
   if reached then
    local path={}
    while node~=start do table.insert(path,1,step[node]);node=previous[node]end
    if #path==0 then return vehicle(e)and 'Aquí. '..boardText(e)or 'Aquí. Pulsa A para entrar.'end
    local runs={};local direction,n=path[1],0
    for _,d in ipairs(path)do
     if d~=direction then runs[#runs+1]=n..' pasos al '..direction;direction=d;n=0 end
     n=n+1
    end
    runs[#runs+1]=n..' pasos al '..direction
    return 'Ruta calculada, pasos de media casilla: '..table.concat(runs,', ')..(vehicle(e)and '. Al llegar, '..boardText(e)or '. Al llegar, pulsa A.')
   end
   for _,v in ipairs(moves)do
    local nx,ny=(x+v[1])%192,(y+v[2])%128
    local nextNode=ny*192+nx
    if not previous[nextNode]and m.walkable(nx,ny)then
     previous[nextNode]=node;step[nextNode]=v[3];queue[#queue+1]=nextNode
    end
   end
  end
  return vehicle(e)and 'No se encontró una ruta a pie hasta el '..(e.kind=='epoch'and 'Epoch.'or 'dáctil.')or 'No se encontró una ruta a pie hasta esta entrada.'
 end
 return m
end
