<?php
require '../clases/conexion.php';
$notanro          = $_POST["notanro"];
$compcod          = $_POST["compcod"];
$fechafactura     = $_POST["fechafactura"];
$timbrado         = $_POST["timbrado"];
$timbradovighasta = $_POST["timbradovighasta"];
$nrofactura       = $_POST["nrofactura"];
$tiponota         = $_POST["tipo_nota"];
$tipomotnota      = $_POST["tipo_mot_nota"];
$suc              = $_POST["suc"];
$usu              = $_POST["usu"];
$notamonto        = $_POST["notamonto"];
$desc             = $_POST["desc"];
$detalle          = $_POST["detalle"];
$ope              = $_POST["ope"];

$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_notas_compras_new($notanro, $compcod, '$fechafactura ', '$timbrado', '$timbradovighasta', '$nrofactura', '$tiponota', '$tipomotnota',$usu, $suc, $notamonto, '$desc','$detalle', $ope)");
//-- ORDEN: notanro, compcod, notacomfechafactura, notacomtimbrado, notacomtimvighasta, notacomfactura, notatipo, usucod, succod, notamonto, notadesc, detalle[], operacion

if($sql){
  echo  pg_last_notice($con->url)."_/_notice";
}else{
  echo pg_last_error()."_/_error";
}
?>