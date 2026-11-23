# 75. Orientación en 12000 a. C. y vuelo en dáctil

Se añaden los mapas exteriores de la superficie nevada y las islas de Zeal,
52 interiores y 142 referencias. El mapa de Prehistoria vuelve a responder
mientras se vuela en dáctil.

## Uso

Recargar el lector con `recargar-lector.cmd`, sin reiniciar el juego ni cargar
partidas. Control+F5 consulta dirección y distancia; Control+F6 cambia de
destino o referencia. En el exterior, Control+F7 calcula una ruta a pie.
Durante el vuelo informa la dirección del destino y recuerda aterrizar;
no calcula una ruta de caminata ni anuncia una entrada como disponible.

En 12000 a. C. se distinguen la superficie y el reino del cielo. Se nombran
por separado los pasajes y las dos entradas de Cueva Terra. Los interiores
añadidos incluyen la cueva de llegada, pasajes, Enhasa, Kajar, Cuervalado,
Cueva Terra, Monte del Canto, Palacio de Zeal y Palacio del Mar.
Algunas cámaras usan nombres de sector para evitar atribuirles una función
que no se haya comprobado. Se conservan las personas numeradas del modelo.

## Causa y corrección del silencio

`world-reader.lua` dependía exclusivamente del punto de ejecución de la
caminata, C23567. El dáctil usa otra tarea: durante el vuelo ese punto no
activa el lector. Se observa además el despacho compartido C2309E, con
firma de ROM comprobada. El modelo distingue el vuelo en el mapa 499 por
el estado 027E=3 y el bit 40 de 029E; toma las coordenadas de 029A/029C.
El cambio entre caminar y volar renueva el anuncio y la selección inicial.

El modelo anterior también rechazaba los mapas 500 y 501. Ahora reconoce
ambos y usa las entradas y colisiones nativas, como en las eras anteriores.

## Datos y comprobaciones

- Perfil explícito `rooms/profiles/zeal.lua`, generado por
  `test/build-zeal75.py`: salidas y cofres de las tablas de la ROM.
- Guardados asociados a actores NPC 121: desaparecen de las referencias
  cuando el actor deja de dibujarse. No basta con una coordenada fija.
- Doce objetos de interacción sin sprite se referencian por la posición de
  su inicialización y una función de activación con texto o llamada de evento.
  Se anuncian como objetos interactivos; su efecto depende de la historia.
- `test/capture-zeal75.py` conserva 52 capturas y funciones de evento de la
  copia administrada, aislada y silenciada, con historia preparada 160.
- `test/test_zeal75.py`: seis pruebas, incluidos datos nativos de interiores,
  visibilidad de guardados, dos exteriores, consultas y reproducción del vuelo.
- `python tools/chrono-access/test/validate-zeal75.py`: 517 pruebas;
  509 aprobadas y ocho fallos previos de `test_walk_trace.py`.
  Pruebas específicas, sintaxis Lua y mezclador real silenciado aprobados.
- Registros: `test/future-check/unit-validation-75.txt`,
  `audio75-replay.txt`, `reader-validation.txt`, capturas `zeal75-*`.
  La ROM y partidas del emulador habitual conservan sus hashes:
  `protected-hashes-75-before.json` y `protected-hashes-75.json`.

## Evidencia del motor y límites

En una copia de pruebas se preparó un dáctil junto al grupo en el mapa 499.
Una pulsación A ejecutó el abordaje nativo: el lector anunció el vuelo.
Al mantener derecha 60 fotogramas, X pasó de 560 a 680; Control+F7 informó
el destino seleccionado a siete casillas al oeste. Capturas
`zeal75-dactyl-board`, `zeal75-dactyl-flight` y `zeal75-dactyl-route`.
Otra pulsación A en ese lugar no produjo un aterrizaje; no se certifica
con ella la transición de aterrizaje. La regresión prueba ese cambio de
contexto de forma sintética.

Desde Enhasa, mapa 355, caminar al sur produjo la salida nativa al mapa
501 y su anuncio correcto: `zeal75-enhasa-exit`.
La prueba del mezclador coloca posiciones de proximidad simuladas sobre las
capturas nativas; no demuestra un recorrido completo de las mazmorras.

No se certifican combates, resolución de acertijos, recorrido natural de
los 52 interiores, Cuervalado por dentro ni la etapa exterior posterior a
la caída de Zeal (mapa 502). El Palacio del Mar tiene referencias de pasos,
cofres y guardados, pero no una guía completa de sus mecanismos.
Pendiente valoración con NVDA y control Nintendo.
No se abrió ni recargó el emulador habitual.

## Continuación y reversión

Conservar pruebas y evidencias 74 y 75. Completar mecanismos y libros con
nombres específicos, verificar aterrizaje nativo y ampliar la etapa posterior
a la caída de Zeal según el progreso del jugador.

Respaldo previo: `test/future-check/zeal75-before`. La unidad del vuelo y
exteriores se revierte restaurando `world-model.lua`, `world-reader.lua` y
la expectativa anterior en `test_ioka_world67.py`. La unidad de interiores
se retira quitando la entrada `zeal` de `rooms/profiles.lua`; su perfil y
pruebas son independientes de las entregas anteriores. Conservar todos
los archivos de evidencia y nunca restaurar ni sobrescribir partidas.
