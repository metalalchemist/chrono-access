# Tutoriales y cofres de la casa del alcalde de Truce

[Continuar](../continuar%20chrono.md) · [Índice](README.md) · [Orientación de las dos plantas](16-casa-del-alcalde-de-truce.md)

Se completó la comprobación de los tutoriales y de los dos cofres pendientes
de esta casa. Las referencias identifican a los tutores por tema, los cofres
anuncian lo obtenido y dejan de emitir la señal de objeto al quedar abiertos.
La demostración de combate anuncia cómo avanzar y el regreso a la planta alta.

## Para jugar

- Control+F5 consulta una referencia; Control+F6 recorre tutores, muebles y cofres.
- Abajo: recepcionista en el recibidor, tutor de armas e ítems en el pasillo,
  tutores de mensajes en movimiento y ventana de mensajes de batalla, y tutor
  de Refugios en el comedor.
- Arriba: tutores de Técnicas, estados de combate, equipo y huida, y demostración
  de combate. Acércate, mira hacia la persona y pulsa A.
- Arriba/abajo cambian las opciones; el lector anuncia la seleccionada. A confirma
  y avanza las páginas. En el tutorial de estados se comprobó también «oír más».
- En la demostración solo hay que avanzar los textos con A: no hace falta elegir
  un enemigo. El juego muestra los ejemplos y vuelve a la planta alta al terminar.
- El cofre de la cocina contiene un **MiniTónico**. Está en X=176..192/Y=368..384;
  en la prueba se abrió desde X=184/Y=392, mirando al norte y pulsando A.
- El cofre entre las camas contiene **100 G**. Está en X=656..672/Y=128..144;
  se abrió desde X=664/Y=152, mirando al norte y pulsando A.

Las coordenadas documentan la investigación; para jugar se usan las consultas
y sonidos. Las distancias interiores siguen sin ser rutas. Un cofre abierto
permanece entre las referencias con la palabra «abierto», pero sin señal de
objeto pendiente. Intentar abrirlo de nuevo anuncia que ya está abierto.
La partida del usuario conserva sus propios objetos y banderas de cofres.

## Cobertura nativa de los tutoriales

Se ensayaron **16 recorridos** entre los nueve tutores interactivos. Todas las
rutas aceptadas terminaron en su planta original, con el diálogo cerrado.

| Planta | Tutor | Opciones y contenido comprobados |
| --- | --- | --- |
| Baja | Recepcionista, slot 16 | No/Sí; presentación de la escuela y permiso para tomar los cofres |
| Baja | Armas e ítems, slot 24 | Sí/No; armas, armaduras, accesorios y estadísticas que afectan al daño |
| Baja | Mensajes, slot 26 | Lectura al caminar y pérdida del mensaje al alejarse |
| Baja | Ventana de mensajes de batalla, slot 28 | Botón Y para mover esa ventana |
| Baja | Refugios, slot 30 | Sí/No; recuperación de HP/MP en el exterior y puntos de guardado |
| Alta | Técnicas, slot 16 | Sí/No; técnicas y aprendizaje durante la aventura |
| Alta | Estados, slot 18 | Sí/No y ambas opciones de «oír más»; estados, Sanar, desmayo y Revivir |
| Alta | Equipo y huida, slot 20 | L+R, ataque, defensa y defensa mágica con el porcentaje correcto |
| Alta | Demostración, slot 22 | Sí/No; ejemplo completo de área, línea y zona centrada en el atacante |

Los actores inferiores 18 y 20 tienen `7E0F00+slot=0` y no dieron diálogo.
El slot 18 coincide con el 20 y no tiene colisión; se retira esa referencia
duplicada y se conserva el personaje físico 20 como «Persona junto a la cocina».
Los actores móviles 26 y 28 cambian su disponibilidad de interacción: el 28
parecía no responder en los primeros intentos, pero su diálogo se comprobó
esperando a que la bandera nativa estuviera activa, sin forzarla. No se contaron
los intentos sin respuesta como pruebas aprobadas ni se inventaron diálogos.

La demostración usa el mapa **254** y regresa al **14**. El último ensayo
`demo-final-complete` dura 3627 fotogramas e incluye el aviso de entrada,
los textos, la pregunta final y el regreso con orientación restaurada.
El guion detiene la secuencia al volver; no se acredita solo el comienzo del ejemplo.

## Cofres y resultados comprobados

| Registro de ROM | Mapa y casilla | Contenido | Bandera nativa |
| --- | --- | --- | --- |
| F5:F40A | 13, (11,23) | Objeto 189, MiniTónico | 7F0001, máscara 04 |
| F5:F40E | 14, (41,8) | 100 G | 7F0001, máscara 08 |

El inventario aumentó en un MiniTónico al abrir el cofre de abajo. Para repetir
la comprobación del aviso se limpió **solo en la copia aislada** su bandera;
`closed-chest-before` y `ground-chest-final-after` conservan otro incremento
de exactamente uno. No se ocultó esa manipulación como una segunda partida nueva.
El cofre superior aumentó el dinero de 400 a 500 G; el intento posterior dejó
500 G y produjo «Este cofre ya está abierto», además del texto original «¡Vacío!».

## Código

- `room-profiles.lua`: tutores con nombre temático y dos referencias de cofres.
- `room-model.lua`: usa las banderas nativas para quitar la señal de cofre pendiente
  y conservar su referencia abierta; permite nombres por perfil y omitir el duplicado.
- `treasure-reader.lua`: verifica firmas y observa la obtención nativa de objeto,
  dinero y cofre vacío. Captura los valores antes y compara el resultado al final
  del fotograma. No anuncia una cantidad recibida si el inventario o dinero no aumentó.
- `lector-snes9x.lua`: integra ese tick sin añadir otro callback por fotograma.
- `room-reader.lua`: avisa de la demostración al pasar de la planta alta al mapa
  254; el regreso utiliza el aviso y la orientación de habitación existentes.
- `magno-charset.lua`: añade `%` para el glifo F0, contrastado con
  `tools/chrono-access/font-specials.png` y el texto real de defensa mágica.

El aviso de resultado de un cofre puede acompañar al mensaje original del juego.
Los nombres ordinarios de objetos se leen del catálogo de esta ROM; no se acredita
con esta entrega cada cofre especial o recompensa de eventos del resto del juego.

## Evidencia y pruebas

Todo el ensayo nuevo está en `tools/chrono-access/test/mayor-tutorial-check/`.
`reader-validation.txt` registra textos, decisiones y resultados. Se conservan
capturas `*-before/after-ram.bin`, imágenes GD y las capturas de los dos cofres.
Los ensayos iniciales sin diálogo y el intento fallido de cargar `resume.state`
son investigación rechazada, no evidencia de cobertura.

En este fork, la API Lua de ranuras numéricas genera una ruta inválida al guardar;
el intento no recuperó la casa. Se entró desde una partida nueva aislada usando
los guiones de descubrimiento y se usaron estados anónimos en memoria para los
ensayos posteriores. No reutilizar la ranura 009 ni los archivos `resume*` como
un punto de continuación probado.

`test_treasure.py` comprueba premios nativos, resultado sin aumento, cofre vacío,
banderas, referencia abierta, contenido de ROM y firmas incompatibles.
`test_mayor_tutorials.py` comprueba los 16 recorridos con sus capturas de final,
nombres de tutores, duplicado retirado, anuncio/regreso de la demostración y `%`.
Se actualizan las expectativas de referencias de `test_truce_mayor.py`.

`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`:
**131 pruebas aprobadas**, doce nuevas respecto de las 119 anteriores.
La voz se registró en texto y el mezclador se sustituyó por uno silenciado.
Falta únicamente valorar esta ampliación con el usuario y NVDA en juego real;
eso no se sustituye por las pruebas automatizadas. No se cambió la configuración
de audio: continúa el ensayo previo de búfer a 128 ms.

## Activación y reversión

No había una instancia habitual abierta al empezar. Solo se usó y cerró la copia
aislada; no se abrió ni cargó la partida del usuario. Abrir con
`tools/chrono-access/iniciar-lector.cmd` activa los cambios. Si ya está jugando,
`recargar-lector.cmd` recarga el lector conservando la partida.

Los guiones nuevos y comandos de `test/` inyectan posiciones, botones y una
bandera de cofre para repetir pruebas. No usarlos para jugar. Se conservan ROM,
partidas y evidencias anteriores. `tools/` sigue ignorado por Git.

Para revertir la ampliación, retirar los metadatos de tutores y cofres de estos
dos perfiles, su interpretación en `room-model.lua`, `treasure-reader.lua` y su
tick, la rama de demostración en `room-reader.lua` y el glifo F0. La orientación
y las decisiones No/Sí de la entrega 16 permanecen independientes.
