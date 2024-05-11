
<?php

require '../clases/conexion.php';
$codigo = $_POST["codigo"];
$nro = $_POST["nro"];
$emp = $_POST["empresa"];
$suc = $_POST["sucursal"];
$usu = $_POST["usuario"];
$fun = $_POST["funcionario"];
$proveedor = $_POST["proveedor"];
$tfactura = $_POST["tipofact"];
$plazo = $_POST["plazo"];
$cuotas = $_POST["cuotas"];
$ffactura = $_POST["ffactura"];
$timbrado = $_POST["timbrado"];
$deposito = $_POST["cboiddeposito"];
$detalle = $_POST["detalle"];
$ope = $_POST["ope"];
$con = new conexion();
$con->conectar();//SELECT public.sp_comp(4,4,1,1,1,1,1,'CONTADO','0','1','09-06-2018',1,1,'{{4,1,1,1,15000}}',1);
$sql = pg_query("select sp_comp($codigo,$nro,$emp,$suc,$usu,$fun,$proveedor,'$tfactura','$plazo','$cuotas','$ffactura',$timbrado,$deposito,'$detalle',$ope)");
$noticia = pg_last_notice($con->url);
echo str_replace("NOTICE: ","",$noticia);


?>