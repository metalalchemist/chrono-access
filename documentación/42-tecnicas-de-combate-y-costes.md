# Técnicas de combate: categoría, fila completa y costes de PM

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

El menú de combate anuncia «Técnicas individuales», «Técnicas dobles» o
«Técnicas triples» junto al nombre de la técnica seleccionada. Los encabezados
son filas que el cursor nativo salta: se leen al seleccionar una técnica de
esa categoría. No se añaden opciones ni movimientos de cursor.

Se corrigen también costes como «Lucca: 255 de magia» y los costes de técnicas
dobles atribuidos al personaje equivocado. Fogonazo cuesta 1 PM de Lucca;
Rem.Llamas muestra 2 PM de Crono y 1 PM de Lucca, también desde el menú de Lucca.
Los PM disponibles y la disponibilidad proceden del estado actual del combate.

## Causa y cambio

`battle-model.lua` interpretaba el primer coste como el del personaje que tenía
el turno y usaba los nibbles de `$9EE7` para asociar los demás. El código nativo
`C10F7E` y las comparaciones siguientes muestran que `$9EE6`, `$9EE8` y `$9EE9`
corresponden siempre a las posiciones 0, 1 y 2 del grupo. Los valores con bit
alto son campos vacíos y no deben anunciarse como un coste de 255.

`battle-reader.lua` capturaba la técnica en `C1103D`, retorno compartido por
varias rutinas, incluido el mantenimiento anterior a la actualización de la
fila. Ahora la captura en `C10EB7`, después de copiar la selección y sus costes.
La firma de esa instrucción se comprueba contra la ROM. Los objetos conservan
su observación anterior. Los encabezados dobles/triples se obtienen de los
códigos FC/FD de la tabla de filas `$94D0 + CCF38C[slot]`.

## Pruebas y evidencia

**324 pruebas aprobadas**, incluidas 21 de combate. Cuatro pruebas nuevas
comprueban: costes con Lucca como personaje activo, ausencia del falso 255,
captura posterior a la actualización completa, categorías y estados nativos.
El caso de categorías triples se comprueba con memoria simulada; no se ha
ejecutado una técnica triple en el juego.

`test/battle-tech-check/reader-validation.txt` conserva ejecución real del
motor con Crono y Lucca, navegación a individuales/dobles, cambio de personaje
y cancelación. `lucca-single-ram.bin`, `lucca-double-ram.bin` y
`double-announced-ram.bin`, con sus capturas GD, se reutilizan como regresiones.
La suite completa está en `test/battle-tech-check/unit-validation.txt`.

El ensayo fue aislado y silenciado. Se copiaron registros de personajes de una
captura antigua, se inyectaron una carga de sala y la petición nativa de combate
y se ampliaron los PV del grupo de prueba para poder navegar sin perder el
combate. Esto verifica el menú del motor, no un recorrido legal de la historia.
El intento inicial de cargar una copia del estado 000 no restauró la partida;
las capturas válidas son las posteriores a la preparación de los registros.

## Activación y reversión

Al intentar observar la partida habitual, el emulador ya estaba cerrado; no se
recargó. Se restauró su autorun sin el observador temporal. La copia de pruebas
quedó cerrada. No se enviaron botones, cargaron estados ni alteraron datos de
la partida habitual. La corrección se cargará al próximo inicio normal.

El límite de reversión son la asociación y exclusión de costes, la categoría
en `battle-model.lua` y el punto de captura de técnicas en `battle-reader.lua`.
Sus pruebas están en `test/test_battle.py`. No requiere modificar audio,
diálogos, técnicas aprendidas ni controles del juego. Falta valoración con NVDA.
