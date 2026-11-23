-- Extend the existing End of Time profile without shadowing its landmarks.
return function(profile)
 profile.people[72]=false
 profile.features[#profile.features+1]={
  name='Acceso al Epoch; entra caminando y confirma que quieres subir',
  sound='connection',box={624,392,640,408},entity=72,followEntity=true,
  entityBounds={600,360,664,432},minStory=174,
  requires={address=0x7F00AB,mask=128},
 }
 profile.guidanceWhenFlags=profile.guidanceWhenFlags or {}
 table.insert(profile.guidanceWhenFlags,1,{
  address=0x7F00AB,mask=128,
  text='El Epoch está disponible por la plataforma del este. Control F6 selecciona Acceso al Epoch y Control F5 orienta. Entra caminando en el acceso y confirma la decisión para subir.',
 })
 return profile
end
