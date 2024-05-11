<?php
require '../clases/conexion.php';

$codigo = $_POST["codigo"];
$descri = $_POST["descri"];
$suc = $_POST["suc"];
$usu = $_POST["usu"];
$ultrecibo = $_POST["ultrecibo"];
//$estado = $_POST["estado"];
$ope = $_POST["ope"];

$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_cajas_or(".$codigo.",'".$descri."',".$suc.",".$ultrecibo.",".$usu.",".$ope.")");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>
