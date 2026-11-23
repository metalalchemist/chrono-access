# 84. Entradas distintas y puntos brillantes de las cuevas de Zeal

Se corrige el bloqueo de orientación comunicado por el usuario en «Cueva de
las islas de Zeal»: el mapa agrupaba entradas distintas por nombre y mapa
interior, y los puntos brillantes carecían de referencias seleccionables.

Tras salir del primer enlace a la isla intermedia, busca con Control+F6
«Cueva, segundo acceso de la isla intermedia». Está al este, siguiendo el
sendero alrededor de la pared. Control+F7 consulta la ruta del mapa exterior.
Dentro, selecciona el punto brillante del norte para llegar a la isla del
palacio. Los puntos se activan caminando sobre ellos, sin pulsar A.

## Qué cambia

world-model.lua distingue las bocas del mapa 389 por sus coordenadas nativas
de llegada. Las casillas adyacentes que desembocan en el mismo punto siguen
agrupadas. El cambio se limita a las cuevas de Zeal en el exterior 501.
No altera la agrupación de posadas, casas ni otros destinos.

El perfil de la cueva se divide en cuatro sectores físicamente separados.
Cada uno anuncia solo su salida y su punto brillante, con ayuda del destino.
Cruzar el teletransporte cambia el sector anunciado aunque el mapa siga siendo
389. Los actores invisibles del transporte no se numeran como personas.

| Boca exterior | Sector interior | Enlace del punto brillante |
|---|---|---|
| (45,31), desde Kajar | occidental superior | hacia (47,28), isla intermedia |
| (47,28), isla intermedia | central superior | regreso hacia Kajar |
| (51,28), segundo acceso intermedio | occidental inferior | hacia (49,26), isla del palacio |
| (49,26), isla del palacio | oriental superior | regreso a la isla intermedia |

El registro exterior contiene además una boca con llegada (30,45), que se
mantiene separada como acceso adicional del sur. No se certifica su recorrido
y no forma parte de la ruta recomendada. Un perfil de reserva evita atribuir
a ese sector los puntos o salidas de las otras cámaras.

También se añaden puntos brillantes seleccionables a los seis Pasajes/Puentes
de Paso 336, 337, 352, 353, 354 y 356. Sus posiciones proceden del actor nativo
de transporte; distinguen el viaje hacia la superficie y hacia las islas.

## Comprobación

En copia administrada silenciada, historia 160 y entrada preparada desde Kajar:

1. Caminar al primer punto transportó al sector central superior.
2. Salir por el sur llegó al exterior (47,29).
3. Seguir el sendero (sur, este, norte) permitió entrar por la boca (51,28).
4. El segundo punto transportó al sector oriental superior.
5. Salir por el sur llegó a la isla del palacio.

Las capturas finales caves84-first-arrival, other-mouth-enter, second-teleport
y palace-island documentan las transiciones. La captura first-teleport fue
tomada antes de terminar la animación; no se usa como evidencia del destino.
No se operó la partida del usuario ni se pulsaron sus controles.

Cuatro pruebas nuevas verifican selección separada de las bocas y ruta a la
segunda; referencias limitadas al sector correcto; los seis puntos de paso;
anuncio de llegada y consultas F6/F5. Ocho pruebas de Zeal y seis del mapa
exterior pasan. La comparación de puertas nativas de Zeal agrega los sectores
del mapa 389, conservando la exigencia de una referencia por salida real.

Producción: world-model.lua y rooms/profiles/zeal.lua. Generador:
test/build-zeal75.py. Reversión independiente: restaurar esos archivos y
test/test_zeal75.py desde test/future-check/caves84-before; retirar test_caves84.py
y este resumen. Conservar las capturas. Cambios al arrancar o recargar lector.

Suite final conjunta: 561 pruebas, 553 aprobadas y los ocho fallos previos
de test_walk_trace; sin fallos nuevos. Recibo: unit-validation-83-84.txt.
