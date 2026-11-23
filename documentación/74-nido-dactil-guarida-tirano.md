# 74. Nido Dáctil y Guarida del Tirano

Corrección posterior: [77. Interruptores y cofres del Tirano](77-interruptores-y-cofres-del-tirano.md)
añade el interruptor del salón de entrada, estados pulsado/no pulsado y
resuelve las listas redirigidas de cofres. El inventario corregido tiene
67 referencias, doce cofres, dos guardados y doce mecanismos. Las cifras
y limitaciones siguientes documentan la entrega 74 original.

Orientación en 12 mapas con 65 referencias: pasos, 11 cofres, dos puntos de
guardado, 11 mecanismos y tres actores dáctiles cuando están dentro del mapa.
Perfil: `rooms/profiles/dactil-tirano.lua`, cargado explícitamente.

## Para jugar

- Control+F6 cambia de referencia; Control+F5 anuncia dirección y distancia.
- Acércate y pulsa A para abrir cofres y accionar objetos. Los cofres se
  numeran sin revelar contenido; al abrirse pierden su señal sonora.
- En el Nido Dáctil sigue las rampas entre los tres mapas hasta la cima.
  La escena y el transporte dependen de la historia.
- En la sala de interruptores de la guarida, busca el «Interruptor del punto
  de guardado». Hace aparecer el círculo al oeste. Otros interruptores pueden
  ocultarlo, cambiar el suelo o iniciar combates; sus referencias lo advierten.
- El otro guardado está en la sala de Nizbel. Un enemigo puede bloquear el
  paso. Guardar sigue requiriendo las opciones y confirmaciones del juego.

Las direcciones son directas: rodea paredes, rocas y desniveles. Las escenas,
combates y elecciones se mantienen en el juego.

## Cobertura y procedencia

| Zona | Mapas | Cofres |
| --- | --- | --- |
| Nido Dáctil, senderos y cima | 293, 294, 295 | 3 |
| Exterior y salón de entrada | 299, 430 | 0 |
| Galerías y corredores | 298, 302 | 2 |
| Sala de interruptores | 303 | 1 |
| Sala de Nizbel y guardado | 304 | 0 |
| Almacén | 305 | 4 |
| Escalera superior y cima | 300, 301 | 1 |

Las salidas provienen de E50000 y los cofres de F5F000 de la ROM local.
`test/build-tyrano74.py` genera los perfiles y conserva los identificadores de
tesoro. Los eventos capturados identifican los mecanismos por sus funciones
de interacción, posiciones y modificaciones de suelo. Son referencias a
casillas de objetos, sin simular su activación ni afirmar estados de pulsación.

Los guardados usan los actores 16 de 303 y 22 de 304, NPC 121 con diálogo de
guardado 64. Su señal sigue dibujo, presencia y posición. Los actores de los
dáctiles usan límites para descartar posiciones de animación fuera del mapa.
Las piezas de escenas no se duplican como personas.

## Validación y límites

Se cargaron los 12 mapas con historia preparada 144 en una copia gestionada
y silenciada. En 303, desde 11,23, un cuadro de arriba y A activaron el
interruptor: el dibujo del actor del guardado pasó de 0 a 1. Desde el sendero
inferior se cruzó al mapa exterior 499 conservando historia 144. Estas cargas
no certifican el recorrido natural, transporte en dáctil, todos los mecanismos
ni los combates finales. Pendiente escuchar y recorrer con NVDA/control.

Siete pruebas cubren geometría de todas las salidas y cofres, cofres abiertos,
guardado oculto y activado, mecanismos, dáctiles fuera del mapa, teclado,
silencio en menús y salida nativa. El mezclador real se verifica silenciado
con proximidad simulada en los 12 mapas.

```powershell
python tools/chrono-access/test/validate-tyrano74.py
```

Suite: 511 pruebas, 503 aprobadas y ocho fallos previos de test_walk_trace.
Sintaxis Lua aprobada; ROM y partidas protegidas con hashes idénticos.

Resultados: `test/future-check/unit-validation-74.txt`. Capturas y eventos:
`tyrano74-map*`, `tyrano74-switch-*` y `tyrano74-dactil-exit*` en esa carpeta.
Audio: `audio74-replay.txt`. Se conserva también un intento preparado
`tyrano74-exit-ready` en 301, sin acreditar cruce.

## Protección y reversión

No se abrió ni recargó el juego habitual. Solo se inició y cerró la copia
gestionada. La validación compara SHA-256 de ROM y partidas protegidas.
No se hicieron commits; `tools/` está ignorado por Git.

Para retirar esta entrega, restaurar `rooms/profiles.lua` y `continuar chrono.md`
desde `test/future-check/tyrano74-before/` y retirar el perfil
`rooms/profiles/dactil-tirano.lua`. El respaldo incluye los comandos de la
herramienta de pruebas. Conservar generador, pruebas y evidencias juntos.
