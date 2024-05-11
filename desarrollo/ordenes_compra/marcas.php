<?php

require "../clases/conexion.php";
$cod = $_POST["cod"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("select mar_desc, mar_cod from v_marcas_items where item_cod =  '$cod' ");

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