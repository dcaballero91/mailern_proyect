<?php
require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();

        
$sqlpersonas = pg_query ('select * from v_funcionarios order by 1');
$personas = pg_fetch_all($sqlpersonas);
$datos['data'] = [];

foreach($personas as $key => $personas){
        $datos['data'][$key]['codigo'] = $personas['fun_cod'];
        $datos['data'][$key]['nom'] = $personas['fun_nom'];
        $datos['data'][$key]['ci'] = $personas['per_ci'];
        $datos['data'][$key]['tel'] = $personas['per_tel'];
        $datos['data'][$key]['cargo'] = $personas['car_desc'];
        $datos['data'][$key]['falta'] = $personas['fun_fecha_alta'];
        $datos['data'][$key]['fbaja'] = $personas['fun_fecha_baja'];
        $datos['data'][$key]['estado'] = $personas['fun_estado'];

       
      //  $datos['data'][$key]['estado'] = "<label title = '".$personas['cli_auditoria']."'>".$personas['cli_estado']."</label>";
        
       
        
        $datos['data'][$key]['acciones'] = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' data-toggle=\'modal\' data-target=\'#modal_basic\' data-placement=\'top\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>'.'

                '.'<button type=\'button\' class=\'btn btn-danger btn-circle eliminar pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Desactivar\'><i class=\'fa fa-times\'></i></button>'.'
                
                '.'<button type=\'button\' class=\'btn btn-success btn-circle activar pull-right\' data-toggle=\'modal\' data-target=\'#activacion\' data-placement=\'top\' title=\'Activar\'><i class=\'fa fa-check\'></i></button>';         
            
}
echo json_encode($datos);
return json_encode($datos);
?>