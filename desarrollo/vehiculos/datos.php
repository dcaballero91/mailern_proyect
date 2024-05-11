<?php
require '../clases/conexion.php';

$cn = new conexion();
$cn->conectar();
$sql = pg_query('select * from v_vehiculos');
$lista = pg_fetch_all($sql);    



$datos['data'] = [];
foreach($lista as $key => $lista){
		$datos['data'][$key]['codigo'] = $lista['vehi_cod'];
		$datos['data'][$key]['marca'] = $lista['veh_mar_desc'];
		$datos['data'][$key]['modelo'] = $lista['veh_mod_desc'];
		$datos['data'][$key]['chapa'] = $lista['veh_chapa'];
		$datos['data'][$key]['estado'] = $lista['veh_estado'];

		
		
		$datos['data'][$key]['acciones'] = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' data-toggle=\'modal\' data-target=\'#modal_basic\' data-placement=\'top\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>'.'
																					
		
                '.'<button type=\'button\' class=\'btn btn-danger btn-circle eliminar pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Desactivar\'><i class=\'fa fa-times\'></i></button>'.'

                '. '<button type=\'button\' class=\'btn btn-success btn-circle activar pull-right\' data-toggle=\'modal\' data-target=\'#activacion\' data-placement=\'top\' title=\'Activar\'><i class=\'fa fa-check\'></i></button>'; 			
			
}
echo json_encode($datos);
return json_encode($datos);
?>