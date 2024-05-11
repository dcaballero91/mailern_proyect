<?php
require '../clases/conexion.php';

$cn = new conexion();
$cn->conectar();
$sqlitem = pg_query('select * from v_timbrados');
$items = pg_fetch_all($sqlitem);    

$datos['data'] = [];
foreach($items as $key => $item){
	
		//$datos['data'][$key]['descri'] =  "<label title = '".$item['item_auditoria']."'>".$item['item_desc']."</label>";
		$datos['data'][$key]['codigo'] =$item['timb_cod'];
		$datos['data'][$key]['descri'] =$item['timb_nro'];
		$datos['data'][$key]['vigdesde'] = $item['tim_vigdesde'];
		$datos['data'][$key]['vighasta'] = $item['tim_vighasta'];
		$datos['data'][$key]['nrodesde'] = $item['tim_nrodesde'];
		$datos['data'][$key]['nrohasta'] = $item['tim_nrohasta'];
		$datos['data'][$key]['ultfact'] = $item['tim_ultfactura'];
		$datos['data'][$key]['puntexp'] = $item['puntoexp'];
		$datos['data'][$key]['suc'] = $item['suc_nom'];
		$datos['data'][$key]['estado'] = $item['timb_estado'];
		
		$datos['data'][$key]['acciones'] = "<button type='button' class='btn btn-info btn-circle pull-right editar' data-toggle='modal' data-target='#confirmacion' data-placement='top' title='Editar'><i class='fa fa-edit'></i></button>";


		// BOTONES A HABILITAR SI QUIERO PODER CAMBAIR EL ESTADO DE TIMBRADOS 
		
		// "<button type='button' class='btn btn-danger btn-circle eliminar pull-right' data-toggle='modal' data-target='#desactivacion' data-placement='top' title='Desactivar'><i class='fa fa-times'></i></button>".
		// "<button type='button' class='btn btn-success btn-circle activar pull-right' data-toggle='modal' data-target='#activacion' data-placement='top' title='Activar'><i class='fa fa-check'></i></button>";	

		/*
		 $datos['data'][$key]['acciones'] = "<button type='button' class='btn btn-info btn-circle pull-right editar'  id ='btn_editar' data-placement='top'><i class='fa fa-edit'></i></button>".
		"<button type='button' class='btn btn-danger btn-circle eliminar pull-right' data-toggle='modal' data-target='#desactivacion' data-placement='top' title='Desactivar'><i class='fa fa-times'></i></button>".
		 "<button type='button' class='btn btn-success btn-circle activar pull-right' data-toggle='modal' data-target='#activacion' data-placement='top' title='Activar'><i class='fa fa-check'></i></button>";	
		 */

			
}
echo json_encode($datos);
return json_encode($datos);
?>