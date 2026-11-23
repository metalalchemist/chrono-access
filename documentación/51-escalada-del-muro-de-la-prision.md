# Subida y bajada del muro exterior de la prisión

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

El muro exterior tiene tres tramos de escalada y nueve referencias nuevas para
seguirlos. Los inicios y pies usan el sonido de escalera; los rellanos junto a
las entradas usan el de conexión. Se conservan las dos referencias a las celdas.

## Para bajar desde la entrada norte

1. Ve al este hasta «Inicio superior del primer tramo de escalada» y baja.
2. En su pie, ve al oeste al inicio del segundo tramo y baja.
3. En el siguiente rellano, vuelve al oeste al inicio del tercer tramo y baja.
4. Al pie del tercero, ve al este por el rellano para entrar en la celda.

Control+F6 recorre las referencias y Control+F5 consulta su dirección y distancia.
Para regresar, sube el tercer tramo, ve al este y sube el segundo; vuelve al este
y sube el primero. Arriba, la salida a la celda queda hacia el oeste.
Crono escala el muro: no se añadieron escaleras físicas al juego.

«Muro norte» y «muro sur» eran nombres de dos regiones del mismo mapa, separadas
por Y=384. Esa división no demostraba un camino recto entre ambas. La guía
anterior solo señalaba las entradas y omitía los cambios de dirección.

## Evidencia nativa

Se cargó el mapa 75 en la copia aislada. La carga independiente colocaba a Crono
en X=56, Y≈128, fuera del rellano transitable; se corrigió una vez la posición
inicial a X=56, Y≈120. Desde ahí se usaron exclusivamente botones nativos para
la bajada y la entrada a la celda, sin reposiciones intermedias.

| Punto | Coordenadas aproximadas | Captura en `test/prison-check/` |
| --- | --- | --- |
| Inicio del primer tramo | 88,120 | `wall-upper-end` |
| Inicio del segundo tramo | 56,248 | `wall-first-landing` |
| Pie del segundo tramo | 56,344 | `wall-second-descent` |
| Pie del tercer tramo | 24,440 | `wall-lower-end` |
| Entrada real a la celda | Mapa 71, 208,112 | `wall-enter-lower-cell` |

`wall-ascent-return` conserva una subida independiente, iniciada en X=24, Y≈440:
los botones nativos recorren los tres tramos y terminan en X=56, Y≈120. La captura
GD de `wall-first-descent` muestra a Crono escalando los ladrillos del muro.
No se recorrió aquí la entrada inicial desde el puente ni la caída por el agujero.

## Validación y activación

`test/test_prison_wall.py` comprueba las capturas de bajada y subida, la entrada
real a la celda, el suelo en los siete puntos con sonido de escalera y la
selección de referencias con Control+F5/F6. Las pruebas enfocadas de prisión,
interruptores y muro aprobaron sus 18 casos. El resultado general se conserva
en `test/prison-wall-check/unit-validation.txt`: **370 pruebas aprobadas**.
Falta valoración con NVDA.

El cambio funcional está en los perfiles `prison_wall_norte` y `prison_wall_sur`
de `room-profiles.lua`, generados por `test/build-prison-profiles.py`. La prisión
conserva veinte zonas y pasa de 79 a 88 referencias. Para revertir esta entrega,
retirar los nueve puntos y restaurar las guías anteriores de esos dos perfiles;
las conexiones a las celdas y el agujero del suelo son independientes.

La copia de pruebas quedó cerrada. La partida habitual no se abrió ni modificó.
Las referencias se cargarán al próximo inicio o con `recargar-lector.cmd` si
el juego habitual está abierto.
