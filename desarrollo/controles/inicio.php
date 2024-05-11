<?php 
require "../clases/funciones.php";
require "../clases/sesion.php";
require "../clases/conexion.php";
verifico();
date_default_timezone_set('America/Asuncion');
$fecha = date("d-m-Y");
$con = new conexion();
$con->conectar();
// $cant = pg_query("select count(comp_nro) as comp_cantidad from compras_cab where comp_estado = 'PENDIENTE'");
// $cantidad = pg_fetch_assoc($cant);
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>INICIO - ASTORE II</title>
    <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/nprogress/nprogress.css" rel="stylesheet">
    <link href="../gentelella-master/build/css/custom.min.css" rel="stylesheet">
           <style >
            body{
              background: url(../imagenes/fon1.jpg) no-repeat center center fixed;
              background-size: cover;
              -webkit-background-size: cover;
              -moz-background-size:cover;
            }
          </style> 
<!--    <link href="../imagenes/fondos.css" rel="stylesheet">-->
  </head>

  <body class="nav-md">
    <div class="container body">
      <div class="main_container">

        <?php require '../controles/menu_cabecera.php' ?>

        <div class="right_col">
          <div class="">
            <div class="page-title">
              <div class="title_left">
             <h1 class="page-header" style="color:#0a0a0a" > Página Principal</h1>
              </div>

              <div class="title_right">
                <div class="col-md-5 col-sm-5 col-xs-12 form-group pull-right top_search">
                  <div class="input-group">
                    <input type="text" class="form-control" placeholder="Buscar...">
                    <span class="input-group-btn">
                      <button class="btn btn-default" type="button">Go!</button>
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <div class="clearfix"></div>
        
              <!-- <div class="animated flipInY col-lg-3 col-md-3 col-sm-6 col-xs-12">
                <div class="tile-stats">
                  <div class="icon"><i class="fa fa-shopping-cart fa-fw"></i></div>
                  <div class="count"><?php echo $cantidad["comp_cantidad"];?></div>
                  <h3>COMPRAS</h3>
                  <p><a href="../ciudades/ciudad.php">Ver Detalles</a></p>
                </div>
              </div>

            <div class="animated flipInY col-lg-3 col-md-3 col-sm-6 col-xs-12">
                <div class="tile-stats">
                  <div class="icon"><i class="fa fa-cut"></i></div>
                  <div class="count">179</div>
                  <h3>SERVICIOS</h3>
                  <p><a href="../ciudades/ciudad.php">Ver Detalles</a></p>
                </div>
              </div>

              <div class="animated flipInY col-lg-3 col-md-3 col-sm-6 col-xs-12">
                <div class="tile-stats">
                  <div class="icon"><i class="fa fa-usd fa-fw"></i></div>
                  <div class="count">179</div>
                  <h3>VENTAS</h3>
                  <p><a href="../ciudades/ciudad.php">Ver Detalles</a></p>
                </div>
              </div> -->


           
          </div>
        </div>
      </div>
      <!-- footer content -->
        <footer>
          <div class="pull-right">
          ASSYSTEMS - "Creado por @Alfredo sanchez Admin Template" by <a href="https://asanchez.com">@alfredo_sanchez</a>
          </div>
          <div class="clearfix"></div>
        </footer>
        <!-- /footer content -->
    </div>

    <script src="../gentelella-master/vendors/jquery/dist/jquery.min.js"></script>
    <script src="../gentelella-master/vendors/bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="../gentelella-master/vendors/fastclick/lib/fastclick.js"></script>
    <script src="../gentelella-master/vendors/nprogress/nprogress.js"></script>
    <script src="../gentelella-master/build/js/custom.min.js"></script>
  </body>
</html>
