<?php
require '../clases/conexion.php';
require '../clases/sesion.php';
$codigo = $_POST["codigo"];
$fun= $_POST["fun"];
$usu = $_POST["usu"];
$pass = $_POST['pass'];
$gru = $_POST['gru'];
$suc = $_POST['suc'];
$foto = $_POST['foto'];
// $usuario = $_SESSION["usu"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_usuarios(".$codigo.",".$fun.",".$suc.",'".$usu."','".$pass."',".$gru.",'".$foto."',".$ope.")");

# $sql = pg_query("select sp_perso(".$codigo.",'".$nom."','".$ape."','".$dir."','".$tel."','".$ruc."','".$ci."','".$fenaci."','".$email."',#".$nac.",".$esta.",".$ciu.",".$gen.",".$tipo.",'".$usuario."',".$ope.")");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>