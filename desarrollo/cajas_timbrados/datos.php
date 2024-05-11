<?php
require '../clases/conexion.php';

$cn = new conexion();
$cn->conectar();
$sqlitem = pg_query('select * from v_timbrado_cajas');
$lista = pg_fetch_all($sqlitem);    

$datos['data'] = [];
foreach($lista as $key => $list){
		$datos['data'][$key]['codigo'] = $list['caja_cod'];
		$datos['data'][$key]['caja'] = $list['caja_desc'];
		$datos['data'][$key]['timbrado'] = $list['timb_nro'];
		$datos['data'][$key]['ultfactura'] = $list['ultima_factura'];
		$datos['data'][$key]['ultrecibo'] = $list['ultimo_recibo'];
		$datos['data'][$key]['suc'] = $list['suc_nom'];
		$datos['data'][$key]['usu'] = $list['usu_name'];
		$datos['data'][$key]['estado'] = $list['timb_estado'];
                
		
		$datos['data'][$key]['acciones'] = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' data-toggle=\'modal\' data-target=\'#modal_basic\' data-placement=\'top\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>';
																					
	#	'.'<button type=\'button\' class=\'btn btn-danger btn-circle confirmar pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Eliminar\'><i class=\'fa fa-times\'></i></button>';

		
			
}
echo json_encode($datos);
return json_encode($datos);
?>