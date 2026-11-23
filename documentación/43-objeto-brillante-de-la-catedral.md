# Señal para el objeto brillante de la catedral

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

Corrección posterior: [44. Parpadeo sin repetir la nave](44-parpadeo-del-objeto-sin-repetir-la-nave.md).
La presencia ahora se determina por actividad del actor, no por su dibujo
intermitente. El primer criterio provocaba avisos repetidos al parpadear.

Cuando aparece el objeto del suelo de la nave, el lector reproduce una vez el
sonido de objeto recogible y avisa de que hay un objeto brillante. Espera a que
termine el diálogo para no solaparse con él. La señal inicial funciona aunque
el objeto quede fuera del radio habitual de proximidad.

Después, su sonido de proximidad permite acercarse. Control+F6 lo recorre como
«Objeto brillante en el suelo; examina con A» y Control+F5 consulta la distancia.
No revela su identidad ni su dueño. Al recogerlo desaparece de las referencias
y deja de sonar. Los enemigos conservan `enemy` y las personas sus números.

## Datos y evidencia

Se identificó el actor 28 del mapa 129: inicializador gráfico `82 70`, posición
X=136, Y=175.9375. El estado nativo antes de hablar es tipo 4 y dibujo 0. Tras
la conversación cambia el dibujo a 1; después de la recogida queda tipo 128 y
dibujo 0. La posición del sonido se lee de la RAM, sin coordenadas fijas nuevas.

`test/cathedral-object-check/before-talk-ram.bin`, `appearance-ram.bin` y
`pickup-complete-ram.bin`, junto a sus capturas GD y `reader-validation.txt`,
conservan conversación, aparición y recogida reales del motor. Se usó una
copia aislada y silenciada con registros de personajes y flags copiados de una
captura antigua; las posiciones y botones se inyectaron únicamente allí.
La sesión de pruebas quedó cerrada y la partida habitual no se modificó.

`test/test_cathedral_object.py` comprueba los tres estados nativos, proximidad,
distancia, exclusión de actores retirados y señal única de aparición tras el
diálogo, incluso a más de cuatro casillas. La notificación sonora se verifica
con el mezclador simulado; falta valoración auditiva con NVDA.
**328 pruebas aprobadas**, incluidas cuatro específicas del objeto. La ejecución
general queda en `test/cathedral-object-check/unit-validation.txt`.

## Implementación y activación

`room-profiles.lua` clasifica el actor como objeto mediante `nonPeople` y sonido
`item`. La guía visible del actor solicita el mismo sonido. `room-model.lua`
devuelve el sonido opcional de la guía y `room-reader.lua` lo usa al anunciar su
aparición. Las guías existentes sin sonido conservan su señal anterior.

No había emulador habitual abierto al terminar; se cargará al próximo inicio
normal del lector. Para retirar esta entrega,
quitar la entrada del actor 28 y su guía del perfil `cathedral_129`; el soporte
opcional de sonido en las guías puede conservarse sin afectar otros perfiles.
