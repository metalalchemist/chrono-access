# Puerta de la celda y orientación de la prisión hasta el Tanque Dragón

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

La prisión tiene orientación en siete mapas, divididos en veinte zonas para
separar puentes, rellanos y grupos de celdas. Se añaden 67 referencias: las
41 conexiones de esos mapas, once cofres, doce puntos intermedios de los puentes,
la puerta inicial, su aproximación interior y el punto de guardado de la celda.
El usuario confirmó que el juicio ya se leyó completo; no se modificó su lector.

## Para jugar desde la celda

1. Recorre las referencias con Control+F6 hasta «Puerta de la celda inicial».
   Control+F5 consulta su distancia y dirección. La puerta está al sur.
2. Puedes esperar la ejecución o caminar hacia el sur contra la puerta para
   tocarla. El contacto caminando provoca la respuesta; A avanza los textos.
3. Para insistir, termina la respuesta, retrocede un poco al norte y vuelve
   a caminar al sur contra la puerta. Se comprobaron «¡Cállate!», la amenaza
   de dar una lección y la orden «¡Abre!».
4. Cuando el juego permita salir, busca el paso al corredor hacia el este.
   Las distancias son directas: una referencia tras una reja no implica que
   puedas atravesarla. Continúa con las conexiones de cada sala y puente.

El puente superior se identifica también como el del encuentro con el Tanque
Dragón. Los enemigos presentes conservan el sonido y las referencias de enemigo.
El combate usa el lector existente, incluidos los nombres nativos de los objetivos.
No se añaden identidades a las personas numeradas.

## Cobertura y evidencia

Desde el muro exterior sur, «Paso 2 a celdas» lleva al mapa 71, X=13, Y=6.
Esa celda tiene el cofre 7 y un agujero al oeste, actor 28, X=152, Y≈112.
Se añadió su referencia después: «Agujero del suelo; entra para bajar a la
celda de los dos cofres». Su guion llama a la función 7 del actor 40 y cambia
al mapa 71, casilla 9,30, donde están los cofres 5 y 6. Se verificó la conexión
en el guion nativo; falta recorrer físicamente esa caída en la copia aislada.

| Mapa | Orientación añadida |
| --- | --- |
| 28 | Cuatro puentes separados, sus extremos y tres puntos por puente. |
| 29 | Vigilancia y entrada, separadas por altura. No es la celda inicial. |
| 30 | Sala de tortura, salida y cofre. |
| 71 | Celdas, puerta inicial, guardado, corredor inferior y almacén. |
| 72 | Tres grupos de corredores, conexiones internas y cofre. |
| 75 | Dos zonas del muro exterior y accesos a las celdas. |
| 489 | Tres rellanos de la torre hacia el castillo y cofre. |

Las conexiones y cofres proceden de las tablas de la ROM Magno compatible.
Los cofres abiertos pierden el sonido de premio y conservan su referencia.
El actor 34 del mapa 71 tiene la firma nativa de gráfico de guardado `82 79`;
su referencia usa `save_point` y no se cuenta también como persona.
Las dos mitades de la puerta inicial son los actores 30 y 32, a X=312/328,
Y≈608. El punto de aproximación está en suelo nativo a X=320, Y=584.

`test/prison-check/` conserva RAM, capturas GD y el registro del lector.
`jailed`, `knock1`, `knock3`, `knock4`, `guardenters` y `dooropens` documentan
la prueba de la puerta. La escena se preparó con flags copiados y el bit de
reclusión ya establecido en la copia aislada; después se usaron botones nativos.
Esto no demuestra el traslado continuo desde el juicio.

Para el puente se preparó el contador de historia 46, el estado de huida y el
grupo Crono/Lucca en la copia. Se caminó hacia el oeste con botones nativos.
El registro contiene la reacción de Lucca y «CANCILLER: ¡Adelante, Dragón Tanque!».
`tankbattleloaded` conserva el combate real y «La cabeza repara daños»;
`tanktargets` comprueba selección y cambio entre «Dragon Tan.», «Captanque» y
«Triturador». No se verificó una victoria contra este jefe.

Faltan el recorrido legal continuo por todas las salas, la apertura física
de todos los cofres, las dos variantes completas de la fuga y la valoración
auditiva con NVDA. La cobertura de orientación no sustituye esas pruebas.

Comprobación posterior del mapa 30: el cofre del noreste no necesita un
interruptor. Se preparó el estado posterior al combate de los dos Carroña
(`7F0198`, bit `01`) y se caminó desde X=104, Y≈192 hacia el este y el norte.
Desde X=184, Y≈120, mirando al norte, aceptar abrió el cofre y el lector anunció
«Cofre. Has obtenido MallaBron..». Las capturas `torture-after-fight`,
`torture-east`, `torture-open` y `torture-accept`, en `test/prison-check/`,
conservan la aproximación y el premio. El combate previo se preparó mediante su
flag; no se jugó esa victoria en esta comprobación.

## Validación, activación y reversión

`test/test_prison.py` verifica terreno, actores, atajos, suspensión en diálogos,
referencias de enemigo y cofres abiertos. El resultado general queda en
`test/prison-check/unit-validation.txt`: **361 pruebas aprobadas**; la integridad del guardado copiado,
en `save-integrity.txt`. La prueba general debe ejecutarse con el emulador
compartido cerrado, pues comprueba deliberadamente su protección contra sesiones
ocupadas. Usar `python -m unittest discover -s tools/chrono-access/test -p 'test_*.py'`.

El cambio funcional está únicamente entre `BEGIN PRISON` y `END PRISON` de
`room-profiles.lua`. Retirar ese bloque revierte esta ampliación sin tocar
diálogos, combate o progreso del juego. `test/build-prison-profiles.py` permite
regenerarlo; los guiones `seed-*`, `warp-*`, `start-*` y `drive-*` de esta entrega
solo deben ejecutarse en el caso aislado `prison-check`.

La copia de pruebas quedó cerrada. No se recargó ni reinició una partida habitual.
Las referencias se cargarán al próximo inicio normal; si el juego ya está abierto,
`recargar-lector.cmd` actualiza el lector conservando la posición.
