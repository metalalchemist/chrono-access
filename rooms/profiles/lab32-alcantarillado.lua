return {
-- BEGIN LAB32 SEWER: ROM exit/chest tables; native event captures.
 {id="future58_223",location=223,name="sector oeste de Lab 32",article="el ",house="Lab 32",bounds={0,0,1024,1024},people={[16]=false,[26]="Patxi, el corredor"},guidance="La salida al exterior está al sur. La moto está al norte: examínala desde el sur con A. Necesitas la Llave de la Moto que entrega el anciano de Arris tras la semilla. Patxi propone la carrera. Arriba y abajo permiten maniobrar y B usa un turbo; tienes tres. El lector anuncia la posición frente al rival y los turbos. Hay un cofre al sureste de la moto. El paso a pie hacia el sector central se abre al este de la moto; tiene combates.",features={
  {name="Paso a mapa exterior de 2300 d. C.",sound="door",box={528,496,672,512}},
  {name="Cofre de SemiTónico",sound="item",box={672,448,688,464},solid=true,treasure=16119262},
  {name="Paso este a pie por Lab 32; acceso por evento del juego",sound="door",box={736,32,752,176}},
  {name="Moto; examina desde el sur con A",sound="games",box={688,88,704,104},entity=16},
 }},
 {id="future58_224",location=224,name="paso a pie de Lab 32",article="el ",house="Lab 32",bounds={0,0,1024,1024},guidance="Paso a pie entre los dos extremos de Lab 32. Regreso al oeste y salida al sector este por el extremo derecho. Hay un cofre junto al recorrido. Hay combates entre escombros; las distancias son directas y no trazan caminos.",features={
  {name="Paso a sector oeste de Lab 32",sound="door",box={0,32,16,224}},
  {name="Paso a sector este de Lab 32",sound="door",box={1008,80,1024,160}},
  {name="Cofre de la Libreta, registro de carreras",sound="item",box={560,176,576,192},solid=true,treasure=16119266},
 }},
 {id="future58_225",location=225,name="sector este de Lab 32",article="el ",house="Lab 32",bounds={0,0,1024,1024},people={[18]=false},guidance="La salida al mapa exterior hacia Proto está al sur. El paso a pie hacia el centro de Lab 32 está al noroeste. La moto de regreso está al norte. Para correr, examínala con Crono en el grupo. Hay un cofre en el sector central.",features={
  {name="Paso a mapa exterior de 2300 d. C.",sound="door",box={848,208,1008,224}},
  {name="Paso al corredor central a pie de Lab 32",sound="door",box={768,48,784,192}},
  {name="Moto de regreso; examina desde el sur con A",sound="games",box={896,152,912,168},entity=18},
 }},
 {id="future58_236",location=236,name="planta principal del alcantarillado",article="la ",house="el alcantarillado",bounds={0,0,1024,1024},hasSwitches=true,people={[16]=false,[18]=false,[20]=false,[28]=false,[34]=false,[40]=false,[50]=false,[54]=false,[60]=false,[62]=false,[68]=false,[70]=false},guidance="Zona opcional. Entrada desde Arris por el noroeste y salida al otro lado por el sureste. Las dos escaleras del oeste y del sur comunican con el pasillo inferior; sigue sus giros para cruzar. Hay tres cofres numerados: dos al norte y uno al sur. El jefe bloquea el trayecto oriental. Puede dejar a un personaje con un punto de vida: lleva curación. Hay interruptores que cambian los pasos del centro y del sur. No hay un punto de guardado real en estas dos plantas; el del pasillo inferior es una trampa.",features={
  {name="Salida noroeste hacia Arris",sound="door",box={224,32,240,48}},
  {name="Salida sureste hacia la otra orilla",sound="door",box={560,512,576,528}},
  {name="Escalera oeste hacia pasillo inferior del alcantarillado",sound="stairs",box={48,448,64,464}},
  {name="Escalera sur hacia pasillo inferior del alcantarillado",sound="stairs",box={224,720,240,736}},
  {name="Cofre con 600 monedas",sound="item",box={432,80,448,96},solid=true,treasure=16119314},
  {name="Cofre de BandaFuria, accesorio de contraataque",sound="item",box={544,80,560,96},solid=true,treasure=16119318},
  {name="Cofre de la espada EspadaRayo para Crono",sound="item",box={432,544,448,560},solid=true,treasure=16119322},
  {name="Interruptor del paso central; examina",sound="sign",box={336,360,352,376},entity=16,switch={address=8323606,mask=1}},
  {name="Interruptor de los puentes del sur; examina",sound="sign",box={384,568,400,584},entity=18,switch={address=8323308,mask=2}},
  {name="Acceso este al puente del sur; cruza al oeste",sound="connection",box={368,608,384,624},state={address=8323308,mask=2,onText="paso abierto",offText="paso cerrado; pulsa el interruptor de los puentes del sur"}},
  {name="Acceso oeste al puente del sur; cruza al este",sound="connection",box={320,608,336,624},state={address=8323308,mask=2,onText="paso abierto",offText="paso cerrado; pulsa el interruptor de los puentes del sur"}},
  {name="Acceso este al puente del oeste; cruza al oeste",sound="connection",box={176,336,192,352},state={address=8323308,mask=2,onText="paso abierto",offText="paso cerrado; pulsa el interruptor de los puentes del sur"}},
  {name="Acceso oeste al puente del oeste; cruza al este",sound="connection",box={112,336,128,352},state={address=8323308,mask=2,onText="paso abierto",offText="paso cerrado; pulsa el interruptor de los puentes del sur"}},
  {name="Puerta del paso central; no es la salida al exterior",sound="door",box={424,336,440,352},state={address=8323606,mask=1,onText="paso abierto",offText="paso cerrado; pulsa el interruptor del paso central"}},
  {name="Aviso junto al corredor central; examina",sound="sign",box={416,360,432,376},entity=68},
  {name="Jefe de la alcantarilla; prepara curación antes de seguir al este",sound="enemy",box={672,120,688,136},entity=72},
 }},
 {id="future58_237",location=237,name="pasillo inferior del alcantarillado",article="el ",house="el alcantarillado",bounds={0,0,1024,1024},people={[16]=false,[24]=false,[26]=false,[38]=false,[44]=false,[52]=false},guidance="Pasillo inferior. Regreso a la entrada por la escalera norte; la escalera sureste lleva a los cofres y al jefe de la planta principal. Sigue el corredor y sus giros. Examinar el gato, la lata, el queso o el falso guardado provoca combates. El falso guardado no permite guardar. Puedes pasar sin examinarlos. Las distancias directas no atraviesan las paredes.",features={
  {name="Escalera norte hacia planta principal del alcantarillado",sound="stairs",box={208,32,224,48}},
  {name="Escalera sureste hacia planta principal del alcantarillado",sound="stairs",box={448,336,464,352}},
  {name="Gato; examinar provoca una emboscada",sound="enemy",box={352,88,368,104},entity=16},
  {name="Lata; examinar provoca una emboscada",sound="enemy",box={368,248,384,264},entity=24},
  {name="Queso; examinar provoca una emboscada",sound="enemy",box={96,280,112,296},entity=38},
  {name="Falso punto de guardado; trampa con enemigos, no guarda",sound="enemy",box={249,464,265,480},entity=44},
 }},
-- END LAB32 SEWER
}
