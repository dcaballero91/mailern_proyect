<?php

require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$nro = $_POST["nro"];
$emp = $_POST["emp"];
$suc = $_POST["suc"];
//$usu = $_POST["usu"];
$fun = $_POST["fun"];
$cliente = $_POST["cliente"];
$detalle = $_POST["detalle"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_pedido_ventas($codigo,$emp,$suc,$fun,$cliente,$nro,'$detalle','$ope')");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>