# Punto de guardado de Arris

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

Se corrigió una omisión de la entrega 55: el punto de guardado de la sala de
habitantes de Arris estaba clasificado como persona. Ahora tiene referencia
propia y sonido `save_point`, con distancia, dirección y consulta mediante
Control+F5 y Control+F6. Está al oeste de la escotilla al subsuelo.

La captura nativa `test/future-check/map-214-ram.bin` identifica el actor 16,
inicializador `82 79`, en X=616, Y=159.9375. Se excluye ese actor de las personas
y se enlaza la referencia a su presencia: si está oculto o inactivo, no suena.
Se usa la muestra original de guardado ya preparada; no se cambian sonidos ni DLL.

La revisión de los inicializadores de los nueve mapas de la entrega 55 encontró
este único actor con el gráfico nativo de guardado. Arris pasa de 48 a **49
referencias**. El generador `test/build-arris-profiles.py` conserva la corrección.

Validación: **nueve pruebas de Arris aprobadas**, incluida la comprobación del
gráfico nativo, referencia única, ausencia de persona duplicada y retirada al
ocultarlo. `test/verify-arris-audio.py` pasó con el mezclador real silenciado,
diez tipos de señal incluido guardado y muestras PCM no vacías. Son pruebas
sobre capturas y reproducción offline; no se abrió el emulador ni se guardó
una partida desde ese punto. Falta valoración auditiva del usuario con NVDA.

Se carga al iniciar el lector o con `recargar-lector.cmd`. Para retirar únicamente
esta corrección, elimina la referencia de guardado, la exclusión de persona 16
y la frase de orientación de Arris en el generador y vuelve a ejecutarlo.

## Ajuste posterior del acceso a las vigas

Por petición del usuario se unificaron la escalera noroeste del mapa 216 y el
paso contiguo al mapa 221. Ahora hay una sola referencia «Escalera hacia la rata
y el Guardián», con sonido de escalera y zona que abarca el tramo y la transición
nativa. Arris queda en 48 referencias. Las nueve pruebas de Arris y la reproducción
de audio real silenciada pasan después del ajuste.
