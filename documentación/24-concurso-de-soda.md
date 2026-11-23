# 24. Concurso de soda de Leene

El lector acompaña el concurso de beber soda de la plaza de la campana
(mapa 439). La referencia del encargado explica que hay que pulsar A
repetidamente al aviso de inicio y alcanzar ocho latas.

## Cómo jugar

Localiza al encargado con Control+F6 y habla con A. Avanza sus instrucciones.
Al empezar la ronda, un pitido y «Ya. Pulsa A rápidamente» indican que debes
pulsar A repetidamente. El lector cuenta las latas completadas, avisa cuando
queda poco tiempo y marca el final con otro pitido y «Tiempo».
Después anuncia el resultado y los Puntos de Oro realmente recibidos.
Ocho latas alcanzan el objetivo; nueve también dan cinco puntos, sin premio extra.
Se reutiliza `bell_timing.wav`; no hace falta buscar otro sonido.

## Implementación

- `soda-model.lua` valida ROM, mapa, tabla y bytecode nativo del encargado.
- `soda-reader.lua` observa las fases, contador y abono. `lector-snes9x.lua`
  lo ejecuta en cada fotograma y reutiliza la señal breve existente.
- `room-profiles.lua` actualiza la referencia del encargado, conservando
  `juegos.wav` como sonido de orientación.

El actor 54 usa el PC en 7E11B6: preparación 0968–0990, juego 0991–09E0,
final 09E1–09F8 y resultado 09F9–0A3F. Su reposo habitual es 0950.
7F0236 contiene pulsaciones durante el juego (ocho por lata); al finalizar,
el motor divide ese mismo valor por ocho y lo convierte en latas.
7F023A es el temporizador y 7F0248 la bandera del concurso.
El premio se comprueba contra el total real de 7F0052; máximo 200 puntos.
No se escribe memoria ni se simulan botones desde el lector de producción.
Una carga a mitad de ronda evita repetir una falsa señal de inicio.

## Verificación y límites

La suite completa pasa 198 pruebas, incluidas doce de soda. Pasó también
`python tools/chrono-access/test/check_audio.py`.

Se ejecutaron cuatro rondas nativas con el lector instalado:

| Registro en `test/soda-check/` | Latas | Premio | Fotogramas de ronda |
| --- | --- | --- | --- |
| soda-1793192037-p0 | 0 | 0 | 420 |
| soda-1793192054-p2 | 3 | 0 | 358 |
| soda-1793192070-p2 | 8 | 5 | 452 |
| soda-1793192087-p2 | 9 | 5 | 446 |

Los volcados `before`, `playing`, `score` y `result` conservan la RAM real.
`soda-probe.txt` registra las fases; `reader-soda.txt` conserva las llamadas
de voz y las ocho señales de inicio/final. Las pruebas comprueban contador,
premio, mapa y dinero sin cambios. Los límites 198/200 se probaron mediante
estados sintéticos, separados de esas rondas nativas.

`research-soda.lua` inyecta A y activa la función nativa del encargado tras
reposicionar al jugador: no modifica contador, tiempo ni premio. Esto prueba
el concurso, sin demostrar un recorrido continuo hasta el encargado.
Las señales quedaron registradas y silenciadas en el ensayo; falta valorar
con NVDA si el conteo se escucha cómodo al pulsar rápidamente.

Se usó únicamente el emulador compartido, con datos del caso `soda-check`.
El emulador habitual y las partidas del usuario no se operaron.
Los guiones de investigación solo deben ejecutarse en el entorno de pruebas.

## Activación y reversión

El arranque habitual carga el módulo automáticamente. Si el lector estaba
abierto, usar `recargar-lector.cmd`. No requiere nuevos atajos ni ajustes.
Para retirar esta ampliación, quitar la creación y llamada de `sodaGame`
en `lector-snes9x.lua`; el juego y los diálogos nativos siguen funcionando.

Siguen pendientes la valoración del concurso y de la carrera con NVDA,
Gato, baile, objetivos de la tienda de los horrores y escena de Lucca.
La campana ya fue confirmada por el usuario.
