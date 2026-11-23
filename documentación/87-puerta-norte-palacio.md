# 87. Puerta del extremo norte del salón del palacio

Corregida la puerta sellada al fondo del salón norte del Palacio de Zeal,
mapa 329. Se selecciona con Control+F6 como «Puerta sellada del norte»;
Control+F5 consulta dirección, distancia y estado abierto/cerrado.
La referencia no garantiza que se pueda cruzar: depende del evento nativo.

El actor 28 carga el gráfico NPC 3 y no tiene conversación. El actor 26
controla la escena de apertura desde (128,136), con un gráfico humano que
también producía una persona falsa. Ambos quedan excluidos de personas.
Los actores 16 y 18, personas reales a los lados, se conservan.
La secuencia nativa copia las baldosas y establece bit 7 de 7F00F4.
La referencia de puerta ocupa [112,128,144,144] y consulta esa marca.

Evidencia: doors87-top.gd y doors87-top-ram.bin, obtenidas en copia administrada
silenciada con historia 160. Pruebas test_palace_door87.py: 2 aprobadas;
test_palace86.py: 3; test_zeal75.py: 8. Total: 13 aprobadas.
Se comprueban exclusión de ambos actores, conservación de las personas
reales, selección/consulta y estado abierto mediante una marca simulada.
No se ejecutó la apertura nativa ni se certifican sus condiciones de historia.

Copia de pruebas cerrada y tres entradas del arnés restauradas. Sin cargas
de partidas del usuario. Cambios solo en el perfil 329 y su generador;
se conserva la entrega 86. Reversión: restaurar zeal.lua y build-zeal75.py
desde test/future-check/doors87-before a sus rutas originales, retirar
test/test_palace_door87.py y esta nota y quitar el resumen 87 de continuar
chrono.md. Pendiente valoración con NVDA/control. Sin commits.
