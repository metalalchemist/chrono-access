-- Read-only, temporary walking diagnosis. Never record arbitrary keyboard text.
return function(memory,folder,say,log,observer,room,gamepad,worldState)
 local function b(a)return memory.readbyte(a)end
 local function w(a)return b(a)+256*b(a+1)end
 local allowed={'up','down','left','right','V','C','D','X','A','S','space','enter','control','alt','shift',
  'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12'}
 local buttons={'up','down','left','right','A','B','X','Y','L','R','start','select'}
 local function names(values,list)
  local result={};for _,key in ipairs(list)do if values[key]then result[#result+1]=key end end
  return #result>0 and table.concat(result,'+') or '-'
 end
 local enabled,held,frame=false,false,0
 local pending,bytes,started={},nil,false
 local previous,active,lastWalk,menu=false,false,-1000,false
 local lastKeys,lastSample,still,warned=nil,-1000,0,false
 local lastPosition=nil
 local path=folder..'caminar.log'
 local function flush()
  if #pending==0 then return end
  local file=io.open(path,'a')
  if not file then enabled=false;pending={};log('Registro de caminata: no se pudo abrir caminar.log.');return end
  if not bytes then bytes=file:seek('end')or 0 end
  local text=table.concat(pending,'\n')..'\n';pending={}
  if bytes+#text>4*1024*1024 then
   file:close();enabled=false;say('Registro de caminata lleno. Conservé el archivo para revisarlo.',false);return
  end
  local ok=file:write(text);file:close()
  if ok then bytes=bytes+#text else enabled=false;log('Registro de caminata: fallo de escritura.')end
 end
 local function emit(kind,s,keys,pad)
  if not started then
   pending[#pending+1]='SESION '..os.date('!%Y-%m-%dT%H:%M:%SZ')..' SOLO_CAMINATA version=2 limite=4MiB'
   started=true
  end
  local raw={};for a=0x7E00F0,0x7E00FB do raw[#raw+1]=string.format('%02X',b(a))end
  local bindings={};for a=0x7E2993,0x7E2998 do bindings[#bindings+1]=string.format('%02X',b(a))end
  pending[#pending+1]=string.format(
   'f=%d t=%d %s mapa=%d slot=%d x=%.3f y=%.3f capa=%d control=%02X dialogo=%02X bloqueo=%02X obstaculo=%02X teclado=%s mando=%s F0_FB=%s D1D_D1F=%02X,%02X,%02X boton_menu_2995=%02X config_2993_2998=%s',
   frame,os.time(),kind,w(0x7E0100),s and s.slot or w(0x7E0197),s and s.x or -1,s and s.y or -1,
   b(0x7E0155),b(0x7E011F),b(0x7E0129),b(0x7E0162),b(0x7E01EB),
   keys and names(keys,allowed)or 'no_registrado',pad and names(pad,buttons)or 'no_registrado',
   table.concat(raw,','),b(0x7E0D1D),b(0x7E0D1E),b(0x7E0D1F),b(0x7E2995),table.concat(bindings,','))
 end
 return {
  tick=function(keys)
   frame=frame+1
   local toggle=keys.control and keys.alt and not keys.shift and keys.F2 or false
   if toggle and not held then
    local nextEnabled=not enabled
    if enabled then flush()end
    enabled=nextEnabled;active=false;previous=false;still=0;warned=false;lastWalk=-1000;menu=false;lastKeys=nil
    say(enabled and 'Registro de caminata activado.' or 'Registro de caminata desactivado.',false)
   end
   held=toggle
   if not enabled then return end
   local screen,state
   if observer and observer.menuContext then screen,state=observer.menuContext()end
   local inMenu=screen~=nil
   local s=room and room.model.state()or nil
   local field=room and room.fieldActive()
   local world=worldState and worldState()
   if world then s={slot=-1,x=world.x,y=world.y,location=world.location,controlled=true};field=true end
   local pad=gamepad()
   local signature=names(keys,allowed)..'/'..names(pad,buttons)
   local direction=pad.up or pad.down or pad.left or pad.right
   local moved=s and previous and s.location==previous.location and
    (math.abs(s.x-previous.x)>0.02 or math.abs(s.y-previous.y)>0.02)
   local walking=not inMenu and field and s and s.controlled and (direction or moved)or false
   if walking then
    lastWalk=frame;lastPosition=s
    if not active or signature~=lastKeys or frame-lastSample>=30 then
     emit(active and 'CAMINATA' or 'INICIO_CAMINATA',s,keys,pad);lastSample=frame
    end
    still=direction and not moved and still+1 or 0
    if still>=60 and not warned then emit('INMOVIL_CON_DIRECCION',s,keys,pad);flush();warned=true end
    if moved then warned=false end
    lastKeys=signature
   elseif active then
    emit('FIN_CAMINATA',s,keys,pad);still=0;warned=false;flush()
   elseif not inMenu and not menu and lastPosition and signature~=lastKeys and
    ((field and s and s.controlled)or frame-lastWalk<=180)and (keys.V or keys.D or pad.A or pad.X)then
    emit('ACCION_TRAS_CAMINATA',field and s or lastPosition,keys,pad);flush()
   end
   if inMenu and not menu and lastPosition then
    emit('MENU_DESDE_CAMINATA pantalla='..screen..' estado='..state..' posicion=ultima_caminata',lastPosition,keys,pad);flush();menu=true
   elseif menu and not inMenu and field and s and s.controlled then
    emit('REGRESO_AL_CAMPO',s);flush();menu=false
   end
   lastKeys=signature;active=walking;previous=not inMenu and field and s and s.controlled and s or false
   if frame%60==0 then flush()end
  end,
  shutdown=flush
 }
end
