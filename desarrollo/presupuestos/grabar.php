<?php

require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$suc = $_POST["suc"];
$cli = $_POST["cli"];
$val = $_POST["val"];
$usu = $_POST["usu"];
$detalle = $_POST["detalle"];
$ope = $_POST["ope"];
// $emp = $_POST["emp"];
// $fun = $_POST["fun"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_presupuestos($codigo,'$val',$suc,$cli,$usu,'$detalle',$ope)");
#--ORDEN:codigo, presunro, presuvalidez, succod, clicod, usucod, detalle[item_cod, presu_cantidad, presu_precio], operacion
if(!$sql){
    echo pg_last_error()."_/_error";
}else{
    echo pg_last_notice($con->url)."_/_notice";
}
?>