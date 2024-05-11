<?php


require "../clases/conexion.php";
$cod = $_POST["item"];
$mar = $_POST["mar"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("select precio from marcas_items where item_cod = '$cod' and mar_cod = '$mar' ");
$precio = pg_fetch_assoc($sql);
echo $precio["precio"];

?>