<?php 
require "../clases/sesion.php";
verifico();
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$nro = pg_query("select coalesce(max(ord_trab_cod),0)+1 as nro from ordenes_trabajos_cab;");
$nros = pg_fetch_assoc($nro);   
date_default_timezone_set('America/Asuncion');
$fecha = date("d/m/Y H:i:s");
// date_default_timezone_set('America/Asuncion');
$fecha2 = date("d/m/Y");
?>
<!DOCTYPE html>
<html lang="en">
   <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>CONFIRMACION DE  TRABAJOS</title>
        <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="../gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">    
        <link href="../gentelella-master/build/css/custom.min.css" rel="stylesheet">    
        <link href="../css/flatty.css" rel="stylesheet"> 
        <link rel="stylesheet" type="text/css" href="../css/chosenselect.css" media="screen">
        <link rel="stylesheet" href="../css/bootstrap-select.css">
        <!--<link rel="stylesheet" href="place.css">-->
<link rel="stylesheet" type="text/css" href="../css/chosenselect.css" media="screen">
        <link rel="stylesheet" href="../css/bootstrap-select.css">
        <!--<link rel="stylesheet" type="text/css" href="../../css/chosenselect.css" media="screen">-->
<style >
            body{
              background: url(../imagenes/fon1.jpg) no-repeat center center fixed;
              background-size: cover;
              -webkit-background-size: cover;
              -moz-background-size:cover;
            }
          </style>
    </head>
  <body class="nav-md">
    <div class="container body">
      <div class="main_container">
        <?php require '../controles/menu_cabecera.php' ?>
        <div class="right_col">
          <div class="">
            <div class="page-title">
            <div class="title_left">
                                <h1 class="page-header" style="color: #0a0a0a;" > <font  face=" Century Gothic">CONFIRMACION DE TRABAJOS </h1>
                            </div>
              <div class="title_right">
                <div class="col-md-5 col-sm-5 col-xs-12 form-group pull-right top_search">
                  <div class="input-group">
                    <input type="text" class="form-control" placeholder="Search for...">
                    <span class="input-group-btn">
                      <button class="btn btn-default" type="button">Go!</button>
                    </span>
                  </div>
                </div>
              </div>
            </div>


                <div class="col-md-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Lista de las Ordenes de Trabajos</h2>
                    <ul class="nav navbar-right panel_toolbox">
                      <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                      </li>
                      <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>
                        
                      </li>
                      <li><a class="close-link"><i class="fa fa-close"></i></a>
                      </li>
                    </ul>
                    <div class="clearfix"></div>
                  </div>
                  <div class="panel-body">
                            <div class="dataTable_wrapper">
                                <table class="table" id="tabla">
                                    <thead>
                                         <tr>
                                            <th></th>
                                            <th width="4%">Código</th>
                                             <!-- <th>Fecha</th> -->
                                            <th>Empresa</th>
                                            <th>Sucursal</th>
                                            <th width="20%">Cliente</th>
                                           <th>Usuario</th>
                                            <th>Estado</th>
                                            <th  width="10%">Acciones</th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                </div>
              </div>
            <div class="modal" id="anularCabecera" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <label class="msgC"></label>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-5 col-md-offset-4">

                                    <button type="button" class="btn btn-primary" id="delete">Si</button>
                                    <button type="button" class="btn btn-danger" id="hide" data-dismiss="modal">Cancelar</button>
                                    <input type="hidden" id="cod_eliminar" value="">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal" id="ordenarCabecera" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <label class="msg2"></label>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-5 col-md-offset-4">

                                    <button type="button" class="btn btn-primary" id="ordenar">Si</button>
                                    <button type="button" class="btn btn-danger" id="hide" data-dismiss="modal">Cancelar</button>
                                    <input type="hidden" id="cod_ordenar" value="">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

          
                </div>
            </div>
        </div>
    </div>
    </div>
    </div>
     
<script src="../js/jquery.js"></script>

<script src="../js/confirmacion_ordentrabajo.js"></script> 
<script src="../js/jquery.dataTables.js"></script>
<script src="../js/fnReloadAjax.js"></script>
<script src="../js/dataTables.bootstrap.js"></script>
<script src="../js/humane.js"></script>
<script src="../js/bootstrap-select.js"></script>

<script src="../gentelella-master/vendors/bootstrap/dist/js/bootstrap.min.js"></script>
<script src="../gentelella-master/build/js/custom.min.js"></script>
<script src="../js/chosenselect.js"></script>

  </body>
</html>
