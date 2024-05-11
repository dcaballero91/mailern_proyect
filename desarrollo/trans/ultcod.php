<?php
require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
//hacemos la consulta del ultimo código más uno (+1) de la tabla pedido
$sql=pg_query("select coalesce(max(nro_tranfer),0)+1 as ultimo from transferencia");
while($fila=pg_fetch_array($sql)){
    //imprimos el valor devuelto por la consulta "ultimo"
         echo $fila["ultimo"];
     }