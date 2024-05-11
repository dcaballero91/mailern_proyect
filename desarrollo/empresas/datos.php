<?php
require '../clases/conexion.php';

$cn = new conexion();
$cn->conectar();
$sqlitem = pg_query('select * from empresas');
$empresa = pg_fetch_all($sqlitem);    

$datos['data'] = [];
foreach($empresa as $key => $emp){
		$datos['data'][$key]['codigo'] = $emp['emp_cod'];
		$datos['data'][$key]['empresa'] = $emp['emp_nom'];
		$datos['data'][$key]['ruc'] = $emp['emp_ruc'];
		$datos['data'][$key]['direccion'] = $emp['emp_dir'];
		$datos['data'][$key]['telefono'] = $emp['emp_tel'];
		$datos['data'][$key]['email'] = $emp['emp_email'];
                
		
		$datos['data'][$key]['acciones'] = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' data-toggle=\'modal\' data-target=\'#modal_basic\' data-placement=\'top\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>'.'
																					
		'.'<button type=\'button\' class=\'btn btn-danger btn-circle confirmar pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Eliminar\'><i class=\'fa fa-times\'></i></button>';

		
			
}
echo json_encode($datos);
return json_encode($datos);
?>