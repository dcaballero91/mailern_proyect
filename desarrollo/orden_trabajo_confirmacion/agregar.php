<?php
    require '../clases/conexion.php';

    $con = new conexion();
    $con->conectar();

    $funcod = $_POST["funcod"];
    $fecha = $_POST['fecha'];
    $hdesde = $_POST['hdesde'];
    $hhasta = $_POST['hhasta'];

    $sql = pg_query("SELECT  listar_fun_ord_trab($funcod, '$fecha','$hdesde', '$hhasta' )");

    if($sql){
        echo pg_last_notice($sql->url)."_/_notice";
    }else{
        echo pg_last_error()."_/_error";
    }
?>
