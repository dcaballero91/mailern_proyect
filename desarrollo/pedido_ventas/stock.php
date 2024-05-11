<?php

require "../clases/conexion.php";
$item = $_POST["item"];
$mar = $_POST["mar"];
$suc = $_POST["suc"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("SELECT stock_cantidad from v_stock where item_cod = '$item' and mar_cod = '$mar' and suc_cod = '$suc' ");
$precio = pg_fetch_assoc($sql);
echo $precio["stock_cantidad"];
?>