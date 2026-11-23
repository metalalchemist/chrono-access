-- Observe native tent rounds. Speech and cues never change game memory/input.
return function(memory,folder,say,log,keys,cue)
 local model=dofile(folder..'horrors-model.lua')(memory)
 local session,last,previousKeys=nil,nil,{}
 local frame,lastDanger=0,-999
 local function speak(t,interrupt)if say then say(t,interrupt==true)else log(t)end end
 local function newBits(now,before)
  for i=0,7 do if math.floor(now/2^i)%2==1 and math.floor(before/2^i)%2==0 then return true end end
  return false
 end
 local function prizes(s)
  if not session then return end
  local first=session.initial
  if newBits(s.toys%128,first.toys%128)and not session.poyozo then
   session.poyozo=true;speak('Premio recibido: muñeco Poyozo.')
  end
  if newBits(s.clones,first.clones)and not session.clone then
   session.clone=true;speak('Premio recibido: clon.')
  end
  if s.toys>=128 and first.toys<128 and not session.cat then
   session.cat=true;speak('Premio recibido: un gato.')
  end
  if s.food>first.food and not session.food then
   session.food=true;speak('Comida para gatos recibida: '..(s.food-first.food)..'.')
  end
 end
 return {model=model,tick=function()
  frame=frame+1
  local pressed=keys and keys()or {}
  local query=pressed.control and not pressed.alt and not pressed.shift and pressed.F10 and not previousKeys.F10
  previousKeys=pressed
  local s=model.state()
  if not s then session,last=nil,nil;return end
  if query then speak(model.status(s),true)end
  if s.phase~='lobby'and not session then
   session={initial=last or s,phase=s.phase}
  end
  if session and last and s.points<last.points then
   speak('Pagados '..(last.points-s.points)..' Puntos de Oro. Quedan '..s.points..'.')
  end
  if session and s.result and not session.result then
   session.result=s.result
   speak(s.result=='win'and 'Reto superado.'or 'Reto perdido.')
  end
  -- Prize flags and food count are the actual reward, not a predicted win.
  prizes(s)
  if session and s.phase=='mimic'and last and last.ready and not s.ready and
   last.round==s.round and s.response==s.cue and not s.result and
   session.confirmedRound~=s.round then
   session.confirmedRound=s.round
   if cue then cue('bell_timing')end
  end
  if s.phase=='guess'and s.ready and s.controlled and not s.result and not s.dialogue and not s.menu then
   if not session.guess then session.guess=true;speak(model.guess(s))end
  elseif s.phase=='mimic'and s.ready and not s.result and not s.dialogue and not s.menu then
   if not last or not last.ready or last.round~=s.round or last.phase~='mimic' then
    -- Short, interrupting cues keep within the game's shrinking response window.
    local moves={[0]='R',[1]='L',[2]='A',[3]='Y'}
    speak(moves[s.cue],true)
   end
  elseif s.phase=='monsters'and s.ready and not s.result and not s.menu then
   if not session.started then
    session.started=true
    speak('Monstruos. Piedras a la izquierda, centro y derecha; mira al norte y pulsa A. Control F10 consulta el estado.')
   end
   local lightNew=s.light and (not last or not last.light)
   if lightNew then
    if cue then cue('bell_timing')end
    speak('Luz azul a la izquierda. Pulsa A al llegar.',true)
   end
   if last and s.captured~=last.captured then
    for i,a in ipairs(s.monsters)do
     if math.floor(s.captured/2^(i-1))%2==1 and math.floor(last.captured/2^(i-1))%2==0 then
      speak('Monstruo '..a.name..' encerrado.')
     end
    end
   end
   if not s.light and frame-lastDanger>=90 then
    local danger
    for i,a in ipairs(s.monsters)do
     if a.visible and math.floor(s.captured/2^(i-1))%2==0 and
      (not danger or a.y>danger.y)then danger=a end
    end
    if danger and danger.y>=128 then
     speak(danger.name..(danger.y>=144 and ': peligro.'or ': se acerca.'),true)
     lastDanger=frame
    end
   end
  end
  -- A fresh lobby after a round can start another session without stale cues.
  if s.phase=='lobby'and s.controlled and not s.dialogue and not s.menu then session=nil end
  last=s
 end}
end
