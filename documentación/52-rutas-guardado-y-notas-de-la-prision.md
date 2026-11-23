# Rutas, guardado y notas de la prisión

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

Se atendió `chrono.txt`: la entrada tiene referencias para subir a vigilancia,
los corredores señalan sus escaleras y rellanos en ambos sentidos, vigilancia
tiene su punto de guardado y las notas del suelo se identifican como objeto.
También se corrigió la guía que confundía la celda de los dos cofres con la
celda inicial, y se añadió su subida de regreso al agujero superior.

## Para orientarse

- **Entrada a vigilancia:** desde el arco del este, baja al pasillo inferior,
  ve al oeste y sube la escalera oeste. En vigilancia, la mesa se bordea por
  el sur para llegar al guardado del este. Para volver, baja la misma escalera.
- **Escalera de vigilancia:** en el corredor superior junto a la entrada hay
  un rellano norte y otro sur. Desde el tramo de entrada avanza al este,
  baja entre los rellanos y toma el tramo hacia el oeste al corredor central.
- **Cruces de escaleras:** cada cruce, occidental u oriental, tiene un rellano
  superior y otro inferior, unidos caminando al norte o al sur. Las cuatro
  ramas tienen referencias que indican el puente o las celdas de destino.
- **Guardado:** «Punto de guardado de vigilancia» usa el sonido original de
  guardado. Su referencia aparece cuando el actor está presente. Se conserva
  el guardado de la celda inicial; son dos puntos identificados en la prisión.
- **Notas:** «Notas del suelo sobre el Dragón Tanque» usa sonido de letrero.
  Acércate y examina con aceptar. La pregunta de lectura y las páginas del
  manual siguen siendo las del juego.
- **Celda de los dos cofres:** su guía explica dónde estás y señala «Subida
  al agujero superior». Ya no da instrucciones de esperar la ejecución allí.

Control+F6 recorre referencias y Control+F5 consulta dirección y distancia.
Las distancias son directas: las ramas separadas de una escalera se siguen
pasando por sus rellanos, y las rejas siguen bloqueando el movimiento.

## Qué se comprobó en el motor

Se usó la copia aislada `prison-check`, con contador de historia 46 y flags de
escenas/encuentros preparados. Las posiciones iniciales se cargaron de forma
independiente. Esto no demuestra una fuga continua desde el juicio.

La ruta occidental sí se recorrió con botones nativos desde la entrada a
vigilancia, pasando por las escaleras hacia el corredor central y el inferior,
hasta el puente 2, y de regreso a la entrada. No hubo reposiciones intermedias
en ese recorrido. Las capturas están en `test/prison-check/`:

| Prueba | Capturas principales |
| --- | --- |
| Pasillo inferior y subida a vigilancia | `routes-bottom-west`, `routes-climb-office` |
| Guardado accesible | `routes-savepoint-arrival` |
| Entrada al corredor superior | `routes-corridor-arrival` |
| Bajada al corredor central e inferior | `routes-stairs-to-central`, `routes-west-crossing`, `routes-west-lower-landing` |
| Llegada al puente 2 y regreso | `routes-west-lower-stair`, `routes-lower-return`, `routes-central-return-upper`, `routes-return-entry` |
| Notas, pregunta y páginas del manual | `routes-read-notes`, `routes-notes-pages`, `routes-notes-end` |

El guardado de vigilancia es el actor 6 del mapa 29. Su inicialización contiene
la firma `82 79`, y acercarse a X=216, Y≈176 activó el bit de guardado `7F01CF:80`.
Las notas son el actor 24: se sigue su posición real, X=152 en la escena probada,
en vez de fijarla en la posición distinta de una captura anterior. Ambos dejan
de anunciarse como personas. El guardia conserva su número.

El registro contiene «Un documento "Top Secret" se ha caído al suelo»,
«¿Leerlo? Sí. No.», la selección real de Sí y las páginas del «Manual del
Dragón Tanque», incluida su explicación de la cabeza y los escudos.

Las doce conexiones de escalera del mapa 72 se cotejaron con las tablas de la
ROM. La puerta de la sala de tortura conserva sonido de puerta. Los puntos del
cruce oriental se comprobaron contra el suelo nativo y sus destinos; falta
recorrer todas sus ramas de forma continua. El corredor superior principal se
recorrió hasta el puente 3 en una comprobación independiente.

La subida de la celda de los dos cofres corresponde al actor 70 del mapa 71.
Su activación llama a la función 6 del actor 40 y vuelve al mapa 71, casilla 9,9.
Se verificaron ese guion y la referencia, pero la reconstrucción aislada de
la animación de retorno no fue concluyente. Falta comprobar físicamente el
regreso desde una caída legal; no se presenta como ya recorrido.

## Validación y activación

`test/test_prison_routes.py` comprueba las rutas capturadas, el bit de guardado,
los actores y su presencia, las páginas del manual, los destinos de las doce
escaleras, el suelo de los puntos, las guías de cada celda y la separación de
las ramas orientales y occidentales. El resultado general está en
`test/prison-routes-check/unit-validation.txt`: **378 pruebas aprobadas**.
Falta valoración auditiva con NVDA.

El lector conserva veinte zonas anteriores y divide tres sectores de corredores
que contenían lugares desconectados: ahora hay 23 zonas y 117 referencias físicas,
además de las referencias dinámicas a personajes, guardado y notas.

Los cambios funcionales están en `room-profiles.lua`, su generador
`test/build-prison-profiles.py` y la selección de guía por área de `room-model.lua`.
Para revertir esta entrega, retirar sus puntos y divisiones del generador,
restaurar las guías anteriores y quitar `guidanceAreas` del modelo. Las entregas
49–51, incluidos interruptores y escalada del muro, son independientes.

La copia de pruebas quedó cerrada. No había un Snes9x habitual abierto al iniciar
la comprobación; no se abrió ni modificó la partida habitual. Se cargará al
próximo inicio del lector o con `recargar-lector.cmd` si la partida está abierta.
