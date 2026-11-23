# 78. Ruinas de la Guarida del Tirano

Después de derrotar a Azala y al Black Tyrano, las Ruinas Guarida tienen
orientación sonora: salida al sur y portal al norte. El mapa exterior ya
reconoce su entrada. Esta entrega añade el interior, mapa nativo 307.

## Para jugar

Control+F6 selecciona una referencia; Control+F5 consulta dirección y distancia.
Selecciona el portal, acércate y pulsa A. Al llegar por primera vez, termina
la conversación del juego para recuperar el control. Para salir al exterior,
dirígete al sur. Rodea las paredes: las distancias no trazan rutas.

El portal solo tiene referencia y sonido cuando su actor está visible.
Su destino y disponibilidad los decide la historia. No hay cofres ni punto
de guardado en esta sala. Los actores de efectos no se anuncian como personas.
Los cambios están disponibles al siguiente arranque o recarga del lector.

## Datos y comprobación

La tabla de salidas E50000 contiene una franja horizontal: x=0, y=13,
16 casillas de ancho, destino 499. La tabla de tesoros no tiene registros.
El actor 18 carga el NPC 151 y ofrece la interacción del portal; su posición
capturada es (136.125,67.875) píxeles. La referencia sigue ese actor y usa
el sonido `connection`. Los actores 16, 20 y 22 son efectos y se ocultan
como referencias de personas. No se modifica el modelo ni el lector común.

En la copia administrada y silenciada se verificaron:

- La conversación inicial y la recuperación del control.
- Control+F6 anunciando el portal al norte.
- Pulsar A cerca del portal: viaje nativo de 307 a 351 y avance de historia
  de 152 a 159, con llegada a la cueva ya cubierta por la entrega 75.
- Cruzar la salida sur: transición nativa de 307 a 499 sin cambiar historia.

Se prepararon historia y posiciones en la copia de pruebas. Esto verifica
las interacciones y transiciones, no un recorrido completo desde el combate
ni todas las variantes posteriores de historia. No se operó la partida habitual.
Pendiente valoración con NVDA y control Nintendo por el usuario.

Cuatro pruebas en `test/test_ruins78.py` verifican la geometría contra ROM,
visibilidad, ausencia de falsas personas, selección/consulta, silencio de menú
y reproducción de los destinos capturados. Ejecutar:
`python tools/chrono-access/test/validate-ruins78.py`.
El recibo `test/future-check/unit-validation-78.txt` conserva los resultados
de pruebas y la comparación de hashes: 538 pruebas, 530 aprobadas y los
ocho fallos previos. Sintaxis Lua aprobada; ROM y guardados protegidos sin
cambios. Los ocho fallos conocidos de
`test_walk_trace.py` siguen teniendo una política de inicio incompatible.

Evidencias: `test/future-check/ruins78-*-ram.bin`, capturas `.gd`,
`ruins78-initial-events.txt` y el registro acumulado `reader-validation.txt`.
El arnés usa el mezclador nativo con ganancia cero durante las pruebas.

## Protección y reversión

Respaldo en `test/future-check/ruins78-before`. Se cierra únicamente la copia
administrada; se restauran sus tres entradas de arnés al terminar.
ROM y guardados habituales se comparan por hash, sin restaurarlos.
No se hicieron commits: `tools/` está ignorado y requiere conservar el respaldo.

Para retirar esta entrega, quitar `ruinas-guarida` de `rooms/profiles.lua`
y retirar `rooms/profiles/ruinas-guarida.lua`, sus pruebas y documentación.
Las entregas anteriores, ROM y partidas se conservan.
