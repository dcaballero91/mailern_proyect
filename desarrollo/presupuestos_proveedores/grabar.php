<?php

require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$suc = $_POST["suc"];
$fecha = $_POST["fecha"];
$pro = $_POST["pro"];
$val = $_POST["val"];
$usu = $_POST["usu"];
$detalle = $_POST["detalle"];
$ope = $_POST["ope"];
// $emp = $_POST["emp"];
// $fun = $_POST["fun"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_presupuestos_proveedores($codigo,$pro,'$fecha','$val',$suc,$usu,'$detalle',$ope)");
#ORDEN: codigo, provcod, fecha, validez, succod, usucod, detalles[items, marcas, cant, precio], operacion
if(!$sql){
    echo pg_last_error()."_/_error";
}else{
    echo pg_last_notice($con->url)."_/_notice";
}
?>