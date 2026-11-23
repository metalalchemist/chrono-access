# Un emulador compartido para las pruebas

[Continuar](../continuar%20chrono.md) · [Índice](README.md) · [Comandos de pruebas](../tools/chrono-access/test/README.md)

Todas las pruebas usan ahora `tools/chrono-access/test/emulator/`. El emulador
habitual del usuario sigue separado. Las carpetas por zona conservan partidas,
configuraciones, capturas, guiones y registros; ya no necesitan un ejecutable
y dos DLL cada una.

## Uso

Desde el workspace:

```powershell
& tools/chrono-access/test/emulador-pruebas.ps1 -Action Prepare
& tools/chrono-access/test/emulador-pruebas.ps1 -Action Start -Case race-check -Script discover-race.lua
& tools/chrono-access/test/recargar-prueba.ps1
& tools/chrono-access/test/emulador-pruebas.ps1 -Action Stop
```

El arranque usa la configuración histórica del caso si existe, o una base
compartida. Fuerza el silencio y la entrada en segundo plano; las rutas de
SRAM, estados y demás datos apuntan al caso. Cada ejecución archiva sus
archivos de control y registros en `<caso>/sessions/`. Los guiones antiguos
mantienen sus rutas de evidencia. Sus comandos pendientes deben revisarse
antes de lanzar un nuevo ensayo.

El compartido acepta una sesión a la vez. Para una prueba simultánea, añadir
`-Temporary` con otro caso. Se crea una carpeta `test/emulator-temp/tmp-…`,
se imprime su identificador y la llamada espera al cierre. Puede cerrarse desde
otra herramienta con `-Action Stop -Instance tmp-…`. Al terminar se retiran
los binarios temporales y se conservan sus datos y registros.

`-Action Cleanup` recoge temporales cerrados después de una interrupción.
Una sesión activa o una carpeta sin marcas válidas no se borra. Los mismos
datos de un caso no se comparten entre dos procesos simultáneos.

## Migración y protección

Se compararon SHA-256 antes de retirar los duplicados. Los 17 ejecutables
eran idénticos; también coincidían las 17 copias de cada DLL y `Valid.Ext`.
Se retiraron **68 archivos, 229943258 bytes**. Descontando la copia compartida
nueva, el ahorro neto de binarios es **216417184 bytes**, unos **206,4 MiB**.

Se conservaron y verificaron por hash **1431 archivos** de las carpetas antiguas,
incluidas configuraciones, partidas, autorun y capturas. Los inventarios están
en `test/runtime-inventory-before.json` y `test/runtime-consolidation.json`.
La marca `verified` confirma la comprobación posterior. El archivo `Valid.Ext`
estaba protegido contra escritura; se retiró después de verificar su identidad.
El script de consolidación puede reanudar una retirada interrumpida.

`test_reader.py` carga ahora la DLL de `test/emulator/`. `probar-snes9x.ps1`
prepara la prueba compartida y dejó de modificar la configuración habitual.
El recargador y el ayudante de entrada en segundo plano usan el compartido por
defecto y aceptan una carpeta temporal explícita.

El gestor comprueba rutas, PID y hora de inicio antes de operar un proceso.
Antes de borrar un temporal verifica su ubicación y propietario y archiva con
hash los archivos que no sean binarios recuperables. Las partidas residen en
el caso y se mantienen. No se cambiaron ROM, lectores ni accesos para jugar.

## Verificación

Se abrieron a la vez el compartido y una instancia temporal silenciados.
Ambos ejecutaron `smoke-emulator.lua`, comprobaron la ROM y alcanzaron el
fotograma 120. Se verificaron el rechazo de un segundo arranque sobre el
compartido ocupado, la conservación de registros y la retirada del temporal.
Las dos instancias de prueba se cerraron; no se operó el emulador habitual.

`test_emulator_runtime.py` añade cinco pruebas: preparación y retirada temporal,
conservación de partidas y evidencia adicional, configuración por caso, rutas
fuera de alcance, carpetas sin propietario o sesión, identidad de binarios,
uso compartido de la DLL Lua y protección de la configuración habitual.

La suite completa registra **186 pruebas aprobadas**:
`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`.
También se comprueba el mezclador nativo con `python tools/chrono-access/test/check_audio.py`.
Los recibos finales quedan en `test/shared-runtime-check/` y las sesiones
nativas en `emulator-smoke-check/sessions/` y `emulator-extra-smoke-check/sessions/`.

## Reversión

La consolidación no cambia el juego. Para recuperar una disposición antigua,
`runtime-consolidation.json` enumera las rutas retiradas: copiar a ellas el
archivo con el mismo nombre de `test/emulator/`, verificando su hash. Los datos
originales de cada caso siguen en su lugar. Restaurar la ruta anterior de la DLL
en `test_reader.py` y los ayudantes de prueba solo si se revierte esta organización.
Los documentos anteriores conservan sus referencias históricas.

No se hicieron commits de cambios ajenos. `tools/` sigue ignorado por Git.
