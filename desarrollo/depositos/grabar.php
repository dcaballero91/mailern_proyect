<?php
require '../clases/conexion.php';

$codigo = $_POST["codigo"];
$empresa = $_POST["empresa"];
$sucursal = $_POST["sucursal"];
$deposito = $_POST["deposito"];

$ope = $_POST["ope"];   

$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_depositos(".$codigo.",".$empresa.",".$sucursal.",'".$deposito."',".$ope.")");
$noticia = pg_last_notice($con->url);
//$error = preg_last_error($con->url); debo aprender a manejar los errores para mostrar los mensajes
echo str_replace("NOTICE: ","",$noticia);
?>


