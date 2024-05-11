<?php

session_start();
require_once '../clases/conexion2.php';

$sql = "select * from v_aperturas_cierres where usu_cod = ". $_SESSION['id'] ." and fecha_cierreformat isnull;";
$result = consultas::get_datos($sql);
//echo $sql;
if($result[0]['aper_cier_cod']){
     $_SESSION['cod'] = $result[0]['aper_cier_cod'];
     $_SESSION['caja'] = $result[0]['caja_cod'];
echo "LA <strong>". $result[0]['caja_desc'] ."</strong> ESTÁ ABIERTA CON MONTO ACTUAL DE <strong>".  number_format(($result[0]['monto_efectivo']+$result[0]['monto_cheque']+$result[0]['monto_tarjeta']), 0, ",", ".")."</strong>";
}else{
    echo "0";
}
//echo $sql;
?>
