<?php
require '../clases/conexion.php';
$cod = $_POST['cod'];
$cn = new conexion();
$cn->conectar();
$sql = pg_query('select * from v_entidades_adheridas where ent_ad_cod='.$cod);
while($fila = pg_fetch_assoc($sql)){
    print_r(json_encode($fila));
}