# 69. Habitaciones organizadas en rooms

Los 164 perfiles se cargan desde doce archivos por zonas en `rooms/profiles/`.
Se conserva cada campo y el orden anterior, incluidas las referencias de Nu,
sectores superpuestos y numeración de cofres.

Para editar una zona, abre su archivo en `rooms/profiles/`. Los perfiles de
catedral, Guardia y casas anteriores están en `catedral-guardia-casas.lua`.
Para agregar otro archivo, inclúyelo explícitamente en `rooms/profiles.lua`:
la posición en esa lista determina la prioridad de sus perfiles.

El modelo está en `rooms/model.lua`, el lector en `rooms/reader.lua` y la
configuración en `rooms/audio-config.lua`. El lector recibe la carpeta raíz
de chrono-access para encontrar la DLL, los sonidos y el catálogo compartido.
Esos recursos compartidos conservan sus rutas.

Los cuatro archivos antiguos `room-*.lua` son entradas de compatibilidad:
delegan a rooms y no contienen copias de los datos. El lector principal ya usa
`rooms/reader.lua`. Las pruebas existentes atraviesan esas entradas y ejecutan
el modelo y el lector trasladados. Los doce generadores de perfiles se ajustaron
a sus archivos por zona, incluido el generador de Zenan, que también actualiza
referencias del castillo y de la feria en el archivo de habitaciones anteriores.
Los scripts históricos de correcciones puntuales no son generadores actuales;
antes de reutilizarlos hay que adaptar sus operaciones sobre texto a estas rutas.

Validación ejecutada con la DLL Lua 5.1 del emulador:

- `python tools/chrono-access/test/validate-rooms69.py`: equivalencia recursiva
  de los 164 perfiles con el respaldo previo, incluido el orden; sintaxis de
  todos los Lua principales y de rooms aprobada. ROM idéntica a la entrega 68.
  Los hashes históricos de tres partidas (.000, .009 y .srm del emulador
  habitual) difieren de aquella entrega. No se tomó una base nueva al inicio,
  por lo que esa comparación no demuestra cuándo cambiaron. Esta intervención
  no realizó operaciones de carga, guardado ni escritura sobre esas partidas.
- `python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`:
  484 pruebas, 476 aprobadas, los ocho fallos previos de test_walk_trace.
- `python tools/chrono-access/test/verify-ioka66-audio.py`: nueve capturas
  nativas de Ioka, proximidad simulada y mezclador real silenciado aprobados.
  No demuestra una caminata nueva ni una comprobación auditiva con NVDA.

Evidencias: `test/future-check/rooms69-equivalence.txt`, `rooms69-suite.txt`
y `protected-hashes-69.json`. Respaldo anterior en
`test/future-check/rooms69-before/`. No se abrió ni recargó el juego del usuario.

El usuario confirmó que funciona en su juego y se eliminó el respaldo
`rooms69-before` según lo acordado. Se conservan los resultados de las pruebas.
`validate-rooms69.py` requiere ese respaldo para repetir la comparación histórica;
las pruebas unitarias siguen disponibles sin él.

La unidad reversible incluye rooms, las cuatro entradas de compatibilidad,
la ruta del lector principal y las rutas de los doce generadores. Para volver
al diseño anterior se restauran esos archivos desde el respaldo; rooms deja
de ser usado. No requiere modificar ROM, partidas ni recursos de audio.
