# 83. Lugares pendientes de 1000, 600 y 2300 d. C.

Se añaden 89 perfiles de mapa, 303 referencias y cinco conexiones que faltaban
en la sala principal del Castillo Guardia. Control+F6 selecciona referencias;
Control+F5 consulta dirección/distancia. Las salidas y escaleras entre salas,
cofres ordinarios y guardados proceden de los registros de esta ROM.

| Época | Zonas incorporadas |
|---|---|
| 1000 d. C. | Santuario/Capilla de Fiona, Solárium, Cabo Oeste, Bosque Sellado, Porre y Choras, cámaras y torres opcionales del Castillo Guardia |
| 600 d. C. | Solárium, viviendas de Truce, Choras y casa del carpintero, Fuerte de Ozzie, Uña de Gigas |
| 2300 d. C. | Solárium, Altar del Sol, Bóveda Bedel y hangar, Bóveda Geno y sus plantas, Pico de la Muerte, encuentro adicional de la fábrica |
| Compartido | Ruinas del Norte: las mismas salas cambian según la época, reparaciones y acontecimientos |

Se conserva el contenido anterior: los perfiles nuevos se registran sin
reemplazar las rutas de huida, la casa inicial ni las referencias de 12000 a. C.
El inventario eras83-profile-inventory.json enumera cada mapa y su cobertura.
La prueba de inventario comprueba todos los huecos del grafo de salidas nativas
de las tres épocas y las ramas adicionales de Geno/Uña de Gigas.

## Uso y comportamiento

En Fiona se anuncia Robo como referencia propia. Las tres religiosas se
numeran como personas; Robo y el altar no añaden personas falsas. Una caminata
nativa desde la entrada llegó junto al altar y Robo.

Los tres Solárium tienen pedestal y referencia de acceso al pasaje/escalera.
Desde el extremo sur, el paso estrecho está centrado en X=136. Se comprobó
la subida nativa hasta el pedestal en 1000, 600 y 2300. La piedra sigue al
actor 16 y desaparece de las referencias cuando el juego la oculta. Los
efectos luminosos no se anuncian como personas. Su aspecto y opciones siguen
dependiendo de la época y del progreso; el lector no decide por el jugador.

Geno añade controles, ascensores y robot de seguridad. Los interruptores
con una pareja Set/Reset nativa identificada anuncian activado/sin activar.
Un control de la planta principal se activó con A en una copia con Robo
preparado en el grupo: 7F013D pasó de 0 a 1. No se ejecutaron todas las
combinaciones de puertas, combates ni la secuencia completa de Geno.

Los arcones sellados identificados consultan su marca nativa de apertura.
Los cofres ordinarios resuelven redirecciones (coordenada 0,0) conservando
la dirección real del registro y su marca de abierto. No se revela contenido.
Los tesoros elegibles del Bosque Sellado se distinguen como occidental/oriental.

Las coordenadas de salida se ajustan a los límites nativos del mapa cuando
la ROM almacena coordenadas locales: por ejemplo, la puerta de Fiona ocupa
[864,480,912,496], no el sector vacío del oeste. Los sectores del castillo que
se excluían durante la entrega de huida ahora tienen sus conexiones completas;
se mantienen las referencias y la orientación anteriores de esa huida.

## Validación y límites

Ocho pruebas en test/test_eras83.py: inventario; salidas y tesoros contra ROM;
87 capturas de campo seleccionan sus perfiles; Fiona; presencia de la piedra;
guardados; estados actuales; activación nativa de un control de Geno.
La prueba antigua de exclusión de cámaras opcionales se actualiza a exigir
su cobertura y conservar escape_21; las quince pruebas de test_future.py pasan.

Las sondas de la sala central de Geno (126, combate) y campamento nocturno
(436, escena) no se certifican como capturas de campo libre: allí se conservan
los lectores de combate/diálogo. Se prepararon historia, grupo, posiciones y
algunas marcas en la copia aislada. No se certifica una partida completa,
todas las variantes de historia, recorridos de todos los pasillos ni todos
los mecanismos de los 89 mapas. Las distancias directas no son rutas seguras
entre paredes, suelos rotos o laderas. La valoración con NVDA/control queda
pendiente. La navegación exterior conserva Control+F7.

verify-eras83-caves84-audio.py reproduce 97 capturas de ambas entregas con
posiciones de proximidad simuladas y mezclador real silenciado. No equivale
a 97 recorridos nativos. Recibos y capturas eras83-* en test/future-check.

Suite final conjunta 83/84: 561 pruebas en 40,973 segundos; 553 aprobadas
y los ocho fallos previos de test_walk_trace. Sin fallos nuevos. Sintaxis
de producción cargada por las pruebas. Recibo: unit-validation-83-84.txt.

## Archivos y reversión

Producción: rooms/profiles/pendientes-{1000,600,2300}.lua, rooms/profiles.lua
y las cinco conexiones de rooms/profiles/futuro.lua. Generador:
test/build-eras83.py. build-future-profiles.py también conserva esas conexiones
si se vuelve a ejecutar el generador antiguo.

Restaurar los archivos preexistentes desde test/future-check/eras83-before;
retirar los tres perfiles nuevos y sus entradas del registro, test_eras83.py,
el generador/arneses de esta entrega y su resumen. Conservar evidencias.
No revertir el arreglo independiente de las cuevas de la entrega 84.

La copia administrada quedó cerrada y las tres entradas de arnés restauradas.
ROM y SRAM habituales sin cambios de hash. Se detectó un cambio concurrente
en el guardado rápido habitual .000 mientras el usuario jugaba; no se restauró
ni se operó ese archivo. Resultado comparativo: eras83-protected-result.json.
No se hicieron commits; tools/ continúa ignorado por Git.
