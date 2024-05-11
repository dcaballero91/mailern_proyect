<?php
require '../clases/conexion.php';
$dep = $_POST["dep"];
$suc = $_POST["suc"];
$con = new conexion();
$con->conectar();
// $sql = pg_query("SELECT * from v_stock where dep_cod ='$dep' and suc_cod = '$suc' ");
$sql = pg_query("SELECT * from items where item_cod in(select item_cod from v_stock where dep_cod = '$dep' and suc_cod = '$suc') ");
while($item = pg_fetch_assoc($sql)){
    $array [] = $item;
}
print_r(json_encode($array));

?>