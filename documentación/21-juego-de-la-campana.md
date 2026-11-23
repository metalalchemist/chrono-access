# Jugar a la campana de Leene con aviso sonoro

[Continuar](../continuar%20chrono.md) · [Índice](README.md) · [Orientación de la feria](20-plaza-leene.md)

El juego de la campana tiene un pitido de anticipación, ajuste por teclado y
lectura del resultado. El lector observa la partida: **no pulsa A, no modifica
la velocidad y no escribe en la memoria del juego**.
Después de esta entrega, el usuario confirmó que la campana funciona.

## Cómo jugar

1. En la entrada de la feria, localiza el juego de la campana al oeste con
   Control+F5/F6. Acércate a la campana mirando al norte y pulsa A para empezar.
2. Suelta A. Crono comienza a moverse automáticamente. Espera al pitido corto
   y pulsa A otra vez. Puedes dejar pasar varias vueltas para escuchar el ritmo.
3. El lector indica si el golpe llegó pronto o tarde. Si ganaste, el mensaje
   del juego se lee por el lector de diálogos; pulsa A para avanzarlo. Después
   se anuncia el Punto de Oro cuando aparece realmente en el contador.

Si te adelantas, **Control+F9 retrasa el aviso**. Si llegas tarde,
**Control+F8 adelanta el aviso**. Las teclas funcionan durante la prueba o
cerca de la campana, y anuncian el cambio. Mantener una tecla pulsada no repite
el ajuste. Los ajustes duran hasta recargar el lector; se parte de ocho pasos
de anticipo en `room-audio-config.lua`.

El anticipo compensa el recorrido del sonido y la reacción del jugador.
Las pruebas automáticas no sustituyen la calibración con el usuario y NVDA.
No se ha escuchado todavía la mezcla real con este pitido. Si el mezclador
no está disponible o los sonidos están desactivados, se avisa en lugar de
pedir que se espere una señal inexistente.

## Implementación y datos verificados

Archivos en `tools/chrono-access/`:

- `bell-model.lua`: identifica el guion nativo de esta ROM, sus fases, contador
  de distancia, sentido del movimiento y Puntos de Oro.
- `bell-reader.lua`: un aviso por recorrido de ida, calibración con Control+F8/F9,
  resultado y anuncio del premio después de recibirlo.
- `lector-snes9x.lua`: ejecuta el lector cada fotograma después de la orientación.
- `room-reader.lua`: carga `bell_timing.wav` y emite el aviso por el canal 22,
  separado de los objetos y avisos de entrada. Se conserva `games.wav` para
  localizar las atracciones.

El nuevo pitido, generado localmente con `test/prepare-bell-sound.py`, dura
60 ms y ocupa **2690 bytes**: mono, 22050 Hz, PCM de 16 bits. Su fuente está
en `sounds/bell-timing.wav` y la copia de ejecución en
`runtime/sounds/bell_timing.wav`. `prepare-sounds.ps1` también lo incluye.
No se requiere Python al jugar.

El mapa es el 5. La campana es el actor de slot 52; la función 3 del líder
ejecuta el movimiento. Los guiones de evento se copian a `$7F2001`:

| Dato | Identificación |
| --- | --- |
| Oscilación del líder | Función `$0596`, bucles de ida `$05A7` y vuelta `$05B7` |
| Activación de la campana | Función `$098A`; espera al líder en `$0994` |
| Contador de distancia | `$7F0228`, valores 0 a 22 |
| Condición de acierto | Comparación nativa `contador >= 21` |
| Puntos de Oro persistentes | `$7F0052` |
| Transferencia y límite | Función `$056E`, copia del temporal `$7F0236` y límite de 200 |

El aviso inicial se emite al cruzar el contador 13 durante la ida: ocho pasos
antes de 21. Se midieron dos fotogramas por incremento en el ensayo. El lector
no supone una duración fija en milisegundos ni avisa al volver. Al cargar a
mitad de una ida, espera un acercamiento completo antes de dar otra señal.

Se contrastan funciones completas del guion y firmas del intérprete. Cambiar
de mapa, abrir un menú que sustituya esa memoria o encontrar datos incompatibles
suspende la detección. El premio no se deduce de una pulsación ni de un sonido.
Un abandono sin observar el golpe no genera un resultado inventado.

## Pruebas y evidencia

Evidencias en `tools/chrono-access/test/bell-check/`:
`bell-trace.txt`, `reader-game.txt`, capturas `reaction-*-ram.bin` y sus estados
`reaction-*-ready-ram.bin`. La tabla recoge la última ejecución completa:

| Demora desde la solicitud del pitido | Golpe | Puntos antes → después | Lectura |
| --- | --- | --- | --- |
| 8 fotogramas | 17, ida | 1 → 1 | Golpe temprano; recomienda Control+F9 |
| 16 fotogramas | 21 | 1 → 2 | Premio confirmado: un Punto de Oro |
| 20 fotogramas | 21 | 1 → 2 | Premio confirmado: un Punto de Oro |
| 30 fotogramas | 16, vuelta | 1 → 1 | Golpe tardío; recomienda Control+F8 |

Las pulsaciones de estos ensayos son sintéticas y ocurren solo en la copia
aislada. Se reubicó al personaje cerca de la campana y se invocó la activación
nativa para superar el filtro de objetos fuera de cámara que dejan esas
reubicaciones. Esto verifica el minijuego, sus premios y el lector, no un
recorrido continuo desde la entrada. El audio de orientación se silenció y la
voz se registró. No acredita todavía una victoria del usuario con audio real.

`test_bell.py` añade doce pruebas: firmas y fases, cadencia, regreso, recarga
a mitad de vuelta, calibración, premio real, límite de puntos, cancelación,
ausencia de escrituras, canal y formato de sonido, y los cuatro resultados
nativos anteriores. La suite completa registra **168 pruebas aprobadas**:
`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`.
Los recibos están en `bell-check/tests-result.txt` y `tests-stdout.txt`.

Los ensayos preliminares se conservaron. El ejecutor final usa comandos
atómicos, identificadores distintos para activación y captura, y un único
observador cargado; los registros anteriores no sustituyen las capturas finales.

## Activación, pendientes y reversión

Abrir `tools/chrono-access/iniciar-lector.cmd` carga la mejora. Si se está
jugando, `recargar-lector.cmd` actualiza el lector conservando la partida.
No usar los autorun ni guiones de pruebas para jugar.
Se operó únicamente `test/leene-check/snes9x.exe`, con los registros nuevos
en `test/bell-check/`. Al terminar se verificó su ruta y se cerró esa copia.
No había una instancia habitual abierta y no se utilizó la partida del usuario.

Falta probar con el usuario el volumen y el anticipo. La carrera y los juegos
de la tienda de los horrores siguen pendientes de seguimiento completo; esta
entrega no modifica sus reglas ni los declara accesibles por tener ubicación.

Reversión: retirar la creación y tick de `bellGame` del lector principal,
`bell-model.lua`, `bell-reader.lua`, la referencia ampliada de la campana,
el ajuste `bellCueLeadSteps`, la entrada `bell_timing` del mezclador y del
preparador, y el método `cue` de `room-reader.lua`. Conservar el sonido original
`juegos.wav`, la orientación de la feria y las evidencias. La unidad no exige
cambios en diálogos, comercio, combate ni partidas. No se tocaron los cambios
ajenos de VeMovie; `tools/` sigue ignorado por Git.
