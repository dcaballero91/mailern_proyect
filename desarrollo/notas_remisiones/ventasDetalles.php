<?php
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$ven = 1; //$_POST['ven']; 
$sqldetalle = pg_query("SELECT * FROM v_ventas_detalles WHERE ven_cod = $ven ");
$ventas = pg_fetch_all($sqldetalle); 

if(!empty($ventas)){
	$data['filas'] = '';
	foreach ($ventas as $key => $venta) {
		$data['filas'] .= '<tr>';
		$data['filas'] .= '<td>'.$venta['item_cod'].'</td>';
		$data['filas'] .= '<td>'.$venta['item_desc'].'</td>';
		$data['filas'] .= '<td>'.$venta['mar_cod'].' - '.$venta['mar_desc'].'</td>';
		$data['filas'] .= '<td>'.number_format($venta['ven_cantidad'],0,',','').'</td>';
		$data['filas'] .= '<td>'.number_format($venta['ven_precio'],0,',','').'</td>';
		$data['filas'] .= '</tr>';
	}
	echo json_encode($data);
	return json_encode($data);
}else{
	$error = "error";
	echo $error;
}