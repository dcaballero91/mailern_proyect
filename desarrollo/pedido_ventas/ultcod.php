<?php
 require '../clases/conexion.php';
 $con = new conexion();
 $con->conectar();
 $sql = pg_query("select coalesce(max(ped_vcod),0)+1 as nro from pedidos_vcab");
 $rs = pg_fetch_assoc($sql);
 echo $rs["nro"];
?>