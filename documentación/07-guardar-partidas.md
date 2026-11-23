# Lectura de la pantalla de Guardar

[Continuar el proyecto](../continuar%20chrono.md) · [Índice documental](README.md)

Las notas siguientes conservan la evidencia y el alcance de cada etapa. Los pendientes de una etapa pueden estar resueltos en documentos posteriores; el estado actual se consulta en el documento de continuación.

Las rutas de código escritas entre comillas invertidas parten de `D:\gt\vemovie`, salvo indicación distinta.

Código y evidencia relacionados:

- [save-reader.lua](../tools/chrono-access/save-reader.lua)
- [test_save.py](../tools/chrono-access/test/test_save.py)
- [save-check/validation.txt](../tools/chrono-access/test/save-check/validation.txt)

## Ampliación: pantalla de Guardar, 26 de octubre de 2026

El usuario pidió acceder al contenido de Guardar, que ya se anunciaba como
opción del menú principal. `save-reader.lua` está integrado en el callback de
`lector-snes9x.lua`. Lee las tres ranuras, distingue sin partida válida de
ocupada y anuncia capítulo, nombres y niveles del grupo guardado y tiempo.
Los nombres pertenecen a la partida anterior, no al grupo actual. Los capítulos
se capturan del texto resuelto de la traducción por callbacks opcionales
`saveGlyph/saveControl` en el observador de `status-reader.lua`; no se duplican
los hooks compartidos de diálogo.

Dentro de Guardar: arriba/abajo eligen ranura y Confirmar abre el uso. En una
ranura sin partida válida, confirmar guarda directamente. Si está ocupada,
aparece «¿Sobrescribir…? Sí/No»; el juego selecciona Sí inicialmente. Arriba y
abajo cambian entre Sí y No. Confirmar Sí reemplaza la partida anterior;
confirmar No o Cancelar conserva la anterior. Se anuncian ambas opciones,
cancelación, guardado completado y rechazo al guardar donde no se permite.
No se cambiaron botones ni se bloqueó el guardado nativo.

Hooks contrastados con la ROM: C2CF00 después del cursor de ranuras, C2CFF9
después de completar su fila, C2CF64 y C2D4D3 para el cursor de confirmación
(3=Sí, 4=No), C2CF88 al cancelar, C2CEEC al rechazar y C2D509 en la variante
de Guardar. C2D0E5 reinicia el contexto al reconstruir la pantalla. La ranura
está en 0079; se exige coincidencia con 0054 para evitar leer la fila anterior.
0D49..0D4B es la validez que comprobó el juego. FFFBE1 contiene bases de SRAM
6000/6A00/7400 en banco 30. Datos por ranura: grupo +580, personajes
+200+ID*50 hexadecimal, nivel +12, nombres +5B0+ID*6. Tiempo de juego: minutos
+5E5+10*5E6; horas +5E7+10*5E8. Capítulo: C2D296..C2D2C2 con texto 7000..75FF.

No anunciar «guardado» al pulsar Confirmar. C2CF37 marca el inicio; C2CF55
solo se alcanza después de SaveSlot_Write (FFF9FB). Se comprueba la última
ranura 307FE0 y la marca E41B de 307FF8+ranura*2. Eso prueba escritura del
motor en SRAM, no una confirmación del sistema operativo de haber escrito
el .srm. El ensayo verificó además el archivo en disco. La actualización de
la ranura después de guardar/cancelar no debe cortar el aviso ni repetirse
al siguiente fotograma. El contexto se limpia con menuEpoch y al reconstruir
la pantalla, no con un timeout durante las animaciones.

Pruebas: `python -m unittest discover -s tools/chrono-access/test -p 'test_*.py'`:
**75 aprobadas**, siete nuevas: ranuras, datos anteriores, capítulos por hooks
compartidos, Sí/No, cancelación, escritura completada/metadata, contexto,
rechazo y firmas incompatibles.

Integración aislada: `test/discover-save.lua`, `test/check-save-runtime.lua` y
`test/save-probe-controls.lua`, con copia oculta/silenciada en `test/save-check/`.
La selección de Guardar se forzó en 0411 durante la investigación; se ejecutó
después el guardado nativo. `runtime.txt` registra ranura 1 vacía, guardado,
ranura 2 vacía, vuelta a ranura 1 ocupada y «La Fiesta del Milenio. Crono.
Nivel 1. Tiempo 0 horas y 3 minutos». Se sobrescribió con Sí y se probó No
mediante abajo, que canceló. `before-cancel-real-ram.bin` y
`after-cancel-real-ram.bin` conservan contador de guardados 2. El archivo
`cancel-baseline.srm` coincide con la SRAM final byte por byte. Checksum
nativo calculado y almacenado: 51FC. Las demás ranuras quedaron intactas.
`test/save-check/validation.txt` resume la evidencia. Son guardados exclusivos de
la copia, no progreso del usuario. No cargar estos scripts de investigación
en la partida real. Falta la valoración con NVDA: en la integración se
registró la voz, sin salida audible.
La copia PID 6188 se cerró al terminar tras verificar la ruta de `save-check`.
Su `runtime-command.lua` quedó en `idle`; no reutilizar el PID. La consulta
posterior no encontró procesos Snes9x abiertos: la activación en la sesión
del usuario queda para la siguiente apertura con el acceso habitual.

Activación: abrir con el acceso habitual o recargar con `recargar-lector.cmd`.
Reversión: retirar carga/tick de `tickSave` en `lector-snes9x.lua`, el módulo
`save-reader.lua` y callbacks opcionales `saveGlyph/saveControl` en
`status-reader.lua`. No exige revertir combate, mapa exterior, equipo ni
diálogos. No se modificaron ROM, DLL ni partidas del usuario. Sin commits;
`tools/` sigue ignorado por Git. Cargar partidas desde el menú de título
todavía no se implementó; no confundirlo con esta pantalla de Guardar.

