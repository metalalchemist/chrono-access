# Bosque y Castillo Guardia de 600 d. C.

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

El capítulo «El regreso de la reina» tiene orientación en el Bosque Guardia
(mapa 119), la sala principal del castillo (120), los aposentos del rey y la
reina (121 y 122), cocina/comedor (123), cuartel (124) y ambas torres (468 y 480).
Los enemigos usan una señal propia, dos tonos más grave que la de personas.

## Para jugar

Control+F5 consulta la referencia seleccionada y Control+F6 pasa a la siguiente.
En el bosque se empieza por la salida sur hacia Truce; siguen la salida norte,
cinco referencias del sendero, el arcón sellado del noreste, el arbusto que
provoca un encuentro al sureste y el destello del este. Examina con A.
El destello entrega una Onza Poder y su señal desaparece al recogerla.
El arcón del noreste responde «Sellado con una fuerza misteriosa…».

El castillo tiene salida al sur, cuartel al oeste, comedor al este y entradas
a las torres al norte. La torre oeste conduce al rey y la este a la reina.
Cada torre tiene tres perfiles de rellano para evitar señalar una conexión
que está en otro tramo del mismo mapa. En los aposentos, busca el cofre y la
puerta de regreso. Las personas visibles conservan su señal de proximidad.

Las consultas dan dirección y distancia directa, sin calcular rutas interiores.
Control+F7 sigue reservado al exterior. La orientación se suspende durante
los diálogos, escenas, combates y menús. Los guardias de la entrada conservan
su escena normal; el lector de diálogo sigue funcionando.

## Objetos contrastados en el motor

| Lugar | Registro o actor | Premio comprobado |
| --- | --- | --- |
| Destello del este del bosque | Actor 126, X=600/Y=591,9375 | Onza Poder, objeto 205; inventario 0 → 1 |
| Arcón noreste del bosque | Actor 124, X=760/Y=95,9375 | Mensaje de sellado; no se forzó apertura |
| Aposentos del rey | F5:F476, casilla 18/43 | MallaBron., objeto 93 |
| Aposentos de la reina | F5:F47A, casilla 36/43 | Mini Eter, objeto 192 |
| Cocina/comedor | F5:F47E, casilla 5/26 | Mini Eter, objeto 192 |
| Rellano intermedio este | F5:F7AE, casilla 13/28 | MiniTónico, objeto 189 |
| Rellano intermedio oeste | F5:F7CA, casilla 13/28 | 100 G, dinero 0 → 100 |

Los cofres abiertos siguen consultables con el añadido «abierto» y dejan de
emitir la señal de objeto. El actor 70 del bosque es un arbusto de emboscada,
no un premio. Su interacción activó enemigos nativos en los slots 76 y 78,
con estado 5. No se presenta como persona ni como objeto recogible.

Se reutilizan del bosque de 1000 los cinco puntos del sendero, comprobando
su espacio transitable con el terreno capturado de 119. Las salidas son
propias de 600: sur `[240,752,432,768]`, norte `[240,16,352,32]`.
La tabla E5 no contiene aquí un paso al claro de 1000. No se copia ese claro
ni se comparte el actor del destello entre épocas.

## Sonido de enemigos

`runtime/sounds/enemy.mp3` es la variante solicitada. `enemy.wav` contiene la
misma señal en PCM mono de 16 bits a 22050 Hz para el mezclador existente.
El original disponible es `sounds/persona.mp3`, convertido a `person.wav`.
`prepare-sounds.ps1` permite reconstruirlos: baja cuatro semitonos, equivalentes
a dos tonos completos, con razón 0,793700526, y compensa la duración mediante
`atempo=1,25992105`. Conserva los originales y no requiere FFmpeg al jugar.

Los actores hostiles de estados 5/6 usan `enemy`; se respetan las excepciones
sonoras explícitas de los perfiles. Los encuentros todavía ocultos no se
anuncian como enemigos visibles. La muestra también figura en Control+F1.
Los identificadores anteriores de sonidos se conservan, añadiendo enemy al final.

## Evidencia y límites

`test/guardia600-check/` conserva capturas RAM/GD de las ocho localizaciones,
los objetos antes y después y `reader-validation.txt` con los anuncios reales.
`start-guardia600.lua`, `survey-guardia600.lua`, `check-guardia600.lua`,
`warp-guardia600.lua` y `probe-guardia600-objects.py` usan exclusivamente la
copia aislada silenciada. Inyectan cargas, posiciones y botones; los resultados
prueban cargas e interacciones independientes, no un recorrido continuo desde
la partida del usuario. Los reinicios de estado del ensayo dejan mensajes
residuales del lector de combate; no acreditan combates jugados ni victorias.

Las pruebas comprueban las cajas de todas las conexiones contra E5, los cinco
cofres y sus flags, la Onza Poder real y la desaparición de su referencia,
el terreno reutilizado, enemigos nativos y duración/formato de audio.
La suite completa se registra en `test/guardia600-check/tests.txt`.
El primer intento de suite coincidió con la sesión compartida abierta y falló
por ocupación del caso; se cerró el ensayo y la ejecución posterior pasó.

No se afirma haber recorrido continuamente todas las escaleras ni agotado
las conversaciones, servicios del cuartel, muebles decorativos o eventos
secundarios del bosque. No se probó guardar en un punto físico del castillo.
Falta la valoración con NVDA y la escucha del sonido de enemigo por el usuario.

## Activación y reversión

Los cambios se cargan en el próximo arranque normal de `iniciar-lector.cmd`.
Si el usuario ya tiene una sesión, usar `recargar-lector.cmd` para conservar
su partida. Al finalizar no había procesos Snes9x abiertos: solo se cerró el
ensayo identificado por el gestor de pruebas. No se cargó ni movió su partida.

La unidad de reversión es retirar los perfiles `guardia600_*`, devolver el
sonido por defecto de hostiles en `room-model.lua` y retirar enemy de
`room-reader.lua`, `sound-catalog.lua` y la generación de sonidos. Sus pruebas
y este documento acompañan esa unidad. El bosque de 1000, el cañón, lectores
de diálogos/cofres y combate permanecen independientes. No se hicieron commits;
`tools/` sigue ignorado por Git y se conservan ROM, partidas y evidencias.

Validación final: **282 pruebas aprobadas**, ejecución completa de
`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`.
Nueve pruebas de la entrega 36; registro íntegro en `test/guardia600-check/tests.txt`.
