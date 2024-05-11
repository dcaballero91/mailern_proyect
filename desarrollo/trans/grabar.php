<?php
require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$cod = $_POST["cod"];
$emp = $_POST["emp"];
$suc = $_POST["suc"];
$fun = $_POST["fun"];
$vehi = $_POST["vehi"];
$envi = $_POST["envi"];
$entre = $_POST["entre"];
$ori = $_POST["ori"];
$des = $_POST["des"];

$depo = $_POST["depo"];
$en = $_POST["en"];
$detalle = $_POST["detalle"];
$ope = $_POST["ope"];

$sql = pg_query("select sp_tran(".$cod.",".$fun.",".$suc.",".$emp.",".$vehi.",'".$envi."','".$entre."',".$ori.",".$des.",".$depo.",".$en.",'".$detalle."','".$ope."')");
$noticia=pg_last_notice($cn->url);
echo str_replace("NOTICE: ","",$noticia);