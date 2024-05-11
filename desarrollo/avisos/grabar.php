<?php

require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$des = $_POST["des"];
$suc = $_POST["suc"];
$emp = $_POST["emp"];
$fun = $_POST["funcionario"];
$serv = $_POST["serv"];
$cli = $_POST["cli"];
$hora = $_POST["hora"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_avisos($codigo,'$des','$emp','$suc','$fun','$serv','$cli','$hora','$ope')");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>