# Tienda de Truce y lectura de compra y venta

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

La sala de la captura es la tienda de Truce, mapa **0011 (17)**. La casa del
alcalde es otro destino. Ahora la tienda tiene orientación sonora y referencias.
También se añade lectura del menú nativo de compra y venta.

## Uso

- Control+F5 consulta inicialmente la salida al mapa exterior, al sur.
- Control+F6 recorre el mostrador del tendero, mostrador, vasijas, estantería y persona.
- El tendero está al norte, tras el mostrador. Acércate mirando al norte y pulsa A.
- En el menú comercial, izquierda/derecha eligen Comprar o Vender; A entra.
  La cruceta recorre los artículos. A abre la cantidad y otro A confirma;
  B cancela o vuelve. Se leen nombre, precio, existencias y dinero.

**En la situación inicial investigada, este tendero solo dice «¡Visite el puesto
en la feria!» y no abre una tienda.** El lector no cambia ese evento. La prueba
de comercio se hizo invocando el menú nativo en una copia aislada, con el
catálogo 0, no acreditando una apertura comercial desde ese tendero.

La comparación de personajes y el cambio de equipo dentro del comercio
(accesibles desde arriba/abajo del menú superior) no tienen lectura completa.
Las descripciones y comparaciones de estadísticas comerciales quedan pendientes.
La cobertura del lector comercial se limita a comprar, vender y cantidades;
no acredita todas las tiendas ni eventos especiales. La casa del alcalde
continúa sin perfil interior.

## Evidencia y límites

La copia silenciada está en `tools/chrono-access/test/truce-shop-check/`.
Su captura `entrance-grid.png` coincide con la sala de la imagen del usuario:
cámara X=256, Y=544; líder 2, X=352, Y=719,9375.
El perfil ocupa `[304,560,464,736]`. La salida ocupa `[336,720,368,736]`,
el punto del tendero `[336,640,368,672]` y el mostrador `[304,640,400,672]`.
La persona visible se obtiene de RAM, slot 22, X=352, Y=655.
Los muebles se anotan desde la captura; las paredes y colisiones usan el terreno.
El registro de salida E5:04D4 conecta al mapa exterior 496.

`reader-validation.txt` registra el diálogo real del tendero y el ensayo nativo:

| Acción | Resultado del motor |
| --- | --- |
| Comprar Esp.Hierro, cantidad 1 | Precio 350 G; dinero 400 → 50 G; inventario +1 |
| Vender Esp.Hierro, cantidad 1 | Precio 175 G; dinero 50 → 225 G; inventario −1 |
| Volver con B | Regreso al menú superior y después a la sala |

Los volcados `native-buy-list`, `native-buy-quantity`, `native-purchase`,
`native-sell-list`, `native-sell-quantity` y `native-sale` conservan esos estados.
La voz se registró en archivo y la orientación se silenció con un módulo de
prueba. No se evaluó todavía la experiencia con NVDA.

El guion `check-truce-shop-reader.lua` inyecta posición, botones y, solo para
ensayar el comercio, registros A=2/X=0 en C0:1960 para abrir el menú nativo.
No usarlo en la sesión del usuario. Los guiones de descubrimiento y comandos
son herramientas de investigación y se conservan con sus evidencias.

## Código y validación

- `room-profiles.lua`: perfil de esta sala, sin modificar las otras casas.
- `shop-reader.lua`: observa rutinas nativas y difiere la voz al final del fotograma.
  Verifica firmas de ROM antes de instalar hooks; no escribe RAM ni pulsa botones.
- `lector-snes9x.lua`: integra el lector comercial en el callback existente.
- `test_shop.py` y `test_truce_shop.py`: ocho pruebas nuevas con capturas reales,
  consultas, contactos, rechazo por firma, falta de dinero, selección y transacciones.

La suite completa registra **109 pruebas aprobadas** con
`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`.
Los ensayos de dinero insuficiente y rechazo son simulaciones controladas;
las compras y ventas anteriores sí se ejecutaron en el motor nativo.

## Audio entrecortado

La configuración habitual tenía WaveOut, búfer de 64 ms, Sync=0,
DynamicRateControl=FALSE y 48000 Hz. Se cambió **solo BufferSize a 128 ms**,
con el emulador habitual cerrado. Copia anterior:
`tools/Snes9x-Lua-1.63/snes9x-lua-1.63-win32-x64/snes9x.conf.antes-buffer-20261026-191159`.
No se tocaron DLL, sincronización ni controlador. El ajuste rige al próximo arranque.

Es un ensayo para dar más margen al audio ante retrasos, no una causa demostrada
ni una corrección confirmada de oído. Puede aumentar la latencia sonora.
La [guía oficial de Snes9x](https://github.com/snes9xgit/snes9x/wiki/Audio-is-crackling-or-skipping.)
propone aumentar el búfer, revisar el controlador y el control dinámico de tasa.
Si persiste, distinguir si se corta música, voz de NVDA o señales de orientación,
y si coincide con anuncios, movimiento o actividad de otras aplicaciones.

## Activación y reversión

No se encontró el emulador habitual abierto; no se cargó una partida del usuario.
Abrir con `tools/chrono-access/iniciar-lector.cmd` activa los cambios.
No usar los autorun de `test/` para jugar.

Para revertir accesibilidad, retirar el perfil `truce_shop`, la carga y tick de
`tickShop` y `shop-reader.lua`. Para revertir el ensayo de audio, devolver
BufferSize a 64 con el emulador habitual cerrado. ROM, partidas, otros lectores
y evidencias no necesitan cambios. `tools/` sigue ignorado por Git.
