-- Keyboard queries never inject game input. Hooks observe walking and flight.
return function(memory,say,log,charset,name,keys)
 local folder=assert(debug.getinfo(1,'S').source:sub(2):match('^(.*[/\\])'))
 local checks={
  [0xC23567]={0xAD,0x7C,0x02},[0xC232D7]={0xBF,0x00,0x7E,0x7E},
  [0xC2567A]={0xA2,0x00,0xF4},[0xC25680]={0xA9,0xC6},
  [0xC258DD]={0xBF,0x00,0xFA,0xDE},[0xC258E8]={0xA9,0xDE},
  [0xC2309E]={0xAD,0x7C,0x02},
  [0xC24DCF]={0xAD,0x7C,0x02},
  [0xC24E20]={0xBD,0x22,0x00,0x1D,0x24,0x00,0x1D,0x2E,0x00,0x29,0x07,0x07},
  [0xC24E63]={0xA9,0x34,0x85,0x03,0x64,0x04,0xA9,0x0E},
 }
 for a,values in pairs(checks)do for i,v in ipairs(values)do
  if memory.readbyte(a+i-1)~=v then log('Mapa exterior no disponible: firma incompatible.');return function()end end
 end end
 local model=dofile(folder..'world-model.lua')(memory,charset,name)
 local observed,flightSlot=false,nil
 memory.registerexec(0xC23567,1,function()observed=true end)
 -- Shared overworld dispatch also runs while the Dactyl task replaces walking.
 memory.registerexec(0xC2309E,1,function()observed=true end)
 memory.registerexec(0xC24DCF,1,function()
  flightSlot=memory.readbyte(0x7E004E)+256*memory.readbyte(0x7E004F);observed=true
 end)
 local previousKeys,active,selected,near,lastLocation,lastContext={},false,nil,nil,nil,nil
 local lastLanding,pendingLanding,landingFrames=nil,nil,0
 local function tick()
  local pressed=keys and keys()or {}
  local modifier=pressed.control and not pressed.alt and not pressed.shift
  local f5=modifier and pressed.F5 and not previousKeys.F5
  local f6=modifier and pressed.F6 and not previousKeys.F6
  local f7=modifier and pressed.F7 and not previousKeys.F7
  previousKeys=pressed
  local s=observed and model.state()or nil;observed=false
  local landing=model.landing(s,flightSlot);flightSlot=nil
  if not s then
   pendingLanding=nil;landingFrames=0
   local location=memory.readbyte(0x7E0100)+256*memory.readbyte(0x7E0101)
   if lastLocation and location~=lastLocation then active=false;selected=nil;near=nil;lastLocation=nil;lastContext=nil end
   return
  end
  local context=s.location..(s.flying and ':flight'or ':walk')
  local landed=lastContext==s.location..':flight'and not s.flying
  if lastContext and lastContext~=context then
   active=false;selected=nil;near=nil;lastLanding=nil;pendingLanding=nil;landingFrames=0
  end
  lastLocation=s.location;lastContext=context
  if landing==nil then pendingLanding=nil;landingFrames=0
  elseif landing~=pendingLanding then pendingLanding=landing;landingFrames=1
  else landingFrames=landingFrames+1 end
  local landingMessage=s.flying and model.landingText(landing)or ''
  local landingChanged=landing~=nil and landingFrames>=6 and landing~=lastLanding
  local exits=model.exits(s)
  if #exits==0 then
   if s.flying and (f5 or f6 or f7 or landingChanged)then say(landingMessage,false);lastLanding=landing end
   return
  end
  local index=1
  for i,e in ipairs(exits)do if e.key==selected then index=i;break end end
  local intro=not active
  if intro then selected=exits[1].key;index=1;active=true end
  if f6 then index=index%#exits+1;selected=exits[index].key end
  local e=exits[index]
  if intro then
   local year=s.location==498 and '2300' or s.location==497 and '600' or '1000'
   local era=s.location==503 and '1999 después de Cristo' or s.location==499 and '65 millones antes de Cristo' or s.location>=500 and '12000 antes de Cristo' or year..' después de Cristo'
   local mode=s.flying and ' Vuelo en dáctil.'or s.location==501 and ' Reino de Zeal, islas del cielo.'or s.location==500 and ' Superficie nevada.'or ''
   say((landed and 'Has aterrizado. 'or '')..'Mapa exterior de '..era..'.'..mode..' Control F5: consultar destino. Control F6: siguiente destino. Control F7: calcular ruta. '..
    'Destino: '..e.name..'. '..model.relative(s,e)..(s.flying and ' '..landingMessage or ''),false)
  elseif f5 or f6 then say('Destino: '..e.name..'. '..model.relative(s,e)..(s.flying and ' '..landingMessage or ''),false)
  elseif f7 then say(e.name..'. '..model.route(s,e)..(s.flying and ' '..landingMessage or ''),false)
  elseif landingChanged then say(landingMessage,false)end
  if s.flying and landing~=nil and (intro or f5 or f6 or f7 or landingChanged)then lastLanding=landing end
  local here=nil
  for _,entry in ipairs(exits)do
   if not s.flying and (model.atEntrance(entry)or((entry.kind=='dactyl'or entry.kind=='epoch')and model.canBoard(s,entry)))then here=entry end
   if here then break end
  end
  local nearby=here or (exits[1].distance<=64 and exits[1]or nil)
  local nearKey=nearby and nearby.key..(here and ':here'or ':near')or nil
  if not intro and not f5 and not f6 and not f7 and not landingChanged and nearKey and nearKey~=near then
   say((here and ((nearby.kind=='dactyl'or nearby.kind=='epoch')and 'Transporte: 'or 'Entrada: ')or 'Cerca: ')..nearby.name..'. '..model.relative(s,nearby),false)
  end
  near=nearKey
 end
 return tick,function()if observed then return model.state()end end
end
