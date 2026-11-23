# 64. Monte Denadoro

Diez mapas del Monte Denadoro tienen 57 referencias nuevas de orientación:
26 accesos nativos, 19 cofres, un punto de guardado, un brillo, un objeto de
la cueva y nueve referencias de escaleras y puente. Las personas aparecen
solo como «Persona 1», «Persona 2», etc., según pidió el usuario.

## Uso

Control+F6 recorre referencias y Control+F5 repite la seleccionada.
Las personas y los enemigos mantienen su posición real. Acércate y pulsa A
para hablar o examinar. Las decisiones, escenas y combates corresponden al juego.

Desde la entrada se pasa al desfiladero de cascadas, sendero oriental y sector
de la cascada y la cueva. La ruta oriental continúa por la subida, cornisa,
laderas y cascadas, puente y claro, y tramo del punto de guardado. Este último
regresa al sector que tiene la entrada de la cueva. Son conexiones de mapas;
las referencias no calculan una ruta transitable entre ellas.

Los pasos repetidos hacia un mismo mapa tienen números de acceso diferentes.
Las escaleras y el puente tienen referencias en sus extremos. Las distancias
son directas: sigue las cornisas y paredes para evitar intentar cruzar roca,
agua o precipicios. La caída por una cascada puede cambiar la posición del grupo.

Los 19 cofres conservan números fijos por mapa. Abiertos dicen «Cofre N, abierto»
y dejan de sonar. No se anuncia su contenido. El brillo y el objeto del fondo
de la cueva tienen sonido de objeto; no se anuncian como personas. El brillo
usa su flag nativo de recogida y la visibilidad de su actor. El objeto de la
cueva sigue la presencia nativa de su actor, sin revelar su identidad.

Hay un punto de guardado en la plataforma norte del tramo superior. Tiene
referencia y sonido propios, y no se cuenta entre las personas. La escalera
de la ladera da acceso a la plataforma. Guardar requiere elegir una ranura
dentro del juego; el lector no guarda ni confirma por el jugador.

## Evidencia

Se obtuvieron salidas y cofres directamente de la ROM local. Los diez mapas
se cargaron mediante el motor nativo en la copia aislada y silenciada de
test/emulador-pruebas.ps1. Se capturaron vistas adicionales de escaleras,
puente, punto de guardado y cueva. Son posiciones preparadas, no un recorrido
completo. Se conservan en test/future-check/denadoro64-*.

El punto de guardado corresponde al actor 16 del mapa 149: gráfico NPC 121,
posición nativa 59,10 y diálogo especial 64. Una aproximación con botones
desde una posición reubicada activó el bit 7 de 7F01CF, que el evento utiliza
para indicar que se está sobre el punto. No se confirmó una ranura ni se
guardó una partida del usuario. Capturas: denadoro64-save-arrival y save-on.

Las pruebas verifican todos los accesos y sus dimensiones, las coordenadas y
flags de los 19 cofres, números estables de personas al moverse, separación
entre objetos y personas, enemigos, presencia del punto de guardado y su
activación nativa. También verifican dirección/volumen del sonido de guardado
y silencio durante menús y diálogos.

El mezclador real se comprobó silenciado, con capturas nativas y proximidad
simulada. Eso no equivale a escuchar el recorrido con NVDA. La sintaxis Lua,
la suite general y los hashes se registran en unit-validation-64.txt.
La entrega anterior documentó ocho fallos de test_walk_trace.py porque sus
tests suponen inicio activado y el lector inicia el registro desactivado.
No se cambió esa política para esta entrega.

Resultado final: 456 pruebas ejecutadas, 448 aprobadas y los mismos ocho
fallos de test_walk_trace.py. Las ocho pruebas nuevas pasan. Sintaxis Lua,
audio nativo y reproducción silenciada de los diez mapas aprobados.

ROM, SRAM y el resto de los archivos protegidos conservaron sus hashes.
El archivo habitual .000 cambió durante la sesión; el archivo actual contiene
el mapa 145, entrada de Denadoro. Se conservó sin restaurarlo ni sobrescribirlo.
No se atribuye su escritura a una acción concreta: el juego habitual estaba
abierto al comenzar. Las configuraciones archivadas confirman que las pruebas
tenían Dir:Savestates y Dir:SRAM en test/future-check/Saves. La diferencia queda
en protected-changes-64.json; por ella y los fallos anteriores el validador
global devuelve fallo. No afirmar que todas las partidas quedaron idénticas.

Resultados en test/future-check/: unit-validation-64.txt, audio64-replay.txt,
denadoro64-native-tables.txt, denadoro64-actor-summary.txt y los archivos
protected-hashes-64-before.json / protected-hashes-64.json.
Repetir: python tools/chrono-access/test/validate-denadoro64.py.

Quedan pendientes recorrer todo el monte con control, valorar los sonidos
con NVDA y completar sus combates. No se presentan estados preparados como
victorias. No se modificaron ROM, SRAM ni partidas mediante los guiones.

## Mantenimiento y reversión

Producción: bloque BEGIN DENADORO64 a END DENADORO64 de room-profiles.lua.
Generador: test/build-denadoro64.py. Pruebas: test/test_denadoro64.py.
Audio: test/verify-denadoro64-audio.py. Investigación: research-denadoro64.py,
capture-denadoro64.py, capture-denadoro64-details.py e inspect-denadoro64.py.

Retirar ese bloque, su generador y sus pruebas retira esta unidad conservando
la cobertura anterior. Hay copias previas de perfiles y resumen en
test/future-check/*-before64. Conservar evidencias y cambios posteriores.
No se modificaron DLL ni sonidos ni archivos de VeMovie. No se hicieron
commits. tools/ sigue ignorado por Git y requiere respaldo propio.
