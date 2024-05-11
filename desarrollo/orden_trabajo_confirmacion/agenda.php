<?php
require '../clases/conexion.php';
$con = new conexion();
$con->conectar();
$fecha = $_POST["fecha"];
$hdesde = $_POST["hdesde"];
$hhasta = $_POST["hhasta"];
$dia = $_POST["dia"];
$sql = pg_query("select * from listar_funcionarios1($dia,'$fecha','$hdesde','$hhasta')");
#--ORDEN: dia, fecha, hdesde, hhasta

// $sql =pg_query(" select agen_cod,fun_agen, fun_agen_nom 
// from v_agendas 
// where (v_agendas.fun_agen not in (
//     select fun_agen 
//     from v_reservas_det 
//     where  fecha_reser = '$fecha' 
//         and  (('$hdesde' between reser_hdesde and reser_hhasta)
//         or ('$hhasta' between reser_hdesde and reser_hhasta))
// )and dias_cod = '$dia' and ('$hdesde' between hora_desde and hora_hasta and '$hhasta' between hora_desde and hora_hasta))");    
// if($sql = null){
//     echo "no hay func disp";
// }
if(!$sql){
    echo pg_last_error()."_/_error";
}else{

    while ($rs = pg_fetch_assoc($sql)){
        $array[] = $rs; 
    };
    print_r(json_encode($array));
    echo pg_last_notice($con->url)."_/_notice";
    
}

?>