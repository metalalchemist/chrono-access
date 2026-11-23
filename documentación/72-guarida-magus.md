# 72. Guarida de Magus

La orientación reconoce 18 mapas de la guarida, desde el exterior hasta la
cámara de Magus, con 71 referencias. El perfil se carga explícitamente desde
`rooms/profiles/magus.lua`.

## Para jugar

- Control+F6 cambia de referencia; Control+F5 anuncia dirección y distancia.
- En el vestíbulo, explora las dos alas y regresa. El círculo central depende
  de los acontecimientos de ambas alas y permite continuar al salón central.
- Las seis cuchillas tienen señales de peligro que siguen su posición.
  Espera y avanza entre ellas. Las referencias orientan; las paredes y escaleras
  pueden requerir rodeos.
- Las seis trampas del suelo tienen referencias de caída al sótano. En el
  sótano, los cuatro círculos tienen efectos variables: combate, guardado o
  regreso. La guía no los presenta como guardados seguros.
- Durante el combate con Ozzie, elige los mecanismos desde los objetivos del
  menú de combate. Después, el círculo occidental conduce hacia Magus y el
  oriental permite guardar, cuando la historia los habilita.
- Acércate y pulsa A para personas, objetos y cofres. Los cofres se numeran
  sin revelar contenido; los abiertos pierden su señal. Las escenas, elecciones
  y órdenes de combate siguen en el juego.

## Cobertura y fuentes

| Sector | Mapas |
| --- | --- |
| Exterior y vestíbulo | 165, 166 |
| Ala izquierda | 469, 169 |
| Ala derecha y apariciones | 171, 125, 173 |
| Salón y cuchillas | 170, 167 |
| Escaleras y trampas | 176, 168, 471, 446 |
| Pasaje y combates | 175, 470 |
| Ozzie y acceso a Magus | 174, 447, 172 |

Las puertas proceden de E50000 y los cofres de F5F000 de la ROM local. El
generador `test/build-magus72.py` conserva sus coordenadas y los identificadores
de tesoro. Los eventos nativos capturados identifican círculos, objetos,
cuchillas y trampas. Los círculos y objetos siguen presencia y posición de sus
actores; los murciélagos decorativos y las piezas de cuchillas no duplican
personas. El sótano conserva la incertidumbre de sus círculos: sus efectos se
resuelven en los eventos, no mediante decisiones automáticas del lector.

## Validación y límites

Se cargaron los 18 mapas con el motor de una copia aislada y silenciada. Las
capturas generales usan historia preparada 102; no representan el recorrido
natural ni certifican que todas las escenas estén desbloqueadas. También se
capturaron dos comprobaciones de transiciones nativas:

- Desde el vestíbulo preparado, 45 cuadros de abajo cruzaron de 166 a 165,
  conservando historia 135.
- Una carga preparada sobre la trampa de 168 activó la caída nativa a 471,
  conservando historia 136. La captura está todavía en animación.

El intento preparado de entrar desde 165 no atravesó la puerta. No se ha
certificado su apertura natural ni una partida completa hasta Magus, la derrota
de los jefes o todas las variantes de círculos. Pendiente escuchar y recorrer
con NVDA y control.

Seis pruebas cubren geometría de puertas y cofres en todos los mapas, cofres
abiertos, círculos visibles y ocultos, cuchillas sin personas duplicadas,
consultas del lector, silencio en menús y transiciones capturadas. El mezclador
real se ejecuta con salida silenciada y proximidad simulada en los 18 mapas.

```powershell
python tools/chrono-access/test/validate-magus72.py
```

Evidencias: `test/future-check/magus72-*`, `audio72-replay.txt` y
`unit-validation-72.txt`. La validación comprueba sintaxis Lua, regresiones y
la identidad SHA-256 de ROM y partidas protegidas. Resultado final registrado
en `unit-validation-72.txt`: 499 pruebas, 491 aprobadas y los mismos ocho
fallos previos de `test_walk_trace`. Sintaxis Lua aprobada; ROM y partidas
protegidas idénticas.

## Reversión y protección

Restaurar `rooms/profiles.lua` y `continuar chrono.md` desde
`test/future-check/magus72-before/`, y retirar `rooms/profiles/magus.lua`.
Ese límite elimina esta orientación sin modificar otros perfiles. El generador,
las pruebas y este documento pueden archivarse junto con sus evidencias.
Los comandos de arranque del caso también tienen respaldo en esa carpeta.

El juego habitual no se abrió ni se recargó. Se cerró solamente la copia
gestionada de pruebas antes de ejecutar la suite. No se hicieron commits;
`tools/` está ignorado por Git y requiere conservar estos respaldos.
