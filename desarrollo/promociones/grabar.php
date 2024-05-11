<?php

require '../clases/conexion.php';
$cod = $_POST["cod"];
//$dfecha = $_POST["dfecha"];
$feinicio = $_POST["feinicio"];
$fefin = $_POST["fefin"];
$usu = $_POST["usu"];
$suc = $_POST["suc"];
$prodesc = $_POST["prodesc"];
$detalle = $_POST["detalle"];
// $tipodesc = $_POST["tipodesc"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_promociones($cod,'$feinicio','$fefin',$usu,$suc,'$prodesc','$detalle',$ope)");
// -- 	ORDEN: codigo, promoinicio, promofin, usucod, succod, promodesc, detalle[], operacion
//(ultcod,current_date,feinicio,fefin,'PENDIENTE')
if(!$sql){
    echo pg_last_error()."_/_error";
}else{
    echo pg_last_notice($con->url)."_/_notice";
}
?>