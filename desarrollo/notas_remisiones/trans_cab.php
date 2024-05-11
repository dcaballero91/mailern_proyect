<?php
require '../clases/conexion.php';
$con = new conexion();
$con->conectar();
$transcab = $_POST['transcab'];
$sql = pg_query("select trans_cod,to_char(trans_fecha_envio, 'yyyy-mm-dd') as fecha_envio,to_char(current_date, 'yyyy-mm-dd') as fecha_entrega, vehi_cod,trans_origen, trans_destino  from transferencias_cab where (select trans_estado from transferencias_cab where trans_cod = '$transcab') = 'PENDIENTE' and trans_cod = '$transcab' ");

$verificar = pg_fetch_all($sql);

if(!empty($verificar)){
    while($trans_cab = pg_fetch_assoc($sql)){
        $array[] = $trans_cab;
    };
    print_r(json_encode($array));

}else{
    $error = 'error';
    echo $error;
}

?>
    