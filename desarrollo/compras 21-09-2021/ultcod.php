<?php
 require '../clases/conexion.php';
 $con = new conexion();
 $con->conectar();

 $sql = pg_query("select coalesce(max(comp_cod),0)+1 as ultcod from compras_cab");
 $rs = pg_fetch_assoc($sql);
 echo $rs["ultcod"];
?>