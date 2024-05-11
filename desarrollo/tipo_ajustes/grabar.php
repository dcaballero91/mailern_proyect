<?php
require '../clases/conexion.php';
$cod = $_POST["cod"];
$des = $_POST["desc"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_tipo_ajustes(".$cod.",'".$des."',".$ope.")");
if(!$sql){
    echo  pg_last_error()."_/_error";
  }else{
    echo  pg_last_notice($con->url)."_/_notice";
  }
// $noticia = pg_last_notice($con->url);
// echo str_replace("NOTICE: ","",$noticia);
?>