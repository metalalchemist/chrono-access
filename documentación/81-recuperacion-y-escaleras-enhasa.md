# 81. Recuperación y escaleras de Enhasa

Enhasa añade cinco referencias seleccionables con Control+F6. Control+F5
consulta la dirección y distancia de la referencia elegida.

- Cuadrado de recuperación de HP y PM, al oeste: entra caminando, sin pulsar A.
- Escalera sur, pie y parte superior: sube al norte y baja al sur.
- Escalera norte, pie y parte superior: sube al norte y baja al sur.

Las escaleras conectan sectores del mismo mapa, sin transición de habitación.
Los extremos tienen sonido de escalera y no bloquean el paso. El cuadrado
usa sonido de conexión y no se presenta como punto de guardado.

El actor 66 comprueba las casillas X 3..4 e Y 16..17 y ejecuta Restore hp/mp
en 0A30. La referencia ocupa [48,256,80,288]. Sus coordenadas proceden del
evento nativo, no de la posición del actor controlador.

La escalera sur tiene referencias [288,352,320,368] y [288,272,320,288].
La norte tiene referencias [240,224,272,240] y [240,176,272,192]. Se comprobaron
con capturas visuales y caminatas nativas en una copia administrada silenciada.
Desde (304,360), cien ticks hacia arriba cruzaron la escalera sur; cien hacia
abajo permitieron regresar. Desde (256,240), setenta ticks hacia arriba y
setenta hacia abajo cruzaron la norte en ambos sentidos. Evidencias:
test/future-check/enhasa81-lower-{up,down} y enhasa81-upper-{up,down}.

En la copia aislada se preparó a Crono con HP=1 y PM=1 fuera del cuadrado.
Al caminar de (64,304) a (64,264), ambos valores llegaron a sus máximos.
Evidencias: enhasa81-heal-before/after-ram.bin. La preparación modifica solo
la RAM de pruebas; no representa una partida jugada desde el inicio.

Dos pruebas nuevas en test/test_enhasa81.py verifican las capturas y la
selección/consulta de las cinco referencias mediante el lector. Las ocho
pruebas de test_zeal75.py también pasan. test/verify-enhasa81-audio.py reproduce
capturas con proximidad simulada y mezclador real silenciado, aprobado.
Recibo de audio: test/future-check/audio81-replay.txt.

Cambios de producción limitados a rooms/profiles/zeal.lua y su generador
test/build-zeal75.py. Reversión: restaurar ambos y continuar chrono.md desde
test/future-check/enhasa81-before; retirar test_enhasa81.py y esta nota.
Las entradas de arnés se restauraron y la copia administrada quedó cerrada.
El juego habitual abierto no se operó. Pendiente valoración con NVDA/control.
Aplicar al arrancar o recargar el lector.

Suite general: 547 pruebas, 539 aprobadas y ocho fallos previos de
test_walk_trace (52,408 segundos). Las diez pruebas específicas de Enhasa/Zeal
pasaron. Sintaxis Lua aprobada y nueve hashes protegidos sin cambios.
Recibos: test/future-check/unit-validation-81.txt, enhasa81-native.json,
audio81-replay.txt y suite81.txt. Se verificó HP 1→161 y PM 1→22.
