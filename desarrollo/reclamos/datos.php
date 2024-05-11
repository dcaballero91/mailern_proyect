<?php
require '../clases/conexion.php';

$cn = new conexion();
$cn->conectar();
$sql = pg_query('SELECT *, to_char(reclamo_fecha_cliente, \'dd/mm/yyyy\'::text ) AS reclamo_fecha_c FROM v_reclamos_sugerencias ORDER BY reclamo_cod');
$sucursal = pg_fetch_all($sql);    



$datos['data'] = [];
foreach($sucursal as $key => $reclamo){
		$datos['data'][$key]['codigo'] = $reclamo['reclamo_cod'];
		$datos['data'][$key]['fecha'] = $reclamo['reclamo_fecha'];
		$datos['data'][$key]['fechareclamo'] = $reclamo['reclamo_fecha_c'];
		$datos['data'][$key]['cli'] = $reclamo['cli_nom'];
        $datos['data'][$key]['tipo'] = $reclamo['tipo_recl_item_desc'];
        $datos['data'][$key]['reclamo'] = $reclamo['tipo_reclamo_desc'];
		$datos['data'][$key]['suc'] = $reclamo['sucursal_reclamo'];
		$datos['data'][$key]['usuario'] = $reclamo['usu_name'];
        $datos['data'][$key]['estado'] = $reclamo['reclamo_estado'];
		// $datos['data'][$key]['empresa'] = $reclamo['emp_nom'];
		// $datos['data'][$key]['hora'] = $reclamo['reclamo_hora'];
		
		
		$datos['data'][$key]['acciones'] = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' data-toggle=\'modal\' data-target=\'#modal_basic\' data-placement=\'top\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>'.'
																					
		'.'<button type=\'button\' class=\'btn btn-danger btn-circle eliminar pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Desactivar\'><i class=\'fa fa-times\'></i></button>'.'

		'. '<button type=\'button\' class=\'btn btn-success btn-circle activar pull-right\' data-toggle=\'modal\' data-target=\'#activacion\' data-placement=\'top\' title=\'Analizar\'><i class=\'fa fa-check\'></i></button>';		
			
}
echo json_encode($datos);
return json_encode($datos);
?>