# Bosque Guardia: salidas, senderos y claro del arcón

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

El Bosque Guardia de **1000 d. C.** tiene orientación sonora para el mapa 19
y el claro contiguo, mapa 20. Se añaden salidas, puntos del sendero, enemigos,
el destello del sureste y el arcón del claro. Se conserva la lectura existente
de diálogos y combate.

## Uso

- **Control+F5:** consulta la referencia seleccionada. Al entrar en el bosque
  comienza por la salida sur, hacia Truce.
- **Control+F6:** recorre salida norte hacia el castillo, paso al claro,
  referencias del sendero, destello y enemigos detectados.
- El bosque tiene árboles y enemigos. Los sonidos de proximidad y choque usan
  el terreno real; los enemigos se anuncian como «Enemigo» al consultarlos.
  Comparten la muestra sonora de personajes del prototipo.
- El paso del noreste lleva al **claro del arcón**. Allí Control+F5 consulta
  el regreso al oeste y Control+F6 el arcón al este.
- Para examinar el arcón, acércate, mira hacia él y pulsa A. En el estado
  investigado responde: **«Sellado con una fuerza misteriosa…»**. No se forzó su apertura.
- El destello del sureste entrega una **Onza Poder**. El recorrido comprobado
  alcanza X=744/Y=543,9375 y pulsa A. Al recogerse desaparece su referencia y señal.

Las consultas indican **dirección y distancia, no una ruta entre árboles**.
Control+F7 conserva su función exclusiva del mapa exterior. No se añadieron
movimiento automático ni combate automático al lector de juego.
Los sonidos se suspenden durante menús, diálogos y los períodos sin control de campo.

## Datos contrastados

| Perfil | Mapa | Límites `[x1,y1,x2,y2]` |
| --- | --- | --- |
| Bosque Guardia | 0013 (19) | `[0,0,768,768]` |
| Claro del arcón | 0014 (20) | `[0,0,256,256]` |

La entrada sur capturada sitúa al líder en el slot **4**, X=312/Y=735,9375,
cámara 176/544. No se asumió el slot 2 de las casas anteriores.
Los primeros actores visibles hostiles tienen estados 5/6; se distingue su nombre
de «Persona». Los actores ocultos siguen filtrados por estado y dibujo.
El actor 82 es el destello y el 36 del mapa 20 representa el arcón, por lo que
se excluyen de las personas y se vinculan a sus referencias de objeto.

| Referencia | Caja en píxeles |
| --- | --- |
| Salida sur hacia Truce | `[240,752,416,768]` |
| Salida norte hacia el castillo | `[240,16,336,48]` |
| Paso al claro del arcón | `[736,80,768,112]` |
| Cruce del sendero sur | `[296,520,328,552]` |
| Paso del oeste | `[112,408,144,440]` |
| Paso central | `[272,304,288,320]` |
| Cruce del norte | `[264,80,296,112]` |
| Desvío del sureste | `[480,528,512,560]` |
| Destello del sureste | `[736,528,752,552]`, actor 82 visible |
| Regreso desde el claro | `[0,80,32,112]` |
| Arcón del claro | `[208,96,224,128]`, actor 36 visible |

Los tres registros del mapa 19, comenzando en E5:04E2, conectan respectivamente
al mapa 20 y a dos puntos distintos del exterior 496. El único registro del
mapa 20 devuelve al 19. Se comprobaron los destinos con las tablas de ROM y
cruzando las conexiones en el motor. No hay cofres ordinarios en la tabla F5
de estos dos mapas: el arcón y el destello se manejan por eventos.

## Recorrido y mensajes probados

La copia silenciada está en `tools/chrono-access/test/guardia-forest-check/`.
`reader-validation.txt` registra las consultas y mensajes. Se conservan:

- `entrance`: entrada sur real desde el exterior.
- `east-passage`, `east-return`, `verified-glade-entry`, `verified-glade-return`:
  cruce del paso del claro en ambos sentidos.
- `sealed-message`: texto real del arcón, sin inventar una recompensa.
- `verified-glade-query` y `verified-arc-query`: consultas nativas de regreso y arcón.
- `verified-north-exit` y `verified-south-exit`: exterior 496 desde ambos extremos;
  los puntos de llegada son distintos y el norte queda más cerca del castillo.
- `walked-sparkle`: recorrido continuo desde la entrada sur y obtención del objeto.

El recorrido continuo usa estos puntos, caminando con los controles nativos:
`(312,535.9375) → (496,535.9375) → (496,567.9375) → (672,567.9375) →
(672,543.9375) → (744,543.9375)`. Termina en 874 fotogramas, incluido el tiempo
de captura. El inventario pasa de cero a una unidad del objeto **205** y el
actor 82 deja de dibujarse. Se repitió en estado de prueba para verificar el
mensaje final «¡Has encontrado 1 Onza Poder!» sin códigos desconocidos.

Las otras referencias de sendero tienen espacio transitable comprobado contra
el terreno capturado. Eso no acredita un recorrido continuo por todas ellas:
las salidas y algunas interacciones se probaron reubicando al personaje cerca
de su acceso. No se han ensayado todos los encuentros ni todos los eventos
secundarios del bosque. La disponibilidad de enemigos depende del progreso.

Las capturas `verified-glade` (seguía en mapa 19) y `verified-glade-aligned`
(coordenada fuera de la zona del mapa 20) son intentos rechazados. Sus nombres
no los convierten en pruebas aceptadas. La aceptación usa mapa, coordenadas,
control y registros de transición. Durante el trabajo se cerraron ambas instancias
de Snes9x; se reabrió solo la copia aislada y se repitieron las comprobaciones finales.

## Cambios de código y validación

- `room-profiles.lua`: perfiles y referencias de los dos mapas.
- `room-model.lua`: referencias ligadas a actores visibles y nombres de enemigos
  para estados 5/6. Una referencia de evento desaparece si se oculta su actor.
- `room-reader.lua`: contracción correcta de «Has salido del Bosque Guardia».
- `magno-charset.lua`: FF se interpreta como espacio. Se contrastó su bitmap
  vacío y ancho de cuatro píxeles en esta ROM. El primer ensayo anunciaba
  «símbolo 0FF» entre «Onza» y «Poder»; el ensayo final lee la frase completa.
- `test_guardia_forest.py`: nueve pruebas nuevas de terreno, enemigos, actores,
  consultas, conexiones, recorrido, inventario y glifo de relleno.

`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`:
**140 pruebas aprobadas**. Los guiones de investigación, análisis del terreno
y marcha están en `test/`; sus entradas se inyectan solo en la copia aislada.
Los registros de voz y las pruebas con mezclador silenciado no sustituyen
la valoración del usuario con NVDA ni la escucha de las señales durante el juego.

## Activación, protección y reversión

Abrir normalmente con `tools/chrono-access/iniciar-lector.cmd` activa los cambios.
Si ya está jugando, `recargar-lector.cmd` recoge los cambios conservando la partida.
No se movió el personaje del usuario ni se cargó una partida suya. Al terminar
se cerró únicamente la instancia de prueba verificada por su ruta. Comprobar
procesos actuales antes de operar: esas observaciones no describen futuras sesiones.

El aviso anterior sobre la casa del alcalde quedó aclarado por el usuario,
que indicó que ya se había orientado. La petición activa pasó al Bosque Guardia.
No se modificaron por ese aviso los límites de la casa ni la configuración de audio.

Para revertir esta ampliación, retirar los dos perfiles `guardia_forest*`,
la visibilidad por actor y el nombre genérico de enemigo en `room-model.lua`,
la contracción en `room-reader.lua` y FF de la tabla de caracteres y etiquetas.
Las casas, tutoriales, cofres ordinarios y lectura de combate siguen siendo
funciones independientes. Se conservan ROM, partidas y evidencias; `tools/`
continúa ignorado por Git.
