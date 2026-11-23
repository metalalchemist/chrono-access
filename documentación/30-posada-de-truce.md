# Posada de Truce

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

La posada de Truce tiene orientación sonora en el salón, el rellano y el
dormitorio. El lector distingue al posadero y los clientes, lee la oferta y
sus opciones, y anuncia el descanso después del pago y la recuperación reales.

## Para jugar

- En el exterior, selecciona «Posada Truce» con Control+F6 y consulta con
  Control+F5. Control+F7 conserva el cálculo de ruta del exterior.
- Dentro, Control+F5 consulta la referencia y Control+F6 pasa a la siguiente.
  La primera referencia del salón es la salida; después vienen la escalera
  y la barra del posadero. Las distancias son directas, no rutas entre muebles.
- El posadero está al noroeste, detrás de la barra. Habla mirando al norte.
  La oferta nativa dice «La noche son 10 G.» y empieza en «Me quedo».
  Abajo selecciona «Me voy»; arriba vuelve a «Me quedo». Confirma con A.
- Al descansar, el juego cobra y traslada a Crono al dormitorio. El aviso
  de descanso espera el regreso del control allí y la vida y magia al máximo.
- La escalera está al noreste del salón: alcanza su acceso y avanza al este,
  después al norte. En el rellano, la puerta del dormitorio está al norte.
  Para regresar, baja por la puerta sur del dormitorio; ve al este del
  rellano, al sur y después al oeste por la escalera.
- Hay tres camas y un arcón sellado al noreste del dormitorio. A lee su
  mensaje; la accesibilidad no elimina el sello del juego.

## Datos y evidencia del motor

Todo el interior usa el mapa **12**, con tres perfiles sin solapamientos:

| Zona | Límites `[x1,y1,x2,y2]` | Referencias |
| --- | --- | --- |
| Salón | `[784,256,1024,496]` | Salida, escalera, barra, mesa, sillas, taburetes, sofá, piano y chimenea. |
| Rellano | `[848,160,1024,256]` | Puerta del dormitorio, regreso por la escalera y persona del pasillo. |
| Dormitorio | `[800,32,1024,160]` | Regreso al rellano, tres camas, arcón, cómoda y reloj. |

Personas: slot 16, posadero; 18, persona junto al piano; 20, persona del
rellano; 22 y 24, clientes. Sus posiciones se leen de la RAM actual. El arcón
es el slot 34, X=1000/Y=79,9375: tiene referencia de objeto y no de persona.
Los slots 28, 30 y 32 no se anuncian como personas durante la escena de dormir.
El arcón requiere entidad visible para emitir su señal.

La salida de ROM está en **E5:04AA**, casillas X=51/Y=30, destino 496;
su referencia ocupa `[816,480,848,496]`.

Evidencias en `tools/chrono-access/test/truce-inn-check/`:

- `entry`, `stairs-east` y `bedroom-north`: RAM y capturas con cuadrícula.
- `keeper-offer`, `keeper-decline-choice`, `keeper-declined`: lectura de
  ambas opciones y rechazo sin gastar los 400 G iniciales.
- `rest-before` y `rest-complete`: 400→390 G, vida 1→70 y magia 0→8;
  al final, diálogo cerrado y control devuelto en el dormitorio.
- `insufficient-offer` y `insufficient-result`: con 5 G, «¡No tienes dinero!»;
  permanecen los 5 G, 1 de vida y 0 de magia.
- `sealed-chest-message` y `sealed-chest-complete`: mensaje de la caja familiar
  y «Sellado por una fuerza misteriosa…».
- `reader-validation.txt`: texto, entradas de zona y seguimiento del descanso.
  `sessions/` conserva los arranques de prueba y sus configuraciones.
- `confirmed-rest-complete`: recuperación y posición final; el bloque
  correspondiente del registro contiene un único aviso después de entrar
  en el dormitorio. `query-bed-final`, `query-bed-next` y `query-exit`
  conservan las consultas habladas. `exit-native` acredita el regreso al mapa 496.

Se inició una partida de ensayo y se utilizó el cargador nativo para llegar
a la posada; esto no acredita una ruta continua desde la casa de Crono.
Las pruebas reubican al personaje en algunos puntos y alteran dinero, vida
y magia exclusivamente en el caso aislado. Los recorridos de la escalera
y el descanso se ejecutan con el motor real. El audio se sustituye por un
mezclador silenciado: falta la valoración con NVDA del usuario.

## Código y verificación

`room-profiles.lua` añade los tres perfiles. `inn-reader.lua` observa la
oferta nativa cerca de la barra, el descenso de 10 G, la recuperación del
grupo y el regreso del control en el dormitorio. No interpreta botones
para decidir una selección. Una recarga a mitad del descanso no inventa
un pago anterior. `lector-snes9x.lua` llama al observador por fotograma.
El pago observado se conserva durante la recarga nativa del mapa al dormir;
el seguimiento caduca si no se alcanza el resultado esperado.

`test_truce_inn.py` comprueba límites y personas, geometría capturada,
visibilidad del arcón, consultas, silencio durante diálogo, salida de ROM,
requisitos del aviso, rechazo, recarga, pago, recuperación y falta de dinero.
Las pruebas del observador combinan capturas reales con cambios sintéticos;
el registro del ensayo acredita por separado su ejecución dentro del emulador.

Herramientas del ensayo: `start-truce-inn.lua`, `check-truce-inn.lua`,
`drive-truce-inn.py` e `inspect-truce-inn.py`. Son herramientas de prueba,
no archivos para cargar en la partida habitual. Antes de ejecutar la suite
completa, cerrar el emulador de pruebas: las pruebas de su gestor operan
sobre el mismo runtime compartido.

Verificación final: `python -m unittest discover -s tools/chrono-access/test -p 'test_*.py' -q`,
**240 pruebas aprobadas en 20,313 segundos**.
El registro completo está en `truce-inn-check/suite-validation.txt`.
`python tools/chrono-access/test/check_audio.py` también pasa: audio nativo,
reloj monótono y cierre del hilo. Se cerró la instancia de pruebas con el gestor
y la comprobación final no encontró procesos Snes9x abiertos.

## Activación y reversión

El siguiente arranque con `iniciar-lector.cmd` incorpora la posada.
Si el juego habitual está abierto, `recargar-lector.cmd` actualiza el lector
sin reiniciar ni cargar una partida. No se cambian ROM, partidas ni audio habitual.

Para revertir, retirar los tres perfiles `truce_inn_*` y la inicialización
y llamada a `tickInn` en `lector-snes9x.lua`; después puede retirarse
`inn-reader.lua`. Diálogos y orientación anteriores conservan sus módulos.
No se hicieron commits de cambios ajenos; `tools/` continúa ignorado por Git.
