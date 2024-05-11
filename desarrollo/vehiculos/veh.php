<?php 
require "../clases/conexion.php";
$cod = $_POST["cod"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("select * from v_vehiculos where vehi_cod =".$cod);
while($data = pg_fetch_assoc($sql)){
    print_r(json_encode($data));
}
// echo $suc["emp_nom"];
?>