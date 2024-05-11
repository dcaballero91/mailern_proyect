<?php
require '../clases/conexion.php';
$cod = $_POST["cod"];
$con = new conexion();
$con->conectar();
$sql = pg_query(" select * from v_timbrado_cajas where caja_cod = '$cod' ");
while($rs = pg_fetch_assoc($sql)){
print_r(json_encode($rs));
}
?>