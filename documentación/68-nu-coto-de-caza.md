# 68. Referencia móvil de Nu en el Coto de Caza

Nu aparece entre las referencias del Coto de Caza cuando su actor nativo está
visible. Selecciónalo con Control+F6 y pulsa Control+F5 para conocer su dirección
y distancia actuales. Cada consulta usa su posición de ese momento. La señal
de proximidad conserva el sonido de enemigo.

Si todavía no ha aparecido o ya desapareció, la referencia no está disponible.
La lluvia por sí sola no crea una referencia: se comprueba la visibilidad real.
Esto también permite seguirlo si aún está visible mientras cambia el tiempo.
No se mueve al jugador ni se inicia un combate automáticamente.

## Datos y comprobación

El mapa 291 tiene tres actores posibles de Nu: 62, 64 y 66. Sus funciones de
inicio cargan el enemigo 0 mediante los bytes `83 00 83`. La tabla nativa de
nombres identifica ese enemigo como «Nu». Las coordenadas de los actores se
leen en cada consulta; sus banderas nativas de dibujo y estado controlan cuándo
la referencia existe. No se anuncian sus premios ni datos de combate ocultos.

Se añadieron tres referencias con `entity` y `followEntity` al perfil del Coto.
Los mismos actores se excluyen de las referencias genéricas para evitar que
Nu aparezca duplicado como «Enemigo». Los otros enemigos conservan sus señales.
Se mantienen intactos los modelos de habitaciones, batalla y lluvia.

En una copia aislada y silenciada, Nu apareció como actor 66, tipo nativo 6,
sin modificar su posición ni sus flags. La referencia siguió su movimiento y
se retiró al desaparecer. Evidencias en `test/future-check/`:
`nu68-slot66-present-ram.bin`, `nu68-slot66-absent-ram.bin` y `nu68-runtime.txt`.
El punto de partida y la historia de la copia estaban preparados. No se
combatió con Nu ni se afirma haber completado su encuentro.

Siete pruebas específicas verifican la identidad nativa, las tres variantes
de aparición, ausencia aunque llueva, movimiento y desaparición, selección
con Control+F6, repetición actualizada con Control+F5 y señal de enemigo.
La aparición/desaparición usa capturas nativas; las otras variantes y consultas
usan también estados preparados. Queda pendiente valorar la orientación con
NVDA y recorrer hasta él con el control.

Repetir: `python tools/chrono-access/test/validate-nu68.py`.
Resultado: 484 pruebas, 476 aprobadas y los mismos ocho fallos previos.
Las siete nuevas y la sintaxis Lua pasan. Los hashes de ROM, SRAM y partidas
habituales coinciden con los iniciales.
Registro: `test/future-check/unit-validation-68.txt` y hashes protegidos 68.
Se conserva el registro de caminata desactivado al inicio y sus ocho fallos
de tests anteriores. No cambiar esa política para hacerlos pasar.

## Activación y reversión

Carga los cambios con `recargar-lector.cmd` o al iniciar el lector.
La recarga Lua no carga ni reinicia una partida. En esta sesión se intentó
recargar el juego habitual abierto, pero el comando no encontró su consola Lua
y no actuó. No afirmar que la instancia habitual tiene ya estos perfiles cargados.

Producción: referencias de Nu y exclusión de los actores 62/64/66 en el perfil
`ioka66_291` de `room-profiles.lua`. Generador: `test/build-ioka66.py`.
Pruebas: `test/test_nu68.py`. Observador aislado: `test/observe-nu68.lua`.
Para revertir, retira esas tres referencias y las tres exclusiones, junto con
la frase de orientación de Nu, tanto del generador como del perfil. Se conservan
copias en `test/future-check/*-before68`; preserva cambios posteriores.
No se hicieron commits; `tools/` está ignorado por Git.
