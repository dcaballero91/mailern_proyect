<?php
require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$descri = $_POST["descri"];
$vruc = $_POST['vruc'];
$vdirec = $_POST['vdirec'];
$vtel = $_POST['vtel'];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_empresa(".$codigo.",'".$descri."','".$vruc."','".$vdirec."','".$vtel."','".$ope."')");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>