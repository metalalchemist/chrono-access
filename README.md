# Chrono Access

Capa de accesibilidad para **Chrono Trigger** que permite jugar a personas ciegas o con baja
visión con narración por voz de NVDA.

El lector se ejecuta como script Lua dentro de Snes9x a través de **Prism**, la API Lua del
emulador. En cada fotograma inspecciona la RAM del juego y traduce el estado del mundo a voz.

## Alcance: solo la versión en español (Magno 101%)

Este proyecto se validó **únicamente** contra la ROM *Chrono Trigger (U) con el parche de
traducción Magno 101%*. No hay soporte para la versión en inglés ni para otras traducciones.

- `lector-snes9x.lua` comprueba al cargar una firma de la rutina del menú (dirección `0xC2E236`);
  si no coincide, el lector se detiene con un mensaje explícito.
- `magno-charset.lua` traduce la tabla de glifos del parche: acentos, ñ y signos de apertura
  sustituyen símbolos originales. Con otra ROM el texto se leería corrupto aunque la firma pasara.
- Toda la narración, los perfiles de zona y la documentación están en español.

## Emulador necesario

El lector necesita una compilación de Snes9x con soporte Lua:

<https://github.com/agehring80/snes9x-lua>

Es un fork de `snes9xgit/snes9x` que incorpora la API Lua de gocha, solo para Windows.

Descarga ya compilada, sin necesidad de instalar nada más:

| Versión | Enlace |
| --- | --- |
| Windows 64 bits (recomendada) | <https://github.com/agehring80/snes9x-lua/releases/download/1.63-lua/snes9x-lua-1.63-win32-x64.zip> |
| Windows 32 bits | <https://github.com/agehring80/snes9x-lua/releases/download/1.63-lua/snes9x-lua-1.63-win32.zip> |

Si prefieres compilarlo tú, el repositorio incluye las instrucciones para Visual Studio.

## Requisitos

- Windows
- Snes9x con soporte Lua (enlace arriba)
- Lector de pantalla NVDA
- ROM *Chrono Trigger (U)* con el parche Magno 101%

## Inicio rápido

| Script | Para qué sirve |
| --- | --- |
| `iniciar-lector.cmd` | Arranca el emulador con el lector cargado |
| `recargar-lector.cmd` | Recarga el lector en un emulador ya abierto |
| `preparar-controles.ps1` | Configura la disposición del mando de Nintendo |
| `prepare-sounds.ps1` | Regenera las señales de audio de `runtime/sounds` |

Teclas principales: `Control+F1` aprende las señales de sonido, `Control+F5` orienta hacia el
objetivo seleccionado, `Control+F6` selecciona un objetivo y `Control+F7` calcula la ruta.

## Qué narra

- Posición, orientación y ruta de caminata hacia el objetivo elegido
- Personas, puertas, escaleras, cofres, tiendas, puntos de guardado y vehículos cercanos
- Menús: inventario, técnicas, grupo, configuración, guardar y cargar, comercio
- Menú de combate, estado de los enemigos y ritmo de los turnos
- Diálogos y minijuegos (moto, campana, carrera, soda, Ioka, baile, horrores)
- Señales de audio espaciales que apuntan a los elementos cercanos

## Estructura

| Ruta | Contenido |
| --- | --- |
| `lector-snes9x.lua` | Punto de entrada: verifica la ROM, inicializa la voz y conecta cada lector |
| `*-reader.lua` | Leen el estado del juego y lo narran |
| `*-model.lua` | Modelos de datos de las entidades descritas |
| `rooms/` | Perfiles por zona: referencias, obstáculos, distancias y sonidos de señal |
| `runtime/` | Módulos nativos ya compilados y señales de audio |
| `*.cpp`, `*.h` | Código fuente de los módulos de voz y audio |
| `continuar chrono.md` | Notas de trabajo entrega por entrega |
| `documentación/` | Documentación de cada entrega |

## Módulos nativos

- `chrono_prism.cpp`: puente de voz SAPI expuesto a Lua como `chrono_prism_v2.dll`
- `chrono_audio.cpp`: mezclador de señales espaciales usado por `rooms/audio-config.lua`
- `prism.dll`: [Prism](https://github.com/ethindp/prism), la capa de abstracción de voz y
  lector de pantalla sobre la que trabaja el puente. Ya viene compilada en `runtime/`.

## Créditos y licencias

- **Prism** (<https://github.com/ethindp/prism>), licencia MPL-2.0. `runtime/prism.dll` es una
  compilación de ese proyecto y se distribuye aquí conservando su licencia; el código fuente
  está disponible en el enlace anterior.
- **Snes9x** y su fork con Lua, ver la sección del emulador.
- El resto de este repositorio no declara licencia todavía.

## Estado

Trabajo en curso, entregado por iteraciones. El avance y las zonas pendientes están en
`continuar chrono.md`.
