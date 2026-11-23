# Menú de Grupo: selección, orden y cambios confirmados

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

El menú de Grupo anuncia los personajes y puestos visibles, el personaje
elegido y el destino del intercambio. Confirma los cambios con el orden que
realmente quedó en el juego y distingue una cancelación de un cambio aplicado.
No repite una selección inmóvil ni modifica controles o datos del grupo.

## Para jugar

En el menú principal, izquierda y derecha recorren sus categorías. Selecciona
Grupo y confirma. Dentro, recorre los personajes con el control habitual;
confirma el primero, elige el destino y confirma de nuevo. Cancelar después
de elegir el primero anula la selección sin cambiar el grupo. Cancelar desde
la selección inicial regresa al menú principal.

La lectura indica el puesto del grupo activo y marca los personajes fijos.
Si las restricciones de la historia dejan menos de dos personajes disponibles,
anuncia que no se puede cambiar el grupo. El lector respeta esa restricción.

El Grupo del menú principal reorganiza únicamente los activos. No anuncia
los nombres de una reserva que esa pantalla no muestra. La pantalla de
intercambio con reserva usa las mismas rutinas: allí se leen también sus
personajes, puestos y destinos. Esto no habilita esa pantalla antes de tiempo.
Los nombres se toman del juego y conservan los cambios hechos por el jugador;
la numeración neutral de personas al caminar permanece independiente.

## Implementación

`group-reader.lua` observa las tareas de entrada del menú y captura la selección
resuelta en `C2C854`, usando `$0F0D` en lugar de inferirla del botón pulsado o de
la fila gráfica. Así respeta el mapa de posiciones, flags y desplazamiento.
`$0F00` identifica el primer personaje elegido y `$2980..2988` el grupo real.
El modo `$0D36` distingue el reordenamiento de activos de la reserva visible.

Se comprueban firmas ROM antes de instalar los hooks. `C2C77C` confirma la
escritura del intercambio; la rutina compartida de limpieza no se interpreta
como cancelación después de un cambio válido. La voz se emite al terminar el
fotograma mediante el único callback de `lector-snes9x.lua`.

## Pruebas y límites

`test/test_group.py` comprueba selección, puestos, estabilidad, selección del
destino, cancelación, cambio real, bloqueos, posiciones vacías, reserva desplazada,
salida, firma incompatible y ausencia de nombres de reserva en el menú normal.
`test/test_reader.py` verifica la lectura a través del callback principal de
producción. **339 pruebas aprobadas**, incluidas diez nuevas de esta entrega.
La suite completa se conserva en `test/group-check/unit-validation.txt`.

La ejecución nativa está en `test/group-check/reader-validation.txt` y sus GD/RAM:

- `group-horizontal`: dos personajes, pero uno fijo; el juego rechaza el cambio.
- `active-swap` y `cancel-choice`: intercambio entre activos y cancelación; se
  contrastan los nueve bytes del grupo antes y después.
- `normal-final`: solo los activos, sin revelar la reserva almacenada.
- `reserve-layout` y `reserve-swap`: selección del destino en reserva y cambio
  aplicado, contrastado con el grupo real.

Se usó únicamente el emulador aislado y silenciado. Se prepararon registros y
flags de personajes, posiciones y el modo de reserva para ejercitar el motor;
no son una ruta legal de reclutamiento ni una partida del usuario. La reserva
con desplazamiento y los bloqueos se cubren además con memoria simulada. Falta
valorar la voz con NVDA y recorrer todas las escenas de selección obligatoria.
La sesión de pruebas quedó cerrada.

## Activación y reversión

No había un emulador habitual abierto al comprobar los procesos. Se cargará
al próximo inicio del lector. No se enviaron botones ni se cargaron partidas
en la instancia habitual.

Para retirar esta entrega, eliminar la inicialización y llamada de `tickGroup`
en `lector-snes9x.lua` y retirar `group-reader.lua` y sus pruebas específicas.
No requiere modificar los lectores de combate, orientación, diálogos o sonidos.
