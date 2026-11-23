-- No input injection, timers or decisions: report the game's own state.
return function(memory,folder,say,log,cue)
 local model=dofile(folder..'ioka-model.lua')(memory)
 local cfg=dofile(folder..'room-audio-config.lua')
 local weather,round,dancing=nil,nil,false
 local function speak(t,interrupt)if say then say(t,interrupt or false)elseif log then log(t)end end
 local function signal()if cfg.enabled and cue then cue('bell_timing')end end
 return {model=model,tick=function()
  local rain=model.weather()
  if rain==nil then
   -- Preserve the previous weather during native fades and battles on this map.
   if memory.readbyte(0x7E0100)~=35 or memory.readbyte(0x7E0101)~=1 then weather=nil end
  elseif model.free()and rain~=weather then
   speak(rain and 'Coto de Caza: está lloviendo.'or 'Coto de Caza: no está lloviendo.')
   weather=rain
  end
  local s=model.party()
  if not s then round=nil;dancing=false;return end
  if s.menu then return end
  if s.dance and not dancing and not s.dialogue then
   speak('Baile. X, Y, L, R y B cambian el movimiento. A termina.')
  end
  dancing=s.dance
  if s.active then
   if round and (round.ended or s.cups<round.cups or s.elapsed<round.elapsed)then round=nil end
   if not round then
    round={cups=s.cups,elapsed=s.elapsed}
    if s.elapsed<=1 and s.cups==0 then signal();speak('Ya. Pulsa A repetidamente para tomar sopa.',true)
    else speak('Carrera de sopa en curso. '..s.cups..' cuencos.')end
   elseif s.cups>round.cups then
    speak(tostring(s.cups)..(s.cups==1 and ' cuenco.'or ' cuencos.'))
   end
   round.cups=s.cups;round.elapsed=s.elapsed
   if s.elapsed>=140 and not round.warned then round.warned=true;speak('Queda poco tiempo.')end
  elseif round and not round.ended then
   round.ended=true;signal()
   speak('Fin de la ronda. '..s.cups..(s.cups==1 and ' cuenco.'or ' cuencos.'),true)
  end
 end}
end
