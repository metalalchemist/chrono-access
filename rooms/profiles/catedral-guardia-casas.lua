return {
-- Cathedral exits and treasure addresses read from the Magno ROM.
 {id="cathedral_129",name="nave de la catedral",article="la ",location=129,bounds={0,0,1024,1024},
  house="la catedral",people={[24]=true,[28]="Objeto brillante en el suelo; examina con A"},
  nonPeople={[28]=true},personSounds={[28]="item"},processingPresence={[28]=true},
  guidanceWhenVisible={{entity=28,sound="item",text="Hay un objeto brillante en el suelo. Puedes localizarlo con Control F6 y consultar su distancia con Control F5."}},
  guidance="Habla con las personas para descubrir las pistas. Piano u órgano al noroeste: examina con A mirando al norte cuando puedas acceder. El mecanismo está relacionado con el acceso oculto del noreste. Salida al exterior al sur. Las distancias son directas, no rutas por los pasillos.",features={
  {name="Paso a mapa exterior de 600",sound="door",box={112,480,144,496}},
  {name="Acceso oculto a los primeros pasillos; relacionado con el piano",sound="connection",box={192,112,224,128}},
  {name="Piano u órgano de la nave; examina con A mirando al norte",sound="furniture",box={32,112,64,144},solid=true},
  {name="Altar de la nave",sound="furniture",box={96,112,160,144},solid=true},
 }},
 {id="cathedral_130",name="primeros pasillos de la catedral",article="los ",location=130,bounds={0,0,1024,1024},
  house="la catedral",guidance="Entrada de la nave al sureste. Habitaciones laterales al oeste y al este, en dos alturas; escalera hacia el laberinto al norte. Hay enemigos en los pasillos. Las distancias son directas, no rutas por los pasillos.",features={
  {name="Paso a sala este de la catedral",sound="door",box={848,368,880,384}},
  {name="Paso a dormitorio de la catedral",sound="door",box={848,192,880,208}},
  {name="Paso a tesorería de la catedral",sound="door",box={400,368,432,384}},
  {name="Paso a comedor de la catedral",sound="door",box={400,192,432,208}},
  {name="Paso a nave de la catedral",sound="door",box={848,736,880,752}},
  {name="Paso a laberinto del piano de la catedral",sound="door",box={624,64,656,80}},
  {name="Cofre 1 de primeros pasillos de la catedral",sound="item",box={544,128,560,144},solid=true,treasure=0xF5F486},
  {name="Cofre 2 de primeros pasillos de la catedral",sound="item",box={560,672,576,688},solid=true,treasure=0xF5F48A},
  {name="Cofre 3 de primeros pasillos de la catedral",sound="item",box={592,672,608,688},solid=true,treasure=0xF5F48E},
 }},
 {id="cathedral_131",name="laberinto del piano de la catedral",article="el ",location=131,bounds={0,0,1024,1024},
  house="la catedral",people={[16]=false,[18]=false,[22]=false,[24]=false,[56]=false,[72]=false},guidance="Sube la escalera central desde la entrada sur. Explora los corredores laterales y sus mecanismos. Piano u órgano en la sala central: examina con A mirando al norte. Busca el paso oculto detrás del altar; los mecanismos pueden cambiar los pasos y las barreras. La salida hacia la antesala está al norte. Las distancias son directas, no rutas por los pasillos.",features={
  {name="Paso a primeros pasillos de la catedral",sound="door",box={336,736,368,752}},
  {name="Paso a antesala de la catedral",sound="door",box={336,80,368,96}},
  {name="Cofre 1 de laberinto del piano de la catedral",sound="item",box={256,112,272,128},solid=true,treasure=0xF5F492},
  {name="Cofre 2 de laberinto del piano de la catedral",sound="item",box={272,112,288,128},solid=true,treasure=0xF5F496},
  {name="Cofre 3 de laberinto del piano de la catedral",sound="item",box={416,304,432,320},solid=true,treasure=0xF5F49A},
  {name="Cofre 4 de laberinto del piano de la catedral",sound="item",box={64,512,80,528},solid=true,treasure=0xF5F49E},
  {name="Extremo norte del pasillo estrecho del oeste",sound="connection",box={96,176,112,192}},
  {name="Extremo sur del pasillo estrecho del oeste",sound="connection",box={96,288,112,304}},
  {name="Extremo norte del pasillo estrecho del este",sound="connection",box={576,176,592,192}},
  {name="Extremo sur del pasillo estrecho del este",sound="connection",box={576,288,592,304}},
  {name="Cruce del corredor inferior; hacia las escaleras laterales",sound="connection",box={336,544,352,560}},
  {name="Interruptor de calavera del noroeste; examina con A mirando al norte",sound="connection",box={192,128,208,152},entity=28},
  {name="Interruptor de calavera del este; examina con A mirando al norte",sound="connection",box={544,288,560,312},entity=48},
  {name="Piano u órgano del laberinto; examina con A mirando al norte",sound="furniture",box={256,288,288,320},solid=true},
  {name="Pared detrás del altar; busca el paso oculto relacionado con el piano",sound="connection",box={336,256,368,288}},
  {name="Punto de guardado junto al pie de la escalera",sound="save_point",box={272,656,288,680},entity=56},
 }},
 {id="cathedral_132",name="antesala de la catedral",article="la ",location=132,bounds={0,0,1024,1024},
  people={[16]=false},
  house="la catedral",guidance="Entrada del laberinto al sur. Continúa al norte hasta la puerta del santuario. Hay enemigos en el recorrido. Las distancias son directas, no rutas por los pasillos.",features={
  {name="Paso a laberinto del piano de la catedral",sound="door",box={112,992,144,1008}},
  {name="Paso a santuario de la catedral",sound="door",box={112,608,144,624}},
  {name="Punto de guardado antes del santuario",sound="save_point",box={48,624,64,648},entity=16},
 }},
 {id="cathedral_198",name="santuario de la catedral",article="el ",location=198,bounds={0,0,1024,1024},
  house="la catedral",guidance="Regreso por el sur. Cofre al norte; los personajes y el diálogo dependen del avance de la historia. Las distancias son directas, no rutas por los pasillos.",features={
  {name="Paso a antesala de la catedral",sound="door",box={112,400,144,416}},
  {name="Cofre 1 de santuario de la catedral",sound="item",box={192,144,208,160},solid=true,treasure=0xF5F582},
 }},
 {id="cathedral_199",name="comedor de la catedral",article="el ",location=199,bounds={0,0,1024,1024},
  house="la catedral",guidance="Regreso a los primeros pasillos por el sur. Habla con los habitantes para investigar la catedral. Las distancias son directas, no rutas por los pasillos.",features={
  {name="Paso a primeros pasillos de la catedral",sound="door",box={368,208,400,224}},
 }},
 {id="cathedral_200",name="dormitorio de la catedral",article="el ",location=200,bounds={0,0,1024,1024},
  house="la catedral",guidance="Regreso a los pasillos al sur. Dos cofres al norte. Busca el acceso oculto al este, junto a la pared; lleva a otra habitación. Las distancias son directas, no rutas por los pasillos.",features={
  {name="Paso a primeros pasillos de la catedral",sound="door",box={624,208,656,224}},
  {name="Paso oculto en la pared este a la habitación secreta",sound="connection",box={752,144,768,160}},
  {name="Cofre 1 de dormitorio de la catedral",sound="item",box={576,112,592,128},solid=true,treasure=0xF5F586},
  {name="Cofre 2 de dormitorio de la catedral",sound="item",box={688,112,704,128},solid=true,treasure=0xF5F58A},
 }},
 {id="cathedral_201",name="tesorería de la catedral",article="la ",location=201,bounds={0,0,1024,1024},
  house="la catedral",guidance="Tres cofres al norte. Regreso a los primeros pasillos por el sur. Puede haber enemigos. Las distancias son directas, no rutas por los pasillos.",features={
  {name="Paso a primeros pasillos de la catedral",sound="door",box={368,464,400,480}},
  {name="Cofre 1 de tesorería de la catedral",sound="item",box={384,352,400,368},solid=true,treasure=0xF5F58E},
  {name="Cofre 2 de tesorería de la catedral",sound="item",box={400,352,416,368},solid=true,treasure=0xF5F592},
  {name="Cofre 3 de tesorería de la catedral",sound="item",box={416,352,432,368},solid=true,treasure=0xF5F596},
 }},
 {id="cathedral_202",name="sala este de la catedral",article="la ",location=202,bounds={0,0,1024,1024},
  house="la catedral",guidance="Regreso a los primeros pasillos por el sur. Puede haber enemigos. Las distancias son directas, no rutas por los pasillos.",features={
  {name="Paso a primeros pasillos de la catedral",sound="door",box={624,464,656,480}},
 }},
 {id="cathedral_203",name="habitación oculta de la catedral",article="la ",location=203,bounds={0,0,1024,1024},
  people={[20]=false,[22]=false},
  friendlyWhen={[30]={address=0x7F00FE,mask=0x80}},
  house="la catedral",guidance="Habitación tras el paso oculto del dormitorio. Dos cofres al norte. Regreso al dormitorio por el sur. Puede haber enemigos y escenas. Las distancias son directas, no rutas por los pasillos.",features={
  {name="Paso a dormitorio de la catedral",sound="door",box={864,384,912,400}},
  {name="Cofre 1 de habitación oculta de la catedral",sound="item",box={832,128,848,144},solid=true,treasure=0xF5F59A},
  {name="Cofre 2 de habitación oculta de la catedral",sound="item",box={928,128,944,144},solid=true,treasure=0xF5F59E},
  {name="Estatua del fondo",sound="furniture",box={872,80,920,144},solid=true,entity=20},
 }},

 {id="truce_shop600",name="tienda de Truce de 600",article="la ",location=118,bounds={816,48,976,224},
  house="la tienda de Truce de 600",people={[16]=false,[18]=true,[20]=true},
  guidance="Salida al sur. Mostrador al norte. Para hablar, acércate a una persona y pulsa A. En el comercio, izquierda y derecha eligen Comprar o Vender; abajo abre Equipo. Las distancias son directas, no rutas entre muebles.",features={
  {name="Salida al mapa exterior de 600",sound="door",box={880,208,912,224}},
  {name="Frente del mostrador",sound="connection",box={880,144,912,160}},
  {name="Mostrador",sound="furniture",box={832,112,960,144},solid=true},
  {name="Vasijas del oeste",sound="furniture",box={816,144,832,160},solid=true},
  {name="Vasija junto al mostrador",sound="furniture",box={848,144,864,160},solid=true},
  {name="Vasijas del este",sound="furniture",box={960,112,976,144},solid=true},
  {name="Estantería oeste",sound="furniture",box={832,48,872,96},solid=true},
  {name="Estantería este",sound="furniture",box={920,48,952,96},solid=true},
  {name="Silla del este",sound="furniture",box={960,144,976,176},solid=true}
 }},
 {id="truce_inn600_saloon",name="salón de la posada de Truce de 600",article="el ",location=116,bounds={64,304,480,496},
  house="la posada de Truce de 600",people={[16]=true,[20]=false,[22]=true,[24]=true,[26]=true,[28]=true,[30]=true,[32]=true,[34]=true},
  guidance="Salida al sur. Recepción al oeste. Escalera al noroeste: desde su pie avanza al este para subir al dormitorio. Habla con las personas para conocer las noticias de Truce. Las distancias son directas, no rutas entre muebles.",features={
  {name="Salida al mapa exterior de 600",sound="door",box={208,480,240,496}},
  {name="Pie de la escalera al dormitorio; avanza al este para subir",sound="stairs",box={80,368,96,384}},
  {name="Parte alta de la escalera al dormitorio",sound="stairs",box={128,320,144,352}},
  {name="Frente del mostrador de recepción",sound="connection",box={152,432,200,448}},
  {name="Mostrador de recepción",sound="furniture",box={144,416,208,448},solid=true},
  {name="Barra del salón",sound="furniture",box={304,384,464,416},solid=true},
  {name="Chimenea",sound="furniture",box={256,336,288,368},solid=true},
  {name="Cocina",sound="furniture",box={320,320,352,368},solid=true},
  {name="Estantería de la barra",sound="furniture",box={352,304,400,352},solid=true},
  {name="Silla oeste de la barra",sound="furniture",box={320,432,336,464},solid=true},
  {name="Silla central de la barra",sound="furniture",box={384,432,400,464},solid=true},
  {name="Silla este de la barra",sound="furniture",box={432,432,448,464},solid=true}
 }},
 {id="truce_inn600_bedroom",name="dormitorio de la posada de Truce de 600",article="el ",location=117,bounds={544,48,736,224},
  house="la posada de Truce de 600",people={[24]=false},
  guidance="Tres camas al norte. Arcón sellado junto a la cama este: examina con A. Regreso al salón al suroeste, bajando por la escalera hacia el oeste. Puedes hablar con las personas del salón.",features={
  {name="Escalera de regreso al salón; avanza al oeste",sound="stairs",box={624,192,640,224}},
  {name="Cama oeste",sound="bed",box={576,96,608,144},solid=true},
  {name="Cama central",sound="bed",box={624,96,656,144},solid=true},
  {name="Cama este",sound="bed",box={672,96,704,144},solid=true},
  {name="Arcón sellado junto a la cama este; examina con A",sound="item",box={712,112,728,144},solid=true,entity=24},
  {name="Cómoda del dormitorio",sound="furniture",box={552,80,568,112},solid=true},
  {name="Reloj del dormitorio",sound="clock",box={648,64,664,80}}
 }},

 {id="guardia600_119",name="Bosque Guardia de 600",article="el ",location=119,bounds={0,0,768,768},
  house="el Castillo Guardia de 600",people={[70]=false,[124]=false,[126]=false},guidance="Salida sur hacia Truce. Salida norte hacia el castillo. Destello al este y arcón sellado al noreste. Hay encuentros ocultos entre los árboles. Las distancias son directas, no rutas entre árboles.",features={
  {name="Salida sur hacia Truce",sound="door",box={240,752,432,768}},
  {name="Salida norte hacia el castillo",sound="door",box={240,16,352,32}},
  {name="Cruce del sendero sur",sound="connection",box={296,520,328,552}},
  {name="Paso del oeste",sound="connection",box={112,408,144,440}},
  {name="Paso central",sound="connection",box={272,304,288,320}},
  {name="Cruce del norte",sound="connection",box={264,80,296,112}},
  {name="Desvío del sureste",sound="connection",box={480,528,512,560}},
  {name="Arcón sellado del noreste; examina con A",sound="item",box={752,80,768,112},solid=true,entity=124},
  {name="Arbusto del sureste; al examinarlo aparecen enemigos",sound="furniture",box={640,688,656,712},entity=70},
  {name="Destello del este; examina con A",sound="item",box={592,576,608,600},entity=126},
 }},
 {id="guardia600_120",name="sala principal del Castillo Guardia de 600",article="la ",location=120,bounds={0,0,1024,1024},
  house="el Castillo Guardia de 600",

 

 

 
-- BEGIN ZENAN CASTLE 62
 guidanceWhenFlags={{address=8323241,mask=8,text="Si todavía no recibiste la entrega del cocinero, recorre hacia el sur el pasillo oriental, junto a la referencia de entrega. Después puedes salir por la puerta sur y regresar al puente."}},
-- END ZENAN CASTLE 62
 guidance="Salida al exterior al sur. Cuartel al oeste y comedor al este. Accesos a las torres al norte; la torre oeste lleva al rey y la este a la reina. Las distancias son directas.",features={
-- BEGIN ZENAN CASTLE 62
 {name="Pasillo oriental de la entrega; regresa por aquí desde la cocina",sound="connection",box={664,832,696,864}},
 {name="Entrada al pasillo oriental de la cocina",sound="connection",box={664,592,696,624}},
-- END ZENAN CASTLE 62




  {name="Salida al mapa exterior de 600",sound="door",box={480,880,528,896}},
  {name="Paso al cuartel del Castillo Guardia",sound="door",box={192,576,208,608}},
  {name="Paso a la torre oeste del Castillo Guardia",sound="stairs",box={416,128,432,160}},
  {name="Paso a la torre este del Castillo Guardia",sound="stairs",box={608,128,624,160}},
  {name="Paso a la cocina y comedor del Castillo Guardia",sound="door",box={768,544,784,576}},
 }},
 {id="guardia600_121",name="aposentos del rey",article="los ",location=121,bounds={0,0,1024,1024},
  house="el Castillo Guardia de 600",guidance="Regreso a la torre oeste por la puerta del oeste. Cofre al norte. Las distancias son directas.",features={
  {name="Paso a la torre oeste del Castillo Guardia",sound="stairs",box={112,720,128,752}},
  {name="Cofre de aposentos del rey",sound="item",box={288,688,304,704},solid=true,treasure=0xF5F476},
 }},
 {id="guardia600_122",name="aposentos de la reina",article="los ",location=122,bounds={0,0,1024,1024},
  house="el Castillo Guardia de 600",guidance="Desde el rellano de entrada, baja por la escalera este al pasillo inferior. Recorre el pasillo hacia el oeste y sube por la escalera oeste a la alcoba. Cama al norte de la alcoba. Regreso a la torre por la puerta del rellano este. Las distancias son directas, no rutas entre escaleras.",features={
  {name="Paso a la torre este del Castillo Guardia",sound="stairs",box={864,720,880,752}},
  {name="Cofre de aposentos de la reina",sound="item",box={576,688,592,704},solid=true,treasure=0xF5F47A},
  {name="Rellano de entrada a los aposentos",sound="connection",box={840,784,872,808}},
  {name="Parte alta de la escalera este; baja al pasillo inferior",sound="stairs",box={840,816,864,848}},
  {name="Pie de la escalera este; pasillo inferior",sound="stairs",box={832,912,864,936}},
  {name="Centro del pasillo inferior entre las escaleras",sound="connection",box={744,936,776,960}},
  {name="Pie de la escalera oeste; sube hacia la alcoba",sound="stairs",box={656,912,688,936}},
  {name="Parte alta de la escalera oeste; entrada a la alcoba",sound="stairs",box={664,776,696,800}},
  {name="Frente de la cama de los aposentos",sound="connection",box={640,720,664,752}},
  {name="Cama de los aposentos",sound="bed",box={664,656,696,720},solid=true},
 }},
 {id="guardia600_123",name="cocina y comedor del Castillo Guardia",article="la ",location=123,bounds={0,0,1024,1024},
  house="el Castillo Guardia de 600",

 

 

 
-- BEGIN ZENAN CASTLE 62
 guidanceWhenFlags={{address=8323241,mask=8,text="Si ya hablaste con el cocinero, regresa a la sala principal. Sigue el pasillo oriental hacia el sur para que te entregue los víveres antes de salir."},{address=8323241,mask=4,text="El capitán espera provisiones. Acércate a la zona del cocinero y habla con la persona cercana. Sigue el diálogo completo y después vuelve hacia la salida del castillo por el pasillo oriental."}},
-- END ZENAN CASTLE 62
 guidance="Regreso a la sala principal al noroeste. Cofre en la cocina al suroeste. Las distancias son directas.",features={
-- BEGIN ZENAN CASTLE 62
 {name="Zona del cocinero; habla con la persona cercana",sound="connection",box={160,448,176,472},entity=20,followEntity=true},
 {name="Pasillo oeste del comedor, extremo norte",sound="connection",box={48,192,72,216}},
 {name="Pasillo oeste del comedor, tramo intermedio",sound="connection",box={48,304,72,328}},
 {name="Paso entre cocina y comedor",sound="connection",box={40,392,72,416}},
 {name="Mesa oeste del comedor",sound="furniture",box={96,192,192,248},solid=true},
 {name="Mesa este del comedor",sound="furniture",box={224,192,320,248},solid=true},
 {name="Fogones de la cocina",sound="furniture",box={96,408,176,440},solid=true},
-- END ZENAN CASTLE 62




  {name="Paso a la sala principal del Castillo Guardia de 600",sound="door",box={112,96,128,128}},
  {name="Cofre de cocina y comedor del Castillo Guardia",sound="item",box={80,416,96,432},solid=true,treasure=0xF5F47E},
 }},
 {id="guardia600_124",name="cuartel del Castillo Guardia",article="el ",location=124,bounds={0,0,1024,1024},
  house="el Castillo Guardia de 600",guidance="Regreso a la sala principal al norte. Puedes hablar con las personas del cuartel. Las distancias son directas.",features={
  {name="Paso a la sala principal del Castillo Guardia de 600",sound="door",box={512,112,528,144}},
 }},
 {id="guardia600_468_superior",name="rellano superior de la torre este del Castillo Guardia",article="el ",location=468,bounds={0,0,1024,240},
  house="el Castillo Guardia de 600",guidance="La torre este une la sala principal con los aposentos de la reina. Los tramos de escalera conectan rellanos separados. Las distancias son directas.",features={
  {name="Paso a los aposentos de la reina",sound="stairs",box={144,96,160,128}},
  {name="Escalera al rellano de la torre; hacia el rellano intermedio",sound="stairs",box={112,96,128,128}},
 }},
 {id="guardia600_468_intermedio",name="rellano intermedio de la torre este del Castillo Guardia",article="el ",location=468,bounds={0,240,1024,480},
  house="el Castillo Guardia de 600",guidance="La torre este une la sala principal con los aposentos de la reina. Los tramos de escalera conectan rellanos separados. Las distancias son directas.",features={
  {name="Escalera al rellano de la torre; hacia el rellano superior",sound="stairs",box={144,384,160,416}},
  {name="Escalera al rellano de la torre; hacia el rellano inferior",sound="stairs",box={112,384,128,416}},
  {name="Cofre de torre este del Castillo Guardia",sound="item",box={208,448,224,464},solid=true,treasure=0xF5F7AE},
 }},
 {id="guardia600_468_inferior",name="rellano inferior de la torre este del Castillo Guardia",article="el ",location=468,bounds={0,480,1024,768},
  house="el Castillo Guardia de 600",guidance="La torre este une la sala principal con los aposentos de la reina. Los tramos de escalera conectan rellanos separados. Las distancias son directas.",features={
  {name="Escalera al rellano de la torre; hacia el rellano intermedio",sound="stairs",box={144,624,160,656}},
  {name="Paso a la sala principal del Castillo Guardia de 600",sound="stairs",box={112,624,128,656}},
 }},
 {id="guardia600_480_superior",name="rellano superior de la torre oeste del Castillo Guardia",article="el ",location=480,bounds={0,0,1024,240},
  house="el Castillo Guardia de 600",guidance="La torre oeste une la sala principal con los aposentos del rey. Los tramos de escalera conectan rellanos separados. Las distancias son directas.",features={
  {name="Escalera al rellano de la torre; hacia el rellano intermedio",sound="stairs",box={144,96,160,128}},
  {name="Paso a la sala principal del Castillo Guardia de 600",sound="stairs",box={112,96,128,128}},
 }},
 {id="guardia600_480_intermedio",name="rellano intermedio de la torre oeste del Castillo Guardia",article="el ",location=480,bounds={0,240,1024,480},
  house="el Castillo Guardia de 600",guidance="La torre oeste une la sala principal con los aposentos del rey. Los tramos de escalera conectan rellanos separados. Las distancias son directas.",features={
  {name="Escalera al rellano de la torre; hacia el rellano inferior",sound="stairs",box={144,384,160,416}},
  {name="Escalera al rellano de la torre; hacia el rellano superior",sound="stairs",box={112,384,128,416}},
  {name="Cofre de torre oeste del Castillo Guardia",sound="item",box={208,448,224,464},solid=true,treasure=0xF5F7CA},
 }},
 {id="guardia600_480_inferior",name="rellano inferior de la torre oeste del Castillo Guardia",article="el ",location=480,bounds={0,480,1024,768},
  house="el Castillo Guardia de 600",guidance="La torre oeste une la sala principal con los aposentos del rey. Los tramos de escalera conectan rellanos separados. Las distancias son directas.",features={
  {name="Paso a los aposentos del rey",sound="stairs",box={144,624,160,656}},
  {name="Escalera al rellano de la torre; hacia el rellano intermedio",sound="stairs",box={112,624,128,656}},
 }},

 {id="truce_canyon_arrival",name="claro de llegada del Cañón de Truce",article="el ",location=113,bounds={0,0,256,256},
  house="el Cañón de Truce",people={[2]=false,[18]=false,[20]=false,[22]=false,[24]=true,[26]=true,[28]=true},
  guidance="Esta es la zona de llegada del Teleport. El paso al sendero principal está al oeste. Puede haber enemigos; durante la batalla se utiliza el lector de combate. Las distancias son directas.",features={
  {name="Paso oeste al sendero principal del Cañón de Truce",sound="connection",box={0,112,16,176}},
  {name="Zona del portal de llegada",sound="connection",box={120,80,152,112}}
 }},
 {id="truce_canyon",name="senderos del Cañón de Truce",article="los ",location=112,bounds={0,0,512,512},
  house="el Cañón de Truce",
  guidance="Salida al mapa exterior al sur. Desde el claro de llegada, sube la escalera del este, cruza el puente del norte hacia el oeste y busca la escalera del oeste para bajar. Continúa hacia el paso sureste y la salida sur. Hay desniveles y enemigos. Las distancias son directas, no rutas por los senderos.",features={
  {name="Salida sur del cañón al mapa exterior",sound="door",box={304,496,352,512}},
  {name="Paso noreste al claro de llegada",sound="connection",box={496,176,512,240}},
  {name="Cofre del noroeste",sound="item",box={96,80,112,96},solid=true,treasure=0xF5F46E},
  {name="Cofre del centro",sound="item",box={272,240,288,256},solid=true,treasure=0xF5F472},
  {name="Pie de la escalera del este; sube hacia el norte",sound="stairs",box={448,200,464,224}},
  {name="Parte alta de la escalera del este; baja hacia el sur",sound="stairs",box={448,120,464,144}},
  {name="Acceso este al puente; crúzalo hacia el oeste",sound="connection",box={384,72,400,88}},
  {name="Acceso oeste al puente",sound="connection",box={304,72,320,88}},
  {name="Parte alta de la escalera del oeste; baja hacia el sur",sound="stairs",box={128,280,144,304}},
  {name="Pie de la escalera del oeste; sube hacia el norte",sound="stairs",box={128,352,144,376}},
  {name="Paso sureste hacia la salida sur",sound="connection",box={304,432,336,464}}
 }},
 {id="truce_inn_saloon",name="salón de la posada de Truce",article="el ",location=12,bounds={784,256,1024,496},
  house="la posada de Truce",people={[16]=true,[18]=true,[22]=true,[24]=true,[34]=false},
  guidance="Salida al sur, al oeste de la mesa. Barra al noroeste. Escalera al noreste; avanza al este para subir y después al norte hacia el rellano. Las distancias son directas, no rutas entre muebles.",features={
  {name="Salida al mapa exterior",sound="door",box={816,480,848,496}},
  {name="Acceso a la escalera; avanza al este para subir",sound="stairs",box={896,288,920,320}},
  {name="Frente de la barra",sound="connection",box={800,304,848,336},solid=true},
  {name="Barra",sound="furniture",box={784,304,880,336},solid=true},
  {name="Mesa del salón",sound="furniture",box={896,368,976,416},solid=true},
  {name="Silla oeste de la mesa",sound="furniture",box={864,384,880,416},solid=true},
  {name="Silla suroeste de la mesa",sound="furniture",box={904,432,920,464},solid=true},
  {name="Silla sureste de la mesa",sound="furniture",box={936,432,952,464},solid=true},
  {name="Taburete oeste de la barra",sound="furniture",box={800,352,816,384},solid=true},
  {name="Taburete este de la barra",sound="furniture",box={832,352,848,384},solid=true},
  {name="Sofá bajo la escalera",sound="furniture",box={928,320,976,352},solid=true},
  {name="Piano",sound="furniture",box={976,320,1008,344},solid=true},
  {name="Chimenea",sound="furniture",box={864,272,880,320},solid=true}
 }},
 {id="truce_inn_landing",name="rellano de la posada de Truce",article="el ",location=12,bounds={848,160,1024,256},
  house="la posada de Truce",people={[20]=true,[34]=false},
  guidance="Puerta del dormitorio al norte, en el centro del pasillo. Escalera al este: avanza al sur y después al oeste para regresar al salón.",features={
  {name="Puerta del dormitorio; avanza al norte",sound="connection",box={936,192,952,208}},
  {name="Escalera de regreso al salón; avanza al sur y después al oeste",sound="stairs",box={976,240,1008,256}}
 }},
 {id="truce_inn_bedroom",name="dormitorio de la posada de Truce",article="el ",location=12,bounds={800,32,1024,160},
  house="la posada de Truce",people={[28]=false,[30]=false,[32]=false,[34]=false},
  guidance="Tres camas al norte. Regreso al rellano al sur, por el paso frente a la cama este. Arcón sellado al noreste; el lector lee su mensaje al examinarlo con A. Puedes hablar con las personas del salón.",features={
  {name="Regreso al rellano; avanza al sur",sound="connection",box={936,144,952,160}},
  {name="Cama oeste",sound="bed",box={840,80,880,128},solid=true},
  {name="Cama central",sound="bed",box={888,80,928,128},solid=true},
  {name="Cama este",sound="bed",box={936,80,976,128},solid=true},
  {name="Arcón sellado",sound="item",box={992,64,1008,96},solid=true,entity=34},
  {name="Cómoda del dormitorio",sound="furniture",box={976,64,992,96},solid=true},
  {name="Reloj del dormitorio",sound="clock",box={976,48,992,64}}
 }},
 {id="leene_entrance",name="entrada de la plaza Leene",location=5,bounds={0,320,768,768},
  house="la plaza Leene",
  people={[16]=false,[18]=false,[20]=false,[22]=false,[24]=true,[26]=true,[28]=true,[30]=true,[32]=true,[36]=true,[48]=true,[50]=true,[52]=false},
  guidance="Salida al exterior al sur. Plaza de la campana al norte. Tienda de los horrores al noreste; se entra hacia el norte. Juego de la campana al oeste y carrera al este. Las distancias son directas, no rutas entre puestos.",features={
  {name="Salida al mapa exterior",sound="door",box={368,752,416,768}},
  {name="Paso norte a la plaza de la campana",sound="connection",box={368,320,432,336}},
  {name="Entrada a la tienda de los horrores; avanza al norte",sound="games",box={688,464,704,480}},
  {name="Juego de la campana; pulsa A para empezar, suelta y vuelve a pulsar al pitido. Control F8 adelanta el aviso; Control F9 lo retrasa",sound="games",box={80,544,96,576},entity=52}
 }},
 {id="leene_bell",name="plaza de la campana de Leene",location=439,bounds={0,0,768,384},
  house="la plaza Leene",
  people={[6]=true,[20]=true,[22]=true,[26]="Gato",[28]=false,[30]="Colgante en el suelo",[56]="Mesa con comida",[24]=true,[32]=true,[34]=true,[36]=false,[54]=true,[60]=true},
  nonPeople={[26]=true,[30]=true,[56]=true},
  personTypes={[6]=3},personSounds={[30]="item",[56]="item"},
  guidance="Regreso a la entrada al sur. Gato al oeste, baile al este y presentación de Lucca al norte. Concurso de beber soda al sureste. Las referencias indican distancia directa.",features={
  {name="Regreso a la entrada de la feria",sound="door",box={352,352,432,368}},
  {name="Paso oeste al recinto de Gato",sound="connection",box={0,80,16,160}},
  {name="Paso este al baile",sound="connection",box={752,32,768,96}},
  {name="Paso norte a la presentación de Lucca; puede estar bloqueado por los vigilantes",sound="connection",box={368,16,416,32}},
  {name="Campana de Leene",sound="connection",box={376,144,408,176},entity=36}
 }},
 {id="leene_gato",name="recinto de Gato",article="el ",location=6,bounds={0,0,256,256},
  house="la plaza Leene",people={[16]=true},
  guidance="Para hablar, acércate a una persona y pulsa A. Regreso a la plaza de la campana al sur. Durante el combate se utiliza el lector de batalla.",features={
  {name="Regreso a la plaza de la campana",sound="door",box={112,240,208,256}}
 }},
 {id="leene_dance",name="zona del baile de Leene",location=7,bounds={0,0,256,256},
  house="la plaza Leene",people={[16]=false,[18]=false,[20]=false,[22]=false,[24]=true,[26]=true,[28]=true,[30]=true},
  guidance="Baile libre: pulsa Y, X, L o R para ejecutar cuatro pasos diferentes. El lector anuncia el paso aceptado por el juego. Regreso a la plaza de la campana al sur. Músicos al norte.",features={
  {name="Regreso a la plaza de la campana",sound="door",box={48,240,112,256}},
  {name="Baile y músicos",sound="games",box={104,80,168,128}}
 }},
 {id="leene_lucca",name="recinto de la presentación de Lucca",article="el ",location=8,bounds={0,0,256,240},
  house="la plaza Leene",people={[20]=true,[22]="Colgante; examina con A",[26]=true,[28]=true,[44]=true,[46]=true,[48]=true,[50]=false,[54]=false,[56]=false},
  nonPeople={[22]=true},personTypes={[26]=3,[28]=3},personSounds={[22]="item"},
  guidance="Teleport al norte. Regreso a la plaza de la campana al sur. Los diálogos de la demostración se leen automáticamente. Las distancias son directas.",
  guidanceWhenVisible={
-- BEGIN ZENAN CASTLE 62
 {entity=50,minStory=72,text="El portal del recinto lleva al Fin del Tiempo. Entra para registrar los pilares de Plaza Leene y del Desfiladero, 600 d. C.",replace=true},
-- END ZENAN CASTLE 62


   {entity=22,text="Hay un colgante en el suelo: puedes examinarlo con A."}
  },features={

  {name="Regreso a la plaza de la campana",sound="door",box={96,224,160,240}},
  {name="Teleport izquierdo: plataforma de salida; entra desde el sur",sound="item",box={48,80,88,112}},
  {name="Teleport derecho: plataforma de llegada",sound="item",box={168,80,208,112}},
-- BEGIN ZENAN CASTLE 62
 {name="Portal al Fin del Tiempo; examina con A",sound="connection",box={128,56,144,80},entity=50,followEntity=true,minStory=72},
-- END ZENAN CASTLE 62
 }},
 {id="leene_horrors",name="tienda de los horrores de Leene",location=434,bounds={0,0,256,224},
  house="la plaza Leene",people={[16]=false,[18]=true,[20]=false,[22]=true,[24]=false,[26]=false,[28]=false,[30]="Monstruo del carril izquierdo",[32]="Monstruo del carril central",[34]="Monstruo del carril derecho",[36]=false,[38]=false,[40]=true,[42]=true,[44]=true,[46]=false},
  nonPeople={[30]=true,[32]=true,[34]=true},
  personTypes={[18]=3},personSounds={[30]="games",[32]="games",[34]="games"},
  guidance="Regreso a la feria al sur. Diez puntos: encontrar al soldado. Cuarenta: imitar al clon con L, R, A e Y; mantén la tecla indicada hasta el pitido y suéltala. Ochenta: piedras contra monstruos y rescate del compañero. Control F10 consulta el objetivo del juego.",features={
  {name="Regreso a la entrada de la feria",sound="door",box={112,208,144,224}},
  {name="Piedra del carril izquierdo; mira al norte y pulsa A",sound="item",box={100,142,108,150},entity=24},
  {name="Piedra del carril central; mira al norte y pulsa A",sound="item",box={132,142,140,150},entity=26},
  {name="Piedra del carril derecho; mira al norte y pulsa A",sound="item",box={164,142,172,150},entity=28},
  {name="Luz azul para subir la cuerda; pulsa A al llegar",sound="item",box={36,144,44,152},entity=16}
 }},
 {id="truce_house_east",name="vivienda este de Truce",location=15,bounds={512,304,736,496},
  people={[16]=true},
  house="la vivienda este de Truce",guidance="Salida al sur, en el paso central. Cocina y mesa al oeste. Cama al noreste.",features={
  {name="Salida al mapa exterior",sound="door",box={608,480,640,496}},
  {name="Cama",sound="bed",box={680,368,720,416},solid=true},
  {name="Cocina y fregadero",sound="furniture",box={528,352,576,384},solid=true},
  {name="Mesa",sound="furniture",box={528,416,576,464},solid=true},
  {name="Silla al norte de la mesa",sound="furniture",box={544,400,560,416},solid=true},
  {name="Silla al oeste de la mesa",sound="furniture",box={512,448,528,464},solid=true},
  {name="Taburete de la cocina",sound="furniture",box={544,384,560,400},solid=true},
  {name="Vasija junto a la cocina",sound="furniture",box={512,384,528,400},solid=true},
  {name="Reloj central",sound="clock",box={624,352,640,368}},
  {name="Reloj junto a la cama",sound="clock",box={720,336,736,352}}
 }},
 {id="truce_house_west",name="vivienda oeste de Truce",location=16,bounds={32,560,224,768},
  people={[16]=true,[18]=true},
  house="la vivienda oeste de Truce",guidance="Salida al sureste. Cocina al noreste, mesa al oeste y dos camas al suroeste.",features={
  {name="Salida al mapa exterior",sound="door",box={176,720,208,736}},
  {name="Cama oeste",sound="bed",box={40,696,80,768},solid=true},
  {name="Cama este",sound="bed",box={104,696,144,768},solid=true},
  {name="Cocina y fregadero",sound="furniture",box={144,576,208,624},solid=true},
  {name="Mesa",sound="furniture",box={64,608,112,656},solid=true},
  {name="Silla junto a la mesa",sound="furniture",box={32,624,48,656},solid=true},
  {name="Vasijas del este",sound="furniture",box={208,624,224,672},solid=true},
  {name="Florero junto a la salida",sound="furniture",box={208,672,224,688},solid=true},
  {name="Reloj central",sound="clock",box={112,560,128,576}},
  {name="Reloj junto a la cocina",sound="clock",box={128,560,144,576}}
 }},
 {id="guardia_forest",name="Bosque Guardia",article="el ",location=19,bounds={0,0,768,768},
  house="el Bosque Guardia",people={[82]=false},
  guidanceWhenVisible={{entity=24,replace=true,sound="connection",text="Durante la huida, sigue el sendero del norte hacia el este. Si el guardia del paso te cierra el camino, baja un poco y pásalo por el sur. Continúa al este hasta el claro del portal. Las salidas habituales del bosque no son la ruta de huida."}},
  guidance="Hay enemigos. Salida sur hacia Truce; salida norte hacia el castillo. El paso del noreste conduce al claro del arcón. Las referencias indican dirección y distancia, no una ruta entre árboles.",features={
  {name="Salida sur hacia Truce",sound="door",box={240,752,416,768}},
  {name="Salida norte hacia el castillo",sound="door",box={240,16,336,48}},
  {name="Paso al claro del arcón",sound="connection",box={736,80,768,112}},
  {name="Sendero norte de la huida; sigue al este",sound="connection",box={472,104,488,120},entity=24},
  {name="Paso del guardia; baja un poco para bordearlo por el sur",sound="connection",box={608,104,632,120},entity=24},
  {name="Tramo final al claro del portal; sigue al este",sound="connection",box={720,104,744,120},entity=24},
  {name="Cruce del sendero sur",sound="connection",box={296,520,328,552}},
  {name="Paso del oeste",sound="connection",box={112,408,144,440}},
  {name="Paso central",sound="connection",box={272,304,288,320}},
  {name="Cruce del norte",sound="connection",box={264,80,296,112}},
  {name="Desvío del sureste",sound="connection",box={480,528,512,560}},
  {name="Destello del sureste",sound="item",box={736,528,752,552},entity=82}
 }},
 {id="guardia_forest_glade",name="claro del arcón del Bosque Guardia",article="el ",location=20,bounds={0,0,256,256},
  house="el Bosque Guardia",people={[36]=false,[18]="Portal hacia las ruinas de 2300 d. C.",[20]=false,[22]=false},nonPeople={[18]=true},personSounds={[18]="connection"},
  guidanceWhenVisible={{entity=18,sound="connection",text="El portal hacia el futuro está al sur del claro. Acércate y examínalo con aceptar; avanza los diálogos de la huida con el botón habitual."}},
  guidance="Regreso al sendero principal al oeste. Arcón al este; acércate, mira hacia él y pulsa A para examinarlo.",features={
  {name="Regreso al sendero principal del bosque",sound="door",box={0,80,32,112}},
  {name="Arcón del claro",sound="item",box={208,96,224,128},solid=true,entity=36}
 }},
 {id="truce_mayor_ground",name="planta baja de la casa del alcalde de Truce",location=13,bounds={48,304,432,496},
  people={[16]=true,[18]=false,[20]=true,[24]=true,[26]=true,[28]=true,[30]=true},
  house="la casa del alcalde de Truce",guidance="Salida al sureste. Escalera a la planta alta en el pasillo inferior, hacia el centro. Cocina y comedor al oeste; pasillo de unión al norte.",features={
  {name="Salida al mapa exterior",sound="door",box={352,480,384,496}},
  {name="Base de la escalera a la planta alta; avanza al este para subir",sound="stairs",box={208,464,224,480}},
  {name="Cocina y fregadero",sound="furniture",box={48,352,144,384},solid=true},
  {name="Mesa del comedor",sound="furniture",box={96,400,144,448},solid=true},
  {name="Silla oeste del comedor",sound="furniture",box={64,432,80,448},solid=true},
  {name="Silla este del comedor",sound="furniture",box={160,416,176,432},solid=true},
  {name="Mueble junto a la cocina",sound="furniture",box={144,368,160,384},solid=true},
  {name="Vasija junto a la cocina",sound="furniture",box={160,368,176,384},solid=true},
  {name="Reloj junto a la cocina",sound="clock",box={160,320,176,336}},
  {name="Reloj del recibidor",sound="clock",box={352,384,368,400}},
  {name="Planta del recibidor",sound="furniture",box={400,400,416,448},solid=true},
  {name="Cofre de la cocina",sound="item",box={176,368,192,384},solid=true,treasure=0xF5F40A}
 }},
 {id="truce_mayor_upper",name="planta alta de la casa del alcalde de Truce",location=14,bounds={544,80,736,224},
  people={[16]=true,[18]=true,[20]=true,[22]=true},
  house="la casa del alcalde de Truce",guidance="Escalera de regreso al oeste, por el paso inferior. Dos camas al norte.",features={
  {name="Acceso a la escalera de regreso a la planta baja; avanza al oeste para bajar",sound="stairs",box={576,192,592,208}},
  {name="Cama oeste",sound="bed",box={616,128,656,176},solid=true},
  {name="Cama este",sound="bed",box={680,128,720,176},solid=true},
  {name="Cofre entre las camas",sound="item",box={656,128,672,144},solid=true,treasure=0xF5F40E}
 }},
 {id="truce_shop",name="tienda de Truce",location=17,bounds={304,560,464,736},
  house="la tienda de Truce",guidance="Mostrador al norte. Salida al sur.",features={
  {name="Salida al mapa exterior",sound="door",box={336,720,368,736}},
  {name="Frente del mostrador",sound="connection",box={336,640,368,672},solid=true},
  {name="Mostrador",sound="furniture",box={304,640,400,672},solid=true},
  {name="Vasijas",sound="furniture",box={320,592,336,640},solid=true},
  {name="Estantería de mercancías",sound="furniture",box={352,560,416,608},solid=true}
 }},
 {id="bedroom",name="dormitorio de Crono",location=2,bounds={288,32,448,224},features={
  {name="Cama",sound="bed",box={400,104,448,160},solid=true},
  {name="Reloj",sound="clock",box={352,48,368,64}},
  {name="Escaleras",sound="stairs",box={336,184,352,208}},
  {name="Escritorio",box={312,80,368,104},solid=true},
  {name="Silla",box={336,104,352,128},solid=true},
  {name="Estantería",box={416,48,448,88},solid=true}
 }},
 {id="ground_floor",name="planta baja de la casa de Crono",location=1,bounds={0,0,256,224},features={
  {name="Escaleras al dormitorio",sound="stairs",box={184,88,208,112}},
  {name="Salida de la casa",sound="door",box={168,208,184,224}},
  {name="Cocina",sound="furniture",box={48,48,128,80},solid=true},
  {name="Silla de la cocina",sound="furniture",box={64,80,80,112},solid=true},
  {name="Mesa",sound="furniture",box={64,112,96,176},solid=true},
  {name="Silla de la mesa",sound="furniture",box={32,112,48,144},solid=true},
  {name="Sofá",sound="furniture",box={128,128,176,160},solid=true},
  {name="Mueble del salón",sound="furniture",box={128,96,176,128},solid=true},
  {name="Reloj",sound="clock",box={176,32,192,48}}
 }},
 {id="lucca_main",name="sala principal de la casa de Lucca",location=4,bounds={0,128,256,336},
  house="la casa de Lucca",guidance="Salida al sur, en el pasillo de la izquierda. Distribuidor al norte, en el centro.",features={
  {name="Salida al mapa exterior",sound="door",box={32,320,80,336}},
  {name="Puerta al distribuidor",sound="connection",box={112,160,144,176}},
  {name="Mesa grande",sound="furniture",box={160,224,208,288},solid=true},
  {name="Mesa de trabajo",sound="furniture",box={16,208,80,240},solid=true},
  {name="Estantería",sound="furniture",box={64,144,96,192},solid=true},
  {name="Máquinas",sound="furniture",box={144,128,192,192},solid=true},
  {name="Tubos de la izquierda",sound="furniture",box={32,160,64,208},solid=true},
  {name="Tubos centrales",sound="furniture",box={96,160,112,272},solid=true},
  {name="Reloj",sound="clock",box={224,144,240,192}}
 }},
 {id="lucca_hall",name="distribuidor de la casa de Lucca",article="el ",location=3,bounds={64,96,192,240},
  house="la casa de Lucca",guidance="Regreso a la sala principal al sur. Puerta al norte. Escaleras al noroeste y noreste.",features={
  {name="Regreso a la sala principal",sound="door",box={112,224,144,240}},
  {name="Escalera al dormitorio oeste",sound="stairs",box={64,112,80,144}},
  {name="Escalera al dormitorio este",sound="stairs",box={176,112,192,144}},
  {name="Puerta a la cocina y comedor",sound="connection",box={112,128,144,144}},
  {name="Vasijas del oeste",sound="furniture",box={64,176,96,192},solid=true},
  {name="Vasijas del este",sound="furniture",box={176,160,192,192},solid=true}
 }},
 {id="lucca_kitchen",name="cocina y comedor de la casa de Lucca",location=3,bounds={32,656,208,848},
  house="la casa de Lucca",guidance="Regreso al distribuidor al sur, por el paso de la izquierda. Cocina al norte. Mesa del comedor al este.",features={
  {name="Regreso al distribuidor",sound="door",box={48,784,80,800}},
  {name="Cocina y fregadero",sound="furniture",box={48,704,112,736},solid=true},
  {name="Mesa del comedor",sound="furniture",box={128,752,176,816},solid=true},
  {name="Silla oeste del comedor",sound="furniture",box={96,768,112,784},solid=true},
  {name="Sillas del este",sound="furniture",box={192,736,208,800},solid=true},
  {name="Taburete de la cocina",sound="furniture",box={128,704,144,736},solid=true},
  {name="Estantería de la cocina",sound="furniture",box={112,672,128,720},solid=true},
  {name="Mueble bajo la ventana",sound="furniture",box={144,704,192,720},solid=true}
 }},
 {id="lucca_east_room",name="dormitorio este de la casa de Lucca",article="el ",location=9,bounds={64,336,208,560},
  house="la casa de Lucca",guidance="Escalera de regreso al distribuidor al suroeste. Paso al rellano este al oeste. Cama al noroeste.",features={
  {name="Escalera al distribuidor",sound="stairs",box={128,528,144,560}},
  {name="Cama",sound="bed",box={80,384,120,448},solid=true},
  {name="Mueble bajo la ventana",sound="furniture",box={112,384,160,400},solid=true},
  {name="Chimenea",sound="furniture",box={64,416,80,480},solid=true},
  {name="Planta oeste",sound="furniture",box={64,368,80,416},solid=true},
  {name="Planta este",sound="furniture",box={176,368,192,416},solid=true},
  {name="Jarrón del este",sound="furniture",box={192,416,208,448},solid=true},
  {name="Paso al rellano este",sound="connection",box={80,496,112,512}}
 }},
 {id="lucca_west_room",name="dormitorio oeste de la casa de Lucca",article="el ",location=10,bounds={304,32,448,256},
  house="la casa de Lucca",guidance="Escalera al distribuidor al sureste. Paso al rellano oeste al suroeste. Cama al noreste.",features={
  {name="Escalera al distribuidor",sound="stairs",box={416,224,448,240}},
  {name="Paso al rellano oeste",sound="connection",box={320,240,352,256}},
  {name="Cama",sound="bed",box={392,80,424,144},solid=true},
  {name="Mesa de trabajo",sound="furniture",box={304,96,352,192},solid=true},
  {name="Estantería",sound="furniture",box={320,48,352,112},solid=true},
  {name="Silla de trabajo",sound="furniture",box={336,112,352,144},solid=true},
  {name="Tubos centrales",sound="furniture",box={352,80,368,224},solid=true},
  {name="Mueble bajo la ventana",sound="furniture",box={368,80,392,96},solid=true},
  {name="Vasija junto a la cama",sound="furniture",box={384,160,400,176},solid=true},
  {name="Vasijas del suroeste",sound="furniture",box={304,192,352,224},solid=true}
 }},
 {id="lucca_west_landing",name="rellano oeste de la casa de Lucca",article="el ",location=4,bounds={16,16,80,128},
  house="la casa de Lucca",guidance="Puerta de regreso al dormitorio oeste al norte.",features={
  {name="Puerta al dormitorio oeste",sound="door",box={32,64,64,80}}
 }},
 {id="lucca_east_landing",name="rellano este de la casa de Lucca",article="el ",location=4,bounds={112,16,240,128},
  house="la casa de Lucca",guidance="Puerta de regreso al dormitorio este al norte.",features={
  {name="Puerta al dormitorio este",sound="door",box={160,64,192,80}},
  {name="Planta junto al tramo central",sound="furniture",box={112,64,128,96},solid=true},
  {name="Planta del este",sound="furniture",box={224,64,240,96},solid=true}
 }}
}
