<?php
    require '../clases/conexion.php';
    $con = new conexion();
    $con->conectar();

    $sql = pg_query(" SELECT COALESCE(MAX(orden_nro),0)+1 as ultcod from ordcompras_cab ");
    $rs = pg_fetch_assoc($sql);

    echo $rs['ultcod'];
?>