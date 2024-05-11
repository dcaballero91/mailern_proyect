<?php
require '../clases/conexion.php';
// $cod = $_GET['cod'];
// $depcod = $_GET['depcod'];

// $con = new conexion();
// $con->conectar();
// $sql = pg_query("SELECT stock_cantidad FROM v_stock WHERE item_cod = '$cod'AND dep_cod = '$depcod' ");
// $rs = pg_fetch_assoc($sql);
// echo $rs['stock_cantidad'];

// while($rs = pg_fetch_assoc($sql)){
//     $array[] = $rs;
// }

// print_r(json_encode($array));

// <?php

// require "../clases/conexion.php";
$item = $_POST["item"];
$mar = $_POST["mar"];
$dep = $_POST["dep"];
$suc = $_POST["suc"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("SELECT stock_cantidad from v_stock where item_cod = '$item' and mar_cod = '$mar' and dep_cod = '$dep' and suc_cod = '$suc' ");
$precio = pg_fetch_assoc($sql);
echo $precio["stock_cantidad"];
?>