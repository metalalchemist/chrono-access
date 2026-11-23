# 79. Golpes de pared en 12000 a. C.

La superficie nevada y las islas de Zeal ahora reproducen el golpe de pared
cuando el motor rechaza un paso. Las pruebas confirman además que ese golpe
ya se disparaba en la cueva de llegada, Enhasa y Kajar.

## Para jugar

Inicia o recarga el lector. Al intentar caminar contra un obstáculo del
exterior de 12000 a. C., suena el golpe de pared. Los choques horizontales
se sitúan a izquierda o derecha. Mantener la dirección repite el aviso
con un intervalo mínimo de 25 actualizaciones, igual que en interiores.
No se añaden sonidos continuos de proximidad en el mapa exterior.

Las referencias y teclas anteriores se conservan. Esta entrega comprueba
choques; no completa acertijos, libros ni el inventario de referencias de 75.

## Hallazgo y cambio

La entrega 75 incorporó destinos y rutas del exterior, pero su lector no
emitía golpes de pared. Las colisiones físicas del juego estaban activas;
faltaba observarlas para producir el sonido.

`rooms/reader.lua` observa C236B6, la rama del motor a la que se llega
después de rechazar un paso en C236B1/C236B4. Comprueba antes la firma ROM
`BD 28 00 29 7F 9D 28 00`. Solo admite mapas 500 y 501 con modo 027C=1.
La orientación sale del campo 28 de la tarea activa (puntero 004E).
No se deduce un choque de estar quieto ni se inyectan entradas de juego.

El golpe pendiente se consume una vez al actualizar audio, después de
limpiar los sonidos de la habitación anterior. Se descarta si cambian
mapa o modo. Respeta la configuración general de sonido. No cambia
`rooms/model.lua`, `world-reader.lua`, ROM, sonidos ni guardados.

## Pruebas

`python tools/chrono-access/test/capture-walls79.py` ejecuta 17 casos en
la copia administrada y silenciada. Preparación de historia y posiciones;
las caminatas y el rechazo de pasos los ejecuta el motor con botones.
Se sale nativamente de la cueva al mapa 500 y de Enhasa al 501.

| Zona | Resultado observado |
| --- | --- |
| Cueva de llegada, 351 | Golpe al oeste y norte |
| Enhasa, 355 | Golpe al oeste |
| Kajar, 357 | Golpe al este |
| Superficie nevada, 500 | Golpes al oeste y este |
| Islas de Zeal, 501 | Golpes al oeste y norte |
| Reposo, 351/500/501 | Cero golpes |
| Menú con direcciones, 500/501 | Cero golpes |

Cada caso registra las llamadas reales al mezclador con identificador 4
(`wall_hit`), ganancia solicitada 0.55 y paneo. El arnés fuerza ganancia de
salida cero para no interferir con el usuario: esto comprueba la ejecución
del mezclador y la señal solicitada, no una escucha humana del dispositivo.
`wall_hit.wav` contiene PCM no nulo.

El arnés `test/check-future.lua` conserva ahora cada golpe, incluso si
repite volumen/paneo. Antes su deduplicación podía ocultar golpes posteriores
al primer registro. Esta mejora afecta solo a la evidencia de pruebas.

Cinco pruebas en `test/test_walls79.py`: contactos capturados, rama nativa,
paneo/cadencia, descarte por contexto, firma ROM y audio desactivado.
`python tools/chrono-access/test/validate-walls79.py` comprueba esas pruebas,
suite general, sintaxis Lua, PCM y hashes protegidos. Recibo completo:
`test/future-check/unit-validation-79.txt`.
Resultado: cinco pruebas nuevas aprobadas; suite de 543 pruebas con 535
aprobadas y los mismos ocho fallos previos de `test_walk_trace.py`.
Sintaxis Lua y PCM aprobados; hashes de ROM y guardados protegidos idénticos.

Evidencia nativa final: `test/future-check/walls79-final-native.json`,
capturas `walls79-final-*-ram.bin` y `.gd`. Investigación inicial:
`walls79-before-trace.csv` y capturas `walls79-*` sin `final`.
No se certifican los 52 interiores completos, todas las direcciones ni
las variantes posteriores de historia. Falta valoración del usuario con NVDA.

## Protección y reversión

No había emulador habitual abierto al comenzar. Solo se operó y cerró la
copia administrada; el validador restaura sus tres entradas de arnés.
ROM y guardados habituales se comparan por hash sin restaurarlos.
Se conserva el cambio ajeno de `config.json`. No se hicieron commits.

Respaldo: `test/future-check/walls79-before`. Para retirar esta entrega,
restaurar `rooms/reader.lua` desde ese respaldo y, opcionalmente, el arnés
`test/check-future.lua`. Sus pruebas y documentación son independientes.
Conservar las ruinas y demás perfiles de las entregas anteriores.
