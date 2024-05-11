
<?php

require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("select * from v_compras_cab  order by 1");
$tabla = pg_fetch_all($sql);
//$rows = pg_num_rows($sql);

$button_anular = '<button type=\'button\' class=\'btn btn-primary btn-circle btn-lg  delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Anular\'><i class=\'fa fa-times\'></i></button>';

$button = $button_anular;

$datos['data'] = [];

foreach ($tabla as $key => $cab) {
    $datos['data'][$key]['codigo'] = $cab['comp_cod'];
    $datos['data'][$key]['nro'] = $cab['comp_nro'];
    $datos['data'][$key]['ffactura'] = $cab['comp_fecha_fact'];
    $datos['data'][$key]['proveedor'] = $cab['prov_nombre'];
    $datos['data'][$key]['plazo'] = $cab['comp_plazo'];
    $datos['data'][$key]['cuotas'] = $cab['comp_cuotas'];
    $datos['data'][$key]['funcionario'] = $cab['fun_nom'];
    $datos['data'][$key]['estado'] = $cab['comp_estado'];
    $datos['data'][$key]['usuario'] = $cab['usu_cod'];
    $datos['data'][$key]['acciones'] = $button;

   // $sqldetalle = pg_query('select * from v_compras_det ');//select * from v_compras_det where comp_cod=2
$sqldetalle = pg_query('select * from  v_compras_det  where comp_cod=' . $cab['comp_cod']);
$detalles = pg_fetch_all($sqldetalle);
//$rows2 = pg_num_rows($sqldetalle);
        
        foreach ($detalles as $key2 => $detalle) {
        $datos['data'][$key]['detalle'][$key2]['comp_cod'] = $detalle['comp_cod'];
        $datos['data'][$key]['detalle'][$key2]['codigo'] = $detalle['item_cod'];
        $datos['data'][$key]['detalle'][$key2]['item'] = $detalle['item_desc'];
        $datos['data'][$key]['detalle'][$key2]['marca'] = $detalle['mar_desc'];
        // $datos['data'][$key]['detalle'][$key2]['exenta'] = $detalle['exenta'];
        // $datos['data'][$key]['detalle'][$key2]['grav5'] = $detalle['grav5'];
        // $datos['data'][$key]['detalle'][$key2]['grav10'] = $detalle['grav10'];
        $datos['data'][$key]['detalle'][$key2]['dep'] = $detalle['dep_desc'];
       $datos['data'][$key]['detalle'][$key2]['cantidad'] = $detalle['comp_cantidad'];
       $datos['data'][$key]['detalle'][$key2]['precio'] = $detalle['comp_precio'];
       $datos['data'][$key]['detalle'][$key2]['cboiddeposito'] = $detalle['dep_desc'];
      //  $datos['data'][$key]['detalle'][$key2]['ivatotal'] = $detalle['comp_ivatotal'];
        }
     
}


echo json_encode($datos);
return json_encode($datos);
?>



















