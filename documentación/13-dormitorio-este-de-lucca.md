# Dormitorio de la escalera este de Lucca

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

El dormitorio al que conduce la escalera este del distribuidor tiene orientación
sonora desde el 26 de octubre de 2026. La persona sentada es Lara: se confirmó
hablando con ella en una copia aislada, donde el lector leyó su diálogo.
El nombre del perfil es descriptivo de su conexión, no una atribución de la cama
a un personaje concreto.

## Uso

Al entrar se anuncia «Estás en el dormitorio este de la casa de Lucca», con
la escalera de regreso al suroeste, cama al noroeste y ventana al norte.

- **Control+F5:** referencia seleccionada; inicialmente, la escalera al distribuidor.
- **Control+F6:** cama, mueble bajo la ventana, chimenea, plantas, jarrón y la
  persona presente, con dirección y distancia.

La persona aparece como «Persona» y se detecta desde los objetos activos del
juego; no es una referencia permanente dibujada sobre el escenario. Al acercarse
produce el sonido de persona. Su diálogo se activa con A del mando y se lee
por el lector de diálogos existente. Las consultas no mueven al personaje y
las distancias no son rutas. La orientación se suspende al abrir menús o diálogos.

La escalera oeste del distribuidor todavía conduce a una zona sin perfil.
La referencia este del distribuidor se llama ahora «Escalera al dormitorio este».
El lector se actualiza recargándolo; no es necesario cerrar la partida.

## Captura real y perfil

La sesión del usuario registró mapa **0009**, líder 2, X=184, Y=519,9375.
Se obtuvo una copia de solo lectura de la RAM y la imagen, conservadas en
[live-ram.bin](../tools/chrono-access/test/lucca-east-check/live-ram.bin) y
[live-grid.png](../tools/chrono-access/test/lucca-east-check/live-grid.png).
La captura temporal no inyecta botones, posiciones o estados. Su llamada
se retiró de `lector-snes9x.lua` después de capturar; el lector habitual no
depende de un script de investigación al arrancar.

El perfil `lucca_east_room` exige mapa 9, `64 <= X < 208`, `336 <= Y < 560`.
La cámara de la captura está en X=0, Y=336. El evento del mapa tiene diez objetos;
la persona visible es el slot 18, estado 4, dibujo 1, X=152, Y=412.

| Referencia | Caja en píxeles `[x1,y1,x2,y2]` |
| --- | --- |
| Escalera al distribuidor | `[128,528,144,560]` |
| Cama | `[80,384,120,448]` |
| Mueble bajo la ventana | `[112,384,160,400]` |
| Chimenea | `[64,416,80,480]` |
| Planta oeste | `[64,368,80,416]` |
| Planta este | `[176,368,192,416]` |
| Jarrón del este | `[192,416,208,448]` |

La cama incluye su borde derecho hasta X=120; el terreno de X=118 está bloqueado
y el de X=120 no, en Y=424. La colisión se comprobó caminando desde X=136 hasta
el contacto en X=127, sin iniciar el recorrido dentro del mueble. Las cajas
nombran referencias y clasifican el choque; el terreno real sigue en la RAM.

El segundo registro de salida de mapa 9 cubre X=8, Y=33..34 en casillas y apunta
al mapa 3. Se comprobó el regreso al distribuidor, X=136, Y=167,9375, mediante
el movimiento nativo de la escalera. No se presenta como una salida al exterior.

## Código y comprobaciones

Se añade contenido a
[room-profiles.lua](../tools/chrono-access/room-profiles.lua), sin otra máquina
de estados ni cambios en el detector de personas del juego. El inspector
[inspect-lucca.py](../tools/chrono-access/test/inspect-lucca.py) se corrigió:
7F2000 corresponde al offset **12000** del volcado iniciado en 7E0000,
no a 10000. Esa lectura errónea afectaba al listado del inspector; el modelo
usado al jugar ya leía la dirección correcta. Tanto la captura antigua como
la nueva contienen a la persona del slot 18.

`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`:
**96 pruebas aprobadas**, tres nuevas en
[test_lucca_east.py](../tools/chrono-access/test/test_lucca_east.py).
Comprueban la captura del usuario, persona activa e inactiva, proximidad,
geometría, contacto con la cama, salida de ROM, consultas, diálogo, límites y
regreso al distribuidor. La evidencia de la antigua escalera este se reconoce
ahora como un perfil cubierto en `test_lucca_hall.py`.

La ejecución real está en
[reader-validation.txt](../tools/chrono-access/test/lucca-east-check/reader-validation.txt)
y [production-reader.log](../tools/chrono-access/test/lucca-east-check/production-reader.log),
producidos por
[check-lucca-east-reader.lua](../tools/chrono-access/test/check-lucca-east-reader.lua).
El ensayo recorrió referencias, consultó la persona, abrió y cerró el menú,
activó su diálogo con A, comprobó el sonido de choque de mueble al aproximarse
a la cama y regresó realmente por la escalera. Una lectura completa identifica
a Lara y sitúa a Lucca con Taban en la Plaza Leene. La prueba vuelve a pulsar A
y puede iniciar otra lectura antes de restaurar el estado de ensayo.

El ensayo usa reubicaciones y estados solo en la copia silenciada
`test/lucca-east-check/`; no demuestra un recorrido continuo desde la aparición
hasta Lara o cada mueble. La captura del usuario fue de solo lectura y las
inyecciones se hicieron exclusivamente en la copia aislada. Falta la valoración
de esta sala con NVDA por el usuario.

El ensayo de la entrega 12 que consultaba una zona pendiente se ajustó para
usar la escalera oeste y el mapa 10: el mapa 9 ahora tiene perfil. Sus registros
anteriores se conservan como evidencia histórica.

La copia aislada PID 9568 se cerró tras verificar su ruta; se restauró su autorun
a `test/discover-lucca-east.lua` y se archivó el comando del ensayo como
`east-command-reader-v1.lua`. La recarga del lector habitual no encontró una
instancia única al final; la activación queda para la próxima apertura habitual.
No se abrió ni cargó otra partida. Comprobar procesos reales antes de operar;
no reutilizar ese PID.

## Reversión

Retirar `lucca_east_room`, devolver el nombre anterior a la escalera este y
revertir las expectativas de cobertura del test del distribuidor. La corrección
del inspector puede conservarse. No requiere modificar ROM, partidas, DLL,
diálogos, menús o mapa exterior. Las evidencias y scripts están bajo `test/`.
`tools/` continúa ignorado por Git; no se hicieron commits.
