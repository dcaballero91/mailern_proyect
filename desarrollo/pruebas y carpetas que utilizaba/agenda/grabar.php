<?php

require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$prof = $_POST["profesion"];
$fun = $_POST["funcionario"];
$detalle = $_POST["detalle"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_agendas($codigo,$prof,$fun,'$detalle','$ope')");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>