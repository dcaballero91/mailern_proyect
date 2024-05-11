<?php
require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("select * from v_notas_remisiones_cab  order by nota_rem_cod " ); 

$transferencia = pg_fetch_all($sql);
$rows = pg_num_rows($sql);                                                                                         

$button_anular = '<button type=\'button\' class=\'btn btn-primary btn-circle btn-lg  delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Anular\'><i class=\'fa fa-times\'></i></button>';

$button = $button_anular;

$datos['data']=[];

foreach($transferencia as $key => $cab){
    $datos['data'][$key]['nro'] = $cab['nota_rem_cod'];
    $datos['data'][$key]['fecha'] = $cab['nota_rem_fecha'];
    $datos['data'][$key]['empresa'] = $cab['emp_nom'];
    $datos['data'][$key]['funcionario'] = $cab['fun_nom'];
    $datos['data'][$key]['vehiculo'] = $cab['veh_desc'];
    $datos['data'][$key]['sucursal'] = $cab['suc_nom'];
    $datos['data'][$key]['estado'] = $cab['nota_rem_estado'];
    $datos['data'][$key]['acciones'] =  $button; 

    $sqldetalle = pg_query('select * from v_notas_remisiones_detalles where nota_rem_cod ='.$cab['nota_rem_cod']);
    $detalles = pg_fetch_all($sqldetalle);
        
    foreach ($detalles as $key2 => $detalle) {
        $datos['data'][$key]['detalle'][$key2]['nro'] = $detalle['nota_rem_cod'];
        $datos['data'][$key]['detalle'][$key2]['item'] = $detalle['item_desc'];
        $datos['data'][$key]['detalle'][$key2]['marca'] = $detalle['mar_desc'];
        $datos['data'][$key]['detalle'][$key2]['cantidad'] = $detalle['nota_rem_cant'];
        $datos['data'][$key]['detalle'][$key2]['precio'] = $detalle['nota_rem_precio'];
    }         
}
echo  json_encode($datos);
return json_encode($datos);

?>



















