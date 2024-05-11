<?php
require '../clases/conexion.php';

$cn = new conexion();
$cn->conectar();
$sqlitem = pg_query('select * from v_marcas_items');
$lista = pg_fetch_all($sqlitem);    

$datos['data'] = [];
foreach($lista as $key => $list){
		$datos['data'][$key]['item'] = $list['item_cod'].' - '.$list["item_desc"];
		$datos['data'][$key]['marca'] = $list['mar_cod'].' - '.$list["mar_desc"];
		$datos['data'][$key]['costo'] = $list['costo'];
		$datos['data'][$key]['precio'] = $list['precio'];
		$datos['data'][$key]['itemmin'] = $list['item_min'];
		$datos['data'][$key]['itemmax'] = $list['item_max'];
		$datos['data'][$key]['estado'] = $list['item_estado'];
		$datos['data'][$key]['tipoimp'] = $list['tipo_imp_desc'];
		// $datos['data'][$key]['estado'] = $list['timb_estado'];
                
		
		$datos['data'][$key]['acciones'] = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' data-toggle=\'modal\' data-target=\'#modal_basic\' data-placement=\'top\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>'
																					
		.'<button type=\'button\' class=\'btn btn-danger btn-circle eliminar pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Eliminar\'><i class=\'fa fa-times\'></i></button>'.'

        '.'<button type=\'button\' class=\'btn btn-success btn-circle activar pull-right\' data-toggle=\'modal\' data-target=\'#activacion\' data-placement=\'top\' title=\'Activar\'><i class=\'fa fa-check\'></i></button>'.'

        '.'<button type=\'button\' class=\'btn btn-warning btn-circle desactivar pull-right\' data-toggle=\'modal\' data-target=\'#desactivacion\' data-placement=\'top\' title=\'Desactivar \'><i class=\'fa fa-info\'></i></button>';

		
			
}
echo json_encode($datos);
return json_encode($datos);
?>