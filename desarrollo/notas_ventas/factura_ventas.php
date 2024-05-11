<?php
    require '../clases/conexion.php';
    $cli = $_POST["cli"];
    $con = new conexion();
    $con->conectar();

    $array[] = ['no hay'];

    $sql = pg_query("SELECT ven_cod, venta_nro_fact AS nro_factura FROM libro_ventas WHERE ven_cod IN (SELECT ven_cod FROM ventas_cab WHERE cli_cod = $cli AND ven_estado != 'ANULADO' ) AND venta_nro_fact IS NOT NULL");
    while($rs= pg_fetch_assoc($sql)){
        $array[] = $rs;
    }

    if($sql){
        print_r(json_encode($array));
    }else{
        echo 'holaa';
    }
?>