# 26. Equipo dentro del comercio

La opción silenciosa que el usuario encontraba al pulsar abajo desde
Comprar/Vender era el selector de Equipo. Las capturas y las rutinas nativas
confirmaron que el comercio tiene sus propias pantallas de equipo; el lector
de equipo del menú principal no las seguía. Comprar y Vender ya funcionaban.

## Uso

1. Habla con un vendedor. Izquierda/derecha cambia entre Comprar y Vender.
2. Pulsa abajo para Equipo. Se anuncia el personaje y sus estadísticas.
3. A entra en sus piezas. Arriba/abajo recorre arma, casco, armadura y accesorio;
   izquierda/derecha cambia de personaje cuando hay más de uno.
4. A muestra las alternativas disponibles, cantidad y comparación de estadísticas.
5. A equipa; B cancela. El lector distingue el cambio confirmado de la previsualización.
6. B desde las piezas regresa a los personajes; otro B vuelve a Comprar/Vender.

Si no hay alternativas, se anuncia. Las confirmaciones se conservan en voz:
la lectura de la pieza al regresar se añade a la cola sin interrumpirlas.
No se necesitan sonidos ni atajos nuevos. Recargar con `recargar-lector.cmd`
o abrir normalmente el juego activa la ampliación.

## Código y datos

`tools/chrono-access/shop-equipment-reader.lua` instala observadores específicos
del comercio. `shop-reader.lua` lo carga, evita leer selecciones comerciales
antiguas mientras se usa Equipo y añade «Abajo: Equipo» a la ayuda inicial.
El lector de estado/equipo del menú principal permanece independiente.

Los hooks C2D6C6, C2D718 y C2D77B identifican personaje, pieza y alternativa.
C2E106 captura las piezas después de actualizar personaje y lista; C2E188
captura la alternativa después del cálculo. La confirmación se observa en
C2D7B5, después de guardar la pieza y recalcular; C2D7BB distingue cancelación
y C2D738 detecta una ranura sin alternativas. Todas esas firmas se validan.

La selección de personaje usa 7E0D5F y el índice nativo; las piezas actuales
se leen del registro canónico 7E2600 + ID×50 hexadecimal. Sus estadísticas
ajustadas están en +36 hexadecimal. La comparación usa ese registro real y
7E9B1C, no el búfer de pantalla 7E9A90, que el comercio sobrescribe durante
la previsualización. Cantidad/posición se contrastan con la lista nativa.
Las descripciones se reutilizan del observador común cuando están disponibles.
El módulo de producción no escribe RAM ni genera pulsaciones.

## Verificación

Se usó solamente el emulador compartido y el caso aislado
`tools/chrono-access/test/shop-equipment-check/`. No se operó la partida del usuario.
El guion activó el vendedor nativo tras reubicar al jugador: no acredita
un recorrido continuo a pie. La compra y el cambio posteriores se hicieron
con botones y operaciones nativas, sin alterar dinero, equipo ni estadísticas
mediante escrituras de prueba.

Se comprobaron los cuatro tipos de pieza, ranura sin alternativas, compra
del Kimono Kárate por 300 G, comparación, cancelación, confirmación y regreso
al comercio. El dinero pasó de 400 a 100 G por la compra y no cambió al equipar.
La previsualización y la cancelación conservaron la Túnica de Piel (ID 91)
y defensa 16; confirmar colocó Kimono Kárate (ID 92), defensa 21, retiró una
unidad del inventario y devolvió la pieza anterior.

Evidencia conservada:

- `character`, `weapon-slot`, `helmet-slot`, `armor-slot`, `accessory-slot`,
  `empty-accessory`: RAM de navegación y ausencia de alternativas.
- `purchase`, `candidate`, `cancel`, `candidate-again`, `equipped`,
  `return-character`, `return-top`: RAM del ciclo real de compra y equipo.
- `reader-validation.txt`: llamadas del lector durante todo ese ciclo.
- `full-reader.txt` y `full-reader-log.txt`: lector principal completo con todos
  sus módulos, voz/audio silenciados y llamadas registradas. Se comprobó la
  comparación inversa 21→16 y que la voz de retorno usa `interrupt=false`.
- `full-*`: RAM de esa comprobación de integración; `sessions/`: sesión archivada.

`test_shop_equipment.py` añade nueve pruebas sobre selección, comparación,
cambio de personaje, confirmación/cancelación, firmas, evidencia nativa e
integración completa. El cambio de personaje adicional se probó con fixture
sintético; la ronda nativa tenía solo a Crono.
Suite completa: 212 pruebas aprobadas en `suite.txt`. También pasó
`python tools/chrono-access/test/check_audio.py`.
El compartido quedó cerrado. Falta valorar las nuevas locuciones con NVDA real.

## Reversión y pendientes

Para retirar esta ampliación, quitar la creación y llamada de `tickEquipment`
en `shop-reader.lua` y la indicación «Abajo: Equipo». El módulo nuevo deja de
cargarse; el equipo del menú principal y la compra/venta siguen independientes.

La entrega 25 había interpretado el uso de arriba/abajo como una confusión
al cambiar entre Comprar y Vender. Las capturas posteriores mostraron una
carencia real del selector de Equipo; esta entrega la corrige.
Quedan las valoraciones con NVDA de esta ampliación, premio de Gato, carrera
y soda. Baile, desafíos de la tienda de los horrores y escena de Lucca siguen pendientes.
