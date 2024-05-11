<?php
require '../clases/conexion.php';
//codigo del producto
$cod = $_POST['cod'];
$cn = new conexion();
$cn->conectar();
//hacemos la consulta del campo art_precioventa y le asignamos un alias "precio"
//que recibe como parametro el código del producto que se guardara en la variable $cod.
$sql=pg_query("select item_precio as precio from item where id_item=".$cod);
while($fila=pg_fetch_array($sql)){
    //por ultimo solo imprimimos el valor devuelto por nuestra consulta "precio"
         echo $fila["precio"];
     }