<?php
require '../clases/conexion.php';

$codigo = $_POST["codigo"];
$apermonto = $_POST["apermonto"];
$caja = $_POST["caja"];
$ope = $_POST["ope"];
$usu = $_POST["usu"];
// $ciermonto= $_POST["ciermonto"];
// $usuario = $_POST["usuario"];
// $sucursal = $_POST["sucursal"];
// $empresa = $_POST["empresa"];
// $funcionario = $_POST["funcionario"];
$con = new conexion(); 
$con->conectar();
$sql = pg_query("select sp_aperturas_cierres(".$codigo.",".$apermonto.",".$caja.",".$usu.",".$ope.")");

if(!$sql){
	echo pg_last_error()."_/_error";
}else{
	echo pg_last_notice($con->url)."_/_notice";
}
// $noticia = pg_last_notice($con->url);
// echo str_replace("NOTICE: ","",$noticia);
?>



