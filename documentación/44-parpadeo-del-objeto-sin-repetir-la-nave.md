# Parpadeo del objeto sin repetir el aviso de la nave

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

El objeto brillante de la catedral mantiene su referencia y sonido durante
el parpadeo. Caminar no vuelve a anunciar «Estás en la nave». Se conserva una
señal al aparecer y la señal local para acercarse; al recogerlo desaparecen.

## Causa comprobada

La entrega 43 usaba el estado de dibujo `$7E1A81+28` como señal de presencia.
El juego lo alterna para animar el brillo. Eso cambiaba la guía entre sus dos
textos, y `room-reader.lua` anunciaba de nuevo toda la sala con cada cambio.
`test/cathedral-object-check/repeated-room-before-fix.log` conserva la repetición
que notificó el usuario. El test anterior mantenía el dibujo fijo y no cubría
el parpadeo; se corrigió esa falta de cobertura.

Los comandos nativos 0B/0C, en `asm/bank_C0.asm` (`C06269` y `C06282`), desactivan
y activan el procesamiento mediante el bit 7 de `$7E1000+actor`. Las capturas
de la entrega 43 muestran 87 antes de la conversación y 07 tras la aparición.
La recogida cambia el tipo del actor a 80 y lo retira, aunque su procesamiento
permanezca habilitado. Por eso se comprueban ambos datos.

## Corrección y pruebas

El perfil `cathedral_129` declara `processingPresence` únicamente para el actor
28. `room-model.lua` usa su tipo y procesamiento para la guía, referencia y
proximidad. Los demás actores conservan su criterio anterior. No se escribe
en memoria del juego ni se aplican temporizadores para ocultar la repetición.

`test/test_cathedral_object.py` reproduce 120 alternancias del dibujo mientras
se mueve al personaje: exige un único aviso y una única señal inicial. Comprueba
también que el objeto siga localizable y audible durante la fase oscura, y que
retirarlo o desactivar su procesamiento lo oculte incluso con dibujo residual.
Se mantienen las comprobaciones sobre aparición y recogida capturadas en el
motor. **329 pruebas aprobadas**, incluidas cinco del objeto. El registro general está en
`test/cathedral-object-check/blink-validation.txt`.

No se abrió ni manipuló una partida en esta corrección. Las pruebas ejecutan el
lector y el modelo con Lua, capturas nativas y cambios de memoria simulados.
Falta la valoración del usuario con NVDA.

## Activación y reversión

No había un emulador abierto al comprobar los procesos; se cargará al próximo
inicio normal. Para retirar esta corrección, quitar `processingPresence` del
actor 28 y restaurar la comprobación de dibujo anterior en el modelo; eso
reintroduciría la repetición. No requiere cambiar sonidos ni controles.
