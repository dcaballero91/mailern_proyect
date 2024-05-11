<?php

require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();

$sql = pg_query("select * from v_pedidos_vcab  order by 1");
$pedidoventas = pg_fetch_all($sql);
                                                                                         
$button_borrar = '<button type=\'button\' class=\'btn btn-primary  delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Anular\'><i class=\'fa fa-times\'></i></button>';
//$button_imp = "<a target='_blank' class='btn btn-mini' href='../informes/imp_pedido.php'>IMP<i class='fa md-clear'></i></a>";
$button = $button_borrar ;

//viene del js de mi tabla y el otro de mi vista en el postgres
//foreach trae todos los elementos de un array
$datos['data']=[];
foreach($pedidoventas as $key => $pedido){
		$datos['data'][$key]['cod'] = $pedido['ped_vcod'];
		$datos['data'][$key]['fun_cod'] = $pedido['fun_cod'];
		$datos['data'][$key]['nro'] = $pedido['nro'];
		$datos['data'][$key]['fecha'] = $pedido['fecha'];
		$datos['data'][$key]['cliente'] = $pedido['cli_nom'].' '.$pedido['cli_ape'];
        $datos['data'][$key]['cli_ruc'] = $pedido['cli_ruc'];
        $datos['data'][$key]['ruc'] = $pedido['emp_ruc'];
		$datos['data'][$key]['cli_direcc'] = $pedido['cli_dir'];
		$datos['data'][$key]['cli_email'] = $pedido['cli_email'];
		$datos['data'][$key]['estado'] = $pedido['ped_estado'];
		$datos['data'][$key]['acciones'] =  $button; 

    $sqldetalle = pg_query('select * from v_pedidos_vdet where ped_vcod='.$pedido['ped_vcod']);
   $detalles = pg_fetch_all($sqldetalle);
		
	foreach ($detalles as $key2 => $detalle) {
        $datos['data'][$key]['detalle'][$key2]['codigo'] = $detalle['ped_vcod'];
        $datos['data'][$key]['detalle'][$key2]['codigo'] = $detalle['item_cod'];
        $datos['data'][$key]['detalle'][$key2]['descripcion'] = $detalle['item_desc'];
        $datos['data'][$key]['detalle'][$key2]['cantidad'] = $detalle['ped_cantidad'];
        $datos['data'][$key]['detalle'][$key2]['precio'] = $detalle['ped_precio'];
					
		}
				
}
 echo  json_encode($datos);
 return json_encode($datos);

?>