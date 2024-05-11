<?php
    require '../clases/conexion.php';
    $ventanro = $_GET['ventanro'];
    $con = new conexion();
    $con->conectar();
    $sql = pg_query("SELECT  SUM(ctas_monto) AS monto_deuda, SUM(ctas_saldo) AS monto_saldo FROM cuentas_cobrar WHERE ven_cod = '$ventanro' ");

    $verificar = pg_fetch_assoc($sql);
    if(!empty($verificar)){
        $array[] =  array('monto_deuda' => $verificar['monto_deuda'], 'monto_saldo' => $verificar['monto_saldo']);
        $data = array('data' => $array);
        $json = json_encode($data);
        print_r(utf8_encode($json));
    }else{
        $error = "error";
        echo $error;
    }

?>