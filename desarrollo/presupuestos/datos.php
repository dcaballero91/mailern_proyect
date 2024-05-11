<?php

require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("select * from v_presupuestos_cab where presu_cod in (select presu_cod from v_presupuestos_detalles) order by presu_cod");

$pedcompras = pg_fetch_all($sql);
$button_borrar = '<button type=\'button\' class=\'btn btn-primary  delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Borrar\'><i class=\'fa fa-minus\'></i></button>';
$button = $button_borrar;

if(!empty($pedcompras)){

    $datos['data'] = [];
    foreach ($pedcompras as $key => $pedidocompras) {
        $datos['data'][$key]['cod'] = $pedidocompras['presu_cod'];
        // $datos['data'][$key]['fun_nom'] = $pedidocompras['fun_nom'];
        $datos['data'][$key]['fecha'] = $pedidocompras['presu_fecha'];
        $datos['data'][$key]['fechav'] = $pedidocompras['presu_validez'];
        // $datos['data'][$key]['ruc'] = $pedidocompras['emp_nom'];
        $datos['data'][$key]['suc'] = $pedidocompras['suc_nom'];
        $datos['data'][$key]['usu'] = $pedidocompras['usu_name'];
        $datos['data'][$key]['estado'] = $pedidocompras['presu_estado'];
        $datos['data'][$key]['acciones'] = $button;
    
        $sqldetalle = pg_query('select * from v_presupuestos_detalles where presu_cod='.$pedidocompras['presu_cod']);
        $detalles = pg_fetch_all($sqldetalle);
    
        foreach ($detalles as $key2 => $det) {
    
            $datos['data'][$key]['detalle'][$key2]['cod'] = $det['presu_cod'];
            $datos['data'][$key]['detalle'][$key2]['codigo'] = $det['item_cod'];
            $datos['data'][$key]['detalle'][$key2]['descripcion'] = $det['item_desc'];
            $datos['data'][$key]['detalle'][$key2]['marcas'] = $det['mar_desc'];
    
            $datos['data'][$key]['detalle'][$key2]['cantidad'] = $det['presu_cantidad'];
            $datos['data'][$key]['detalle'][$key2]['precio'] = $det['presu_precio'];
        }
    }
    
    echo json_encode($datos);
    return json_encode($datos);

}else{
    $datos['data']['cod'] = '-';
         $datos['data']['cod'] = '-';
         $datos['data']['fun_nom'] = '-';
         $datos['data']['nro'] = '-';
         $datos['data']['fecha'] = '-';
         $datos['data']['fechav'] = '-';
         $datos['data']['suc'] = '-';
         $datos['data']['usu'] = '-';
         $datos['data']['estado'] = '-';
         $datos['data']['acciones'] =  '-';

         echo  json_encode($datos);
         return json_encode($datos);

}

?>