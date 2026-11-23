# Lectura de partidas desde la pantalla de título

[Continuar el proyecto](../continuar%20chrono.md) · [Índice documental](README.md)

La pantalla de carga anuncia las ranuras válidas, capítulo, grupo guardado,
niveles y tiempo. Distingue las partidas existentes de «Nueva partida».
La entrega se verificó el 26 de octubre de 2026 con 81 pruebas aprobadas y
una carga real en una copia aislada de Snes9x. Falta la valoración del usuario con NVDA.

## Cómo usarla

1. Abre el juego con el acceso habitual y avanza desde el título con Start.
2. Escucha las ranuras disponibles. Arriba y abajo eligen una partida o «Nueva partida».
3. Confirma la partida que quieras recuperar. Se anunciará «Partida cargada de la ranura…».

Las ranuras sin datos válidos las omite el propio cursor del juego. Si no hay
ninguna, el lector avisa y anuncia «Nueva partida». Confirmar una partida la
carga directamente: no hay una pregunta Sí/No adicional ni se escribe una partida.
Confirmar «Nueva partida» empieza desde el principio.
Son los botones del mando configurado en Snes9x, no las teclas F1–F10 de estados rápidos.

## Implementación y referencias

- [load-reader.lua](../tools/chrono-access/load-reader.lua): contexto de carga, cursor y finalización.
- [save-reader.lua](../tools/chrono-access/save-reader.lua): resumen compartido de datos de ranura.
- [lector-snes9x.lua](../tools/chrono-access/lector-snes9x.lua): carga y tick de ambos lectores.
- [test_load.py](../tools/chrono-access/test/test_load.py): seis pruebas específicas de carga.
- [test_save.py](../tools/chrono-access/test/test_save.py): regresión de Guardar.
- [Entrega anterior: Guardar](07-guardar-partidas.md): distribución de SRAM y capítulos resueltos.
- [Validación nativa](../tools/chrono-access/test/load-check/validation.txt): datos y alcance del ensayo.
- [Registro nativo](../tools/chrono-access/test/load-check/runtime.txt): recorrido hablado de la pantalla.

Las rutas escritas entre comillas invertidas parten de `D:\gt\vemovie`.

El resumen de `save-reader.lua` acepta ahora el propósito `load`. Usa los
mismos datos verificados de SRAM y capítulos resueltos, con instrucciones de
carga. Guardar conserva sus mensajes de guardado y sobrescritura. No se añadieron
otros hooks de glifos ni otro acceso a las partidas del usuario.

Direcciones contrastadas con la ROM local y `bank_C2.asm`:

| Dirección | Evidencia y uso |
| --- | --- |
| C2E83F | Fin de construir la pantalla. Reinicia el contexto y anuncia ranuras válidas. |
| C2E635 | Después de leer entrada, antes de omitir ranuras inválidas. No anunciar ese cursor provisional. |
| C2E7C1 | Fin de la fila, después de `Menu_SaveSlotCursorMove`. Captura selección definitiva. |
| 7E0054 / 7E0079 | Cursor y ranura: exigir coincidencia; 0–2 son partidas, 3 es Nueva partida. |
| 7E0D49..0D4B | Validez comprobada por el motor. Las ranuras inválidas no son seleccionables. |
| C2E657 | Llamada nativa a `SaveSlot_LoadRegions`; registra la ranura pendiente. |
| C2E65B | Retorno de la carga nativa. Solo aquí anuncia la partida cargada. |
| C2E65D / C2E694 | Preparación y salida nativa de Nueva partida; distingue inicio de selección. |

Todas las firmas se comprueban antes de instalar hooks. La voz se emite en el
callback por fotograma. Un cambio de cursor no inicia una carga ni se interpreta
como confirmación. Tras cargar se limpia el contexto para evitar repeticiones.

## Pruebas y evidencia

`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py'`: **81 aprobadas**.
Las seis nuevas cubren datos guardados, ausencia de partidas, Nueva partida,
cursor provisional, ranuras inválidas, confirmación al terminar la carga,
reentrada, firmas incompatibles y detección limitada de Nueva partida más.

`test/check-load-runtime.lua` ejecutó el lector de producción con voz registrada y
audio silenciado en `test/load-check/`. Se preparó su SRAM de prueba a partir de
`test/save-check/cancel-baseline.srm`: se duplicó la ranura 1 en la 3, con checksum y
marca válidos; la 2 quedó inválida. Es una preparación sintética de partidas;
la validación del cursor, renderizado y carga posterior sí ejecutó el motor real.

El registro muestra 1 → 3 → Nueva partida → 3 → 1 y «Partida cargada de la ranura 1».
Se leyó «La Fiesta del Milenio. Crono. Nivel 1. Tiempo 0 horas y 4 minutos».
`loaded-ram.bin` confirmó localización 496, vida 70, dinero 400 y contador de
guardados 2. La SRAM después de cargar coincidió byte por byte con `before-load.srm`.
No se cargó ni se modificó la partida del usuario.
La copia PID 2820 se cerró tras verificar su ruta; no reutilizar ese PID.
Después de cerrarla, el archivo SRAM seguía idéntico al original de prueba.
La consulta posterior no encontró procesos Snes9x abiertos: la activación del
usuario queda para su próxima apertura con el acceso habitual.

## Límites, activación y reversión

La opción «Nueva partida más» se identifica si está desbloqueada, pero su pantalla
de elección de origen aún no tiene lectura completa. El lector se suspende al entrar
en esa modalidad para no presentar su selección de origen como una carga normal.
La pantalla sin partidas y el inicio de Nueva partida tienen pruebas sintéticas;
el ensayo nativo de esta entrega cargó una partida existente.

No se añadió un selector de archivos .srm ni gestión de estados rápidos del emulador.
El lector observa la SRAM del juego ya abierto y no escribe memoria ni pulsa botones.
Falta validar la experiencia con NVDA y el mando del usuario.

Activación: acceso habitual `iniciar-lector.cmd`, o `recargar-lector.cmd` si el
emulador ya está abierto. No cerrar una partida en curso para probar la carga.

Reversión: retirar carga/tick de `tickLoad` en `lector-snes9x.lua` y
`load-reader.lua`. El resumen compartido opcional puede permanecer: las llamadas
de Guardar conservan su comportamiento anterior. Sin cambios de ROM o DLL.
No se hicieron commits; `tools/` continúa ignorado por Git.

Los scripts `test/check-load-runtime.lua` y los archivos de `test/load-check/` son solo de
investigación: automatizan botones y nunca deben cargarse en la partida del usuario.
