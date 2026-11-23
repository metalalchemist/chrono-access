# Casa del alcalde de Truce: dos plantas y opciones de diálogo

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

La casa del alcalde de **Truce** tiene orientación sonora en la planta baja y
la planta alta. Se verificaron la entrada desde el exterior, la escalera en
ambos sentidos y la salida. También se añade lectura de la opción seleccionada
en las decisiones de diálogo, probada con «No» y «Sí» del recibidor.

## Uso

- Control+F5 consulta una referencia. Al entrar abajo comienza por la salida;
  arriba comienza por el acceso de regreso a la escalera.
- Control+F6 recorre las referencias de la planta y las personas detectadas.
- La salida está al sureste de la planta baja. La escalera se aborda desde
  su base en el pasillo inferior, hacia el centro: **avanzar al este sube**.
- Arriba, el acceso de regreso está al oeste, por el paso inferior:
  **avanzar al oeste baja**. Hay dos camas al norte.
- Para hablar, acercarse y mirar a una persona y pulsar A. En el recibidor,
  arriba/abajo cambian entre No y Sí y el lector anuncia la selección real.
  A confirma la opción del juego. No se ha añadido cancelación con B.

Las consultas dan dirección y distancia; no calculan rutas entre muebles,
personas ni pasillos. La parte oeste de abajo contiene cocina y comedor,
conectados con el recibidor por el pasillo del norte. No se acredita un
recorrido continuo entre todas las referencias; los ensayos usan reubicaciones.
Los textos de los tutoriales siguen usando el lector de diálogo existente.
No se comprobó cada tutorial ni el contenido de todos los cofres.

## Perfiles y conexiones

| Perfil | Mapa | Límites `[x1,y1,x2,y2]` |
| --- | --- | --- |
| Planta baja | 000D (13) | `[48,304,432,496]` |
| Planta alta | 000E (14) | `[544,80,736,224]` |

La entrada capturada sitúa al líder 2 en X=376, Y=463,9375, cámara 176/288.
Abajo se señalan la salida `[352,480,384,496]`, la base de escalera
`[208,464,224,480]`, cocina, mesa, dos sillas, mueble, vasija, dos relojes y planta.
Arriba se señala el acceso a la escalera `[576,192,592,208]` y las dos camas.
Se clasifican como muebles los obstáculos anotados. Las paredes y distancias
se calculan con el terreno del juego; las personas se obtienen de RAM.
Las referencias siguen llamándose «Persona», sin asignar nombres a los tutores.
Dos slots inferiores coinciden inicialmente en posición; no se afirma que
el recuento de slots sea un recuento de personas visualmente distintas.

Los registros de salida de ROM se contrastan en `test_truce_mayor.py`:

- E5:04B1: mapa 13 → exterior 496; siguiente registro: mapa 13 → mapa 14.
- E5:04BF: mapa 14 → mapa 13.
- La subida real, comenzando cerca de la base en X=200/Y=464 y avanzando al
  este, termina arriba en X=600/Y=199,9375.
- El descenso desde X=584/Y=200 al oeste termina abajo en X=216/Y=479,9375.

Las primeras pruebas cerca del dibujo superior de la escalera quedaron
detenidas. Sus capturas `upstairs` y `upstairs2` siguen en mapa 13 y se conservan
como intentos rechazados. La subida acreditada es `upstairs3`, en mapa 14.

## Opciones de diálogo

`dialogue-reader.lua` conserva los glifos resueltos de cada línea nativa
`7E0131`, los reinicia con la limpieza del renderer C0:20B2 y lee el estado
de decisión `7E0162=2`. La selección está en `7E0163`, acotada por
`7E0164/0165`. Solo anuncia líneas capturadas dentro del diálogo de campo.
No deduce selecciones por pulsaciones, ni intenta reconstruir una caja
que ya estaba dibujada antes de recargar el lector.

La primera selección se encola detrás de la pregunta. Las siguientes
selecciones pueden interrumpir la voz para responder al movimiento del cursor.
La lectura general del texto mantiene su comportamiento anterior.
Las pruebas cubren cambio de selección, límites inválidos, separación de menús,
cierre, reapertura y limpieza entre páginas. No se acredita con ello cada
decisión especial ni un diálogo que ya estuviera abierto al recargar.

## Evidencia y validación

La copia aislada y silenciada es `tools/chrono-access/test/truce-mayor-check/`.
Las capturas `entrance-grid.png`, `west-kitchen-grid.png` y `upstairs3-grid.png`
aportan las referencias visuales; sus archivos `*-ram.bin` conservan el terreno.
`reader-validation.txt` registra consultas, cambios de planta, diálogo y opciones.
`verified-bed-ram.bin` conserva la detención en X=608/Y=160 después de intentar
avanzar al este contra la cama oeste. Los guiones no reproducen sonido nativo
de orientación: sustituyen el mezclador por uno silenciado y registran la voz.
Falta valorar el resultado con NVDA y escuchar los sonidos durante el juego.

La suite completa registra **119 pruebas aprobadas**:
`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`.
Son seis pruebas nuevas de la casa y cuatro de decisiones de diálogo.
La configuración de audio habitual conserva el ensayo de 128 ms de la entrega 15;
no se hicieron más ajustes de audio en esta entrega.

## Activación, protección y reversión

No se encontró una instancia habitual abierta al empezar. Se creó y cerró
únicamente la copia aislada; no se abrió ni cargó una partida del usuario.
Comprobar los procesos actuales antes de operar. Abrir normalmente con
`tools/chrono-access/iniciar-lector.cmd` activa los cambios; si ya estuviera
jugando, recargar con `recargar-lector.cmd` conserva su partida.

Los guiones `discover-truce-mayor.lua`, `check-truce-mayor-runtime.lua` y
`check-truce-mayor-reader.lua` inyectan posiciones y botones. Son exclusivos
de la copia aislada y no se deben usar para jugar. Los comandos y capturas
se conservan como evidencia; no abrir sus autorun sobre una partida habitual.

Reversión de orientación: retirar `truce_mayor_ground` y `truce_mayor_upper`
de `room-profiles.lua`. Reversión de decisiones: retirar la captura por líneas,
el hook C0:20B2 y el anuncio de selección de `dialogue-reader.lua`, manteniendo
la lectura de páginas anterior. Cada función tiene pruebas y documentación
propias. No requiere modificar la ROM, partidas, otras casas ni DLL.
`tools/` sigue ignorado por Git y no se hicieron commits de cambios ajenos.
