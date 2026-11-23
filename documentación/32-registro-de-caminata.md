# Registro temporal para investigar la detención al caminar

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

El diagnóstico escribe `tools/chrono-access/caminar.log` mientras se intenta
caminar. Su finalidad es identificar por qué se abre el menú durante el
recorrido con teclado. **Todavía no se ha identificado la causa del caso del usuario.**

## Uso

El registro comienza desactivado al cargar o recargar el lector. No escribe
en `caminar.log` mientras permanece desactivado. Control+Alt+F2 permite
activarlo temporalmente para investigar. El archivo existente se conserva.

**Control+Alt+F2** detiene o reactiva el registro durante esa sesión y anuncia el
cambio. Mantener el atajo pulsado no lo conmuta repetidamente. No añade voz ni
sonidos mientras registra movimientos. El anuncio habitual de Control+F1 y la
guía de sonidos permanecen disponibles.

Desde la entrega 57, Control+F2 pertenece a la ayuda opcional de desafíos;
Control+Mayúsculas+F2 lee sus instrucciones.

## Qué registra

- Inicio y fin de la caminata, cambios de teclas/botones y una muestra cada
  treinta fotogramas mientras se mantiene una dirección o cambia la posición.
- Teclas de una lista limitada: flechas, V/C/D/X/A/S, espacio, Enter,
  modificadores y teclas F1–F12. No se almacenan cadenas de texto ni el resto
  de las letras del teclado.
- Botones de la consola que devuelve `joypad.get(1)`, posición del líder,
  mapa, capa, control, diálogo, bloqueo y el identificador de obstáculo.
- Bytes de entrada F0–FB y D1D–D1F, y configuración interna 2993–2998
  (confirmar, cancelar, menú, correr, mapa y desplazamiento). Se conservan
  como valores crudos para contrastarlos; no se deduce una acción por una letra.
- Una marca `INMOVIL_CON_DIRECCION` al pasar sesenta fotogramas manteniendo
  una dirección sin desplazamiento. También ocurre legítimamente ante paredes;
  esta marca por sí sola no demuestra un fallo.
- La transición `MENU_DESDE_CAMINATA`, si una rutina nativa de menú se observa
  después de un intento de caminar, aunque haya pasado más tiempo parado. Incluye una
  única muestra de entrada en esa transición. No continúa registrando las
  pulsaciones dentro de las pantallas de equipo, inventario o texto.
- `ACCION_TRAS_CAMINATA` registra V/D y A/X al volver a pulsar acción después
  de una detención, dentro del campo de juego. Esta ampliación de la versión 2
  cubre el intervalo que la versión inicial perdía después de tres segundos
  inmóvil. El resto de las pulsaciones en reposo sigue sin guardarse.

Las marcas llevan contador de fotogramas del registro y tiempo Unix. Cada sesión
añade una cabecera con fecha UTC; el archivo se conserva al recargar. Un segundo
puede contener varias transiciones de teclas y varias muestras; los intervalos
no deben interpretarse como una grabación completa de todos los fotogramas.

El registro utiliza el hook de control de campo que ya usa `room-reader`,
incluso fuera de los interiores con referencias. Para el mapa exterior utiliza
el indicador nativo de `world-reader`, sin reemplazar su hook. En ese mapa
las coordenadas proceden del modelo exterior y se registra `slot=-1`.

## Protección y coste

`walk-trace.lua` solo lee estado e input. No envía botones, cambia asignaciones,
escribe memoria, mueve al personaje, abre menús ni cierra/carga partidas.
Comparte indicadores de los lectores existentes; no reemplaza sus hooks.
No cambia la configuración del emulador.

Agrupa las escrituras, normalmente una vez por segundo, y vacía los datos al
detenerse, aparecer el menú, desactivar el diagnóstico o cerrar el lector.
El límite es **4 MiB**: al alcanzarlo se detiene y conserva el archivo, sin
rotarlo ni borrar evidencia anterior. Si falla la apertura/escritura, se
desactiva el diagnóstico y se informa en `lector.log`.

## Código y validación

- `walk-trace.lua`: filtro de campo/movimiento, estado, eventos y archivo limitado.
- `room-reader.lua`: expone `fieldActive` sin consumir el indicador del hook.
- `status-reader.lua`: expone `menuContext` con pantalla/estado capturados por
  sus rutinas verificadas. Se consulta antes de que `tickStatus` limpie el evento.
- `world-reader.lua`: expone el estado observado del exterior sin consumirlo.
- `lector-snes9x.lua`: consulta el diagnóstico al principio del fotograma y
  vacía datos al cerrar o recargar el script.

`test_walk_trace.py` comprueba ausencia de registro en reposo/menús, lista de
teclas, entrada real frente a teclado, inmovilidad, movimiento sin dirección
actualmente pulsada, transición única de menú, modificadores, escritura por
lotes, límite y fallo de archivo, y el hook real del lector de estado.

El ensayo nativo está en `test/walk-trace-check/`. Usa una partida nueva de
pruebas, voz/audio silenciados y botones inyectados únicamente en esa copia.
Su teclado es simulado para contrastar campos; **sus pulsaciones no constituyen
evidencia de lo que hizo el usuario**. Se conservan los intentos de cargar una
copia de un estado histórico; no se usaron para acreditar el resultado final.
Guion final: `test/check-walk-trace.lua`. Las evidencias válidas son
`runtime.txt` y la última `SESION` de `caminar.log` del ensayo desde el arranque
nuevo: dirección/X, una apertura de menú y regreso al campo. Las coordenadas de
apertura conservan la última posición de caminata: el menú reutiliza el búfer
de actores para otros datos. Los cambios de pantalla dentro del mismo menú no
se consideran nuevas aperturas. El exterior se contrasta con capturas reales
y pruebas sintéticas; no se acredita aquí un recorrido nativo nuevo por él.

Verificación final: **255 pruebas aprobadas en 23,051 segundos** con
`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`.
Registro completo: `test/walk-trace-check/suite-validation.txt`.
El ensayo se cerró con el gestor. Al terminar tampoco se encontró abierto
el emulador habitual, por lo que no se ejecutó una recarga ni se abrió su juego:
el próximo arranque activa el registro. No se cambió la DLL de audio.

## Reversión y pendiente

Después de identificar y resolver la causa, retirar la inicialización, llamada
y cierre de `walkTrace` en `lector-snes9x.lua`; después puede retirarse el módulo
y los accesores `fieldActive`/`menuContext` añadidos para él. Conservar el registro
como evidencia. No requiere revertir orientación, menús o guía de sonidos.
El segundo resultado de `world-reader` solo expone el estado observado y puede
retirarse junto con el parámetro `worldWalkingState` del diagnóstico.

Queda pendiente reproducir **la detención del usuario** con el registro activo.
Las aperturas de menú ya vistas en `lector.log` no permiten atribuirla a D,
V, una asignación interna u otro origen sin esta evidencia adicional.

El 29 de octubre se revisó un aviso real del usuario. V figura como A; en las
muestras previas revisadas no aparece D/X. Esto no excluye una pulsación en el
intervalo sin muestras de la versión inicial. Se conservó el archivo como
`diagnosticos/20261029-084450-caminar-usuario.log`, separado del ensayo inyectado.
Se amplió el diagnóstico a la versión 2; todavía no hay causa confirmada.
La suite de la versión 2 pasa **256 pruebas en 31,273 segundos**; registro en
`diagnosticos/suite-registro-v2.txt`. Se recargó el lector habitual con éxito
para activar la ampliación sin reiniciar ni cargar la partida abierta.
