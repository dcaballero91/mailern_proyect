<?php
require '../clases/conexion.php';

$codigo = $_POST["codigo"];
$efectivo = $_POST["efectivo"];
$aperciercod = $_POST["aperciercod"];
$usu = $_POST["usuario"];
$suc = $_POST["sucursal"];
$fcobro = $_POST["fcobro"];
$vencod = $_POST["vencod"];
$detalleTarjetas = $_POST["detalleTarjetas"];
$detalleCheques = $_POST["detalleCheques"];
$montoDisponible = $_POST["montoDisponible"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();

$sql = pg_query("select sp_cobros($codigo,$efectivo,$aperciercod, $usu,$suc,$fcobro,$vencod,'$detalleTarjetas','$detalleCheques',$montoDisponible,$ope)");
#Orden: codigo, cobefectivo, aperciercod, usucod, sucod, fcobcod, vencod, detTarjetas, detCheques, montoTotal, oper
if(!$sql){
    echo pg_last_error()."_/_error";
}else{
    echo pg_last_notice($con->url)."_/_notice";
}
// $noticia = pg_last_notice($con->url);
// echo str_replace("NOTICE: ","",$noticia);


?>