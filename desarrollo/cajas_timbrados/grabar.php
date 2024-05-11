<?php
require '../clases/conexion.php';

$caja = $_POST["caja"];
$timb = $_POST['timb'];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_detalle_timbrados(".$caja.",".$timb.",".$ope.")");

$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>

