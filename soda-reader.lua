-- Read-only progress. Timing is taken from the game, never a wall-clock timer.
return function(memory,folder,say,log,cue)
 local model=dofile(folder..'soda-model.lua')(memory)
 local cfg=dofile(folder..'room-audio-config.lua')
 local names={'Una','Dos','Tres','Cuatro','Cinco','Seis','Siete','Ocho','Nueve','Diez'}
 local session,last=nil,nil
 local function speak(text,interrupt)if say then say(text,interrupt or false)else log(text)end end
 local function signal()if cfg.enabled and cue then cue('bell_timing')end end
 if not model.supported then log('Concurso de soda no disponible: firma incompatible.')end
 return {model=model,tick=function()
  local s=model.state()
  if not s then session,last=nil,nil;return end
  if last and s.phase=='drinking'and last.phase=='drinking'and
   (s.raw<last.raw or s.timer>last.timer)then session=nil end
  if not session and (s.phase=='prepare'or s.phase=='drinking')then
   session={points=s.points,cups=0,prepared=s.phase=='prepare'}
  end
  if session and s.phase=='drinking'then
   if not session.started then
    session.started=true
    if session.prepared or s.timer==80 then signal();speak('Ya. Pulsa A rápidamente.',true)
    else speak('Concurso de soda en curso.')end
   end
   if s.cups>session.cups then
    session.cups=s.cups
    speak(names[s.cups]..(s.cups==8 and '. Objetivo alcanzado.'or '.'))
    log('Soda: '..s.cups..' latas, contador '..s.raw..'.')
   end
   if s.timer<=16 and not session.warned and s.cups<8 then
    session.warned=true;speak('Queda poco tiempo.')
   end
  elseif session and session.started and (s.phase=='ending'or s.phase=='result')then
   if not session.ended then session.ended=true;signal();speak('Tiempo.',true)end
   if s.phase=='result'then session.score=s.cups end
  elseif session and session.started and session.ended and s.phase=='idle'and s.controlled and not s.dialogue then
   local score=session.score or session.cups
   speak('Resultado: '..score..(score==1 and ' lata.'or ' latas.'))
   if s.points>session.points then
    speak('Premio del concurso: '..(s.points-session.points)..' Puntos de Oro. Tienes '..s.points..'.')
   elseif score>=8 and s.points==200 then speak('Ya tienes el máximo de 200 Puntos de Oro.')end
   session=nil
  elseif s.phase=='idle'and session then
   session=nil
  end
  last=s
 end}
end
