<?php

//session_start();
require_once '../../clases/conexion.php';
$filtro = $_POST['fil'];
$sql = "select * from v_agendas_cab where agen_cod||prof_desc ilike '%$filtro%' order by 1 desc";
$result = consultas::get_datos($sql);

foreach ($result as $r) {
    echo "<tr onclick=\"seleccion($(this));\">";
        echo "<td class=\"text-center\">";
        echo "<a style=\"color:blue;\" target=\"blank\" href=\"imprimir_factura.php?valor=$r[agen_cod]\">";
        echo $r['agen_cod'];
        echo "</a>";
        echo "</td>";
        echo "<td>";
        echo $r['fun_nom'];
        echo "</td>";
        echo "<td>";
        echo $r['prof_desc'];
        echo "</td>";
     
       
        echo "<td class=\"hidden\">";
        //echo date_format(date_create($r['ven_fecha']), 'd/m/Y');
        echo "</td>";
    echo "</tr>";
}
//echo $sql;
?>
