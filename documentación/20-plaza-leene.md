# Orientación de la plaza Leene y sus atracciones

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

La feria tiene referencias habladas y sonoras en sus seis zonas. **Control+F5**
consulta la referencia seleccionada, inicialmente la salida; **Control+F6**
recorre conexiones, atracciones y habitantes. Las distancias son directas:
no calculan un camino entre los puestos. Control+F7 sigue siendo del exterior.

## Recorrido y sonidos

| Zona | Mapa | Orientación |
| --- | --- | --- |
| Entrada | 5 | Exterior al sur, campana al norte, tienda de los horrores al noreste. Juego de la campana al oeste y carrera al este. |
| Plaza de la campana | 439 | Entrada al sur, Gato al oeste, baile al este y Lucca al norte. Concurso de soda al sureste. |
| Recinto de Gato | 6 | Gato al norte; regreso al sur. |
| Baile | 7 | Músicos al norte; regreso al sur. |
| Presentación de Lucca | 8 | Presentación al norte; regreso al sur. El paso puede estar cerrado por vigilantes. |
| Tienda de los horrores | 434 | Pepe Carrolla al norte; regreso a la entrada al sur. |

El efecto aportado `sounds/juegos.wav` se conserva. Su copia de ejecución,
`runtime/sounds/games.wav`, ocupa **17416 bytes**: mono, 22050 Hz, PCM de 16 bits,
unos 0,394 segundos. El original ya tenía ese formato y tamaño; la conversión
no consiguió reducirlo. `prepare-sounds.ps1` acepta ahora WAV además de MP3.

Se usa `games` en las atracciones, Gato, el encargado de la carrera, el concurso
de soda y Pepe Carrolla. Los vendedores conservan `person`: Melchor y los puestos
de los slots 32 y 48. Los cuatro corredores no producen señales de persona.
El baile agrupa a sus músicos en una referencia para evitar varias señales
superpuestas. Los juegos no reciben señales de proximidad de muebles.

## Qué permite jugar esta entrega

Se pueden localizar las atracciones, sus encargados y los regresos. Los textos
siguen a cargo del lector común. El combate de Gato utiliza el lector de batalla
existente; esta entrega no completó un combate contra él. El concurso de soda
indica pulsar A rápidamente, según su diálogo nativo.

**Los minijuegos todavía no tienen seguimiento completo sin visión.** Faltan
la señal del momento de golpear en el juego de la campana, posiciones o progreso
durante la carrera y el seguimiento de los objetivos de la tienda de los horrores.
La referencia del juego de la campana y la entrada a la tienda avisan de sus
límites. No se verificaron victorias, premios ni todas las rondas de esos juegos.
No presentar esta entrega como accesibilidad completa de los minijuegos.

La escena de Lucca se capturó con el control desactivado. El lector suspende
la orientación durante escenas y diálogos; el texto continúa por su módulo
independiente. Se comprobó el destino y el regreso del mapa 8 en ROM, pero no
su recorrido completo ni su salida después de terminar la demostración.
El ensayo reubicó al personaje por delante de los vigilantes: no acredita
que ese paso esté abierto en cualquier momento de la historia.

## Evidencia y validación

Código: `room-profiles.lua`, `room-model.lua`, `room-reader.lua` y
`prepare-sounds.ps1`, dentro de `tools/chrono-access/`.
`room-model.lua` admite un sonido por persona mediante `personSounds`;
las posiciones siguen leyendo al actor real y desaparecen cuando se oculta.

Se conservaron RAM, capturas y registros en `test/leene-check/`:

- `entrance`, `bell-entry`, `gato-entry`, `dance-entry`, `lucca-entry` y
  `tent-ready`: llegadas reales a las seis localizaciones.
- `native-gato-f5/f6`, `native-dance-f5/f6`, `native-south-f5/f6` y
  `native-tent-f5/f6`: consultas del lector de producción, con voz registrada
  y mezclador de proximidad silenciado.
- `native-gato-return` y `native-dance-return`: regreso al mapa 439.
  `native-south` y `native-tent-return`: regreso al mapa 5.
  `native-world-exit`: salida al mapa exterior 496.
- `reader-validation.txt`: textos reales de carrera, juego de la campana,
  concurso de soda, vigilantes, Melchor y Pepe Carrolla. `service-32` y
  `service-48` muestran la apertura del comercio nativo.

Los guiones de identificación invocan la activación nativa de un actor en la
copia de pruebas. Sirven para identificar sus textos y servicios; **no prueban
una aproximación a pie ni una partida ganada**. Las reubicaciones cercanas a
las salidas tampoco acreditan rutas continuas entre todos los puestos.
Algunas capturas después de restaurar estados tienen fondos incompletos;
no se usaron para inventar muebles o límites de obstáculos. El terreno se
consulta en RAM y las cajas de conexión se contrastan con la tabla E5 de ROM.

`test_leene.py` añade nueve pruebas: llegadas y cobertura, todas las conexiones
de ROM, separación de sonidos, seguimiento y ocultación de Gato, suspensión
durante escenas, atajos y carga del sonido, identificación por diálogos,
formato de audio, y consultas/salidas nativas.

Suite completa: `python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`:
**156 pruebas aprobadas**. Falta la valoración del usuario con NVDA y la escucha
real de la mezcla con el nuevo efecto.

Los archivos de comandos se publican con sustitución atómica desde
`run-leene-orientation.py`. Escribir sobre el archivo mientras Lua lo lee
detuvo un ensayo preliminar; se corrigió el guion y se repitieron consultas y
regresos con los archivos `native-*`. Los registros preliminares se conservan.

## Activación, protección y reversión

Abrir `tools/chrono-access/iniciar-lector.cmd` carga la ampliación. Si se está
jugando, `recargar-lector.cmd` recarga sin reiniciar la partida. La instancia
usada en esta entrega fue exclusivamente `test/leene-check/snes9x.exe`, con
audio del juego silenciado. Se habilitó su entrada en segundo plano para los
ensayos. No se modificó la configuración del emulador habitual ni se abrió
una partida del usuario para probar. Los autorun de pruebas no sirven para jugar.
Al terminar solo estaba abierta la copia aislada; se cerró tras comprobar su
ruta exacta. El acceso habitual recogerá los cambios en el próximo arranque.

Reversión de esta unidad: retirar los seis perfiles `leene_*`, el soporte
`personSounds` de `room-model.lua`, la entrada `games` del lector y del
preparador, y su copia de audio de runtime. Conservar el original aportado
y las evidencias. No se requieren cambios en lectores de texto, combate,
guardado, comercio ni mapas anteriores. `tools/` continúa ignorado por Git;
no se tocaron los cambios ajenos de VeMovie.
