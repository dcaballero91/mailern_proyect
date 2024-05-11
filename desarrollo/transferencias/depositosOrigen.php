<?php
    require '../clases/conexion.php';
    $con = new conexion();
    $con->conectar();
    $suc = $_GET["suc"];

    $sql = pg_query(" SELECT * FROM v_depositos WHERE suc_cod = '$suc' order by dep_cod ");

    $verficar = pg_fetch_all($sql);

    if(empty($verificar)){
        while($rs = pg_fetch_assoc($sql)){
            $array [] = $rs;
        }
        print_r(json_encode($array));
    }else{
        $error = 'error';
        echo $error;
    }
?>