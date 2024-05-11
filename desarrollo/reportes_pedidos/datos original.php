<?php

// $desde = $_GET["desde"];
// $hasta = $_GET["hasta"];
$suc = 0; //$_GET["suc"];
$fun = 0; // $_GET["fun"];

if ($suc == 0 && $fun == 0){
   // $where = "where ped_estado != 'ANULADO' and fecha BETWEEN '$desde' and '$hasta' order by 1";
     $where = "where ped_estado != 'ANULADO' and fecha BETWEEN '2019-12-31' and '2020/12/31' order by 1";
}elseif($suc !== 0 && $fun !== 0){
    $where = "where ped_estado != 'ANULADO' and fecha BETWEEN '$desde' and '$hasta' and suc_cod = $suc and fun_cod = $fun order by 1";
}elseif ($fun == 0){
    $where = "where ped_estado != 'ANULADO' and fecha BETWEEN '$desde' and '$hasta' order by 1";
}elseif($fun !== 0){
    $where = "where ped_estado != 'ANULADO' and fecha BETWEEN '$desde' and '$hasta' and fun_cod = $fun order by 1";
}elseif ($suc == 0){
    $where = "where ped_estado != 'ANULADO' and fecha BETWEEN '$desde' and '$hasta' order by 1";
}elseif($suc !== 0){
    $where = "where ped_estado != 'ANULADO' and fecha BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
}
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$sql = pg_query("select * from v_pedidos_compras_cab");
$rows = pg_num_rows($sql);
while($cab = pg_fetch_array($sql)){
    $button_imp = "<a target='_blank' class='btn btn-info btn-mini' href='../informes/imp_pedidocompras.php?id=".$cab["ped_nro"]."'>Imprimir<i class='fa md-clear'></i></a>";
    $detalle = detalle($cab["ped_nro"]);
    $total = 0;
    foreach ($detalle as $valor){

         $prec = $valor["precio"];

         $subtotal = $prec;
        $total = $total + $subtotal;
       
    }
    $array[] = array('cod' => $cab["ped_nro"],
        'fecha' => $cab["fecha"],
        'proveedor' => $cab["fun_nom"],
        'prov_ruc' => $cab["emp_ruc"],
        'prov_direcc' => $cab["suc_dir"],
        'prov_email' => $cab["suc_email"],
        'fun_cod' => $cab["fun_cod"],
        'estado' => $cab["ped_estado"],
        'acciones' => $button_imp,
        'total' => number_format($total,0,',','.').' Gs.','detalle' => $detalle);
    $data = array('data' => $array);
    $json = json_encode($data);  
}
print_r(utf8_decode($json));

function detalle($cod){
    $sql0 = pg_query('select * from v_pedidos_compras_det where ped_nro = '.$cod.'');
    while ($det = pg_fetch_array($sql0)){
    $detalle[] = array('ped_nro' => $det["ped_nro"],
        'items_cod' => $det["item_cod"],
        'descri' => $det["item_desc"],
        'descrip' => $det["mar_desc"],
        
        'hasta' => $det["ped_cantidad"],
        'precio' => $det["ped_precio"]);
    }
    return $detalle;
}

?>