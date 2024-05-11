<?php
require '../clases/conexion.php';
require '../clases/sesion.php';
$codigo = $_POST["codigo"];
$nom = $_POST["nom"];
$ape = $_POST['ape'];
$dir = $_POST['dir'];
$tel = $_POST['tel'];
$ci = $_POST['ci'];
$fenaci = $_POST['fenaci'];
$email = $_POST['email'];
$nac = $_POST['nac'];
$ciu = $_POST['ciu'];
$gen = $_POST['gen'];
$tipo = $_POST['tipo'];
$esta = $_POST['esta'];
// $usuario = $_SESSION["usu"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_personas(".$codigo.",'".$nom."','".$ape."','".$dir."','".$tel."','".$ci."','".$fenaci."','".$email."',".$nac.",".$ciu.",".$gen.",".$tipo.",'".$esta."',".$ope.")");

# $sql = pg_query("select sp_perso(".$codigo.",'".$nom."','".$ape."','".$dir."','".$tel."','".$ruc."','".$ci."','".$fenaci."','".$email."',#".$nac.",".$esta.",".$ciu.",".$gen.",".$tipo.",'".$usuario."',".$ope.")");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>