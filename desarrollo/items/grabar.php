<?php
require '../clases/conexion.php';
require '../clases/sesion.php';

$codigo = $_POST["codigo"];
$descri = $_POST["descri"];
$tipoitem = $_POST["tipoitem"];
$venta = $_POST["venta"];
$imp = $_POST["imp"];
$ope = $_POST["ope"];
// $costo = $_POST["costo"];
// $dep = $_POST["dep"];
//$usuario = $_SESSION["usu"]; para hacer auditoria 

$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_items_sin_marcas(".$codigo.",".$tipoitem.",'".$descri."',".$venta.",".$imp.",".$ope.")");

// $sql = pg_query("select sp_items(".$codigo.",".$imp.",'".$descri."',".$costo.",".$min.",".$max.",".$mar.",".$cla.",'".$usuario."',".$venta.",".$ope.")");
//OBS para $sql = pg_query= ( '".$desc."')  <--estos tipos de comillas son para cargar text 
//OBS para $sql = pg_query= ( ".$costo." ) <--estos tipos de comillas son para cargar integer
if(!$sql){
    echo pg_last_error()."_/_error";
}else{
    echo pg_last_notice($con->url)."_/_notice";
}

?>
