# 73. Ruinas Laruba, 65 millones a. C.

El mapa 292 tiene orientación hacia su salida sur, el cacique y Nu cuando están
presentes. Los otros cuatro habitantes conservan las referencias de personas
numeradas. El perfil está en `rooms/profiles/laruba.lua`.

## Para jugar

Control+F6 cambia de referencia; Control+F5 consulta dirección y distancia.
La salida al mapa exterior está al sur y el cacique al norte cuando sigue en
la aldea. Rodea vegetación y restos siguiendo los claros: las distancias son
directas. Acércate y pulsa A para hablar. Las escenas y elecciones siguen en
el juego. Los habitantes y Nu aparecen según la historia.

## Evidencia y límites

La entrada nativa del mapa exterior identifica el destino 292 con el nombre
81, Ruinas Laruba. Su única salida procede de E50000: x=7, y=31, ancho de dos
casillas, destino 499. Los eventos capturados identifican al cacique (actor 16)
y a Nu (26); el actor 28 es parte de su animación y no se duplica como persona.
Ambas referencias siguen posición y presencia, con límites para descartar las
coordenadas 4080,4080 que usan los actores sin colocar.

Se capturaron dos cargas preparadas, con historias 144 y 183. En la primera
hay cacique y cuatro habitantes; en la segunda están ausentes y aparece Nu.
Desde esta segunda carga, 45 cuadros de abajo cruzaron naturalmente a 499
con historia 183. Estas cargas no certifican el desarrollo natural de las
escenas ni todas las conversaciones. Falta escuchar y recorrer con NVDA/control.

Cinco pruebas verifican geometría nativa, ambas poblaciones, seguimiento y
desaparición, consultas de teclado, silencio en menús y salida capturada.
El mezclador real se prueba silenciado con proximidad simulada.

```powershell
python tools/chrono-access/test/validate-laruba73.py
```

Resultados completos: `test/future-check/unit-validation-73.txt`.
Suite: 504 pruebas, 496 aprobadas y los mismos ocho fallos previos de
`test_walk_trace`. Sintaxis Lua aprobada. La validación termina con error
porque cambió el guardado habitual `.001` durante la sesión (fecha de escritura
21:25:11); no se restauró ni sobrescribió. La ROM y los demás archivos
protegidos conservan sus hashes. No se atribuye la causa de ese cambio.
Capturas: `laruba73-map292`, `laruba73-late` y `laruba73-exit`, en esa misma
carpeta. Eventos: `laruba73-map292-events.txt`; audio: `audio73-replay.txt`.

## Protección y reversión

No se abrió ni recargó el juego habitual. Solo se ordenó cerrar la instancia
gestionada de pruebas. Al finalizar ya no había procesos Snes9x. La validación
compara SHA-256 de ROM y partidas, con la diferencia indicada arriba.
No se hicieron commits; conservar el respaldo porque `tools/` está ignorado.

Para retirar esta entrega, restaurar `rooms/profiles.lua` y `continuar chrono.md`
desde `test/future-check/laruba73-before/` y retirar el perfil `laruba.lua`.
Pruebas, documentación y evidencias pueden archivarse junto al respaldo.
