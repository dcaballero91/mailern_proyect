<?php 
require "../clases/sesion.php";
verifico();
require "../clases/conexion.php";
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CIUDADES</title>
    <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/nprogress/nprogress.css" rel="stylesheet">
    <link href="../gentelella-master/build/css/custom.min.css" rel="stylesheet">
    <link href="../css/dataTables.responsive.css" rel="stylesheet">
    <link href="../css/flatty.css" rel="stylesheet">
    <link href="../font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="../gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <!-- NProgress -->
    <link href="../gentelella-master/vendors/nprogress/nprogress.css" rel="stylesheet">
    <!-- iCheck -->
    <link href="../gentelella-master/vendors/iCheck/skins/flat/green.css" rel="stylesheet">

    <!-- Custom Theme Style -->
    <link href="../gentelella-master/build/css/custom.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="../css/chosenselect.css" media="screen">
    <link rel="stylesheet" href="../css/bootstrap-select.css">

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
                   <h1 class="page-header" style="color:#000" ><font size="40"  face="arial,verdana"><h1 >CIUDAD</font></h1>
                  
              
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

            <div class="row">
                 
                <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                 <div class="x_title">
                    <h2><strong>Agregar Nuevo Ciudad</strong> </h2> 
                    <div class="clearfix"></div>
                  </div>
                      <div class="form-group">
                        <div class="col-sm-6">
                          <label>Descripción</label>
                           <div class="form-group">
                            <div class="col-md-10 col-sm-6 col-xs-10"><br>
                            <input type="text" id="desc" required="required" class="form-control col-md-10 col-xs-8" placeholder="Ingrese la ciudad">
                             </div>
                        </div>
                        </div>
                      </div>

                      <div class="form-group">
                        <div class="col-sm-6">
                          <label>Pais</label>
                           <div class="form-group">
                            <div class="col-md-10 col-sm-6 col-xs-10"><br>
                            <select  id="pais" class="form-control selectpicker" data-size="5" data-live-search="true" >
                              <option value="0">Elija una Opcion</option>
                              <?php
                                $con = new conexion();
                                $con->conectar();
                                $sql = pg_query("select * from paises order by pais_cod");
                                while($i = pg_fetch_assoc($sql)){
                                  echo "<option value='".$i["pais_cod"]."'>" .$i["pais_desc"]."</option>";
                                };
                              ?>
                            </select>
                             </div>
                        </div>
                        </div>
                      </div><br><br>
                      <div class="col-md-10 col-sm-10 col-xs-10  col-md-offset-0">
                     <div class="ln_solid"></div>
                      <center>
                   <button class="btn btn-info" type="button">Cancel</button>
                   <button  type="submit" class="btn  btn-large btn-success " id="guardar"><span class=""> Guardar</button></center>
                </div>
                </div>




                
              <div class="col-md-12">
                <div class="x_panel">
                  <div class="x_title">
                 <h2><strong>Lista de Ciudades</strong></h2>
                    <ul class="nav navbar-right panel_toolbox">
                   <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
                      <a href="../informes/imp_ciudad.php" target="_blank"  class="btn btn-primary btn-sm fa fa-print" ><strong>Imprimir</strong></a>
                      <li class="dropdown"><!--  <a href="../informes/imp_ciudad.php"  class="btn btn-info btn-sm fa fa-print" >
                                        Imprimir
                                    </a>-->
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>
                        
                      </li>
                      <li><a class="close-link"><i class="fa fa-close"></i></a>
                      </li>
                    </ul>
                    <div class="clearfix"></div>
                  </div>
                  <div class="x_content">

                   

                    <!-- start project list -->
                    <table class="table table-striped projects"  id="referencial">
                      <thead>
                        <tr>
                          <th>Codigo</th>
                          <th>Descripcion</th>
                          <th>Pais</th>
                          <th>Acciones</th>
                        </tr>
                      </thead>
                    </table>
                  </div>
                </div>
              </div>

              <div class="modal" id="modal_basic" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                            <h3 class="modal-title" id="myModalLabel">Editar</h3>
                                        </div>
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-md-2">
                                                        <div class="form-group">
                                                            <label>Codigo</label>
                                                            <input class="form-control" type="text" id="cod_edit" disabled/>
                                                        </div>
                                                </div>
                                                <div class="col-md-5">
                                                        <div class="form-group">
                                                            <label>Descripcion</label>
                                                            <input class="form-control" type="text" id="desc_edit" placeholder="Ingrese la ciudad" />
                                                        </div>
                                                </div>
                                                <div class="form-group">
                                                  <div class="col-sm-5">
                                                    <label>Pais</label>
                                                    <div class="form-group">
                                                      <div class="col-md-10 col-sm-6 col-xs-10">
                                                      <select  id="pais_desc" class="form-control selectpicker" data-size="5" data-live-search="true" >
                                                        <option value="0">Elija una Opcion</option>
                                                        <?php
                                                          $con = new conexion();
                                                          $con->conectar();
                                                          $sql = pg_query("select * from paises order by pais_cod");
                                                          while($i = pg_fetch_assoc($sql)){
                                                            echo "<option value='".$i["pais_cod"]."'>" .$i["pais_desc"]."</option>";
                                                          };
                                                        ?>
                                                      </select>
                                                      </div>
                                                  </div>
                                                  </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-danger" id="cerrar" data-dismiss="modal">Cancelar</button>
                                            <button type="button" class="btn btn-primary" id="guardar_edit">Guardar Cambios</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal" id="confirmacion" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                        <label class="msg"></label>
                                        </div>
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-md-5 col-md-offset-4">
                                                <button type="button" class="btn btn-primary" id="borrar">Si</button>
                                                <button type="button" class="btn btn-danger" id="cerrar2" data-dismiss="modal">Cancelar</button>
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
    <script src="../js/ciudades.js"></script>
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
<!-- bloque de cajas
