<?php

session_start();
if ($_SESSION) {
    require_once '../clases/conexion2.php';

    $sqlfun = "SELECT * from v_especialidades where prof_cod = ".$_POST['esp_cod']."  order by esp_desc;";
    //SELECT * from v_especialidades where prof_cod = 1 order by esp_desc;
    $result = consultas::get_datos($sqlfun);
    foreach ($result as $res) {
       echo '<option value="'.$res['esp_cod'].'">'.$res['esp_desc'].'</option>';
    }
} else {
    header('location:../../index.php');
}
