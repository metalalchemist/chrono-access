-- Observe the native Settings tasks; never infer selection from pressed buttons.
return function(memory,say,log)
 local function b(a)return memory.readbyte(a)end
 local signatures={
  [0xC2BFFD]={0x28,0x60},
  [0xC2BF6D]={0x20,0x84,0xE9},
  [0xC2BF9F]={0x20,0x84,0xE9}
 }
 for a,bytes in pairs(signatures)do for i,v in ipairs(bytes)do
  if b(a+i-1)~=v then
   log('Configuración no disponible: firma incompatible.')
   return function()end
  end
 end end
 local seen=false
 for a in pairs(signatures)do memory.registerexec(a,1,function()seen=true end)end
 local names={'Estéreo','Modo de batalla','Guardar cursor del menú',
  'Guardar cursor de batalla','Guardar cursor de ítems','Velocidad de batalla',
  'Color de la ventana','Tipo de panel','Pad de control','Información de ítems'}
 local offsets={0,3,2,7,8,11,6,4,1,9}
 local actions={'Aceptar','Cancelar','Menú','Correr','Mapa','Cambiar'}
 local buttons={[128]='A',[64]='X',[32]='L',[16]='R',[8]='B',[4]='Y',[2]='Select',[1]='Start'}
 local function button(v)return buttons[v]or 'asignación desconocida' end
 local function number(v,limit)
  if v>=limit then return 'valor desconocido' end
  return (v+1)..' de '..limit
 end
 local previous,missing=nil,0
 return function()
  if not seen then
   missing=missing+1
   if missing>3 then previous=nil end
   return
  end
  seen=false;missing=0
  -- $68 is task-local and another task overwrites it before frame end.
  -- The config cursor's disjoint ranges remain stable for each submode.
  local row,cursor=b(0x7E0417),b(0x7E0054)
  local key,text
  if row==8 and cursor>=15 and cursor<=20 then
   local index=cursor-15
   if not actions[index+1]then return end
   local value=b(0x7E0F00+index)
   local pending=value~=b(0x7E0408+index)
   text='Asignación de botones. '..actions[index+1]..'. Botón '..button(value)..'.'
   if pending then text=text..' Cambio en edición.' end
   key='buttons:'..index..':'..value..':'..tostring(pending)
  elseif row==7 and cursor>=12 and cursor<=14 then
   local value=b(0x7E0D8A)
   local labels={[0]='Sin panel',[1]='Tipo 1',[2]='Tipo 2'}
   text='Tipo de panel. '..(labels[value]or 'valor desconocido')..'. Confirma o cancela para volver.'
   key='panel:'..value
  elseif row==10 or row==11 then
   local value=b(row==10 and 0x7E0D8B or 0x7E0D90)
   text=(row==10 and 'Velocidad de batalla. 'or 'Velocidad de mensajes. ')..
    number(value,8)..'. 1 es más rápido; 8 más lento. Izquierda y derecha ajustan; confirma o cancela para volver.'
   key='speed:'..row..':'..value
  elseif names[row+1]then
   local value=b(0x7E0D86+offsets[row+1])
   local mode=''
   if row==0 then text=value==0 and 'Sí' or 'No'
   elseif row==1 then text=value==1 and 'Activo' or 'Lento'
   elseif row==2 or row==3 or row==4 or row==9 then text=value==1 and 'Sí' or 'No'
   elseif row==5 then
    text=number(b(0x7E0D8B),8)..'. Mensajes: '..number(b(0x7E0D90),8)..'. Confirma para editar'
   elseif row==6 then
    text='Estilo '..number(value,8)
    mode=b(0x7E0F0F)~=0 and 'edit' or ''
    text=text..(mode=='edit' and '. Izquierda y derecha cambian el estilo; confirma o cancela para volver' or '. Confirma para editar')
   elseif row==7 then text=({[0]='Sin panel',[1]='Tipo 1',[2]='Tipo 2'})[value]or 'valor desconocido'
   elseif row==8 then text=value==0 and 'Normal' or 'Personalizado'
   end
   text='Configuración. '..names[row+1]..'. '..text..'.'
   key='row:'..row..':'..value..':'..mode
   if row==5 then key=key..':'..b(0x7E0D8B)..':'..b(0x7E0D90)end
  else return end
  if key~=previous then say(text);previous=key end
 end
end
