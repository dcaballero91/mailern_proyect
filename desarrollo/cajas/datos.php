<?php
require '../clases/conexion.php';

$cn = new conexion();
$cn->conectar();
$sqlista = pg_query('select * from v_cajas');
$lista = pg_fetch_all($sqlista);    

$datos['data'] = [];
foreach($lista as $key => $lista){
		$datos['data'][$key]['codigo'] = $lista['caja_cod'];
		$datos['data'][$key]['descri'] = $lista['caja_desc'];
		$datos['data'][$key]['ultrecibo'] = $lista['ultimo_recibo'];
		$datos['data'][$key]['usu'] = $lista['usu_name'];
		$datos['data'][$key]['suc'] = $lista['suc_nom'];
		$datos['data'][$key]['emp'] = $lista['emp_nom'];
		$datos['data'][$key]['estado'] = $lista['caja_estado'];
		
		$datos['data'][$key]['acciones'] = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' data-toggle=\'modal\' data-target=\'#modal_basic\' data-placement=\'top\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>'.'
																					
		'.'<button type=\'button\' class=\'btn btn-danger btn-circle desactivar pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Desactivar\'><i class=\'fa fa-times\'></i></button>'.'

		'. '<button type=\'button\' class=\'btn btn-success btn-circle activar pull-right\' data-toggle=\'modal\' data-target=\'#activacion\' data-placement=\'top\' title=\'Activar\'><i class=\'fa fa-check\'></i></button>';			
			
}
echo json_encode($datos);
return json_encode($datos);
?>