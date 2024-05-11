<?php

$desde = $_GET["desde"];
$hasta = $_GET["hasta"];
$cliente = $_GET["cliente"];
$fun = $_GET["fun"];
if ($cliente == 0 && $fun == 0){
    $where = "where reser_estado != 'ANULADO' and reser_fecha BETWEEN '$desde' and '$hasta' order by 1";
}elseif($cliente !== 0 && $fun !== 0){
    $where = "where reser_estado != 'ANULADO' and reser_fecha BETWEEN '$desde' and '$hasta' and cli_cod = $cliente and fun_cod = $fun order by 1";
}elseif ($fun == 0){
    $where = "where reser_estado != 'ANULADO' and reser_fecha BETWEEN '$desde' and '$hasta' order by 1";
}elseif($fun !== 0){
    $where = "where reser_estado != 'ANULADO' and reser_fecha BETWEEN '$desde' and '$hasta' and fun_cod = $fun order by 1";
}elseif ($cliente == 0){
    $where = "where reser_estado != 'ANULADO' and reser_fecha BETWEEN '$desde' and '$hasta' order by 1";
}elseif($cliente !== 0){
    $where = "where reser_estado != 'ANULADO' and reser_fecha BETWEEN '$desde' and '$hasta' and cli_cod = $cliente order by 1";
}
require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("select * from v_reservas_cab ");
$rows = pg_num_rows($sql);
while($cab = pg_fetch_array($sql)){
    $button_imp = "<a target='_blank' class='btn btn-info btn-mini' href='../informes/imp_reporte_reserva.php?cod=".$cab["reser_cod"]."'>Imprimir<i class='fa md-clear'></i></a>";
    $detalle = detalle($cab["reser_cod"]);
    $total = 0;
    foreach ($detalle as $valor){

         $prec = $valor["precio"];

         $subtotal = $prec;
        $total = $total + $subtotal;
       
    }
    $array[] = array('cod' => $cab["reser_cod"],
        'fecha' => $cab["reser_fecha"],
        'cliente' => $cab["cli_nom"],
       // 'prov_ruc' => $cab["cli_ruc"],
        'cli_direcc' => $cab["cli_dir"],
       // 'prov_email' => $cab["cli_email"],
        'fun_cod' => $cab["fun_cod"],
        'estado' => $cab["reser_estado"],
        'acciones' => $button_imp,
        'total' => number_format($total,0,',','.').' Gs.','detalle' => $detalle);
    $data = array('data' => $array);
    $json = json_encode($data,JSON_UNESCAPED_UNICODE);
}
print_r (utf8_decode($json));
function detalle($cod){
    $sql0 = pg_query('select * from v_reservas_det where reser_cod = '.$cod.' order by 1');
    while ($det = pg_fetch_array($sql0)){
    $detalle[] = array('reser_cod' => $det["reser_cod"],
        'items_cod' => $det["tipo_serv_cod"],
        'descri' => $det["reser_desc"],
        'descrip' => $det["tipo_serv_desc"],
        'desde' => $det["reser_hdesde"],
        'hasta' => $det["reser_hhasta"],
        'precio' => $det["tipo_serv_precio"]);
    }
    return $detalle;
}
?>