<?php
    require '../clases/conexion.php';

    $con = new conexion();
    $con->conectar();

    $sql  = pg_query("SELECT COALESCE(MAX(ord_trab_cod),0)+1 AS ultcod FROM ordenes_trabajos_cab");
    $rs = pg_fetch_assoc($sql);
    echo $rs['ultcod'];
?>