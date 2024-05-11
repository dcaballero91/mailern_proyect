<?php

session_start();
if ($_SESSION) {
    require_once '../clases/conexion.php';
    $dep = $_POST['cod'];
    $con = new conexion();
    $con->conectar();

    $sql = pg_query("SELECT * from items where item_cod in(select item_cod from v_stock where dep_cod = '$dep') ");

    $verificar = pg_fetch_all($sql);

    if(empty($verificar)){
        echo "error";
    }else{    
        while($rs = pg_fetch_assoc($sql)){
            $array[] = $rs;
        }
    
        print_r(json_encode($array));

    }
} 


