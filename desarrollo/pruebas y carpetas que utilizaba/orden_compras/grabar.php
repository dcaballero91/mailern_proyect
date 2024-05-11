<?php

require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$nro = $_POST["nro"];
$plazo = $_POST["plazo"];
$cuotas = $_POST["cuotas"];
$suc = $_POST["suc"];
$emp = $_POST["emp"];
$usu = $_POST["usu"];
$fun = $_POST["fun"];
$proveedor = $_POST["proveedor"];
$tipo_factura = $_POST["tipo_factura"];
$detalle = $_POST["detalle"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_orden_compras($codigo,$nro,$plazo,$cuotas,$suc,$emp,$usu,$fun,$proveedor,$tipo_factura,'$detalle','$ope')");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>