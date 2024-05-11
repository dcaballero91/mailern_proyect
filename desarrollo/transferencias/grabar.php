<?php

require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$sucursal = $_POST["sucursal"];
$usu = $_POST["usu"];
// $empresa = $_POST["empresa"];
// $funcionario = $_POST["funcionario"];
$feenvio = $_POST["feenvio"];
$feentrega = $_POST["feentrega"];
$vehiculo = $_POST["vehiculo"];
$origen = $_POST["origen"];
$destino = $_POST["destino"];
$en = $_POST["en"];
$depositoo = $_POST["depositoo"];
$depositod = $_POST["depositod"];

$detalle = $_POST["detalle"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_transferencias($codigo,$sucursal,$usu,'$feenvio','$feentrega',$vehiculo,$origen,$destino,'$en',$depositoo, $depositod,'$detalle',$ope)");
#--ORDEN: codigo,succod,usucod,transfechaenvio,transfechaentrega,vehcod,transorigen,transdestino,transenviarrecibir,deporigen,depdestino,detalle{itemcod,tracant,tracant_rec],operacion
if($sql){
    echo pg_last_notice($con->url)."_/_notice";
}else{
    echo pg_last_error()."_/_error";
}
?>