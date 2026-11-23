# Estado y pendientes históricos de la casa

[Continuar el proyecto](../continuar%20chrono.md) · [Índice documental](README.md)

Registro histórico: conserva el estado de esa etapa y sus pendientes originales. No representa el estado actual; consulta el documento de continuación antes de retomar.

Las rutas de código escritas entre comillas invertidas parten de `D:\gt\vemovie`, salvo indicación distinta.

## Punto exacto donde dejamos el trabajo

El usuario ya bajó las escaleras del dormitorio de Crono y está en la planta baja de su casa. Confirmó que se leen los diálogos de su mamá y la pantalla para escribir el nombre de la amiga inventora. La última captura muestra la planta baja sin diálogo abierto: cocina arriba a la izquierda, escaleras arriba a la derecha, mesa a la izquierda y sofá rojo a la derecha. No se ha identificado con certeza la posición del personaje en esa captura.

**La orientación sonora ya cubre el dormitorio y la planta baja.** La planta baja tiene paredes por dirección, choques, señales graduales para muebles, personas, reloj, escaleras al dormitorio y salida de la casa. Se anuncia la llegada a cada planta y la salida al exterior. El exterior aún no tiene orientación sonora; tampoco hay rutas guiadas ni distancias habladas.

Después de pedir este documento, el usuario preguntó si podíamos hacer accesible la planta baja antes de cambiar de conversación. Se implementó y verificó en una copia aislada, sin controlar su partida. Para activar la versión nueva en una partida ya abierta, usar `tools/chrono-access/recargar-lector.cmd`. No se ha confirmado todavía con el usuario cómo percibe los nuevos sonidos de esta planta.

Para retomar en una conversación nueva, puede escribir:

> Lee «D:\gt\vemovie\continuar chrono.md» y retoma el proyecto de Chrono Trigger accesible. Ya estoy en la planta baja de la casa. Conserva la lectura y los sonidos que funcionan; revisa los pendientes antes de continuar.

## Qué está implementado y qué falta

| Función | Estado y alcance |
| --- | --- |
| Activo/Lento | Lee el cursor del juego, anuncia cambios y confirmación. Confirmado por el usuario. |
| Pantalla de nombres | Lee letras, edición del nombre y confirmación. Confirmada para Crono y para la amiga inventora en la planta baja. |
| Diálogos de campo | Lee páginas completas usando los caracteres que el propio juego ya ha expandido. Confirmado durante el despertar y en la planta baja. |
| Proximidad en dormitorio | Sonidos graduales de paredes por dirección, cama, reloj y escaleras; personas cercanas detectadas desde memoria. El usuario confirmó que oye los sonidos. |
| Choques en la casa | Golpe para pared o persona/objeto, con intervalo para evitar saturación. |
| Cambios de zona | Avisos de dormitorio, escalera, planta baja y salida de la casa. Comprobados en el emulador aislado. |
| Planta baja | Proximidad de paredes, muebles, reloj, personajes, escaleras y salida. Aviso de llegada: salida al sur, escaleras al noreste. Pendiente de valoración sonora por el usuario. |
| Exterior | Se anuncia que termina la orientación sonora. No hay todavía perfil del mapa exterior. |
| Distancias habladas y rutas | Pendientes. No hay todavía una tecla de consulta de posición ni un planificador de rutas. |
| Estado y equipo | Lectura de estadísticas, piezas disponibles, comparación, descripciones y confirmación/cancelación. Ver ampliaciones superiores. |
| Objetos y Técnicas | Listas, cantidades/costes, descripciones, destinos y uso de campo verificados en copia aislada. Pendiente de valoración con el usuario. |
| Otras opciones y combate | Configuración, Grupo, Guardar y el menú de combate siguen pendientes. |
| Juego completo | No se ha demostrado accesibilidad completa ni compatibilidad con otras traducciones. |

El registro `tools/chrono-access/lector.log`, leído como UTF-8, confirma la secuencia del usuario anterior a esta ampliación (su antiguo aviso de falta de cobertura en planta baja ya se sustituyó):

- «Sales del dormitorio por las escaleras. Fuera de este cuarto todavía no hay orientación sonora. Los diálogos siguen activos.»
- «MAMA: ¡Por fin! Ah, esa inventora amiga tuya…» y «Um…ya sabes… ¡Vaya, he olvidado su nombre!».
- Apertura del editor de nombre con el nombre predeterminado **Lucca**.
- Después, «Nombre: Aucca.» y «Nombre confirmado: Aucca.».
- «MAMA: ¡Eso, Aucca! No olvides que te ha invitado a ver su invento.» y «MAMA: Vete ya y vuelve a la hora de comer.».

El nombre confirmado en ese registro es **Aucca**, posiblemente por una edición durante la prueba. No sustituirlo silenciosamente por Lucca ni asumir que la lectura falló por esa diferencia. Es el estado que anunció el juego a través del lector.

## Siguientes pasos concretos

Primero validar con el usuario la lectura de Objetos y Técnicas tras recargar y
volver a abrir el menú. Los inventarios y técnicas desbloqueados de `test/menu-check/`
son exclusivamente de prueba: no desbloquear técnicas ni añadir objetos al usuario.

La ampliación de planta baja está implementada y verificada en la copia de prueba. El siguiente paso es que el usuario recargue con `recargar-lector.cmd` y valore los sonidos al moverse: si distingue muebles, escaleras y salida, y si los avisos llegan en el momento adecuado. Ajustar volumen o referencias según esa experiencia.

Después pueden abordarse consulta hablada de posición/distancias, selección de destinos y rutas, y el mapa exterior, con evidencia propia de memoria y eventos. La localización 496 observada al salir no significa que ya se tenga un modelo de navegación del exterior. Aún faltan elecciones de diálogo, menús de juego y combate.

Pistas del desensamblado para continuar: `C0A33B` descomprime datos de mapa desde punteros `F61E00` a `7EB500`; `C0A66B` participa en construir información de salidas; el segundo plano de propiedades en `7E7000` tiene un bit 0x10 relacionado con salidas. La conexión de las escaleras puede ser un evento dentro del mismo mapa y no una salida marcada de esa forma. Contrastar antes de generalizar.

