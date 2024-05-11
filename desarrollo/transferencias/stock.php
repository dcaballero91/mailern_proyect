<?php
require '../clases/conexion.php';
$dep = $_GET['dep'];
$item = $_GET['item'];

$con = new conexion();
$con->conectar();

$sql= pg_query("SELECT stock_cantidad from stock where item_cod = '$item' and dep_cod = '$dep' ");
$rs = pg_fetch_assoc($sql);
echo $rs['stock_cantidad'];

?>