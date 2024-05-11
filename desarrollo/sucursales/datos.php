<?php
require '../clases/conexion.php';

$cn = new conexion();
$cn->conectar();
$sql = pg_query('select * from v_sucursales');
$sucursal = pg_fetch_all($sql);    



$datos['data'] = [];
foreach($sucursal as $key => $sucursal){
		$datos['data'][$key]['codigo'] = $sucursal['suc_cod'];
		$datos['data'][$key]['emp'] = $sucursal['emp_nom'];
		$datos['data'][$key]['suc'] = $sucursal['suc_nom'];
		$datos['data'][$key]['dir'] = $sucursal['suc_dir'];
		$datos['data'][$key]['tel'] = $sucursal['suc_tel'];
		$datos['data'][$key]['email'] = $sucursal['suc_email'];
		$datos['data'][$key]['estado'] = $sucursal['suc_estado'];
		
		
		$datos['data'][$key]['acciones'] = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' data-toggle=\'modal\' data-target=\'#modal_basic\' data-placement=\'top\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>'.'
																					
		'.'<button type=\'button\' class=\'btn btn-danger btn-circle confirmar pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Eliminar\'><i class=\'fa fa-times\'></i></button>'.'

		'.'<button type=\'button\' class=\'btn btn-success btn-circle activar pull-right\' data-toggle=\'modal\' data-target=\'#activacion\' data-placement=\'top\' title=\'Activar\'><i class=\'fa fa-check\'></i></button>';			
			
}
echo json_encode($datos);
return json_encode($datos);
?>