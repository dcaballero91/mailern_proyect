<?php

$desde = $_GET["desde"];
$hasta = $_GET["hasta"];
$suc = $_GET["suc"];
$fun = $_GET["fun"];
if ($suc == 0 && $fun == 0){
    $where = "where ped_estado != 'ANULADO' and ped_fecha BETWEEN '$desde' and '$hasta' order by 1";
}elseif($suc !== 0 && $fun !== 0){
    $where = "where ped_estado != 'ANULADO' and ped_fecha BETWEEN '$desde' and '$hasta' and suc_cod = $suc and fun_cod = $fun order by 1";
}elseif ($fun == 0){
    $where = "where ped_estado != 'ANULADO' and ped_fecha BETWEEN '$desde' and '$hasta' order by 1";
}elseif($fun !== 0){
    $where = "where ped_estado != 'ANULADO' and ped_fecha BETWEEN '$desde' and '$hasta' and fun_cod = $fun order by 1";
}elseif ($suc == 0){
    $where = "where ped_estado != 'ANULADO' and ped_fecha BETWEEN '$desde' and '$hasta' order by 1";
}elseif($suc !== 0){
    $where = "where ped_estado != 'ANULADO' and ped_fecha BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
}
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$sql = pg_query("select * from v_pedidos_cab2 $where");
$rows = pg_num_rows($sql);
while($cab = pg_fetch_array($sql)){
    $button_imp = "<a target='_blank' class='btn btn-info btn-mini' href='../informes/imp_pedidocompras.php?id=".$cab["ped_cod"]."'>Imprimir<i class='fa md-clear'></i></a>";
    $detalle = detalle($cab["ped_cod"]);
    $total = 0;
    foreach ($detalle as $valor){

         $prec = $valor["precio"];

         $subtotal = $prec;
        $total = $total + $subtotal;
       
    }
    $array[] = array('cod' => $cab["ped_cod"],
        'fecha' => $cab["ped_fecha"],
        'proveedor' => $cab["fun_nom"],
        'prov_ruc' => $cab["fun_ape"],
        'prov_direcc' => $cab["fun_dir"],
        'prov_email' => $cab["fun_email"],
        'fun_cod' => $cab["fun_cod"],
        'estado' => $cab["ped_estado"],
        'acciones' => $button_imp,
        'total' => number_format($total,0,',','.').' Gs.','detalle' => $detalle);
    $data = array('data' => $array);
    $json = json_encode($data,JSON_UNESCAPED_UNICODE);
}
print_r (utf8_decode($json));
function detalle($cod){
    $sql0 = pg_query('select * from v_pedidos_det where ped_cod = '.$cod.' order by 1');
    while ($det = pg_fetch_array($sql0)){
    $detalle[] = array('ped_cod' => $det["ped_cod"],
        'items_cod' => $det["item_cod"],
        'descri' => $det["item_desc"],
        'descrip' => $det["mar_desc"],
        
        'hasta' => $det["ped_cantidad"],
        'precio' => $det["ped_precio"]);
    }
    return $detalle;
}
?>