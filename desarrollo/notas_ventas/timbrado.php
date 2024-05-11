<?php
    require '../clases/conexion.php';
    
    $con = new conexion();
    $con->conectar();
    $prov = $_POST["prov"];
    $factura = $_POST["factura"];
    // $sql= pg_query("INSERT INTO orden_compra VALUES('$compcod', '$ordencod');");
    $sql= pg_query("SELECT prov_timb_nro FROM compras_cab WHERE prov_cod = '$prov' AND nro_factura = '$factura' ");

    $rs = pg_fetch_assoc($sql);
    echo $rs['prov_timb_nro'];
?>