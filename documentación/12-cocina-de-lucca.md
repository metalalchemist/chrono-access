# Cocina y comedor de Lucca y respuesta en zonas sin referencias

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

La puerta norte del distribuidor de Lucca conduce a una cocina con comedor.
Desde el 26 de octubre de 2026 esta sala tiene orientación sonora, consultas
de referencias y aviso de entrada. Además, Control+F5/F6 responde cuando una
zona aún no tiene referencias; antes las consultas quedaban en silencio.

## Para jugar

El lector anuncia «Estás en la cocina y comedor de la casa de Lucca» y sitúa
el regreso al distribuidor al sur, por el paso izquierdo. En la entrada:

- **Control+F5:** regreso al distribuidor, una casilla al sur.
- **Control+F6:** cocina y fregadero, mesa, sillas, taburete, estantería y
  mueble bajo la ventana, con dirección y distancia.

Las paredes, muebles y salida usan los sonidos existentes. La distancia no
es una ruta y las consultas no mueven al personaje. Menús y diálogos suspenden
la orientación. La puerta norte del distribuidor se llama ahora «Puerta a la
cocina y comedor». Las habitaciones tras las escaleras siguen pendientes.

Para activar los cambios se recarga el lector con la partida abierta; no es
necesario cerrarla ni cargar otro estado. La valoración del usuario con NVDA
sigue pendiente, aunque la ejecución real del lector se validó en copia aislada.

## Causa y alcance

| Síntoma | Clase y causa | Evidencia que lo cubre |
| --- | --- | --- |
| Silencio al cruzar la puerta norte | Ampliación de cobertura: la entrega 10 documentaba esa sala como pendiente. Comparte mapa 3 con el distribuidor, pero tiene otras coordenadas. | `test_capture_furniture_collisions_and_exit`, `test_entry_queries_menu_pause_and_return_announce_once` |
| Control+F5/F6 no responde fuera de perfiles | Fallo común de consultas: la condición `s.enabled` omitía por completo la respuesta. | `test_uncovered_control_queries_reply_and_respect_dialogue_and_modifiers` |

La corrección común añade una respuesta a las consultas de campo sin perfil,
respetando control disponible y modificadores. No añade estados, atajos o
controles nuevos. El cambio de ejecución suma 15 líneas: 11 de contenido del
perfil y cuatro de respuesta común, además de ajustar nombres y una caja.
Los menús y el mapa exterior conservan sus lectores propios.

## Identificación y geometría

La captura del usuario coincide con
[kitchen-entrance-grid.png](../tools/chrono-access/test/lucca-kitchen-check/kitchen-entrance-grid.png).
La copia aislada cruzó la puerta del distribuidor y registró en
[kitchen-entrance-ram.bin](../tools/chrono-access/test/lucca-kitchen-check/kitchen-entrance-ram.bin)
mapa **0003**, líder 2, X=64, Y=767,9375; cámara X=0, Y=624.
El perfil `lucca_kitchen` exige `32 <= X < 208`, `656 <= Y < 848`.
El distribuidor conserva su perfil separado, cerca de Y=208.

| Referencia | Caja en píxeles `[x1,y1,x2,y2]` |
| --- | --- |
| Regreso al distribuidor | `[48,784,80,800]` |
| Cocina y fregadero | `[48,704,112,736]` |
| Mesa del comedor | `[128,752,176,816]` |
| Silla oeste del comedor | `[96,768,112,784]` |
| Sillas del este | `[192,736,208,800]` |
| Taburete de la cocina | `[128,704,144,736]` |
| Estantería de la cocina | `[112,672,128,720]` |
| Mueble bajo la ventana | `[144,704,192,720]` |

La mesa incluye sus patas y el terreno sólido hasta Y=814; limitar su caja a
la superficie visible terminaba clasificando el choque inferior como pared.
La caja se extendió hasta Y=816 y una prueba comprueba el contacto como mueble.
Las colisiones siguen viniendo de la RAM; las cajas nombran las referencias.
La captura no contiene personas activas y no se anuncian objetos recogibles
por su mera apariencia sobre la mesa.

## Pruebas y archivos

Cambian [room-profiles.lua](../tools/chrono-access/room-profiles.lua) y
[room-reader.lua](../tools/chrono-access/room-reader.lua). Las pruebas están en
[test_lucca_kitchen.py](../tools/chrono-access/test/test_lucca_kitchen.py),
[test_room.py](../tools/chrono-access/test/test_room.py) y
[test_lucca_hall.py](../tools/chrono-access/test/test_lucca_hall.py).
Las antiguas aserciones de que la cocina no tenía perfil se actualizaron:
las zonas sin cobertura se siguen probando con el mapa 9 y el espacio entre
los perfiles, sin convertir el distribuidor y la cocina en un solo recinto.

`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`:
**93 pruebas aprobadas**, cuatro nuevas. Cubren geometría, colisiones, salida,
referencias, cambios entre perfiles del mismo mapa, suspensión, modificadores,
teclas mantenidas y consultas de zonas pendientes.

La ejecución del lector completo, con hooks reales y audio nativo silenciado,
se hizo con
[check-lucca-kitchen-reader.lua](../tools/chrono-access/test/check-lucca-kitchen-reader.lua).
Los registros están en
[reader-validation.txt](../tools/chrono-access/test/lucca-kitchen-check/reader-validation.txt)
y [production-reader.log](../tools/chrono-access/test/lucca-kitchen-check/production-reader.log):
entrada, consultas, menú, contacto con la mesa, regreso real al distribuidor
y respuesta hablada de Control+F5/F6 en una habitación pendiente del mapa 9.
Los volcados `verified-*` conservan los puntos del recorrido.
La prueba emplea reubicaciones y estados solo en esa copia; no acredita un
recorrido continuo desde la entrada a cada mueble. No se inyectaron botones
ni posiciones en la partida del usuario.

El ensayo final registra `SOUND 5 ... LOOP false` al chocar con la mesa,
después de corregir su caja inferior. La copia aislada PID 7672 se cerró tras
verificar su ruta y se restauró su autorun a `test/discover-lucca-kitchen.lua`.
El comando del lector de ensayo se conserva como `kitchen-command-reader-v1.lua`.
La recarga del lector habitual no encontró una instancia única; la consulta
posterior no encontró ningún Snes9x abierto. La activación en la sesión del
usuario queda para su próxima apertura con `iniciar-lector.cmd`. No se abrió
ni cargó otra partida. Volver a comprobar los procesos antes de operar.

## Reversión

Retirar el perfil `lucca_kitchen`, devolver el nombre anterior a la puerta
norte y retirar la rama de respuesta para zonas sin perfil de `room-reader.lua`.
No exige cambiar ROM, partidas, DLL, menús o mapa exterior. Los scripts de
investigación y sus capturas permanecen en `tools/chrono-access/test/`;
`tools/` sigue ignorado por Git y no se hicieron commits.
