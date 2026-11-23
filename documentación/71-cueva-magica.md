# 71. Cueva Mágica de 600 d. C.

La orientación reconoce la entrada cerrada (163), la entrada abierta (435)
y el pasaje interior (164). Se carga desde `rooms/profiles/cueva-magica.lua`.

## Para jugar

- Control+F6 cambia la referencia; Control+F5 anuncia dirección y distancia.
- En la entrada cerrada, la roca está al norte y la salida al sur. La apertura
  sigue dependiendo de la historia y del grupo del juego.
- En la entrada abierta, el paso norte entra en la cueva y el sur sale al exterior.
- Dentro, el paso suroeste vuelve a la entrada y la salida noreste lleva al otro
  lado. Sigue senderos y escaleras: una referencia no calcula un camino recto.
- Hay referencias para los restos con una nota y el cofre sellado. Acércate y
  pulsa A; el juego conserva sus condiciones, diálogos y decisiones. El lector
  numera el cofre sin revelar el contenido. Enemigos con la señal habitual.

Son ocho referencias: cinco salidas, roca, nota y cofre. El murciélago decorativo,
la nota y el cofre no se anuncian además como personas. Nota y cofre siguen los
actores nativos 48 y 50; el cofre usa el estado de recogida 7F0079, máscara 1.

## Evidencia y límites

Las salidas se contrastan con la tabla nativa E50000. No hay cofres normales en
F5F000 para estos tres mapas: el cofre sellado se resuelve por eventos. Los
eventos capturados confirman posición, interacción y estado de recogida.

En una copia aislada y silenciada se cargaron los tres mapas mediante el motor.
Desde una posición preparada junto a la entrada, 40 cuadros de arriba cruzaron
de 435 a 164 manteniendo historia 96. Esto prueba ese cruce; no prueba la apertura
con Rana, todo el recorrido, todos los combates ni el desbloqueo del cofre.
Queda pendiente escuchar y recorrer con NVDA y control.

Cuatro pruebas específicas cubren las salidas y estados, referencias de objetos,
cofre abierto, ausencia de duplicados, consultas del lector, silencio en menús y
el cruce nativo. El mezclador real se prueba silenciado con proximidad simulada
en los tres mapas. Ejecutar:

```powershell
python tools/chrono-access/test/validate-magic71.py
```

Regresión: 493 pruebas, 485 aprobadas y ocho fallos previos de test_walk_trace,
sin fallos nuevos. Sintaxis Lua aprobada; ROM y partidas protegidas idénticas.

Evidencias en `test/future-check/magic71-*`, `audio71-replay.txt` y
`unit-validation-71.txt`. La validación compara ROM y partidas contra
`protected-hashes-71-before.json` y comprueba sintaxis Lua.

## Reversión

Restaurar `rooms/profiles.lua` y `continuar chrono.md` desde
`test/future-check/magic71-before/`, y retirar `rooms/profiles/cueva-magica.lua`.
Eso elimina esta orientación sin cambiar otros perfiles. Pruebas y documento 71
pueden archivarse con sus evidencias. Los archivos de comandos y arranque del
caso se respaldaron en la misma carpeta. No se modificó el juego habitual ni
se recargó su lector; el cambio queda en disco para la siguiente recarga.
