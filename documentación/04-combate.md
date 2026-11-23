# Lectura del combate

[Continuar el proyecto](../continuar%20chrono.md) · [Índice documental](README.md)

Las notas siguientes conservan la evidencia y el alcance de cada etapa. Los pendientes de una etapa pueden estar resueltos en documentos posteriores; el estado actual se consulta en el documento de continuación.

Las rutas de código escritas entre comillas invertidas parten de `D:\gt\vemovie`, salvo indicación distinta.

Código y evidencia relacionados:

- [battle-reader.lua](../tools/chrono-access/battle-reader.lua)
- [battle-model.lua](../tools/chrono-access/battle-model.lua)
- [test_battle.py](../tools/chrono-access/test/test_battle.py)

## Última ampliación: combate, 26 de octubre de 2026

El lector principal ya integra `battle-reader.lua` y `battle-model.lua`. Lee
Atacar/Técnicas/Objetos, personaje que elige, vida y magia, nombres de enemigos
numerados, fila de técnica, coste ajustado por participante, cantidad de objetos,
indisponibilidad y selección de objetivos individuales o múltiples. La vida de
enemigos solo se anuncia cuando la permite el visor del propio juego.

La confirmación dice «Acción preparada», no «usada»: el comando puede esperar
su ejecución. Los cambios reales de vida y magia se anuncian por separado.
También se leen enemigos fuera de combate, victoria/derrota, mensajes resueltos
del motor (incluidas recompensas) y vuelta al campo. Se aprovechan los hooks
compartidos de glifos/control mediante dos callbacks opcionales del observador;
no se reemplaza el lector de diálogos de campo.

Prueba completa: `python -m unittest discover -s tools/chrono-access/test -p 'test_*.py'`:
**56 aprobadas**, incluidas 11 nuevas de combate. Comprueban comandos, costes de
varios participantes, registros nativos de objetos, objetivos múltiples dispersos,
visibilidad de vida enemiga, confirmación, cambios reales, mensajes repetidos,
fin de combate, firmas incompatibles y sincronización de filas renderizadas.

Integración real en `test/battle-check/`, con `test/discover-battle.lua` y
`test/check-battle-runtime.lua`: copia independiente y silenciada de Snes9x. Se preparó
un encuentro controlado mediante la entrada nativa de combate, asignando dos
Azulete a objetos de campo existentes e inyectando vida/magia, técnicas y objetos.
**No es un encuentro natural del guion**; las figuras de campo siguen siendo de
PNJ. Sí se ejecutan la IA, selección, consumo, daño y recompensas reales del motor.
No se modificó la partida ni se controló el emulador del usuario.

Evidencia en `runtime-reader.log`: Atacar confirmado; Ciclón, coste 2, ambos
objetivos, magia 99→97, ambos enemigos derrotados, «Victoria», 4 puntos de
experiencia, 24G y «Fin del combate». MiniTónico: cantidad 5, destino Crono,
acción preparada y vida 745→795 después de recibir un ataque. La captura de
RAM `final-item-ram.bin` muestra cantidad 4 en el registro nativo de combate
1580; el inventario de campo 2400/2500 aún no se sincroniza durante la batalla.
No usar ese inventario de campo para anunciar consumo en combate.

Direcciones contrastadas con la ROM y el desensamblado CC0 de
https://github.com/dscotton/ct_disassembly :

- C10000 entrada; C11153 entrada de comandos; 95D5 actor; 95DB ventana;
  95DC+actor comando; 9609 selección de destino. Registros de personajes y
  enemigos: 5E2D+slot*80 hexadecimal; vida +3/+5, magia +7/+9.
- C1103D termina renderizado de fila: capturar ahí técnicas/objetos completos;
  leer cursor y caché en fotogramas distintos causaba costes falsos al abrir.
  Técnica 9EE3, flags 9EE5, costes 9EE6/8/9, participantes 9EE7;
  A02A+actor es cantidad de técnicas (A099 no lo es). Objetos 1580+índice*5.
- Destinos A62D..A637: recorrer los once bytes si es múltiple, aunque haya FF
  intermedios. Nombres de enemigos CC6500+ID*11, técnicas CC15C4 y objetos CC0B5E.
- C11713 observa el comando completo 93EE+actor*7; ID de objeto/técnica en +6.
  C183BB victoria, C1813F derrota, C018AB vuelta al campo. CD0261 inicia
  mensajes; texto resuelto en 7EB400..BFFF. Excluir nombres de destino ya leídos.
- `fetch-disassembly.py` descarga únicamente bancos de referencia autorizados;
  no descarga ROM ni ejecutables. Se añadieron C1, C3, CD, CF, FD y battle_work.

Pendiente: números flotantes de daño/curación, estados alterados, comprobación
nativa de técnicas dobles/triples y combates especiales. Los costes combinados
tienen pruebas sintéticas, no una validación nativa con tres personajes. Los
objetivos de área pueden cambiar al moverse los enemigos y producir avisos
repetidos; revisar estabilidad sin ocultar cambios reales. No afirmar que todo
el combate esté resuelto. Para activar lo entregado, recargar con
`tools/chrono-access/recargar-lector.cmd` o iniciar con el acceso habitual.

Reversión: retirar carga y tick de combate en `lector-snes9x.lua`, sus dos módulos
y callbacks opcionales `battleGlyph/battleControl` de `status-reader.lua`.
No exige revertir menús de campo, audio ni DLL. Las notas anteriores describen
etapas previas y sus pendientes históricos; esta sección tiene prioridad.

