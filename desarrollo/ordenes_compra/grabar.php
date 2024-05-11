<?php

require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$plazo = $_POST["plazo"];
$cuotas = $_POST["cuotas"];
$suc = $_POST["suc"];
$usu = $_POST["usu"];
$proveedor = $_POST["proveedor"];
$tipo_factura = $_POST["tipo_factura"];
$detalle = $_POST["detalle"];
$ope = $_POST["ope"];
// $emp = $_POST["emp"];
// $nro = $_POST["nro"];
// $fun = $_POST["fun"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_ordenes_compras($codigo,$plazo,$cuotas,$suc,$usu,$proveedor,$tipo_factura,'$detalle',$ope)");
#--ORDEN: ordencod,ordenro,ordenplazo,ordencuotas,succod,usucod,provcod,tipofactcod, detalle[ ultcod,itemcod,ordencantidad,ordenprecio ], operacion
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>