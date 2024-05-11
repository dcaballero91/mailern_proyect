<?php

session_start();
if ($_SESSION) {
    require_once '../clases/conexion2.php';

    $sqlfun = "select cla_desc from v_items where item_cod = ".$_POST['dep_cod']." ";
    
    $result = consultas::get_datos($sqlfun);
    foreach ($result as $res) {
       echo '<option value="'.$res["cla_desc"].'</option>';
    }
} else {
    header('location:../../index.php');
}
