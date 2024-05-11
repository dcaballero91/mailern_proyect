<?php
    require '../clases/conexion.php';
    $con = new conexion();
    $con->conectar();
    $cod = $_POST['cod'];

    $sql = pg_query("SELECT * FROM v_reservas_cab WHERE reser_cod = '$cod' ");
    while($rs = pg_fetch_assoc($sql)){
        print_r(json_encode($rs));
    };
?>