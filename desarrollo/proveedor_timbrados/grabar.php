<?php
require '../clases/conexion.php';
$provcod = $_POST['prov'];
$tim = $_POST['tim'];
$fecha = $_POST['fecha'];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_proveedores_timbrados(".$provcod.",".$tim.",'".$fecha."', ".$ope.")");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
$exception = pg_last_error($con->url);
echo str_replace("NOTICE: ","",$exception);
?>