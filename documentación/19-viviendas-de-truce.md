# Viviendas este y oeste de Truce

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

Las viviendas **15 y 16** tienen orientación sonora, salida, muebles y personas.
Para distinguirlas, el lector las llama vivienda este y vivienda oeste de Truce,
tanto dentro como en las consultas del exterior. Son nombres de orientación;
la ROM las denomina simplemente «Vivienda» y no se asignó un propietario.

## Uso

- **Control+F5:** consulta la referencia seleccionada; inicialmente es la salida.
- **Control+F6:** recorre cama o camas, cocina, mesa, sillas, vasijas, relojes y habitantes.
- En la vivienda este, la salida está al sur en el paso central, cocina y mesa
  al oeste y cama al noreste. Hay una habitante que se mueve por la sala.
- En la vivienda oeste, la salida está al sureste, cocina al noreste, mesa
  al oeste y dos camas al suroeste. Hay dos habitantes.
- Acércate a una persona, mira hacia ella y pulsa A. Los tres diálogos se
  comprobaron completos con el lector común.

Las referencias de muebles sirven para orientarse y reconocer colisiones;
que un mueble tenga sonido no implica que produzca un mensaje al pulsar A.
Las distancias son directas, no rutas para rodear mesas o personas. Control+F7
mantiene su función del mapa exterior.

## Datos y evidencia

| Vivienda | Mapa | Entrada exterior | Límites `[x1,y1,x2,y2]` |
| --- | --- | --- | --- |
| Este | 000F (15) | (26,16), cerca de la casa de Crono | `[512,304,736,496]` |
| Oeste | 0010 (16) | (24,16) | `[32,560,224,768]` |

Las capturas de entrada muestran al líder en el slot 2, X=624/Y=463,9375 en
la casa este y X=192/Y=703,9375 en la oeste. La consulta anterior de la sesión
del usuario había registrado mapa 15, X=624/Y=441,94: también queda dentro del perfil.

Las dos casas tienen una salida cada una, comprobada en ROM y en el motor:
E5:04C6 para la este, E5:04CD para la oeste; ambas llevan al mapa exterior 496.
Las cajas de salida son `[608,480,640,496]` y `[176,720,208,736]`.
Las tablas F5 de ambos mapas no registran cofres ordinarios. Las capturas iniciales
contienen solo los habitantes visibles además del grupo; no se añadieron cofres ficticios.

Los datos y las pruebas nativas están en `tools/chrono-access/test/truce-houses-check/`:

- `entry15-grid.png` y `entry16-grid.png` documentan los muebles en sus coordenadas.
- `dialogue15-complete`: la habitante habla de los mil años de Guardia, el rey
  XXXIII y su hija. Se conserva la lectura de las dos páginas y el regreso al control.
- `dialogue16-kitchen-complete`: «Esa chica, Lucca, dice que ha hecho el invento de su vida».
- `dialogue16-table-complete`: «¡Soy tan feliz que gritaría!».
- `query16-exit`, `query16-bed`: consultas habladas de salida y cama oeste.
- `bed16-contact`: intento de avanzar 12 fotogramas al este contra la cama desde
  X=96/Y=728; el personaje permanece allí. La geometría y clasificación de cama
  y mesa de las dos viviendas también se contrastan contra los volcados reales.
- `exit15`, `exit16`: cruce de las dos salidas hacia el mapa 496.

La copia viajó entre ambas casas por el exterior. Parte de los ensayos de
diálogo y colisión reubica al personaje cerca del objetivo; no acredita una
ruta continua entre todos los muebles. Los textos se registraron y el mezclador
de señales se sustituyó por uno silenciado. Falta la valoración con NVDA del usuario.

## Código y validación

`room-profiles.lua` añade `truce_house_east` y `truce_house_west`. La casa este
tiene diez referencias fijas y un habitante; la oeste, diez referencias y dos
habitantes. La posición de las personas y el terreno se leen del estado actual.
No se infieren selecciones o mensajes por pulsaciones del control.

`world-model.lua` aplica los nombres diferenciados a los destinos 15 y 16.
Conserva el diccionario nativo «Vivienda», las claves de destino y las rutas.
Las demás viviendas del mundo no reciben esos nombres.

`test_truce_houses.py` añade siete pruebas: cobertura y límites, camas, mesas,
salidas de ROM y ausencia de cofres ordinarios, consultas, tres diálogos y
salidas reales, y nombres únicos en el exterior sin alterar el diccionario.

`python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`:
**147 pruebas aprobadas**. La implementación queda lista para el acceso habitual;
el estado de los procesos se comprueba al terminar y no se presupone en sesiones futuras.

## Activación, protección y reversión

Abrir con `tools/chrono-access/iniciar-lector.cmd` carga los perfiles nuevos.
Si ya se está jugando, `recargar-lector.cmd` actualiza el lector sin reiniciar
el juego. La partida del usuario no se usa en los guiones de prueba.
La instancia habitual estaba abierta al comenzar, pero en la comprobación final
solo quedaba la copia aislada. Se cerró únicamente esa copia tras verificar su
ruta; la activación queda para el siguiente arranque habitual. No se reabrió ni
cargó una partida del usuario para hacer las pruebas.

Los guiones `discover-truce-houses.lua`, `enter-truce-house15.lua`,
`enter-truce-house16.lua`, `check-truce-houses.lua` y `finish-truce-dialogue.lua`
inyectan posiciones o botones únicamente en la copia aislada. Sus autorun y
comandos no se deben utilizar para jugar. Se conservan ROM, partidas y evidencias.
No hubo cambios de configuración de audio; sigue el ensayo de búfer de 128 ms.

Para revertir esta ampliación, retirar los dos perfiles y las dos asignaciones
de nombre por destino en `world-model.lua`. Los lectores de diálogo, guardado,
combate, bosque y casas anteriores permanecen independientes. `tools/` sigue
ignorado por Git; no se hicieron commits de cambios ajenos a esta entrega.
