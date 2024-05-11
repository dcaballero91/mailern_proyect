<?php
require '../clases/conexion.php';

$cn = new conexion();
$cn->conectar();
$sql = pg_query('select * from v_entidades_adheridas');
$entidad_adherida = pg_fetch_all($sql);    



$datos['data'] = [];
foreach($entidad_adherida as $key => $entidad_adherida){
		$datos['data'][$key]['codigo'] = $entidad_adherida['ent_ad_cod'];
		$datos['data'][$key]['entidad'] = $entidad_adherida['ent_ad_nom'];
		$datos['data'][$key]['emisora'] = $entidad_adherida['ent_nom'];
		$datos['data'][$key]['dir'] = $entidad_adherida['ent_ad_dir'];
		$datos['data'][$key]['marca'] = $entidad_adherida['mar_tarj_desc'];
		$datos['data'][$key]['tel'] = $entidad_adherida['ent_ad_tel'];
		$datos['data'][$key]['email'] = $entidad_adherida['ent_ad_email'];
		
		
		
		
		
		$datos['data'][$key]['acciones'] = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' data-toggle=\'modal\' data-target=\'#modal_basic\' data-placement=\'top\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>'.'
																					
		'.'<button type=\'button\' class=\'btn btn-danger btn-circle confirmar pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Eliminar\'><i class=\'fa fa-times\'></i></button>';			
			
}
echo json_encode($datos);
return json_encode($datos);
?>