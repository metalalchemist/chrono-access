# Referencias e investigación de otros lectores

[Continuar el proyecto](../continuar%20chrono.md) · [Índice documental](README.md)

Las notas siguientes conservan la evidencia y el alcance de cada etapa. Los pendientes de una etapa pueden estar resueltos en documentos posteriores; el estado actual se consulta en el documento de continuación.

Las rutas de código escritas entre comillas invertidas parten de `D:\gt\vemovie`, salvo indicación distinta.

## Investigación sobre Pokémon Access

El usuario preguntó por Pokémon Essentials Access al inicio y más tarde por «pokemon access de mwive». En esa segunda consulta se interpretó que se refería al repositorio **nuive/pokemon-access**; no dar por hecho que ambos proyectos son el mismo.

En el código consultado de nuive/pokemon-access se observó esta arquitectura:

- Un adaptador por juego conoce las estructuras de memoria y obtiene personas/objetos, colisiones, conexiones, cambios de mapa y carteles.
- Combina coordenadas de eventos del mapa con coordenadas vivas de objetos en RAM. Usa nombres de sprites y correcciones manuales cuando hacen falta.
- Una capa común une esa información. Decir «dos arriba, tres a la derecha» puede ser solo la diferencia de coordenadas; no significa que exista un camino libre.
- El cálculo de rutas usa una cuadrícula de colisiones, considera objetos y conexiones y aplica A*. Después agrupa las direcciones para hablar el recorrido.

La idea útil para Chrono Trigger es conservar una capa común de distancias/sonidos y ampliar la extracción de mapas/eventos. Ya leemos posición y terreno real; los muebles de las dos plantas aún tienen anotaciones manuales en `room-profiles.lua`. No es necesario escribir una biblioteca de distancias distinta para cada objeto. Sí falta identificar de forma general conexiones y tipos/nombres de eventos para ampliar la navegación a más mapas.

Fuentes primarias ya consultadas:

- https://github.com/nuive/pokemon-access/blob/master/game/common/gsc.lua
- https://github.com/nuive/pokemon-access/blob/master/pokemon.lua
- https://github.com/nuive/pokemon-access/blob/master/gb.lua
- https://github.com/dscotton/ct_disassembly
- https://github.com/agehring80/snes9x-lua
- https://github.com/ethindp/prism

