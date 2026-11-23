# 63. Dorino, Porre y Desierto Hundido

Doce mapas de 600 d. C. tienen 56 referencias nuevas: vivienda, casa del anciano,
posada y tienda de Dorino; casa del anciano, café, posada y tienda de Porre;
Villa Fiona; entrada y dos niveles del Desierto Hundido.

## Uso

Control+F6 recorre referencias y Control+F5 repite la seleccionada.
Las personas conservan sus números. Acércate por un lado libre y habla con A.

En la casa del anciano de Porre las personas aparecen solo por número.
Se retiró la referencia adicional del intercambio a petición del usuario.
Si llevas el objeto solicitado,
el lector lee las opciones nativas. Elige con el control: el lector no entrega
objetos ni decide por ti. La casa del anciano de Dorino también tiene orientación.

Hay referencias de salidas, mesas, camas, escritorios y mostradores. Los
diálogos y el comercio conservan sus lectores existentes. La posada de Dorino
tiene dormitorio al norte del mismo mapa; se excluyen los actores de escenas
remotas. En Porre, la recepción está al sureste y las camas al oeste.

La entrada del desierto conecta con el primer nivel. Su escalera norte vuelve
al exterior y el paso sur lleva al nivel profundo. La escalera noroeste del
nivel profundo regresa al primero. La arena mueve al grupo; las distancias
directas requieren seguir paredes y pasos del terreno. Los encuentros y
combates corresponden al juego.

Trece cofres ordinarios: dos en Villa Fiona, cuatro en el primer nivel del
desierto y siete en el profundo. Dos arcones sellados en Porre usan sus flags
individuales. Conservan números fijos por mapa; abiertos dicen «abierto» y
dejan de sonar. No se revelan contenidos. La decoración nativa del nivel
profundo no se anuncia como personas.

## Evidencia y límites

Las tablas de salidas y cofres proceden de la ROM local. Capturas e imágenes:
test/future-check/villages63-map*. Se usó exclusivamente la copia aislada y
silenciada de test/emulador-pruebas.ps1. Las capturas de 140, 141, 152 y 153
son investigación adicional; esos mapas no recibieron perfiles.

Se comprobaron interacciones nativas con posiciones reubicadas:
- Porre, intercambio: sin objeto se lee la petición; con objeto preparado solo
  en pruebas se leen las tres opciones. Rechazar conserva objeto y oro; aceptar
  consume el objeto y cambia el oro según la opción. Capturas trade-choices,
  trade-decline y trade-accept, con prefijo villages63-.
- Porre, descanso: oferta, pago de 20 G y recuperación de vida/magia del grupo.
  Capturas villages63-porre-inn-offer y villages63-porre-inn-rest.
- Dorino, tienda: bienvenida y transición al comercio. El arnés no incorpora
  el lector de comercio; su cobertura se conserva en las pruebas anteriores.

Los ensayos de aproximación al servicio de Dorino no abrieron su oferta.
No prueban un descanso allí. La referencia procede del actor nativo 44 que
invoca la función de alojamiento; falta verificar el acceso caminando con
control. No se añadió un anuncio especial de descanso a estas posadas;
los diálogos y estadísticas conservan su lectura normal.

Quedan pendientes recorridos completos con control, descanso de Dorino,
encuentros y combate del desierto, y valoración auditiva con NVDA.
Las capturas preparadas no prueban recorridos ni victorias.

Validación: 448 pruebas ejecutadas, 440 aprobadas y ocho fallos anteriores
en test_walk_trace.py. Esos tests suponen registro activado al iniciar,
mientras walk-trace.lua lo desactiva por defecto; esa política ya constaba
en la entrega 62 y no se cambió. Las nueve pruebas nuevas pasan.
Sintaxis Lua, audio nativo y reproducción silenciada de doce mapas aprobados.
El audio usa proximidad simulada, no acredita una caminata.
ROM, SRAM y partidas protegidas conservaron sus hashes desde antes de investigar.

Resultados: test/future-check/unit-validation-63.txt, audio63-replay.txt,
protected-hashes-63-before.json y protected-hashes-63.json.
Repetir: python tools/chrono-access/test/validate-villages63.py.
Devuelve fallo mientras sigan las ocho pruebas anteriores del registro.

## Mantenimiento y reversión

Producción: bloque BEGIN VILLAGES63 a END VILLAGES63 en room-profiles.lua.
Generador: test/build-villages63.py. Pruebas: test/test_villages63.py.
Audio: test/verify-villages63-audio.py. Investigación: research-villages63.py,
capture-villages63.py y capture-villages63-details.py en test/.

Retirar ese bloque y sus herramientas/pruebas retira esta unidad sin cambiar
la cobertura anterior. Copias previas: test/future-check/*-before63.
Conservar evidencias y cambios posteriores. No se modificaron ROM, DLL,
sonidos ni archivos de VeMovie. No se hicieron commits; tools/ está ignorado
por Git y necesita respaldo propio.
