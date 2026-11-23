# 66. Villa Ioka, selva y fiesta

Villa Ioka tiene orientación en sus cuatro chozas, el punto de reunión y la
fiesta. También se añadieron los dos estados de la Selva y el Coto de Caza:
nueve mapas, con diez accesos, nueve cofres y siete referencias de mobiliario.
Las personas conservan nombres como «Persona 1», sin identificar su función.

## Controles

Control+F6 recorre referencias; Control+F5 repite la seleccionada. Acércate y
pulsa A para hablar o examinar. Las referencias indican distancias directas;
los árboles, rocas, desniveles y encuentros requieren seguir el terreno.

La choza del cacique está al norte de Ioka. La choza de curación ofrece agua
dulce mediante una conversación. El lector lee las opciones del juego y tú
eliges con el control. El descanso, las ofertas y la fiesta dependen de la
historia. Se conservaron los lectores de diálogo, estado, tienda y combate.

En la fiesta, localiza a las personas numeradas para hablar y participar:

- Baile: X, Y, L, R y B cambian el movimiento; A termina. El lector repite
  estas instrucciones al entrar en el baile.
- Carrera de sopa: pulsa A repetidamente cuando se anuncie «Ya». Se anuncia
  cada cuenco completo, «Queda poco tiempo» y el total al finalizar la ronda.
  Los diálogos del juego presentan el resultado y las opciones para continuar.
  El lector no acepta desafíos, repite rondas ni pulsa botones por ti.

En el Coto de Caza se anuncia «está lloviendo» o «no está lloviendo» al entrar
y cuando cambia el tiempo con el control disponible. Los cambios durante
menús o diálogos esperan a que vuelvas al juego. Durante las transiciones del
clima se espera a que concuerden el flag y los dos estados nativos del efecto.
El aviso está limitado al Coto de Caza, donde se comprobó ese ciclo.

Los nueve cofres están en el mapa 282 de la Selva. Tienen números estables;
los abiertos dicen «abierto» y dejan de sonar. No se revelan contenidos.

## Evidencia y límites

Salidas y cofres proceden de las tablas de la ROM local. Los nueve mapas se
cargaron con el motor nativo en la copia aislada y silenciada gestionada por
`test/emulador-pruebas.ps1`. Capturas, RAM y eventos: `test/future-check/ioka66-*`.
Las posiciones y la historia se prepararon para investigar; no constituyen un
recorrido completo ni la superación de combates.

La sopa usa otro programa que la soda. Se reutilizó su separación entre
modelo de memoria y lector de voz, manteniendo intactos `soda-model.lua` y
`soda-reader.lua`. El actor 14, función 1 (087D..08A1), incrementa el contador
local 1E y completa un cuenco en el contador 0D. La ronda usa el flag 0E y el
contador de tiempo 1B del actor 12. Sus direcciones son 7F023C, 7F021A,
7F021C y 7F0236. Las firmas y el mapa 280 protegen estas lecturas.

Una ronda nativa con botones produjo cuatro cuencos, inicio, aviso de tiempo
y final. Registro: `ioka66-runtime.txt`; RAM: `ioka66-native-1` a `-7`.
Se prepararon las conversaciones previas; el resultado de esa ronda lo calculó
el juego. No se afirmó ni se preparó una victoria. El baile se comprobó desde
su decisión nativa, tras preparar conversaciones previas: `ioka66-dance-*`.
Se probaron botones y la devolución del control al terminar con A.

La lluvia del mapa 291 usa 7F01D1, bit 4, y los efectos 7E0BD8 / 7F1521
(0 sin lluvia y 4 con lluvia). El motor produjo un ciclo seco, lluvia y seco
sin forzar esos valores: `ioka66-native-10`, `-12` y `-14`.

Hay diez pruebas específicas sobre accesos, cofres, numeración y movimiento de
personas, acompañantes de la fiesta, firmas, rondas, recarga durante la sopa,
menús, baile y ciclo nativo de lluvia. El lector de habitaciones admite
`partyPeople` exclusivamente para perfiles que lo declaran: permite localizar
actores de personajes durante estas escenas y excluye al actor controlado.

Validación reproducible: `python tools/chrono-access/test/validate-ioka66.py`.
Resultados: `unit-validation-66.txt`, `audio66-replay.txt` y
`protected-hashes-66-before.json` / `protected-hashes-66.json`.
Resultado: diez pruebas nuevas aprobadas. Suite general: 470 pruebas, 462
aprobadas y los mismos ocho fallos previos de `test_walk_trace.py` por asumir
registro inicial activado. Se conserva la política de inicio desactivado.
Sintaxis Lua y audio nativo aprobados; ROM, SRAM y partidas habituales
conservaron sus hashes. El validador global devuelve fallo por esos ocho tests.

El audio usa el mezclador real silenciado y proximidad simulada. Queda pendiente
valorar el recorrido completo y los avisos de voz con NVDA, y comprobar caminando
las rutas de la Selva y los servicios de las chozas.

## Activación y mantenimiento

Los cambios se cargan con el lector habitual al iniciarlo. Si ya está abierto,
usa `recargar-lector.cmd` para recargar Lua sin cargar una partida.

Producción: bloque IOKA66 de `room-profiles.lua`, `ioka-model.lua`,
`ioka-reader.lua`, su conexión en `lector-snes9x.lua` y la condición
`partyPeople` de `room-model.lua`. Generador: `test/build-ioka66.py`.
Pruebas: `test/test_ioka66.py`; audio: `test/verify-ioka66-audio.py`.

Para revertir esta unidad, retira ese bloque, los dos módulos, su conexión y
la condición `partyPeople`, conservando cualquier cambio posterior. Las copias
anteriores están en `test/future-check/*-before66`. No se hicieron commits:
`tools/` está ignorado por Git. Se conservó la cobertura previa, incluido el
bloque ROUTE65 ya existente al comenzar. No se modificaron DLL ni sonidos.
