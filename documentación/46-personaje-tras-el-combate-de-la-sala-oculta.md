# Personaje conversable tras el combate de la sala oculta

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

El personaje que permanece tras la victoria en la habitación oculta de la
catedral, mapa 203, aparece en las referencias como una persona numerada.
No se revela su nombre ni su función. La estatua del fondo tiene su propia
referencia de mueble y ya no se anuncia como dos personas.

## Para jugar

Tras el combate, recorre las referencias con Control+F6 y consulta la distancia
con Control+F5. El personaje conversable se lee como Persona 1 con el sonido
de persona. Su posición se sigue desde la memoria real, incluso si se mueve.
Acércate y habla mediante el botón habitual de aceptar.

Antes de la victoria los enemigos conservan «Enemigo» y la señal `enemy`.
Si sales y regresas, el juego retira al personaje que había quedado; el lector
no lo hace reaparecer. En la copia del guardado revisada ya estaba retirado.
No se implementó ningún cambio de estado, diálogo, posición o partida del juego.

## Causa y corrección

El actor 30 conserva el tipo nativo 5 después de la pelea, aunque puede hablar.
La regla general lo trataba siempre como enemigo. El perfil `cathedral_203`
añade `friendlyWhen` para ese actor cuando `$7F00FE` tiene el bit 80, que el
script de esa sala establece después de la victoria. `room-model.lua` entonces
aplica la numeración y señal normales de persona. Los demás enemigos y perfiles
conservan su clasificación anterior. La presencia sigue dependiendo del estado
y dibujo del actor: no se conserva una referencia fantasma al retirarlo.

Los actores 20 y 22 son componentes de la estatua y su base. Se excluyen de
las personas y se añade «Estatua del fondo», sin identificar a quién representa
ni presentar su base como un interlocutor. El diálogo del personaje real ya
se leía correctamente; no se cambió `dialogue-reader.lua`.

## Evidencia y pruebas

`test/cathedral-survivor-check/player-copy-ram.bin` es una extracción de solo
lectura de una copia del guardado del usuario: mapa 203, cinco enemigos con
dibujo desactivado, estatua visible y control habilitado. Se verificó el tipo
y las funciones de los actores mediante el script de eventos que carga la ROM.

La reproducción aislada conserva `start-encounter-ram.bin`, `after-victory-ram.bin`
y `survivor-dialogue-ram.bin`, capturas GD y `reader-validation.txt`.
Después de ganar, el actor 30 tiene tipo 5, dibujo 1 y procesamiento 09.
Se abrió su diálogo y se leyó la frase «¡Venid y uníos a nuestra danza fúnebre!»;
después cambia de posición. La reproducción inyectó flags, posiciones y el
inicio de la función nativa de batalla, y redujo los PV enemigos para acortar
el ensayo. No demuestra un recorrido legal completo ni el final de toda esa
escena. Los intentos de atajos posteriores al diálogo quedaron bloqueados por
el control de la escena, por lo que no se cuentan como una prueba nativa del
atajo funcionando.

`test/test_cathedral_survivor.py` comprueba con esas capturas la persona tras
ganar, enemigos antes de ganar, estatua, desplazamiento y desaparición. Ejecuta
también `room-reader.lua` sobre la captura nativa de victoria con control
habilitado: Control+F6 lee Persona 1 y su distancia. El mezclador y las teclas
del ensayo de atajos son simulados. Falta valoración del usuario con NVDA.
**344 pruebas aprobadas**, incluidas cinco específicas de esta corrección.
La ejecución general está en `test/cathedral-survivor-check/unit-validation.txt`.

## Activación y reversión

El emulador aislado quedó cerrado. No se cargaron estados ni se enviaron botones
en la partida habitual, y no había un emulador habitual abierto al comprobar.
Se cargará al próximo inicio normal del lector.

Para retirar esta entrega, eliminar `friendlyWhen` y las referencias de estatua
del perfil `cathedral_203`, restaurar sus personas anteriores y quitar la regla
opcional de clasificación en `room-model.lua`, con sus pruebas. No afecta a los
lectores de texto, Grupo, combate ni al catálogo de sonidos.
