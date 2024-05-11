<?php
require '../clases/conexion.php';
 $dia = $_POST["dia"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select * from devolver_dias_int('$dia')");
$rs = pg_fetch_assoc($sql);
echo $rs["salida"];
?>