

<?php
require "../clases/conexion.php";

$orden = $_POST['orden']; 
$con = new conexion();
$con->conectar();
$sql = pg_query("select * from v_ordenes_compras_cab where orden_estado = 'PENDIENTE' and orden_nro= '$orden' ");

$verificar = pg_fetch_all($sql);
if(!empty($verificar)){

	while($orden = pg_fetch_assoc($sql)){
		// $array[] = $orden;
		print_r(json_encode($orden));
	}; 
}else{

	$error = 'error';
	echo $error;
}

?>
