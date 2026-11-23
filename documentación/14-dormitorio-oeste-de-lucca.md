# Dormitorio oeste de Lucca y rellanos de regreso

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

La habitación de la escalera izquierda del distribuidor tiene orientación
sonora desde el 26 de octubre de 2026. El dormitorio oeste es el mapa 000A.
También se cubren los dos rellanos del mapa 0004 a los que conducen pasos de
los dormitorios. Cada rellano tiene su propia puerta de regreso; no se anuncia
un recorrido entre ellos ni una escalera practicable hacia la sala principal.

## Uso

Al entrar se anuncia «Estás en el dormitorio oeste de la casa de Lucca».

- **Control+F5:** escalera al distribuidor, inicialmente al sureste.
- **Control+F6:** paso al rellano oeste, cama, mesa, estantería, silla, tubos,
  mueble bajo la ventana y vasijas, con dirección y distancia.

El paso al rellano oeste queda al suroeste. En ese rellano, Control+F5 consulta
la puerta del dormitorio oeste, una casilla al norte desde la llegada.
El dormitorio este tiene un paso equivalente a su propio rellano, con su
puerta de regreso al norte. Se actualizan los nombres de estas conexiones y
de la escalera izquierda del distribuidor.

Los muebles y paredes usan el audio existente. Las distancias no son rutas
y las consultas no mueven al personaje. Menús y diálogos suspenden los sonidos.
La captura del dormitorio oeste no contiene personas dentro del área; los
slots de personas inactivas o situadas fuera del mapa no se anuncian allí.

## Datos contrastados

La captura del usuario coincide con
[west-entrance-grid.png](../tools/chrono-access/test/lucca-west-check/west-entrance-grid.png),
obtenida entrando por la escalera oeste en copia aislada. El volcado
[west-entrance-ram.bin](../tools/chrono-access/test/lucca-west-check/west-entrance-ram.bin)
registra mapa **000A**, líder 2, X=392, Y=215,9375, cámara X=256, Y=32.
No se capturó su sesión en vivo: al intentar recargar para esa captura, no se
encontró una instancia habitual única. Se retiró la llamada temporal del lector.

El perfil `lucca_west_room` exige mapa 10, `304 <= X < 448`, `32 <= Y < 256`.

| Referencia | Caja en píxeles `[x1,y1,x2,y2]` |
| --- | --- |
| Escalera al distribuidor | `[416,224,448,240]` |
| Paso al rellano oeste | `[320,240,352,256]` |
| Cama | `[392,80,424,144]` |
| Mesa de trabajo | `[304,96,352,192]` |
| Estantería | `[320,48,352,112]` |
| Silla de trabajo | `[336,112,352,144]` |
| Tubos centrales | `[352,80,368,224]` |
| Mueble bajo la ventana | `[368,80,392,96]` |
| Vasija junto a la cama | `[384,160,400,176]` |
| Vasijas del suroeste | `[304,192,352,224]` |

Los dos registros de salida del mapa 10, banco E5, apuntan a mapa 3 y mapa 4.
La escalera devolvió al distribuidor, X=120, Y=167,9375. El paso suroeste
llevó al rellano oeste, mapa 4, X=48, Y=95,9375. Su puerta devolvió al
dormitorio oeste en X=336, Y=223,9375.

El paso secundario del dormitorio este también se comprobó: el rellano este
está en mapa 4, X=176, Y=95,9375; su puerta entra al dormitorio este en
X=96, Y=479,9375. Son conexiones nativas, no destinos inferidos por la imagen.

Los perfiles del mapa 4 quedan separados:

| Perfil | Límites `[x1,y1,x2,y2]` | Referencia de regreso |
| --- | --- | --- |
| Sala principal | `[0,128,256,336]` | Salida exterior y puerta al distribuidor |
| Rellano oeste | `[16,16,80,128]` | Puerta al dormitorio oeste, `[32,64,64,80]` |
| Rellano este | `[112,16,240,128]` | Puerta al dormitorio este, `[160,64,192,80]` |

El rellano este incluye las plantas en `[112,64,128,96]` y `[224,64,240,96]`.
El centro no se trata como un pasillo transitable. La propuesta inicial de
anunciar una escalera hacia la sala principal se rechazó al probar el movimiento:
desde el rellano oeste el juego detiene al personaje en X=72; los ensayos de
rodear el borde terminan en X=72, Y=119. Un intento situado directamente en
el dibujo central no consiguió bajar. Los datos están en
[stairs-research.txt](../tools/chrono-access/test/lucca-west-check/stairs-research.txt).
La versión final ofrece las puertas de regreso comprobadas y no esa escalera.

## Código y verificación

Solo se amplía contenido y límites en
[room-profiles.lua](../tools/chrono-access/room-profiles.lua). No se cambian
los controles, las rutinas de lectura de diálogo ni la detección de objetos.
Las referencias de los dormitorios y el distribuidor reciben los nombres de
sus destinos comprobados.

`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`:
**101 pruebas aprobadas**, cinco nuevas en
[test_lucca_west.py](../tools/chrono-access/test/test_lucca_west.py).
Comprueban captura, muebles, personas fuera del área, sonido de cama,
registros de salidas, consultas, separación entre rellanos y sala principal y
destinos reales conservados en los volcados `verified-*` del ensayo final.
Las expectativas de referencias y cobertura de entregas anteriores se actualizan.

El ensayo nativo está en
[reader-validation.txt](../tools/chrono-access/test/lucca-west-check/reader-validation.txt)
y [production-reader.log](../tools/chrono-access/test/lucca-west-check/production-reader.log),
producidos por
[check-lucca-west-reader.lua](../tools/chrono-access/test/check-lucca-west-reader.lua).
Se recorrieron referencias, se abrió y cerró el menú, se comprobó choque de
mueble con la cama desde una posición libre, se regresó al distribuidor y se
cruzaron las puertas dormitorio oeste ↔ rellano oeste y dormitorio este ↔
rellano este. Ambos rellanos consultan su puerta de regreso por voz.

El ensayo usa reubicación cerca de conexiones y estados de prueba; no acredita
un recorrido continuo entre cada mueble ni un camino entre los rellanos.
Los dos rellanos se probaron por separado. Las comprobaciones anteriores que
intentaban bajar a la sala principal fallaron y se conservan como evidencia
rechazada; no se ajustó la expectativa para presentar ese recorrido como válido.
La voz se registra y la DLL de audio nativa se silencia en el ensayo. Falta
la valoración del usuario con NVDA.

El guion de prueba de la cocina ahora etiqueta su visita oeste como `west-room`,
porque el mapa 10 ya tiene perfil. La respuesta genérica de zonas sin cobertura
sigue probándose en la suite; los registros antiguos de salas entonces pendientes
se conservan con su contexto histórico.

La copia aislada PID 9084 se cerró tras verificar su ruta y se restauró su
autorun a `test/discover-lucca-west.lua`. Los comandos del lector y de la
investigación de escaleras se archivaron como `west-command-reader-v1.lua`
y `gallery-command-stairs-v1.lua`. Los volcados del descenso fallido se
conservan como `rejected-stairs-main-ram.bin` y
`rejected-stairs-main-return-ram.bin`. El cargador habitual conserva su hash
original tras retirar la llamada temporal de captura.

Al finalizar no se encontró una copia habitual abierta, por lo que la
activación queda para la próxima apertura con `iniciar-lector.cmd`. No se
abrió ni cargó otra partida. Comprobar procesos actuales antes de operar;
no reutilizar ese PID de prueba.

## Reversión

Retirar `lucca_west_room` y los dos perfiles `lucca_*_landing`, devolver los
nombres y referencias anteriores en el dormitorio este y distribuidor, y
restaurar el límite inferior anterior de la sala principal. Los lectores,
ROM, DLL, partidas y menús no requieren cambios. Las copias, capturas y
guiones de investigación permanecen en `test/`. `tools/` continúa ignorado
por Git y no se hicieron commits.
