<?php

require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("SELECT * FROM v_ordenes_trabajos_cab ");
$reservas = pg_fetch_all($sql);                                                                             

$button_borrar = '<button type=\'button\' class=\'btn btn-primary delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Anular\'><i class=\'fa fa-minus\'></i></button>';

// $button_ordenar = '<button type=\'button\' class=\'btn btn-success ordenar pull-right\' title=\'Ordenar\'><i class=\'fa fa-plus\'></i></button>';
$button = $button_borrar;
if(!empty($reservas)){   
    $datos['data']=[];
    foreach($reservas as $key => $cab){
        $datos['data'][$key]['cod'] = $cab['ord_trab_cod'];
        $datos['data'][$key]['empresa'] = $cab['emp_nom'];
        $datos['data'][$key]['sucursal'] = $cab['suc_nom'];
        $datos['data'][$key]['funcionario'] = $cab['usu_name'];
        $datos['data'][$key]['cliente'] = $cab['cli_nom'];   
        $datos['data'][$key]['estado'] = $cab['ord_trab_estado'];
        $datos['data'][$key]['acciones'] =  $button;

        $sqldetalle = pg_query('select * from v_ordenes_trabajos_det where ord_trab_cod ='.$cab['ord_trab_cod']);
        $detalles = pg_fetch_all($sqldetalle);
        
        foreach ($detalles as $key2 => $det) {
            $datos['data'][$key]['detalle'][$key2]['cod'] = $det['item_cod']; 
            $datos['data'][$key]['detalle'][$key2]['tservicio'] = $det['item_desc'];
            $datos['data'][$key]['detalle'][$key2]['hdesde'] = $det['orden_hdesde'];
            $datos['data'][$key]['detalle'][$key2]['hhasta'] = $det['orden_hhasta'];
            $datos['data'][$key]['detalle'][$key2]['sugerencias'] = $det['ord_trab_desc'];
            $datos['data'][$key]['detalle'][$key2]['precio'] = $det['orden_precio'];
        }
    }  
    echo  json_encode($datos);
    return json_encode($datos);
        
}else{
    $datos['data']=[];
    $datos['data']['cod'] = '-';
    $datos['data']['empresa'] = '-';
    $datos['data']['sucursal'] = '-';
    $datos['data']['funcionario'] = '-';
    $datos['data']['cliente'] = '-';   
    $datos['data']['estado'] ='-';
    $datos['data']['acciones'] =  '-';
    
    echo  json_encode($datos);
    return json_encode($datos);
}
?>