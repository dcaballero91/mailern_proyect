<?php
require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();

        
$sqlpersonas = pg_query ('select * from v_usuarios order by 1');
$personas = pg_fetch_all($sqlpersonas);
$datos['data'] = [];

foreach($personas as $key => $personas){
        $datos['data'][$key]['codigo'] = $personas['usu_cod'];
        $datos['data'][$key]['nom'] = $personas['usu_name'];
        $datos['data'][$key]['funnom'] = $personas['fun_nom'];
        $datos['data'][$key]['car'] = $personas['car_desc'];
        $datos['data'][$key]['grupo'] = $personas['gru_desc'];
        $datos['data'][$key]['estado'] = $personas['usu_estado'];
      
      //  $datos['data'][$key]['estado'] = "<label title = '".$personas['cli_auditoria']."'>".$personas['cli_estado']."</label>";
        
       
        
        $datos['data'][$key]['acciones'] = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' data-toggle=\'modal\' data-target=\'#modal_basic\' data-placement=\'top\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>'.'

        '.'<button type=\'button\' class=\'btn btn-danger btn-circle eliminar pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Desactivar\'><i class=\'fa fa-times\'></i></button>'.'

        '.'<button type=\'button\' class=\'btn btn-success btn-circle activar pull-right\' data-toggle=\'modal\' data-target=\'#activacion\' data-placement=\'top\' title=\'Activar\'><i class=\'fa fa-check\'></i></button>'.'

        '.'<button type=\'button\' class=\'btn btn-dark btn-circle reiniciar pull-right\' data-toggle=\'modal\' data-target=\'#reiniciar\' data-placement=\'top\' title=\'Reiniciar Contraseña \'><i class=\'fa fa-rotate-right\'></i></button>';         
            
}
echo json_encode($datos);
return json_encode($datos);
?>