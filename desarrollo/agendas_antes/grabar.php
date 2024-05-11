<?php

require '../clases/conexion.php';

$codigo = $_POST["codigo"];
$usu = $_POST["usu"];
$suc = $_POST["suc"];
$fun = $_POST["fun"];
$horadesde = $_POST["horadesde"];
$horahasta = $_POST["horahasta"];
$dias = $_POST["dias"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();

$sql = pg_query("select sp_agendas($codigo,$usu,$suc,$fun,'$horadesde','$horahasta',$dias,$ope)");
#select sp_agendas(0,1,1,3,'20:00:01','20:20:00',10,1,1)
#ORDEN: codigo, usucod, succod, funagen, hdesde, hhasta, agencupos, diascod, operacion
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>