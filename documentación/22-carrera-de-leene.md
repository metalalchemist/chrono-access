# Apostar y cobrar en la carrera de Leene

[Continuar](../continuar%20chrono.md) · [Índice](README.md) · [Plaza Leene](20-plaza-leene.md)

La carrera tiene lectura de las opciones nativas y avisos automáticos de
disponibilidad, elección confirmada, inicio, ganador y premio. El cobro se
anuncia cuando aumentan realmente los Puntos de Oro. No hacen falta sonidos
nuevos ni teclas adicionales.

## Cómo jugar

1. En la entrada de la feria, busca con Control+F6 «Carrera: encargado de
   apuestas y cobro». Acércate a él y pulsa A cuando el lector indique que
   puedes apostar. Si ya corre una carrera, espera la siguiente pausa.
2. En «¿Quieres apostar?», elige **Vale**. Después elige un corredor con
   arriba/abajo y confirma con A. El lector de diálogos anuncia las opciones
   reales; elegir **No** cancela sin registrar una apuesta.
3. Escucha el inicio y el ganador. Los corredores se mueven automáticamente.
   Si acertaste, el lector avisa que tienes un premio pendiente.
4. Habla otra vez con el encargado y avanza su mensaje con A. El lector
   confirma los puntos recibidos después de que se abonen.

| Opción | Corredor |
| --- | --- |
| A | Hojalatón |
| B | Moquillo V; el resultado nativo también lo llama Moquillo Verde |
| C | A. Gatón; el resultado nativo también lo llama Abel Gatón |
| D | Martini Fiz |

Elegir un corredor no descuenta dinero ni Puntos de Oro. Un acierto permite
cobrar 20 puntos, con el límite global de 200. Si solo caben diez, el lector
anuncia diez; si ya tienes 200, lo indica. La persona al sureste del encargado
da pistas sobre los corredores; no garantiza un ganador.

Los avisos se mantienen cerca del encargado o mientras hay apuesta, premio
o cobro pendiente. Al alejarse sin apuesta, dejan de comentar las carreras.
El aviso de disponibilidad es breve porque la pausa entre rondas es limitada.
La campana conserva su pitido y ajustes: el usuario confirmó que funciona.

## Código y datos comprobados

Archivos en `tools/chrono-access/`:

- `race-model.lua`: valida los guiones de esta ROM y lee las variables reales.
- `race-reader.lua`: observa cambios de ronda, apuesta y premio.
- `lector-snes9x.lua`: ejecuta el observador cada fotograma.
- `room-profiles.lua`: distingue al encargado de apuestas/cobro y a la persona
  que da pistas. El encargado conserva el sonido `games`.

La selección y las preguntas usan `dialogue-reader.lua`, que ya leía el cursor
nativo. El observador nuevo espera a que el guion registre la elección; no
deduce una apuesta al mover el cursor ni al pulsar un botón.

| Estado | Dirección o función nativa |
| --- | --- |
| Carrera en marcha | `$7F021C` |
| Ganador, identificadores 1–4 | `$7F020C`, válido con el indicador `$7F0210` |
| Corredor elegido | `$7F022C`, cero cuando no hay apuesta |
| Premio pendiente | `$7F0232` |
| Puntos de Oro reales | `$7F0052` |
| Encargado | Slot 24; función inicial `$0718`, activación `$075D` |
| Texto de cobro / suma de 20 | Rama `$0764`–`$0770` |

El ganador anterior permanece en memoria durante la siguiente elección: se
ignora al anunciar una apuesta nueva y se espera al comienzo de su ronda.
El premio pendiente puede aparecer antes de que termine de limpiarse la
bandera de carrera; cobrar en ese intervalo tampoco genera un falso aviso de
derrota. La escritura de los puntos llegó dos fotogramas después del retorno
al control en un ensayo: el lector espera el cambio real.

Las funciones completas del encargado, las cuatro ramas de llegada y la
transferencia con límite de 200 se contrastan con los guiones en `$7F2001`.
La lectura se suspende en otros mapas o ante datos incompatibles. El código
de producción no modifica apuestas, ganadores, velocidades, premios ni botones.

## Validación y límites

Evidencias: `tools/chrono-access/test/race-check/`. El manifiesto
`validated-races.json` identifica seis rondas completas verificadas:

- Cinco apuestas fallidas conservaron los 20 puntos iniciales.
- A. Gatón ganó una apuesta por A. Gatón; después del cobro, 20 → 40 puntos.
- Elegir «No» dejó la apuesta a cero y conservó los 40 puntos.
- Se recorrieron y leyeron las cuatro opciones y la cancelación con el cursor
  nativo. El dinero normal permaneció en 400 G durante las rondas comprobadas.

Los archivos `*-before`, `*-bet`, `*-finish` y `*-result` contienen la RAM de
cada etapa. `reader-validation.txt` conserva el diálogo común y
`reader-race.txt` los avisos del observador. `race-probe.txt` registra los cambios
del motor. `record-native-races.py` excluye los ensayos preliminares incompletos.

Las pruebas reubican al personaje cerca del encargado e invocan su activación
nativa para superar el filtro de objetos fuera de cámara que dejan esas
reubicaciones. Las elecciones y el cobro se hacen con botones en el diálogo
nativo. No se escribieron directamente la apuesta, el ganador ni el premio.
Esto prueba la actividad y su lectura; no acredita un recorrido continuo a pie.
La voz se registró; falta la valoración del usuario con NVDA.

`test_race.py` añade trece pruebas: compatibilidad, observación por proximidad,
elección confirmada, ganador anterior, inicio, derrota, cobro diferido, límite
de puntos, salida del mapa, ausencia de escrituras, cobro antes de limpiar la
bandera de carrera, seis rondas nativas y las cuatro opciones/cancelación.
Suite: `python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`:
**181 pruebas aprobadas**. Recibos: `race-check/tests-result.txt` y
`tests-stdout.txt`.

Los ensayos preliminares se conservaron. Se corrigieron dos condiciones del
guion de prueba: esperar al inicio de la ronda nueva antes de evaluar su ganador
y esperar al abono antes de capturar el resultado. Los casos validados no usan
esas capturas prematuras. Los límites de 190 → 200 y de 200 son pruebas
sintéticas respaldadas por el guion; las rondas nativas llegaron hasta 40.

## Activación, protección y reversión

Abrir `tools/chrono-access/iniciar-lector.cmd` carga la mejora. Si el juego
habitual ya está abierto, `recargar-lector.cmd` actualiza sin reiniciar.
Los autorun y guiones de pruebas no sirven para jugar.

Solo se operó `test/leene-check/snes9x.exe`, con resultados separados en
`test/race-check/`, audio silenciado y entrada en segundo plano. No se abrió
una partida del usuario ni se cambió la configuración del emulador habitual.
Al terminar solo estaba abierta esa copia de pruebas; se comprobó su ruta y
se cerró. El siguiente arranque habitual cargará la ampliación.

Reversión: retirar `raceGame` y su tick del lector principal, `race-model.lua`,
`race-reader.lua`, sus pruebas y los dos nombres ampliados del perfil de entrada.
Se conservan el lector de diálogos, la orientación de la feria y la campana.
No hubo cambios en los sonidos, ROM, partidas ni trabajo ajeno de VeMovie.
`tools/` sigue ignorado por Git.
