<?php

require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("select * from v_avisos_recordatorios where aviso_estado='PENDIENTE' order by 1");

$pedcompras = pg_fetch_all($sql);
$button_borrar = '<button type=\'button\' class=\'btn btn-primary  delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Borrar\'><i class=\'fa fa-minus\'></i></button>';
$button = $button_borrar;

$datos['data'] = [];
foreach ($pedcompras as $key => $pedidocompras) {
    $datos['data'][$key]['cod'] = $pedidocompras['aviso_cod'];
    $datos['data'][$key]['funcionario'] =$pedidocompras['fun_nom']."  ".$pedidocompras['fun_ape'];
    $datos['data'][$key]['cli_nom'] = $pedidocompras['cli_nom']."  ".$pedidocompras['cli_ape'];;
    $datos['data'][$key]['tipo_serv'] = $pedidocompras['tipo_serv_desc'];
    $datos['data'][$key]['hora'] = $pedidocompras['aviso_hora'];
    $datos['data'][$key]['des'] = $pedidocompras['aviso_desc'];
    $datos['data'][$key]['acciones'] = $button;

    
}

echo json_encode($datos);
return json_encode($datos);
?>