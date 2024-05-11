<?php
require '../clases/conexion.php';
$cod = $_POST["codigo"];
$mar = $_POST["mar"];
$mod = $_POST["mod"];
$chap = $_POST["chapa"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_vehiculos(".$cod.",".$mar.",".$mod.",'".$chap."',".$ope.")");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>


