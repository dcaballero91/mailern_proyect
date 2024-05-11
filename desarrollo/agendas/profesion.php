<?php

require "../clases/conexion.php";
$cod = $_POST["cod"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("select prof_desc from v_especialidades where esp_cod = '$cod'");

$profesion = pg_fetch_assoc($sql);
echo $profesion["prof_desc"];