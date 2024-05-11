<?php
require '../clases/conexion.php';
$cod = $_POST['codigo'];
$cn = new conexion();
$cn->conectar();
$sql = pg_query('select * from v_aperturas_cierres where aper_cier_cod='.$cod);
while($fila = pg_fetch_assoc($sql)){
    print_r(json_encode($fila));
}