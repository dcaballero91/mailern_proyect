<?php
    require '../clases/conexion.php';
    $prov = $_POST["prov"];
    
    $con = new conexion();
    $con->conectar();
    $sql = pg_query("select * from proveedor_timbrados where prov_cod = '$prov' ");
    while($rs= pg_fetch_assoc($sql)){
        $array[] = $rs;
    }
    print_r(json_encode($array));
?>