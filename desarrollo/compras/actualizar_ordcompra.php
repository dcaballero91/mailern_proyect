<?php
    require '../clases/conexion.php';
    $compcod = $_POST["compcod"];
    $ordencod = $_POST["ordencod"];
    $con = new conexion();
    $con->conectar();
    $sql = pg_query("UPDATE ordcompras_cab set orden_estado = 'PROCESADO' where orden_nro = $ordencod ");
    $sql2 = pg_query("INSERT INTO orden_compra VALUES ($compcod, $ordencod)");
?>