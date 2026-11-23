# Objetivos accesibles de la tienda de los horrores

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

Los tres juegos tienen seguimiento hablado del objetivo y de sus premios reales.
Se completaron los tres en el motor de la ROM Magno: muñeco Poyozo, clon y gato.
La escucha y la facilidad de reacción con NVDA siguen pendientes de valorar.

## Para jugar

Ejecuta `tools/chrono-access/recargar-lector.cmd` para recoger los cambios sin
reiniciar la partida. La entrada a la tienda está al noreste de la entrada de
la feria. Dentro, Pepe Carrolla está al norte y el regreso al sur.
Control+F5 consulta una referencia y Control+F6 recorre las referencias visibles.
**Control+F10 consulta el objetivo o repite la orden actual del minijuego.**

| Precio | Qué escuchar y hacer |
| --- | --- |
| 10 Puntos de Oro | Se anuncia a quién buscar y quién está a la izquierda, en el centro y a la derecha. Acércate al soldado solicitado y pulsa A. Los nombres de esta traducción son Rafa, Carlos y Fonso. |
| 40 Puntos de Oro | Escucha L, R, A o Y. Mantén esa tecla hasta el pitido de aceptación y suéltala. Espera la siguiente orden; hay 22 rondas. Control+F10 repite la orden y el número de ronda. |
| 80 Puntos de Oro | Necesitas un compañero. Usa las piedras izquierda, central y derecha mirando al norte y pulsando A. Se anuncian los monstruos que se acercan y los encerrados. Al aviso de luz azul, acércate a esa luz a la izquierda y pulsa A para subir la cuerda del rehén. |

Se anuncia el descuento real de puntos. Los premios se anuncian cuando cambian
sus datos en el juego. Los textos y las opciones de precio continúan a cargo
del lector común. No hay selección ni respuesta automática al jugar.

En la mímica, L corresponde al brazo izquierdo, R al derecho, A a sorpresa e Y
a risa. El código interno 0 requiere R y el 1 requiere L; no deducir el botón
a partir de la posición visual del brazo del clon. El aviso hablado es corto
e interrumpe la locución anterior para conservar el tiempo de respuesta.
El pitido nuevo confirma la respuesta nativa registrada, sin adelantar la ronda.

La luz azul del reto de monstruos tiene prioridad sobre los avisos de peligro.
Control+F10 también permite consultar cuáles siguen libres y su distancia
vertical. Las referencias son distancias directas; no calculan rutas entre
personajes y obstáculos. Las piedras y la luz dejan de anunciarse cuando
el motor las oculta. Los monstruos y soldados conservan sus posiciones reales.

## Verificación

Se conservaron los ensayos en `tools/chrono-access/test/horrors-check/`.
El control de pruebas introduce botones y objetivos de interacción; **no es
evidencia de rutas completas a pie ni de la reacción de una persona con NVDA**.
Las victorias, los descuentos, la mezcla, las rondas, el descenso de la cuerda
y los premios los ejecutó el motor nativo. No se escribieron victorias o premios.

| Ensayo nativo | Resultado observado |
| --- | --- |
| Soldados, primer acierto | 200→190 puntos; nuevo muñeco Poyozo. Fonso estaba a la izquierda. |
| Soldados, repetición | 190→180 puntos; dos unidades de comida para gatos. Rafa estaba en el centro. |
| Mímica, ensayo corto | 180→140 puntos; fallo en la cuarta ronda por soltar pronto Y; sin clon. |
| Mímica completa | 140→100 puntos; 22 respuestas aceptadas, incluidas repeticiones, y clon nuevo. |
| Monstruos con Crono solo | Rechazo nativo y 100 puntos conservados. |
| Monstruos con Crono y Marle | 100→20 puntos; tres monstruos encerrados, luz activada, cuerda 180→68 y gato nuevo. |

Los puntos iniciales y la incorporación de Marle se prepararon únicamente en
la copia de ensayo. El primer acceso a la tienda utilizó el cargador nativo de
localizaciones desde el mapa 2. Los accesos posteriores atravesaron la puerta
desde una posición cercana reubicada. No acreditar la historia de Marle ni
una caminata continua desde casa con estos ensayos.

Evidencia principal:

- `reader-validation.txt`: diálogos reales, precios, negativas y premios.
- `horrors-reader.txt`: observaciones del lector, órdenes y cambios de estado.
- `native-cases.txt`: casos, respuestas de mímica y finales.
- `refill-real-ram.bin` y `guess-native-1-exit-ram.bin`: primer premio y coste.
- `mimic-round-1-ram.bin` hasta `mimic-round-22-ram.bin`: ventanas nativas de respuesta.
- `mimic-40-complete-exit-ram.bin`, `solo-refusal-ram.bin` y
  `monsters-80-native-exit-ram.bin`: clon, negativa y gato.
- `sessions/`: configuración y autorun archivados al cerrar la copia compartida.

Los registros preliminares se conservaron. Un ensayo inicial de soldados quedó
con la etiqueta `mimic-native-win`; no confundirlo con la mímica completa, cuya
etiqueta es `mimic-40-complete`. También hubo un aviso preliminar de derrota
después de ganar: el soldado atraviesa el tramo de salida común. El lector
final conserva el primer resultado terminal y tiene una prueba contra esa
regresión. El pitido de aceptación se comprueba por reproducción de estado;
la secuencia completa nativa anterior ya verificó las 22 respuestas.

`test_horrors.py` aporta diez pruebas: estados y firmas, objetivos y seis
permutaciones de soldados, costes y premios, las 22 rondas, la correspondencia
de botones de ROM, luz y monstruos, referencias móviles y evidencia nativa.
Suite completa: **226 pruebas aprobadas**. El mezclador nativo también pasa
`python tools/chrono-access/test/check_audio.py`, sin reproducción audible.

## Datos para continuar

Código de ejecución en `tools/chrono-access/`: `horrors-model.lua`,
`horrors-reader.lua`, integración en `lector-snes9x.lua` y perfil ampliado de
`room-profiles.lua`. Son observadores: no escriben RAM ni introducen botones.

El mapa es 434 y contiene 24 objetos. Los soldados son 40, 42 y 44; los
monstruos 30, 32 y 34; las piedras 24, 26 y 28; la luz 16 y el clon 18.
Las posiciones de las piedras son (104,146), (136,146) y (168,146); luz (40,148).
El perfil permite expresamente el tipo 3 del clon, separado de los compañeros.

Los operandos de memoria local se multiplican por dos, según las rutinas
C062DE y C068A5. Las direcciones siguientes son las efectivas:

| Dato | RAM |
| --- | --- |
| Juego de soldados/monstruos activo | 7F0216 |
| Soldado solicitado: 1 Rafa, 2 Carlos, 3 Fonso | 7F0218 |
| Copia local de puntos | 7F021A |
| Ronda de mímica | 7F0210 |
| Gesto solicitado y respuesta; 80 hexadecimal significa espera | 7F0220 / 7F0222 |
| Descenso de la cuerda, palabra | 7F0224 |
| Máscara de monstruos encerrados | 7F0232 |
| Puntos, muñecos/gato, clones y comida, persistentes | 7F0052 / 7F005D / 7F005E / 7F005F |

Los offsets de evento 328, 59C y 8C0 inician las partes observadas de mímica,
soldados y monstruos. Las firmas y los punteros se contrastan con la captura
`leene-check/tent-ready-ram.bin`. `inspect-horrors.py` lee metadatos mediante AST
de la [tabla de eventos de Temporal Redux](https://github.com/OnemusCT/temporal-redux/blob/main/sourcefiles/jetsoftime/eventcommand.py),
sin importar ese código externo. `decode-horrors-text.py` contrasta los textos
en ROM y su diccionario DEFA00. Estos archivos de investigación no se cargan
al jugar.

## Operación y reversión

El ensayo usó el emulador compartido silenciado y una sesión de herramientas
persistente (`run-horrors-session.ps1`). Revisar sus comandos pendientes antes
de repetirlo: `native-case.lua`, `reader-command.lua` y `session-command.txt`.
`start-horrors.lua` utilizado en esta entrega espera una escena de campo
ya disponible para cargar la tienda; no es un arranque automático desde cero.
El cierre forzado del gestor usa ahora el objeto Process previamente verificado
y un plazo de cinco segundos, tras observar una excepción de Stop-Process.
La instancia de pruebas quedó cerrada. El emulador habitual, su configuración
y sus partidas no se operaron.

Reversión de esta unidad: retirar los dos módulos `horrors-*`, su creación y
tick del lector principal, y restaurar las referencias anteriores del perfil
`leene_horrors`. El cambio de cierre del gestor es independiente. Conservar
ROM, sonidos, partidas y evidencias. No se tocaron cambios ajenos de VeMovie.
