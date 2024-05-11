<?php

require "../clases/conexion.php";
$cod = $_POST["cod"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("select tipo_item_desc from v_items where item_cod = '$cod'");
$tipoitem = pg_fetch_assoc($sql);
echo $tipoitem["tipo_item_desc"];