<?php
    require '../clases/conexion.php';
    $ventanro = $_GET['cod'];

    $con = new conexion();
    $con->conectar();
    $sql = pg_query(" SELECT * FROM ventas_cab WHERE ven_cod= $ventanro ");
    while ($venta = pg_fetch_assoc($sql)){
        if ($venta['ven_estado'] == 'PAGADO'){
            $array[] = array('error'=> 'ESTA VENTA YA HA SIDO COBRADO EN SU TOTALIDAD');
        }else{
            $array[] = array('cliente' => $venta["cli_cod"],'ventanro' => $venta["ven_cod"]);
        }
    }
    $data = array('data' => $array);
    $json = json_encode($data);
    print_r(utf8_encode($json));
?>