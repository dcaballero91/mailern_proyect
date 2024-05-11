<?php
require '../clases/conexion.php';

$codigo = $_POST["codigo"];
$marca = $_POST["marca"];
$entidad = $_POST["entidad"];
$direccion = $_POST["dir"];
$telefono = $_POST["tel"];
$email = $_POST["email"];
$emisora = $_POST["emisora"];
$ope = $_POST["ope"];

$con = new conexion();
$con->conectar();
 
$sql = pg_query("select sp_entidades_adheridas(".$codigo.",".$emisora.",".$marca.",'".$entidad."','".$direccion."','".$telefono."','".$email."',".$ope.")");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>


