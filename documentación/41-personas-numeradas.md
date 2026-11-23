# Personas numeradas sin nombres ni funciones anticipadas

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

Todas las zonas con orientación anuncian a los personajes como «Persona 1»,
«Persona 2», etc. Se sustituyen nombres propios y funciones como posadero,
tutor, vendedor o encargado. La conversación permite descubrir quién es cada
persona. Los diálogos, nombres de combate y menús siguen leyendo el texto del
juego; esta entrega cambia la orientación, no el contenido original.

## Para jugar

Control+F5 consulta la referencia y Control+F6 pasa a la siguiente. La cuenta
es propia de cada perfil de sala. Se asigna al detectar por primera vez cada
actor visible, en orden de sus ranuras; no depende de la distancia. Una persona
conserva su número al moverse, ocultarse o regresar a esa sala mientras el lector
siga cargado. Si aparece otra, recibe el siguiente número libre. Al recargar o
reiniciar el lector se reconstruye la cuenta con los actores que estén visibles.
Los números son identificadores de orientación, no etiquetas del juego.

Las personas usan el sonido de persona, incluso si antes estaban marcadas como
encargados de minijuegos. Los hostiles se anuncian como «Enemigo» y conservan el
tono `enemy.mp3` mediante su WAV. Los objetos, el gato de la feria y los monstruos
del minijuego conservan descripciones de su aspecto o tipo. El colgante y la
comida ya no adelantan el nombre de su dueño. Los nombres de lugares existentes,
como casa de Lucca, no cambian.

Se retiraron también indicaciones que identificaban al personaje por su oficio
o daban instrucciones de hablar con Lucca o Marle según la fase de la escena.
Se conservan las referencias físicas y los avisos de objetos visibles.

## Implementación y pruebas

`room-model.lua` guarda los números por perfil y ranura, sin escribir en la RAM
del juego. `room-profiles.lua` conserva las exclusiones de actores que son
muebles o están fuera de cobertura. `nonPeople` distingue los animales y objetos
de los personajes que deben numerarse. Las etiquetas humanas dejan de contener
nombres escritos a mano.

`test/test_numbered_people.py` comprueba todos los perfiles, números únicos,
movimiento, desaparición, regreso, exclusiones y cambios a estado hostil. Usa
también capturas nativas de la feria y de una vivienda para comprobar objetos
y lectura de «Persona 1» mediante Control+F5/F6, suspendida durante el diálogo.
Los tests anteriores se actualizaron donde exigían las etiquetas retiradas;
los registros históricos de entregas previas se conservan sin reescribirlos.

Validación final: **320 pruebas aprobadas**, incluidas cuatro específicas de
personas numeradas. La ejecución se conserva en
`test/numbered-people-check/unit-validation.txt`.
No se abrió una nueva partida para estas pruebas: se ejecutaron el modelo y
el lector con la DLL Lua del emulador sobre las capturas existentes y memoria
simulada para los cambios de visibilidad. Falta valoración auditiva con NVDA.

## Activación y reversión

Si el juego está abierto, recargar su lector mediante `recargar-lector.cmd`
conserva la partida; si está cerrado, basta el próximo inicio normal.
No había emulador habitual abierto al finalizar; se cargará al próximo inicio.
La sesión de trabajo no ha inyectado botones ni cargado partidas del usuario.
El límite para retirar esta entrega es la numeración en `room-model.lua`,
las etiquetas y guías neutrales en `room-profiles.lua` y sus pruebas asociadas.
Los sonidos, lectores de diálogos y combate no requieren restauración.
