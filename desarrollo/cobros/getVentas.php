<?php
    require '../clases/conexion.php';
    $cliente = $_GET['cliente'];

    $con = new conexion();
    $con->conectar();
    $sql = pg_query(" SELECT * FROM ventas_cab WHERE ven_estado = 'PENDIENTE' AND cli_cod = '$cliente' ORDER BY ven_cod DESC");

    $verificar = pg_fetch_all($sql);
    if(!empty($verificar)){

        while($var = pg_fetch_assoc($sql)){
            $datos[] = $var;
        }
        print_r(json_encode($datos));
    }else{
        $error = "error";
        echo $error;
    }

?>