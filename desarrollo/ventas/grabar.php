
<?php

require '../clases/conexion.php';
$codigo = $_POST["codigo"];
// $emp = $_POST["empresa"];
$suc = $_POST["sucursal"];
$usu = $_POST["usuario"];
// $fun = $_POST["funcionario"];
$cliente = $_POST["cliente"];
$tfactura = $_POST["tipofact"];
$plazo = $_POST["plazo"];
$cuotas = $_POST["cuotas"];
$detalle = $_POST["detalle"];
$detalle2 = $_POST["detalle2"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();

$sql = pg_query("select sp_ventas2($codigo,$suc,$usu,$cliente,$tfactura,$plazo,$cuotas,'$detalle','$detalle2',$ope)");
#ORDEN: codigo, succod, usucod, clicod, ventatipofact, venplazo, vencuotas, timbcod, aperciercod, nrofactura, detalleventa[ depcod, itemcod, cantidad, venprecio], libroventas[exa, g5, g10, iva5, iva10], operacion
if(!$sql){
    echo pg_last_error()."_/_error";
}else{
    echo pg_last_notice($con->url)."_/_notice";
}



?>