<?php

require "../clases/conexion.php";
$item = $_POST["cod"];
$mar = $_POST["mar"];
$dep = $_POST["dep"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("SELECT stock_cantidad from stock where item_cod = '$item' and mar_cod = '$mar' and  dep_cod = '$dep' ");
$precio = pg_fetch_assoc($sql);
echo $precio["stock_cantidad"];