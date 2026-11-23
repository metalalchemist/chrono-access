# 70. Guarida de los Reptiles y sus referencias

La orientación sonora cubre los nueve mapas conectados de la guarida: 283 a
290 y la cámara lateral 222. Hay 38 referencias: doce salidas de la tabla de
la ROM, nueve cofres, dieciséis agujeros y un punto de guardado.

Control+F6 cambia de referencia; Control+F5 anuncia dirección y distancia.
Los agujeros tienen señal de escalera y número estable por actor. Acércate
y pulsa A para bajar. La orientación no pulsa botones ni elige un agujero.
Los cofres conservan su numeración y dejan de sonar cuando están abiertos,
sin revelar su contenido. Los enemigos conservan la señal habitual.

## Sectores y conexiones

| Mapa | Sector | Conexiones |
| --- | --- | --- |
| 283 | Entrada | Exterior 499 y sala de excavación 284 |
| 284 | Sala de excavación | Entrada y agujeros hacia 285 |
| 285 | Galerías superiores | Agujeros hacia 286; uno puede llevar a 222 |
| 286 | Galerías intermedias | Agujeros hacia 287 |
| 287 | Galería inferior | Corredor 288 |
| 288 | Corredor del punto de guardado | 287, sala del fondo 289 y pasaje 290 |
| 289 | Sala del fondo | 288 y salida exterior condicionada por la historia |
| 290 | Pasaje de las lianas | 288 y cámara lateral 222 |
| 222 | Cámara lateral | 290 y agujeros hacia 287 o 284 |

Las distancias son directas; las paredes separan cámaras y pueden exigir
rodeos. Entrar en la sala del fondo puede iniciar escenas o un combate.
La guía no revela nombres de personajes, resultados ni recompensas.

## Evidencia y validación

Los mapas se cargaron mediante el motor nativo en la copia aislada y
silenciada del gestor `test/emulador-pruebas.ps1`. Se prepararon historia 111
y posiciones de entrada para investigar cada sector; no constituye una
recorrida completa desde una partida normal. Capturas y eventos:
`test/future-check/reptiles70-map*-ram.bin`, `.gd`, `.png` y `-events.txt`.

Los agujeros son actores NPC 133. Sus coordenadas cambian al excavar;
algunos aparecen dibujados en (8,16) antes de colocarse. El campo opcional
`entityBounds` del modelo filtra esas posiciones provisionales. Las
referencias usan `entity/followEntity` y desaparecen si se oculta o retira
el actor. No se anuncian también como personas. La numeración puede tener
huecos cuando todavía no están colocados todos los actores.

Se preparó una entrada junto al agujero inicial de 284. Después se enviaron
arriba durante cinco fotogramas y A durante uno: el propio juego cambió al
mapa 285, conservando historia 111. Evidencias: `reptiles70-hole-ready` y
`reptiles70-hole-crossed`. No se escribió el destino para ese cruce. Esto
verifica una interacción; no prueba todos los destinos ni una victoria.

`test/test_reptiles70.py` verifica las tablas nativas de salidas y cofres,
cofres abiertos, firmas de actores, posiciones provisionales, movimiento,
desaparición, ausencia de duplicados, Control+F6/F5 y silencio en menú.
Son cinco pruebas. `test/verify-reptiles70-audio.py` reproduce las nueve
capturas con proximidad simulada y el mezclador real silenciado; comprueba
las señales de puerta, cofre, escalera y guardado. No sustituye escuchar
con NVDA ni caminar toda la guarida con el control.

Resultado de esta entrega: cinco pruebas nuevas aprobadas; audio aprobado;
suite general de 489 pruebas, 481 aprobadas y los mismos ocho fallos previos
de `test_walk_trace`. Sintaxis Lua aprobada y todos los hashes protegidos
idénticos a los tomados al inicio de esta intervención.

Ejecutar `python tools/chrono-access/test/validate-reptiles70.py` registra
pruebas, suite general, sintaxis Lua 5.1 y hashes en
`test/future-check/unit-validation-70.txt` y `protected-hashes-70*.json`.

## Archivos y reversión

El perfil está en `rooms/profiles/reptiles.lua`; su generador es
`test/build-reptiles70.py`. Se carga explícitamente desde `rooms/profiles.lua`.
El único cambio del modelo compartido es el filtro opcional `entityBounds`.
No se cambió la política de registro de caminata ni los recursos de audio.

Para revertir la unidad, restaurar `rooms/model.lua`, `rooms/profiles.lua`
y `continuar chrono.md` desde `test/future-check/reptiles70-before`; retirar
el perfil y sus scripts/pruebas/documentación de la entrega 70. El respaldo
del modelo se reconstruyó retirando únicamente el bloque añadido. Los otros
archivos se copiaron antes de editarlos. No requiere modificar ROM ni partidas.

La sesión de pruebas se cerró antes de la suite general. No se abrió ni se
recargó una instancia habitual. Los cambios quedan disponibles en disco.
