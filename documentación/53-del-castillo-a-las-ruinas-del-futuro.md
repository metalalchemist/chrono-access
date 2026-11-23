# Del castillo a las ruinas del futuro

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

**Actualización:** los pendientes de esta entrega y la entrada izquierda que
quedaba sin orientación se atienden en [54. Huida comprobada y cuartel oeste](54-huida-comprobada-y-cuartel-oeste.md).
La lista de zonas y los límites siguientes describen la entrega 53 original;
el alcance actual, los recorridos completos y las nuevas pruebas están en la 54.

La orientación continúa desde la sala de la captura del usuario, al salir del
rellano inferior de la torre, hasta la Bóveda Bangor de 2300 d. C. También se
añaden Trann y los dos sectores de Lab 16. Bangor indica expresamente salir
por el sur: la puerta sellada del norte está bloqueada en la primera visita.

## Recorrido y referencias

- **Castillo:** desde el vestíbulo oeste, bajar al pasillo inferior y girar al
  este hacia el acceso principal. La salida al bosque queda al sur. Los avisos
  de los soldados y el reencuentro con Marle conservan los controles del juego.
- **Bosque:** se mantiene la orientación anterior del mapa 19. En el claro del
  arcón, el portal del sur tiene sonido de conexión y guía cuando está presente.
  Sus dos efectos gráficos dejan de anunciarse como personas.
- **Bangor:** puerta sellada al norte, portal de regreso y escalera/salida al
  sur. No hay cofres accesibles ni punto de guardado en la sala de llegada.
- **Mapa exterior:** Control+F5 consulta destinos, Control+F6 cambia de destino
  y Control+F7 calcula una ruta a pie. Ahora reconoce el año 2300 y sus entradas.
- **Trann:** personas numeradas, máquina de descanso al oeste y referencias en
  los giros del pasillo desde el vestíbulo. Puerta sellada al norte de los
  habitantes; salida al exterior por el vestíbulo del sureste.
- **Lab 16:** dos sectores, cuatro cofres, conexiones y enemigos. Las seis ratas
  del sector oeste tienen sonido de peligro y descripción propia; no se confunden
  con personas. Las distancias son directas y no resuelven los giros entre ruinas.

El generador añade **20 zonas y 64 referencias físicas**: 40 conexiones de la
ROM, 14 cofres, nueve puntos de orientación y la máquina de descanso. Incluye
los interiores y torres del castillo conectados con la sala principal, y las
cámaras tras las puertas selladas de Bangor y Trann. Estas cámaras se describen
como inaccesibles en la llegada inicial; añadir su orientación no abre puertas.
Los cofres usan el bit nativo de apertura y silencian su señal una vez abiertos.

Los interruptores y puntos de guardado de la prisión se conservan. En los mapas
de llegada comprobados no se identificó un nuevo interruptor o punto de guardado;
la máquina de Trann se anuncia como máquina de descanso. No se ha añadido Arris
ni se presenta su punto de guardado como parte de esta entrega.

## Evidencia y límites

Se trabajó exclusivamente en `test/future-check/`, con el emulador compartido
silenciado. La copia inicial del `.000` tiene mapa 21, posición X=216, Y≈600 y
contador de historia 46; reproduce visualmente la captura del usuario. El hash
del `.000` habitual se comprobó idéntico al terminar. No se modificó la SRAM
habitual ni se enviaron botones a su instancia.

| Comprobación | Evidencia en `test/future-check/` |
| --- | --- |
| Vestíbulo de la captura | `source-ram.bin`, `castle-floor.gd`, `castle-floor.png` |
| Bajada y giro hacia el acceso principal con botones nativos | `escape-dialogue`, `escape-bottom`, `escape-turn`, `escape-main` y sus RAM/GD |
| Diálogos de soldados, Marle y canciller | `reader-validation.txt`, capturas `escape-marle` y `escape-king` |
| Portal nativo del claro, actor 18, gráfico `82 97` | `map-20-ram.bin`, `map-20.gd` |
| Puerta norte y portal de Bangor, actor 22, gráfico `82 97` | `map-208-ram.bin`, `map-208.png` |
| Anuncio de Bangor y salida al exterior de 2300 | `reader-validation.txt`, `future-world-guide-ram.bin` |
| Consulta de ruta en el mapa exterior | `future-world-route-ram.bin`, `reader-validation.txt` |
| Habitantes, máquina y pasillo de Trann con botones nativos | `map-210-ram.bin`, `trann-up`, `trann-west`, `trann-middle` |
| Ratas y enemigos de Lab 16 | `map-212-ram.bin`, `map-213-ram.bin` |

Las cargas de mapas fueron independientes, mediante el cargador nativo. Para
los mapas futuros se prepararon los tres personajes y contador 52, exclusivamente
en la copia. La salida de Bangor se ensayó colocando al grupo al pie de la
escalera, X=120, Y=176, y caminando al sur. No demuestra una llegada continua
desde el Tanque Dragón: quedaron sin completar las escenas de huida y el tránsito
por el portal en una sola secuencia. Los intentos iniciales de cargar directamente
el estado no produjeron un punto fiable y no se usan como prueba de ese recorrido.

Los 40 accesos y los 14 cofres se cotejan con las tablas originales de esta ROM.
No se recorrieron todos los interiores del castillo ni las cámaras selladas.
Lab 16 tiene referencias verificadas contra la ROM y actores del motor; falta
recorrer sus dos sectores completos, incluidos los desvíos a cofres. Falta
valoración de los sonidos con NVDA.

## Validación, archivos y activación

`test/test_future.py` incorpora siete pruebas: punto inicial del usuario,
cobertura exacta de accesos y cofres, puerta/salida/portal de Bangor, aparición
del portal del bosque, apertura de cofres y ratas, máquina/personas de Trann,
y destinos/año del mapa exterior de 2300. El resultado de la suite completa
se conserva en `test/future-check/unit-validation.txt`.

Archivos funcionales: `room-profiles.lua`, `world-model.lua` y `world-reader.lua`.
El bloque nuevo se regenera con `test/build-future-profiles.py`; la corrección
del claro está fuera del bloque generado. Las herramientas de investigación
son `start-future.lua`, `check-future.lua`, `warp-future.lua`, `probe-future.py`,
`drive-future.py` y `future-paths.py`; ninguna se usa en la partida habitual.

La copia quedó cerrada. Los cambios se cargarán al iniciar el lector o mediante
`recargar-lector.cmd`, conservando la partida abierta. Las consultas mantienen
Control+F5 y Control+F6 dentro de las salas.

Para revertir esta entrega, retirar el bloque `BEGIN ESCAPE FUTURE` de perfiles,
restaurar la configuración anterior del claro y quitar el año 498 de la condición
de `world-model.lua` y de la frase de `world-reader.lua`. La copia anterior de
perfiles se conserva en `test/future-check/room-profiles-before.lua`; no restaurarla
entera si después se han añadido otros cambios independientes.

La guía consultada coincide con la salida sur de Bangor y el recorrido posterior
por Trann y Lab 16: [Beyond the Ruins, Caves of Narshe](https://www.cavesofnarshe.com/ct/walkthrough.php?chapter=5).
La numeración de capítulos depende de la guía; el alcance se identifica aquí
por los lugares concretos.
