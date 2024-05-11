<?php
require '../clases/conexion.php';
$con = new conexion();
$con->conectar();
$fecha = $_POST["fecha"];
$hdesde = $_POST["hdesde"];
$hhasta = $_POST["hhasta"];
$dia = $_POST["dia"];
$sql = pg_query("SELECT * FROM listar_funcionarios_disponibles($dia,'$fecha','$hdesde','$hhasta')");
#--ORDEN: dia, fecha, hdesde, hhasta

if(!$sql){
    echo pg_last_error()."_/_error";
}else{
    while ($rs = pg_fetch_assoc($sql)){
        $array[] = $rs; 
    };
    print_r(json_encode($array));
    echo pg_last_notice($con->url)."_/_notice";
}

?>