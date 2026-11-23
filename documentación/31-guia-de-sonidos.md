# Aprender los sonidos con Control+F1

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

Al cargar el lector se anuncia: **«Pulsa Control F1 para aprender los sonidos»**.
El atajo abre una lista accesible de las 17 muestras utilizadas por el lector.

## Uso

1. Pulsa **Control+F1** durante el juego o los menús iniciales.
2. Usa **flecha abajo** y **flecha arriba** para elegir un sonido. NVDA puede
   leer el nombre y su explicación mediante el control de lista de Windows.
3. Pulsa **Enter** para reproducir la muestra seleccionada. Puedes repetirla;
   cambiar de selección detiene la muestra anterior.
4. Pulsa **Escape** para cerrar y continuar jugando. También hay botones
   «Reproducir» y «Cerrar», accesibles con Tab.

Mientras la guía está abierta, el juego no avanza y sus lectores quedan a
la espera. Los sonidos de orientación se silencian para escuchar una muestra
a la vez. Al cerrar se recupera la orientación normal. La guía funciona
también fuera de las zonas con referencias y con la orientación desactivada.

Incluye paredes izquierda, derecha, norte y sur; choques con pared y objeto;
cama, reloj, escalera, conexión, persona, puerta, objeto/cofre, cartel,
mueble, juego y pitido de tiempo. Las paredes laterales conservan su posición
estéreo; reloj y muebles conservan sus factores de volumen habituales.
Cada reproducción es una muestra individual, no una repetición continua.
El cartel se identifica como muestra disponible porque no todas las zonas lo usan.

## Implementación

- `sound-catalog.lua`: nombres, explicaciones, direcciones y factores de volumen.
- `room-reader.lua`: detecta una pulsación de Control+F1, prepara los IDs ya
  cargados y abre la guía. Mantener el atajo pulsado no abre ventanas sucesivas.
- `sound-guide-dialog.h`: diálogo modal con controles estándar de Windows,
  lista, botón predeterminado para Enter y cierre con Escape.
- `chrono_audio.cpp` y `runtime/chrono_audio.dll`: exponen `audio.guide` y
  reproducen las muestras en el mezclador existente, por el canal 23.
- `lector-snes9x.lua`: nuevo anuncio inicial y consulta del atajo antes de
  ejecutar los lectores habituales del fotograma.

El diálogo mantiene ocupado el callback del hilo del emulador; su bucle modal
procesa los mensajes de Windows y la accesibilidad. No modifica la RAM,
envía botones al juego ni cambia su estado de pausa. El hilo de audio sigue
funcionando sin acceder a Lua. Al cerrar vuelve el mismo callback y el juego
continúa desde el siguiente fotograma. No se añade un proceso al jugar.

## Verificación y límites

`test_sound_guide.py` comprueba los 17 IDs y sus volúmenes/direcciones,
el uso del modificador, la ausencia de repetición al mantener el atajo,
la apertura fuera de cobertura y el anuncio/integración del lector completo.

La prueba nativa carga el lector completo con voz y muestras silenciadas
únicamente en el caso `sound-guide-check`. Abre el diálogo real, recorre
su lista con mensajes de teclado dirigidos a sus controles, pulsa Enter dos
veces y cierra con Escape. Se comprueban los 17 nombres y que Enter mantenga
abierta la ventana. No se envían teclas globales ni se opera la partida habitual.

El registro acredita **OPEN FRAME 70131**, **CLOSED FRAME 70131 RAM UNCHANGED**
y **RESUMED FRAME 70132**. La comparación cubre los 128 KiB completos de WRAM.
Evidencias en `tools/chrono-access/test/sound-guide-check/`:

- `guide-runtime.txt`: anuncio, catálogo y comprobación de memoria/fotogramas.
- `window-validation.json`: nombres, selección, Enter repetido y cierre.
- `sessions/`: configuraciones y arranques archivados por el gestor.
- `suite-validation.txt`: resultado de la suite completa.

Guiones: `check-sound-guide.lua` y `check-sound-guide-window.ps1`.
La comprobación automatizada valida controles y ejecución; **falta la valoración
del usuario con NVDA y la escucha de las muestras a volumen normal**.

Verificación final: **244 pruebas aprobadas en 22,426 segundos**, ejecutadas con
`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`.
También pasa `python tools/chrono-access/test/check_audio.py`: audio nativo,
reloj monótono y cierre del hilo. El emulador de pruebas quedó cerrado.

## Activación y reversión

El siguiente arranque con `iniciar-lector.cmd` incorpora la guía. Se recompiló
`chrono_audio.dll` con `build-audio.cmd`, con Snes9x cerrado. Si se sustituye
esta DLL en otra instalación, hay que cerrar antes el emulador: una recarga
de Lua no reemplaza una biblioteca nativa que el proceso ya tenga cargada.
No se cambiaron ROM, partidas ni configuración habitual de audio.

Para revertir, retirar el catálogo, el método `learnSounds`, su llamada y el
nuevo anuncio del lector; retirar la inclusión y exportación del diálogo del
módulo nativo y recompilar con el emulador cerrado. Los perfiles y lectores
anteriores conservan sus módulos. No se hicieron commits de cambios ajenos.
