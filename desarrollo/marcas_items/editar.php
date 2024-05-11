<?php
require '../clases/conexion.php';
$itemcod= $_POST["itemcod"];
$marcod = $_POST["marcod"];
$con = new conexion();
$con->conectar();
$sql = pg_query(" select * from v_marcas_items where item_cod = '$itemcod' and mar_cod = '$marcod' ");
while($rs = pg_fetch_assoc($sql)){
print_r(json_encode($rs));
}
?>