<?php

require "../clases/conexion.php";
    $cod = $_POST["cod"];
    $con = new conexion();
    $con->conectar();
    $sql = pg_query("select item_precio from items where item_cod = '$cod' ");

    $verificar = pg_fetch_all($sql);
    if(!empty($verificar)){
    $precio = pg_fetch_assoc($sql);
    echo $precio["item_precio"];
    }else{
    $echo = "error";
    echo $error;
    }

?>