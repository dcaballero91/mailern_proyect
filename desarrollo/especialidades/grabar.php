<?php
require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$esp = $_POST["especialidad"];
// $est = $_POST["estado"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_especialidades(".$codigo.",'".$esp."',".$ope.")");
if(!$sql){
    echo pg_last_error()."_/_error";
}else{
  echo  pg_last_notice($con->url)."_/_notice";
}
// $noticia = pg_last_notice($con->url);
// echo str_replace("NOTICE: ","",$noticia);
?>
