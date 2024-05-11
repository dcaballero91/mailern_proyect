<?php
require "../clases/conexion.php";
$cod = $_GET['cod'];
$con = new conexion();
$con ->conectar();
$sql = pg_query("select * from v_items where item_cod = $cod ");
$rs = pg_fetch_assoc($sql);
print_r(json_encode($rs))
?>