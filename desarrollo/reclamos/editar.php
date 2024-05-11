<?php

require "../clases/conexion.php";
$cod = $_POST["cod"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("select  *  from v_reclamos_sugerencias where reclamo_cod = '$cod' ");
while($var = pg_fetch_assoc($sql)){
    print_r(json_encode($var));
};
