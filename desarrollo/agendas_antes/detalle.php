<?php

//session_start();
require_once '../../clases/conexion.php';
$filtro = $_POST['fil'];
$sql = "select * from v_detalle_ventas where id_venta = $filtro order by 3 desc;";
$result = consultas::get_datos($sql);
echo $result[0]['id_deposito']."|";
foreach ($result as $r) {
    
    echo "<tr>";
        echo "<td class=\"text-center\">";
        echo $r['agen-cod'];
        echo "</td>";
        echo "<td>";
        echo $r['esp_cod'];
        echo "</td>";
        echo "<td class=\"text-center\">";
        echo $r['agen_hdesde'],0,",",".";
        echo "</td>";
        echo "<td class=\"text-right\">";
        echo $r['agen_hhasta'],0,",",".";
        echo "</td>";
        echo "<td class=\"text-right\">";
        echo $r['agen_cupos'],0,",",".";
        echo "</td>";
        echo "<td class=\"text-right\">";
        echo $r['dias_cod'],0,",",".";
        echo "</td>";
       
        echo "<td class=\"text-right\" onclick=\"eliminarfila($(this).parent())\"><button type=\"button\" class=\"btn btn-danger btn-xs\"><span class=\"glyphicon glyphicon-remove\"></span></button></td>";
    echo "</tr>";
}
//echo $sql;
?>
<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <meta charset="UTF-8">
        <title></title>
    </head>
    <body>
        <?php
        // put your code here
        ?>
    </body>
</html>
