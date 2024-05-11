<?php

require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("SELECT * FROM v_presupuestos_proveedores_cab WHERE pre_prov_cod IN (SELECT pre_prov_cod FROM v_presupuestos_proveedores_det) AND pre_prov_estado != 'ANULADO' ORDER BY pre_prov_cod");

$presupuesto = pg_fetch_all($sql);
$button_borrar = '<button type=\'button\' class=\'btn btn-primary  delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Borrar\'><i class=\'fa fa-minus\'></i></button>';

$button_editar = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>';

$button = $button_borrar ." ".$button_editar;

if(!empty($presupuesto)){

    $datos['data'] = [];
    foreach ($presupuesto as $key => $presupuestos) {
        $preprovcod  =  $presupuestos['pre_prov_cod'];
        $proveedores =  $presupuestos['prov_cod'];
        $fecha       =  $presupuestos['pre_prov_fecha'];

        $datos['data'][$key]['cod'] = $presupuestos['pre_prov_cod'];
        $datos['data'][$key]['pro_nom'] = $presupuestos['prov_cod'].'-'.$presupuestos['prov_nombre'];
        $datos['data'][$key]['fecha'] = $presupuestos['pre_prov_fecha'];
        $datos['data'][$key]['fechav'] = $presupuestos['pre_prov_validez'];
        // $datos['data'][$key]['ruc'] = $presupuestos['emp_nom'];
        $datos['data'][$key]['suc'] = $presupuestos['suc_nom'];
        $datos['data'][$key]['usu'] = $presupuestos['usu_name'];
        $datos['data'][$key]['estado'] = $presupuestos['pre_prov_estado'];
        $datos['data'][$key]['acciones'] = $button;
    
        $sqldetalle = pg_query(" SELECT * FROM v_presupuestos_proveedores_det WHERE pre_prov_cod =
        '$preprovcod' AND prov_cod= '$proveedores' AND pre_prov_fecha = '$fecha' ");

        $detalles = pg_fetch_all($sqldetalle);
    
        foreach ($detalles as $key2 => $det) {
    
            $datos['data'][$key]['detalle'][$key2]['cod'] = $det['pre_prov_cod'];
            $datos['data'][$key]['detalle'][$key2]['codigo'] = $det['item_cod'];
            $datos['data'][$key]['detalle'][$key2]['descripcion'] = $det['item_desc'];
            $datos['data'][$key]['detalle'][$key2]['marcas'] = $det['mar_desc'];
    
            $datos['data'][$key]['detalle'][$key2]['cantidad'] = $det['pre_prov_cantidad'];
            $datos['data'][$key]['detalle'][$key2]['precio'] = $det['pre_prov_precio'];
        }
    }
    
    echo json_encode($datos);
    return json_encode($datos);

}else{
    $datos['data']['cod'] = '-';
         $datos['data']['cod'] = '-';
         $datos['data']['pro_nom'] = '-';
         $datos['data']['nro'] = '-';
         $datos['data']['fecha'] = '-';
         $datos['data']['fechav'] = '-';
         $datos['data']['suc'] = '-';
         $datos['data']['usu'] = '-';
         $datos['data']['estado'] = '-';
         $datos['data']['acciones'] =  '-';

         echo  json_encode($datos);
         return json_encode($datos);

}

?>