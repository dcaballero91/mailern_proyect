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
    <title>VEHICULO</title>
    <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/nprogress/nprogress.css" rel="stylesheet">
    <link href="../gentelella-master/build/css/custom.min.css" rel="stylesheet">
    <link href="../css/dataTables.responsive.css" rel="stylesheet">
    <link href="../css/flatty.css" rel="stylesheet">
    <link href="../font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
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
                   <h2 class="page-header" style="color:#000" ><font size="40"  face="arial,verdana"><h2 >VEHICULO</font></h2>
                  
              
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
                    <h3>Agregar Nuevo Vehiculo</h3> 
                    <div class="clearfix"></div>
                  </div>
                      
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Marca</label>
                                              <select class="form-control chosen-select"  data-size="10" data-live-search="true" id="marca">

                                                <option value="">Seleccion la Marca</option>
                                                <?php
                                                $con = new conexion();
                                                    $con ->conectar();
                                                    $emp = pg_query("select * from vehiculos_marcas order by 1;");
                                                    while ($i = pg_fetch_assoc($emp)){
                                                        echo "<option value='".$i["veh_mar_cod"]."'>".$i["veh_mar_desc"]."</option>";
                                                    }
                                                    ?>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                      <div class="form-group">
                                        <label>Modelo</label>
                                        <select id="modelo" class="form-control chosen-select" data-size="10" data-live-search="true">
                                        <option value="">Seleccion la Modelo</option>
                                        <?php
                                            $con = new conexion();
                                            $con ->conectar();
                                            $emp = pg_query("select * from vehiculos_modelos order by 1;");
                                            while ($i = pg_fetch_assoc($emp)){
                                                echo "<option value='".$i["veh_mod_cod"]."'>".$i["veh_mod_desc"]."</option>";
                                            }
                                          ?>
                                        </select>
                                      </div>
                                    </div>
                                     
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Chapa</label>
                                            <input class="form-control" type="text" id="chapa" placeholder="Chapa" />
                                        </div>
                                    </div>
                                    
                                     <div class="col-md-1">
                                        <div class="form-group">
                                            <label></label>
                                            <div class="controls">
                                                <button type="submit" class="btn btn-primary" id="btnsave">Guardar</button>
                                            </div>
                                        </div>
                                    </div>
                        <!-- <input type="hidden" class="form-control" id="empresa" value="<?php// echo $resulemp[0]['emp_cod']; ?>"> -->

                      </div>
                    </div>
                </div>

              <div class="col-md-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2><strong>Lista de Vehiculos</strong></h2></li>
                    <ul class="nav navbar-right panel_toolbox">
                      <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>

                      <li class="dropdown">

                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>
                        
                      </li>
                                                                   <a href="../informes/imp_cargo.php"  class="btn btn-primary btn-sm fa fa-print" ><strong>Imprimir</strong></a>

                      <li><a class="close-link"><i class="fa fa-close"></i></a>
                      </li>
                    </ul>
                    <div class="clearfix"></div>
                  </div>
                  <div class="x_content">

                   

                    <!-- start project list -->
                    <table class="table table-striped projects"  id="lista">
                      <thead>
                        <tr>
                                    <th>Cod</th>
                                    <th>Marca</th>
                                    <th>Modelo</th>
                                    <th>Chapa</th>
                                    <th>Estado</th>
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
                                                <h3 class="modal-title" id="myModalLabel"><strong>Editar</strong></h3>
                                            </div>
                                            <div class="modal-body">
                                            <div class="row">
                                                <div class="col-md-2">
                                                        <div class="form-group">
                                                            <label>Código</label>
                                                            <input class="form-control" type="integer" id="cod_edit" disabled/>
                                                        </div>
                                                </div>
                                                <div class="col-md-3">
                                                       <div class="form-group">
                                                       <label>Marca</label>
                                                        <select  id="marca_edit" class="form-control selectpicker">
                                                        <?php
                                                          $con = new conexion();
                                                          $con ->conectar();
                                                          $emp = pg_query("select * from vehiculos_marcas order by 1;");
                                                          while ($i = pg_fetch_assoc($emp)){
                                                              echo "<option value='".$i["veh_mar_cod"]."'>".$i["veh_mar_desc"]."</option>";
                                                          }
                                                          ?>
                                                        </select>
                                                   </div>
                                              </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Modelo</label>
                                            <select class="form-control selectpicker" data-live-search="true" id="modelo_edit">
                                                <!-- <option value="">Seleccione Modelo</option> -->
                                                <?php
                                                $con = new conexion();
                                                    $con ->conectar();
                                                    $emp = pg_query("select * from vehiculos_modelos order by 1;");
                                                    while ($i = pg_fetch_assoc($emp)){
                                                        echo "<option value='".$i["veh_mod_cod"]."'>".$i["veh_mod_desc"]."</option>";
                                                    }
                                                    ?>
                                            </select>
                                        </div>
                                    </div>
                                     
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Chapa</label>
                                            <input class="form-control" type="text" id="chapa_edit" />
                                        </div>
                                    </div>
                                    </div>
                                               
                                               <div class="modal-footer">
                                            <button type="button" class="btn btn-danger" id="cerrar" data-dismiss="modal">Cancelar</button>
                                            <button type="button" class="btn btn-primary" id="btn_edit">Guardar Cambios</button>
                                        </div>
                                               
                                            </div>
                                        </div>

                                        
                                        </div>
                                    </div>
                                </div>
        
    </div>
</div>
</div>
 <div class="modal" id="activacion" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            <label class="msgactive"></label>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-5 col-md-offset-4">
                    <input type="hidden" id="cod_activar" name="">
                    <button type="button" class="btn btn-primary" id="okactive">Si</button>
                    <button type="button" class="btn btn-danger" id="hide" data-dismiss="modal">Cancelar</button>
                    </div>
                </div>
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
                                                        <button type="button" class="btn btn-primary" id="delete">Si</button>
                                                        <button type="button" class="btn btn-danger" id="cerrar2" data-dismiss="modal">Cancelar</button>
                                                        <input type="hidden" id="cod_eliminar" value="">
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
    <script src="../js/vehiculos.js"></script>
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
