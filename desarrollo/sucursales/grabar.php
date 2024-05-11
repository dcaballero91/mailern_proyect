<?php
require '../clases/conexion.php';

$codigo = $_POST["codigo"];
$empresa = $_POST["emp"];
$sucursal = $_POST["suc"];
$direccion = $_POST["dir"];
$telefono = $_POST["tel"];
$email = $_POST["email"];
$ope = $_POST["ope"];

$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_sucursales(".$codigo.",".$empresa.",'".$sucursal."','".$direccion."','".$telefono."','".$email."',".$ope.")");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>


