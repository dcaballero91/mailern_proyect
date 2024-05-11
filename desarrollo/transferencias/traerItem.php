<?php
require '../clases/conexion.php';
$con = new conexion();
$con->conectar();
$dep = $_GET['dep'];
$sql = pg_query(" SELECT * FROM items where item_cod in(SELECT item_cod from v_stock where dep_cod = '$dep') " );

$verificar = pg_fetch_all($sql);

if(!empty($verificar)){
    while($rs = pg_fetch_assoc($sql)){
        $array[] = $rs;
    };
    print_r(json_encode($array));
    
}else{
    $error = 'error';
     echo $error;
}

?>