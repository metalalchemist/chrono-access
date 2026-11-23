# Orientación del mapa exterior

[Continuar el proyecto](../continuar%20chrono.md) · [Índice documental](README.md)

Las notas siguientes conservan la evidencia y el alcance de cada etapa. Los pendientes de una etapa pueden estar resueltos en documentos posteriores; el estado actual se consulta en el documento de continuación.

Las rutas de código escritas entre comillas invertidas parten de `D:\gt\vemovie`, salvo indicación distinta.

Código y evidencia relacionados:

- [world-reader.lua](../tools/chrono-access/world-reader.lua)
- [world-model.lua](../tools/chrono-access/world-model.lua)
- [test_world.py](../tools/chrono-access/test/test_world.py)
- [world-check/entry-validation.txt](../tools/chrono-access/test/world-check/entry-validation.txt)

## Ampliación: mapa exterior de 1000 d. C., 26 de octubre de 2026

El usuario está fuera de la casa y usa NVDA. `world-reader.lua` y
`world-model.lua`, integrados en `lector-snes9x.lua`, añaden lectura del mapa
01F0 cuando se camina a pie. Al entrar o recargar anuncian el destino más
cercano. Control+F5 consulta el destino seleccionado; Control+F6 recorre las
entradas agrupadas por nombre y destino; Control+F7 calcula una ruta a pie.
F5/F6/F7 solas cargan estados en Snes9x: no recomendarlas como consultas.
Los atajos nuevos requieren Control y rechazan Alt/Shift. No modifican mando,
configuración, ROM o partidas. Los avisos de proximidad y entrada son automáticos.

La distancia se expresa en casillas de 16 píxeles; es diferencia de posición,
no una ruta. Las rutas usan pasos de 8 píxeles, media casilla, y colisiones
reales. El usuario mueve el personaje; no hay conducción automática ni sonidos
de paso nuevos. Puede repetir Control+F7 para recalcular desde donde se encuentre.
Al llegar al punto válido se anuncia «Entrada: … Aquí. Pulsa A para entrar».
A es el botón del mando de Snes9x; conservar el mapeo habitual del usuario.

Datos contrastados con el desensamblado y la ROM local: C23567 observa el
motor a pie; 027C=1 y coordenadas 0283/0285. Entradas activas en 7E7E00,
registros de siete bytes, cantidad 1B38, bit 80 del primer byte. Coordenadas
en casillas: byte0&7F, byte1&3F; nombre byte2; destino palabra+3&01FF.
Nombres de la traducción: punteros C6F400, textos C6, diccionario DEFA00 y
nombres de personajes de `status-reader.lua`. No copiar nombres ingleses.
Se comprueban firmas del motor y de las tablas antes de habilitar el lector.

Colisiones: mapa de metacasillas 96x64 en 7E5800; propiedades en 7E7000,
dos bytes por metacasilla, nibble alto para columna par. C239C3 comprueba los
dos puntos superiores con máscara 0303. C239AE exige bit4 en ambos para
activar entradas. La ruta busca ese punto, no cualquier punto de la casilla;
el aviso para entrar exige un índice nativo válido en 1B32. El mapa envuelve
horizontalmente a 1536 y verticalmente a 1024, como el motor. La ruta BFS
usa las mismas dimensiones y propiedades.

Pruebas: `python -m unittest discover -s tools/chrono-access/test -p 'test_*.py'`:
**68 aprobadas**, seis nuevas de nombres comprimidos, personaje, entradas
reales, agrupación, distancia, colisiones, punto de acceso, teclas con Control,
suspensión en menús, otras zonas y firmas incompatibles.

Integración: `test/discover-world.lua`, `test/check-world-runtime.lua` y
`test/check-world-entry.lua`, solo en la copia oculta y silenciada `test/world-check/`.
`outside-ram.bin` registra salida real en 01F0, X440/Y296. El primer ensayo
reveló que X440/Y280 aún no activa la puerta; se corrigió la condición de ruta
y el aviso. La repetición en `entry-validation.txt` registra tres pasos al
norte desde X440/Y296, entrada nativa en X440/Y272 y destino final 0001
(planta baja) después de A. La posada se consultó con su nombre y ruta; no
se probó entrar en ella en este ensayo. Los avisos se registraron sin voz;
falta valorar los atajos y la orientación con el usuario y NVDA.
La simulación de consultas usó el proveedor de teclas de prueba; los nombres
`control`/`F5`/`F6`/`F7` se contrastaron con `input.get` del fork. El conflicto
de F5 sin Control se contrastó con la configuración real de Snes9x.
La copia de investigación PID 9720 se cerró tras verificar su ruta y se
restauró su autorun a `test/discover-world.lua`. No reutilizar ese PID.
Se intentó activar con `recargar-lector.ps1`, pero no encontró una instancia
del emulador habitual. La consulta posterior de procesos `snes9x.exe` no
devolvió ninguna. No se abrió ni reinició la partida del usuario; la activación
en su sesión queda pendiente de que abra el juego o se identifique su proceso.

Límites: solo mapa 01F0 a pie; otros tiempos, vehículos y mapas interiores
no están cubiertos. Las rutas usan terreno y entradas actuales, pero todavía
no modelan eventos de guion intermedios, no anticipan cambios de historia y
no ofrecen instrucciones automáticas giro a giro. No afirmar navegación
completa del juego. El fondo verde de la captura no se corrigió: no se
diagnosticó su causa y no se cambiaron los ajustes gráficos.

Reversión: retirar carga/tick de `tickWorld` en `lector-snes9x.lua`, los dos
módulos `world-*` y restaurar el aviso anterior de salida en `room-reader.lua`.
No exige revertir combate, menús, audio o DLL. `tools/` continúa ignorado por
Git; no se hicieron commits. Los scripts `check-*` y `discover-*` de esta
prueba inyectan botones y nunca deben cargarse en la partida del usuario.

