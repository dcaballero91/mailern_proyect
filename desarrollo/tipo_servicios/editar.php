<?php
require '../clases/conexion.php';
$cod = $_POST['cod'];
$cn = new conexion();
$cn->conectar();
$sql = pg_query('select * from v_tipo_servicios where tipo_serv_cod='.$cod);
while($fila = pg_fetch_assoc($sql)){
    print_r(json_encode($fila));
}