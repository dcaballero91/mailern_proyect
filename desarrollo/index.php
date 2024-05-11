<?php 
require 'clases/conexion.php';
require 'clases/funciones.php';
require 'clases/sesion.php';

if(estas_logeado()){
    llevame_a("controles/inicio.php");
}
?>
<!DOCTYPE html>
<html lang="es">
<head>

        <meta charset="utf-8">
        <title>Acceso Sistema</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="">
        <meta name="author" content="">

        <!-- CSS -->
        <link rel='stylesheet' href='http://fonts.googleapis.com/css?family=PT+Sans:400,700'>
        <link rel="stylesheet" href="css/reset.css">
        <link rel="stylesheet" href="css/supersized.css">
        <link rel="stylesheet" href="css/style.css">
        <style >
            body{
              background: url(./imagenes/fon1.jpg) no-repeat center center fixed;
              background-size: cover;
              -webkit-background-size: cover;
              -moz-background-size:cover;
            }
          </style> 

    </head>
<body>

        <div class="page-container">
            <h1>Acceso al Sistema</h1>
            <form action="clases/acceso.php" method="post">
            <?php echo "<p style='color: red;'>".msg_sesion()."</p>";?> <!--Mensaje de sesion -->
                <input type="text" class="form-control input-lg" placeholder="Usuario" name="usu" />
                <input type="password" class="form-control" placeholder="Contraseña" name="pass" id="pass" value="">
                <button type="submit"  class=" btn-lg btn-success btn-block sign-out "   value="Ingresar" >INGRESAR</button>
                <div class="error"><span>+</span></div>
            </form>
            
                <div style="margin-top: 30px;">
                  <!-- <h1><i class="fa fa-cut"></i> ASTORE SA</h1> -->
                  <p>©2019 Todos los derechos reservados. Alfredo Sanchez</p>
                </div>
        </div>

        <!-- Javascript -->
        <script src="js/jquery-1.8.2.min.js"></script>
        <script src="js/supersized.3.2.7.min.js"></script>
        <!-- <script src="js/supersized-init.js"></script> -->
        <script src="js/scripts.js"></script>

    </body>
   </html> 
    
    
    
    
    
   