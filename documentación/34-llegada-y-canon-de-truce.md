# Llegada al Cañón de Truce y cambio de escena del Teleport

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

La llegada al capítulo «El regreso de la reina» tiene orientación en el
**claro de llegada, mapa 113**, y los **senderos del Cañón de Truce, mapa 112**.
El exterior de esa época, mapa 497, permite consultar destinos y calcular rutas.
El mapa exterior llama al cañón **«Desfiladero»**.

## Para jugar

En el recinto del Teleport, cuando desaparece Marle y aparece su colgante,
la orientación cambia: deja de pedir que hables con ella y explica cómo
recoger el colgante con A, equivalente a V en el teclado del usuario. Las
personas ocultas dejan de aparecer en las referencias. El juego conserva
su secuencia nativa para llevar a Crono al invento y enviarlo tras Marle.

Al recuperar el control en el cañón:

1. **Control+F5** consulta inicialmente «Paso oeste al sendero principal».
   Acércate a ese paso para salir del claro de llegada.
2. En los senderos, **Control+F6** recorre la salida sur, regreso al claro,
   cofres, extremos de las escaleras, accesos del puente y paso sureste.
   **Control+F5** vuelve a consultar la referencia seleccionada.
3. Desde el claro, el recorrido general sube la escalera del este, cruza el
   puente del norte al oeste y busca la escalera del oeste para bajar.
   Después continúa por los senderos hacia el paso sureste y la salida sur.
4. Al salir, **Control+F5/F6** consultan y recorren destinos del exterior.
   **Control+F7** calcula una ruta, por ejemplo hacia «Posada Truce».

Hay enemigos. El lector de combate sigue activo y la orientación se suspende
durante batalla, diálogo y menús. Los avisos de inmovilidad del registro de
diagnóstico no distinguen por sí solos una pared de un fallo.

Las distancias interiores son directas, **no rutas alrededor de árboles,
barandillas y acantilados**. En el puente debes alcanzar su paso central;
acercarse por el borde de la barandilla puede bloquear el avance. No se añade
movimiento ni combate automático al juego habitual.

## Datos y referencias

| Perfil | Mapa | Límites |
| --- | --- | --- |
| Claro de llegada | 113, 0071 | `[0,0,256,256]` |
| Senderos del cañón | 112, 0070 | `[0,0,512,512]` |

La posición del usuario registrada tras el primer combate estaba en el mapa
113, con líder en el slot 4. No se presupone que el líder siga en el slot 2.

| Referencia | Caja en píxeles | Origen |
| --- | --- | --- |
| Paso oeste del claro | `[0,112,16,176]` | E5:08FC, destino 112 |
| Zona del portal de llegada | `[120,80,152,112]` | Actores nativos del portal en X=136/Y=95,9375 |
| Salida sur del cañón | `[304,496,352,512]` | E5:08EE, destino 497 |
| Regreso noreste al claro | `[496,176,512,240]` | E5:08F5, destino 113 |
| Cofre del noroeste | `[96,80,112,96]` | F5:F46E, objeto BD |
| Cofre del centro | `[272,240,288,256]` | F5:F472, objeto 97 |
| Pie de la escalera este | `[448,200,464,224]` | Capturas y subida nativa |
| Parte alta de la escalera este | `[448,120,464,144]` | Capturas y subida nativa |
| Acceso este al puente | `[384,72,400,88]` | Capturas del puente |
| Acceso oeste al puente | `[304,72,320,88]` | Capturas del puente |
| Parte alta de la escalera oeste | `[128,280,144,304]` | Capturas y descenso parcial |
| Pie de la escalera oeste | `[128,352,144,376]` | Captura del extremo inferior |
| Paso sureste | `[304,432,336,464]` | Captura del tramo sur y salida nativa |

Los cofres se distinguen como objetos; el estado abierto y la retirada de su
señal usan los bits nativos del lector común. Los enemigos usan sus posiciones
y visibilidad actuales. En el claro se excluyen actores auxiliares y efectos
del portal para que no se anuncien como personas ficticias.

## Cambios de código

- `room-profiles.lua`: dos perfiles del cañón y reglas de orientación de Lucca
  según visibilidad del colgante, Marle independiente y Lucca, en ese orden.
- `room-model.lua`: resuelve `guidanceWhenVisible` sin escribir estado.
- `room-reader.lua`: anuncia el cambio de instrucciones una vez al recuperar
  control dentro de la misma zona; reconoce la salida al exterior 497.
- `world-model.lua`: admite caminar a pie en 496 y 497; conserva el filtro de
  modo de control. Destinos y terreno proceden de los datos actuales de RAM.
- `world-reader.lua`: anuncia el año 600 para 497 y conserva el año 1000 para
  496. Reinicia la selección si cambia directamente el mapa exterior.

No se cambian ROM, partidas, DLL, sonidos originales ni configuración del
emulador. La navegación del exterior utiliza las mismas consultas y algoritmo
de ruta que el mapa anterior, contrastados con los datos nativos de 600.

## Pruebas y evidencias

`test_truce_canyon.py` comprueba perfiles y límites, salidas y cofres de ROM,
sonidos de escalera, cofre abierto, consultas, silencio durante combate,
victoria inicial, transiciones nativas, destinos y rutas del exterior de 600.
`test_teleport.py` añade el cambio de instrucciones al aparecer el colgante,
la retirada de Marle oculta y la ausencia de anuncios repetidos por fotograma.
Estas últimas comprobaciones usan visibilidad modificada sobre RAM capturada;
no se acredita una segunda ejecución completa de la escena de Marle.

Evidencias en `tools/chrono-access/test/truce-canyon-check/`:

- `arrival`, `arrival-battle-complete`: llegada y victoria real contra los tres
  Azulete con el personaje de prueba. Se registran experiencia y dinero nativos.
- `exit-arrival`, `east-ladder-top`, `bridge-west`, `bridge-crossed`: paso al
  mapa 112, subida y acceso al puente. El intento posterior en el puente
  terminó en derrota; **no acredita un recorrido continuo completo del cañón**.
- `west-plateau`, `northwest-chest`, `middle-path`, `west-ladder` y
  `west-ladder-bottom`: sondeos independientes del terreno y del cofre que
  entrega MiniTónico. Se usó el cargador nativo para situar la copia de prueba.
- `south-entrance`, `query-south-exit`, `south-ladder` y `southern-path-exit`:
  tramo sur, consulta de salida y cruce real al mapa 497. El nombre histórico
  del sondeo `south-ladder` no significa que allí exista otra escalera; la
  referencia implementada es el paso sureste.
- `world-600-entry`, `world-query-route`, `world-return-canyon`: exterior, ruta
  hablada al Desfiladero y regreso nativo al cañón con A.
- `world-inn-query`, `world-inn-route`: consulta y cálculo de ruta a Posada
  Truce. Se verifica el cálculo; no se recorrió esa ruta hasta entrar en la posada.
- `reader-validation.txt`, capturas `.gd`, cuadrículas y `sessions/`: registros
  completos, incluidos intentos fallidos, conservados sin borrar evidencia.

Los guiones `start-truce-canyon.lua`, `check-truce-canyon.lua`,
`warp-canyon-research.lua` y `drive-truce-canyon.py` son **solo para la copia
aislada y silenciada**. Preparan historia y pueden inyectar posiciones o
botones. Se ensayó una recuperación de vida durante el combate del puente,
que no evitó la derrota; ese intento no se utiliza para acreditar navegación.
El emulador habitual no se operó para investigar ni se llevó al usuario a otra zona.

## Activación, límites y reversión

Una recarga del lector incorpora los perfiles sin reiniciar ni cargar partida;
no hace falta sustituir una DLL. También se cargan en el siguiente arranque.
Falta la valoración del usuario con NVDA y de la mezcla sonora durante el recorrido.
Las viviendas, tienda y posada de 600 todavía no reciben perfiles interiores
de esta entrega; el exterior sí permite localizarlas y calcular rutas.

Verificación final: **272 pruebas aprobadas en 26,914 segundos** con
`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`.
Registro en `test/truce-canyon-check/suite-validation.txt`. Se cerró el ensayo
con el gestor. La comprobación final no encontró procesos Snes9x abiertos,
por lo que los cambios quedan para el próximo arranque habitual; no se abrió
ni cargó una partida por el usuario.

Para revertir, retirar los dos perfiles, `guidanceWhenVisible`, su resolución y
anuncio por cambio; restaurar los filtros de 496 y la introducción anterior
del lector exterior. Conservar las evidencias. El diagnóstico de caminata,
los combates y los perfiles anteriores siguen siendo módulos independientes.
