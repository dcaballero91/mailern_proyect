<?php
require "../clases/conexion.php";

//print_r($_POST['cuenta']);
//die;
$cod = $_POST['cod']; 

//echo "$string";

$con = new conexion();
$con->conectar();
$sql = pg_query("select * from v_reservas_det where reser_cod = '$cod' ");
$reservas = pg_fetch_all($sql); 

$data['filas'] = '';
$subtotal = 0;
foreach ($reservas as $key => $reserva) {
	 $subtotal = $reserva['reser_precio'];
	$data['total'] = number_format($subtotal,0,',','.');
	$data['filas'] .= '<tr>';
	$data['filas'] .= '<td>'.$reserva['reser_cod'].'</td>';
	$data['filas'] .= '<td>'.$reserva['item_cod'].'</td>';
	$data['filas'] .= '<td>'.$reserva['item_desc'].'</td>';
	$data['filas'] .= '<td>'.$reserva['reser_precio'].'</td>';
	$data['filas'] .= '<td>'.$reserva['reser_hdesde'].'</td>';
	$data['filas'] .= '<td>'.$reserva['reser_hhasta'].'</td>';
	$data['filas'] .= '<td>'.$reserva['reser_desc'].'</td>';
	$data['filas'] .= '<td>'.$reserva['fun_cod'].'-'.$reserva['fun_nombre'].'</td>';
	$data['filas'] .= '<td>'.number_format($subtotal,0,',','').'</td>';
	
	// $data['filas'] .= '<td>'.$reserva['orden_precio'].'</td>';
	$data['filas'] .= '<td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td>';
	$data['filas'] .= '</tr>';
}
echo json_encode($data);
return json_encode($data);
