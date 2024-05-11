<?php
    require '../clases/conexion.php';
    $con = new conexion();
    $con->conectar();

    $sql = pg_query("SELECT coalesce(max(ajus_cod), 0) + 1 as ultcod FROM ajustes_cab");
    $rs = pg_fetch_assoc($sql);

    echo $rs["ultcod"];

?>