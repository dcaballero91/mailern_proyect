<?php
require '../clases/conexion.php';
require '../clases/sesion.php';
$codigo = $_POST["codigo"];
$nom = $_POST["nom"];
$car = $_POST["car"];
$prof = $_POST["prof"];
$esp = $_POST["esp"];

// $usuario = $_SESSION["usu"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_funcionarios(".$codigo.",".$nom.",".$car.",".$prof.",".$esp.",".$ope.")");

# $sql = pg_query("select sp_perso(".$codigo.",'".$nom."','".$ape."','".$dir."','".$tel."','".$ruc."','".$ci."','".$fenaci."','".$email."',#".$nac.",".$esta.",".$ciu.",".$gen.",".$tipo.",'".$usuario."',".$ope.")");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>