# 76. Avisos de dónde aterrizar con el dáctil

El lector comprueba el aterrizaje mientras vuelas en el mapa exterior de
Prehistoria. Al detenerte, dice «Puedes aterrizar aquí. Pulsa A» o «No puedes
aterrizar aquí». Al completar el aterrizaje, anuncia «Has aterrizado».

## Uso

1. Vuela con la cruceta y suéltala donde quieras comprobar el terreno.
2. Escucha el aviso. También puedes consultar con Control+F5; Control+F6 y
   Control+F7 incluyen el mismo estado junto a la orientación del destino.
3. Cuando diga que puedes aterrizar, pulsa A del juego.

Los avisos automáticos solo se repiten cuando cambia la posibilidad de
aterrizar, tras seis muestras estables. Si el dáctil sigue moviéndose o no
hay una muestra actual de su tarea, la consulta pide detenerlo: no reutiliza
un permiso de una posición anterior. El lector informa; nunca pulsa A.

## Comprobación nativa

Se verificó el botón A en la ROM local compatible: C24DDF prueba el bit 0080
del mando y salta a la secuencia de aterrizaje C24E20.

`world-reader.lua` observa C24DCF para obtener el registro de la tarea
activa mediante el puntero 7E004E. `world-model.lua` exige una tarea dáctil
4CC5, fase 3 y coordenadas coincidentes con la posición actual del vehículo.
De ese modo no confunde una tarea de otro objeto ni una muestra de movimiento
con una comprobación actual de aterrizaje.

La predicción reproduce las restricciones nativas:

- C24E20 combina las palabras de la tarea +22, +24 y +2E y prueba 0707:
  cuatro muestras del terreno y el dato adicional de obstrucción.
- C248E8 rechaza el solapamiento con la nave Epoch si está presente en
  este mismo mapa. Las dimensiones se leen de C24946/C2494E.
- C24E4F/C6E74E excluyen el rectángulo de coordenadas de media casilla
  x=[0,14), y=[0,52). La comprobación respeta sus límites abiertos.

El lector verifica las firmas de las instrucciones observadas. No modifica
ROM, memoria del juego ni botones para averiguar si se puede aterrizar.

## Evidencia y límites

`test/capture-dactyl76.py` ejecutó el ciclo completo en la copia administrada,
aislada y silenciada: abordaje con A en X560/Y632, aviso positivo y consulta,
quietud sin repetición, vuelo a X680/Y632, aviso negativo y consulta, intento
A rechazado, regreso al oeste y aterrizaje nativo con A. La salida del
lector incluyó «Has aterrizado» y el estado volvió a caminar.

Recibo: `test/future-check/dactyl76-live-validation.txt`. Se conservan sus
capturas RAM y de pantalla `dactyl76-live-*`, además de la traza de puertas
de decisión `dactyl76-native-trace.txt`. El juego habitual permaneció abierto
y no se usó para las pruebas.

`test/test_dactyl76.py` cubre nueve casos, incluidos datos nativos, las seis
muestras de obstrucción, límites de la zona restringida, presencia y límites
de la nave, tareas inválidas, consultas, menús, cadencia y anuncio final.
Los casos de la nave y el rectángulo restringido son pruebas sintéticas de
las fórmulas leídas de la ROM; el recorrido nativo comprobado fue junto a Ioka.

Validación reproducible:
`python tools/chrono-access/test/validate-dactyl76.py`.
El recibo completo queda en `test/future-check/unit-validation-76.txt`.
Resultado: nueve pruebas nuevas aprobadas; suite de 526 pruebas, 518
aprobadas y los mismos ocho fallos previos de `test_walk_trace.py`.
Sintaxis Lua y ciclo nativo aprobados. La ROM y SRAM conservaron sus hashes.
El guardado habitual `.000` cambió durante la sesión con el emulador normal
PID 4980 abierto; se conservó su versión actual. No se atribuye su cambio
al ensayo ni se restaura el hash anterior. La configuración archivada de
las pruebas confirma que savestates y SRAM apuntaban a `test/future-check/Saves`.
`validate-dactyl76.py --audit-only` conserva el recibo original y añade esta
auditoría, sin repetir la suite ni modificar el guardado.
No se añade sonido nuevo: los avisos usan la voz habitual del lector.
Pendiente la valoración del usuario con NVDA y control Nintendo.

Al terminar se ejecutó `recargar-lector.ps1` sobre el emulador habitual:
«Lector recargado. La partida sigue abierta en su posición actual».
`lector.log` confirmó salida de voz NVDA y recarga en el mapa 430, durante
un combate que continuó después de la recarga. No se cargaron partidas.

## Archivos y reversión

Esta unidad modifica `world-model.lua` y `world-reader.lua`, añade las pruebas
y los guiones 76, y actualiza los enlaces de continuación. El respaldo está
en `test/future-check/dactyl76-before`. Para retirar únicamente esta mejora,
restaurar esos dos Lua desde ese respaldo: se conserva la orientación de
vuelo y los mapas de 12000 a. C. de la entrega 75.

Los hashes antes y después están en `protected-hashes-76-before.json` y
`protected-hashes-76.json`. No restaurar ni sobrescribir partidas al revertir
el código. Los límites de cobertura de la era de 12000 a. C. siguen en
[la entrega 75](75-era-12000-y-vuelo-dactil.md).
