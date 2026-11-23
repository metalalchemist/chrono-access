# Interruptores de la prisión con sonido y estado

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

Los once interruptores de las celdas y corredores tienen referencias con el
sonido de letrero (`sign.wav`, la muestra ya preparada para el lector).
Control+F6 los selecciona y Control+F5 consulta su dirección, distancia y estado:
«Interruptor 4, pulsado» o «Interruptor 4, sin pulsar».

El sonido de proximidad se conserva en ambos estados. Al cambiar un interruptor,
el lector anuncia el estado nuevo una vez, cuando vuelve el control de campo.
No interrumpe diálogos o escenas, ni anuncia todos los estados al entrar.
Para accionarlos se usa el botón de aceptar configurado en el juego.

## Datos y pruebas

Las posiciones y los indicadores de estado proceden de los guiones nativos
capturados en `test/prison-check/room71-ram.bin` y `room72-ram.bin`.
Se comprobaron las instrucciones de poner y quitar cada bit; el lector solo
las observa y no escribe ninguno de esos indicadores.

| Referencia | Mapa y actor | Dirección y máscara del estado |
| --- | --- | --- |
| Interruptor 1 | 71, actor 10 | `7F019B`, `08` |
| Interruptores 2–8 | 71, actores 12–24 | `7F0192`, `02/04/08/10/20/40/80` |
| Interruptor 9 | 71, actor 26 | `7F0192`, `01` |
| Interruptor 10 | 72, actor 10 | `7F0191`, `40` |
| Interruptor 11 | 72, actor 12 | `7F0191`, `80` |

Se accionó un interruptor con el motor real en la copia aislada. Los archivos
`switch-action-ram.bin` y `switch-confirm-ram.bin` muestran el cambio de `10` a
`18` en `7F0192`, correspondiente al interruptor 4. Se usó B, el botón de aceptar
que conserva la configuración copiada de esa partida. Los guiones de prueba
reposicionan al personaje y solo deben usarse en la copia aislada.

`test/test_prison_switches.py` comprueba los once guiones, sus coordenadas y
máscaras, ambos estados, ocultación, conservación del sonido, anuncio único,
espera durante diálogos y regreso a otra zona sin avisos antiguos. Los cambios
simulados de estado y audio se distinguen de la única operación nativa anterior.
El registro general está en `test/prison-switch-check/unit-validation.txt`:
**365 pruebas aprobadas**.
Falta valoración auditiva con NVDA y accionar físicamente los otros diez.

## Archivos y activación

`room-model.lua` añade el estado a la referencia. `room-reader.lua` observa sus
cambios. `test/build-prison-profiles.py` conserva las once definiciones y genera
el bloque correspondiente de `room-profiles.lua`. La ampliación de prisión tiene
ahora 78 referencias, conservando sus veinte zonas y once cofres.

Para revertir esta entrega, retirar esas once definiciones y regenerar los
perfiles, además de quitar la observación de `switchPressed` del modelo y lector.
La puerta inicial, cofres y demás referencias de la entrega 49 se conservan.

La copia de pruebas quedó cerrada. No se recargó ni reinició la partida habitual.
Se cargará al próximo inicio del lector; `recargar-lector.cmd` permite actualizar
una partida abierta conservando su posición.
