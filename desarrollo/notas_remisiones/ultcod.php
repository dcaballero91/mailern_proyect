<?php
require '../clases/conexion.php';
$con = new conexion();
$con->conectar();
$sql = pg_query(" select coalesce(max(nota_rem_cod),0)+1 as ultcod from notas_remisiones_cab ");
$nro = pg_fetch_assoc($sql);
echo $nro["ultcod"];
?>