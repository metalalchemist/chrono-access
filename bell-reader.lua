-- Observe the game; never press buttons, change its speed or write game RAM.
return function(memory,folder,say,log,keys,cue)
 local model=dofile(folder..'bell-model.lua')(memory)
 local cfg=dofile(folder..'room-audio-config.lua')
 local lead=math.max(0,math.min(20,math.floor(tonumber(cfg.bellCueLeadSteps)or 8)))
 local previousKeys,session,last,armed,cued={},nil,nil,false,false
 local function speak(t)if say then say(t,false)else log(t)end end
 if not model.supported then log('Juego de la campana no disponible: firma incompatible.')end
 return {model=model,tick=function()
  local s=model.state()
  local pressed=keys and keys()or {}
  local modifier=pressed.control and not pressed.alt and not pressed.shift
  local earlier=modifier and pressed.F8 and not previousKeys.F8
  local later=modifier and pressed.F9 and not previousKeys.F9
  previousKeys=pressed
  if not s then session,last=nil,nil;armed,cued=false,false;return end
  local active=s.phase~='idle'
  local near=s.controlled and math.abs(s.x-88)<=64 and math.abs(s.y-592)<=64
  if (active or near)and (earlier or later)then
   local adjusted=math.max(0,math.min(20,lead+(earlier and 1 or -1)))
   if adjusted~=lead then
    lead=adjusted
    speak(earlier and 'Aviso de la campana adelantado.'or 'Aviso de la campana retrasado.')
    log('Anticipo de campana: '..lead..' pasos.');armed=false
   else speak('El aviso ya está en su límite.')end
  end
  if active and not session then
   session={points=s.points}
   speak(cfg.enabled and cue and 'Campana. Suelta A y pulsa al pitido. Puedes dejar pasar vueltas.'or
    'Juego de la campana. El aviso sonoro no está disponible.')
  end
  if s.phase=='swing' then
   local threshold=21-lead
   if not last or last.phase~='swing'or last.direction~=s.direction then
    armed=s.direction=='out'and s.counter<threshold;cued=false
   end
   if s.direction=='out'and armed and not cued and s.counter>=threshold then
    if last and s.counter-last.counter<=1 then
     if cfg.enabled and cue then
      cue('bell_timing')
      log('Aviso de campana: contador '..s.counter..', anticipo '..lead..'.')
     end
    end
    cued=true
   end
  elseif session and (s.phase=='return'or s.phase=='strike')and not session.hit then
   session.hit=s.counter;session.direction=last and last.direction or 'out'
   log('Golpe de campana registrado: '..s.counter..'.')
  elseif session and s.phase=='idle'and s.controlled and not s.dialogue then
   if session.hit then
    if s.points>session.points then
     speak('Premio: un Punto de Oro. Tienes '..s.points..'.')
    elseif session.hit>=21 and s.points==200 then
     speak('Buen golpe. Ya tienes el máximo de 200 Puntos de Oro.')
    elseif session.hit<21 then
     speak(session.direction=='out'and
      'Te adelantaste. Control F9 retrasa el aviso de la campana.'or
      'El golpe llegó tarde. Control F8 adelanta el aviso de la campana.')
    end
   end
   session=nil;armed,cued=false,false
  end
  last=s
 end}
end
