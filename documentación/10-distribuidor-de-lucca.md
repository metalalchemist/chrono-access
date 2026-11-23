# Orientación del distribuidor de Lucca

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

El distribuidor que conecta con la puerta norte de la sala principal de Lucca
tiene orientación sonora desde el 26 de octubre de 2026. Al entrar se anuncia
«Estás en el distribuidor de la casa de Lucca», con el regreso a la sala principal
al sur, la puerta al norte y las escaleras al noroeste y noreste.

## Uso y cobertura

Abrir con `tools/chrono-access/iniciar-lector.cmd`, o recargar el lector si la
partida sigue abierta. Los mismos atajos funcionan en la sala principal, el
distribuidor y las dos plantas accesibles de la casa de Crono:

- **Control+F5:** referencia seleccionada, dirección y distancia. En el
  distribuidor la referencia inicial es «Regreso a la sala principal».
- **Control+F6:** siguiente referencia: regreso, escalera oeste, escalera este,
  puerta norte y vasijas de cada lado.

Se reutilizan los sonidos de paredes, escaleras, conexiones, puertas y muebles.
Las distancias son diferencias de posición, no recorridos; no hay rutas
interiores ni movimiento automático. La orientación se suspende en menús y
diálogos. Los sonidos de choque y proximidad mantienen la cadencia existente.

Las habitaciones a las que llevan las escaleras y la puerta norte todavía no
tienen perfil. Ahora el aviso al entrar en ellas aclara «Sigues dentro de la
casa de Lucca». El aviso exterior se reserva al cambio real al mapa 01F0.
En la sala principal, la referencia norte se llama «Puerta al distribuidor».

## Identificación y referencias

La captura del usuario muestra un distribuidor con dos escaleras y una puerta
central. Se reprodujo entrando desde la sala principal en una copia nueva y
silenciada, sin usar sus partidas. La captura nativa
[hall-entrance-ram.bin](../tools/chrono-access/test/lucca-hall-check/hall-entrance-ram.bin)
registra mapa **0003**, líder 2, X=128, Y=207,9375, capa 1.
[hall-entrance-grid.png](../tools/chrono-access/test/lucca-hall-check/hall-entrance-grid.png)
sitúa la cámara en X=0, Y=64 y permite contrastar muebles y puertas.

El perfil `lucca_hall` exige mapa 3, `64 <= X < 192`, `96 <= Y < 240`.
El límite espacial es necesario: otra sala del edificio comparte mapa 3 y
está cerca de Y=768. No se le aplica el perfil del distribuidor.

| Referencia | Caja `[x1,y1,x2,y2]` | Conexión nativa verificada |
| --- | --- | --- |
| Regreso a la sala principal | `[112,224,144,240]` | Mapa 4 |
| Escalera oeste | `[64,112,80,144]` | Mapa 10 |
| Escalera este | `[176,112,192,144]` | Mapa 9 |
| Puerta norte a otra sala | `[112,128,144,144]` | Mapa 3, zona de Y=768 |
| Vasijas del oeste | `[64,176,96,192]` | Mobiliario sólido |
| Vasijas del este | `[176,160,192,192]` | Mobiliario sólido |

Las conexiones se contrastaron con los registros de siete bytes de E50000
para el mapa 3 y con su ejecución real. El registro norte mantiene el mismo
identificador de mapa y cambia de posición; comparar solo 7E0100 no basta.
Las cajas anotan referencias; el terreno y sus colisiones se siguen leyendo
de la RAM real. La captura no contiene personas activas y no se inventan.

## Código y pruebas

[room-profiles.lua](../tools/chrono-access/room-profiles.lua) añade el perfil y
el nombre de la puerta desde la sala principal.
[room-reader.lua](../tools/chrono-access/room-reader.lua) anuncia las entradas
entre perfiles cubiertos y aclara que se sigue dentro de Lucca al pasar a los
mapas 3, 4, 9 o 10 fuera de cobertura. También corrige «de el» a «del» en los
avisos. No se cambiaron el mando, la ROM ni el recargador habitual.

`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`:
**89 pruebas aprobadas**, cuatro nuevas en
[test_lucca_hall.py](../tools/chrono-access/test/test_lucca_hall.py).
Comprueban captura, límites dentro del mismo mapa, vasijas, proximidad de
escaleras, registros y destinos nativos, consultas, suspensión en diálogo,
transiciones entre sala principal y distribuidor y aviso interior correcto.

El lector completo, con hooks reales y DLL de audio nativa silenciada, se
ejecutó mediante
[check-lucca-hall-reader.lua](../tools/chrono-access/test/check-lucca-hall-reader.lua).
La evidencia está en
[reader-validation.txt](../tools/chrono-access/test/lucca-hall-check/reader-validation.txt)
y [production-reader.log](../tools/chrono-access/test/lucca-hall-check/production-reader.log).

Desde la entrada, la consulta indica el regreso a una casilla al sur,
las escaleras a cuatro al norte y tres a cada lado, y la puerta norte a cuatro
al norte. Se abrió y cerró el menú, se cruzaron ambas escaleras y la puerta
norte, se volvió a la sala principal al sur y se reentró al distribuidor.
Los volcados `verified-west`, `verified-east`, `verified-north`, `verified-main`
y `verified-hall-return` conservan los destinos reales. La prueba usa estados
y reubicación cerca de las conexiones exclusivamente en la copia aislada;
no demuestra un recorrido completo desde el punto de aparición hasta cada
escalera. Falta valorar la orientación con el usuario y NVDA.

## Operación y reversión

La investigación usa `test/lucca-hall-check/`, separada de las evidencias de la
sala principal. `test/discover-lucca-hall.lua`, `test/start-lucca-hall-research.lua` y
`test/check-lucca-hall-research.lua` inyectan posiciones o controles y nunca deben
cargarse en la partida del usuario. `inspect-lucca.py lucca-hall-check` genera
las cuadrículas sin conectarse al emulador.

La copia de prueba PID 9596 se cerró tras verificar su ruta y su autorun se
restauró a `test/discover-lucca-hall.lua`. El comando del lector de prueba se
conserva como `hall-command-reader-v1.lua`, fuera del nombre ejecutable.
La última consulta ya no encontró procesos Snes9x. Comprobar el estado actual
antes de operar otra sesión; no reutilizar ese PID.

Para revertir esta ampliación, retirar `lucca_hall`, devolver el nombre anterior
a la puerta de la sala principal y retirar la frase interior de `room-reader.lua`.
La orientación de Crono y de la sala principal, menús y mapa exterior pueden
conservarse. Los cuatro tests y los scripts de investigación se pueden retirar
sin alterar las partidas. `tools/` continúa ignorado por Git; no se hicieron
commits y los archivos existen solo en disco.
