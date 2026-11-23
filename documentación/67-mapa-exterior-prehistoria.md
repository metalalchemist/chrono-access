# 67. Orientación en el mapa exterior de 65 millones a. C.

Al salir de las chozas de Ioka, el lector anuncia el mapa exterior y permite
buscar destinos con los mismos controles de 600 y 1000 d. C. Esta entrega
corrige una omisión de la entrega 66: los interiores estaban cubiertos, pero
el lector exterior rechazaba el mapa 499 de la prehistoria.

## Uso

- Control+F5: consulta el destino seleccionado y su distancia.
- Control+F6: recorre los destinos disponibles.
- Control+F7: calcula una ruta a pie, con pasos de media casilla.
- A: entra cuando el juego detecta el punto de acceso.

Las chozas aparecen como «Choza del cacique de Villa Ioka», «Choza suroeste de
Villa Ioka», «Choza de intercambio de Villa Ioka» y «Choza de curación de Villa
Ioka». También se distingue el punto de reunión. Las dos entradas de la Selva
se diferencian como acceso norte y acceso sur. Los demás lugares conservan
sus nombres nativos. Solo se leen las entradas que publica el mapa del juego.

Las rutas usan la colisión nativa del mapa exterior. No cruzan interiores:
si una entrada está al otro lado de un bosque y no tiene camino exterior,
se anuncia que no se encontró una ruta a pie. En la captura desde Ioka, el
acceso norte de la Selva tiene ruta y el acceso sur no. Esto no impide recorrer
el bosque desde su entrada; describe el alcance del cálculo exterior.

## Comprobación

Se salió caminando de la choza de curación en una copia aislada y silenciada.
La RAM nativa confirmó el mapa 499 y las entradas de Ioka. Desde esa salida,
se siguió con botones la ruta calculada hasta la choza del cacique; A entró
al mapa 275. No se reubicó al jugador durante ese recorrido exterior.
La posición e historia iniciales de la copia sí fueron preparadas.

Después se volvió a cargar el lector actualizado en la copia aislada y se
comprobaron los avisos de salida, la presentación «65 millones antes de Cristo»
y las consultas Control+F5, F6 y F7. Evidencias en `test/future-check/`:
`ioka67-world-native-ram.bin`, `ioka67-chief-arrival-ram.bin`,
`ioka67-world-reader-ram.bin` y `ioka67-query-f5/f6/f7-ram.bin`.
El texto de los avisos se conserva en `ioka67-runtime.txt`; la ruta seguida,
en `ioka67-chief-route.txt`.

Siete pruebas específicas verifican nombres distintos, rutas sobre colisión
hasta las chozas, reunión, Monte Místico, Selva norte y Coto de Caza; los tres
atajos; avisos de entrada; cambios entre interior y exterior; y la llegada
nativa al cacique. Las otras rutas se comprobaron con las tablas de colisión;
no se presentan como recorridos realizados con control.

Validación: `python tools/chrono-access/test/validate-ioka-world67.py`.
Resultado: siete pruebas nuevas aprobadas. Suite general: 477 pruebas,
469 aprobadas y los mismos ocho fallos previos de `test_walk_trace.py`.
Sintaxis Lua aprobada; todos los hashes protegidos coinciden. La validación
global devuelve fallo por esos ocho tests anteriores.
Registro: `test/future-check/unit-validation-67.txt`. Se mantiene el inicio del
registro de caminata desactivado y sus ocho fallos de tests ya documentados.
Queda pendiente valorar los avisos con NVDA y recorrer el resto de destinos.

## Activación y reversión

Usa `recargar-lector.cmd` si el juego ya está abierto, o inicia el lector como
siempre. No hace falta cargar una partida para activar estos cambios.

Se modificaron `world-model.lua` (mapa 499 y nombres), `world-reader.lua`
(presentación de la época) y `room-reader.lua` (aviso al salir al mapa 499).
Se conserva el planificador existente de 600 y 1000 d. C. La numeración de
personas, los interiores y los minijuegos de la entrega 66 siguen activos.

Para revertir esta corrección, retira exclusivamente la admisión del mapa 499,
los nombres específicos de Ioka y su presentación de época/salida. Las copias
previas son `test/future-check/*-before67`; preserva cambios posteriores.
No se modificaron ROM, partidas, sonidos ni DLL. No se hicieron commits.
