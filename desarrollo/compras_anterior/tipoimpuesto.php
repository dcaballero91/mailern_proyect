<?php
require "../clases/conexion.php";
$cod = $_POST["cod"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("select item_tipo_impuesto from items where item_cod = '$cod'");
$precio = pg_fetch_assoc($sql);
echo $precio["item_tipo_impuesto"];
?>
