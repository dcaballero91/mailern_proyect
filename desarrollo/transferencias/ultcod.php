<?php
require '../clases/conexion.php';
$con = new conexion();
$con->conectar();
$sql = pg_query(" select coalesce(max(trans_cod),0)+1 as ultcod from transferencias_cab ");
$nro = pg_fetch_assoc($sql);
echo $nro["ultcod"];
?>