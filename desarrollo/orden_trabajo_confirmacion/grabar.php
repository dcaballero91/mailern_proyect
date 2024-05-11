<?php
require '../clases/conexion.php';
$con = new conexion();
$con->conectar();
$codigo = $_POST["codigo"];
$sucursal = $_POST["sucursal"];
$usuario = $_POST["usuario"];
$cliente = $_POST["cliente"];
$detalle = $_POST["detalle"];
$ope = $_POST["ope"];

$sql = pg_query("select sp_ordenes_trabajos(".$codigo.",".$sucursal.",".$cliente.",".$usuario.",'".$detalle."',".$ope.")");

$noticia=pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);