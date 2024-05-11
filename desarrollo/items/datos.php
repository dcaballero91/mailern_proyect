<?php
require '../clases/conexion.php';

$cn = new conexion();
$cn->conectar();
$sqlitem = pg_query('select * from v_items');
$items = pg_fetch_all($sqlitem);    

$datos['data'] = [];
foreach($items as $key => $item){
	
		//$datos['data'][$key]['descri'] =  "<label title = '".$item['item_auditoria']."'>".$item['item_desc']."</label>";
		$datos['data'][$key]['codigo'] =$item['item_cod'];
		$datos['data'][$key]['descri'] =$item['item_desc'];
		$datos['data'][$key]['precio'] =$item['item_precio'];
		 $datos['data'][$key]['tipo_item'] = $item['tipo_item_desc'];
		 $datos['data'][$key]['imp'] = $item['tipo_imp_desc'];
		$datos['data'][$key]['estado'] = $item['item_estado'];
		
		$datos['data'][$key]['acciones'] = "<button type='button' class='btn btn-info btn-circle pull-right editar' data-toggle='modal' data-target='#confirmacion' data-placement='top' title='Editar'><i class='fa fa-edit'></i></button>".
		"<button type='button' class='btn btn-danger btn-circle eliminar pull-right' data-toggle='modal' data-target='#desactivacion' data-placement='top' title='Desactivar'><i class='fa fa-times'></i></button>".
		"<button type='button' class='btn btn-success btn-circle activar pull-right' data-toggle='modal' data-target='#activacion' data-placement='top' title='Activar'><i class='fa fa-check'></i></button>";	

		/*
		 $datos['data'][$key]['acciones'] = "<button type='button' class='btn btn-info btn-circle pull-right editar'  id ='btn_editar' data-placement='top'><i class='fa fa-edit'></i></button>".
		"<button type='button' class='btn btn-danger btn-circle eliminar pull-right' data-toggle='modal' data-target='#desactivacion' data-placement='top' title='Desactivar'><i class='fa fa-times'></i></button>".
		 "<button type='button' class='btn btn-success btn-circle activar pull-right' data-toggle='modal' data-target='#activacion' data-placement='top' title='Activar'><i class='fa fa-check'></i></button>";	
		 */

			
}
echo json_encode($datos);
return json_encode($datos);
?>