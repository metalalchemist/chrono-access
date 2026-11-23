# 86. Escaleras, Nu y recuperación del Palacio de Zeal

El vestíbulo del Palacio de Zeal (mapa 401) añade trece referencias.
Control+F6 selecciona; Control+F5 consulta dirección y distancia.

- Cuadrado de recuperación de HP y PM, al suroeste: entra caminando.
- Nu del pasillo central, noroeste, norte y noreste: acércate y pulsa A.
  Las referencias siguen su posición y desaparecen si el actor no está visible.
- Escaleras centrales sur, intermedia y norte, y escalera occidental:
  cada tramo tiene referencia al pie y arriba. Sube al norte y baja al sur.

Las distancias son directas. Rodea paredes y muebles; las personas pueden
bloquear el paso. Los Nu conversables dejan de duplicarse como enemigos.
No se modifica la detección general de personas ni los actores de escenas
posteriores; el cambio se limita a este vestíbulo.

El evento del actor 28 comprueba casillas X 9..10, Y 42..43 y ejecuta
Restore hp/mp en 05E6. La referencia ocupa [144,672,176,704]. En copia
administrada silenciada, caminar desde (168,719.9375) hasta (168,679.9375)
restauró HP 1→161 y PM 0→22. Se preparó el daño únicamente en RAM de pruebas.

Cuatro tramos comprobados caminando en ambos sentidos en el mapa nativo:
central sur (Y 464→364→484), intermedio (356.9375→296.9375), central norte
(303.9375→193.9375→338.9375) y occidental (296→376→296).
Se prepararon posiciones y cargas de mapa en copia aislada; esto no certifica
un recorrido continuo desde la entrada ni todas las variantes de historia.
Capturas palace86-*.gd y palace86-*-ram.bin en test/future-check.

Validación: test_palace86.py (3), test_zeal75.py (8), test_enhasa81.py (2)
y test_caves84.py (4): 17 pruebas aprobadas. Incluye selección y consulta
de las trece referencias, Nu móvil/oculto, recuperación, escaleras nativas
y reproducción con el mezclador real silenciado y proximidad simulada.
No se ejecutó la suite general. Pendiente valoración con NVDA y control.

La copia administrada quedó cerrada y sus tres entradas de arnés restauradas.
No se cargaron partidas ni se alteró la RAM del juego habitual.
Reversión: restaurar rooms/profiles/zeal.lua y test/build-zeal75.py desde
test/future-check/palace86-before (nombres zeal.lua y build-zeal75.py),
retirar test/test_palace86.py y esta nota y deshacer solo el resumen 86.
El respaldo incluye continuar chrono.md. Sin commits: tools está ignorado.
