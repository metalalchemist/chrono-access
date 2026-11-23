# 89. Recarga confirmada de las referencias de Mammon

El usuario seguía oyendo los nombres antiguos y falta de orientación al
entrar en Mammon después de la entrega 88. La consola todavía ejecutaba
el lector previo: las referencias nuevas estaban en disco, sin cargar.

recargar-lector.ps1 enviaba BM_CLICK al botón Restart de una consola inactiva.
La llamada devolvía éxito sin reiniciar el script. Ahora envía WM_COMMAND
con el identificador del botón y BN_CLICKED a su ventana padre. No cambia
el foco ni reinicia el juego. Antes de anunciar éxito exige que lector.log
añada «Ubicacion al recargar» y «Pulsa Control F1 para aprender los sonidos».
Si no aparecen en cinco segundos, informa del fallo de confirmación.

Comprobación real: una orden nativa y una ejecución del script corregido
añadieron nuevos inicios al registro. La sesión anunció mapa 330, «antesala
de la máquina Mammon», y la orientación nueva. Se mantiene la referencia
de la máquina en 331 y la puerta norte incorporadas en 88. No se movió al
personaje, no se cargaron partidas ni se modificó su RAM.

Durante la comprobación el usuario entró en 331. El registro habitual ya
anunció orientación disponible y «Máquina Mammon» al seleccionar/consultar:
primero 4.5 casillas al norte y después 2.0 al norte, 0.7 al este. Una nueva
ejecución confirmada del script registró mapa 331 y mantuvo esa orientación.

La captura aportada por el usuario coincide con la sala de la máquina.
Se investigó además la variante 333 en una copia administrada silenciada;
sigue sin perfil y no forma parte de esta corrección. No atribuirle este
reporte: el registro habitual demuestra que seguía usando el lector antiguo.
No se cambian perfiles ni generador en 89. Las pruebas de la entrega 88
siguen siendo su validación de referencias; no se repitieron sin cambios.

Copia de diagnóstico cerrada y tres entradas del arnés restauradas.
Reversión de esta corrección: restaurar recargar-lector.ps1 desde
test/future-check/mammon89-before/recargar-lector.ps1. Conservar 86–88.
Retirar esta nota y el resumen 89 si se revierte. Sin commits.
