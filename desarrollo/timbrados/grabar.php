<?php
require '../clases/conexion.php';
require '../clases/sesion.php';

$codigo = $_POST["codigo"];
$descri = $_POST["descri"];
$vigdesde = $_POST["vigdesde"];
$vighasta = $_POST["vighasta"];
$nrodesde = $_POST["nrodesde"];
$nrohasta = $_POST["nrohasta"];
$ultfact = $_POST["ultfact"];
$puntexp = $_POST["puntexp"];
$suc = $_POST["suc"];
//$usuario = $_SESSION["usu"]; para hacer auditoria 
$ope = $_POST["ope"];

$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_timbrados_or(".$codigo.",".$descri.",'".$vigdesde."','".$vighasta."',".$suc.",".$nrodesde.",".$nrohasta.",".$ultfact.",".$puntexp.",".$ope.")");

#ORDEN: timbcod, timbnro, timvigdesde, timvighasta, succod,timnrodesde, timnrohasta, ultfactura, puntpexp, operacion

// $sql = pg_query("select sp_items(".$codigo.",".$imp.",'".$descri."',".$costo.",".$min.",".$max.",".$mar.",".$cla.",'".$usuario."',".$venta.",".$ope.")");
//OBS para $sql = pg_query= ( '".$desc."')  <--estos tipos de comillas son para cargar text 
//OBS para $sql = pg_query= ( ".$costo." ) <--estos tipos de comillas son para cargar integer
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>
