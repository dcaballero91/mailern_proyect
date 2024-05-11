<?php
require '../clases/conexion.php';
$cod = $_GET['cod'];
$con = new conexion();
$con->conectar();
$sql = pg_query("SELECT * FROM ordenes_trabajos_cab WHERE cli_cod = '$cod' AND ord_trab_estado = 'PENDIENTE' AND ord_trab_fecha::date = CURRENT_DATE ORDER BY ord_trab_cod ");

$verificar = pg_fetch_all($sql);
if(empty($verificar)){// Verifacamos si la respuesta esta vacia o no
    echo  "error";
}else{
    while($rs = pg_fetch_assoc($sql)){
        $array[] = $rs;
    }
    print_r(json_encode($array));
}


?>