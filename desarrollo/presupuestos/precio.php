<?php

require "../clases/conexion.php";
    $item = $_POST["item"];
    $mar = $_POST["mar"];
    $con = new conexion();
    $con ->conectar();
    $sql = pg_query("select precio from marcas_items where item_cod = '$item' and mar_cod = '$mar' ");

    $verificar = pg_fetch_all($sql);
    if(!empty($verificar)){
    $precio = pg_fetch_assoc($sql);
    echo $precio["precio"];
    }else{
    $echo = "error";
    echo $error;
    }

?>