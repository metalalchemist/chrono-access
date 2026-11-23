# Texto, posición y audio de la casa

[Continuar el proyecto](../continuar%20chrono.md) · [Índice documental](README.md)

Las notas siguientes conservan la evidencia y el alcance de cada etapa. Los pendientes de una etapa pueden estar resueltos en documentos posteriores; el estado actual se consulta en el documento de continuación.

Las rutas de código escritas entre comillas invertidas parten de `D:\gt\vemovie`, salvo indicación distinta.

## Lectura de texto: decisiones y direcciones

No se usa OCR ni se vuelca toda la RAM constantemente para leer diálogos. Se observan rutinas concretas del juego mediante `memory.registerexec`. Esas rutinas ya han descomprimido el texto y resuelto sustituciones de nombres. Los hooks capturan estado y el callback `emu.registerafter` envía la voz al terminar el fotograma.

El fork tiene `emu.frameadvance` comentado; no escribir un bucle basado en esa función. Mantener un único `emu.registerafter` que llama a los lectores. Las corutinas Lua no equivalen a hilos del sistema.

| Elemento | Dirección SNES o dato |
| --- | --- |
| Firma de menú inicial | Desde `C2E236`, comprobada por el lector antes de abrir voz |
| Activo/Lento | Hook `C2E23C`, cursor `7E0054`: 0 activo, 1 lento; confirmación `7E0D1D >= 80` |
| Nombre | Hook `C2E224`, después de actualizar cursor; columna `7E0F08`, fila `7E0F09` |
| Tabla de letras y nombre | Tabla `FFC9AC`; nombre `7E0F00..05`; confirmación `C2E233` |
| Inicio de diálogo | `C02121` |
| Glifo final expandido | Hook `C25DC4`, valor de 16 bits en `7E0235` |
| Código de control | Hook `C25950`, registro A reducido a 8 bits |
| Espera de página | Hook `C021D8` |
| Filtro de diálogo de campo | Estado `7E0129`, modo `7E0214 == 0`, banco destino `7E0212 == 7E`, destino `7E0210 >= F000` |

Las direcciones de esta tabla son direcciones del bus de SNES, no offsets del proceso Windows. Cada lector comprueba firmas de las rutinas relevantes; no reutilizar a ciegas en otra ROM.

`dialogue-reader.lua` agrupa glifos hasta cierre o pausa de página, conserva acentos, espacios y puntuación, y permite que una página idéntica vuelva a leerse en otra ocasión legítima. Tiene límite de 4096 glifos y registro explícito de caracteres desconocidos. No asumir que el mismo mecanismo ya lee elecciones de respuesta o menús de combate.

La tabla de Magno difiere de la inglesa: `C4=é`, `E2=k`, `E3=:`, `E4=ñ`, `E5=í`, `E7=¡`, `EA=¿`, `EB=ó`, `EC=ú`, `F3=á`. Se verificó con las imágenes de los glifos reales. No corregirla usando una tabla inglesa genérica.

`chrono_prism.cpp` obtiene la API de Lua de la DLL ya cargada y carga `prism.dll` desde la ruta del módulo. Los diálogos y los avisos del cuarto usan `interrupt=false` para encolar la voz; los cambios de selección de menú interrumpen. El lector inicializa el audio espacial dentro de `pcall` para conservar la voz si ese módulo no puede abrirse.

## Sonidos y posición de la casa

### Cadencia y concurrencia

Se acordaron **dos consultas de proximidad por segundo**. La implementación usa tiempo monótono de Windows, no el número de fotogramas ni el modo PAL/NTSC. En cada fotograma se leen unos pocos datos de posición/control; solo se recorre el terreno en la actualización de proximidad o para confirmar un choque cercano.

El hilo C++ mezcla audio y suaviza ganancias. Nunca llama a Lua ni lee memoria del emulador. Lua entrega sonidos, volumen y paneo; C++ reproduce de forma continua entre consultas. Así se evita mover el acceso al emulador a un hilo inseguro.

Configuración vigente en `room-audio-config.lua`:

```lua
return {enabled=true, updatesPerSecond=2, radiusPixels=64, volume=0.55, ambientVolume=0.32}
```

El alcance de 64 píxeles corresponde a cuatro casillas de 16 píxeles; no se midió la animación de pasos. La ganancia aumenta de forma gradual con la cercanía. Pared izquierda/derecha usa paneo estéreo; arriba/abajo tiene muestras distintas. El reloj tiene menor volumen de ambiente.

`chrono_audio.cpp` usa WaveOut a 22050 Hz estéreo, cuatro buffers de 512 frames, 24 canales y hasta 32 muestras. Tiene sincronización de los datos compartidos, suavizado de ganancia y watchdog de 1800 ms si dejan de llegar actualizaciones. Al cerrar se detiene y une el hilo. Menús, diálogos, escenas sin control y estar fuera del área cubierta silencian las referencias de proximidad.

### Datos de memoria usados

| Dato | Lectura y significado |
| --- | --- |
| Localización | Palabra `7E0100` |
| Índice del líder | Palabra `7E0197`, índice par de 0 a 126 |
| Posición del líder | Palabras `7E1800 + índice` y `7E1880 + índice`, divididas por 16: coordenadas en punto fijo 12.4 |
| Capa del jugador | Byte `7E0155` |
| Intención de movimiento | Bytes `7E1D2C`, `7E1D2D` |
| Control disponible | `7E011F != 0`, `7E0129 == 0`, `7E0162 == 0` |
| Ejecución real de control de campo | Hook `C0881E`; evita interpretar posiciones antiguas en otros modos |
| Objeto que bloquea | Byte `7E01EB`, 80 como centinela; índice par válido identifica un objeto próximo |
| Terreno | Planos `7E30C0` y `7E7040`, índice `floor(y/16) * 256 + floor(x/16)` |
| Tablas de pendientes | ROM `C09BF5`, `C09C0B`, `C09C21`, 22 entradas cada una |
| Objetos vivos | Cantidad `7F2000`; estado `7E1100 + índice`, dibujo `7E1A81 + índice`, coordenadas como las del líder |

El perfil del dormitorio exige localización 2 y `288 <= X < 448`, `32 <= Y < 224`. La planta baja se confirmó en localización 1, con límites de perfil `0 <= X < 256`, `0 <= Y < 224`. La hipótesis previa de que esa planta compartía la localización 2 no se confirmó: no trasladarla a nuevos perfiles. La selección aproximada de personas se acota al perfil activo; todavía no es un clasificador universal de todos los objetos del juego.

La interpretación del terreno se contrastó con las rutinas `C09AD3..C09C5B`, incluyendo zonas, capas y pendientes diagonales. Se lanzan tres rayos por dirección, con incrementos de 2 píxeles hasta el alcance configurado, considerando el tamaño del cuerpo. La distancia representa separación respecto al cuerpo, no solo al punto central.

### Referencias de mobiliario

Las colisiones vienen del terreno real; los nombres y tipos de estos muebles se anotaron manualmente con una captura cuadriculada. Las cajas son `[x1,y1,x2,y2]` en coordenadas del mapa.

| Referencia | Caja | Uso |
| --- | --- | --- |
| Cama | `[400,104,448,160]` | Sonido propio y choque de objeto |
| Reloj | `[352,48,368,64]` | Sonido de ambiente |
| Escaleras | `[336,184,352,208]` | Sonido de conexión |
| Escritorio | `[312,80,368,104]` | Clasificación de choque de objeto |
| Silla | `[336,104,352,128]` | Clasificación de choque de objeto |
| Estantería | `[416,48,448,88]` | Clasificación de choque de objeto |

No se inventó una puerta en el dormitorio donde hay escaleras, ni objetos recogibles o puntos de guardado que no se hayan identificado. El sonido `person` se usa para personas activas y visibles dentro del alcance, según sus datos vivos en RAM.

En la planta baja hay perfiles de cocina `[48,48,128,80]`, silla de cocina `[64,80,80,112]`, mesa `[64,112,96,176]`, silla de mesa `[32,112,48,144]`, sofá `[128,128,176,160]` y mueble del salón `[128,96,176,128]`. Todos se clasifican como mobiliario al confirmar el contacto. Las cajas siguen el área de colisión, que puede ser más amplia que los píxeles de un dibujo.

La escalera de regreso tiene una señal en `[184,88,208,112]`, la salida de la casa en `[168,208,184,224]` y el reloj en `[176,32,192,48]`. Se verificaron en `test/house-check/ground-floor-grid.png` y RAM real; los recorridos confirmaron la subida al dormitorio y la salida al exterior. Se mantiene una señal genérica para personajes vivos; no se ha creado un identificador semántico universal de madre, gato u otros eventos.

Para el choque se comprueba intención de movimiento sin desplazamiento y se confirma un contacto fresco de hasta 2 píxeles, en lugar de reutilizar una lectura de terreno de medio segundo antes. `7E01EB` ayuda a distinguir personas/objetos. Hay un intervalo mínimo de 24 fotogramas entre golpes repetidos.

### Avisos de cambio de cobertura

`room-reader.lua` recibe `(memory, folder, log, say)`. Conserva `lastRoom` para avisos y `activeRoom` para invalidar la lectura anterior al cambiar de perfil, independientemente de la suspensión por diálogos o menús. Al entrar anuncia dormitorio o planta baja. En la planta baja añade «Salida al sur. Escaleras al noreste». Si observa el tramo de escalera fuera del rectángulo del dormitorio, anuncia que se baja o sube, sin afirmar todavía que terminó el recorrido.

El aviso se emite después de limpiar/actualizar canales para que la señal breve no se corte ese mismo fotograma. No se repite por abrir y cerrar un diálogo ni al permanecer fuera. Ahora la planta baja se identifica por memoria, con localización 1. Salir de ella a `0x1F0` (496) anuncia la salida de la casa y falta de orientación en el exterior, con señal de puerta. Ese cambio se observa incluso sin el hook de control de campo ni un índice válido de jugador, porque el mapa exterior no ejecuta necesariamente esa rutina. No extender esta excepción a cualquier menú o localización.

