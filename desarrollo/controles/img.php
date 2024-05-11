 <?php 
require "../clases/funciones.php";
require "../clases/sesion.php";
require "../clases/conexion.php";
verifico();
$con= new conexion();
$con->conectar();
$fotos = pg_query("SELECT usu_foto FROM v_usuarios where usu_cod=$_SESSION[id]");
while ($foto = pg_fetch_row($fotos)) {
  $foto2=$foto[0];  
}
?>

 <img src="<?php echo  "$foto2"; ?>" class="img-circle profile_img">