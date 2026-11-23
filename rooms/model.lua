-- Pixel-space terrain probes for supported field maps. One tile = 16 pixels.
return function(memory)
 local model={radius=64}
 local folder=assert(debug.getinfo(1,"S").source:sub(2):match("^(.*[/\\])"))
 local profiles=dofile(folder.."profiles.lua")
 -- Number chests by their fixed profile order, never by visibility or contents.
 for _,profile in ipairs(profiles)do
  local number=0
  for _,feature in ipairs(profile.features)do
   if feature.treasure or feature.name:match('^Cofre')then
    number=number+1;feature.name='Cofre '..number
   end
  end
 end
 -- Keep a person's number while moving, disappearing or revisiting this room.
 local peopleNumbers={}
 local function contains(profile,x,y)
  local b=profile.bounds
  return x>=b[1] and x<b[3] and y>=b[2] and y<b[4]
 end
 local function byte(a)return memory.readbyte(a)end
 local function word(a)return byte(a)+256*byte(a+1)end
 local function present(profile,slot)
  if byte(0x7E1100+slot)>=128 then return false end
  -- A blinking actor can be active while drawing is temporarily disabled.
  if profile.processingPresence and profile.processingPresence[slot]then
   return byte(0x7E1000+slot)<128
  end
  return byte(0x7E1A81+slot)~=0
 end
 function model.guidance(s)
  if not s.profile then return nil end
  local text=s.profile.guidance
  for _,rule in ipairs(s.profile.guidanceWhenFlags or {})do
   local enabled=math.floor(byte(rule.address)/rule.mask)%2==1
   if enabled==(not rule.unset)then
    text=rule.text..(text and not rule.replace and ' '..text or '');break
   end
  end
  for _,rule in ipairs(s.profile.guidanceAreas or {})do
   local b=rule.box
   if s.x>=b[1] and s.x<b[3] and s.y>=b[2] and s.y<b[4]then text=rule.text;break end
  end
  for _,rule in ipairs(s.profile.guidanceWhenVisible or {})do
   if (not rule.minStory or byte(0x7F0000)>=rule.minStory)and present(s.profile,rule.entity)then
    return rule.text..(text and not rule.replace and ' '..text or ''),rule.sound
   end
  end
  return text
 end
 local shifts,offsets,signs={},{},{}
 for i=0,21 do shifts[i]=byte(0xC09BF5+i);offsets[i]=byte(0xC09C0B+i);signs[i]=byte(0xC09C21+i) end
 function model.state()
  local slot=word(0x7E0197)
  if slot>126 or slot%2~=0 then return nil end
  local s={x=word(0x7E1800+slot)/16,y=word(0x7E1880+slot)/16,slot=slot,
   location=word(0x7E0100),layer=byte(0x7E0155),dx=byte(0x7E1D2C),dy=byte(0x7E1D2D)}
  for _,profile in ipairs(profiles) do
   if s.location==profile.location and contains(profile,s.x,s.y) then
    s.profile=profile;s.room=profile.id;break
   end
  end
  s.inside=s.profile~=nil
  s.controlled=byte(0x7E011F)~=0 and byte(0x7E0129)==0 and byte(0x7E0162)==0
  s.enabled=s.inside and s.controlled
  return s
 end
 local function blocked(px,py,layer,cache)
  if px<0 or py<0 or px>=1024 or py>=1024 then return true end
  local tx,ty=math.floor(px/16),math.floor(py/16)
  local key=ty*256+tx
  local p=cache[key]
  if not p then p={byte(0x7E30C0+key),byte(0x7E7040+key)};cache[key]=p end
  local shape=math.floor(p[1]/4)
  local fx,fy=math.floor(px*16)%256,math.floor(py*16)%256
  local alt=false
  if shape==1 then alt=true
  elseif shape>=2 and shape<=23 then
   local mode=shape-2;local shift=shifts[mode]%128
   local value=math.floor(fx/2^shift)
   if shifts[mode]>=128 then value=255-value end
   value=(offsets[mode]+value-math.floor(fy/4))%256
   alt=(value>=128)~=(signs[mode]>=128)
  elseif shape>=24 then
   local mode=shape-2
   if mode==22 then alt=fx<128
   elseif mode==23 then alt=fy<128
   elseif mode==24 then alt=fx<128 and fy<128
   elseif mode==25 then alt=fx>=128 and fy<128
   elseif mode==26 then alt=fx>=128 and fy>=128
   elseif mode==27 then alt=fx<128 and fy>=128 end
  end
  local field=alt and math.floor(p[2]/8)%8 or p[2]%8
  local zone=field%4
  if field>=4 then return layer==3 end
  return zone==0 or (zone~=3 and zone~=layer and layer~=3)
 end
 model.blocked=function(x,y,layer)return blocked(x,y,layer,{})end
 local function distanceBox(x,y,b)
  local dx=math.max(b[1]-x,0,x-b[3]);local dy=math.max(b[2]-y,0,y-b[4])
  return math.sqrt(dx*dx+dy*dy),math.max(b[1],math.min(x,b[3])),math.max(b[2],math.min(y,b[4]))
 end
 model.profiles=profiles
 local directions={
   {name="left",dx=-1,dy=0,points={{-7,-7},{-7,-4},{-7,0}},pan=-1},
   {name="right",dx=1,dy=0,points={{7,-7},{7,-4},{7,0}},pan=1},
   {name="up",dx=0,dy=-1,points={{-7,-7},{0,-7},{7,-7}},pan=0},
   {name="down",dx=0,dy=1,points={{-7,0},{0,0},{7,0}},pan=0}
 }
 local function ray(s,dir,radius,cache)
   for step=0,radius,2 do
    local hit,hx,hy=false,nil,nil
    for _,p in ipairs(dir.points) do
     local x,y=s.x+p[1]+dir.dx*step,s.y+p[2]+dir.dy*step
     if blocked(x,y,s.layer,cache) then hit=true;hx=x;hy=y;break end
    end
    if hit then
     local kind="wall"
     for _,f in ipairs(s.profile and s.profile.features or {}) do
      if f.solid and hx>=f.box[1] and hx<=f.box[3] and hy>=f.box[2] and hy<=f.box[4] then kind="object";break end
     end
     return {distance=step,pan=dir.pan,kind=kind}
    end
   end
 end
 function model.contact(s,name)
  if not s.profile then return nil end
  local blocker=byte(0x7E01EB)
  if blocker<128 and blocker%2==0 and blocker~=s.slot and byte(0x7E1100+blocker)<128 then
   return {distance=0,kind="object",pan=name=="left" and -1 or name=="right" and 1 or 0}
  end
  for _,dir in ipairs(directions) do if dir.name==name then return ray(s,dir,2,{}) end end
 end
 function model.references(s)
  local result={}
  if not s.profile then return result end
  for i,f in ipairs(s.profile.features) do
   local available=not f.requires or math.floor(byte(f.requires.address)/f.requires.mask)%2==1
   -- Some native hole actors are drawn at (8,16) until excavation places them.
   if available and f.entityBounds and f.entity then
    local b=f.entityBounds
    local x,y=word(0x7E1800+f.entity)/16,word(0x7E1880+f.entity)/16
    available=x>=b[1] and x<b[3] and y>=b[2] and y<b[4]
   end
   if available and (not f.minStory or byte(0x7F0000)>=f.minStory)and (not f.entity or present(s.profile,f.entity))then
   local box=f.box
   if f.followEntity and f.entity then
    local x,y=word(0x7E1800+f.entity)/16,word(0x7E1880+f.entity)/16
    box={x-8,y-8,x+8,y+8}
   end
   local d,x,y=distanceBox(s.x,s.y,box)
   local name,sound=f.name,f.sound
   local switchPressed
   local indicator=f.switch or f.state
   if indicator then
    local enabled=math.floor(byte(indicator.address)/indicator.mask)%2==1
    if f.switch then switchPressed=enabled end
    name=name..', '..(enabled and (indicator.onText or 'pulsado') or (indicator.offText or 'sin pulsar'))
   end
   if f.treasure then
    local index=(f.treasure-0xF50000-word(0xF5F000))/4
    if index>=0 and index==math.floor(index) then
     local flags=byte(0x7F0001+math.floor(index/8))
    if math.floor(flags/2^(index%8))%2==1 then name=name..', abierto';sound=nil
    elseif f.closedText then name=name..', '..f.closedText end
    end
   end
   if f.collected and math.floor(byte(f.collected.address)/f.collected.mask)%2==1 then
    name=name..(name:match('^Cofre ')and ', abierto'or ', recogido');sound=nil
   end
   result[#result+1]={key='feature:'..i,name=name,sound=sound,distance=d,
    x=x,y=y,switchPressed=switchPressed,pan=math.max(-1,math.min(1,(x-s.x)/48))}
   end
  end
  local count=math.min(byte(0x7F2000),64)
  for i=0,count-1 do
   local slot=i*2;local status=byte(0x7E1100+slot)
   local expected=s.profile.personTypes and s.profile.personTypes[slot]
   if slot~=s.slot and ((status>=4 and status<=6)or expected==status or (s.profile.partyPeople and s.profile.partyPeople[slot] and status<4)) and present(s.profile,slot) then
    local x,y=word(0x7E1800+slot)/16,word(0x7E1880+slot)/16
    local d=math.sqrt((x-s.x)^2+(y-s.y)^2)
    local label=s.profile.people and s.profile.people[slot]
    if contains(s.profile,x,y) and label~=false then
     local rule=s.profile.friendlyWhen and s.profile.friendlyWhen[slot]
     local friendly=(s.profile.friendlyActors and s.profile.friendlyActors[slot]) or
      (rule and math.floor(byte(rule.address)/rule.mask)%2==1)
     local hostile=status>=5 and not friendly
     local sound=s.profile.personSounds and s.profile.personSounds[slot] or (status>=5 and "enemy" or "person")
     local name=label
     if hostile then name="Enemigo";sound="enemy"
     elseif not (s.profile.nonPeople and s.profile.nonPeople[slot]) then
      local numbers=peopleNumbers[s.profile.id]
      if not numbers then numbers={next=1};peopleNumbers[s.profile.id]=numbers end
      if not numbers[slot] then numbers[slot]=numbers.next;numbers.next=numbers.next+1 end
      name="Persona "..numbers[slot];sound="person"
     end
     result[#result+1]={key='person:'..slot,name=name,sound=sound,distance=d,x=x,y=y,
      pan=math.max(-1,math.min(1,(x-s.x)/48))}
    end
   end
  end
  return result
 end
 function model.relative(s,obj)
  local dx,dy=obj.x-s.x,obj.y-s.y
  local parts={}
  if math.abs(dy)>=8 then parts[#parts+1]=string.format('%.1f al %s',math.abs(dy)/16,dy<0 and 'norte' or 'sur')end
  if math.abs(dx)>=8 then parts[#parts+1]=string.format('%.1f al %s',math.abs(dx)/16,dx<0 and 'oeste' or 'este')end
  if #parts==0 then return 'Aquí cerca.'end
  return 'Distancia en casillas: '..table.concat(parts,', ')..'.'
 end
 function model.scan(s)
  local result={walls={},objects={}};local cache={}
  if not s.profile then return result end
  for _,dir in ipairs(directions) do result.walls[dir.name]=ray(s,dir,model.radius,cache) end
  for _,obj in ipairs(model.references(s))do
   if obj.sound and obj.distance<=model.radius then result.objects[#result.objects+1]=obj end
  end
  return result
 end
 return model
end
