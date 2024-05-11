<?php

require "../clases/conexion.php";
$cod = $_POST["cod"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("select mar_desc from v_items where item_cod = '$cod'");
$var = pg_fetch_assoc($sql);
echo $var["mar_desc"];
