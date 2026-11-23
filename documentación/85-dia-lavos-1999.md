# 85. Orientación al llegar al Día de Lavos, 1999

El destino de la cubeta del Fin del Tiempo tiene ahora orientación sonora.
La cubeta y su decisión de viaje ya eran accesibles y conservan su comportamiento.

Al llegar, Control+F6 selecciona el portal de regreso o el paso norte hacia
Lavos; Control+F5 consulta dirección y distancia. El portal queda al norte
de la llegada: acercarse y pulsar A devuelve al Fin del Tiempo. Para seguir
hacia Lavos hay que rodear el portal por un lado y continuar al norte.
El encuentro se activa caminando; no necesita A.

El perfil `rooms/profiles/dia-lavos.lua` cubre el mapa nativo 466. El portal
consulta la presencia y posición del actor 24; los actores de efectos y
eventos no se numeran como personas. El paso norte usa la franja previa
al disparador nativo (y=18 casillas). No se modifica el modelo común.
Este perfil no amplía la orientación del interior de Lavos ni los combates.

Validación: 18 pruebas aprobadas mediante
`venv/Scripts/python.exe -m pytest tools/chrono-access/test/test_lavos85.py tools/chrono-access/test/test_time_medina.py tools/chrono-access/test/test_room.py -q`.
En copia administrada silenciada se comprobó el viaje 464→466, el retorno
466→464 con A y el avance al norte hasta la escena nativa 503. El grupo y
la historia se prepararon en la copia: no acredita una partida completa.
Capturas y registros `portal85-*` en `test/future-check/`.

Aplicar al arrancar o recargar el lector. Pendiente valoración con NVDA y control.
Respaldo independiente: `test/future-check/portal85-before/`.
Para retirar esta entrega basta quitar `dia-lavos` de `rooms/profiles.lua`
y su archivo de perfil, prueba y documento. No revertir otras entregas.
