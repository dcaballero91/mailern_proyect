<?php
require '../clases/conexion.php';
$con = new conexion();
$con->conectar();

$sql = pg_query(" select coalesce(max(pre_prov_cod),0)+1 as nro from presupuestos_proveedores_cab");
$nro = pg_fetch_assoc($sql);
echo $nro["nro"];
?>