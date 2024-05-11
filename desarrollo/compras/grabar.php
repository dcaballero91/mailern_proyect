<?php
require '../clases/conexion.php';
$cod          = $_POST["cod"];
$proveedor    = $_POST["proveedor"];
$timbrado     = $_POST["timbrado"];
$timvighasta  = $_POST["timvighasta"];
$nrofact      = $_POST["nrofact"];
$fechafact    = $_POST["fechafact"];
$tipofact     = $_POST["tipo_factura"];
$plazo        = $_POST["plazo"];
$cuotas       = $_POST["cuotas"];
$suc          = $_POST["suc"];
$usu          = $_POST["usu"];
$detalle      = $_POST["detalle"];
$ope          = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_compras_new($cod, $proveedor, $timbrado, '$timvighasta', '$nrofact', '$fechafact', $tipofact, $plazo, $cuotas, $suc, $usu,'$detalle', $ope)");
#ORDEN: compcod,provcod,provtimbnro,provtimbvig,nro_factura,comp_fechafactura,tipofactcod,compplazo,compcuotas,succod,usucod,detallecompra[compcod,itemcod, marcod, cant,costo,precio,depcod ], operacion
if($sql){
  echo  pg_last_notice($con->url)."_/_notice";
}else{
    echo pg_last_error()."_/_error";
}
?>