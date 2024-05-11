<?php
require "../clases/conexion.php";

//print_r($_POST['cuenta']);
//die;
$cod = $_GET['cod']; 

//echo "$string";

$con = new conexion();
$con->conectar();
$sql = pg_query("select * from v_pedidos_compras_det where ped_nro = '$cod' ");
$pedidos = pg_fetch_all($sql); 

$data['filas'] = '';
$subtotal = 0;
foreach ($pedidos as $key => $pedido) {
	 $subtotal = $pedido['ped_precio'] * $pedido['ped_cantidad'];
	$data['total'] = number_format($subtotal,0,',','.');
	$data['filas'] .= '<tr>';
	$data['filas'] .= '<td>'.$pedido['item_cod'].'</td>';
	$data['filas'] .= '<td>'.$pedido['item_cod'].' - '.$pedido['item_desc'].'</td>';
	$data['filas'] .= '<td>'.$pedido['mar_cod'].' - '.$pedido['mar_desc'].'</td>';
	$data['filas'] .= '<td>'.$pedido['ped_cantidad'].'</td>';
	$data['filas'] .= '<td>'.$pedido['ped_precio'].'</td>';
	$data['filas'] .= '<td>'.number_format($subtotal,0,',','').'</td>';
	
	$data['filas'] .= '<td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td>';
	$data['filas'] .= '</tr>';
}
echo json_encode($data);
return json_encode($data);