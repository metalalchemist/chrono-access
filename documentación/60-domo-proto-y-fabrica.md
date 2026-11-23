# 60. Domo Proto y fábrica

Se añadieron once perfiles y 59 referencias en `room-profiles.lua` para Proto,
su cámara del portal y las salas de la fábrica: entrada, laboratorio superior e
inferior, almacén y pasarelas, salas de información y núcleo de energía.

Las referencias incluyen el Enertron de Proto, computadoras, ascensores,
escaleras, grúa, controles, salidas, punto de guardado y cofres. Los controles
no aparecen además como personas. Los enemigos conservan sus señales de peligro.
Las ayudas de estas salas no dan contraseñas ni combinaciones. La información
que el jugador consulte en las computadoras se lee mediante el diálogo normal.

Control F6 recorre referencias; Control F5 repite la referencia seleccionada y su
dirección. Examina las computadoras y el Enertron desde el sur con aceptar.
Los ascensores se señalan también cuando su uso depende de la historia; el jugador
elige los destinos en el menú del juego. Las distancias son directas, no rutas
que atraviesen paredes o niveles.

En todas las salas compatibles, el modelo nombra los cofres únicamente como
`Cofre 1`, `Cofre 2`, etcétera. La numeración es fija por sala, incluso cuando se
abre un cofre. Los cofres abiertos conservan su número en la consulta manual,
pero no tienen señal de proximidad. También se quitaron los contenidos de cofres
que aparecían en las ayudas de Lab 32 y la alcantarilla.

## Evidencia y límites

Validación final: **427 pruebas aprobadas**, sintaxis Lua y audio nativo aprobados.
La ROM y las partidas habituales conservaron sus hashes durante la validación.

Los accesos y cofres se obtuvieron de las tablas nativas de esta ROM. Las
computadoras, los ascensores y los controles se contrastaron con eventos y
capturas del juego en una copia aislada y silenciada. Las escaleras interiores
se anotaron desde las capturas con coordenadas. No se operó la partida habitual.

- Capturas: `test/future-check/proto60-map*-ram.bin`, `.gd` y `.png`.
- Eventos: `proto60-map*-events.txt`; rejillas: `proto60-grid*.png`.
- Pruebas: `test/test_proto_factory.py`; regresiones de cofres actualizadas.
- Audio real silenciado: `test/verify-proto-factory-audio.py`, con registro en
  `test/future-check/audio60-replay.txt`. Usa capturas nativas y posiciones de
  proximidad simuladas; no demuestra un recorrido caminando.
- Validación general y sintaxis: `test/future-check/unit-validation-60.txt`.
- Hashes de ROM y partidas durante la validación final:
  `test/future-check/protected-hashes-60.json`.

Queda pendiente recorrer de principio a fin Proto y la fábrica con el control,
validar la grúa durante su secuencia especial y valorar la orientación con NVDA.
Las secuencias automáticas conservan la suspensión normal del audio del cuarto.
No se añadieron automatismos para resolver claves o manejar la grúa.

## Archivos y mantenimiento

`room-model.lua` aplica la política común de cofres. El bloque `PROTO FACTORY` de
`room-profiles.lua` se regenera con `test/build-proto-factory.py`. Las copias
anteriores están en `test/future-check/room-*-before60` y `continuar-before60.md`.
No se cambiaron la ROM, sonidos, DLL ni partidas del jugador. No se hicieron
commits; `tools/` sigue ignorado por Git y requiere respaldo independiente.

Para retirar esta entrega, se puede quitar el bloque `PROTO FACTORY` y restaurar
`room-model.lua` desde `room-model.lua-before60`, junto con sus expectativas de
pruebas. Esa retirada revierte las nuevas referencias y la política de nombres
de cofres sin tocar VeMovie ni los datos del juego.
