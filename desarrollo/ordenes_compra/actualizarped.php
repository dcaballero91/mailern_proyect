<?php
    require '../clases/conexion.php';
    $pednro = $_POST["pednro"];
    $con = new conexion();
    $con->conectar();
    $sql = pg_query("update pedidos_cab set ped_estado = 'PROCESADO' where ped_nro = '$pednro' ");
?>