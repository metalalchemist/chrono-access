# Sonido propio para los dos puntos de guardado de la catedral

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

Los dos puntos de guardado de la catedral usan el sonido original
`sounds/punto de guardado.mp3`: el del pie de la escalera del laberinto y el de
la antesala del jefe. El primero deja de sonar como una conexión; el segundo
deja de anunciarse como persona y tiene una referencia propia.

## Para jugar

El sonido indica proximidad: aumenta al acercarte y se sitúa a izquierda o
derecha según la posición relativa. Se limita al radio habitual de cuatro
casillas. Control+F6 recorre el punto y Control+F5 consulta su distancia.
Control+F1 incluye «Punto de guardado» para reconocer la muestra.

Se respetan los actores visibles del juego: un punto retirado u oculto no
suena. Los diálogos, menús y combate suspenden la orientación como antes.
No se añadieron avisos de entrada ni guías que cambien con la animación.

## Datos verificados

Los dos inicializadores nativos usan `82 79`, el gráfico del punto de guardado:

| Zona | Mapa y actor | Posición nativa en píxeles |
| --- | --- | --- |
| Laberinto, pie de la escalera | 131, actor 56 | X=280, Y=671.9375 |
| Antesala del santuario | 132, actor 16 | X=56, Y=639.9375 |

Se conservan las capturas RAM nativas de la entrega 40 en
`test/cathedral-check/131-ram.bin` y `132-ram.bin`. Los perfiles enlazan cada
referencia a su actor para respetar las órdenes nativas de ocultarlo o mostrarlo.

## Audio e implementación

La conversión genera `runtime/sounds/save_point.wav`, mono PCM de 16 bits a
22050 Hz: 33957 muestras, aproximadamente 1.54 segundos y 67 KiB. Conserva el
MP3 original. Se prepara una vez con FFmpeg; el juego reproduce la muestra desde
el mezclador existente, sin FFmpeg ni procesos auxiliares durante la partida.
No se recompiló ni modificó la DLL de audio.

`prepare-sounds.ps1` incluye la nueva muestra. `room-reader.lua` la añade al
final de la lista, identificador 18, conservando los identificadores anteriores.
`sound-catalog.lua` incorpora la guía: ahora hay 19 sonidos. `room-profiles.lua`
asigna el sonido a ambos puntos y excluye el actor 16 de las personas.

## Pruebas y límites

`test/test_cathedral_savepoints.py` comprueba actores y gráficos nativos,
presencia/retirada, ausencia de personas duplicadas, distancia, dirección,
aumento del volumen y suspensión durante diálogo y combate. También carga la
muestra mediante la DLL real y prueba una reproducción en bucle con ganancia
cero, seguida de limpieza y cierre. Los cambios de posición/menú de esas pruebas
son simulados sobre las capturas, sin manipular una partida abierta.

Se actualizaron las comprobaciones de la guía para sus 19 entradas, incluida
su lectura desde el callback principal. La prueba de ventanas de la guía se
actualizó al nuevo recuento, pero no se volvió a ejecutar su interacción gráfica.
**348 pruebas aprobadas**, incluidas cuatro nuevas para estos puntos.
La suite general está en `test/cathedral-savepoints-check/unit-validation.txt`.
Falta valoración auditiva con NVDA y comprobar una escritura de SRAM desde estos
puntos físicos; esta entrega no afirma haber guardado una partida desde ellos.

## Activación y reversión

No se abrió un emulador ni se modificaron partidas. Se cargará al próximo inicio
normal del lector; no había emulador habitual abierto al comprobar los procesos.

La reversión se limita a la muestra `save_point`, su preparación, catálogo,
carga y las dos referencias del perfil. Restaurar el primer punto a `connection`
si se retira la muestra. No requiere cambios de controles, diálogos o combate.
