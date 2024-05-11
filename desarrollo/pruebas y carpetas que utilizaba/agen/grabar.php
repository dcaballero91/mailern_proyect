<?php

require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$prof = $_POST["profesion"];
$fun = $_POST["funcionario"];
$fecha = $_POST["fecha"];
$detalle = $_POST["detalle"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_agen($codigo,$prof,$fun,'$fecha','$detalle','$ope')");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>