# 82. Estado de los libros de Enhasa y Kajar

Los tres libros de cada edificio anuncian «abierto» o «cerrado» al
seleccionarlos con Control+F6 y consultarlos con Control+F5. Acércate y pulsa
A para cambiar el estado. El lector consulta la marca nativa actual; no
cuenta pulsaciones ni conserva un estado propio al cargar o cambiar de sala.

| Marca nativa | Enhasa, mapa 355 | Kajar, mapa 357 |
|---|---|---|
| 7F0214, bit 1 | Libro del sur, actor 20, (256,384) | Libro central, actor 22, (208,240) |
| 7F0216, bit 1 | Libro del este, actor 22, (432,192) | Libro del noroeste, actor 24, (48,160) |
| 7F0218, bit 1 | Libro del noroeste, actor 26, (96,112) | Libro del sur, actor 26, (352,384) |

En la tabla, bit 1 significa máscara 0x01. Valor 1 anuncia abierto; valor 0,
cerrado. Las mismas variables gobiernan el cambio de baldosas de los libros.
Los comandos Set/Reset Byte usan 7F0200 + 2 × argumento: 0A, 0B y 0C.
Se usa el campo state ya soportado en rooms/model.lua; no cambia ese modelo.

Kajar añade sus tres referencias y excluye sus actores de las personas.
Enhasa conserva sus referencias, recuperación y escaleras. También se corrigen
los signos de interrogación que habían sustituido acentos en el texto de
recuperación. No se revela el orden de apertura de los mecanismos.

## Comprobación

Se abrió y cerró cada libro pulsando A en la copia administrada silenciada.
Se esperaron 200 frames para terminar la animación antes de cada captura:
las doce capturas finales muestran el bit correspondiente 1/0 y control libre.
Los intentos previos con esperas cortas no certifican el estado final.
Evidencias: test/future-check/books82-final-*-{abierto,cerrado}-ram.bin,
sus capturas GD y books82-final-native.json. Comparación visual de Enhasa y
Kajar en books82-final-visual.png.

Se prepararon historia 160 y posiciones de entrada. En Enhasa se completó
el diálogo del niño y se estableció la marca 7F00F4=4 para aislar el libro
noroeste de esa escena. Esto comprueba las interacciones nativas de los seis
libros; no certifica un recorrido completo ni la apertura de cámaras ocultas.

Dos pruebas de test_books82.py verifican las doce capturas y consultas F6/F5
que reflejan cambios nativos sin historial de botones. Las ocho pruebas de
test_zeal75.py y dos de test_enhasa81.py pasan. verify-books82-audio.py reproduce
las doce capturas con proximidad simulada y mezclador real silenciado; aprobado.

Suite general: 549 pruebas en 44,802 segundos; 541 aprobadas y ocho fallos
previos de test_walk_trace. Sintaxis Lua aprobada. Recibos: suite82.txt,
audio82-replay.txt y unit-validation-82.txt en test/future-check.

La copia administrada se cerró y las tres entradas del arnés se restauraron.
Nueve hashes de ROM/guardados habituales sin cambios. No se operó el juego
habitual. Pendiente valoración con NVDA/control; aplicar al arrancar o recargar.

## Reversión

Restaurar rooms/profiles/zeal.lua, test/build-zeal75.py, test/test_zeal75.py y
continuar chrono.md desde test/future-check/books82-before; retirar
test_books82.py, verify-books82-audio.py y esta nota. Las capturas se conservan.
