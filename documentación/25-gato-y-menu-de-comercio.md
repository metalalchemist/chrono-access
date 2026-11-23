# 25. Premio de Gato y orientación del menú comercial

Actualización: la opción inferior silenciosa era Equipo, como mostraron después
las capturas del usuario. Se completó en la [entrega 26](26-equipo-dentro-del-comercio.md).

El usuario confirmó que puede combatir, ganar a Gato y subir de nivel.
El lector general de combate ya funciona; no era una función pendiente.
Tras la presentación de Gato empieza la pelea sin una elección intermedia.

## Qué cambió

`tools/chrono-access/gato-reader.lua`, llamado desde `lector-snes9x.lua`,
observa el abono nativo y anuncia «Premio de Gato: 15 Puntos de Oro.
Tienes …» después del diálogo, cuando regresa el control. Si solo caben
algunos puntos, anuncia lo recibido; si ya hay 200, informa del máximo.
No modifica combate, entradas, memoria, premio ni duración de escenas.
La lectura del poema y del combate continúa en los módulos existentes.

El observador valida mapa 6, nueve actores, tabla de Gato y bytecode del
premio. Lee el PC del actor principal en 7E1180 y los puntos en 7F0052.
La secuencia nativa suma 15 y limita a 200. No deduce un premio por subir
de nivel: requiere observar el incremento en la fase nativa de recompensa.
Cambiar de mapa o encontrar otro guion descarta el seguimiento.

En `shop-reader.lua`, la entrada del menú ahora explica:
«Izquierda o derecha cambia entre Comprar y Vender. A entra; B sale».
El usuario confirmó que estaba usando arriba/abajo. En la prueba nativa,
derecha selecciona Vender y se anuncia correctamente; no se reprodujo
un fallo de lectura al seleccionar esa opción con la dirección adecuada.
Dentro de las listas, arriba y abajo recorren los objetos.

## Evidencia

Se usó solo `test/emulator/`, caso `test/gato-check/`, silenciado.
`fight-gato.lua` pulsa A para una pelea completa sin alterar HP ni premios.
La activación del actor es inyectada tras reubicar al jugador: no demuestra
un recorrido continuo hasta él. La victoria real dio 10 puntos de experiencia,
1 punto de técnica y después abonó 15 Puntos de Oro.

- `fight-before-ram.bin` y `fight-reward-ram.bin`: puntos 0→15, dinero intacto.
- `review.txt`: fases nativas y «Premio de Gato: 15 Puntos de Oro. Tienes 15».
- `reader-validation.txt`: presentación, ataques, victoria y poema final.
- `fair-sell-top-ram.bin`: cursor 9, modo superior 1 tras pulsar derecha.
- `fair-sell-list-ram.bin`: modo 3 tras A; inventario vendible vacío en ese ensayo.
- `fair-buy-return-ram.bin`: regreso después de B e izquierda.

Los guiones `research-gato-shop.lua`, `open-fair-shop.lua`, `fight-gato.lua`
y los comandos de este caso son exclusivamente de investigación. El lector
de producción no los carga. Se cerró el compartido y se archivó la sesión;
no se abrió ni se operó el emulador habitual del usuario.

`test_gato.py` comprueba premio real, espera al final del diálogo, límites
sintéticos de 200, ausencia de premio en derrota y firmas/mapas incorrectos.
`test_shop.py` comprueba la ayuda y las capturas nativas Comprar/Vender.
Suite completa: 203 pruebas aprobadas; registro `test/gato-check/suite.txt`.
Falta valorar el anuncio nuevo con NVDA. Los límites y derrota del observador
se comprobaron sintéticamente, separados de la victoria nativa.

## Activación y reversión

Usar `recargar-lector.cmd` si el juego ya está abierto; el siguiente arranque
también carga los cambios. No requiere otro sonido ni atajo.
Para retirar el anuncio de puntos, quitar la creación y llamada de `tickGato`
del lector principal; el combate general queda independiente. Para retirar
la ayuda comercial, quitar `help` y su concatenación en `shop-reader.lua`.

Quedan por valorar con NVDA el anuncio de Gato, la carrera y la soda.
El usuario ya confirmó campana y combates. Baile, desafíos de la tienda de
los horrores y escena de Lucca siguen pendientes.
