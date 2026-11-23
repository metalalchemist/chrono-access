# Catedral de Manoria: orientación, cofres y piano

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

La catedral tiene referencias en diez mapas: nave (129), primeros pasillos
(130), laberinto (131), antesala (132), santuario (198), comedor (199),
dormitorio (200), tesorería (201), sala este (202) y habitación oculta (203).
Se conservan los lectores de diálogos, cofres y combate.

## Para jugar

Control+F5 consulta la referencia y Control+F6 recorre salidas, cofres, pianos,
mecanismos y personajes. Las distancias son directas, no rutas por los pasillos.
Las paredes se detectan mediante el terreno real. Los enemigos activos usan
el tono conservado en `runtime/sounds/enemy.mp3`, mediante su WAV existente.
Las emboscadas no se anuncian como enemigos antes de que el juego las active.

Habla con las monjas para descubrir las pistas. En la nave, el piano u órgano
está al noroeste y el acceso oculto al noreste. Los primeros pasillos tienen
cuatro habitaciones laterales y continuación al norte.

El laberinto referencia los extremos de los corredores estrechos oeste y este,
el cruce inferior, el piano central y la pared detrás del altar relacionada con
el paso oculto. Las calaveras del noroeste y este tienen referencias propias:
examina con A mirando al norte. El dormitorio tiene otro acceso oculto al este.
Las referencias indican dónde buscarlos; su disponibilidad depende de los
mecanismos y de la historia. No se anuncia una confirmación de apertura.

Los quince cofres usan coordenadas y banderas de la ROM. Abiertos, añaden
«abierto» a su referencia y dejan de sonar como objeto; siguen localizables.
Se referencia también el punto de guardado visible junto al pie de la escalera
del laberinto; Guardar desde ese punto sigue pendiente de prueba.

## Evidencia y límites

`test/cathedral-check/129-ram.bin` a `202-ram.bin` conservan nueve cargas
independientes del motor, con capturas GD. `hidden-view-ram.bin` conserva el
mapa 203. Son cargas inyectadas de prueba, no una ruta continua ni un avance
legal completo de la historia. Las capturas muestran ambos instrumentos y las
calaveras. Los intentos con A no demostraron cambios del terreno: quedan
pendientes su activación mediante una ruta legal y el recorrido de los pasos.

`reader-validation.txt` conserva la apertura real del primer cofre de la
tesorería mediante A: «Has obtenido Vestido». Los estados antes/después prueban
la bandera abierta y el incremento del inventario. Faltan aperturas reales de
los otros catorce cofres, rescate, guardado físico y valoración con NVDA.

`test/test_cathedral.py` verifica todas las conexiones contra la tabla ROM,
los quince cofres y sus banderas, perfiles con RAM nativa, señal de enemigos,
referencias de pianos/pasos y suelo de los puntos de los corredores.
La suite general final pasó 316 pruebas, incluidas seis de catedral.
El registro general está en
`test/cathedral-check/unit-validation.txt`. Un intento anterior coincidió con
el emulador ocupado; se repitió con la sesión cerrada y pasó.

## Archivos, activación y reversión

La implementación se limita a los diez perfiles `cathedral_*` de
`room-profiles.lua`. Reutiliza los lectores y sonidos existentes. Para retirar
esta entrega basta eliminar esos perfiles. `test/cathedral-check/room-profiles-before.lua`
conserva el archivo previo; no restaurarlo sobre ampliaciones posteriores.

Los scripts `start-cathedral.lua`, `boot-cathedral.lua`, `survey-cathedral.lua`,
`check-cathedral.lua`, `warp-cathedral.lua`, `drive-cathedral.py` e
`inspect-cathedral.py` inyectan cargas, posiciones o botones: solo para la copia
aislada. El emulador de pruebas quedó cerrado. No se tocó la partida habitual.
No había emulador habitual abierto al terminar: los cambios se cargarán en el
próximo inicio normal con `iniciar-lector.cmd`.
