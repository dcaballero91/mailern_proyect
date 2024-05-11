<?php
require "../clases/conexion.php";
$cod = $_POST["cod"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("select emp_nom from v_sucursales where suc_cod = '$cod'");
$suc = pg_fetch_assoc($sql);
echo $suc["emp_nom"];
?>