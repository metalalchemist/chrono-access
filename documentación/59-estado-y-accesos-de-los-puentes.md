# 59. Estado y acceso a los puentes de la alcantarilla

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

Los dos interruptores de la alcantarilla indican **pulsado** o **sin pulsar** al
consultarlos. Cuando cambia su estado, el lector lo anuncia una vez. Los accesos
a los puentes tienen sonido de conexión y explican si el paso está abierto o
cerrado. La salida al exterior conserva su referencia independiente.

## Cómo orientarte

Usa Control+F6 para elegir referencia y Control+F5 para consultarla de nuevo.
Después de pulsar el interruptor del sur, busca **Acceso este al puente del sur;
cruza al oeste**: queda al suroeste del interruptor. Hay una referencia para cada
extremo, con la dirección de cruce. Cuando están cerrados, sus nombres indican
que debes pulsar el interruptor de los puentes del sur.

Ese interruptor abre **los dos puentes a la vez**; otra pulsación los cierra.
El interruptor del paso central abre una puerta distinta, al noreste de él.
Se añadió **Puerta del paso central; no es la salida al exterior**, también con
estado abierto/cerrado. Este interruptor central se activa una sola vez durante
la visita; no alterna como el del sur.

## Evidencia y alcance

Se verificaron los eventos y las colisiones del motor en `future-check`:

| Referencia | Estado y posición comprobados |
| --- | --- |
| Interruptor central | Bit 1 de `$7F0216`, variable local del mapa; `bridge59-central-native-ram.bin`. |
| Interruptor del sur | Máscara 2 de `$7F00EC`; `bridge59-before`, `bridge59-on` y `bridge59-off`, capturas RAM/GD. |
| Puente del sur | Extremos X=328 y X=376, Y=616. `bridge59-walk1-ram.bin` conserva el cruce nativo con botones, de este a oeste. |
| Puente del oeste | Extremos X=120 y X=184, Y=344. Colisiones antes/después comprobadas; no se realizó su cruce completo. |
| Anuncio al pulsar | `bridge59-reader-on/off-ram.bin`; anuncios en `reader-validation.txt`. |

La preparación de las pruebas carga el mapa o coloca al grupo exclusivamente en
la copia aislada. Las activaciones y el cruce del puente del sur usan botones y
eventos nativos. No se operó la instancia habitual del usuario.

`room-model.lua` permite leer estado en una referencia mediante `state`, con
textos abierto/cerrado. Solo las referencias `switch` generan anuncios al cambiar;
los cuatro extremos no producen cuatro avisos adicionales. Los perfiles anteriores
conservan el comportamiento y los textos de sus interruptores.

`test/build-lab32-sewer.py` conserva estos datos al reconstruir perfiles: son
32 referencias en los cinco mapas de la entrega 58. Se añadieron tres pruebas
sobre capturas nativas: estados y colisiones, interruptor central y anuncio único.
Pasaron **423 pruebas**, la sintaxis Lua y el mezclador real silenciado.
La validación general se conserva en `test/future-check/unit-validation-59.txt`
y los hashes durante esa validación en `protected-hashes-59.json`.

```powershell
python tools/chrono-access/test/validate-lab32-delivery.py 59
```

Para jugar con los cambios, abrir normalmente o ejecutar `recargar-lector.cmd`
si el juego ya estaba abierto. Editar Lua no actualiza el lector cargado.

Para retirar esta ampliación, elimina de la planta principal los cuatro accesos
a puentes y la puerta central; retira `switch` de sus dos interruptores y
`hasSwitches` del perfil. Haz lo mismo en el generador. En `room-model.lua`,
restaura la lectura anterior de `f.switch` si también quieres retirar el soporte
de `state`. No se cambiaron sonidos, DLL ni otros lectores.
