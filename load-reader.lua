-- Title-screen loading only. Native cursor movement skips invalid SRAM slots.
return function(memory,say,log,data)
 if not data or not data.saveSlotSummary then return function()end end
 local function b(a)return memory.readbyte(a)end
 local checks={
  [0xC2E83F]={0x28,0x60},[0xC2E7C1]={0x28,0x60},
  [0xC2E635]={0x2C,0x1D,0x0D},[0xC2E657]={0x22,0xA3,0xFA,0xFF},
  [0xC2E65B]={0x80,0x37},[0xC2E65D]={0x20},[0xC2E694]={0xA9,0xF3},
 }
 for a,values in pairs(checks)do for i,v in ipairs(values)do
  if b(a+i-1)~=v then log('Pantalla de carga no disponible: firma incompatible.');return function()end end
 end end
 local function hook(a,f)memory.registerexec(a,1,f)end
 local active,opening=false,false
 local state,previous,pending=nil,nil,nil
 local events={}
 local function row()
  if not active then return end
  local slot=b(0x7E0054)
  if slot~=b(0x7E0079)then return end
  if slot<3 and b(0x7E0D49+slot)~=0 then
   state={key='slot:'..slot,text=data.saveSlotSummary(slot,'load')}
  elseif slot==3 then
   local plus=b(0x307FE2)~=0 and b(0x7E9392)==0x78
   state={key=plus and 'new-plus'or 'new',text=plus and
    'Nueva partida más. Esta modalidad todavía no tiene lectura completa.'or
    'Nueva partida. Confirmar empezará desde el principio.'}
  end
 end
 hook(0xC2E83F,function()active=true;opening=true;previous=nil;pending=nil;row()end)
 hook(0xC2E7C1,row)
 hook(0xC2E635,function()
  -- This hook is before the native skip-invalid pass: don't announce its cursor.
  if active then state=nil end
 end)
 hook(0xC2E657,function()
  local slot=b(0x7E0079)
  if active and slot<3 and b(0x7E0D49+slot)~=0 then pending=slot end
 end)
 hook(0xC2E65B,function()
  if type(pending)=='number'then events[#events+1]='Partida cargada de la ranura '..(pending+1)..'.'end
  active=false;opening=false;state=nil;previous=nil;pending=nil
 end)
 hook(0xC2E65D,function()
  if not active then return end
  state=nil
  if b(0x307FE2)~=0 and b(0x7E9392)==0x78 then
   -- Its next screen selects a source for New Game+, not a normal load.
   active=false;opening=false;pending=nil;previous=nil
  else pending='new'end
 end)
 hook(0xC2E694,function()
  if active and pending=='new'then events[#events+1]='Iniciando nueva partida.'end
  active=false;opening=false;state=nil;previous=nil;pending=nil
 end)
 return function()
  local lines=events;events={}
  local interrupt=#lines==0
  if opening then
   local valid={}
   for i=0,2 do if b(0x7E0D49+i)~=0 then valid[#valid+1]=i+1 end end
   lines[#lines+1]='Cargar partida. '..(#valid==0 and 'No hay partidas válidas guardadas. 'or
    'Ranuras disponibles: '..table.concat(valid,', ')..'. ')..
    'Usa arriba y abajo para elegir. Confirmar carga la partida seleccionada o inicia una nueva.'
   opening=false
  end
  if active and state and state.key~=previous then lines[#lines+1]=state.text;previous=state.key end
  if #lines>0 then say(table.concat(lines,' '),interrupt)end
  state=nil
 end
end
