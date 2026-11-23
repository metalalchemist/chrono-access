-- Observe native save UI and SRAM completion; never write memory or press buttons.
return function(memory,say,log,charset,data)
 if not data then return function()end end
 local function b(a)return memory.readbyte(a)end
 local function w(a)return b(a)+256*b(a+1)end
 local checks={
  [0xC2CF00]={0x2C,0x1D,0x0D},[0xC2CFF9]={0x28,0x60},
  [0xC2CF64]={0x2C,0x1D,0x0D},[0xC2D4D3]={0x28,0x60},
  [0xC2CF37]={0xA9,0x19},[0xC2CF55]={0x20,0x1E,0x82},
  [0xC2CF88]={0x20,0xC2,0xEA},[0xC2CEEC]={0x64,0x67},
  [0xC2D509]={0x2C,0x1D,0x0D},
  [0xC2D296]={0x08,0xE2,0x20},[0xC2D2C2]={0x28,0x60},
  [0xC2D0E5]={0x08,0xE2,0x20},
  [0xFFFBE1]={0x00,0x60,0x00,0x6A,0x00,0x74},
 }
 for a,values in pairs(checks)do for i,v in ipairs(values)do
  if b(a+i-1)~=v then log('Menú Guardar no disponible: firma incompatible.');return function()end end
 end end
 local function hook(a,f)memory.registerexec(a,1,f)end
 local chapters,capture,parts={},nil,{}
 hook(0xC2D296,function()capture=b(0x7E0079);parts={}end)
 hook(0xC2D2C2,function()
  if capture and capture<3 then chapters[capture]=table.concat(parts):gsub('%s+',' '):match('^%s*(.-)%s*$')end
  capture=nil;parts={}
 end)
 local function chapterText()
  return capture and capture<3 and b(0x7E0212)==0x7E and w(0x7E0210)>=0x7000 and w(0x7E0210)<0x7600
 end
 data.saveGlyph=function(code)
  if chapterText()and #parts<256 then parts[#parts+1]=charset.chars[code]or '?'end
 end
 data.saveControl=function(code)
  if chapterText()and (code==5 or code==6)then parts[#parts+1]=' 'end
 end
 local function summary(slot,purpose)
  local text='Ranura '..(slot+1)..' de 3. '
  if b(0x7E0D49+slot)==0 then return text..'Sin partida válida. '..
   (purpose=='load'and 'No se puede cargar.'or 'Confirmar guardará aquí directamente.')end
  local a=0x300000+w(0xFFFBE1+slot*2)
  local party={}
  for i=0,2 do
   local id=b(a+0x580+i)
   if id<7 then
    local name={}
    for j=0,5 do
     local code=b(a+0x5B0+id*6+j)
     if code==0 or code==255 then break end
     name[#name+1]=charset.chars[code]or '?'
    end
    party[#party+1]=table.concat(name)..'. Nivel '..b(a+0x200+id*80+0x12)..'.'
   end
  end
  local hours=b(a+0x5E7)+10*b(a+0x5E8)
  local minutes=b(a+0x5E5)+10*b(a+0x5E6)
  return text..'Ocupada. '..(chapters[slot]and chapters[slot]~=''and chapters[slot]..'. 'or '')..
   table.concat(party,' ')..string.format(' Tiempo %d horas y %d minutos. ',hours,minutes)..
   (purpose=='load'and 'Confirmar cargará esta partida.'or 'Confirmar abrirá la pregunta para sobrescribir.')
 end
 data.saveSlotSummary=summary
 local state,previous,pending=nil,nil,nil
 local open=false
 hook(0xC2D0E5,function()state=nil;previous=nil;open=false end)
 local events={}
 local epoch=data.menuEpoch
 local function slots()
  local slot=b(0x7E0054)
  if slot<3 and slot==b(0x7E0079)then state={key='slot:'..slot,text=summary(slot)}end
 end
 hook(0xC2CF00,slots);hook(0xC2CFF9,slots);hook(0xC2D509,slots)
 local function prompt()
  local slot,choice=b(0x7E0079),b(0x7E0054)
  if slot<3 and (choice==3 or choice==4)then
   state={key='prompt:'..slot..':'..choice,text='¿Sobrescribir la partida de la ranura '..(slot+1)..'? '..
    (choice==3 and 'Sí. Confirmar reemplazará la partida anterior.'or 'No. La partida anterior se conservará.')}
  end
 end
 hook(0xC2CF64,prompt);hook(0xC2D4D3,prompt)
 hook(0xC2CF37,function()local slot=b(0x7E0079);pending=slot<3 and slot or nil end)
 hook(0xC2CF55,function()
  local slot=pending;pending=nil
  if slot and b(0x307FE0)==slot and w(0x307FF8+slot*2)==0xE41B then
   events[#events+1]='Partida guardada en la ranura '..(slot+1)..'.'
   state=nil;previous='slot:'..slot
  end
 end)
 hook(0xC2CF88,function()
  events[#events+1]='Guardado cancelado. La partida anterior se conserva.'
  state=nil;previous='slot:'..b(0x7E0079)
 end)
 hook(0xC2CEEC,function()
  events[#events+1]='No se puede guardar aquí. Busca un punto de guardado o sal al mapa exterior.'
  state=nil;previous=nil
 end)
 return function()
  if epoch~=data.menuEpoch then
   epoch=data.menuEpoch;state=nil;previous=nil;pending=nil;open=false
  end
  local lines=events;events={}
  local interrupt=#lines==0
  if state and state.key~=previous then
   if not open then lines[#lines+1]='Guardar partida. Usa arriba y abajo para elegir ranura. Confirmar guarda; cancelar vuelve al menú.';open=true end
   lines[#lines+1]=state.text;previous=state.key
  end
  if #lines>0 then say(table.concat(lines,' '),interrupt)end
  state=nil
 end
end
