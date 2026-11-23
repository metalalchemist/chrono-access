# Tienda de Truce de 600 d. C.

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

La tienda cercana a la salida sur del Bosque Guardia, mapa 118, tiene
orientación propia para 600: salida, mostrador, tendero, cliente y muebles.
Se reutilizan los lectores comerciales de las entregas 15 y 26. Se probaron
compra, venta, comparación, cancelación y cambio de equipo desde este tendero,
abriendo su comercio mediante el diálogo normal.

## Para jugar

En el mapa exterior de 600, selecciona Tienda con Control+F6 y consulta con
Control+F5; Control+F7 conserva el cálculo de ruta. Dentro, Control+F5 consulta
la referencia y Control+F6 pasa a la siguiente. La primera es la salida sur,
la segunda el mostrador. El tendero está al norte: acércate mirando al norte
y pulsa A. Después de su saludo, confirma para abrir el comercio.

En el comercio, izquierda/derecha cambia entre Comprar y Vender. Confirma
para entrar en la lista; arriba/abajo recorre artículos. Confirmar abre la
cantidad y confirmar otra vez realiza la operación. Cancelar vuelve al nivel
anterior. Se leen nombre, precio, cantidad disponible, piezas equipadas,
dinero insuficiente, cantidad elegida, total y resultado real.

Desde Comprar/Vender, abajo entra en Equipo. Selecciona personaje, confirma
y recorre sus cuatro piezas. Confirmar sobre una pieza muestra alternativas
y comparación de estadísticas. Confirma para equipar o cancela para conservar
la pieza anterior. La comparación no se anuncia como un cambio realizado.

La orientación sonora se suspende en diálogos y comercio. Las consultas del
local dan dirección y distancia directa, sin calcular rutas entre muebles.
No hay movimiento, compras ni cambios automáticos de equipo.

## Datos contrastados

El perfil `truce_shop600` usa el mapa **118**, límites `[816,48,976,224]`.
La entrada capturada tiene líder en el slot 2, X=888/Y=207,9375. El registro
E5:0926 ocupa `[880,208,912,224]` y devuelve al mapa exterior 497.
La salida fue cruzada caminando, con resultado conservado en
`verified-native-exit-ram.bin`.

El tendero usa el actor 18, X=896/Y=127. El actor 16 superpuesto se excluye
para no duplicar la misma persona; el actor 20, X=936/Y=159,9375, es el cliente.
El mostrador es una referencia transitable en `[880,144,912,160]`, delante
del mueble `[832,112,960,144]`. El terreno real distingue suelo en 896/152
y mostrador bloqueado en 896/136. Estanterías, vasijas y silla se anotaron
con la captura cuadriculada. La tabla F5 no contiene cofres ordinarios para 118.

El catálogo se contrastó con la lista y los precios del motor:

| Artículo de Magno | Precio |
| --- | --- |
| Esp.Hierro | 350 G |
| Pist.Dardo | 800 G |
| Kim.Kárate | 300 G |
| Cas.Bronce | 200 G |
| MiniTónico | 10 G |
| Sanar | 10 G |
| Revivir | 200 G |
| Refugio | 150 G |

Estos nombres pertenecen a la ROM del usuario. La Esp.Hierro corresponde a
la espada de 350 G citada en las consultas anteriores; no se añadió un
artículo nuevo ni se cambiaron sus precios.

## Evidencia nativa y límites

`test/truce-shop600-check/` conserva RAM/GD, imágenes, `entrance-grid.png`,
`reader-validation.txt` y la suite. Herramientas: `start-shop600.lua`,
`check-shop600.lua`, `drive-shop600.py`, `inspect-shop600.py` y `grid-shop600.py`.
Inyectan entradas, posiciones o dinero exclusivamente en la copia aislada
silenciada. No deben cargarse en la partida habitual.

El primer arranque de investigación saltó a la localización antes de que
terminara la inicialización del juego: el nombre estaba vacío y el factor
de precios era cero, por lo que el motor mostraba precios de 1 G. Se rechazó
ese estado para validar comercio. Sus datos se conservaron como
`initial-incomplete-*`. No se modificó el lector para aceptar esos precios.
Se corrigió el arranque de prueba para esperar nombre, control y factor
nativo 0100 antes de cargar la tienda. El comercio aceptado usa únicamente
las capturas con prefijo `verified-`, con precios normales.

La nueva carga de localización es una entrada independiente, no una ruta
continua desde el bosque ni una partida jugada hasta el capítulo 3. Se fijaron
2000 G solo en el ensayo para comprobar operaciones; después se fijaron 10 G
para la prueba de insuficiencia. No se alteraron equipo, inventario ni
estadísticas para simular las compras o el cambio de casco aceptados.

| Evidencia | Resultado comprobado |
| --- | --- |
| `verified-entrance` | Posición, actores y estado inicial correctamente inicializados |
| `verified-greeting`, `verified-top` | Saludo y apertura normal por el tendero; no se forzó el overlay comercial |
| `verified-buy-list`, `verified-buy-quantity`, `verified-purchase` | Esp.Hierro, 350 G; dinero 2000 → 1650, inventario +1 |
| `verified-sell-list`, `verified-sell-quantity`, `verified-sale` | Esp.Hierro, 175 G; dinero 1650 → 1825, inventario −1 |
| `verified-helmet-list`, `verified-helmet-quantity`, `verified-helmet-purchase` | Cas.Bronce, 200 G; dinero 1825 → 1625, inventario +1 |
| `verified-equipment-character`, `verified-helmet-slot` | Personaje y pieza seleccionados en el equipo comercial |
| `verified-helmet-preview`, `verified-helmet-cancel` | Comparación 16 → 21 de defensa; cancelar conserva GorraNegra y dinero |
| `verified-helmet-preview-again`, `verified-helmet-equipped` | Confirma Cas.Bronce; defensa 16 → 21, devuelve GorraNegra al inventario y conserva 1625 G |
| `verified-insufficient-list`, `verified-insufficient-attempt` | Dinero insuficiente para la espada; conserva 10 G y no entrega objeto |
| `verified-room-control`, `verified-query-exit`, `verified-query-counter` | Regreso al campo y consultas habladas de salida/mostrador |
| `verified-native-exit` | Cruce al exterior 497 con la misma partida de ensayo |

El equipo comercial se probó con Crono. El cambio entre varios personajes
conserva las pruebas existentes de la entrega 26; esta entrega no acredita
un ensayo nativo adicional con Lucca. No se probaron compras de todos los
artículos ni todas las cantidades. Falta la valoración del usuario con NVDA
y su escucha de la orientación sonora.

## Código, pruebas y reversión

Solo cambia el código de datos `room-profiles.lua`: se añade el perfil 118,
sin aplicar el de la tienda 17 de 1000. Se conservó una copia previa en
`test/truce-shop600-check/room-profiles-before.lua`. No se cambian los lectores
comerciales, que ya leen los datos reales de cada vendedor.

`test_shop600.py` añade nueve pruebas con capturas reales: geometría/personas,
terreno/contacto, conexión de ROM, catálogo/precios, compra/venta, comparación,
cancelación/equipo real, insuficiencia, consultas y regreso al exterior.
`python -m unittest discover -s tools/chrono-access/test -p test_shop600.py -q`:
**9 pruebas aprobadas**. La suite completa se conserva en `tests.txt`.

Para activar en una sesión abierta, `recargar-lector.cmd` conserva la partida;
el próximo inicio normal también recoge el perfil. Solo se cerró la instancia
compartida de pruebas antes de la suite. No se cerró, cargó ni movió la
partida habitual que estaba abierta en otra ruta del emulador.

La unidad de reversión es retirar `truce_shop600`, sus pruebas y este documento.
El lector comercial, el de equipo, la tienda de 1000 y las otras áreas siguen
independientes. No se hicieron commits; `tools/` sigue ignorado por Git.
Se conservan ROM, partidas, configuración y evidencias.

Validación final: **310 pruebas aprobadas**, suite completa registrada en
`test/truce-shop600-check/tests.txt`. Las nueve nuevas también pasan por separado.
Se intentó la recarga habitual al terminar, pero el emulador que estaba abierto
al comenzar ya no estaba en ejecución. El script rechazó la recarga sin operar
ninguna ventana; la comprobación posterior no encontró procesos Snes9x.
Los cambios se cargarán en el próximo arranque normal.
