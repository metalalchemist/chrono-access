-- Optional button-driven assistance. Reads state; never writes RAM or loads saves.
return function(memory,model)
 local function b(a)return memory.readbyte(a)end
 local function w(a)return b(a)+256*b(a+1)end
 local function bit(a,mask)return math.floor(b(a)/mask)%2==1 end
 local function native(map)
  local count,slot,bytes
  if map==221 then count,slot,bytes=14,24,{0x83,0x86,0x04,0x8B,0x0F,0x08}
  elseif map==216 then count,slot,bytes=10,16,{0x8B,0x26,0x23,0x00,0xB2}
  elseif map==219 then count,slot,bytes=20,18,{0x8B,0x08,0x13,0x87,0x01}
  else return false end
  if b(0x7F2000)~=count then return false end
  local p=0x7F2001+w(0x7F2001+slot*16)
  for i,value in ipairs(bytes)do if b(p+i-1)~=value then return false end end
  return true
 end
 local function known()return bit(0x7F00EC,64)end
 local function unlocked()return bit(0x7F00A4,32)end
 local function enabled()return bit(0x7F00EC,16)end
 local challenge={id='arris_rat',name='la rata de Arris'}
 challenge.instructions='Corre con B, tecla C, siguiendo los giros de las vigas. Pulsa A, tecla V, cerca de la rata. Si escapa, sal y vuelve a entrar. La nota del almacén debe estar leída. Después vuelve por la salida sur al subsuelo; la consola oeste se activa con L, R y A juntos, teclas A, S y V.'
 function challenge.detect()
  local s=model.state()
  if not s or not native(s.location)then return false end
  return (s.location==221 and not unlocked()and (enabled()or known()))or
   (s.location==216 and known()and not unlocked())
 end
 -- Centreline of the real narrow walkway, north to south. Feet coordinates.
 local beam={{312,48},{312,144},{72,144},{72,336},{408,336},
  {408,528},{312,528},{312,704},{72,704},{72,760}}
 local function route(s,south)
  local best,index,projection=math.huge,nil,nil
  for i=1,#beam-1 do
   local a,c=beam[i],beam[i+1]
   local dx,dy=c[1]-a[1],c[2]-a[2]
   local t=math.max(0,math.min(1,((s.x-a[1])*dx+(s.y-a[2])*dy)/(dx*dx+dy*dy)))
   local x,y=a[1]+t*dx,a[2]+t*dy
   local d=(x-s.x)^2+(y-s.y)^2
   if d<best then best,index,projection=d,i,{x,y}end
  end
  if best>32^2 then return nil end
  local path={projection}
  if south then for i=index+1,#beam do path[#path+1]=beam[i]end
  else for i=index,1,-1 do path[#path+1]=beam[i]end end
  return path
 end
 local function drawn(slot)return b(0x7E1100+slot)<128 and b(0x7E1A81+slot)~=0 end
 function challenge.start()
  local s=model.state()
  local run={phase=known()and 'return' or 'chase',age=0,attempts=0,index=1,stuck=0,legAge=0}
  function run.path(points)run.points=points;run.index=1;run.stuck=0;run.legAge=0;run.last=nil end
  local function chaseDirection(state)
   if drawn(24)and not drawn(26)then return true end
   if drawn(26)and not drawn(24)then return false end
   return state.y<170
  end
  if s.location==221 then run.path(route(s,run.phase=='return'or chaseDirection(s)))
  elseif s.location==216 then run.phase='console';run.path({{552,600},{616,600},{616,592}})end
  if not run.points then return nil,'Acércate a las vigas antes de iniciar la ayuda.'end
  local function navigate(state,catch)
   local p=run.points[run.index]
   while p and math.abs(state.x-p[1])<=2.1 and math.abs(state.y-p[2])<=2.1 do
    run.index=run.index+1;run.legAge=0;p=run.points[run.index]
   end
   if not p then return {},true end
   run.legAge=run.legAge+1
   if run.last and math.abs(state.x-run.last.x)+math.abs(state.y-run.last.y)<.05 then
    run.stuck=run.stuck+1
   else run.stuck=0 end
   run.last={x=state.x,y=state.y}
   if run.stuck>120 or run.legAge>900 then return nil,'No pude avanzar. La ayuda se detuvo; conservas el control.'end
   local keys={B=true}
   if math.abs(state.x-p[1])>2.1 then keys[state.x<p[1]and 'right'or 'left']=true
   else keys[state.y<p[2]and 'down'or 'up']=true end
   if catch and run.age%10==0 then keys.A=true end
   return keys,false
  end
  function run.step()
   run.age=run.age+1
   local state=model.state()
   local location=state and state.location or w(0x7E0100)
   local doorway=location==219 and (run.phase=='north_exit'or run.phase=='north_back')
   if (location==216 or location==221 or doorway)and (not state or not native(location))and b(0x7E0162)==0 then
    run.loading=(run.loading or 0)+1
    if run.loading<=180 then return {}end
   else run.loading=0 end
   if not state or not native(state.location)or (state.location==219 and not doorway)or b(0x7E0162)~=0 then
    return nil,'La ayuda se detuvo al salir del desafío.'
   end
   if doorway and (state.y<440 or state.x<104 or state.x>152)then
    return nil,'La ayuda se detuvo fuera del umbral seguro.'
   end
   if run.age>18000 then return nil,'La ayuda alcanzó su límite de tiempo y se detuvo.'end
   if not state.controlled then
    if state.location==221 and b(0x7E0129)>=5 and b(0x7E0129)<=7 then
     return {A=run.age%20==0}
    end
    return {}
   end
   if state.location==219 and run.phase=='north_exit'then
    run.phase='north_back';run.path({{136,472}})
   elseif state.location==221 and run.phase=='north_back'then
    run.phase='return';run.path(route(state,true))
   elseif state.location==216 and run.phase~='console'and run.phase~='activate'and run.phase~='reenter'then
    if known()then
     run.phase='console';run.path({{552,600},{616,600},{616,592}})
    else
     run.attempts=run.attempts+1
     if run.attempts>3 then return nil,'La rata escapó. La ayuda se detuvo después de tres intentos.'end
     run.phase='reenter';run.path({{544,576},{544,548}})
    end
   elseif state.location==221 and run.phase=='reenter'then
    run.phase='chase';run.path(route(state,false))
   elseif state.location==221 and known()and (run.phase=='chase'or run.phase=='reset'or run.phase=='reenter')then
    run.phase='return';run.path(route(state,true))
   end
   if run.phase=='console'and state.location~=216 then return nil,'La ayuda perdió la ruta a la consola y se detuvo.'end
   if not run.points then return nil,'No pude reconocer este tramo de las vigas.'end
   if run.phase=='activate'then
    if unlocked()then return nil,'Desafío completado. Rata atrapada, contraseña obtenida y paso abierto. Estás frente a la consola oeste de Arris.',true end
    run.activation=run.activation+1
    if run.activation==1 then return {up=true}end
    if run.activation==4 then return {L=true,R=true,A=true}end
    if run.activation>180 then return nil,'Llegaste a la consola. No pude confirmar la apertura del paso; puedes usar L, R y A.'end
    return {}
   end
   local keys,done=navigate(state,run.phase=='chase')
   if not keys and run.phase=='return'and state.location==221 and known()and drawn(26)then
    -- The caught southern rat can reset across the narrow beam. Refresh its
    -- native visibility through the north doorway, then return without fighting.
    run.phase='north_exit';run.path(route(state,false))
    if run.points then run.points[#run.points+1]={312,16};return {}end
   end
   if not keys then return nil,done end
   if done then
    if run.phase=='chase'then
     run.phase='reset';run.path(route(state,true))
    elseif run.phase=='console'then run.phase='activate';run.activation=0
    end
   end
   return keys
  end
  return run
 end
 return challenge
end
