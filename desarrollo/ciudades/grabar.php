<?php
require '../clases/conexion.php';
$cod = $_POST["cod"];
$des = $_POST["desc"];
$pais = $_POST["pais"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_ciudades(".$cod.",'".$des."',".$pais.",".$ope.")");

if(!$sql){
    echo  pg_last_error()."_/_error";
  }else{
    echo  pg_last_notice($con->url)."_/_notice";
  }
// $noticia = pg_last_notice($con->url);
// echo str_replace("NOTICE: ","",$noticia);
?>