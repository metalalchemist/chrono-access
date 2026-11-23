# 93. Volver al Epoch estacionado

Tras desembarcar, Control+F6 selecciona «Epoch estacionado» en el mapa
exterior de la época donde se encuentra. Control+F5 consulta dirección y
distancia; Control+F7 calcula una ruta a pie hasta su alcance. Cerca anuncia
«Aquí. Pulsa A para subir al Epoch». Sigue la posición nativa, sin fijar
un lugar de estacionamiento ni conservar un historial propio.

world-model.lua consulta C230EF–C23118: presencia bit 80 en 7E0294,
mapa 7E029F y coordenadas 7E0290/0292. Solo ofrece el transporte con el
grupo caminando, 027E=0. La rueda, el viaje y el modo a bordo quedan fuera
de la orientación a pie. El exterior 502, posterior a la caída de Zeal,
admite ahora el mismo modelo de referencias; no se certifican sus recorridos.

El alcance de A usa la comparación nativa C22345 con las dimensiones del
grupo en C2324C y las del Epoch en C23254. La ruta termina en ese alcance,
sin exigir la marca de entrada cubierta del terreno. Se comparte el cálculo
con el dáctil, conservando para este la tabla C2325C. world-reader.lua
anuncia ambos como transporte, con proximidad y teclas de consulta comunes.

Validación: 38 pruebas aprobadas en test_epoch93.py, test_dactyl91.py,
test_dactyl76.py, test_world.py, test_zeal75.py y test_epoch92.py.
Los seis casos nuevos comprueban presencia/época, movimiento de coordenadas,
ausencia a bordo, límites del alcance, ruta transitable, consulta y exterior
502. Se ejecutaron con Lua real y terreno capturado; las posiciones del
Epoch en esos casos son simuladas. No se abrió ni se operó un emulador en
esta entrega y no se certifica un nuevo abordaje nativo en el exterior.
La interacción del hangar y la rueda conservan la validación de 92.

Respaldo independiente: test/future-check/epoch93-before. Para revertir,
restaurar world-model.lua y world-reader.lua de ese respaldo y retirar
test_epoch93.py y esta nota. Conservar las entregas 91 y 92. Sin commits.
Disponible al siguiente inicio del lector. Al finalizar se detectó el juego
habitual abierto; la recarga automática no pudo identificar una consola Lua
única y no actuó. La inspección mostró inicialmente la versión 92 en el
hangar. No se confirmó que 93 se cargara en esa sesión ni se movió/cargó
la partida. Pendiente valoración con NVDA/control Nintendo.
