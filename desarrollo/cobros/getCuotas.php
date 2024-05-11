<?php
    require '../clases/conexion.php';
    $ventanro = $_GET['ventanro'];

    $con = new conexion();
    $con->conectar();
    $sql = pg_query(" SELECT COUNT(ctas_cobrar_nro) AS cuotas_pagadas FROM  cuentas_cobrar WHERE ctas_estado = 'PAGADO' AND ven_cod = '$ventanro'  ");
    $rs1 = pg_fetch_assoc($sql);

    $sql2 = pg_query(" SELECT COUNT(ctas_cobrar_nro) AS cuotas_total FROM cuentas_cobrar WHERE ven_cod = '$ventanro' ");
    $rs2 = pg_fetch_assoc($sql2);

    $array[] = array('cuotas_pagadas' => $rs1["cuotas_pagadas"],'cuotas_total' => $rs2["cuotas_total"]);

    $data = array('data' => $array);
    $json = json_encode($data);
    print_r(utf8_encode($json));

     // $verificar = pg_fetch_all($sql);
    // if(!empty($verificar)){
    //     echo $verificar['cuotas_pagadas'];
    // }else{
    //     $error = "error";
    //     echo $error;
    // }

?>