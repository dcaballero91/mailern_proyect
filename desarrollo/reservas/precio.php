<?php

require "../clases/conexion.php";
$cod = $_POST["cod"];
$con = new conexion();
$con ->conectar();
//$pre= $_POST["precio"];
$sql = pg_query("select item_precio from items where item_cod = '$cod'");
//("select item_venta from items where item_cod = '$cod'");
$precio = pg_fetch_assoc($sql);
echo $precio["item_precio"];