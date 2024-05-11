<?php

require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("select * from v_pedidos_cab where ped_estado='PENDIENTE' order by 1");

$pedcompras = pg_fetch_all($sql);
$button_borrar = '<button type=\'button\' class=\'btn btn-primary  delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Borrar\'><i class=\'fa fa-minus\'></i></button>';
$button = $button_borrar;

$datos['data'] = [];
foreach ($pedcompras as $key => $pedidocompras) {
    $datos['data'][$key]['cod'] = $pedidocompras['ped_cod'];
    $datos['data'][$key]['fun_nom'] = $pedidocompras['fun_nom'];
    $datos['data'][$key]['nro'] = $pedidocompras['nro'];
    $datos['data'][$key]['fecha'] = $pedidocompras['fecha'];
    $datos['data'][$key]['ruc'] = $pedidocompras['emp_ruc'];
    $datos['data'][$key]['estado'] = $pedidocompras['ped_estado'];
    $datos['data'][$key]['acciones'] = $button;

    $sqldetalle = pg_query('select * from v_pedidos_det where ped_cod=' . $pedidocompras['ped_cod']);
    $detalles = pg_fetch_all($sqldetalle);

    foreach ($detalles as $key2 => $detalle) {

        $datos['data'][$key]['detalle'][$key2]['cod'] = $detalle['ped_cod'];
        $datos['data'][$key]['detalle'][$key2]['codigo'] = $detalle['item_cod'];
        $datos['data'][$key]['detalle'][$key2]['descripcion'] = $detalle['item_desc'];
        $datos['data'][$key]['detalle'][$key2]['marca'] = $detalle['mar_desc'];
        $datos['data'][$key]['detalle'][$key2]['cantidad'] = $detalle['ped_cantidad'];
        $datos['data'][$key]['detalle'][$key2]['precio'] = $detalle['ped_precio'];
    }
}

echo json_encode($datos);
return json_encode($datos);
?>