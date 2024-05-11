<?php
    require '../clases/conexion.php';
    $ordencod = $_POST["ordencod"];
    $con = new conexion();
    $con->conectar();
    $sql = pg_query("UPDATE ordcompras_cab set orden_estado = 'PROCESADO' where orden_cod = '$ordencod' ");
?>