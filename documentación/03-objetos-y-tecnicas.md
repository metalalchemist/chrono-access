# Objetos y Técnicas de campo

[Continuar el proyecto](../continuar%20chrono.md) · [Índice documental](README.md)

Las notas siguientes conservan la evidencia y el alcance de cada etapa. Los pendientes de una etapa pueden estar resueltos en documentos posteriores; el estado actual se consulta en el documento de continuación.

Las rutas de código escritas entre comillas invertidas parten de `D:\gt\vemovie`, salvo indicación distinta.

Código y evidencia relacionados:

- [inventory-reader.lua](../tools/chrono-access/inventory-reader.lua)
- [tech-reader.lua](../tools/chrono-access/tech-reader.lua)
- [menu-check/validation.txt](../tools/chrono-access/test/menu-check/validation.txt)

## Última ampliación del 26 de octubre: Objetos y Técnicas

Ya se leen los dos submenús. `inventory-reader.lua` anuncia nombre, cantidad,
casilla, descripción, casillas vacías, destino con vida/magia, uso confirmado y
cantidad restante. También explica marcar/mover un objeto, avisa al intercambiar,
cancelar u ordenar, y consulta los personajes compatibles con una pieza de equipo.
Para Onzas de estadística lee el valor actual antes y después del uso.

**Objetos tiene una interacción propia del juego:** confirmar una vez marca la
casilla; confirmar otra vez sobre la misma abre el uso o consulta. Después se
elige y confirma el destino. Confirmar sobre otra casilla intercambia los objetos.
El lector lo explica y no anuncia «usado» hasta observar el consumo real.

`tech-reader.lua` lee categoría Individuales/Dobles/Triples, personaje, técnica,
posición y descripción. Anuncia coste de magia por participante y magia disponible,
usando el cálculo del juego, incluidos accesorios de descuento. Distingue solo
combate, personaje fuera del grupo activo, magia insuficiente y técnica visible
pero todavía no aprendida. Para esta última lee los puntos de técnica restantes.
También lee selección de destino, cancelación y uso real con magia restante.
Esto da acceso a estos menús de campo; **no implementa el menú de combate**.

Los módulos comparten con `status-reader.lua` las funciones de nombres, personajes
y descripción del observador ya existente. Las cachés de descripción de objeto y
técnica están separadas: un mismo número de ID no identifica el mismo contenido.
`dialogue-reader.lua` mantiene sus hooks compartidos y el filtro de campo. Las
actualizaciones automáticas durante una animación no deben cortar la confirmación
de uso: se conserva la identidad del destino incluso durante fotogramas sin hook.
La vuelta real al menú principal (C29A98) incrementa `menuEpoch` en el observador.
Objetos y Técnicas limpian su selección con ese cambio de contexto, no con un
timeout de tres fotogramas: las animaciones pueden suspender sus hooks antes y
después del consumo, y ese timeout provocaba repeticiones que cortaban la voz.

Direcciones verificadas para nuestra ROM:

- Objetos: C2AD4E después de seleccionar fila; índice absoluto 7E0D26 = scroll
  7E0416 + cursor. Inventario real: IDs 7E2400 y cantidades 7E2500, 242 casillas
  del menú. ID 00 significa vacío, aunque un byte de cantidad antiguo no sea cero.
- C2AAA7 marca; C2AAFC/C2AAFF intercambia o cancela; C2AA4D lee la cabecera y
  C2AB61 termina ordenar. C2AEB4 muestra quién puede equipar un objeto; es consulta,
  no confirmación de cambio de equipo.
- Destinos de objetos: C2B1AE y C2B231. C2B31C/C2B352 rodean el consumo y su
  redibujo; C2B1BA indica falta de efecto. Los destinos salen de 7E0D5F[7E0DBE],
  o de todo el grupo si 7E0DBD tiene bit 3. El máximo de vida para destinos se
  obtiene del campo calculado del personaje +3F, como hace la rutina del juego.
- Técnicas: C2B567 termina cabecera; C2B72D termina cursor/lista. Índice absoluto
  7E0F48 + 7E0F4A, total 7E0F49, IDs 7E0F00, grupo de participantes 7E0F30.
  Nombres: CC15C4 + ID*11. Participantes: máscara CC2963[grupo] y bits FFF9BB.
- C2BC57 captura el coste ya ajustado de 7E9890 para el ID 7E0F4C y personaje
  7E9A90. No sustituirlo por el coste base de ROM: perdería los descuentos y los
  componentes de técnicas combinadas. C2BE51 inicia su descripción, terminada por
  el observador C2FAE8. C2B494 lee destino; C2B516 observa el uso después de restar
  magia. Las ramas de rechazo tienen hooks propios y firmas comprobadas.
- En la categoría individual, bit 6 de 7E7700[ID] marca la próxima técnica aún no
  aprendida, y +2D del registro del personaje contiene los puntos restantes.
  Al comenzar, Ciclón puede verse en la lista pero faltan 5 puntos: no anunciarlo
  como técnica ya aprendida. El bit 7 indica uso desde el menú cuando corresponde.

Pruebas: `python -m unittest discover -s tools/chrono-access/test -p 'test_*.py'`:
**45 aprobadas** (13 de Objetos/Técnicas, 7 estado/equipo, 14 lector, 6 cuarto,
5 casa). Incluyen costes de varios participantes, descuento ya calculado, puntos
pendientes, descripciones con IDs coincidentes, consumo real, cápsulas, casillas
vacías y confirmación que no se interrumpe tras una animación.

Integración aislada: `test/discover-menus.lua`, `test/check-menu-runtime.lua`, `test/menu-check/`.
**Nunca cargar esos scripts ni sus comandos en la partida del usuario:** inyectan
botones y los ensayos añadieron inventario, personajes y técnicas solo a la copia.
Voz registrada y audio silenciado. Se verificó MiniTónico: vida 20 → 70, cantidad
3 → 2; repetir con vida llena no consume. Aura: vida 20 → 62 y magia de Marle
20 → 19. Cura2 con accesorio A2 cuesta 3 en vez de su coste base 5; la falta de
magia se rechaza sin aplicar la técnica. NubeAura leyó Marle 1/Crono 2;
FuerzaDelta leyó Marle 4/Crono 8/Lucca 8. OnzaPoder cambió fuerza 5 → 6 y
cantidad 3 → 2. Se comprobaron casillas más allá de la primera página y mover
objetos sin consumirlos. `test/menu-check/validation.txt` resume las capturas de RAM.
El ordenado conservó los 20 tipos y todas sus cantidades. La prueba final de Aura
con la corrección de contexto leyó vida 20 → 66 y magia 18 → 17 sin repetir el
destino después de la confirmación. La curación varía: no fijar 42 HP como efecto
constante por haberlo observado en la primera prueba.
La consulta real de Esp.Madera anunció «Pueden equiparlo: Crono» sin cambiar el
arma equipada ni consumir la pieza de inventario. La copia de prueba (PID 10316)
se cerró al terminar y su autorun volvió a `test/discover-room.lua`; no reutilizar ese
PID sin comprobar el proceso real.
Los personajes, técnicas e inventario de esa prueba no representan la partida
real. La prueba de campo empezó con Ciclón pendiente, sin desbloquear nada al usuario.

Activación: ejecutar `recargar-lector.cmd` y cerrar/abrir el menú, o iniciar una
sesión nueva con el acceso normal. Falta la valoración del usuario con NVDA.
Las próximas funciones pendientes son Configuración, Grupo, Guardar, combate y
navegación fuera de las dos plantas; conservar también la valoración pendiente de
sonidos de la planta baja.

Unidades reversibles: retirar carga y tick de `tickInventory` en
`lector-snes9x.lua` desactiva solo Objetos; retirar `tickTech` desactiva solo
Técnicas. Los métodos compartidos del observador pueden conservarse. No hubo
cambios de DLL, ROM o partidas del usuario. El prototipo sigue sin commits y
`tools/` sigue ignorado por Git.

