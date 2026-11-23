# 35. Atajos que cambiaban el mando al caminar

El registro real mostró V como A y después `left`, sin D, antes de abrir Equipo.
La configuración tenía ocho atajos sin modificadores asignados a las flechas.
Arriba ejecutaba `SwitchControllers` y `JoypadSwap`: cambiaba el periférico y
permutaba los mandos. En modo ratón, `left` significa botón izquierdo; V lo
activa. Esto explica que dejara de caminar y la acción terminara en el menú.
La implementación nativa de Snes9x confirma esas correspondencias.

Se retiraron ocho atajos conflictivos, conservando las doce asignaciones del
juego. `preparar-controles.ps1` corrige la configuración con el emulador cerrado;
`iniciar-lector.ps1` lo ejecuta antes de arrancar. Conserva una copia antes y
después. No reescribe un archivo usado por un emulador abierto.

Para una sesión abierta, `reparar-controles.ps1 -Apply` utiliza el diálogo nativo
de atajos y selecciona el mando SNES. El archivo se guarda al salir normalmente
del emulador; no afirmar que cambia en disco inmediatamente. Nunca carga una
partida. La aplicación a la sesión del usuario se rechazó porque ya estaba
cerrada; después se corrigió su configuración en disco. Se activa al arrancar.

## Evidencia y comprobación

- `diagnosticos/controles-inicio-20261029-111044-158-8ebd27/`: configuración real,
  respaldo y ocho cambios. Flechas, V y demás botones del juego conservados.
- `test/keyboard-fix-check/native-validation.json`: en el emulador compartido,
  arriba reproduce el cambio de periférico antes de reparar. Después, las
  cuatro flechas y V conservan el mando SNES. Al cerrar, los ocho atajos quedan
  guardados como `Unassigned`.
- `test_control_hotkeys.py`: conserva asignaciones del juego, retira ocho
  conflictos y verifica que una segunda ejecución no reescribe el archivo.
- `test/keyboard-fix-check/suite-validation.txt`: resultado de la suite.

Falta confirmar el resultado con la caminata habitual del usuario. El registro
continúa disponible con Control+F2. La orientación del cañón de la entrega 34
se mantiene disponible para su valoración con NVDA.
