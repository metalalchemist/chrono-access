-- Delivery 71: native exits, captured actors and cave event functions.
return {
 {id="magic71_163",location=163,name="Cueva Mágica, entrada cerrada",article="la ",house="Cueva Mágica",bounds={0,0,1024,1024},
  guidance="La roca del norte cierra la Cueva Mágica. Acércate a ella; la apertura depende de la historia y del grupo. Si no se abre, vuelve al mapa exterior por el sur. Control F6 cambia de referencia y Control F5 consulta dirección y distancia. Las escenas y decisiones siguen en el juego.",
  features={
   {name="Salida al mapa exterior de 600 d. C.",sound="door",box={0,240,256,256}},
   {name="Roca que cierra la cueva",box={96,112,144,144},solid=true},
  }},
 {id="magic71_435",location=435,name="Cueva Mágica, entrada abierta",article="la ",house="Cueva Mágica",bounds={0,0,1024,1024},
  guidance="La entrada de la Cueva Mágica está abierta al norte. El paso del norte entra en la cueva; el borde sur vuelve al mapa exterior de 600 d. C. Control F6 cambia de referencia y Control F5 consulta dirección y distancia.",
  features={
   {name="Salida al mapa exterior de 600 d. C.",sound="door",box={0,208,256,224}},
   {name="Entrada a la Cueva Mágica",sound="door",box={96,48,128,64}},
  }},
 {id="magic71_164",location=164,name="Cueva Mágica, pasaje interior",article="la ",house="Cueva Mágica",bounds={0,0,1024,1024},
  guidance="La Cueva Mágica comunica dos zonas del mapa exterior de 600 d. C. El paso del suroeste vuelve a la entrada abierta. La salida del noreste lleva al otro lado. Sigue los senderos y escaleras entre las paredes; la dirección de una referencia no garantiza un camino recto. Hay enemigos, un cofre sellado y unos restos con una nota. Acércate y pulsa A para interactuar. El cofre depende del progreso del juego y no anuncia su contenido. Control F6 cambia de referencia y Control F5 consulta dirección y distancia.",
  people={[46]=false,[48]=false,[50]=false},
  features={
   {name="Salida al otro lado, mapa exterior de 600 d. C.",sound="door",box={672,112,704,128}},
   {name="Paso a la entrada abierta",sound="door",box={80,320,112,336}},
   {name="Restos con una nota",sound="item",box={704,152,720,168},entity=48,followEntity=true,solid=true},
   {name="Cofre sellado",sound="item",box={336,424,352,440},entity=50,followEntity=true,solid=true,collected={address=0x7F0079,mask=1}},
  }},
}
