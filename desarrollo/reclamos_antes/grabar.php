<?php
require '../clases/conexion.php';
// $con = pg_connect("host='localhost' dbname='corregido' port='5432' user='postgres' password='123'  ");

$codigo = $_POST["codigo"];
$tipo = $_POST["tipo"];
$reclamo = $_POST["reclamo"];
$sucr = $_POST["sucr"];
$cli = $_POST["cli"];
$fecharecla = $_POST["fechareclamo"];
$usu = $_POST["usu"];
$tipor = $_POST["tipor"];
$suc = $_POST["suc"];
$ope = $_POST["ope"];

$con = new conexion();
$con->conectar();  
#   --select sp_reclamos_clientes1(1,1,'me gustaria que lo precios se mejoracen',1,1,'2020-01-01',1,2,1,1)
#	--ORDEN: reclamocod, tipreclamo, reclamodesc, sucreclamo, clicod, reclafechacli, usucod, tiporeclamoitem,succod operacion

$sql = pg_query("select sp_reclamos_clientes(".$codigo.",".$tipor.",'".$reclamo."',".$sucr.",".$cli.",'".$fecharecla."',".$usu.",".$tipo.",".$suc.",".$ope.")");

if(!$sql){
    echo pg_last_error()."_/_error";
}else{
echo pg_last_notice($con->url)."_/_notice";
   
}
// $noticia = pg_last_notice($con->url);
// echo str_replace("NOTICE: ","",$noticia);
?>


