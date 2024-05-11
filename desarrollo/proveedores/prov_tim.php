<?php
require '../clases/conexion.php';
$per = $_GET['per'];
$cn = new conexion();
$cn->conectar();
$sql = pg_query("select *  from personas where per_cod= '$per' ");
while($fila=pg_fetch_array($sql)){
    //imprimos el valor devuelto por la consulta "ultimo"
         echo $fila["per_ci"];
     }