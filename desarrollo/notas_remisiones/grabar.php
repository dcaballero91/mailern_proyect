<?php
require '../clases/conexion.php';
$codigo         = $_POST["codigo"];
$vencod         = $_POST["vencod"];
$vehiculo       = $_POST["vehiculo"];
$chofer         = $_POST["chofer"];
$tipoNota       = $_POST["tipoNota"];
$timbrado       = $_POST["timbrado"];
$timVig         = $_POST["timVig"];
$nroFact        = $_POST["nroFact"];
$montoFactura   = $_POST["montoFactura"];
$usu            = $_POST["usu"];
$suc            = $_POST["suc"];
$detalle        = $_POST["detalle"];
$ope            = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_notas_remisiones($codigo,$vencod,$vehiculo,$chofer,'$tipoNota',$timbrado,'$timVig','$nroFact','$montoFactura',$usu, $suc,'$detalle',$ope)");
# ORDEN: codigo, vencod, vehicod, chofercod, remisiontipo, chofertib, chofertimbvighasta, choferfactura, chofermonto, usu, suc, detalles, ope
if($sql){
    echo pg_last_notice($con->url)."_/_notice";
}else{
    echo pg_last_error()."_/_error";
}
?>