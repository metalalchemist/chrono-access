# Selección y cambio de equipo

[Continuar el proyecto](../continuar%20chrono.md) · [Índice documental](README.md)

Las notas siguientes conservan la evidencia y el alcance de cada etapa. Los pendientes de una etapa pueden estar resueltos en documentos posteriores; el estado actual se consulta en el documento de continuación.

Las rutas de código escritas entre comillas invertidas parten de `D:\gt\vemovie`, salvo indicación distinta.

Código y evidencia relacionados:

- [status-reader.lua](../tools/chrono-access/status-reader.lua)
- [test_status.py](../tools/chrono-access/test/test_status.py)
- [equipment-check/validation.txt](../tools/chrono-access/test/equipment-check/validation.txt)

## Ampliación posterior del 26 de octubre: cambiar equipo

El menú de equipo ahora lee la pieza candidata, su posición en la lista y cantidad,
las estadísticas que subirían o bajarían (valor anterior, nuevo y diferencia), y la
descripción real del objeto. Funciona para arma, casco, armadura y accesorio.
Anuncia confirmación, cancelación y el intento de abrir una ranura sin piezas
disponibles. La lista y su filtrado por personaje vienen del juego; no se simulan
con las pulsaciones del mando. Los otros submenús (Objetos, Técnicas, Configuración,
Grupo, Guardar) y combate siguen pendientes.

La comparación se captura en C29CB5 después de que el juego actualiza cursor,
desplazamiento y estadísticas de prueba. Índice absoluto: 7E0FC8 - 4 + 7E0054;
total 7E0FC6; ID 7E04C9 contrastado con 7E0F00[índice]; cantidad 7E0F62[índice].
La base sigue en 7E9AC6 y el resultado de prueba en 7E9B1C. La vida calculada
compara las palabras 7E9ACF y 7E9B25. No anunciar como equipadas las piezas
que solo se están previsualizando. C29CE1 se ejecuta después del intercambio real
de inventario; C29CE4 también se alcanza al cancelar, por lo que el aviso de
confirmación tiene prioridad si se observaron ambos. C29C8D identifica lista vacía.

Las descripciones usan un observador opcional de los hooks ya existentes de
`dialogue-reader.lua`, sin reemplazar ni duplicar esos hooks. `status-reader.lua`
devuelve tick y observador; `lector-snes9x.lua` pasa el segundo al lector de diálogo.
C2F308 inicia una descripción y C2FAE8 termina su renderizado; solo se aceptan
glifos resueltos con destino 7E5E00..61FF. Se conserva la descripción por ID para
que una lectura atrasada no se atribuya a otra pieza. La captura de diálogos de
campo mantiene su filtro y su cola independientes.

Pruebas: `test/test_status.py` 7, `test/test_reader.py` 14, `test/test_room.py` 6,
`test/test_house.py` 5: **32 aprobadas**. Cubren diferencias positivas/negativas,
vida de varios dígitos, desplazamiento, cantidad, no repetir selección, descripción
por el hook compartido, cancelación, confirmación y lista vacía.

Integración: `test/discover-equipment.lua` y `test/check-equipment-runtime.lua` usan una copia
oculta y silenciada. **Nunca cargarlos en la partida del usuario:** inyectan botones
y, mediante comandos de prueba, añaden inventario solo a la copia. Evidencias en
`test/equipment-check/`: `runtime-reader.log`, `runtime.txt`, RAM y capturas GD.
Se comprobó lista de 12 armas (posición 10 con desplazamiento 2), ataque 8 → 81,
cancelación que conserva arma 1/ataque 8 y confirmación de arma 12/ataque 81.
Las descripciones reales incluyeron «Magia +2», «Velo. +1» y «Protege estado».
La cinta comparó velocidad 13 → 12 y puntería 8 → 10; la armadura comparó
defensa 16 → 27. `test/equipment-check/validation.txt` resume las comprobaciones de RAM.
También se confirmó un casco: ID 7E y defensa 27 en el registro real del personaje,
coincidiendo con la pantalla. La copia de prueba se cerró y su autorun volvió a
`test/discover-room.lua` al terminar.

Activación: `recargar-lector.cmd` si el juego está abierto; cerrar y abrir el menú
tras recargar. El acceso normal carga la versión nueva en la siguiente sesión.
La experiencia con voz del usuario todavía debe valorarse: en la integración la
voz se registró y el audio se silenció. No se tocaron partidas del usuario.
Reversión de esta ampliación: los bloques nuevos de equipo/descripción en
`status-reader.lua`, el parámetro observador opcional de `dialogue-reader.lua`
y el paso de ese observador en `lector-snes9x.lua`; no requiere cambiar DLL.
No hay commits del prototipo y `tools/` sigue ignorado por Git.

