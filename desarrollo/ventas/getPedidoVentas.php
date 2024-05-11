<?php
    require '../clases/conexion.php';
    $cod = $_GET['cod'];
    $con = new conexion();
    $con->conectar();
    $sql = pg_query("SELECT * FROM pedidos_vcab WHERE cli_cod = '$cod' AND ped_estado = 'PENDIENTE' AND ped_fecha::date = CURRENT_DATE  ORDER BY pedidos_vcab ");

    $verificar = pg_fetch_all($sql);

    if(empty($verificar)){// VERIFICAMOS SI LA RESPUESTA ESTA VACIA O NO
        echo  "error";
    }else{
        while($rs = pg_fetch_assoc($sql)){
            $array[] = $rs;
        }
        print_r(json_encode($array));
    }

    

?>