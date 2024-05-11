<?php
require '../clases/conexion.php';
  $notanro    = $_POST["notanro"];
  $vencod     = $_POST["vencod"];
  $nrofact    = $_POST["nrofactura"];
  $timbrado   = $_POST["timbrado"];
  $clicod     = $_POST["clicod"];
  $tiponota   = $_POST["tipo_nota"];
  $motivonota = $_POST["tipo_mot_nota"];
  $notamonto  = $_POST["notamonto"];
  $desc       = $_POST["desc"];
  $detalle    = $_POST["detalle"];
  $suc        = $_POST["suc"];
  $usu        = $_POST["usu"];
  $ope        = $_POST["ope"];
  $con = new conexion();
  $con->conectar();
  $sql = pg_query("SELECT * FROM sp_notas_ventas($notanro, $vencod, '$nrofact', 6, $clicod, '$tiponota', '$motivonota', $notamonto, '$desc', $usu, $suc, '$detalle', $ope)");
  //ORDEN: codigo, vencod, notavenfact, timbcod, clicod, notaventipo, notavenmotivo, notamonto, notadescripcion, usu, suc, detalles[], ope

  if($sql){
    echo  pg_last_notice($con->url)."_/_notice";
  }else{
    echo pg_last_error()."_/_error";
  }
?>