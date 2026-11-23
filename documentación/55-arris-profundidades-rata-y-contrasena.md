# Arris: profundidades, rata y contraseña

[Continuar](../continuar%20chrono.md) · [Índice](README.md) · [Entrega anterior](54-huida-comprobada-y-cuartel-oeste.md)

Arris tiene orientación en nueve mapas, con 48 referencias nuevas. Se comprobó
en una copia silenciada la lectura de la nota, una persecución con la rata en
movimiento, su captura, la contraseña y la activación de la consola. Con la
configuración de teclado encontrada, **A+S+V simultáneas corresponden a L+R+A**.
**S+D+A corresponden a R+X+L y abren el menú**, sin activar la consola.

## Para jugar

1. En Arris, busca la escotilla entre los habitantes. Entra desde su plataforma
   norte; la pasarela inferior está en otro nivel y no permite acceder directamente.
2. En el subsuelo, la escalera noroeste lleva a las vigas. Sus referencias marcan
   los giros. Desde el sur: norte, este, norte, este, norte, oeste, norte, este y norte,
   siguiendo las vigas hacia el acceso del Guardián. Las distancias a una referencia
   o a la rata son directas; no significan que puedas atravesar el vacío.
3. Tras el Guardián, examina los restos de la persona del almacén. La nota escrita
   en una sábana explica que la rata no es una estatua. Su lectura habilita la carrera.
4. Vuelve a las vigas. Mantén **B para correr** y pulsa **A para atraparla** al
   acercarte. Hay actores para la persecución en ambos sentidos. Si escapa, sal
   y vuelve a entrar. La rata tiene señal de juego, distinta del peligro de enemigos;
   mientras corre, el lector anuncia su dirección y distancia cada 90 fotogramas.
   Los avisos sustituyen el aviso hablado anterior para evitar acumular posiciones
   antiguas. Se detienen durante diálogos y al obtener la contraseña.
5. Regresa a las consolas del subsuelo. Acércate desde el sur mirando al norte.
   Pulsa **L+R+A juntos**; en el teclado examinado, **A+S+V**. También puedes mantener
   L y R y después pulsar A, como indica la rata. La consola necesita que hayas
   obtenido la contraseña; conocer los botones por otra fuente no habilita el paso.

Control+F5 consulta la referencia seleccionada y Control+F6 cambia de referencia.
Los diálogos y el combate conservan sus lectores habituales.

## Cobertura

| Mapa | Referencias y función |
| --- | --- |
| 214 | Arris: salida, escotilla, plataforma norte, Tauritón y habitantes numerados. |
| 216 | Subsuelo: escaleras, giros, dos computadoras y estado de sus plataformas. |
| 221 | Vigas: ocho giros, accesos, ratas móviles y señal de enemigos conservada. |
| 219 | Cámara del Guardián: regreso y puerta del almacén. |
| 344 | Almacén: restos y nota, cofre de la escena de la semilla, cajas y salida. |
| 215 | Corredor de enemigos: accesos y un cofre. |
| 217 | Profundidades: accesos y consola del paso norte. |
| 218 | Sala de información: dos terminales y regreso. |
| 220 | Cámara sellada: cuatro cofres y regreso; bloqueada en la primera visita. |

Hay **seis referencias a cofres**: cinco proceden de las tablas nativas de
tesoros; el del almacén pertenece a un evento, no a esa tabla. Al obtener la
semilla, su referencia dice «recogido» y deja de emitir sonido de objeto.
Los otros cinco conservan la detección de apertura por sus bits nativos.
No se presentan los cofres sellados como disponibles en la primera visita.

## Qué se comprobó

El ensayo reproducible es [run-arris-native.py](../test/run-arris-native.py),
ejecutado únicamente en la copia gestionada `future-check`. Recibo final:
[arris55-native.txt](../test/future-check/arris55-native.txt).

| Resultado | Capturas RAM/GD en `test/future-check/` |
| --- | --- |
| Nota real y habilitación de la rata, bit `0x10` de `7F00EC` | `arris55-note`, `arris55-note-finished` |
| Presentación de Marle/Lucca antes de correr | `arris55-rat-introduction` |
| Inicio antes del disparador nativo y captura tras los giros | `arris55-rat-start`, `arris55-catch` |
| Contraseña obtenida, bit `0x40` de `7F00EC` | `arris55-password` |
| Consola aún desactivada | `arris55-console` |
| R+X+L simultáneos: menú, sin activar el paso | `arris55-sda` |
| L+R+A simultáneos: bit `0x20` de `7F00A4` y aviso de consola pulsada | `arris55-lra` |
| Escena real de alimentos podridos y semilla | `store-load`, `store-scene` |

La persecución final empieza al norte del disparador, avanza la presentación
y recorre los giros corriendo con B y pulsaciones de A. La captura ocurre
cerca del tramo sur, en `(250, 702.9375)`. Durante ese recorrido no se
reposiciona al grupo ni se altera el estado de la rata.

El arranque del ensayo **prepara historia 53 y el estado del almacén**, omitiendo
el combate del Guardián y la escena de la semilla. Después de leer la nota se
carga nativamente el mapa de las vigas; después de la captura se carga el de
las consolas. Se conserva la contraseña real entre estos escenarios. No es
un recorrido continuo a pie de todo el domo. La semilla se comprobó en otro
ensayo. Las primeras capturas de captura cercana a una rata quieta no se usan
como prueba de la carrera: se conservan aparte de la persecución final.

Las combinaciones se inyectaron como botones SNES en un mismo fotograma.
La equivalencia de letras procede de `snes9x.conf`: L=A, R=S, A=V, X=D.
No se ensayó la electrónica de un teclado físico ni se cambió el mapeo del usuario.

Las nueve salas se cargaron para inspección. Las conexiones y cinco cofres de
tabla se contrastan con la ROM; no se abrieron todos los cofres de las profundidades
ni se recorrieron a pie todos sus pasillos. El combate del Guardián no se ensayó
en esta entrega. La valoración personal con NVDA sigue pendiente.

## Audio, pruebas y archivos

[verify-arris-audio.py](../test/verify-arris-audio.py) reproduce capturas mediante
el lector real y `chrono_audio.dll` con salida silenciada. Comprueba nueve tipos
de señal, límites de volumen y estéreo y PCM no vacío. Para alcanzar cada referencia
reposiciona solamente el observador de la reproducción offline: eso no prueba
una caminata nativa. Recibo: [arris55-audio.txt](../test/future-check/arris55-audio.txt).
`audio-validation.txt` conserva además la señal de juego de la rata durante el motor.

[test_arris.py](../test/test_arris.py) cubre perfiles, tesoros y conexiones de la
ROM, ratas dinámicas y amistosas sin ocultar enemigos, estados de consola,
nota y cofre de evento, carrera real y cese de avisos tras la contraseña.
El recibo de la suite general, audio y sintaxis Lua está en
[unit-validation-55.txt](../test/future-check/unit-validation-55.txt).
Resultado final: **401 pruebas aprobadas**, incluidas las ocho de Arris;
mezclador real, muestras PCM y sintaxis Lua aprobados.

Los cambios de juego están en `room-profiles.lua`, `room-model.lua` y
`room-reader.lua`. [build-arris-profiles.py](../test/build-arris-profiles.py)
regenera solo el bloque `BEGIN ARRIS` y conserva los perfiles anteriores.
`test/warp-future.lua` admite indicadores opcionales únicamente dentro de la
copia aislada; no se instala en el lector del usuario.

La copia queda cerrada. No se operó una instancia del usuario ni se escribieron
su ROM, SRAM o partidas. Su `.000` ya difiere del hash de la entrega 54: no se
restaura esa partida anterior. El recibo 55 compara un hash tomado antes de la
validación final con el archivo al terminar; no lo presenta como un hash tomado
al inicio de toda esta entrega.

## Activación, reversión y continuación

Los cambios se cargan al próximo inicio o con `recargar-lector.cmd`, conservando
la partida. No se inicia ni se recarga por el usuario durante estas pruebas.

Para retirar esta entrega, elimina únicamente el bloque `BEGIN ARRIS` de
`room-profiles.lua`, el soporte `friendlyActors` y `collected` de `room-model.lua`
y el seguimiento `trackActors` con sus variables de `room-reader.lua`.
Los scripts y evidencias nuevos se pueden conservar para diagnóstico.
No restaures todos los perfiles desde la copia `room-profiles-before-55.lua`
si después se añaden otras zonas.

Siguiente paso: valoración del recorrido con NVDA y, si se desea continuar la
historia, Lab 32 y Proto. Quedan sin ensayo completo el Guardián y la apertura
de los cofres de las profundidades; sus referencias están implementadas.
