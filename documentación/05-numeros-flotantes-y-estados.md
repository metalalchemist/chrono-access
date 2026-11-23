# Números flotantes y estados alterados

[Continuar el proyecto](../continuar%20chrono.md) · [Índice documental](README.md)

Las notas siguientes conservan la evidencia y el alcance de cada etapa. Los pendientes de una etapa pueden estar resueltos en documentos posteriores; el estado actual se consulta en el documento de continuación.

Las rutas de código escritas entre comillas invertidas parten de `D:\gt\vemovie`, salvo indicación distinta.

Código y evidencia relacionados:

- [battle-effects.lua](../tools/chrono-access/battle-effects.lua)
- [test_battle.py](../tools/chrono-access/test/test_battle.py)
- [effects-check/validation.txt](../tools/chrono-access/test/effects-check/validation.txt)

## Ampliación: números flotantes y estados, 26 de octubre de 2026

`battle-effects.lua`, integrado en `battle-reader.lua`, anuncia las cifras de
vida/magia que el motor presenta sobre cada destino: daño, recuperación,
pérdida de magia y fallo. Se captura el evento de presentación en C15B72,
no se calcula el daño a partir de la diferencia de vida. Esto conserva golpes
repetidos iguales, varios objetivos y cifras que exceden la vida restante.
No expone la vida total oculta de enemigos ni atribuye un atacante no observado.
Las cifras son las mostradas; una curación limitada por el máximo puede recuperar
menos vida real. Los avisos existentes de vida/magia real se conservan.

Los estados se consultan cada fotograma tras inicializar los comandos, incluso
durante animaciones sin hook de menú. Se anuncia aparición y desaparición de
Paro, Veneno, Lentitud, pérdida gradual de vida, Silencio, Confusión, Sueño,
Ceguera, Prisa, evasión doble, barrera mágica, protección física y regeneración
de magia. Los bits sin identificación se omiten. La muerte y la salida del
combate no producen una lista falsa de estados curados. Los estados ya presentes
al empezar se anuncian una vez. Las inmunidades de los grupos negativos no son
estados activos; para efectos positivos se combina estado actual y de equipo.

Evidencia estática: C15B72 lee AD9E+offset (0 sin cifra, 1 recuperación de vida,
2 de magia, 3 daño de vida, 4 de magia, 5 fallo), con cantidad AD9C+offset.
El offset en 7E0080 incluye la pasada CCF829[A3D3] y cuatro bytes por destino.
C15B49..C15CD7 prepara una sola presentación por destino y recorre once ranuras.
C1B0DD..C1B222, C1BD6F y C1E63B confirman los consumidores de estados.
Actuales: 5E4B para negativos; 5E4D/5E4E para positivos. Solo estos últimos
se combinan con 5E52/5E53. No confundir 5E50 (inmunidades) con veneno activo.
Se verifica la firma de C15B72 antes de instalar los hooks de combate.

Pruebas: `python -m unittest discover -s tools/chrono-access/test -p 'test_*.py'`:
**62 aprobadas**, seis nuevas. Cubren las cinco clases de cifra, cero/sin cifra,
golpes idénticos, pasadas nativas de ROM, índices fuera de rango, animaciones,
aparición/fin de estados, inmunidades, equipo permanente, enemigos ausentes,
inicialización, victoria, reinicio del combate y firma incompatible.
Estas pruebas ejecutan Lua 5.1 real con ROM local y estados sintéticos.

Integración real en `test/effects-check/`, con `test/discover-effects.lua` y
`test/check-effects-runtime.lua`: encuentro controlado de dos Sebobo sobre objetos de
campo existentes. No es un encuentro natural del guion. `runtime.txt` registra
16 y 34 de daño a Sebobo 1; 54, 46 y 53 a Crono, con cambios reales de vida
999 -> 945 -> 899 y posteriores. La IA real del enemigo aplicó pérdida gradual de
vida y el lector la anunció. Veneno y Prisa se inyectaron y retiraron en RAM de
la copia: ambos produjeron avisos de aparición y fin, sin repetición.
`complete.txt` registra 55 visitas nativas al bucle de presentación (once
ranuras por pasada; no equivalen a 55 golpes). El ensayo nativo validó daño;
recuperación de vida/magia, pérdida de magia y fallo se validaron con pruebas
sintéticas y rutinas ROM, no mediante acciones nativas en este ensayo.
La copia oculta y silenciada (PID 5360) se cerró al terminar tras verificar su
ruta; no reutilizar ese PID. No se controló el emulador ni la partida del usuario.
Estos scripts inyectan botones y datos solo en su copia: nunca cargarlos en la
partida del usuario. Para repetir, iniciar el ejecutable de `test/effects-check/`
con la ROM y `-lua`; su autorun carga `test/discover-effects.lua`.

Activación: recargar con `tools/chrono-access/recargar-lector.cmd` o usar el
acceso habitual en la próxima sesión. Falta valoración con NVDA.
Reversión: retirar de `battle-reader.lua` la firma y hook C15B72, carga/reset/tick
de `effects` y el módulo `battle-effects.lua`. No requiere revertir menús,
diálogos, audio, DLL, ROM ni partidas. No se hicieron commits.
Siguen pendientes técnicas dobles/triples nativas, combates especiales y la
estabilidad de objetivos de área. Los bits de estado aún desconocidos y las
etiquetas de crítico u otros resultados especiales no se dan por resueltos.

