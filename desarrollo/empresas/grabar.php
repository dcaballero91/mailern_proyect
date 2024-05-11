<?php
require '../clases/conexion.php';
$cod = $_POST["codigo"];
$emp = $_POST["empresa"];
$ruc = $_POST['ruc'];
$dir = $_POST['direccion'];
$tel = $_POST['telefono'];
$email = $_POST['email'];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_empresas(".$cod.",'".$emp."','".$ruc."','".$dir."','".$tel."','".$email."',".$ope.")");

$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>

