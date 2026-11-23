# 91. Encontrar el dáctil estacionado en Prehistoria

El mapa exterior de 65 millones a. C. añade «Dáctil estacionado» como destino
cuando el transporte está disponible y el grupo camina. Control+F6 selecciona,
Control+F5 consulta dirección y distancia y Control+F7 calcula una ruta hasta
su alcance. Al estar cerca, anuncia «Aquí. Pulsa A para subir al dáctil».
La referencia desaparece al volar o cuando el dáctil no está disponible.

No hace falta estar exclusivamente al sur. El abordaje nativo acepta una
superposición del grupo con el transporte: menos de 8 píxeles de diferencia
horizontal; verticalmente, menos de 8 por el norte o 16 por el sur. Las
coordenadas iguales son válidas. El juego exige A. Acercarse desde el sur
facilita el alcance, pero no es una condición de orientación del personaje.

La presencia sigue C23159: bit 80 en 7E029E y mapa 499. Se usan las
coordenadas reales 7E029A/029C y el modo de caminata 027E=0. No se fija la
posición junto a Ioka ni a las Ruinas: sigue donde el juego haya dejado al
dáctil. Las dimensiones se leen de C2324C/C2325C, usadas por C2317D/C22345.
El destino es transporte, no una entrada del mapa. La búsqueda de ruta termina
en su alcance de abordaje y no exige la marca de entrada cubierta del terreno.
No se modifica el cálculo de rutas para las entradas normales.

En copia administrada silenciada se preparó un dáctil junto a Ioka en
(560,632) y el grupo al sur en (560,664). Pulsaciones nativas al norte
llevaron hasta Y640, con anuncio de abordaje. Un A inició el vuelo:
027E=3, bit 40 de 029E y coordenadas del dáctil (560,632). El lector anunció
el vuelo y que podía aterrizar. Capturas dactyl91-{prepared,in-range,flight}.
Esta preparación modifica solo RAM de la copia; no reproduce el recorrido
completo desde la expulsión del palacio ni certifica todas las islas.

test_dactyl91.py (4), test_dactyl76.py (9), test_ioka_world67.py (7),
test_world.py (6), test_zeal75.py (8): 34 pruebas aprobadas. Se comprueban
presencia, movimiento del transporte, límites del abordaje, ruta transitable,
selección/consulta, desaparición al volar y abordaje nativo. Las tres pruebas
iniciales de 91 fallaron por una ruta de fixture incorrecta; corregida antes
de los cuatro resultados finales. No se ejecutó la suite general.

Copia cerrada y tres entradas del arnés restauradas. Al intentar recargar
ya no había emulador habitual abierto; la herramienta lo detectó y no actuó.
Se aplica al siguiente inicio con iniciar-lector.cmd. Sin mover ni cargar
la partida del usuario.
Pendiente valoración con NVDA/control. Reversión: restaurar world-model.lua
y world-reader.lua desde test/future-check/dactyl91-before, retirar
test/test_dactyl91.py, test/prepare-dactyl91.lua, esta nota y el resumen 91.
Conservar mejoras 75/76 y entregas 86–90. Sin commits.
