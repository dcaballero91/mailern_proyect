<?php

require "../clases/conexion.php";
$cod = $_POST["cod"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("select stock_cantidad from stock where item_cod = '$cod'");
$precio = pg_fetch_assoc($sql);
echo $precio["stock_cantidad"];