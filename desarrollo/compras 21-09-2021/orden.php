<?php
require "../clases/conexion.php";

//print_r($_POST['cuenta']);
//die;
$orden = $_POST['orden']; 
$con = new conexion();
$con->conectar();
$sql = pg_query("select * from v_ordenes_compras_det where (select orden_estado from ordcompras_cab where orden_nro = '$orden') = 'PENDIENTE' and orden_nro = '$orden' ");
$pedidos = pg_fetch_all($sql); 


// $sql3 = pg_query("select * from sucursales  order by suc_cod");
// $sucursal = pg_fetch_all($sql3);
// $select_sucursal = '';
// foreach ($sucursal as $key => $s) {
// 	$select_sucursal = $select_sucursal."<option value=\"$s[suc_cod]\">".$s["suc_cod"].'-'. $s["suc_nom"]."</option>";
// }


$sql2 = pg_query("select * from v_depositos where dep_estado = 'ACTIVO' order by dep_cod");
$deposito = pg_fetch_all($sql2); 

$select_deposito = '';
foreach ($deposito as $key => $d) {
	$select_deposito = $select_deposito."<option value=\"$d[dep_cod]\">".$d["suc_nom"].' - '. $d["dep_desc"]."</option>";
}

$data['filas'] = '';
$subtotal = 0;
$subtotal1 = 0;
foreach ($pedidos as $key => $pedido) {
	$subtotal = $pedido['orden_precio']*$pedido['orden_cantidad'];
	$subtotal1 += $pedido['orden_precio']*$pedido['orden_cantidad'];
	$total= $subtotal1;
	
	$data['total'] = number_format($total,0,',','.');
	$data['filas'] .= '<tr>';
	$data['filas'] .= '<td>'.$pedido['item_cod'].'</td>';
	$data['filas'] .= '<td>'.$pedido['item_desc'].'</td>';
	$data['filas'] .= '<td>'.$pedido['mar_cod'].' - '.$pedido['mar_desc'].'</td>';
	$data['filas'] .= '<td>'.number_format($pedido['orden_cantidad'],0,',','').'</td>';
	
	$data['filas'] .= '<td>'.$pedido['orden_precio'].'</td>';
	$data['filas'] .= '<td>'.number_format($subtotal,0,',','').'</td>';
	// $data['filas'] .= '<td width="15%"><select class="grilla form-control" id="sucid'.$pedido["item_cod"].'">'.$select_sucursal.'</select></td>';
	$data['filas'] .= '<td width="20%"><select class="form-control" id="ordenid'.$pedido["item_cod"].'">'.$select_deposito.'</select></td>';
	// $data['filas'] .= '<td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td>';
	$data['filas'] .= '</tr>';
}
echo json_encode($data);
return json_encode($data);
