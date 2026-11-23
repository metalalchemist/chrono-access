# Localizar el colgante de Marle en el suelo

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

El colgante tiene sonido de objeto y la referencia «Colgante de Marle en el
suelo». Usa sus coordenadas reales y desaparece del detector al recogerlo.
La caída y la recogida se comprobaron en el motor de la ROM Magno.

## Uso

Recarga con `tools/chrono-access/recargar-lector.cmd`, sin reiniciar la partida.
Tras la escena con Marle, Control+F6 permite recorrer las referencias hasta
el colgante y Control+F5 vuelve a consultar su dirección y distancia.
El sonido de objeto se oye dentro del alcance habitual de cuatro casillas.
Las distancias son directas, sin cálculo de rutas.

El detector no lo anuncia antes de caer ni después de recogerlo. Durante
escenas y diálogos la orientación se suspende, como en las demás zonas.
Todavía falta valorar la mezcla y la localización práctica con NVDA.

## Identidad y cambio

El mapa 439 usa dos entidades diferentes para el colgante. El slot 28, gráfico
70 hexadecimal, anima la caída y después se oculta. El objeto en el suelo es
el **slot 30, gráfico 63 hexadecimal**, inicialmente en (488,143.9375).
Su activación ejecuta `CA D6` para añadir el objeto D6 al inventario y
`0A 1E` para retirar la entidad 30. No confundir la animación con el objeto
que el jugador recoge.

Solo cambia `tools/chrono-access/room-profiles.lua`: se oculta del listado
la animación del slot 28 y se etiqueta el 30 con sonido `item` en el perfil
`leene_bell`. El modelo existente ya consulta posición, tipo y visibilidad
de cada entidad. La entrada de la feria conserva a Melchor en el slot 28 y
a la recepción en el 30; las etiquetas se aplican por mapa.

## Pruebas y evidencia

`test/test_pendant.py` añade cuatro pruebas: ocultación antes y después,
sonido de objeto y seguimiento de posición, conservación de los habitantes
de la entrada y reproducción de la caída/recogida nativas. La prueba de
proximidad reproduce la RAM nativa y acerca al oyente sin cambiar el objeto.

Evidencia en `tools/chrono-access/test/pendant-check/`:

- `bell-before-collision-ram.bin`: colgante oculto.
- `dropped-ram.bin`: animación terminada y objeto 30 visible.
- `floor-ready-ram.bin`: control devuelto, colgante visible y D6 ausente.
- `pickup-ram.bin`: D6 en inventario y entidad 30 retirada/oculta.
- Capturas `.gd`, `reader-validation.txt` y `sessions/`: escena y ensayo.
- `unit-tests-final.txt`: suite completa, **230 pruebas aprobadas**.

Se usó únicamente el emulador compartido y silenciado. El arranque nativo
desde una partida nueva se reubicó con el cargador de localizaciones al mapa
439. Después de ensayos de aproximación, se introdujo el objetivo 6 en el
detector de contacto C0304F para activar la escena nativa con Marle. La
recogida introdujo la interacción con el objeto 30 desde una posición cercana.
El motor hizo la caída, mostró los textos, añadió D6 y retiró el objeto.
No se forzaron su visibilidad ni la posesión del colgante.

Esto acredita los estados de la escena y del inventario; no una ruta continua
a pie, una escucha real con NVDA ni decisiones completas del juicio.
La copia de pruebas quedó cerrada. No se operó la partida habitual.

## Reversión

Retirar las etiquetas nuevas de los slots 28/30 y el sonido `item` del 30 en
`leene_bell`. Conservar pruebas, capturas, ROM y partidas. No hay cambios
en los lectores de diálogo, inventario, juicio o tienda de los horrores.
