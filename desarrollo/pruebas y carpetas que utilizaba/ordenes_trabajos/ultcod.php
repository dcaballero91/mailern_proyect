<?php
    require '../clases/conexion.php';
    $con = new conexion();
    $con->conectar();
    $sql = pg_query("select coalesce(max(reser_cod),0)+1 as ultcod from reservas_cab");
    $rs = pg_fetch_assoc($sql);

    echo $rs["ultcod"];
?>