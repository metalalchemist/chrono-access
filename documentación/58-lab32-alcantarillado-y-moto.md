# 58. Lab 32, alcantarillado y carrera de motos

[Continuar](../continuar%20chrono.md) · [Índice](README.md)

Hay orientación sonora en los tres sectores de Lab 32 y las dos plantas del
alcantarillado. La carrera anuncia la posición frente a Patxi, su altura en la
pista, el porcentaje restante, los turbos y la llegada a meta.

## Para jugar

Recarga el lector con `recargar-lector.cmd` si el juego ya estaba abierto.
Control+F5 consulta la referencia seleccionada y Control+F6 cambia de referencia.
Durante la carrera, Control+F5 repite la situación de la moto.

La alcantarilla es opcional en esta etapa. Sus cofres contienen **600 monedas**,
**BandaFuria** y **EspadaRayo** para Crono; son los nombres leídos de esta ROM de
Magno. Con nivel 10–11 es una visita razonable si llevas curación. El jefe puede
dejar a alguien con 1 HP: cura antes de que reciba otro golpe.
La [guía de Sewer Access](https://guides.gamercorner.net/ct/areas/sewer-access)
describe ese ataque y sitúa los enemigos en el nivel de esta etapa.

Entra desde el exterior al sureste de Arris. La planta principal tiene una
escalera al oeste y otra al sur que comunican mediante el pasillo inferior.
Sigue las referencias de las escaleras y rodea las paredes. Hay interruptores
que cambian los pasos. Los cofres del noreste y del sur están en la ruta del jefe.
Las distancias son directas; no calculan un recorrido por los pasillos.

El gato, la lata, el queso y el falso guardado del pasillo inferior tienen señal
de peligro y un nombre que explica la emboscada. **Ese guardado no guarda**.
No se encontró un guardado real en estas dos plantas ni en Lab 32. Puedes guardar
en el mapa exterior antes de entrar. Los guardados reales de las zonas anteriores
conservan su sonido.

Para correr necesitas la Llave de la Moto de Arris y a Crono en el grupo.
Examina la moto desde el sur con A. En esta traducción el rival se llama Patxi.
La moto acelera sola: arriba y abajo cambian tu posición en la pista; B usa uno
de los tres turbos. Si vas detrás, cambia de altura para intentar adelantar;
si vas delante, intenta mantener al rival detrás. Conserva algún turbo para
la parte final. La ayuda es informativa: tú manejas la moto.

## Qué se implementó y comprobó

- `room-profiles.lua`: cinco perfiles y 27 referencias. Las tablas de salidas y
  cofres se leen de la ROM; los actores y eventos se contrastan con capturas
  nativas. El paso este de Lab 32 oeste se ejecuta por evento, fuera de la tabla
  normal de salidas. Cada salida nativa aparece una sola vez; las dos escaleras
  entre plantas tienen destinos físicos distintos. Los cofres abiertos callan.
- `bike-reader.lua`: observa el motor Mode 7 descomprimido, sin escribir RAM ni
  botones. Mapa 271, firmas en `$7E485D` y `$7E4984`. Solo lee la situación después
  de ejecutar la rutina nativa. Posiciones longitudinales de 32 bits en `$51/$76`,
  posiciones transversales en `$4E/$73`, turbos en `$9A`, meta en `$80000`.
- `lector-snes9x.lua`: integra el lector de motos y suspende los lectores de
  menús/combate durante el mapa de la carrera. Su memoria temporal no debe
  interpretarse como nombres, daño o estados de combate.
- Se reutilizan los sonidos originales preparados: puerta, escalera, objeto,
  aviso, juegos y enemigo. No se modificaron MP3, WAV, ROM ni DLL.

La sesión `future-check` recorrió una carrera nativa completa, usando botones
después de preparar la llave y la presentación de Patxi en la copia de pruebas.
Se comprobaron arriba/abajo, los tres consumos de B, los anuncios de posición,
la meta y el regreso nativo a Lab 32. Patxi ganó ese recorrido: no se afirma una
estrategia de victoria ni hay automatización. Evidencias en `test/future-check/`:

| Evidencia | Alcance |
| --- | --- |
| `bike58-trace.csv`, `bike58-reader.txt` | Estados y anuncios durante la carrera nativa final. |
| `bike58-proof-ready-ram.bin`, `bike58-proof-run-ram.bin`, `bike58-proof-end-ram.bin` | Preparación, carrera y regreso al campo; GD del mismo prefijo. |
| `bike58-stage1-ram.bin` a `bike58-stage7-ram.bin` | Estados del motor durante el recorrido. |
| `map-223/224/225/236/237-ram.bin` y sus GD | Cargas nativas independientes de las cinco zonas. |
| `audio58-replay.txt` | Mezclador real silenciado sobre capturas, colocando sintéticamente al líder junto a cada referencia. |
| `unit-validation-58.txt`, `protected-hashes-58.json` | Suite general, sintaxis Lua, audio y protección de ROM/Saves durante la validación final. |

La suite general terminó con **420 pruebas aprobadas**. Los siete casos nuevos cubren salidas/cofres sin duplicados, trampas, cofre abierto,
lectura de la carrera, cadencia, turbos, repetición, firmas y llegada.
La valoración con NVDA y el recorrido completo a pie por la alcantarilla siguen
pendientes. Las cargas de sus mapas no demuestran haber atravesado todos los
pasillos ni haber derrotado al jefe. No se operó la instancia habitual del usuario.

## Reproducir y retirar esta ampliación

`test/build-lab32-sewer.py` reconstruye el bloque de perfiles desde la ROM.
`test/trace-bike58.lua` y `test/seed-bike58.lua` son exclusivos de la copia aislada;
inyectan preparación o botones y nunca se usan en la partida habitual.
Con la sesión de pruebas cerrada, ejecutar:

```powershell
python tools/chrono-access/test/validate-lab32-delivery.py
```

Para retirar solo esta ampliación, elimina el bloque `BEGIN LAB32 SEWER` de
`room-profiles.lua`, la carga de `bikeGame` y su llamada/bloque en el callback de
`lector-snes9x.lua`. `bike-reader.lua` queda entonces sin uso. El resto de lectores
y la ayuda opcional de la rata permanecen independientes. El perfil anterior está
en `test/future-check/room-profiles-before58.lua`.
