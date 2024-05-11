<?php

require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("SELECT * FROM v_ajustes_cab ORDER BY ajus_cod DESC ");

$ajustes = pg_fetch_all($sql);

$button_borrar = '<button type=\'button\' class=\'btn btn-primary btn-circle btn-lg delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Anular\'><i class=\'fa fa-minus\'></i></button>';

$button = $button_borrar;

$datos['data'] = [];
foreach ($ajustes as $key => $ajustecab) {
    $ajus_cod = $ajustecab['ajus_cod'];

    $datos['data'][$key]['codigo'] = $ajustecab['ajus_cod'];
    $datos['data'][$key]['fecha'] = $ajustecab['fecha_ajuste'];
    $datos['data'][$key]['empresa'] = $ajustecab['emp_nom'];
    $datos['data'][$key]['sucursal'] = $ajustecab['suc_nom'];
    $datos['data'][$key]['funcionario'] = $ajustecab['fun_nom'];
    // $datos['data'][$key]['usuario'] = $ajustecab['id'];
    $datos['data'][$key]['tipoajuste'] = $ajustecab['ajus_tipo'];
    $datos['data'][$key]['estado'] = $ajustecab['ajus_estado'];
    $datos['data'][$key]['acciones'] = $button;

    $sqldetalle = pg_query(" SELECT * FROM v_ajustes_det WHERE ajus_cod = '$ajus_cod' ");
    $detalles = pg_fetch_all($sqldetalle);

    foreach ($detalles as $key2 => $detalle) {

        $datos['data'][$key]['detalle'][$key2]['cod'] = $detalle['ajus_cod'];
        // $datos['data'][$key]['detalle'][$key2]['cod'] = $detalle['item_cod'];
        $datos['data'][$key]['detalle'][$key2]['dep'] = $detalle['dep_desc'];
        $datos['data'][$key]['detalle'][$key2]['item'] = $detalle['item_desc'];
        $datos['data'][$key]['detalle'][$key2]['marca'] = $detalle['mar_desc'];

        $datos['data'][$key]['detalle'][$key2]['motivo'] = $detalle['mot_desc'];
        $datos['data'][$key]['detalle'][$key2]['cantidad'] = $detalle['ajus_cantidad'];
    }
}

echo json_encode($datos);
return json_encode($datos);
?>