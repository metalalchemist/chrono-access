# Orientación de la sala principal de Lucca

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

La sala principal de la casa de Lucca tiene orientación sonora y consultas
habladas desde el 26 de octubre de 2026. Se identifica por el mapa **0004**,
con perfil `0 <= X < 256`, `112 <= Y < 336`. Las otras habitaciones del
edificio siguen pendientes; al salir del área cubierta se avisa por voz.

## Uso

Abrir con `tools/chrono-access/iniciar-lector.cmd`, o recargar con
`recargar-lector.cmd` si el emulador habitual sigue abierto. No reiniciar
la partida para activar cambios. Al entrar o recargar se anuncia la sala,
la cobertura y las conexiones:

- Salida al sur, en el pasillo izquierdo.
- Puerta a otra habitación al norte, en el centro.
- **Control+F5:** consulta la referencia seleccionada y su dirección y distancia.
  Al entrar, la referencia inicial es la salida exterior.
- **Control+F6:** recorre las referencias de la habitación y las personas activas.

Las distancias son diferencias de posición en casillas de 16 píxeles, con un
decimal; no son rutas que eviten obstáculos. Control+F7 sigue siendo exclusivo
del mapa exterior. No usar F5/F6 sin Control: Snes9x las asigna a estados.

Las paredes mantienen sus señales por dirección; los objetos, reloj y puertas
usan los sonidos existentes, con proximidad de cuatro casillas y dos consultas
por segundo. Abrir menús o diálogos suspende la orientación. Las consultas
habladas no dependen de que los sonidos estén activados en la configuración.

## Datos contrastados

La entrada del mapa exterior apunta al destino 4. La recarga de la sesión del
usuario registró mapa 0004, líder 2, X=56, Y=303,9375. Una copia aislada llegó
al mismo punto mediante entrada real y produjo
[entrance-ram.bin](../tools/chrono-access/test/lucca-check/entrance-ram.bin) y
[entrance-grid.png](../tools/chrono-access/test/lucca-check/entrance-grid.png).
La cámara de esa captura está en X=0, Y=112; se calculó con la rutina C0AB45,
no tomando las coordenadas de la captura del escritorio como coordenadas del mapa.

La tabla de salidas de la ROM, banco E5, tiene los registros de mapa 4 entre
0448 y 0464. El primer registro cubre las casillas X=2..4, Y=20 y apunta a
01F0. El segundo cubre X=7..8, Y=10 y apunta a 0003. Por eso la puerta
interior no se presenta como una salida al exterior. Las otras dos conexiones,
en Y=4, quedan fuera de este perfil; no se probaron en esta entrega.

| Referencia | Caja en píxeles `[x1,y1,x2,y2]` |
| --- | --- |
| Salida exterior | `[32,320,80,336]` |
| Puerta interior | `[112,160,144,176]` |
| Mesa grande | `[160,224,208,288]` |
| Mesa de trabajo | `[16,208,80,240]` |
| Estantería | `[64,144,96,192]` |
| Máquinas | `[144,128,192,192]` |
| Tubos izquierdos | `[32,160,64,208]` |
| Tubos centrales | `[96,160,112,272]` |
| Reloj | `[224,144,240,192]` |

El mobiliario se anotó sobre la captura cuadriculada. Las paredes y colisiones
siguen viniendo de la RAM real, no de estas cajas. No se presentan los libros
dibujados en el suelo como objetos recogibles. La captura tiene tres slots y
ninguna persona activa: las pruebas comprueban que no se inventen personajes.

## Código y validación

[room-profiles.lua](../tools/chrono-access/room-profiles.lua) añade el perfil.
[room-model.lua](../tools/chrono-access/room-model.lua) separa las referencias
consultables de las cercanas que producen audio.
[room-reader.lua](../tools/chrono-access/room-reader.lua) integra las consultas,
los avisos y el nombre correcto al salir de Lucca; conserva los avisos de
escaleras de Crono. [lector-snes9x.lua](../tools/chrono-access/lector-snes9x.lua)
entrega el proveedor de teclas y conserva el diagnóstico de ubicación al recargar.

`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`:
**85 pruebas aprobadas**, cuatro nuevas. Cubren la captura nativa, salidas de
ROM, obstáculos, referencias lejanas sin audio fuera de alcance, Control,
tecla mantenida, suspensión y mensajes de cobertura.

La ejecución real del lector completo quedó en
[reader-validation.txt](../tools/chrono-access/test/lucca-check/reader-validation.txt)
y [production-reader.log](../tools/chrono-access/test/lucca-check/production-reader.log):
anuncio de sala, sonidos nativos silenciados para el ensayo, consulta de salida
a una casilla al sur, puerta interior a 8 al norte y 3,5 al este, apertura y
cierre del menú, consulta desde el centro y salida real caminando al mapa 01F0.
La suspensión y reanudación del audio figuran en el segundo registro.
Falta la valoración del usuario con NVDA; el ensayo registra la voz sin emitirla.

Los guiones `test/discover-lucca.lua`, `test/check-lucca-runtime.lua` y
`test/check-lucca-reader.lua` son exclusivos de `test/lucca-check/`: inyectan controles
y posiciones de prueba. La entrada se preparó reubicando al actor del mapa
exterior en la copia aislada, moviéndolo brevemente y pulsando A; no demuestra
un recorrido completo a pie desde Crono. La partida de prueba conserva un
nombre de personaje alterado por el ensayo; no corresponde al nombre del usuario.
`test/recargar-prueba.ps1` envía WM_COMMAND a la consola oculta; el recargador
habitual no se modificó. `test/capture-lucca.lua` no está conectado al lector:
el intento de captura en vivo no produjo archivos. No se cargaron estados,
se inyectaron botones ni se escribió RAM en la sesión del usuario.
La copia aislada PID 9620 se cerró tras verificar su ruta. Su autorun vuelve
a `test/discover-lucca.lua`; el comando del ensayo se conserva como
`command-reader-v1.lua`, fuera del nombre que se ejecuta automáticamente.
La consulta final no encontró procesos Snes9x. Es un dato histórico: volver a
comprobar los procesos antes de operar el emulador del usuario.

## Límites y reversión

Esta entrega cubre la sala de la captura, no todas las habitaciones de Lucca.
La puerta norte se localiza, pero su destino aún no tiene orientación sonora.
No hay ruta interior ni movimiento automático. Las personas siguen usando el
detector acotado al perfil, no un clasificador universal de objetos del juego.

Para retirar esta ampliación, eliminar el perfil `lucca_main`, las consultas y
los avisos genéricos de `room-reader.lua`, y el proveedor de teclas del lector.
`references`/`relative` en el modelo pueden conservarse sin activación o
reintegrarse en `scan` para volver al comportamiento anterior. No exige
cambiar ROM, partidas, DLL, menús, combate o mapa exterior. `tools/` continúa
ignorado por Git; no se hicieron commits.
