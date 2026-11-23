-- Same samples, volume factors and stereo directions used by room-reader.
return {
 {sound='wall_left',label='Pared a la izquierda. Aumenta al acercarte.',gain=0.6,pan=-1},
 {sound='wall_right',label='Pared a la derecha. Aumenta al acercarte.',gain=0.6,pan=1},
 {sound='wall_up',label='Pared al norte. Aumenta al acercarte.',gain=0.6},
 {sound='wall_down',label='Pared al sur. Aumenta al acercarte.',gain=0.6},
 {sound='wall_hit',label='Choque contra una pared.'},
 {sound='object_hit',label='Choque contra un mueble, objeto o persona.'},
 {sound='bed',label='Cama. Señal de proximidad.'},
 {sound='clock',label='Reloj. Señal de proximidad.',ambient=true},
 {sound='stairs',label='Escalera o aviso de entrada en una zona.'},
 {sound='connection',label='Conexión, paso o cambio de zona.'},
 {sound='person',label='Persona. Señal de proximidad.'},
 {sound='door',label='Puerta o salida. Señal de proximidad.'},
 {sound='item',label='Objeto o cofre. Señal de proximidad.'},
 {sound='sign',label='Cartel. Muestra disponible; algunas zonas aún no lo usan.'},
 {sound='furniture',label='Mueble. Señal de proximidad.',gain=0.4},
 {sound='games',label='Juego o encargado de un minijuego.'},
 {sound='bell_timing',label='Pitido de tiempo o indicación de un minijuego.'},
 {sound='enemy',label='Enemigo. Dos tonos más grave que una persona.'},
 {sound='save_point',label='Punto de guardado. Señal de proximidad.'}
}
