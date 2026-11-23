# 90. Salón del trono de la reina

La puerta sellada del extremo norte del salón 329 lleva al salón del trono.
Ahora sus dos variantes, mapas 332 y 334, tienen orientación y referencias.
Control+F6 selecciona «Trono de la reina» o el regreso al salón norte;
Control+F5 consulta dirección y distancia. El trono está al norte, al fondo
del pasillo central; el acceso de regreso está al sur.

Avanzar hacia el trono puede iniciar una escena o un combate. La referencia
es un punto fijo de orientación, no una orden de interacción ni una promesa
de acceso libre. No se cambia la escena ni se controla al jugador.

Trono fijo [368,96,400,112], comprobado visualmente en capturas nativas de
ambas variantes. No sigue a quien lo ocupa: en 334 el actor 20 es un enemigo
y conserva esa clasificación. En 332 se excluye de personas el actor 28,
que usa el gráfico de puerta NPC 3. La salida procede del registro nativo
de ambos mapas [368,272,400,288], destino 329. La guía de 329 explica que
su puerta norte conduce al salón del trono.

Capturas throne90-map332 (historia 165) y throne90-map334 (171), obtenidas
en copia administrada silenciada. Desde 334, caminar al sur volvió a 329,
con historia 171 conservada y control activo. En la preparación de 332 el
paso sur quedó bloqueado por la puerta; no se certifica su recorrido de
regreso ni la apertura desde 329. No se probaron escenas ni combates nuevos.

test_throne90.py (3), test_palace_door87.py (2), test_mammon88.py (3),
test_zeal75.py (8): 16 pruebas aprobadas. Incluye selección y consulta del
trono y salida en ambas variantes, permanencia del trono sin seguir actores,
clasificación del enemigo y reproducción con mezclador real silenciado.
No se ejecutó la suite general. Pendiente valoración con NVDA/control.

Copia de pruebas cerrada y tres entradas del arnés restauradas. El lector
habitual se recarga mediante la herramienta con confirmación añadida en 89.
Sin cargas ni desplazamientos de la partida del usuario.
Reversión: restaurar rooms/profiles/zeal.lua y test/build-zeal75.py desde
test/future-check/throne90-before (nombres zeal.lua y build-zeal75.py),
retirar test/test_throne90.py, esta nota y el resumen 90. Los archivos de
eventos zeal75-map332/334-events.txt pueden conservarse como evidencias.
Conservar entregas 86–89. Sin commits: tools está ignorado por Git.
