-- Context-gated optional challenge helpers. No input injection until requested.
return function(memory,folder,say,log,room,observer,setPad)
 local helpers={}
 if room then helpers[1]=dofile(folder..'arris-rat-challenge.lua')(memory,room.model)end
 local active,run,lastContext,held,releasing=nil,nil,nil,false,false
 local function neutral()
  return {A=false,B=false,X=false,Y=false,L=false,R=false,up=false,down=false,
   left=false,right=false,start=false,select=false}
 end
 local function context()
  for _,helper in ipairs(helpers)do if helper.detect()then return helper end end
 end
 local function inMenu()return observer and observer.menuContext and observer.menuContext()~=nil end
 local function stop(message)
  active=nil;run=nil;releasing=true
  if message then say(message,true)end
 end
 local api={}
 function api.tick(keys)
  if run and room and room.quietChase then room.quietChase(90)end
  if run and inMenu()then stop('Ayuda automática detenida al abrir un menú.')end
  local helper=context()
  local state=room and room.model.state()
  local field=room and room.fieldActive()and state and state.controlled and not inMenu()
  local id=helper and helper.id or nil
  if field and id~=lastContext then
   lastContext=id
   if helper and not run then
    say('Estás en un desafío: '..helper.name..'. Pulsa Control F2 para hacerlo automáticamente, o Control Mayúsculas F2 para escuchar las instrucciones.',false)
   end
  elseif not helper then lastContext=nil end
  local pressed=keys.control and not keys.alt and keys.F2 or false
  if pressed and not held then
   if keys.shift then
    if room and room.quietChase then room.quietChase(900)end
    if helper then say(helper.instructions,true)else say('Aquí no hay instrucciones de un desafío asistido.',true)end
   elseif run then stop('Ayuda automática cancelada. Conservas el control.')
   elseif helper and field and setPad then
    local message;run,message=helper.start()
    if run then active=helper;say('Ayuda automática iniciada. Control F2 para cancelar.',true)
    else say(message or 'No pude iniciar la ayuda aquí.',true)end
   else say('Aquí no hay un desafío disponible para la ayuda automática.',true)end
  end
  held=pressed
 end
 function api.before()
  if run then
   if inMenu()then stop('Ayuda automática detenida al abrir un menú.')
   else
    local ok,buttons,message=pcall(run.step)
    if not ok then log('Error en ayuda de desafío: '..tostring(buttons));stop('La ayuda encontró un problema y se detuvo.')
    elseif not buttons then stop(message)
    else
     local output=neutral();for key,value in pairs(buttons)do output[key]=value end
     setPad(output);return
    end
   end
  end
  if releasing and setPad then setPad(neutral());releasing=false end
 end
 function api.active()return run~=nil end
 function api.shutdown()if run then stop()end;if releasing and setPad then setPad(neutral());releasing=false end end
 return api
end
