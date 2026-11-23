# 61. Fin del Tiempo, Medina y Hecran

Se añadieron 88 referencias en 16 perfiles de 13 mapas: Fin del Tiempo, sala de
Spekio, Plaza Medina, casa del anciano, posada, vivienda del portal, tienda,
casa y taller de Melchor y cueva Hecran, hasta el regreso a Truce y Plaza Leene.
Los cofres abiertos ahora dicen «Cofre 1, abierto», conservan su número y no
emiten proximidad. La corrección también cubre Proto y la fábrica, sin revelar
contenidos.

## Uso

Control+F6 recorre referencias y Control+F5 repite la seleccionada y su distancia.
Las distancias son directas; sigue corredores y escaleras para salvar obstáculos.

En el Fin del Tiempo se distinguen anciano, farol, cubeta de recuperación,
cubeta del portal a 1999, punto de guardado, puerta de Spekio, escalera y tres
pilares iniciales con sus destinos. Otros cuatro pilares aparecen según sus
flags nativos; los posteriores de Terra y los Dáctilos quedan fuera del alcance.
En Spekio hay cinco referencias del borde para seguir sus instrucciones con el
control. No se automatizan las vueltas ni se inventa un contador de progreso.

Medina y Melchor tienen puertas, escaleras, mesas, camas, mostradores, cocinas,
estanterías, brillos y armario del portal. Personas y enemigos conservan su
sistema anterior. Diálogos, decisiones y comercio usan los lectores existentes.
El observador de descanso no se amplió a Medina: allí las ofertas se leen como
diálogo normal; no hay aviso adicional de «descanso completado».

Hecran tiene cuatro cofres nativos, arcón sellado, pasos, escaleras, guardado y
remolino de regreso, disponible después del combate. Sus cuatro cámaras
interiores separadas tienen perfiles distintos para no señalar objetos de otra
cámara. El exterior, la casa de Crono y Plaza Leene conservan su cobertura previa.

El alcance se contrastó con la [guía de Game Corner](https://guides.gamercorner.net/ct/walkthrough/):
Fin del Tiempo, Medina, Melchor, Hecran y regreso a Truce. Las coordenadas y
salidas proceden de esta ROM y de sus eventos, no de la guía.

## Evidencia y límites

Validación final: **432 pruebas aprobadas**, sintaxis Lua y audio nativo aprobados.
ROM, SRAM y partidas habituales conservaron sus hashes durante la validación.

Las salidas y cofres comunes se extrajeron de tablas nativas. Actores y controles
se contrastaron con eventos y capturas de la copia administrada, oculta y
silenciada. Muebles y extremos de escaleras usan capturas con coordenadas.

- Capturas: test/future-check/time61-map*-ram.bin, .png y -events.txt.
- Vistas adicionales: time61-square, time61-entrance, time61-river,
  time61-sealed y time61-return.
- Pruebas: test/test_time_medina.py y regresiones anteriores de cofres.
- Audio real silenciado: test/verify-time-medina-audio.py y audio61-replay.txt.
- Suite completa, sintaxis y audio: test/future-check/unit-validation-61.txt.
- Hashes durante la validación final: protected-hashes-61.json.

Las cargas independientes de mapas no demuestran un recorrido completo andando.
La reproducción del audio usa capturas nativas con proximidades simuladas.
Quedan pendientes el recorrido completo con control, las vueltas de Spekio,
las negociaciones de Medina y la valoración con NVDA. No se operó la partida
habitual ni se modificaron ROM, DLL o sonidos.

## Mantenimiento y reversión

El generador test/build-time-medina.py regenera el bloque TIME MEDINA de
room-profiles.lua. room-model.lua añade «abierto» y filtra referencias por flags
nativos y progreso. La suite se ejecuta con:

    python tools/chrono-access/test/validate-time-medina.py

Cerrar primero la copia administrada de pruebas. El registro distingue las
pruebas de modelo, las capturas nativas y la reproducción del mezclador.

Para retirar las nuevas zonas, quitar el bloque TIME MEDINA. Para retirar
además la corrección de cofres y sus filtros, restaurar room-model.lua y las
expectativas anteriores desde los archivos *-before61 en test/future-check.
Son dos unidades reversibles: referencias nuevas y estado hablado de cofres.
No requieren tocar VeMovie ni las partidas. No se hicieron commits; tools/
sigue ignorado por Git y requiere respaldo independiente.
