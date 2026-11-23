# Menú de Configuración accesible

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

El apartado **Configuración** del menú de campo anuncia la opción seleccionada,
su valor y los cambios reales. Incluye las diez opciones principales y los
submenús de velocidad, color de ventana, tipo de panel y asignación de botones.
El módulo nuevo, `config-reader.lua`, observa las tareas del menú y no escribe
memoria, ajustes ni entradas del control.

## Para usarlo

Abre el menú con el botón habitual y selecciona Configuración, entre Técnicas
y Grupo. Los iconos del menú principal se recorren horizontalmente.
Dentro de Configuración, arriba/abajo recorre las cinco filas de la columna;
izquierda/derecha cambia de columna cuando no estás editando un valor.
Confirma para cambiar una opción o entrar en su edición. Cancelar devuelve
al nivel anterior; puede ser necesario cancelar primero la edición y después
salir de Configuración. Se conservan los controles del propio juego.

| Opción | Lo que se anuncia |
| --- | --- |
| Estéreo | Sí / No |
| Modo de batalla | Activo / Lento |
| Guardar cursor del menú | Sí / No |
| Guardar cursor de batalla | Sí / No |
| Guardar cursor de ítems | Sí / No |
| Velocidad de batalla | Valor actual de batalla y mensajes; confirmar abre la edición |
| Color de la ventana | Estilo 1–8; confirmar permite cambiarlo con izquierda/derecha |
| Tipo de panel | Sin panel, Tipo 1 o Tipo 2 |
| Pad de control | Normal / Personalizado; edición de las seis acciones |
| Información de ítems | Sí / No |

Al editar velocidades, arriba/abajo elige batalla o mensajes y
izquierda/derecha cambia el valor de 1 a 8: 1 es más rápido y 8 más lento.
El color de ventana se identifica por el número de estilo que muestra el
juego, sin inventar nombres de colores.

La asignación de botones anuncia **Aceptar, Cancelar, Menú, Correr, Mapa y
Cambiar**, junto a su botón actual. En esa edición, arriba/abajo cambia de
acción e izquierda/derecha recorre los botones. Si el valor provisional
que muestra el juego difiere del valor confirmado, añade «Cambio en edición».
Al navegar o salir, el juego aplica sus propias reglas de confirmación y
cancelación; el lector no sustituye esas reglas ni confirma por el usuario.

El lector habla al cambiar de selección o valor. No repite cada fotograma
una opción inmóvil ni sigue leyendo Configuración desde otro menú. La voz
de una selección nueva interrumpe la anterior para no acumular valores
antiguos al mantener una dirección.

## Implementación contrastada

`lector-snes9x.lua` inicializa `config-reader.lua` y lo llama dentro del callback
por fotograma que ya existe. No se añade otro callback de juego habitual.
Se reutilizan la salida de voz, el arranque y el menú principal existente.
La lectura específica del interior de Configuración es nueva; no se trata
de diálogo de campo y no utiliza el lector de conversaciones para inferirla.

Los observadores verifican las firmas de C2:BFFD (opciones y velocidades),
C2:BF6D (botones) y C2:BF9F (panel) antes de instalar los hooks. Una firma
incompatible desactiva solo este módulo. Las etiquetas se contrastaron con
la pantalla de la ROM de Magno soportada y los handlers de la ROM local.

La fila actual está en 7E:0417 y el cursor en 7E:0054. Los valores están en
7E:0D86–0D90. La tabla de correspondencias C2:C4F9 relaciona las diez opciones
con esos bytes; las velocidades son 0D8B/0D90 y el estilo de ventana es 0D8C.
El panel usa 0D8A. Durante la edición de botones el cursor ocupa 15–20 y
los valores provisionales están en 0F00–0F05; se comparan con 0408–040D.
Los botones reconocidos son A, B, X, Y, L, R, Select y Start.

7E:0068 es memoria temporal de la tarea: en el hook contiene su estado pero
otra tarea lo sobrescribe antes de terminar el fotograma. El primer ensayo
no distinguía los submenús al consultar ese byte al final. La implementación
aceptada utiliza las zonas disjuntas del cursor: 12–14 para panel, 15–20 para
botones y filas 10/11 para las velocidades. Solo interpreta esos datos en
fotogramas donde ha observado una rutina nativa de Configuración.

## Evidencia y pruebas

`test/config-check/` conserva RAM, capturas GD/PNG y `reader-validation.txt`.
`rows.png` reúne las etiquetas nativas de las diez opciones. Herramientas:
`start-config.lua`, `check-config.lua`, `drive-config.py`, `refresh-config.lua`,
`survey-config-rows.py`, `survey-config-right.py` e `inspect-config.py`.
Son guiones de investigación que inyectan botones exclusivamente en la copia
silenciada del gestor de pruebas, iniciada sin cargar las partidas del usuario.

Se comprobaron en el motor:

- Entrada desde el menú principal; diez opciones y sus valores iniciales.
- `speed-edit`, `speed-slower`, `speed-messages`, `messages-change`:
  dos velocidades separadas y cambios de 5 a 6.
- `window-edit`/`window-change`: estilo de ventana 1 → 2.
- `panel-edit`/`panel-change`: panel Tipo 1 → Tipo 2.
- `buttons-edit`, `buttons-change`, `buttons-next`, `reader-submenu-refresh`,
  `buttons-row2-change`, `buttons-row3`, `buttons-run`, `buttons-map` y
  `buttons-change-character`: las seis acciones, intercambio nativo de
  botones por conflicto y distinción de la asignación en edición.
- `battle-cursor-toggle`, `menu-cursor-toggle`, `battle-mode-toggle`,
  `stereo-toggle`, `cursor-items-toggle`, `item-information-toggle`:
  cambios reales de las opciones binarias y del modo de batalla.
- `config-close`, `menu-close`, `reopen-config`: salida sin anuncios residuales
  y reapertura con el valor conservado «Información de ítems. No».

Los primeros intentos de abrir el menú pulsando abajo no seleccionaron
Configuración: el menú principal es horizontal. Se conservaron como intentos,
no se presentan como accesos exitosos. El ensayo aceptado entra con derecha.
La recarga intermedia del guion añadió el lector en ejecución; la versión
final está integrada en el punto de entrada habitual.

`test_config.py` contiene diez pruebas: todas las filas y valores nativos,
velocidades, estilos, panel, seis acciones, valores provisionales, toggles,
reapertura, silencio/deduplicación, límites numéricos, firma incompatible y
ausencia de escrituras o entradas del lector. Las variantes numéricas
1–8 y «Sin panel» también se prueban de forma sintética; no se afirma haber
recorrido todas ellas en el emulador. El registro de la suite general está
en `test/config-check/tests.txt`.

Falta la valoración del usuario con NVDA. La captura del texto y la copia
silenciada no sustituyen su escucha. No se probó la persistencia de ajustes
a través de guardar/cargar o reiniciar el juego; sí cerrar y reabrir el menú
en la misma sesión.

## Activación, protección y reversión

El próximo arranque normal con `iniciar-lector.cmd` carga el módulo. Si el
usuario ya está jugando, `recargar-lector.cmd` actualiza el lector sin mover
su personaje ni cargar otra partida. No se cambiaron sus asignaciones de
botones, configuración, ROM o guardados. La instancia silenciada se cerró
con el gestor antes de ejecutar la suite general.

La unidad de reversión es retirar la inicialización y llamada a `tickConfig`
en `lector-snes9x.lua`, junto con `config-reader.lua`, sus pruebas y este
documento. El resto de lectores sigue independiente. No se hicieron commits;
`tools/` continúa ignorado por Git y se conservan las evidencias.

Validación final: **10 pruebas nuevas aprobadas**. La suite completa ejecutó
**301 pruebas: 300 aprobadas y 1 error por evidencia ausente**. No hay fallos
de aserción en la ejecución final. El error previo de `test_control_hotkeys`
se debe a que no existe
`diagnosticos/controles-inicio-20261029-111044-158-8ebd27/snes9x-antes.conf`.
No se recreó esa evidencia de otra entrega. La primera ejecución de la suite
se conserva en `tests-first-run.txt`; la final, en `tests.txt`.
