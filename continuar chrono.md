# Continuar Chrono Trigger accesible

Proyecto con Snes9x, Lua, Prism y orientación sonora para NVDA.
El usuario es ciego y juega con control Nintendo. Código en tools/chrono-access/.

## Por dónde retomar

Entrega 94: Epoch en las épocas y acceso del Fin del Tiempo.
Lee [94. Epoch en todas las épocas](documentación/94-epoch-en-todas-las-epocas.md).
Exteriores 496–503: Control+F6 selecciona «Epoch estacionado», Control+F5
orienta y Control+F7 calcula ruta. Solo aparece donde está realmente y al
caminar. Incluye 1000, 600, 2300, Prehistoria y 12000 a. C.; 1999 queda
condicionado al estado nativo, sin certificar desembarque allí.
Fin del Tiempo (464): «Acceso al Epoch», plataforma oriental. Entra caminando
y confirma «Sí»; contacto y abordaje nativos a 473 comprobados en copia
silenciada. Presencia por 7F00AB bit 80, historia 174 y actor 72.
57 pruebas y 15 subcasos aprobados; copia cerrada y entradas restauradas.
Al finalizar no había emulador habitual abierto: se carga al próximo inicio
con iniciar-lector.cmd. Respaldo epoch94-before. Conservar 91–93.

Entrega 93: localizar el Epoch estacionado en el mapa exterior.
Lee [93. Epoch estacionado](documentación/93-epoch-estacionado-en-el-mapa.md).
Control+F6 selecciona «Epoch estacionado», Control+F5 orienta y Control+F7
calcula ruta hasta el alcance de A. Solo aparece al caminar en la época
donde está el vehículo, siguiendo posición/presencia nativas. Se oculta
a bordo y durante la rueda/viaje. Incluye exterior 502 sin certificar sus
recorridos. 38 pruebas aprobadas con terreno capturado y posiciones simuladas;
sin nuevo abordaje nativo exterior. No se operó un emulador en esta entrega.
Respaldo epoch93-before. Se aplica al siguiente inicio o recarga del lector.
La recarga automática en la sesión habitual no encontró consola Lua única;
93 no confirmado allí. Partida sin mover/cargar.
Conservar 91/92. Pendiente valoración con NVDA/control.

Entrega 92: criatura extraña, abordaje lateral y rueda del tiempo del Epoch.
Lee [92. Criatura y máquina Epoch](documentación/92-criatura-y-maquina-epoch.md).
Mapa 243: Control+F6 selecciona criatura, Epoch y accesos laterales;
Control+F5 orienta. Rodea a la criatura por un lado y pulsa A junto al Epoch.
Desde el acceso occidental mira al este; desde el oriental mira al oeste.
Arriba/abajo elige Despegar o Desembarcar; A confirma. La rueda anuncia
los siete destinos; L/R o direcciones cambian, A viaja y B cancela.
Posición y presencia nativas de criatura/vehículo; retirada la cabina fija
incorrecta. Conversación, abordaje oeste, decisiones, rueda, viaje al Fin
del Tiempo y cancelación comprobados en copia silenciada. Acceso oriental
y descubrimiento inicial no recorridos. Respaldo epoch92-before.
62 pruebas aprobadas. Copia cerrada y entradas del arnés restauradas.
Se carga al siguiente inicio con iniciar-lector.cmd si no hay juego abierto.
Conservar entregas anteriores. Pendiente valoración con NVDA/control.

Entrega 91: localizar y abordar el dáctil estacionado en Prehistoria.
Lee [91. Encontrar y subir al dáctil](documentación/91-localizar-y-subir-al-dactil.md).
Mapa 499: Control+F6 selecciona «Dáctil estacionado», Control+F5 orienta y
Control+F7 calcula ruta hasta el alcance real de abordaje. Cerca: pulsa A.
No exige sur exclusivamente; el alcance es mayor desde ese lado. Posición
y presencia nativas; desaparece al volar. Abordaje desde el sur y anuncio
de vuelo comprobados en copia silenciada junto a Ioka. 34 pruebas aprobadas.
Copia cerrada y entradas restauradas. Respaldo dactyl91-before.
Al finalizar ya no había emulador habitual abierto: recarga no aplicada.
La mejora se carga al siguiente inicio con iniciar-lector.cmd.
Conservar 75/76 y 86–90. Pendiente valoración con NVDA/control.

Entrega 90: orientación del salón del trono tras la puerta sellada.
Lee [90. Trono de la reina](documentación/90-trono-de-la-reina.md).
Mapas 332/334: Control+F6 selecciona «Trono de la reina» o regreso al salón
norte; Control+F5 orienta. Trono al norte, acceso de regreso al sur.
Acercarse puede iniciar escena/combate. Se conserva el enemigo de 334 y
se excluye la puerta de 332 de personas. 16 pruebas aprobadas, mezclador
real silenciado incluido. Regreso nativo 334→329 comprobado; en la copia
de 332 la puerta bloqueó el regreso, no certificar su paso libre.
Copia cerrada y entradas restauradas. Respaldo throne90-before.
Conservar 86–89. Pendiente valoración con NVDA/control.

Entrega 89: recarga real y confirmada del lector. Lee
[89. Recarga confirmada](documentación/89-recarga-confirmada-del-lector.md).
La consola seguía con el lector antiguo pese al mensaje de éxito de 88:
BM_CLICK no actuaba con el diálogo inactivo. Ahora se envía WM_COMMAND al
padre y se exige confirmación nueva en lector.log antes de anunciar éxito.
Comprobado en la sesión habitual: inicio nuevo en 330 y anuncio de la
antesala de Mammon con la guía actualizada. Sin mover ni cargar la partida.
Al entrar el usuario en 331, lector.log confirmó orientación disponible y
consulta de «Máquina Mammon»: 2.0 casillas al norte, 0.7 al este.
Referencias de 86–88 activadas; perfiles intactos en 89. Copia de diagnóstico
cerrada y entradas restauradas. Respaldo mammon89-before. 333 sigue pendiente.

Entrega 88: referencia de la máquina Mammon para acercar el pendiente.
Lee [88. Máquina Mammon y pendiente](documentación/88-maquina-mammon-y-pendiente.md).
Sala real 331: Control+F6 selecciona la máquina, Control+F5 orienta;
acércate desde el sur, mira al norte y pulsa A. Carga nativa comprobada en
copia silenciada: historia 162→165 y control recuperado al acabar la escena.
Corregido el mapa 403: es dormitorio, no sala del Mammon. Mapa 330 ahora
anuncia antesala y referencia su puerta norte; se excluye de personas.
16 pruebas aprobadas, incluido mezclador real silenciado. Copia cerrada y
entradas restauradas. Respaldo mammon88-before. Variante 333 no cubierta.
Conservar 86/87. Pendiente valoración con NVDA/control.

Entrega 87: corregida la puerta del extremo norte del salón del Palacio de
Zeal (329), que se anunciaba como persona. Lee
[87. Puerta norte del palacio](documentación/87-puerta-norte-palacio.md).
Control+F6 selecciona «Puerta sellada del norte» y Control+F5 orienta y
consulta abierta/cerrada según la marca nativa. Excluidos puerta (28) y
controlador de escena (26); personas laterales 16/18 conservadas.
13 pruebas aprobadas; captura nativa en copia silenciada. No se probó la
apertura nativa. Copia cerrada y entradas restauradas. Respaldo doors87-before.
Conservar entrega 86. Pendiente valoración con NVDA/control.

Entrega 86: escaleras, cuatro Nu conversables y cuadrado de HP/PM del
vestíbulo del Palacio de Zeal (401). Lee
[86. Referencias del palacio](documentación/86-referencias-palacio-zeal.md).
Trece referencias nuevas: Control+F6 selecciona y Control+F5 orienta.
Escaleras: pie y parte superior de cuatro tramos; sube al norte y baja al sur.
Nu con nombre y seguimiento de posición; cerca, pulsa A. Cuadrado al suroeste:
entra caminando. Recuperación y ocho cruces comprobados en copia silenciada.
17 pruebas específicas y regresiones aprobadas; mezclador real silenciado
aprobado con proximidad simulada. Copia cerrada y entradas de arnés restauradas.
Respaldo palace86-before. Pendiente valoración con NVDA/control.

Entrega 85: orientación del destino de 1999, mapa 466, Día de Lavos.
Lee [85. Día de Lavos](documentación/85-dia-lavos-1999.md).
La cubeta ya era accesible. Ahora Control+F6 selecciona el portal de regreso
o el paso norte hacia Lavos; Control+F5 consulta dirección y distancia.
Acercarse al portal y pulsar A regresa. Para seguir, rodearlo por un lado
y caminar al norte activa el encuentro. No cubre el interior de Lavos.
18 pruebas aprobadas; viaje, regreso y escena de encuentro comprobados en
copia aislada silenciada. Anuncios finales y mezclador real comprobados.
Copia cerrada y entradas del arnés restauradas. Respaldo portal85-before.
Aplicar al arrancar o recargar; pendiente valoración con NVDA/control.


Entrega 84: arregladas las entradas agrupadas y los puntos brillantes de
«Cueva de las islas de Zeal». Lee
[84. Cuevas y puntos brillantes](documentación/84-cuevas-zeal-y-puntos-brillantes.md).
Tras el primer enlace, salir al exterior y buscar con Control+F6 «Cueva,
segundo acceso de la isla intermedia», al este por el sendero. Control+F7
consulta ruta. El segundo punto brillante lleva a la isla del palacio.
Cada sector anuncia solo su salida y punto; ya no oculta las otras bocas
del exterior. También hay referencia de transporte en los seis Pasajes/Puentes
de Paso. Recorrido nativo completo comprobado en copia aislada silenciada.
Respaldo independiente caves84-before; no revertir la ampliación 83 al quitarlo.

Entrega 83: 89 mapas adicionales de 1000, 600 y 2300 d. C., con 303 referencias
y cinco conexiones nuevas del salón del Castillo Guardia. Lee
[83. Lugares de las tres épocas](documentación/83-lugares-pendientes-tres-epocas.md).
Incluye Fiona, los tres Solárium, Porre/Choras, Ruinas del Norte, Fuerte de
Ozzie, Uña de Gigas, Bedel/hangar, Geno y Pico de la Muerte. Referencias F6/F5;
estados nativos de controles identificados y cofres, sin historial propio.
Pruebas nuevas: test_eras83.py (8) y test_caves84.py (4); prueba antigua de
cámaras omitidas ahora exige su cobertura. Mezclador real silenciado aprobado
con 97 capturas; no certifica todos los recorridos ni variantes de historia.
La copia administrada está cerrada y las entradas de arnés restauradas.
ROM/SRAM intactas; cambio concurrente detectado en un .000 habitual mientras
el usuario jugaba, sin restaurarlo ni operarlo. Respaldo eras83-before.
Aplicar al arrancar o recargar lector; pendiente valoración con NVDA/control.

Suite final 83/84: 561 pruebas, 553 aprobadas y ocho fallos previos de
test_walk_trace; sin fallos nuevos. Recibo unit-validation-83-84.txt,
suite83-84-final.txt y audio83-84-replay.txt en test/future-check.

Entrega 82: estado abierto/cerrado de los seis libros de Enhasa y Kajar.
Lee [82. Estado de libros](documentación/82-estado-libros-enhasa-kajar.md).
Control+F6 selecciona y Control+F5 consulta el estado nativo actual.
Acercarse y pulsar A abre/cierra. Se añaden tres referencias en Kajar y se
excluyen sus actores de personas. Campos state en zeal.lua, sin cambios
del modelo común. Variables 7F0214/16/18, máscara 1: abierto=1, cerrado=0.
Doce estados finales comprobados mediante A nativo en copia silenciada,
dos pruebas nuevas y diez regresiones específicas aprobadas, mezclador
real silenciado aprobado. Se restauraron las entradas del arnés y se cerró
la copia; nueve hashes protegidos intactos. Respaldo books82-before.
Aplicar al arrancar o recargar lector. Pendiente valoración con NVDA/control.

Suite 82: 549 pruebas, 541 aprobadas y los ocho fallos previos de test_walk_trace.
Sintaxis Lua aprobada. Recibos unit-validation-82.txt, books82-final-native.json
y audio82-replay.txt en test/future-check.

Entrega 81: cuadrado de recuperación de HP/PM y ambas escaleras de Enhasa.
Lee [81. Recuperación y escaleras](documentación/81-recuperacion-y-escaleras-enhasa.md).
Control+F6 selecciona el cuadrado o el pie/parte superior de cada escalera;
Control+F5 consulta dirección y distancia. Entra caminando en el cuadrado;
sube las escaleras al norte y baja al sur. Recuperación y cuatro cruces
comprobados en copia aislada silenciada. Dos pruebas nuevas y ocho regresiones
específicas aprobadas; reproducción con mezclador real silenciado aprobada.
Se restauraron las entradas del arnés y se cerró la copia administrada.
El juego habitual abierto quedó intacto. Aplicar al arrancar o recargar lector.
Pendiente valoración con NVDA/control Nintendo.

Suite 81: 547 pruebas, 539 aprobadas y los ocho fallos previos de test_walk_trace.
Sintaxis Lua y nueve hashes protegidos comprobados. Recibos unit-validation-81.txt
y enhasa81-native.json en test/future-check. Respaldo: enhasa81-before.

Entrega 80: referencias a los tres libros de Enhasa y corrección de personas
falsas en la cueva de llegada. Lee
[80. Libros y portal](documentación/80-libros-enhasa-y-portal.md).
Control+F6 selecciona Libro del sur, del este o del noroeste;
Control+F5 consulta dirección/distancia; acercarse y pulsar A interactúa.
El portal de la cueva tiene referencia propia; sus efectos y actores de escena
ya no se numeran como personas. Ocho pruebas específicas y reproducción
de capturas con mezclador silenciado aprobadas. No se operó la partida habitual.
Aplicar al siguiente arranque o recarga del lector.

Conservar antecedentes:

Entrega 79: pruebas y golpes de pared en el exterior de 12000 a. C.
Lee [79. Colisiones de 12000](documentación/79-colisiones-12000.md).
La cueva de llegada, Enhasa y Kajar ya disparaban wall_hit: se confirmó
con caminatas nativas. Faltaba el sonido en los exteriores 500/501.
rooms/reader.lua observa ahora C236B6, rama nativa de paso bloqueado,
con firma comprobada, modo 027C=1, paneo de la tarea y límite de 25 ticks.
No deducir un choque solo por estar quieto. No hay proximidad continua
de paredes en exteriores. No cambian rooms/model.lua ni world-reader.lua.

Diecisiete casos nativos finales, mezclador real silenciado, reposo y menú
sin golpes en ambos exteriores. Cinco pruebas nuevas. Suite: 543 pruebas,
535 aprobadas y ocho fallos previos de test_walk_trace; sintaxis Lua y PCM
aprobados. ROM y guardados protegidos sin cambios por hash.
Evidencias: test/future-check/walls79-final-native.json y capturas asociadas.
Recibo: unit-validation-79.txt. Respaldo: walls79-before. Copia administrada
cerrada; entradas de arnés restauradas. No había juego habitual abierto.
El arnés test/check-future.lua registra ahora todos los golpes, sin deduplicar
los repetidos. Validación: python tools/chrono-access/test/validate-walls79.py.
Cambios disponibles al arrancar o recargar el lector. Pendiente valoración
del usuario con NVDA/control Nintendo. No se certifican los 52 interiores.
Sigue pendiente la referencia seleccionable de salida en la cueva 351;
su orientación textual al sur y su transición nativa sí están comprobadas.

Conservar entrega 78: Ruinas de la Guarida del Tirano tras Azala y Black Tyrano.
Lee [78. Ruinas Guarida](documentación/78-ruinas-guarida.md).
Interior nativo 307 con salida sur al exterior 499 y portal al norte.
Control+F6 selecciona referencias; Control+F5 consulta dirección/distancia.
Acercarse y pulsar A usa el portal. Su actor 18 determina visibilidad y
posición; efectos 16/20/22 no se anuncian como personas. No hay cofres ni
guardado. Perfil rooms/profiles/ruinas-guarida.lua, registrado primero en
rooms/profiles.lua; no cambian el modelo ni lector común.

En copia administrada silenciada: diálogo inicial, selección del portal,
viaje nativo a 351 (cueva de 12000 a. C., historia 152 a 159) y salida sur
a 499 con historia conservada. Se prepararon historia/posiciones: no prueba
recorrido completo desde el combate ni todas las variantes de historia.
Cuatro pruebas nuevas en test/test_ruins78.py; recibo general y hashes en
test/future-check/unit-validation-78.txt. Validación reproducible:
python tools/chrono-access/test/validate-ruins78.py.
Suite: 538 pruebas, 530 aprobadas y ocho fallos previos de test_walk_trace.
Sintaxis Lua aprobada; ROM y guardados protegidos sin cambios por hash.

Evidencias ruins78-* en test/future-check, eventos nativos y registros del
arnés. Respaldo: test/future-check/ruins78-before. Entradas de arnés
restauradas, copia de pruebas cerrada. No se operó el juego habitual.
Cambios disponibles al siguiente arranque o recarga del lector.
Pendiente valoración del usuario con NVDA/control Nintendo.

Conservar [77. Interruptores y cofres](documentación/77-interruptores-y-cofres-del-tirano.md):
doce mecanismos con estado, doce cofres y dos guardados del perfil
dactil-tirano. Coordenadas de tesoro (0,0) son redirecciones; conservar las
direcciones reales de registro para consultar flags. No guardar historial
propio de pulsaciones; consultar las marcas nativas.
Conservar también 76 (aterrizaje dáctil), 75 (era 12000) y regresiones 66–77.
Pendientes: libros/mecanismos completos de 12000, Cuervalado interior y
exterior posterior a la caída de Zeal (502).

## Operación y protección

- Registro de caminata desactivado al cargar o recargar. Control+Alt+F2 permite
  activarlo temporalmente. Conservar caminar.log. Los ocho fallos previos de
  test_walk_trace.py suponen inicio activado: no cambiar esta política.
- iniciar-lector.cmd abre el juego habitual. recargar-lector.cmd recarga Lua
  sin reiniciar ni cargar una partida.
- Comprobar procesos antes de operar. No cerrar el juego del usuario ni
  confirmar cargas por él. No ejecutar pruebas en su partida.
- Usar test/emulador-pruebas.ps1 para copias aisladas y silenciadas. Cerrar la
  sesión antes de la suite general, que prueba también ese gestor.
- Conservar ROM, partidas, sonidos y evidencias. No sobrescribir DLL cargadas.
- tools/ está ignorado por Git y no constituye respaldo. No tocar cambios
  ajenos de VeMovie. No se hicieron commits.

Copias anteriores: test/future-check/*-before68. Pruebas: test/test_nu68.py.
Mantener también test_ioka66.py y test_ioka_world67.py.
Para otra entrega, crear documento numerado, enlazarlo y sustituir este resumen.

## Ajustes de velocidad, 16 de noviembre de 2026

A petición del usuario se activó Sync Sound en el emulador habitual abierto
y se desactivó Fast Forward (Tab). Verificado en sesión: orden 40028 marcada
(estado 8) y atajo Disabled al reabrir el diálogo. Sin reiniciar ni cargar
partidas. Sync=0 aún figura en disco: el emulador bloquea el archivo mientras
corre; debe guardar su ajuste activo al cerrar normalmente. Comprobar Sync=1
tras ese cierre. Key:FastForward ya figura Unassigned en disco.
Respaldo: diagnosticos/velocidad-20261116-210950/snes9x-antes.conf.
Pendiente comprobar con el usuario el cambio de ventana y el sonido.
