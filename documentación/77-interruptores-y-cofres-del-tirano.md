# 77. Interruptores con estado y cofres corregidos en la Guarida del Tirano

Se añade el interruptor que faltaba en el salón de entrada. Los doce
mecanismos de la guarida anuncian «pulsado» o «no pulsado». La auditoría
corrige también los cofres de la escalera superior y la sala de interruptores:
hay doce cofres entre el Nido Dáctil y la guarida, además de dos guardados.

## Para jugar

Control+F6 selecciona referencias; Control+F5 consulta su estado y dirección.
El salón de entrada incluye ahora «Interruptor de las escaleras del salón de
entrada; libera enemigos». Acércate y pulsa A para accionarlo. Las referencias
de mecanismos usan la muestra `sign`, también usada por los interruptores de
la prisión, sin la atenuación de proximidad de los muebles.

Después de una activación, el lector anuncia el cambio al recuperar el control.
No lo repite cada fotograma. Los dos interruptores reversibles de la sala
de interruptores también anuncian «no pulsado» al desactivarlos.
El mecanismo de caída de los corredores cambia de sala: su estado queda
consultable al volver, sin prometer un anuncio antes de terminar la caída.

Los cofres indican «cerrado» o «abierto», sin revelar contenido. Un cofre
abierto conserva su referencia y pierde su señal sonora. Los puntos de
guardado solo aparecen en las referencias cuando están dibujados; guardar
sigue requiriendo el menú del juego. No se etiqueta un guardado como pulsado.

## Omisiones y causa

El perfil 74 solo enumeraba mecanismos en 302 y 303. Omitía el actor 32
del mapa 430, cuya interacción mueve las escaleras y libera los enemigos.
Se añadió su posición nativa (20,41), su estado y una indicación al entrar.
Los otros once mecanismos tenían coordenadas, pero no un indicador `switch`;
por eso no anunciaban el estado ni sus cambios. Se usa el soporte ya existente
del modelo y lector de habitaciones, sin inferir pulsaciones del mando.

Dos aparentes cofres en (0,0) eran registros de redirección. La rutina nativa
C0A75D/C0A763 trata una palabra de coordenadas cero como un enlace a la lista
de otro mapa. El generador anterior la trataba como un cofre real.

| Mapa de juego | Lista de tesoros real | Referencias corregidas |
| --- | --- | --- |
| 300, escalera superior | 297 | Dos cofres en (44,8) y (54,8) |
| 303, sala de interruptores | 110 | Un cofre en (13,7) |

Se mantienen las direcciones reales de esos registros para consultar los
bits de abierto del juego. No se reutilizan los bits de los enlaces.
Los demás cofres y los dos guardados de los mapas cubiertos ya estaban
registrados. La revisión cubre los doce mapas de la entrega 74.

## Estados verificados

| Mapa y actor | Dato del juego |
| --- | --- |
| 430, 32: escaleras | 7F0063, máscara 08 |
| 302, 34 y 36: pasos oriental y occidental | 7F0063, máscaras 10 y 20 |
| 302, 38: caída | 7F0064, máscara 01 |
| 303, 18: aparece el guardado | 7F0212, máscara 01 |
| 303, 20: paso occidental | 7F0210, máscara 01 |
| 303, 22 y 24: suelo suroeste y sureste | 7F0214 y 7F0216, máscara 01 |
| 303, 26 y 32: mecanismos orientales | 7F0218 y 7F021A, máscara 01 |
| 303, 34 y 36: reversibles del norte | 7F00ED, máscaras 40 y 80 |

Las seis marcas 7F02xx son memoria local del motor, escrita por el comando
75 (C06CBD: dirección 7F0200+2*operando, valor 1). Las otras provienen de los
comandos nativos de bits. Se informa el estado actual que conserva el juego,
sin mantener un historial propio de botones pulsados.

## Pruebas y evidencia

`test/capture-tyrano77.py` activó los doce mecanismos con A en la copia
administrada y silenciada. Los dos reversibles se pulsaron por segunda vez
y sus bits volvieron a cero. Se conservaron capturas antes y después.
El cambio del suelo suroeste tarda más de cien fotogramas: la primera captura
fue anterior a su marca final; se repitió con margen de trescientos.

`test/capture-tyrano77-extra.py` abrió los tres cofres redirigidos y comprobó
sus bits nativos. Para los de 300 se preparó el estado posterior al combate
del sector; no se certifica ese combate. Otra secuencia activó el guardado
de 303 y lo ocultó después mediante el interruptor sureste. Las posiciones y
la historia se prepararon en la copia de pruebas; no fue un recorrido natural.

Siete pruebas nuevas en `test/test_tyrano77.py` cubren estados, cambios,
inventario, redirecciones, cuadrícula nativa y reproducción de esas capturas.
Se actualizaron las siete regresiones 74 para comprobar los doce cofres reales
y los indicadores de interruptor. Se mantuvieron las cuatro de la prisión.
La mezcla nativa silenciada comprueba también las muestras de señal y guardado.
Resultado final: 533 pruebas; 525 aprobadas y los mismos ocho fallos previos
de `test_walk_trace.py`. Pruebas específicas, sintaxis Lua y mezclador aprobados.
La ROM, SRAM y demás archivos protegidos conservaron sus hashes; la diferencia
del `.000` se describe abajo.

Validación:
`python tools/chrono-access/test/validate-tyrano77.py --preserve-updated-snapshot`.
Recibo: `test/future-check/unit-validation-77.txt`. El primer recibo con dos
errores de sintaxis en las pruebas nuevas se conserva como
`unit-validation-77-initial.txt`; se corrigieron y repitieron las pruebas.

Evidencias: `tyrano77-native-validation.txt`, `tyrano77-extra-validation.txt`,
`tyrano77-interaction-audit.txt`, capturas `tyrano77-*` y `audio77-replay.txt`.
Pendiente valoración del usuario con NVDA/control Nintendo.

## Protección y reversión

Solo se operó la copia de pruebas; no se probaron botones en la partida
habitual. Esta estaba abierta al empezar (PID 4980) y ya no estaba abierta
al terminar las pruebas. El archivo habitual `.000` se actualizó a las
12:04:57; se conserva su versión actual. Los hashes antes y después registran
el cambio sin atribuir su autor. La configuración archivada de las pruebas
redirige savestates y SRAM a `test/future-check/Saves`. El argumento de
validación conserva y declara esa diferencia; no restaura guardados.

Respaldo: `test/future-check/tyrano77-before`. Para retirar esta unidad,
restaurar `rooms/model.lua`, `rooms/profiles/dactil-tirano.lua` y
`test/build-tyrano74.py`, junto con las expectativas previas de la prueba 74.
`rooms/reader.lua` no necesitó cambios: su soporte de estados ya existía.
Se conservan las entregas 75 y 76. No restaurar ROM ni partidas.
