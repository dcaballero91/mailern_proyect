<?php
require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();

        
$sqlpersonas = pg_query ('select * from v_proveedor_timbrados order by 1');
$personas = pg_fetch_all($sqlpersonas);
$datos['data'] = [];

foreach($personas as $key => $personas){
       
        $datos['data'][$key]['nro'] = $personas['prov_timb_nro'];
        $datos['data'][$key]['nombre'] = $personas['prov_cod'].' - '.$personas['prov_nombre'];
        $datos['data'][$key]['ruc'] = $personas['prov_ruc'];
        $datos['data'][$key]['vighasta'] = $personas['prov_tim_vighasta'];
        $datos['data'][$key]['esta'] = $personas['prov_estado'];
        // $datos['data'][$key]['estado'] = $personas['prov_estado'];
        
        $datos['data'][$key]['acciones'] = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' data-toggle=\'modal\' data-target=\'#modal_basic\' data-placement=\'top\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>'.'

                '.'<button type=\'button\' class=\'btn btn-danger btn-circle eliminar pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Desactivar\'><i class=\'fa fa-times\'></i></button>';

              #  '. '<button type=\'button\' class=\'btn btn-success btn-circle activar pull-right\' data-toggle=\'modal\' data-target=\'#activacion\' data-placement=\'top\' title=\'Activar\'><i class=\'fa fa-check\'></i></button>';         
            
}
echo json_encode($datos);
return json_encode($datos);
?>