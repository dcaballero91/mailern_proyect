<?php

require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$suc = $_POST["suc"];
$usu = $_POST["usu"];
$detalle = $_POST["detalle"];
$ope = $_POST["ope"];
// $emp = $_POST["emp"];
// $nro = $_POST["nro"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_pedidos_compras($codigo,$suc,$usu,'$detalle',$ope)");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>