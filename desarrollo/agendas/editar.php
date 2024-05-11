<?php
require "../clases/conexion.php";

$cod = $_GET['cod']; 
$con = new conexion();
$con->conectar();
$sql = pg_query("SELECT  * FROM v_agendas_det WHERE agen_cod = '$cod' ");
$agendas = pg_fetch_all($sql); 

$sqlcab = pg_query("SELECT fun_cod FROM v_agendas_cab WHERE agen_cod = '$cod' ");
$fun = pg_fetch_assoc($sqlcab);
$fun = $fun['fun_cod'];

$data['filas'] = '';
foreach ($agendas as $key => $agenda) {
	$data['filas'] .= '<tr>';
	$data['filas'] .= '<td>'.$agenda['agen_cod'].'</td>';
	$data['filas'] .= '<td>'.$agenda['dias_cod'].' - '.$agenda['dias_desc'].'</td>';
	$data['filas'] .= '<td>'.$agenda['hora_desde'].'</td>';
	$data['filas'] .= '<td>'.$agenda['hora_hasta'].'</td>';	
	$data['filas'] .= '<td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td>';
	$data['filas'] .= '</tr>';
}
echo json_encode($data);
return json_encode($data);