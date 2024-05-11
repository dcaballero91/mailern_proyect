<?php
require '../clases/conexion.php';
$cod = $_POST["cod"];
$con = new conexion();
$con->conectar();
$sql = pg_query("select * from v_agendas where agen_cod = '$cod' ");
while($rs = pg_fetch_assoc($sql)){
    print_r(json_encode($rs));
}
?>