-- Magno 101%: native tent event state. No writes, input injection or prediction.
return function(memory)
 local model={}
 local function b(a)return memory.readbyte(a)end
 local function w(a)return b(a)+256*b(a+1)end
 local function pc(slot)return w(0x7E1180+slot)end
 local function between(n,a,z)return n>=a and n<z end
 local function visible(slot)return b(0x7E1100+slot)<128 and b(0x7E1A81+slot)~=0 end
 local function actor(slot,name)
  return {slot=slot,name=name,x=w(0x7E1800+slot)/16,y=w(0x7E1880+slot)/16,visible=visible(slot)}
 end
 function model.state()
  if w(0x7E0100)~=434 or b(0x7F2000)~=24 or w(0x7F2001)~=0x300 or
   w(0x7F2141)~=0x547 or w(0x7F2161)~=0x83F or
   b(0x7F2329)~=0x12 or b(0x7F259D)~=0x12 then return nil end
  local slot=w(0x7E0197)
  if slot>126 or slot%2~=0 then return nil end
  local s={phase='lobby',points=b(0x7F0052),food=b(0x7F005F),
   toys=b(0x7F005D),clones=b(0x7F005E),dialogue=b(0x7E0129)~=0,
   menu=b(0x7E0162)~=0,controlled=b(0x7E011F)~=0,
   x=w(0x7E1800+slot)/16,y=w(0x7E1880+slot)/16,
   cue=b(0x7F0220),response=b(0x7F0222),round=b(0x7F0210),
   rope=w(0x7F0224),captured=b(0x7F0232),light=visible(16)}
  s.soldiers={actor(40,'Rafa'),actor(42,'Carlos'),actor(44,'Fonso')}
  s.monsters={actor(30,'izquierda'),actor(32,'centro'),actor(34,'derecha')}
  if between(pc(0),0x328,0x3AE) then
   s.phase='mimic';s.ready=s.response==0x80 and s.cue<=3 and s.round>=1 and s.round<=22
   if between(pc(0),0x38A,0x39E)then s.result='win'
   elseif between(pc(0),0x39E,0x3AE)then s.result='loss'end
  elseif visible(40)or visible(42)or visible(44)or between(pc(20),0x59C,0x6AE)then
   s.phase='guess';s.target=b(0x7F0218)
   s.ready=b(0x7F0216)==1 and s.target>=1 and s.target<=3 and
    s.soldiers[1].visible and s.soldiers[2].visible and s.soldiers[3].visible
   if between(pc(20),0x620,0x6AE)then s.result='win'
   elseif between(pc(40),0xA8F,0xA98)or between(pc(42),0xAFC,0xB05)or
    between(pc(44),0xB36,0xB3F)then s.result='loss'end
  elseif visible(30)or visible(32)or visible(34)or s.captured>0 or between(pc(22),0x8C0,0x920)then
   s.phase='monsters'
   s.ready=b(0x7F0216)==1 and s.controlled and not s.dialogue
   local hostage=w(0x7E0199)
   if between(pc(30),0x9D1,0x9DB)or between(pc(32),0xA11,0xA1B)or
    between(pc(34),0xA51,0xA5B)or
    (hostage<=126 and between(pc(hostage),0x421,0x44F))then s.result='loss'end
  end
  return s
 end
 function model.guess(s)
  if not s.ready then return 'Espera a que termine la mezcla.'end
  local ordered={s.soldiers[1],s.soldiers[2],s.soldiers[3]}
  table.sort(ordered,function(a,z)return a.x<z.x end)
  if ordered[1].x==ordered[2].x or ordered[2].x==ordered[3].x then return 'Los soldados siguen moviéndose.'end
  local parts={'Busca a '..s.soldiers[s.target].name..'.'}
  local lanes={'Izquierda','Centro','Derecha'}
  for i,a in ipairs(ordered)do parts[#parts+1]=lanes[i]..': '..a.name..'.'end
  parts[#parts+1]='Acércate y pulsa A.'
  return table.concat(parts,' ')
 end
 function model.status(s)
  if s.phase=='guess'then return model.guess(s)end
  if s.phase=='mimic'then
   local moves={[0]='R, brazo derecho',[1]='L, brazo izquierdo',[2]='A, sorpresa',[3]='Y, risa'}
   if s.ready then return 'Ronda '..s.round..' de 22. '..moves[s.cue]..'.'end
   return 'Mímica. Espera la letra y mantén esa tecla hasta el pitido; después suéltala. L: brazo izquierdo. R: brazo derecho. A: sorpresa. Y: risa.'
  end
  if s.phase=='monsters'then
   local parts={s.light and 'Luz azul disponible a la izquierda; acércate y pulsa A.'or 'La luz azul aún no está disponible.'}
   for i,a in ipairs(s.monsters)do
    local caught=math.floor(s.captured/2^(i-1))%2==1
    parts[#parts+1]=a.name..(caught and ': encerrado.'or
     a.visible and string.format(': %.1f casillas al norte de ti.',math.max(0,(s.y-a.y)/16))or ': fuera de vista.')
   end
   return table.concat(parts,' ')
  end
  return 'Tienda de los horrores. Tienes '..s.points..' Puntos de Oro. Diez puntos: soldados. Cuarenta: mímica. Ochenta: monstruos; necesitas un compañero.'
 end
 return model
end
