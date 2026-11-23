-- Jet Bike: read-only observation of the native, decompressed Mode 7 engine.
return function(memory,say,log,cue)
 local function b(a)return memory.readbyte(a)end
 local function w(a)return b(a)+256*b(a+1)end
 local function matches(a,bytes)
  for i,v in ipairs(bytes)do if b(a+i-1)~=v then return false end end
  return true
 end
 local function active()return w(0x7E0100)==271 end
 local function signature()
  return active() and matches(0x7E485D,{0xE6,0xBC,0xA5,0x53,0xC9,0x08,0x00})
   and matches(0x7E4984,{0xA5,0x9A,0xF0,0x2D,0x3A,0x85,0x9A})
 end
 local seen=false
 memory.registerexec(0x7E485D,1,function()if signature()then seen=true end end)
 local entered,started,finished=false,false,false
 local frame,lastSpeech,oldBoost,oldLead,lastKeys=0,-1000,nil,nil,{}
 local function read()
  if not signature()then return nil end
  local p=w(0x7E0051)+65536*w(0x7E0053)
  local rival=w(0x7E0076)+65536*w(0x7E0078)
  local y,ry=w(0x7E004E),w(0x7E0073)
  local boosts=w(0x7E009A)
  if p>0x81000 or rival>0x81000 or y>0x7000 or ry>0x7000 or boosts>3 then return nil end
  local difference=p-rival
  local lead=difference>256 and 'Vas delante' or difference< -256 and 'Vas detrás' or 'Vais a la par'
  local lane=ry<y-2048 and 'Patxi está arriba' or ry>y+2048 and 'Patxi está abajo' or 'Patxi está a tu altura'
  local remaining=math.max(0,math.ceil((0x80000-p)*100/0x80000))
  return {player=p,rival=rival,boosts=boosts,lead=lead,lane=lane,remaining=remaining}
 end
 return {active=active,read=read,tick=function(keys)
  keys=keys or {};frame=frame+1
  local repeatState=keys.control and not keys.alt and not keys.shift and keys.F5 and not lastKeys.F5
  lastKeys={F5=keys.F5}
  if not active()then
   entered,started,finished,seen=false,false,false,false
   oldBoost,oldLead=nil,nil;return
  end
  if not entered then
   entered=true
   say('Carrera de motos. Arriba y abajo para maniobrar; B para turbo, tres usos. Control F5 repite tu situación.',false)
  end
  local observed=seen;seen=false
  if not observed then return end
  local s=read();if not s then return end
  if not started then started=true;oldBoost=s.boosts;lastSpeech=frame-120 end
  if not finished and (s.player>=0x80000 or s.rival>=0x80000)then
   finished=true
   say('Meta. '..(s.player>s.rival and 'Has ganado la carrera.' or 'Patxi ha llegado delante.'),false)
   return
  end
  if finished then return end
  if oldBoost~=s.boosts then
   say('Turbo usado. Quedan '..s.boosts..'.',false);oldBoost=s.boosts;lastSpeech=frame
  end
  if repeatState or frame-lastSpeech>=120 then
   say(s.lead..'. '..s.lane..'. Queda '..s.remaining..' por ciento. Turbos: '..s.boosts..'.',false)
   if cue and oldLead and oldLead~=s.lead then cue(s.lead=='Vas delante' and 'games' or 'enemy')end
   oldLead=s.lead;lastSpeech=frame
  end
 end}
end
