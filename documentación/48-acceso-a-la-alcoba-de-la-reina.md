# Aposentos de la reina: acceso a la alcoba y reencuentro

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

Los aposentos de la reina, mapa 122, tienen referencias para recorrer ambos
tramos de escalera y el pasillo inferior hasta la alcoba. Se añade también la
cama y un punto de aproximación a su frente. La guía de entrada explica ese
recorrido. Las personas conservan sus números y el texto del juego se lee sin
modificaciones.

## Para jugar

Desde el rellano de entrada, baja por la escalera este. En el pasillo inferior,
avanza hacia el oeste y busca «Pie de la escalera oeste; sube hacia la alcoba».
Sube y busca «Frente de la cama de los aposentos». Control+F6 recorre estas
referencias y Control+F5 consulta su distancia. Las distancias son directas;
se deben seguir los tramos de escalera, no atravesar las paredes hacia la cama.

Tras rescatar a Leene, la escena necesaria para regresar al portal es el
reencuentro con Marle en esa alcoba. En el estado revisado, acercarse a la cama
activa su aparición y diálogo. Continúa los textos con el botón habitual de
aceptar hasta que termine la escena y se una al grupo.

## Causa de la dificultad

El recuento de tres personas era correcto: estaban en el pasillo inferior.
Marle todavía no era una cuarta persona visible allí. El perfil solo tenía
la salida y el cofre, sin referencias para llegar a la alcoba desde ese pasillo.
La inicialización de la escena mantenía a su actor fuera de la zona hasta
activar el reencuentro. La reproducción aclaró que faltaba orientación del
recorrido; no se alteró la detección general de personajes ni se forzó su aparición.

## Evidencia y pruebas

La copia RAM extraída del guardado 000 tenía mapa 113, personajes activos Crono
y Lucca y contador de historia 28. Se copiaron registros de personajes y flags
en el emulador aislado para cargar los aposentos. Tras situar al personaje en el
rellano de entrada, se recorrieron ambos tramos de escalera y el pasillo mediante
botones nativos. Esto prueba el recorrido dentro de la sala; no incluye una
entrada continua desde el cañón a través del castillo.

`test/queen-return-check/descend-east-ram.bin`, `lower-west-ram.bin` y
`ascend-west-ram.bin`, con sus GD, conservan el recorrido. `bed-approach-ram.bin`
captura el comienzo de la escena cerca de X=645, Y=743. `reader-validation.txt`
conserva la aparición y sus textos, incluida «Marle: ¿Eh? ¿Qué ha pasado?».

`after-reunion-ram.bin` confirma control de campo habilitado, grupo activo
`0,2,1` (Crono, Lucca, Marle) y contador de historia 33. La copia de pruebas
avanzó los diálogos y aceptó la respuesta inicial; no se afirmó una elección
distinta ni se cambiaron datos de la partida habitual. El emulador aislado quedó
cerrado y los guardados originales solo se leyeron.

`test/test_queen_return.py` comprueba suelo nativo de los puntos, colisión de la
cama, tres personas reales, aparición de Marle y unión efectiva. Ejecuta también
el lector sobre RAM nativa con teclas y audio simulados: Control+F6 alcanza el
frente de la cama y caminar no repite la entrada. La suite general está en
`test/queen-return-check/unit-validation.txt`: **352 pruebas aprobadas**.
Falta valoración del usuario con NVDA.

## Archivos, activación y reversión

La implementación se limita a la guía y ocho referencias físicas del perfil
`guardia600_122` en `room-profiles.lua`; no modifica el argumento, controles o
flags del juego. Para revertir, retirar esas referencias y restaurar su guía
anterior, conservando la salida y el cofre. Las pruebas y herramientas auxiliares
de esta entrega están en `test/` y solo deben usarse en una copia aislada.

No había un emulador habitual abierto al comprobar los procesos. Las referencias
se cargarán al próximo inicio normal del lector.
