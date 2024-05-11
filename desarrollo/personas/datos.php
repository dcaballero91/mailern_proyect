<?php
require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();

        
$sqlpersonas = pg_query ('select * from v_personas order by 1');
$personas = pg_fetch_all($sqlpersonas);
$datos['data'] = [];

foreach($personas as $key => $personas){
        $datos['data'][$key]['codigo'] = $personas['per_cod'];
        $datos['data'][$key]['nom'] = $personas['per_nom'];
        $datos['data'][$key]['ape'] = $personas['per_ape'];
        $datos['data'][$key]['ci'] = $personas['per_ci'];
        $datos['data'][$key]['dir'] = $personas['per_dir'];
        $datos['data'][$key]['tel'] = $personas['per_tel'];
        $datos['data'][$key]['nac'] = $personas['pais_desc'];
        $datos['data'][$key]['tipo'] = $personas['tipo_pers_desc'];
       
      //  $datos['data'][$key]['estado'] = "<label title = '".$personas['cli_auditoria']."'>".$personas['cli_estado']."</label>";
        
       
        
        $datos['data'][$key]['acciones'] = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' data-toggle=\'modal\' data-target=\'#modal_basic\' data-placement=\'top\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>'.'

                '.'<button type=\'button\' class=\'btn btn-danger btn-circle eliminar pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Eliminar\'><i class=\'fa fa-times\'></i></button>';         
            
}
echo json_encode($datos);
return json_encode($datos);
?>