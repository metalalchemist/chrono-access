# Huida comprobada y orientación del cuartel oeste

[Continuar](../continuar%20chrono.md) · [Índice](README.md) · [Entrega 53](53-del-castillo-a-las-ruinas-del-futuro.md)

La entrada izquierda al salir de la torre **sí es accesible durante la huida**:
lleva al cuartel oeste, mapa 25. Ya tiene orientación, escaleras, camas, mesa,
sillas y personas dinámicas. Se comprobó la vuelta a la sala principal. Se
completaron también la escena de huida hasta Bangor, la salida sur, la visita
al Tauritón de Trann, los cuatro cofres de Lab 16 y su salida al mapa exterior.

## Para jugar

- **Entrada izquierda:** desde el vestíbulo de la torre, la puerta izquierda
  lleva al cuartel oeste. Su vestíbulo y escalera larga pueden parecer otra
  torre. Baja al rellano, gira al este y baja esa escalera hacia las camas.
  Durante la huida los soldados te persiguen y pueden iniciar diálogos.
- **Regreso del cuartel:** sube la escalera larga, gira al oeste en el rellano
  y sube hacia el arco norte. Usa la referencia de la puerta para alinearte
  con su centro. Su salida devuelve al vestíbulo de la sala principal.
- **Continuar la huida:** desde la sala principal, baja al pasillo inferior y
  gira al este. Avanza los diálogos de soldados, Marle y el rey con aceptar.
  La escena lleva al Bosque Guardia. Sigue el sendero norte al este; si un
  guardia bloquea el paso, bordéalo por el sur y continúa al claro del portal.
- **Bangor:** baja por la escalera y sal al sur. La puerta sellada norte está
  bloqueada al llegar. El mapa exterior anuncia correctamente 2300 d. C.
- **Trann:** las referencias distinguen el pasillo de entrada, la rampa, el
  comerciante, la escalera inferior y el paso entre habitantes. El Tauritón
  se examina desde el sur mirando al norte. Su pregunta Sí/No y los mensajes
  de recuperación y hambre se leen. Para volver a la salida, usa la rampa
  noreste hacia el pasillo y el vestíbulo.
- **Lab 16:** se señalan los cuatro cofres y pasos intermedios entre
  escombros. Para abrir los cofres desde las posiciones probadas, mira al norte y examina. Las ratas tienen
  señal de peligro y aviso de robo; los combates conservan su lector habitual.

Control+F5 consulta una referencia y Control+F6 recorre las referencias. Dentro
de las salas se informa dirección y distancia; en el mapa exterior Control+F7
calcula una ruta a pie.

El bloque generado tiene **8 zonas y 57 referencias físicas**, además de las
personas y portales dinámicos. El bosque conserva tres referencias adicionales
que aparecen durante la persecución. Se mantienen las puertas, interruptores,
cofres y puntos de guardado anteriores de la prisión. El cuartel no tiene cofres
ni un punto de guardado nuevo.

Los aposentos reales, el comedor y sus torres opcionales quedan fuera de esta
ampliación, conforme al pedido de centrarse en la huida. El cuartel se conserva
porque se comprobó su entrada real y el usuario estaba entrando allí. Su retirada
inicial había dejado esa sala sin perfil; ahora hay una prueba que protege ese
acceso y su anuncio.

Por preferencia del usuario se retiraron las cuatro referencias «Acceso al
cofre» de Lab 16. Cada cofre conserva una sola referencia, su sonido de objeto
y su estado abierto; se mantienen los puntos de orientación entre escombros.

## Recorridos comprobados en el motor

Los nombres siguientes corresponden a capturas RAM/GD y registros conservados
en `test/future-check/`.

| Comprobación | Evidencia |
| --- | --- |
| Entrada izquierda real, mapa 21 → 25 | `left-start-observe`, `left-entry` |
| Rellano, giro y escalera larga | `left-barracks-down`, `left-barracks-stairs` |
| Aviso «¡Se escapan!» y soldados que se acercan | `left-barracks-warning`, `left-barracks-lower` |
| Regreso por escaleras, arco norte y vuelta al mapa 21 | `left-barracks-return-stairs`, `left-barracks-back-to-castle`, `left-barracks-exit-door` |
| Anuncio del cuartel con el perfil nuevo | `left-entry-with-guidance`, `reader-validation.txt` |
| Huida y escena de Marle y el rey hasta el bosque | `full-start` a `full-king-pages` |
| Paso del guardia por el sur y entrada al claro | `full-forest-lower-pass`, `full-glade-arrival` |
| Diálogos del portal y llegada al futuro | `full-glade-portal-scene`, `full-enter-portal`, `full-portal-second-entry` |
| Salida sur de Bangor y anuncio del año | `route-bangor-room`, `route-bangor-south` |
| Ruta exterior y entrada en Trann | `route-trann-via-planner` |
| Tauritón: pregunta, recuperación real de HP/MP y hambre | `route-trann-use-enertron`, `route-trann-rested` |
| Vuelta desde Trann al exterior | `route-trann-ramp-return`, `route-trann-door-return` |
| Primeros tres cofres de Lab 16 | `route-lab16-chest-south-open`, `route-lab16-chest-middle-open`, `route-lab16-chest-northwest-open` |
| Paso entre los dos sectores | `resume-lab16-west-exit` |
| Cuarto cofre | `resume-lab16-east-chest-open` |
| Salida de Lab 16 al mapa exterior de 2300 | `resume-lab16-final-exit-path` |

Los cofres dieron, por orden de comprobación: **Colérico, EspadaDura, Arco Duro
y Mini Eter**. Las pruebas verifican los cuatro bits nativos de apertura: no
se da por obtenido un objeto basándose únicamente en el texto del registro.
Se leyeron también el robo de las ratas, las victorias y Fogonazo de Lucca,
incluida su selección y coste, usado contra las Sombras.

Desde el punto inicial del castillo hasta el portal, Bangor, Trann y los tres
primeros cofres se usaron botones nativos, sin reposicionar al grupo ni alterar
indicadores de historia durante el recorrido. Se comprobó asimismo el regreso
por el portal. Al continuar tras el cierre de esa sesión, Lab 16 se retomó en
una copia desde el registro capturado en el tercer cofre, mediante el cargador
nativo y sus datos de grupo e historia. Desde esa reanudación se caminaron el
paso al segundo sector, el cuarto cofre y la salida, con sus combates reales.
No se presenta todo el trabajo de ambas sesiones como una única ejecución sin
interrupciones.

El nuevo acceso al cuartel se ensayó aparte desde el vestíbulo del castillo con
historia 46. Se entró, bajaron las escaleras, aparecieron las persecuciones y
se volvió al mapa 21 mediante sus conexiones originales. No fue necesario
abrir otra cámara ni recoger un cofre para continuar la huida.

## Sonidos y validación

Se corrigió `room-reader.lua`: salir al mapa **498** también anuncia la salida
con señal de puerta y detiene las señales ambientales de la sala. Antes solo
se reconocían allí los mapas exteriores de 1000 y 600. La prueba comprueba que
el aviso se emite una sola vez y que las escenas suspenden las señales ambientales.

`verify-future-audio.py` reproduce las capturas nativas a través del lector
real y del mezclador `chrono_audio.dll`. Comprueba cargas y señales de cama,
escalera, conexión, persona, puerta, cofre, mueble y enemigo, así como los límites
de volumen y estéreo. El mezclador recibe volumen cero en la copia para mantener
el ensayo en silencio; el volumen y posición solicitados quedan registrados.
También se verifica PCM no vacío de esos sonidos y del guardado existente.

Evidencias: `audio-validation.txt` para las señales durante el motor,
`audio-replay.txt` para la reproducción de capturas y `audio-assets.json` para
las muestras. Esto es validación técnica; la valoración personal con NVDA sigue
correspondiendo al usuario. No se cambiaron las DLL ni los sonidos originales.

Validación final: **393 pruebas aprobadas**, reproducción de audio aprobada,
audio nativo aprobado y sintaxis Lua aprobada. Recibos completos:
`unit-validation-54.txt` y `unit-validation-54-full.txt`. Los quince casos de
`test_future.py` incluyen la nueva sala, el anuncio de entrada, sus personas
móviles, el regreso, las escenas, los cuatro cofres y la salida de Lab 16.

## Archivos, protección y siguiente paso

Los cambios funcionales están en `room-profiles.lua`, `room-model.lua` y
`room-reader.lua`. El generador es `test/build-future-profiles.py`. La guía
temporal de persecución puede sustituir la guía habitual mientras el guardia
está presente; al desaparecer vuelve la guía normal del bosque.

Los guiones de control y combate automatizado están limitados a la copia
`future-check` y no forman parte del lector habitual. Se conservan los intentos
que encontraron paredes o personajes como `WALK STUCK`/`WALK NO PATH`; no se
cuentan como recorridos aprobados. Los `.csv` registran los caminos planificados;
la llegada real y el resultado se comprueban con las capturas y registros del motor.

La copia de pruebas quedó cerrada y su arranque volvió al castillo. El `.000`
habitual conserva el hash tomado al investigar la entrada izquierda
(`user-left-source-sha256.txt`). No se operó la instancia del usuario ni se
escribieron su ROM, SRAM o partidas.

Los cambios se cargan al iniciar el lector o con `recargar-lector.cmd` si está
abierto. Arris y el resto de áreas posteriores siguen siendo el siguiente tramo;
esta entrega termina en la salida de Lab 16.

Para retirar únicamente esta entrega, revertir las referencias y guías añadidas
por el generador, la guía condicional del bosque, el campo `replace` de
`room-model.lua` y el reconocimiento de 498 en la salida de `room-reader.lua`.
Conservar el soporte exterior de 2300 de la entrega 53 y los módulos de prisión.
No restaurar en bloque una copia antigua de perfiles sobre ampliaciones posteriores.
