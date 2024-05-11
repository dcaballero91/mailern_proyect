<?php
    require '../clases/conexion.php';
    $ventanro = $_GET['ventanro'];
    $cuotas = $_GET['cuotas'];

    $con = new conexion();
    $con->conectar();
    $sql = pg_query(" SELECT (ctas_monto * '$cuotas' ) as monto FROM cuentas_cobrar WHERE ven_cod = '$ventanro' limit 1 ");
    
    $verificar = pg_fetch_assoc($sql);
    if(!empty($verificar)){
        echo $verificar['monto'];
    }else{
        $error = "error";
        echo $error;
    }

?>