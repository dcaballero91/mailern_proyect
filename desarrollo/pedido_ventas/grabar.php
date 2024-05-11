<?php

require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$nro = $_POST["nro"];
$suc = $_POST["suc"];
$cli = $_POST["cli"];
$usu = $_POST["usu"];
$detalle = $_POST["detalle"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_pedidos_ventas($codigo,$suc,$nro,$usu,$cli,'$detalle',$ope)");
#--ORDEN: codigo, succod, pednro, usucod, clicod, detalles[], operacion
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>