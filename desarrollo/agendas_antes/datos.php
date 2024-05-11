<?php

require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("select * from v_agendas   order by agen_cod desc");

$agendas = pg_fetch_all($sql);


$button_borrar = '<button type=\'button\' class=\'btn btn-primary  delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Borrar\'><i class=\'fa fa-minus\'></i></button>';

$button_editar = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' data-toggle=\'modal\' data-target=\'#modal_basic\' data-placement=\'top\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>';



$button = $button_borrar . ' ' . $button_editar;



$datos['data'] = [];
foreach ($agendas as $key => $agendas) {
    $datos['data'][$key]['codigo'] = $agendas['agen_cod'];
    $datos['data'][$key]['funcionario'] = $agendas['fun_agen_nom'];
    $datos['data'][$key]['horadesde'] = $agendas['hora_desde'];
    $datos['data'][$key]['horahasta'] = $agendas['hora_hasta'];
    $datos['data'][$key]['dias'] = $agendas['dias_desc'];
    $datos['data'][$key]['estado'] = $agendas['agen_estado'];
    $datos['data'][$key]['acciones'] = $button;


}//el detalle si se va usar debe ir dentro de esta llave

    // $sqldetalle = pg_query('select * from v_agendas_det where agen_cod=' . $agendas['agen_cod']);
    // $detalles = pg_fetch_all($sqldetalle);

    // foreach ($detalles as $key2 => $detalle) {
    //     $datos['data'][$key]['detalle'][$key2]['codigo'] = $detalle['esp_cod'];
    //     $datos['data'][$key]['detalle'][$key2]['especialidad'] = $detalle['esp_desc'];
    //     $datos['data'][$key]['detalle'][$key2]['dias'] = $detalle['dias_desc'];
    //      $datos['data'][$key]['detalle'][$key2]['fecha'] = $detalle['agen_fecha'];
    //     $datos['data'][$key]['detalle'][$key2]['hora_desde'] = $detalle['agen_hdesde'];
    //     $datos['data'][$key]['detalle'][$key2]['hora_hasta'] = $detalle['agen_hhasta'];
    //     $datos['data'][$key]['detalle'][$key2]['cupo'] = $detalle['agen_cupos'];
    // }

echo json_encode($datos);
return json_encode($datos);
?>