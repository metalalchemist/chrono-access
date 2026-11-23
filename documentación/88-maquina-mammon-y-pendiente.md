# 88. Acercar el pendiente a la máquina Mammon

La máquina Mammon tiene referencia propia en su sala real, mapa 331.
Control+F6 selecciona «Máquina Mammon» y Control+F5 indica dirección y
distancia. Acércate desde el sur por el centro, mira al norte y pulsa A.
Espera a que termine la escena. La acción depende del avance de la historia.

Se corrige un nombre anterior: el mapa 403 es un dormitorio, no la sala del
Mammon. El mapa 330 se anuncia como antesala de la máquina Mammon. Desde el
vestíbulo, selecciona el paso a esa antesala (cámara occidental), sube al
norte y cruza la puerta del fondo, ahora referenciada y excluida de personas.
La salida de la sala 331 vuelve a la antesala por el sur.

El actor 32 en (128,184) ejecuta la interacción nativa. La referencia ocupa
[120,176,136,192]; no sigue un efecto visual. Los actores 16/30/32/34/36
son controladores o efectos y no se numeran como personas. El efecto 30
usa gráfico NPC 171; el 34 muestra el pendiente. Se elimina la referencia
genérica duplicada del actor 32 en el generador.

En copia administrada silenciada se preparó el mapa 331 con historia 162.
Caminar al norte desde (136,271.9375) llevó hasta (139,199.9375). Un A nativo
activó la escena; al esperar, la historia pasó de 162 a 165 y regresó el
control (011F=1). El evento establece historia 165 al terminar la carga.
Capturas mammon88-{ready,near,use,charged}-ram.bin y .gd en test/future-check.
No se certifica el recorrido continuo desde el vestíbulo ni la variante 333
posterior de la sala. No se alteró la historia ni RAM de la partida habitual.

test_mammon88.py (3), test_zeal75.py (8), test_palace86.py (3) y
test_palace_door87.py (2): 16 pruebas aprobadas. Incluye carga nativa,
selección/consulta, nombres de salas y mezclador real silenciado. No se
ejecutó la suite general. Copia cerrada y tres entradas de arnés restauradas.
Pendiente valoración con NVDA/control.

Reversión: restaurar rooms/profiles/zeal.lua y test/build-zeal75.py desde
test/future-check/mammon88-before (nombres zeal.lua y build-zeal75.py),
retirar test/test_mammon88.py y esta nota y quitar el resumen 88. El archivo
test/future-check/zeal75-map331-events.txt puede conservarse como evidencia.
Conservar las entregas 86/87. Sin commits: tools está ignorado por Git.
