<?php
require '../clases/conexion.php';
$con = new conexion();
$con->conectar();
$codigo = $_POST["codigo"];
$sucursal = $_POST["sucursal"];
$usuario = $_POST["usuario"];
$cliente = $_POST["cliente"];
$detalle = $_POST["detalle"];
$ope = $_POST["ope"];

$sql = pg_query("select sp_ordenes_trabajos(".$codigo.",".$sucursal.",".$cliente.",".$usuario.",'".$detalle."',".$ope.")");

if(!$sql){
    echo pg_last_error()."_/_error";
}else{
    echo pg_last_notice($con->url)."_/_notice";
}

?>