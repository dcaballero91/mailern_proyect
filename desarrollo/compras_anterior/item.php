<?php

session_start();
if ($_SESSION) {
    require_once '../clases/conexion2.php';

    $sqlfun = "SELECT * from v_stock where dep_cod = ".$_POST['dep_cod']." order by item_desc;";
    
    $result = consultas::get_datos($sqlfun);
    foreach ($result as $res) {
       echo '<option value="'.$res['item_cod'].'~'.$res['item_costo'].'~'.$res['item_tipo_impuesto'].'~'.$res['stock_cantidad'].'~'.$res['cla_desc'].'">'.$res['item_desc'].'</option>';
    }
} else {
    header('location:../../index.php');
}


