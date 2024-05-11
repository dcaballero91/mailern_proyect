<?php

require "../clases/conexion.php";
$cod = $_POST["cod"];
$mar = $_POST["mar"];
$suc = $_POST["suc"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("select sum(stock_cantidad) as stock_cantidad from v_stock where item_cod = '$cod' and mar_cod = '$mar' and suc_cod = '$suc' ");
$precio = pg_fetch_assoc($sql);
echo $precio["stock_cantidad"];