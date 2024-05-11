<?php

require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("select * from v_reservas_cab where reser_estado != 'ANULADO' order by 1");

$reservas = pg_fetch_all($sql);
                                                                                          

$button_borrar = '<button type=\'button\' class=\'btn btn-primary delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Borrar\'><i class=\'fa fa-minus\'></i></button>';



$button = $button_borrar;



$datos['data']=[];
foreach($reservas as $key => $cab){
		$datos['data'][$key]['cod'] = $cab['reser_cod'];
		// $datos['data'][$key]['freserva'] = $cab['reser_dfecha'];	
        $datos['data'][$key]['empresa'] = $cab['emp_nom'];
        $datos['data'][$key]['sucursal'] = $cab['suc_nom'];
        $datos['data'][$key]['funcionario'] = $cab['usu_name'];
		$datos['data'][$key]['cliente'] = $cab['cli_nom'];   
       // $datos['data'][$key]['especialidad'] = $cab['esp_desc'];
		// $datos['data'][$key]['funcionario'] = $cab['fun_nom'];
        $datos['data'][$key]['estado'] = $cab['reser_estado'];
		$datos['data'][$key]['acciones'] =  $button;




		$sqldetalle = pg_query('select * from v_reservas_det where reser_cod='.$cab['reser_cod']);
		$detalles = pg_fetch_all($sqldetalle);
		
		foreach ($detalles as $key2 => $det) {
        $datos['data'][$key]['detalle'][$key2]['cod'] = $det['item_cod']; 
         $datos['data'][$key]['detalle'][$key2]['tservicio'] = $det['item_desc'];
         $datos['data'][$key]['detalle'][$key2]['funnom'] = $det['fun_nom'];
        $datos['data'][$key]['detalle'][$key2]['hdesde'] = $det['reser_hdesde'];
        $datos['data'][$key]['detalle'][$key2]['hhasta'] = $det['reser_hhasta'];
         $datos['data'][$key]['detalle'][$key2]['sugerencias'] = $det['reser_desc'];
        $datos['data'][$key]['detalle'][$key2]['precio'] = $det['reser_precio'];
					
		}

				
}


 echo  json_encode($datos);
 return json_encode($datos);

?>