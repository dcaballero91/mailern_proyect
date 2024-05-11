<?php
 
require '../clases/conexion.php';
$cod = $_POST["cod"];
$suc = $_POST["suc"];
$cli = $_POST["cli"];
$usu = $_POST["usu"];
$fecha = $_POST["rfecha"];
// $agencod = $_POST["agencod"];
$detalle = $_POST["detalle"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_reservas($cod,$suc,$cli,$usu,'$fecha','$detalle',$ope)");
#--ORDEN: codigo, succod, clicod, usucod,fecha, detalle[reserhdesde, reserhasta, precio, item_cod, descripcion, fun_cod], operacion
if(!$sql){
    echo pg_last_error()."_/_error";
}else{
    echo pg_last_notice($con->url)."_/_notice";
    
}

// $noticia2 = pg_last_error($con->url);
// echo str_replace("ERROR: ","",$noticia2);
?>