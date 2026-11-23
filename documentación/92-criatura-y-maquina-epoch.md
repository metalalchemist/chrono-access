# 92. Encontrar la criatura y subir al Epoch

En el hangar de la Bóveda Bedel, Control+F6 permite seleccionar «Criatura
extraña», «Epoch» y sus dos accesos laterales. Control+F5 consulta dirección
y distancia. La criatura repite las instrucciones cuando te acercas y pulsas A.

Para subir, rodea a la criatura por la izquierda o la derecha hasta el acceso
lateral del Epoch. Desde el acceso occidental, mira al este; desde el oriental,
mira al oeste. Acércate y pulsa A. Elige «Despegar» o «Desembarcar» con arriba
y abajo y confirma con A. Las decisiones las lee el lector general de diálogo.

La rueda del tiempo anuncia el destino seleccionado. L y R o las direcciones
cambian de época; A viaja y B cancela. Lee Fin del Tiempo, 2300, 1999, 1000,
600, 12000 a. C. y Prehistoria. El juego omite la época actual al recorrer
destinos; no se sustituye esa decisión ni se inyectan controles.

La antigua referencia fija «Cabina del Epoch; examina con A» apuntaba a
Y352–384. El Epoch disponible estaba en (128,288), con la criatura en
(128,304), bloqueando el acceso directo desde el sur. Ahora los actores 30
y 28 determinan posición y presencia. La criatura deja de desaparecer de
las referencias por su clasificación gráfica de enemigo. Los actores de
escenario siguen excluidos de personas.

El perfil específico conserva el identificador eras83_243 y la salida nativa.
pendientes-2300.lua lo carga desde epoch-hangar.lua; build-eras83.py conserva
esa delegación cuando se reconstruyen los perfiles. La guía también señala
el extremo norte y el punto de encuentro del sur para la primera visita.
La marca 7F00EE, bit 80, informa si ya se presentó el transporte; no se guarda
historial propio de pulsaciones.

epoch-reader.lua observa C26AC8, despacho nativo de la rueda, y C26B5E,
lectura de sus controles en reposo. El destino está en tarea +22, con índices
0–6. Se comprueban firmas de ROM antes de instalar ambos observadores.
El anuncio espera a que termine el giro, evita repeticiones en reposo y se
reinicia al salir de la rueda. lector-snes9x.lua ejecuta su tick cada cuadro.

En copia administrada silenciada se prepararon mapa 243, historia 172 y
7F00EE=82 hexadecimal a partir de una captura previa, con grupo en (136,416).
Se comprobó conversación con la criatura, abordaje nativo por el oeste,
decisión de desembarcar y cambio de vuelta a despegar. Tras despegar, L/R
recorrieron los siete destinos y el lector anunció cada uno. A inició el
viaje al Fin del Tiempo: pasó por la escena 432 y llegó a 473. B canceló
la rueda y devolvió la decisión de continuar o desembarcar. Control+F6/F5
seleccionaron y consultaron la criatura, y el mezclador real funcionó
silenciado con los nuevos objetos.

Evidencias: test/future-check/epoch92-*. Los primeros intentos incluyen una
orden Lua mal entrecomillada y recorridos que chocaron con la criatura; no
son recorridos aprobados. El acceso oriental y la secuencia inicial de
descubrimiento se basan en los eventos nativos, pero no se han recorrido.
No se certifican todos los viajes ni la variante posterior a la caída de Zeal.

62 pruebas aprobadas, incluida regresión de diálogo, cuartos, mapa exterior,
dáctil y Zeal. Sintaxis Lua/Python y hashes protegidos comprobados; copia
cerrada y tres entradas del arnés restauradas. Pruebas y cierre se registran
en test/future-check/unit-validation-92.txt. Respaldo independiente:
test/future-check/epoch92-before. Para revertir, restaurar pendientes-2300.lua,
build-eras83.py y lector-snes9x.lua de ese respaldo y retirar epoch-reader.lua,
epoch-hangar.lua y test_epoch92.py. Conservar las entregas 75–91.
Sin commits. Pendiente valoración con NVDA/control Nintendo.
