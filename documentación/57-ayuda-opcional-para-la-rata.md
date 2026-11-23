# Ayuda opcional para la rata de Arris

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

El lector ofrece ayuda al detectar el desafío de la rata, después de leer la
nota del almacén. No se inicia automáticamente por entrar a la sala.

| Atajo | Acción |
| --- | --- |
| Control+F2 | Iniciar la ayuda; si ya está funcionando, cancelarla. |
| Control+Mayúsculas+F2 | Escuchar las instrucciones sin iniciar la ayuda. |
| Control+Alt+F2 | Activar o desactivar el diagnóstico de caminata. |

El aviso dice: «Estás en un desafío: la rata de Arris. Pulsa Control F2 para
hacerlo automáticamente, o Control Mayúsculas F2 para escuchar las instrucciones».
Se anuncia una vez al entrar al contexto. Fuera de un desafío implementado,
Control+F2 indica que no hay ayuda disponible y no pulsa botones del juego.

## Qué hace la ayuda

Corre siguiendo las vigas, pulsa aceptar cerca de la rata y avanza la presentación
y su diálogo para obtener la contraseña. Después camina hasta la salida sur,
baja al subsuelo, llega a la consola oeste y pulsa L+R+A simultáneamente. Comprueba
el indicador nativo de apertura antes de anunciar que terminó. El grupo queda
frente a la consola con el control devuelto al usuario.

Si la rata escapa, sale y vuelve a entrar para reintentar desde el extremo sur.
Se limita a tres reentradas. Puede iniciarse a mitad de las vigas; no exige que
el usuario vuelva al comienzo. Un bloqueo prolongado detiene la ayuda con un aviso.
Si la rata capturada queda atravesada en el tramo sur, la recuperación puede
cruzar el umbral norte hacia la cámara del Guardián y regresar inmediatamente:
solo permite la zona de la puerta, sin avanzar hacia el combate. Al volver,
el juego actualiza de forma nativa la presencia de las ratas. Esta recuperación
de bloqueo tiene comprobación sobre capturas; los dos recorridos completos
aprobados no necesitaron ese desvío.
Control+F2 permite cancelarla en cualquier momento. Al detenerse suelta todos
los botones que estuviera pulsando.

Mientras escucha instrucciones se silencian temporalmente los avisos hablados
de posición de la rata, conservando las señales ambientales. Durante la ayuda
también se evitan esos avisos repetitivos. La guía Control+F1 y las referencias
Control+F5/F6 siguen disponibles.

## Alcance y protección de la partida

La ayuda usa exclusivamente botones SNES a través de `joypad.set`. No escribe
RAM, no cambia indicadores de historia, no reposiciona al grupo y no carga
partidas. La contraseña y la plataforma se obtienen ejecutando sus eventos
nativos. No resuelve el combate del Guardián ni lee por el usuario la nota
del almacén antes de habilitar el desafío.

El contexto comprueba mapa, indicadores y firmas de actores nativos. No inicia
acciones desde menús o combate. Espera las transiciones entre los mapas 221 y
216, durante las que el líder puede no tener una posición válida. Si aparece
otro mapa, un menú, un bloqueo o un estado incompatible, cancela y suelta botones.
El único mapa adicional permitido durante una recuperación es el umbral sur del
219, con límites de posición explícitos. Tras obtener la contraseña y abrir la
plataforma, deja de ofrecer el desafío como pendiente.

La infraestructura admite otros desafíos mediante implementaciones específicas,
pero esta entrega solo incorpora **la rata de Arris y su consola**. No se anuncia
automatización de los demás minijuegos o acertijos.

## Código y comprobaciones

- `challenge-assist.lua`: detección, aviso, atajos, consentimiento por pulsación,
  cancelación, instrucciones y devolución del control.
- `arris-rat-challenge.lua`: firmas de Arris, navegación por las vigas,
  captura, reintento, salida nativa y consola.
- `lector-snes9x.lua`: integración real en los callbacks de fotograma.
- `walk-trace.lua`: diagnóstico trasladado de Control+F2 a Control+Alt+F2.
- `room-reader.lua`: silencio temporal de avisos hablados de la persecución.

`test/test_challenge_assist.py` comprueba que no se pulsa ningún botón sin
solicitud, que escuchar instrucciones no activa la ayuda, que mantener F2
pulsado no alterna repetidamente y que cancelación, menús, combate, cierre,
firmas incorrectas y transiciones devuelven o conservan el control.
`test/test_reader.py` prueba el atajo a través del lector y el callback de
entrada de producción, sin activar el diagnóstico de caminata.

El ensayo del motor usa `test/check-arris-assist.lua`, que carga los mismos
módulos de producción, y `test/run-arris-assist.py`. Se ejecuta exclusivamente
en la copia silenciada `future-check`. El arranque prepara historia y nota
leída: no demuestra el combate previo del Guardián. Después de iniciar con F2
no se reposiciona al grupo ni se cargan mapas por guion: la salida de las vigas
y la llegada al subsuelo se producen caminando por las conexiones del juego.

Los recibos de los escenarios se conservan como `assist57-north-receipt.txt`
y `assist57-middle-receipt.txt`, con capturas RAM/GD del mismo prefijo.
`assist-validation.txt` conserva progreso y avisos, incluidos los intentos
de desarrollo que no llegaron al final. Solo se consideran aprobados los
escenarios con recibo final PASS.

La copia de esta entrega usa OpenGL en `test/future-check/snes9x.conf`, porque
Direct3D presentó un error de controlador al iniciar la prueba. La configuración
del emulador habitual no se modifica.

La validación final y los hashes de los archivos del usuario están en
`test/future-check/unit-validation-57.txt` y `protected-hashes-57.json`.
Resultado: **413 pruebas aprobadas**, audio real silenciado, PCM y sintaxis Lua
aprobados. Los escenarios del norte y de mitad de las vigas terminaron en la
consola oeste, posición `(614, 592.9375)`, con contraseña y plataforma activadas.
Se comprobó la cancelación en el motor y estabilidad posterior durante 120 fotogramas.
El audio del ensayo está silenciado. Falta valoración personal con NVDA.

## Activación y reversión

Se carga al iniciar el lector o con `recargar-lector.cmd`. No se ejecuta la
ayuda en la partida habitual durante las pruebas. No se cambia su posición.

Para retirar esta entrega, quita la integración de `challengeAssist` del lector,
los módulos `challenge-assist.lua` y `arris-rat-challenge.lua` y el silencio
`quietChase` de `room-reader.lua`; devuelve el atajo del diagnóstico si se desea.
Conserva los perfiles, sonidos, guardado, nota, rata y consola de Arris de las
entregas anteriores. No restaures todos los archivos de una entrega antigua.
