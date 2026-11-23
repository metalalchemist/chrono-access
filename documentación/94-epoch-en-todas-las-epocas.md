# 94. Localizar el Epoch en las épocas y el Fin del Tiempo

Control+F6 selecciona «Epoch estacionado» y Control+F5 consulta dirección y
distancia en los mapas exteriores de 1000, 600, 2300, Prehistoria y 12000
a. C., incluida la superficie posterior a la caída de Zeal. Control+F7
calcula una ruta a pie hasta el alcance del botón A. Se conserva el hangar
de la Bóveda Bedel de la entrega 92.

La referencia usa presencia, mapa y coordenadas nativas, como en 93. Solo
aparece donde el juego haya dejado el vehículo y cuando el grupo camina.
No se inventan estacionamientos simultáneos en todas las épocas. El exterior
503 de 1999 también admite esa referencia si el estado nativo permite
caminar y deja allí el Epoch; se corrige su anuncio de época. Esto no
certifica sus escenas interiores ni un desembarque en 1999.

En el Fin del Tiempo, Control+F6 selecciona «Acceso al Epoch» y Control+F5
orienta. Se entra caminando en el acceso de la plataforma oriental y se
confirma «¿Subir a bordo? Sí / No». No se exige pulsar A para iniciar ese
diálogo: es el evento de contacto del actor 72, función 2.

rooms/profiles/epoch-time.lua amplía el perfil existente de 464 al registrarlo
en rooms/profiles.lua. Conserva pilares, anciano, cubetas y escaleras.
La referencia sigue al actor 72, alrededor de (632,400), y exige historia
174 o posterior y bit 80 en 7F00AB. El juego pone esa marca al desembarcar
desde el Epoch y la quita al volver a subir. El controlador 72 deja de
anunciarse como persona.

En copia administrada silenciada se prepararon historia 174, mapa 464,
7F00AB=80 hexadecimal y 7F00CD=6, con una captura previa del grupo. Desde
(616,368), bajar hasta Y400 y caminar al este activó la decisión al llegar
a X618. A sobre «Sí» llevó al mapa 473, con «¡A toda máquina! / Desembarcar».
El lector anunció la nueva orientación y el mezclador real trabajó silenciado.
Capturas epoch94-platform-free, epoch94-step, epoch94-prompt y epoch94-board
en test/future-check. Preparación de RAM solo en la copia; no reproduce
todos los viajes anteriores ni prueba nuevos recorridos nativos exteriores.

Validación: 57 pruebas y 15 subcasos aprobados con test_epoch94.py,
test_epoch93.py, test_epoch92.py, test_dactyl91.py, test_dactyl76.py,
test_world.py, test_zeal75.py, test_time_medina.py y test_room.py.
Los casos exteriores verifican las ocho ubicaciones 496–503 con posiciones
simuladas sobre datos capturados, presencia y exclusión de otras épocas.
Se conservan las pruebas de ruta y de dáctil de 93/91.

Copia de pruebas cerrada y entradas del arnés restauradas. Al finalizar ya
no estaba abierto el emulador habitual; no se aplicó una recarga en vivo.
Se carga al siguiente inicio con iniciar-lector.cmd. Sin mover ni cargar la
partida habitual. Cambios ajenos de VeMovie conservados. Sin commits.

Respaldo: test/future-check/epoch94-before. Para revertir, restaurar
rooms/profiles.lua, world-model.lua y world-reader.lua del respaldo y retirar
rooms/profiles/epoch-time.lua y test_epoch94.py. Conservar entregas 91–93.
Pendiente valoración con NVDA/control Nintendo.
