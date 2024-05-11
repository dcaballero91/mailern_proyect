<?php
require "../clases/conexion.php";
$cod = $_POST["cod"];
$dep = $_POST['dep'];
$con = new conexion();
$con ->conectar();
$sql = pg_query("SELECT  item_cod, item_desc, mar_cod, mar_desc FROM v_stock WHERE item_cod = '$cod' and dep_cod = '$dep' ");

$verificar = pg_fetch_all($sql);

if(!empty($verificar)){

    while($marca = pg_fetch_assoc($sql)){
        $array [] = $marca;
    }
    print_r(json_encode($array));
}else{
    $error = "error";
    echo $error;
}

?>