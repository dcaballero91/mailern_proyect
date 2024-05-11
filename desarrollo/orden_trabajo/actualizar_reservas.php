<?php
    require '../clases/conexion.php';
    $resercod = $_POST["resercod"];
    $con = new conexion();
    $con->conectar();
    $sql = pg_query("UPDATE reservas_cab set reser_estado = 'PROCESADO' where reser_cod = $resercod ");
?>