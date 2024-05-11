<?php

require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("SELECT  * FROM v_agendas_cab  ORDER BY agen_cod DESC");
$agendas = pg_fetch_all($sql);

if(!empty($agendas)){
    $button_borrar = '<button type=\'button\' class=\'btn btn-primary  delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Borrar\'><i class=\'fa fa-minus\'></i></button>';
    // $button_editar = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' data-toggle=\'modal\' data-target=\'#modal_basic\' data-placement=\'top\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>';
    $button_editar = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>';
    $button = $button_borrar . ' ' . $button_editar;
    
    $datos['data'] = [];
    foreach ($agendas as $key => $agendas) {
        $datos['data'][$key]['codigo'] = $agendas['agen_cod'];
        $datos['data'][$key]['fecha'] = $agendas['agen_fecha'];
        $datos['data'][$key]['funcionario'] = $agendas['fun_cod'].' - '.$agendas['fun_nom'];
        $datos['data'][$key]['estado'] = $agendas['agen_estado'];
        $datos['data'][$key]['acciones'] = $button;
    
        $sqldetalle = pg_query('select * from v_agendas_det where agen_cod=' . $agendas['agen_cod']);
        $detalles = pg_fetch_all($sqldetalle);
        
        foreach ($detalles as $key2 => $detalle) {
            $datos['data'][$key]['detalle'][$key2]['codigo'] = $detalle['agen_cod'];
            $datos['data'][$key]['detalle'][$key2]['dias'] = $detalle['dias_desc'];
            $datos['data'][$key]['detalle'][$key2]['hora_desde'] = $detalle['hora_desde'];
            $datos['data'][$key]['detalle'][$key2]['hora_hasta'] = $detalle['hora_hasta'];
        }
    }
    echo json_encode($datos);
    return json_encode($datos);
}else{
    $datos['data'] = [];
    $datos['data']['codigo'] = "-";
    $datos['data']['fecha'] = "-";
    $datos['data']['funcionario'] = "-";
    $datos['data']['estado'] = "-";
    $datos['data']['acciones'] = "-";
    
    echo json_encode($datos);
    return json_encode($datos);
}

?>