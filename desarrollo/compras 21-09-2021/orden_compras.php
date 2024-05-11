<?php
    require '../clases/conexion.php';
    
    $con = new conexion();
    $con->conectar();
    $ordencod = $_POST["ordencod"];
    $compcod = $_POST["compcod"];
    // $sql= pg_query("INSERT INTO orden_compra VALUES('$compcod', '$ordencod');");
    $sql= pg_query("SELECT * FROM sp_ordencompra_intermedio($compcod,$ordencod)");
    pg_last_notice($con->url);
?>