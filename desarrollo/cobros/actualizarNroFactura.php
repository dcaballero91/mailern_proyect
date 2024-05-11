<?php
    require '../clases/conexion.php';
    $usu = $_GET["usu"];
    $con = new  conexion();
    $con->conectar();

    $sql = pg_query("SELECT * FROM v_aperturas_cierres WHERE usu_cod = " . $usu . " AND fecha_cierreformato IS NULL");
    $rs = pg_fetch_assoc($sql);
    echo $rs['siguiente_factura'];
?>