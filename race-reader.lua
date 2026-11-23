-- Dialogues retain their native reader. This observes the race around them.
return function(memory,folder,say,log)
 local model=dofile(folder..'race-model.lua')(memory)
 local previous,watch,roundBet,winnerSaid,claim,roundWon=nil,false,nil,false,nil,false
 local function speak(t)if say then say(t,false)else log(t)end end
 if not model.supported then log('Carrera no disponible: firma incompatible.')end
 return {model=model,tick=function()
  local s=model.state()
  if not s then previous,watch,roundBet,winnerSaid,claim,roundWon=nil,false,nil,false,nil,false;return end
  local wasWatching=watch
  if s.bet>0 and (not previous or previous.bet~=s.bet)then
   watch=true;roundBet=s.bet
   speak('Elegiste a '..model.names[s.bet]..'.')
  end
  if s.near or s.pending or s.claiming then watch=true end
  if not watch then previous=s;return end
  local start=s.running and (not previous or not previous.running or not wasWatching)
  if start then
   winnerSaid=false;roundWon=false;roundBet=s.bet>0 and s.bet or nil
   if not s.pending and not claim then
    speak(previous and not previous.running and 'Empieza la carrera.'or 'Carrera en curso.')
   end
  end
  -- An idle winner belongs to the previous round, even if a new bet is set.
  if s.running and s.winner>0 and not winnerSaid and not s.pending and not claim then
   speak('Ganó '..model.names[s.winner]..'.');winnerSaid=true
  end
  if s.pending then roundWon=true end
  local ended=previous and previous.running and not s.running
  if s.pending and (not previous or not previous.pending)then
   speak('Tienes un premio de la carrera pendiente. Habla con el encargado para cobrar.')
  elseif ended and roundBet and not s.pending and not roundWon then
   speak('No acertaste. Apuesta ahora.')
  elseif not s.running and s.bet==0 and not s.pending and not claim and
   not s.claiming and not s.dialogue and (ended or not wasWatching)then
   speak('Puedes apostar ahora.')
  end
  if (previous and previous.pending and not s.pending)or
   (s.claiming and (not previous or not previous.claiming))then
   claim={points=previous and previous.points or s.points}
  end
  if claim and s.points>claim.points then
   local amount=s.points-claim.points
   speak('Premio de la carrera: '..amount..' Puntos de Oro. Tienes '..s.points..'.')
   claim=nil
  elseif claim and s.points==200 and not s.dialogue and s.controlled then
   speak('Ya tienes el máximo de 200 Puntos de Oro.');claim=nil
  end
  if not s.near and s.bet==0 and not s.pending and not claim then
   watch=false;roundBet=nil
  end
  previous=s
 end}
end
