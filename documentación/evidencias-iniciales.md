# Evidencias y herramientas de las primeras etapas

[Continuar el proyecto](../continuar%20chrono.md) · [Índice documental](README.md)

Las notas siguientes conservan la evidencia y el alcance de cada etapa. Los pendientes de una etapa pueden estar resueltos en documentos posteriores; el estado actual se consulta en el documento de continuación.

Las rutas de código escritas entre comillas invertidas parten de `D:\gt\vemovie`, salvo indicación distinta.

## Evidencias y pruebas ya realizadas

Última validación de la ampliación a la planta baja:

| Comprobación | Resultado registrado |
| --- | --- |
| `python tools/chrono-access/test/test_reader.py` | 13 pruebas aprobadas de menú, nombre, firmas, páginas, acentos, colas y casos de error |
| `python tools/chrono-access/test/test_room.py` | 6 pruebas aprobadas del dormitorio sobre RAM capturada |
| `python tools/chrono-access/test/test_house.py` | 5 pruebas aprobadas de planta baja, obstáculos, puerta, personajes, ganancia y cambios de zona; 24 en total con las anteriores |
| `python tools/chrono-access/test/check_audio.py` | Carga de los 15 WAV, apertura del dispositivo y cierre del hilo |
| `python tools/chrono-access/test/check_audio.py --play` | Prueba audible breve de cercanía, paneo y golpe |
| `python tools/chrono-access/test/test_reader.py --native --voice` | Prism detectó NVDA al ejecutarse con acceso a la sesión de Windows |
| Compilación de `chrono_audio.cpp` | Compiló con Build Tools sin advertencias en la validación anterior |
| 100 consultas del modelo sobre RAM capturada | Promedio de 0.330 ms por consulta en la DLL real de Lua; no mide el coste total del emulador |

Las pruebas enfocadas se ejecutaron al implementar esta ampliación. La prueba audible y la detección NVDA de la tabla corresponden a la validación anterior del puente, que no se modificó. La nueva prueba de integración usó los módulos de producción y el mezclador nativo en un emulador aislado, pero sustituyó la voz por registro y llevó la ganancia nativa a cero para no interrumpir al usuario. La prueba de voz dentro del sandbox puede no detectar NVDA; no confundir el aislamiento de la sesión con un fallo de Prism.

Las pruebas Python cargan la DLL real de Lua 5.1 mediante ctypes. Son herramientas de desarrollo y no un requisito de ejecución del lector.

`test/room-check/bedroom-ram.bin` contiene una captura real de 128 KiB de RAM; `bedroom.gd` y `bedroom-grid.png` ayudan a relacionar posiciones y decoración. Al obtener control tras levantarse, Crono tenía `X=394.25`, `Y=143.9375`, índice 2, capa 1. No usar la posición durante el sueño como prueba de control libre.

`test/room-check/discovery.txt` registra una prueba aislada de movimiento: se detuvo en `X=400.25` junto a la cama y `X=311.25` junto a la pared izquierda, con separación calculada de 2 píxeles. La escalera mueve automáticamente en diagonal: hubo puntos aproximados `(344.25,199.94)`, `(359.25,214.94)` y `(374.25,229.94)`. Eso prueba el recorrido y la salida del perfil del dormitorio, no identifica por sí solo los límites de la planta baja.

`test/runtime-check/result.txt` contiene cinco páginas obtenidas por otra prueba aislada y silenciada. Ese registro precede a la corrección del separador de MAMA de punto y coma a dos puntos. Los emuladores de prueba usados en esas verificaciones se cerraron al finalizar; comprobar procesos reales si se vuelve a trabajar y no fiarse de antiguos archivos de PID.

`test/house-check/ground-floor-ram.bin` contiene la planta baja: localización 1, índice de líder 4, X=216, Y=103.9375, capa 1. La lectura del líder no debe quedarse fija en el índice 2 del dormitorio. `ground-floor.gd` y `ground-floor-grid.png` muestran cocina, mesa, sofá, reloj, escaleras y personajes. `door-near-ram.bin` registra X=176, Y=201.9375, aún en la planta baja. El paso posterior lleva a localización 496. No había bits de salida 0x10 en el área de esa captura: no basta ese bit para descubrir esta conexión.

`test/house-check/runtime.txt` y `runtime-reader.log` registran el lector completo con hooks reales: planta baja → dormitorio (X=328, Y=199.94) → escalera → planta baja (X=207, Y=103.94) → exterior (localización 496, X=167, Y=223.94). También comprueban muestras de puerta, mobiliario, pared, reloj, escalera y personaje, con ganancia y paneo antes de silenciar la salida de prueba.

Se probó `recargar-lector.ps1 -EmulatorFolder tools/chrono-access/test/room-check` contra la consola oculta de esa copia: conservó localización y coordenadas en vez de volver al título. La lectura del campo Edit de otro proceso necesita WM_GETTEXT; GetWindowText por sí solo devolvía cadenas vacías. El botón era Restart. La copia de investigación (último PID 6204) fue cerrada y su configuración FrameSkip volvió a 200; el emulador y la partida del usuario no se controlaron.

Límites de reversión: el audio de planta baja es un perfil de `room-profiles.lua` junto con los avisos de casa de `room-reader.lua`; no requiere revertir los lectores de texto ni recompilar DLL. El acceso `recargar-lector.cmd/.ps1` es una unidad independiente y puede retirarse sin cambiar el juego ni el lector. Los resultados de integración anteriores documentan ambas unidades aun sin commits.

## Herramientas de desarrollo y prototipos anteriores

| Archivos | Uso |
| --- | --- |
| `chrono_prism.cpp`, `build-native.cmd` | Compilar `runtime/chrono_prism_v2.dll` con Visual Studio Build Tools 2022 |
| `chrono_audio.cpp`, `build-audio.cmd` | Compilar el mezclador `runtime/chrono_audio.dll` |
| `prepare-sounds.ps1` | Preparar WAV desde los MP3 originales, usando FFmpeg del workspace |
| `test/test_reader.py`, `test/test_room.py`, `test/test_house.py`, `test/check_audio.py` | Pruebas enfocadas del prototipo |
| `test/check-dialogue-runtime.lua`, `test/runtime-check/` | Captura aislada de diálogos; automatiza botones |
| `test/discover-room.lua`, `test/room-check/` | Investigación del mapa y movimiento; automatiza botones |
| `test/discover-house.lua`, `test/house-check/` | Recorrido por escaleras, capturas de planta baja y comandos de investigación |
| `test/check-house-runtime.lua` | Lector de producción dentro de la copia aislada, con voz registrada y audio silenciado |
| `bank_C0.asm`, `bank_C2.asm`, `ramvars.asm` | Desensamblado consultado y contrastado con nuestra ROM |
| `snes9x-lua-api.cpp`, `snes9x-window.cpp`, `cpuexec.cpp` | Fuentes del fork consultadas para conocer callbacks y ejecución |
| `font-preview.png`, `font-specials.png` | Inspección de glifos de Magno |
| `prism-sdk/`, `prism-windows-x64.zip` | SDK, licencias y descarga original de Prism |
| `test/probar-snes9x.cmd`, `test/probar-snes9x.ps1` | Configuración/reparación inicial con respaldo |
| `lector.log` | Registro UTF-8 de avisos y textos leídos |

**No cargar `test/discover-room.lua`, `test/discover-house.lua`, `test/check-house-runtime.lua` ni `test/check-dialogue-runtime.lua` en la partida del usuario:** inyectan botones para investigación o sustituyen callbacks y salidas. Usar una copia aislada y silenciada del emulador si hace falta repetirlos. Los archivos command.lua y runtime-command.lua también pertenecen solo a esas pruebas. No terminar todos los procesos llamados `snes9x`: verificar PID y ruta de la copia propia antes de cerrar un proceso.

`bridge.lua`, `monitor.py` e `iniciar-monitor.cmd` son el antiguo prototipo de volcado de RAM de BizHawk/Python y ya no participan. BizHawk y su ZIP tampoco son necesarios para el lector actual. `runtime/chrono_prism.dll` es una versión antigua; se carga `chrono_prism_v2.dll`. Se conservaron los archivos anteriores, sin borrarlos.

