# 80. Libros de Enhasa y portal de llegada

Control+F6 permite seleccionar Libro del sur, Libro del este y Libro del
noroeste. Control+F5 consulta dirección y distancia. Acércate y pulsa A.
Los nombres describen su ubicación sin revelar el orden del mecanismo.

Los actores nativos 20/22/26 editan las baldosas de los libros en
(256,384), (432,192) y (96,112). El 24 es un efecto visual. Se excluyen
de las personas. Se conservan las otras interacciones de los actores 40/44/48.

En la cueva 351, los actores 16/18 pertenecen a escenas, 20/22 son efectos
y 24/26 forman el portal. Ninguno se numera como persona. Portal temporal
sigue la posición y visibilidad del actor 24 alrededor de (112,80).
La salida sur sigue descrita en la orientación; falta su referencia seleccionable.

Cambios: rooms/profiles/zeal.lua y test/build-zeal75.py. Reversión: restaurar
ambos desde test/future-check/books80-before y retirar las dos pruebas nuevas
de test/test_zeal75.py. Aplicación al arrancar o recargar el lector.

Validación: ocho pruebas de test_zeal75.py aprobadas, incluidas dos nuevas
sobre libros, personas falsas y visibilidad del portal. El arnés
test/verify-enhasa80-audio.py reproduce capturas 351/355 con proximidad
simulada y mezclador real silenciado; aprobado, recibo audio80-replay.txt.
No se ejecutó una caminata nativa nueva ni la secuencia de apertura de libros.
No se operó la partida habitual. Pendiente valoración con NVDA/control.

Suite general: 545 pruebas, 537 aprobadas y ocho fallos previos de
test_walk_trace. Sintaxis Lua aprobada. Recibo: unit-validation-80.txt.
