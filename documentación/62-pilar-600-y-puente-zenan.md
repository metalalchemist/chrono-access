# 62. Pilar de 600 d. C. y puente Zenan

Se añadieron 20 referencias: diez entre el puente Zenan normal y destruido,
nueve en la cocina y sala principal de Guardia y una para el portal de Plaza
Leene después de visitar el Fin del Tiempo. Se conservan los lectores de diálogo,
decisiones, combate y cofres abiertos, y las personas siguen numeradas.

## Pilar de 600 d. C.

El pilar del Desfiladero no aparece solo por terminar Hecran o cambiar de
capítulo. Debes usar el portal del recinto de los teleportadores, al norte de
Plaza Leene en 1000 d. C. Después de llegar al Fin del Tiempo ese portal registra
los dos pilares: Plaza Leene y Desfiladero de 600 d. C.

Lo confirma el evento nativo del actor 50 del mapa 8: activa el bit 0 de
7F00A6 y cambia al mapa 464. El actor 38 del mapa 464 consulta ese mismo bit para
habilitar el destino 113 (Desfiladero). La referencia anterior ya consultaba
correctamente ese dato; faltaban la explicación y la referencia del portal de
la feria, cuyo actor estaba oculto en la lista de personas.

Ahora la ayuda del Fin del Tiempo explica el paso pendiente cuando falta ese
bit. Al desbloquearlo deja de dar esa explicación. El recinto tiene una referencia
propia del portal, condicionada por su presencia y por haber llegado al Fin del
Tiempo. No se escriben flags ni se crean pilares que el juego aún no habilita.

El recorrido coincide con la [guía de The Village of Magic](https://www.thonky.com/chrono-trigger/village-of-magic).

## Puente y víveres

Control+F6 recorre referencias y Control+F5 repite la seleccionada. La salida
este conecta con la orilla norte del mapa exterior; la oeste con la orilla sur.
Hay referencias del puesto del capitán, la entrada al tablero y tres tramos del
puente. Los tramos oriental y central muestran su estado de encuentro pendiente
o superado con los flags nativos. La orientación se suspende durante el combate
y las escenas mediante los mecanismos anteriores. El puente destruido conserva
solo su salida válida y un punto de referencia del extremo cortado.

La secuencia de este capítulo es hablar con el capitán, ir a la cocina de
Guardia, hablar con el cocinero, recoger la entrega al regresar por el pasillo
oriental del castillo y volver al capitán. Después de entregar los víveres hay
que hablarle otra vez para aceptar ayudar. Los textos y las decisiones se leen
normalmente; el lector no los confirma por el jugador.

El puesto del capitán y la zona del cocinero siguen la posición real de sus
actores. Son referencias de orientación y conservan además las personas numeradas.
Se añadieron referencias de mesas, fogones y pasillos de la cocina, y del pasillo
oriental de la entrega en la sala principal. No hay cofres nativos en los mapas
de ambos puentes; el cofre existente de la cocina conserva su estado abierto.

El alcance se contrastó con la [guía de Zenan Bridge](https://vorxu.com/chrono-trigger/walkthrough/the-hero-appears).

## Comprobación y límites

Validación final: **439 pruebas aprobadas**, sintaxis Lua y audio nativo aprobados.
ROM, SRAM y partidas conservaron sus hashes desde antes de la investigación.

- Tablas de salidas: ROM nativa, mapas 133 y 135. Eventos en
  test/future-check/zenan62-*-events.txt.
- Capturas independientes: zenan62-before, wrecked, kitchen, hall, fair y canyon.
- Interacciones nativas: zenan62-native-captain-request, cook-finish0,
  handoff-finish0, captain-give, captain-finish y captain-accept.
- Las interacciones observaron petición de comida, diálogo del cocinero,
  entrega de víveres, recepción por el capitán y aceptación de ayuda. Se
  reubicaron posiciones en la copia de pruebas; no fue un recorrido completo.
- zenan62-battlefield y zenan62-after son estados preparados para inspección.
  No prueban que se hayan ganado las batallas. Un ensayo previo de carga directa
  del castillo se atascó; se corrigió entrando por el sector sur antes de la
  entrega. No se utilizó ese ensayo fallido como prueba de éxito.
- Pruebas: test/test_zenan.py, test/test_time_medina.py y regresiones anteriores.
- Mezclador real silenciado con proximidades simuladas: verify-zenan-audio.py y
  test/future-check/audio62-replay.txt.
- Suite completa, sintaxis Lua, audio nativo y hashes:
  test/future-check/unit-validation-62.txt y protected-hashes-62.json.

Quedan pendientes el recorrido completo con control, las batallas del puente y
la valoración con NVDA. No se operó la partida habitual. Los hashes anteriores
a la investigación permiten comprobar ROM, SRAM y partidas durante toda la
entrega, no solo durante la suite final.

## Mantenimiento y reversión

El generador test/build-zenan62.py mantiene el bloque ZENAN y los bloques
ZENAN CASTLE 62 que amplían perfiles existentes. test/build-time-medina.py
mantiene la nueva ayuda condicional del Fin del Tiempo. room-model.lua incorpora
ayudas por flags, condición de historia en ayudas de actores y seguimiento de
posición en referencias con followEntity.

Para retirar las referencias del puente, castillo y feria, quitar esos bloques.
Para retirar también la ayuda de desbloqueo y el soporte del modelo, restaurar
los archivos correspondientes desde *-before62 en test/future-check, conservando
las ampliaciones posteriores que existan. Las dos unidades son orientación del
portal y puente/víveres; no requieren cambios en VeMovie, ROM, DLL o sonidos.
No se hicieron commits. tools/ sigue ignorado por Git y requiere respaldo propio.
