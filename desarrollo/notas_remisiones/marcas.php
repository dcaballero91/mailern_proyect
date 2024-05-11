<?php

require "../clases/conexion.php";
$cod = $_POST["cod"];
$dep = $_POST["dep"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("select mar_desc, mar_cod from v_stock where item_cod =  '$cod' and dep_cod = '$dep' ");

$verificar = pg_fetch_all($sql);

if(!empty($verificar)){

    while($var = pg_fetch_assoc($sql)){
        $datos[] = $var;
    }
    print_r(json_encode($datos));
}else{
    $error = "error";
    echo $error;
}
?>