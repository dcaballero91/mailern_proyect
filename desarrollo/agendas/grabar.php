
<?php
    require '../clases/conexion.php';
    $codigo     = $_POST["codigo"];
    $fun        = $_POST["fun"];
    $detalles   = $_POST["detalle"];
    $usu        = $_POST["usu"];
    $suc        = $_POST["suc"];
    $ope        = $_POST["ope"];

    $con = new conexion();
    $con->conectar();

    $sql = pg_query("SELECT sp_agendas_full($codigo, $fun, '$detalles', $suc, $usu,  $ope)");
    # ORDEN: codigo, funcod, detalles[dias, hdesde, hhasta], succod, usucod, operacion
    if($sql){
        echo  pg_last_notice($con->url)."_/_notice";
    }else{
        echo pg_last_error()."_/_error";
    }
?>