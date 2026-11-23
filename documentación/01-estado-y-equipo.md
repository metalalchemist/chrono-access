# Lectura de estado y equipo

[Continuar el proyecto](../continuar%20chrono.md) · [Índice documental](README.md)

Las notas siguientes conservan la evidencia y el alcance de cada etapa. Los pendientes de una etapa pueden estar resueltos en documentos posteriores; el estado actual se consulta en el documento de continuación.

Las rutas de código escritas entre comillas invertidas parten de `D:\gt\vemovie`, salvo indicación distinta.

Código y evidencia relacionados:

- [status-reader.lua](../tools/chrono-access/status-reader.lua)
- [test_status.py](../tools/chrono-access/test/test_status.py)

## Ampliación del 26 de octubre de 2026: estado y equipo

Se añadió `tools/chrono-access/status-reader.lua`, conectado al callback único de
`lector-snes9x.lua`. Lee el cursor del menú principal y anuncia sus seis opciones.
En Equipo y estado anuncia nombre, nivel, HP/MP actuales y máximos, ataque,
defensa, fuerza, velocidad, puntería, evasión, magia, vitalidad, defensa mágica,
experiencia, experiencia restante, las cuatro piezas equipadas, dinero y tiempo.
Las ranuras de equipo anuncian su nombre y la pieza equipada al cambiar el cursor.
Esto sustituye la anterior falta total de lectura de esa pantalla; no implementa
el contenido de Objetos, Técnicas, Configuración, Grupo, Guardar ni combate.
La lista para elegir una pieza nueva y la comparación de equipo siguen pendientes.

La captura del usuario mostraba el menú principal con el panel de Crono y una
ventana de iconos superpuesta, no una conversación. Se corrigió una descripción
inicial: el dinero visible era **400 G**, no 4000. El registro más reciente confirma
el nombre **Lucca**, a diferencia del anterior ensayo con Aucca.

Se contrastó la pantalla real con la lectura, incluyendo valores distintos en una
copia oculta y silenciada: nivel 12, HP 321/999, MP 27/80, EXP 65537, siguiente
nivel 456, dinero 123456. `test/status-check/different.png` muestra esas cifras y
`test/status-check/runtime-reader.log` registra su lectura. Esos valores se inyectaron
solo en la copia de prueba; no representan progreso real ni la partida del usuario.
`test/status-check/live-ram.bin` y `live.png` conservan el estado inicial del menú.

Los hooks verificados son C29A23 (principal), C29C42 (personaje de equipo),
C29C79 (ranuras), C29CB5 (lista) y C2A271 (fin del panel de datos). Se comprueban
firmas antes de instalarlos. No usar el estado 0067/0068 al final del fotograma:
el planificador lo reutiliza entre tareas. Leer al inicializar el menú produjo
datos residuales de Magus; se corrigió esperando las rutinas de entrada activas.
El buffer de personaje está en 7E9A90, nivel +12, EXP de 24 bits +13,
experiencia restante +2B, estadísticas calculadas +36. Los nombres de piezas se
obtienen del banco CC con punteros en 7E7D00: once bytes, icono más diez glifos.
Tiempo: minutos 0402+10*0403, horas 0404+10*0405. No usar un terminador para
buscar el final de cada nombre de equipo: concatenaría piezas posteriores.

Validación: `python tools/chrono-access/test/test_status.py` (4 aprobadas),
`test/test_reader.py` (13), `test/test_room.py` (6), `test/test_house.py` (5), 28 en total.
La integración usó `test/check-status-runtime.lua`, que sustituye la voz por registro
y silencia el audio nativo, y verificó navegación principal y ranuras en Snes9x.
`test/discover-status.lua` y `test/check-status-runtime.lua` son herramientas aisladas que
inyectan botones: **nunca cargarlas en la partida del usuario**. La copia de
investigación se cerró y su autorun volvió a `test/discover-room.lua` al terminar.

Para activar en una partida abierta, usar `recargar-lector.cmd`; para una sesión
nueva, el acceso normal carga automáticamente el módulo actualizado. No se ha
confirmado todavía la experiencia del usuario con esta lectura. Reversión:
retirar las dos llamadas de carga/tick de `tickStatus` en `lector-snes9x.lua`
y el módulo `status-reader.lua`; los lectores de diálogo y orientación son
independientes. No se hicieron commits; `tools/` sigue ignorado por Git.

Actualizado el 26 de octubre de 2026, después de ampliar estado, equipo, Objetos y Técnicas. Las secciones superiores describen las ampliaciones más recientes; las inferiores conservan el contexto de orientación y las pruebas anteriores. Este es el documento principal para retomar en otra conversación. El prototipo funciona con **Snes9x + Lua 5.1 + módulos nativos C++ + Prism/NVDA**. Python se usa para desarrollo y pruebas; no hace falta para jugar.

