<?php
require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$nom = $_POST["nom"];
$ruc = $_POST['ruc'];
// $fecha = $_POST['fechain'];


$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_proveedores(".$codigo.",".$nom.",'".$ruc."',".$ope.")");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
$exception = pg_last_error($con->url);
echo str_replace("NOTICE: ","",$exception);
?>