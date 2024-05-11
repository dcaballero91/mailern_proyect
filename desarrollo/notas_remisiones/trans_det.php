<?php
require '../clases/conexion.php';
$con = new conexion();
$con->conectar();
$transcab = $_POST['transcab'];
$sql = pg_query("select * from transferencias_det where (select trans_estado from transferencias_cab where trans_cod = '$transcab') = 'PENDIENTE' and trans_cod = '$transcab' ");

$verificar = pg_fetch_all($sql);

if(!empty($verificar)){
    while($rs = pg_fetch_assoc($sql)){
        $array[] = $rs;
    };
    print_r(json_encode($array));
    
}else{
    $error = 'error';
    echo $error;
}

?>