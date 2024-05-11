<?php
require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$tserv = $_POST["tserv"];
$precio = $_POST["precio"];
$imp = $_POST["impuesto"];
$esp = $_POST["especialidad"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_tipo_servicios(".$codigo.",'".$tserv."',".$precio.",'".$imp."',".$esp.",'".$ope."')");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>
