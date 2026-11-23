# Baile y referencias de la feria

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

El lector distingue a Marle, al anciano, su mesa con el almuerzo y al gatito.
El baile tiene instrucciones y un anuncio del paso que inicia el personaje.
La comprobación de esta entrega usa RAM capturada y pruebas Lua; **queda
pendiente comprobar los cuatro pasos en una sesión real y escucharlos con NVDA**.

## Cómo usarlo

Recarga con `tools/chrono-access/recargar-lector.cmd`, conservando la partida.
Control+F6 recorre las referencias; Control+F5 vuelve a consultar su posición.
La distancia sigue siendo directa, sin calcular un camino.

En la plaza de la campana aparecen estas referencias separadas:

| Referencia | Comportamiento |
| --- | --- |
| Marle | Sigue su posición mientras está como personaje independiente; desaparece de la lista cuando se incorpora al grupo. |
| Anciano dueño del almuerzo | Sigue al anciano, separado de su comida. |
| Mesa con el almuerzo del anciano | Usa sonido de objeto; su referencia sigue la entidad del almuerzo y se oculta cuando el juego la oculta. Pulsar A lo come. |
| Gatito de la niña | Sigue sus coordenadas reales, también mientras corre o sigue al personaje. |

Melchor conserva su identificación en la entrada de la feria. La niña que
busca al gato conserva su referencia. El lector no decide acciones del juicio
ni recoge, come o devuelve objetos por el jugador.

En el recinto del baile, Y, R, L y X solicitan cuatro pasos. El lector dice
«Baile: paso Y», por ejemplo, cuando comienza la animación nativa correspondiente.
Los nombres identifican el paso por su botón: todavía no describen la postura
visual de cada animación. No se han verificado premios ni se anuncian puntuaciones.
El regreso a la plaza sigue disponible al sur.

## Datos y código

Archivos relativos a `tools/chrono-access/`:

- `room-profiles.lua`: etiquetas y orientación del baile.
- `room-model.lua`: admite el tipo de actor expresamente indicado por el perfil.
- `dance-reader.lua`: observa el inicio de animaciones y emite la voz al final del fotograma.
- `lector-snes9x.lua`: integra el lector de baile en su callback existente.
- `test/test_dance.py`: pruebas sobre las capturas conservadas en `test/leene-check/`.

En el mapa 439, Marle es el slot 6, tipo 3 e identificador de personaje 1.
La exploración genérica solo incluía tipos 4 a 6. `personTypes[6]=3` permite
reconocerla sin convertir a los compañeros del grupo en referencias de persona.
El anciano usa el slot 22, el gato el 26 y el almuerzo el 56. La identidad del
gato se contrasta con la carga de NPC `82 3B` y su evento de seguimiento;
el almuerzo usa `82 65`, se oculta al comer y muestra «¡Uum! ¡Sabe a pollo!»
en la evidencia anterior `reader-validation.txt`.

El mapa 7 contiene cuatro ramas de botones en los offsets de evento 20A,
21B, 22C y 23D. Invocan funciones de los integrantes del grupo. Las funciones
3 a 6 comparten los offsets 256, 25A, 25E y 262, con animaciones B7 15 08,
B7 09 10, B7 1A 08 y B7 1B 08. La observación de C02F48 se limita al líder,
al mapa y a las firmas de estas ramas. No lee teclas para deducir un éxito.
Se descartan avisos durante diálogo, selección o cambio de mapa. Una firma
incompatible desactiva únicamente este módulo.

La semántica de B7 se contrastó con `asm/bank_C0.asm` y con el inicio de
animación que escribe $1781,X. Los callbacks y estados de Snes9x se consultaron
también en el [código de su motor Lua](https://github.com/agehring80/snes9x-lua/blob/master/lua-engine.cpp).

## Verificación y límites

Las cuatro pruebas nuevas verifican todos los pasos y su repetición, exclusión
de otros actores/mapas/eventos, supresión durante diálogo/selección, nombres,
movimiento y ocultación del gato y la comida, desaparición de Marle al cambiar
de tipo y conservación de Melchor. Se usa la DLL Lua del emulador; la ejecución
de los hooks se simula sobre RAM nativa capturada. Esto no demuestra que los
cuatro botones se hayan jugado durante esta entrega.

El ensayo aislado de esta sesión quedó en `test/dance-check/`, con RAM,
capturas, registros y sesiones archivadas. Hubo un fallo de Direct3D al arrancar;
DirectDraw permitió continuar, pero no se logró reanudar el estado antiguo ni
salir de la habitación inicial con el guion de entrada. La causa restante no
se aisló. No se usó esa ejecución para afirmar un baile completado, devolver
el gato o acreditar una ruta hasta la mesa. El emulador de pruebas se cerró.
No se operó el emulador habitual ni se modificaron sus partidas o configuración.

La comprobación global y su resultado se conservan en
`test/dance-check/unit-tests-final.txt`:

```powershell
python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q
```

## Reversión

Retirar `dance-reader.lua` y sus dos llamadas en el lector principal;
revertir las etiquetas nuevas del perfil de la feria y `personTypes` en el
modelo. Conservar capturas, ROM, sonidos y partidas. Esta unidad no cambia
el comercio, la campana, la soda, la carrera ni los lectores de batalla.
