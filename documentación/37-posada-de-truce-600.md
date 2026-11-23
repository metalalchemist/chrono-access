# Posada de Truce de 600 d. C.

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

La posada de 600 tiene orientación en su salón (116) y dormitorio (117),
lectura de diálogos/opciones y aviso de descanso verificado. Se reutilizan
los lectores y sonidos de la entrega 30 con perfiles propios de esta época.
Hay un **arcón sellado junto a la cama este**; no hay cofres ordinarios en
la tabla F5 de estos dos mapas.

## Para jugar

Desde el exterior selecciona Posada Truce con Control+F6. Control+F5 consulta
el destino y Control+F7 calcula la ruta. Dentro, Control+F5 consulta una
referencia y Control+F6 avanza a la siguiente. Las distancias son directas.

En el salón, la salida está al sur y la recepción del alojamiento al oeste.
Habla con el posadero mirando al norte. Ofrece «Serán 10 G. ¿Te quedas?»;
empieza en «Sí». Abajo elige «No» y arriba vuelve a «Sí». Confirma con A.
Al dormir cobra 10 G y devuelve el control en el dormitorio, con vida y
magia recuperadas. El lector anuncia ese resultado después de comprobarlo.

Para subir caminando, busca el **pie de la escalera al noroeste** y avanza
al este. La escalera es diagonal: el motor lleva a Crono al dormitorio.
Para bajar, alcanza la parte suroeste del dormitorio y avanza al oeste.
En el dormitorio hay tres camas, cómoda, reloj y el arcón junto a la cama
este. Acércate al arcón, mira hacia él y pulsa A. El juego cuenta que la caja
lleva tiempo en la familia y después responde «Sellado por una fuerza
misteriosa…». No se alteran sus requisitos de apertura.

Los clientes y soldados del salón tienen referencias propias; la persona
que recorre la barra mantiene su posición real. Las conversaciones se leen
al hablarles. No se sustituye su diálogo por una explicación de la trama,
ni se da por probado haber agotado todas sus conversaciones.

## Datos contrastados

| Zona | Mapa y límites | Datos |
| --- | --- | --- |
| Salón | 116, `[64,304,480,496]` | Salida, escalera, recepción, barra, cocina, chimenea, estantería y sillas |
| Dormitorio | 117, `[544,48,736,224]` | Escalera, tres camas, arcón, cómoda y reloj |

La salida E5:0911 ocupa `[208,480,240,496]` y lleva al exterior 497.
E5:0918, `[128,320,144,352]`, comunica el salón con 117. El pie de la
escalera está en `[80,368,96,384]`; la marcha real desde X=88/Y=375,9375,
avanzando al este, llega al dormitorio. E5:091F, `[624,192,640,224]`, devuelve
a 116. Se comprobaron ambas direcciones con botones nativos, sin cargar
otra localización durante esos cruces.

La recepción usa el actor 22. El actor 20 superpuesto se excluye para evitar
duplicar la persona. El arcón del dormitorio es el actor 24, X=720/Y=127;
no se anuncia como persona y su señal requiere que siga visible. No se copia
el actor 34 ni las coordenadas de la posada de 1000.

La oferta de 600 tiene selector nativo `0162=2`, `0164=2`, `0165=3`, distinto
del de 1000. `inn-reader.lua` configura por separado oferta y dormitorio
para cada posada. Conserva el pago durante la recarga nativa al dormir,
exige recuperación completa y control devuelto, y no anuncia al recargar
el lector después de un descanso cuyo pago no observó.

Se corrigió la comprobación de vida máxima: `+3F` es una caché calculada por
el menú y en esta sesión de campo vale FFFF. La rutina de dormir devuelve
la vida máxima persistente de `+5`; el observador usa ahora ese valor.
Las diez pruebas anteriores de la posada de 1000 siguen pasando.

## Evidencias y pruebas

`test/truce-inn600-check/` conserva las capturas RAM/GD, imágenes y
`reader-validation.txt`. Las herramientas `start-inn600.lua`,
`survey-inn600.lua`, `check-inn600.lua`, `drive-inn600.py` y `warp-inn600.lua`
inyectan entradas y cargas solo en la copia aislada silenciada. No usarlas
en la partida habitual.

- `116`/`117`: capturas de ambos interiores y sus actores.
- `sealed-chest-message`/`sealed-chest-complete`: mensaje familiar y sello.
- `keeper-offer`: oferta inicial; `walking-offer` alcanza la recepción
  caminando desde la entrada sur.
- `final-walk-offer` → bloque `final-walk-sleep` → `stairs-return`:
  400 → 390 G, vida 1 → 70, magia 0 → 8 y un único aviso de descanso después
  de la entrada al dormitorio. El último archivo se capturó al terminar el
  descenso; no existe una captura `final-walk-sleep`, porque la orden de
  capturar se sustituyó al comenzar el regreso. Su registro sí conserva
  el pago, el retorno al dormitorio y el aviso. No presentar ese nombre
  de orden como un archivo de captura.
- `stairs-return`, `stairs-climb`, `stairs-return-again`: cruces reales
  117 → 116 → 117 → 116.
- `decline-offer-retry`/`decline-confirmed`: «No», conserva 400 G.
- `insufficient-offer`/`insufficient-result`: «¡No tienes dinero!», conserva
  5 G, vida 1 y magia 0.

Los primeros intentos de acercamiento por reubicación no siempre abrieron
la oferta; no se presentan como descansos exitosos. Un guion auxiliar de
recarga se detuvo por BOM UTF-8 y se corrigió antes del ensayo aceptado.
Se usaron dos observadores durante la comprobación final para comparar
la corrección de vida máxima; el registro duplica las líneas de diagnóstico
de oferta/pago, pero solo uno anuncia el descanso. El juego habitual
inicializa un único observador.

`test_inn600.py` contiene nueve pruebas: perfiles/personas/visibilidad,
conexiones y ausencia de cofres ordinarios en ROM, consultas y silencio,
texto nativo, descanso real, cancelación, falta de dinero, escaleras y
condiciones del observador. Los cambios sintéticos del observador se
identifican por separado de las capturas del motor. La suite completa
queda en `test/truce-inn600-check/tests.txt`.

Falta la valoración del usuario con NVDA y la escucha de las señales.
No se afirma una ruta continua desde el cañón ni haber probado todos los
clientes, sus cambios por progreso o las interacciones decorativas.

## Activación y reversión

Abrir normalmente con `iniciar-lector.cmd` carga estos cambios. Si el juego
ya está abierto, `recargar-lector.cmd` actualiza el lector conservando la
partida. Solo se operó la copia de pruebas; se cerró con su gestor antes de
la suite. Se conservan ROM, partidas y configuraciones habituales.

La unidad de reversión son los perfiles `truce_inn600_*`, la entrada 116 de
la configuración de `inn-reader.lua` y sus pruebas/documentación. La
corrección del máximo de vida puede conservarse de manera independiente.
Los perfiles originales de 1000 y el resto de lectores no se sustituyen.
No se hicieron commits; `tools/` continúa ignorado por Git.

Validación final: las **19 pruebas de ambas posadas** pasan (9 de 600 y 10 de 1000).
La suite general ejecutó 291 pruebas: **290 aprobadas y 1 error por evidencia ausente**.
El error corresponde a `test_control_hotkeys`: falta el archivo previo
`diagnosticos/controles-inicio-20261029-111044-158-8ebd27/snes9x-antes.conf`.
No se recreó ni sustituyó esa evidencia de otro trabajo para ocultar el error.
