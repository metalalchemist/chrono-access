# Contexto, arranque y protección del proyecto

[Continuar el proyecto](../continuar%20chrono.md) · [Índice documental](README.md)

Las notas siguientes conservan la evidencia y el alcance de cada etapa. Los pendientes de una etapa pueden estar resueltos en documentos posteriores; el estado actual se consulta en el documento de continuación.

Las rutas de código escritas entre comillas invertidas parten de `D:\gt\vemovie`, salvo indicación distinta.

El inventario de archivos conservado abajo corresponde a las primeras etapas. Los módulos posteriores se enlazan desde [el índice](README.md). La nota antigua menciona `CHRONO_CONTINUAR.md`, pero no se encontró ese archivo al reorganizar: el punto de entrada existente es `continuar chrono.md`.

## Objetivo y preferencias del usuario

El usuario es ciego, usa NVDA y juega con un control Nintendo. Quiere leer diálogos y opciones al mover el cursor interno del juego, con independencia de cómo se asignen los botones. También quiere localizar objetos, paredes, personas y conexiones mediante sonidos que aumenten al acercarse, avisos de choque y, a futuro, indicaciones de distancia y rutas.

Prefiere una solución ligera. BizHawk resultó lento aun sin cargar nuestros scripts. Se decidió usar Lua dentro de Snes9x y Prism mediante un módulo nativo, sin un proceso Python durante el juego. No volver a proponer BizHawk como primera opción ni interceptar teclas para inferir selecciones que ya existen en la memoria del juego.

Le resulta fácil perderse cuando termina el área con sonidos. Por eso se añadieron avisos hablados de entrada y salida del dormitorio. Al describir una captura, distinguir lo visible de lo inferido: una captura del dormitorio con Crono en el tramo inferior de la escalera aún no demostraba que hubiese llegado a la planta baja; las siguientes capturas sí mostraron esa planta.

## Abrir el juego y conservar la partida

El acceso normal es `D:\gt\vemovie\tools\chrono-access\iniciar-lector.cmd`.

El script necesita Snes9x cerrado. Comprueba el SHA-256 de la ROM, genera un archivo Lua de inicio junto al emulador y abre la ROM con `-lua`. Solo sobrescribe ese archivo si tiene la marca `-- CHRONO_ACCESS_AUTORUN`. Se escribe en UTF-8 sin BOM y usa una ruta Lua entre corchetes largos.

Modificar los archivos no actualiza automáticamente un lector ya cargado. Para recoger cambios hay que recargar el script o volver a abrir el emulador. No cerrar ni reiniciar la partida del usuario sin atender a su progreso: este documento guarda el estado del desarrollo, **no es un guardado del juego**. Conservar ROM y carpeta `Saves/`. No se ha implementado un sistema propio de guardado automático.

Para recargar sin cerrar la partida, ejecutar `tools/chrono-access/recargar-lector.cmd`. Su PowerShell identifica una sola instancia del emulador esperado y una consola Lua cuya ruta corresponda al lector o a su archivo de inicio, y pulsa su botón Restart. No envía teclas al juego ni lo reinicia. Si no encuentra una coincidencia única, termina con un error en vez de escoger otra ventana. Se probó sobre el emulador aislado: la localización 496 y las coordenadas X=167, Y=223.94 se conservaron al recargar.

| Recurso | Ubicación o identificación |
| --- | --- |
| Workspace | `D:\gt\vemovie` |
| Proyecto accesible | `tools/chrono-access/` |
| Emulador | `tools/Snes9x-Lua-1.63/snes9x-lua-1.63-win32-x64/snes9x.exe` |
| ROM | `tools/Chrono Trigger (U) [T+Spa101%_Magno].smc` |
| ROM: tamaño y formato | 4194304 bytes, sin cabecera de copiador, HiROM, modo 0x31 |
| ROM: SHA-256 | `E8CBD564C0E37144BAE193A0C82DCD1C95AA25087911932FE01F1803DE519A50` |
| ROM: CRC32 y checksum interno | `975fd385`, `58E2` |
| Emulador descargado de | https://github.com/agehring80/snes9x-lua/releases/tag/1.63-lua |

El nombre Spa101% corresponde a la traducción de Magno 101.0%; no asumir que significa versión 1.01. Las direcciones y firmas se verificaron para esta ROM concreta.

### Configuración que permitió arrancar

Al principio Snes9x mostraba pantalla negra y no sonaba. Quedó funcionando con estos ajustes conjuntos:

| Ajuste | Valor |
| --- | --- |
| CPUOverclockMode | 0 |
| MaxSpriteTilesPerLine | 34 |
| SoundDriver | 8, WaveOut |
| Sound Sync | 0 |
| PauseWhenInactive | FALSE |

No se aisló cuál de los cambios solucionó el fallo. Conservar el `snes9x.conf` funcional y las DLL de Lua. El emulador anterior del usuario era ZSNESW; la implementación vigente es para el fork de Snes9x con Lua.

## Archivos que se usan al jugar

Rutas relativas a `tools/chrono-access/`:

| Archivo | Función |
| --- | --- |
| `iniciar-lector.cmd`, `iniciar-lector.ps1` | Arranque y verificación de ROM. |
| `recargar-lector.cmd`, `recargar-lector.ps1` | Recarga de la consola Lua del lector, conservando la partida abierta. |
| `lector-snes9x.lua` | Punto de entrada, voz, menú Activo/Lento y único callback por fotograma. |
| `name-reader.lua` | Cursor de letras, nombre escrito y confirmación. |
| `dialogue-reader.lua` | Captura y anuncio de páginas de diálogo. |
| `magno-charset.lua` | Tabla específica de caracteres de Magno. |
| `runtime/chrono_prism_v2.dll` | Módulo Lua 5.1 de 64 bits que llama a Prism. |
| `runtime/prism.dll` | Prism v0.18.3, comprobado con NVDA. |
| `room-reader.lua` | Cadencia, mezcla de señales, choques y avisos de cobertura de la casa. |
| `room-model.lua` | Posición, terreno, distancias y personajes para el perfil de habitación activo. |
| `room-profiles.lua` | Datos específicos de dormitorio y planta baja: identificadores, límites y muebles. |
| `room-audio-config.lua` | Activación, alcance, cadencia y volúmenes. |
| `runtime/chrono_audio.dll` | Mezclador de audio estéreo con hilo nativo. |
| `runtime/sounds/*.wav` | Los 15 sonidos preparados para el mezclador. |

El usuario aportó 18 MP3 en `sounds/`; se conservan sus originales. `prepare-sounds.ps1` usa `bin/ffmpeg.exe` y produjo WAV mono PCM de 16 bits a 22050 Hz. FFmpeg no hace falta al jugar. La búsqueda de nombres normaliza acentos porque PowerShell 5.1 puede interpretar mal cadenas UTF-8 sin BOM; los nombres de salida son ASCII.

Sonidos preparados: `wall_left`, `wall_right`, `wall_up`, `wall_down`, `wall_hit`, `object_hit`, `bed`, `clock`, `stairs`, `connection`, `person`, `door`, `item`, `sign` y `furniture`. El último se preparó del MP3 «objeto colisión» para señalar muebles, con una ganancia reducida al 40% para que destaque menos que las conexiones. El golpe usa otra muestra y es puntual. Que un sonido esté preparado no significa que exista ese tipo de objeto detectado en la habitación.

## Protección del trabajo y forma de retomarlo

El repositorio principal es VeMovie, un editor de vídeo, y tiene muchos cambios previos ajenos. **No limpiarlos, revertirlos ni mezclarlos con Chrono.** No se hicieron commits del prototipo. `tools/` está ignorado por `.gitignore`: el código existe en disco pero no tiene respaldo en Git por el mero hecho de estar aquí. No borrar prototipos, sonidos originales, ROM o partidas al ordenar archivos.

La memoria útil para el proyecto son los datos de la SNES y las rutinas verificadas, no los rangos completos de memoria del proceso Windows del emulador. Mantener la observación de estado en el hilo del emulador y el audio en su hilo nativo.

Para desactivar solo la orientación, cambiar `enabled=true` a `enabled=false` en `room-audio-config.lua` y recargar el lector. Para retirar la integración de audio, el límite es la inicialización, tick y cierre de `roomAudio` en `lector-snes9x.lua`; la voz y los lectores de texto son módulos independientes.

Los accesos y pruebas usan rutas relativas a la estructura actual; revisarlas antes de mover el proyecto. No sobrescribir DLL mientras estén cargadas en Snes9x. Leer `lector.log` con `Get-Content -LiteralPath 'tools\chrono-access\lector.log' -Encoding UTF8`.

Abrir una nueva conversación no exige rehacer lo implementado: este documento y los archivos permiten recuperar el estado. No asumir que el historial sustituye estas evidencias ni que esta nota guarda la partida. El anterior `CHRONO_CONTINUAR.md` se conserva con un enlace a este documento principal.
