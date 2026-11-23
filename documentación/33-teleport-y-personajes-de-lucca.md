# Teleport y referencias de Lucca y Marle

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

El recinto de la presentación de Lucca, mapa **8**, distingue las dos plataformas
del invento con el nombre solicitado **«Teleport»** y sonido de objeto. Lucca
y Marle tienen referencias propias cuando aparecen como personajes independientes.

## Para jugar

- **Control+F6** recorre salida, Teleport izquierdo, Teleport derecho y las
  personas visibles. **Control+F5** consulta la posición de la referencia elegida.
- «Teleport izquierdo: plataforma de salida; entra desde el sur» señala la
  plataforma usada para la prueba. Habla antes con Lucca y avanza sus mensajes.
- «Teleport derecho: plataforma de llegada» distingue el destino de la prueba.
- «Lucca: controles del Teleport» sigue a Lucca cuando se desplaza.
- «Marle: habla con ella después de la prueba para continuar» aparece cuando
  está separada del grupo y puede participar en la escena. Acércate, mira hacia
  ella y pulsa **V**, equivalente al botón A.

Después de la primera prueba de Crono, **hablar con Marle continúa la historia**.
La invitación a repetir la prueba no obliga a repetirla. La secuencia se
contrasta con la [guía de la escena](https://www.cavesofnarshe.com/ct/walkthrough.php?chapter=1).
El registro habitual del usuario ya contenía «¡Yo quiero probar también!» al
iniciar esta ampliación; no se accionó su partida para avanzar esa escena.

La orientación inicial explica que se hable con Lucca antes de la prueba y
con Marle después. Las distancias son directas, no rutas alrededor de las
máquinas o del público. La referencia de una plataforma no ejecuta el invento
ni altera sus colisiones o condiciones nativas.

## Datos verificados

| Referencia | Identidad o límites | Sonido |
| --- | --- | --- |
| Salida al sur | `[96,224,160,240]`, conserva el registro ROM anterior | Puerta |
| Teleport izquierdo | `[48,80,88,112]`, plataforma de la captura nativa | Objeto |
| Teleport derecho | `[168,80,208,112]`, plataforma de la captura nativa | Objeto |
| Lucca | Slot 26, tipo 3; función inicial `81 02` carga el personaje 2 | Persona |
| Marle independiente | Slot 28, tipo 3; función inicial `81 01` carga el personaje 1 | Persona |
| Colgante de Marle | Slot 22, NPC `82 63`; solo cuando está visible | Objeto |

La lista genérica admitía tipos 4–6 y omitía el tipo 3 de Lucca y Marle.
El perfil añade `personTypes` para esos dos slots, como ya se hacía para
Marle en la plaza de la campana. No convierte a los compañeros del grupo
en referencias de persona. Posición y visibilidad se leen de la RAM actual.
Las entidades gráficas 54 y 56 y el efecto 50 dejan de aparecer como personas;
las personas del público conservan una etiqueta de público.

Las plataformas usan cajas fijas sin `solid`: no crean obstáculos artificiales.
El colgante no se anuncia mientras está oculto. Su lectura y referencia en
este recinto son independientes del colgante de la plaza de la entrega 29.

## Verificación

`room-profiles.lua` contiene el cambio funcional; no se modificaron el mezclador,
los WAV, la ROM ni la configuración de controles.

`test_teleport.py` verifica identidad por comandos nativos de carga, inclusión
del tipo 3, movimiento/ocultación, exclusión del compañero de grupo, dos señales
de objeto, salida conservada y consultas de referencia dentro del emulador.
Las pruebas de visibilidad del colgante incluyen cambios sintéticos: no
acreditan su recogida nativa en este recinto.

Las evidencias están en `tools/chrono-access/test/teleport-check/`:

- `entry-ready.gd` y `entry-ready-grid.png`: máquinas y plataformas con coordenadas.
- `intro-complete-ram.bin`: actores del mapa 8 y comandos de identidad.
- `lucca-talk`, `lucca-instructions`, `first-trial`: interacción y textos nativos
  de Lucca, incluida la indicación de subir a la tarima izquierda.
- `query-teleport-left`, `query-teleport-right`, `query-lucca`, `query-marle`:
  consultas habladas con Control+F5/F6, capturas y RAM nativas.
- `trial-platform-entry` y `trial-complete`: traslado nativo del líder desde
  X=72,875/Y=95,75 hasta X=184/Y=95,9375, con «¡Transfiriendo energía!» y
  «¡ES GENIAL!». Se acredita una prueba; no un ciclo repetido de ensayos.
- `reader-validation.txt` y `sessions/`: textos y arranques de la copia aislada.

Se usó el emulador compartido silenciado y un arranque nuevo. `setup-flags.lua`
prepara exclusivamente el ensayo con indicadores de historia obtenidos de una
lectura del estado guardado del usuario, sin sobrescribir ni cargar ese estado
en su emulador. Después se utilizaron el cargador de mapas y botones nativos
en la copia de prueba. Esto no acredita una ruta continua desde casa de Crono.
Los guiones `start-teleport.lua`, `check-teleport.lua` y `drive-teleport.py`
solo son para pruebas; no se usan en el juego habitual.

Falta la valoración de sonidos y referencias con NVDA por el usuario. No se
atribuye a esta ampliación la resolución del diagnóstico de menús de la entrega 32.

La suite completa pasa **262 pruebas en 36,864 segundos**:
`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`.
Registro en `test/teleport-check/suite-validation.txt`.

## Activación y reversión

Una recarga con `recargar-lector.ps1` incorpora los datos sin reiniciar ni
cargar la partida; no requiere cambiar la DLL. En un arranque nuevo se cargan
automáticamente.

Al terminar no se encontró una instancia habitual única para recargar; el
recargador se negó a escoger otra ventana y no modificó el juego. Las
referencias nuevas se cargarán en el siguiente arranque habitual.

Para revertir, retirar las dos plataformas y las etiquetas/tipos/sonidos nuevos
del perfil `leene_lucca`, y restaurar su orientación anterior. Conservar las
evidencias. El resto de los mapas, lectores y partidas no depende de estos datos.
