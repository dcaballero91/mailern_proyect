<?php
    require '../clases/conexion.php';
    $con = new conexion();
    $con->conectar();

    $sql = pg_query("select coalesce(max(agen_cod),0)+1 as ultcod from agendas_cab");
    $rs = pg_fetch_assoc($sql);
    echo $rs["ultcod"];
?>