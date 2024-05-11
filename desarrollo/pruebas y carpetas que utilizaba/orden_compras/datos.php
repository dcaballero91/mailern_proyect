<?php
require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("select * from v_ordcompras_cab order by 1");
$ordencompras = pg_fetch_all($sql);
$button_borrar = '<button type=\'button\' class=\'btn btn-primary btn-circle   delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Anular\'><i class=\'fa fa-times\'></i></button>';
$button = $button_borrar;
$datos['data']=[];
foreach($ordencompras as $key => $ordencompras){
        $datos['data'][$key]['cod'] = $ordencompras['orden_cod'];
        $datos['data'][$key]['nro'] = $ordencompras['nro'];
        $datos['data'][$key]['fecha'] = $ordencompras['fecha'];
        $datos['data'][$key]['proveedor'] = $ordencompras['prov_nom']." ".$ordencompras['prov_ape'];
        $datos['data'][$key]['ruc'] = $ordencompras['prov_ruc'];
      //  $datos['data'][$key]['ruc'] = $ordencompras['emp_ruc'];
        $datos['data'][$key]['pro_dir'] = $ordencompras['prov_dir'];
        $datos['data'][$key]['pro_email'] = $ordencompras['prov_email'];
        $datos['data'][$key]['fun_cod'] = $ordencompras['fun_cod'];
        //$datos['data'][$key]['usu_cod'] = $ordencompras['usu_cod'];
        $datos['data'][$key]['tipo_factura'] = $ordencompras['tipo_fact_desc'];
        $datos['data'][$key]['plazo'] = $ordencompras['orden_plazo'];
        $datos['data'][$key]['cuotas'] = $ordencompras['orden_cuotas'];
        $datos['data'][$key]['estado'] = $ordencompras['orden_estado'];
        $datos['data'][$key]['acciones'] =  $button;

//      Solo para prueba del detalle
//        $sqldetalle = pg_query('select * from v_ordcompras_det where orden_cod=1');
//        if(!empty($sqldetalle)){
//                    $detalles = pg_fetch_all($sqldetalle);
//            foreach ($detalles as $key2 => $detalle) {
//        $datos['data'][$key]['detalle'][$key2]['cod'] = $detalle['orden_cod'];
//        $datos['data'][$key]['detalle'][$key2]['codigo'] = $detalle['item_cod'];
//        $datos['data'][$key]['detalle'][$key2]['descripcion'] = $detalle['item_desc'];
//        //$datos['data'][$key]['detalle'] = $ordencompras['mar_cod'];
//        $datos['data'][$key]['detalle'][$key2]['cantidad'] = $detalle['orden_cantidad'];
//        $datos['data'][$key]['detalle'][$key2]['precio'] = $detalle['orden_precio'];
//    }
//        }

        
                    
}

 echo  json_encode($datos);
 return json_encode($datos);

?>