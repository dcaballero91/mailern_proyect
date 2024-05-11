<?php

require '../clases/conexion.php';
$proveedor = $_POST["proveedor"];
$timbrado = $_POST["timbrado"];
$nrofact = $_POST["nrofact"];
$fechafact = $_POST["fechafact"];
$tipofact = $_POST["tipo_factura"];
$plazo = $_POST["plazo"];
$cuotas = $_POST["cuotas"];
$suc = $_POST["suc"];
$usu = $_POST["usu"];
$detalle = $_POST["detalle"];
$ope = $_POST["ope"];
// $depcod = $_POST["depcod"];
// $emp = $_POST["emp"];
// $fun = $_POST["fun"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_compras($proveedor,$timbrado,'$nrofact','$fechafact',$tipofact,$plazo,$cuotas,$suc,$usu,'$detalle',$ope)");
#--ORDEN: provcod,provtimbnro,factura,fechafact,tipofact,plazo,cuotas,succod,usu,detalle[item,marca,cant,precio,deposito],operacion
if($sql){
  echo  pg_last_notice($con->url)."_/_notice";
}else{
    echo pg_last_error()."_/_error";
}
?>