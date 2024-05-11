<?php

require "../clases/conexion.php";
$cod = $_POST['cod'];
$con = new conexion();
$con->conectar();

$sql = pg_query(" SELECT item_cod, item_desc, mar_cod, mar_desc FROM v_marcas_items WHERE item_cod = '$cod' ");

$verificar = pg_fetch_all($sql);

if(!empty($verificar)){
    while($var = pg_fetch_assoc($sql)){
        $array[] = $var;
    }
    print_r(json_encode($array));

}else{
    $error = "error";
    echo $error;
}

?>