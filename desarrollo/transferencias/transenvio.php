<?php
require "../clases/conexion.php";


$con = new conexion();
$con->conectar();
//print_r($_POST['cuenta']);
//die;
$transenvio =  $_POST['trans']; 

$sqldetalle = pg_query("select * from v_transferencias_det where (select trans_estado from transferencias_cab where trans_cod = '$transenvio') = 'PENDIENTE' and trans_cod = $transenvio ");
#(select trans_estado from transferencias_cab where trans_cod = '$transenvio') = 'PENDIENTE' and
$transferencias = pg_fetch_all($sqldetalle); 

//echo "$string";

if(!empty($transferencias)){
	$data['filas'] = '';
	foreach ($transferencias as $key => $transenvio) {
	
		$data['filas'] .= '<tr>';
		$data['filas'] .= '<td>'.$transenvio['item_cod'].'</td>';
		$data['filas'] .= '<td>'.$transenvio['item_desc'].'</td>';
		$data['filas'] .= '<td>'.$transenvio['mar_cod'].' - '.$transenvio['mar_desc'].'</td>';
		$data['filas'] .= '<td>'.number_format($transenvio['trans_cantidad'],0,',','').'</td>';
	
		$data['filas'] .= '<td width="10%"><input type="text" value="0" class="form-control"/></td>';// es solo para prueba
		$data['filas'] .= '</tr>';
	}
	echo json_encode($data);
	return json_encode($data);
	
}else{
	$error = "error";
	echo $error;
}