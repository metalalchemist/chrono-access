# Pruebas reunidas en `test/`

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

La organización vigente del emulador está en
[23. Emulador compartido de pruebas](23-emulador-compartido-de-pruebas.md).
Las copias por zona descritas en esta entrega se consolidaron; sus datos se conservan.

Las pruebas de Chrono están en
[`tools/chrono-access/test/`](../tools/chrono-access/test/README.md).
La reorganización del 26 de octubre de 2026 movió 59 entradas, con 583 archivos:
tests Python, guiones Lua de investigación, herramientas auxiliares y carpetas
de emuladores aislados con sus partidas, capturas y registros.

## Ejecutar las pruebas

Desde `D:\gt\vemovie`:

```powershell
python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q
python tools/chrono-access/test/check_audio.py
```

Resultado: **89 pruebas aprobadas** y comprobación de audio nativo aprobada.
Los fixtures conservan `ROOT` apuntando a `tools/chrono-access/`, donde siguen
los lectores. Las capturas se buscan bajo `ROOT/test/`. Las herramientas de
investigación llaman al código real de la carpeta superior y guardan sus
resultados en las copias aisladas dentro de `test/`.

## Qué se conservó y verificó

- Capturas de RAM, imágenes, registros históricos, estados y SRAM de prueba.
- Los 55 archivos de producción y recursos protegidos, incluida la ROM,
  conservan sus hashes. El lector y los accesos habituales siguen en su lugar.
- Los 51 archivos Lua de pruebas compilan con la DLL Lua 5.1 del emulador.
  Sus referencias absolutas a otros archivos Lua existen en las rutas nuevas.
- Los scripts PowerShell trasladados tienen sintaxis válida. Las rutas del
  recargador de pruebas y de la comprobación inicial de Snes9x se ajustaron.
- Los enlaces y comandos de la documentación anterior apuntan a la nueva
  ubicación. Los textos dentro de registros históricos se conservan.

La evidencia de integridad está en
[layout-before.json](../tools/chrono-access/test/layout-before.json),
[layout-path-updates.json](../tools/chrono-access/test/layout-path-updates.json) y
[layout-validation.json](../tools/chrono-access/test/layout-validation.json).
523 archivos trasladados quedaron idénticos; en los otros 60 solo se ajustaron
rutas de scripts o se regeneró bytecode de Python al ejecutar los tests.

La partida del usuario estaba abierta en el emulador habitual durante la
reorganización. No se cerró, recargó ni movió esa instancia. No se repitieron
los recorridos con botones de las entregas anteriores: esta entrega comprueba
la suite desde su nueva ubicación, el audio nativo y las rutas y sintaxis de
los guiones; la evidencia de recorridos reales sigue en sus carpetas movidas.

## Reversión

El inventario `entries` de `layout-before.json` enumera las entradas que antes
estaban directamente en `tools/chrono-access/`. Para deshacer la organización,
moverlas de vuelta y revertir las rutas de los archivos enumerados en
`layout-path-updates.json`, los comandos y enlaces documentales. No hace falta
revertir funcionalidades del lector, la ROM ni las partidas. Antes de mover
copias del emulador, comprobar que sus procesos estén cerrados.

`tools/` continúa ignorado por Git; no se hicieron commits.
