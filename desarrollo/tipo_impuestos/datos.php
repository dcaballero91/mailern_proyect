<?php
require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$button_editar = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' data-toggle=\'modal\' data-target=\'#modal_basic\' data-placement=\'top\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>';
$button_borrar = '<button type=\'button\' class=\'btn btn-danger btn-circle confirmar pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Borrar\'><i class=\'fa fa-times\'></i></button>';

$sql = ('select * from tipo_impuestos order by 1');
$query = pg_query($sql);
while ($value = pg_fetch_assoc($query)){
    $button = $button_editar."  ".$button_borrar;
    $array[] = array('cod' => $value["tipo_imp_cod"],'desc' => $value["tipo_imp_desc"], 'acciones' => $button);
}
$data = array('data' => $array);
$json = json_encode($data);
print_r(utf8_encode($json));
?>
