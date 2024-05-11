<?php
require '../clases/conexion.php';

$item = $_POST["item"];
$marca = $_POST['marca'];
$costo= $_POST['costo'];
$precio = $_POST['precio'];
$itemmin = $_POST['min'];
$itemmax = $_POST['max'];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select sp_marcas_items(".$item.",".$marca.",".$costo.",".$precio.",".$itemmin.",".$itemmax.", ".$ope." )");
#-- ORDER: itemcod, marcod, itemcosto, itemprecio, itemmin, itemmax, operacion

$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);
?>

