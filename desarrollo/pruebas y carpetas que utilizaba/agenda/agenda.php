<?php

require "../clases/funciones.php";
require "../clases/sesion.php";
require "../clases/conexion.php";
verifico();
$con = new conexion();
$con ->conectar();

//$nros = pg_fetch_assoc($nro);
$fecha = date("d/m/Y H:h:m");
?>
<!DOCTYPE html>
<html lang="es">
 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Agendas</title>
    <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
     <link href="../vendors/nprogress/nprogress.css" rel="stylesheet">
    <link href="../gentelella-master/build/css/custom.min.css" rel="stylesheet">
      <link href="../vendors/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet">
    <link href="../css/flatty.css" rel="stylesheet">
    
    
    <link rel="stylesheet" href="../css/bootstrap-select.css">
    <link rel="stylesheet" href="place.css">



    
  </head>
<body class="nav-md">
    <div class="container body">
      <div class="main_container">
        <?php require '../controles/menu_cabecera.php' ?>
        <div class="right_col">
          <div class="">
            <div class="page-title">
              <div class="title_left">
               <h3 class="page-header" style="color:#ffffff" > <font  face="arial"><strong>Registros de Agendas Profesionales</strong></h3>
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
                    <h2>Agendas</h2>  
                    <div class="clearfix"></div>
                  </div>
                      <div class="form-group">
                        <div class="col-sm-12">
                          

                                 <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Funcionario</label>
                                            
                                                <input  class="form-control" type="text" value="<?php echo $_SESSION["fun_nom"] . " " . $_SESSION["fun_ape"]; ?>" disabled/>
                                            
                                        </div>
                                    </div>
                            <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Profesional</label>
                                            
                                                <select class="form-control selectpicker" data-size="10" data-live-search="true" id="profesion">
                                             
                                                  <?php
                                                  $var = pg_query("select * from v_funcionarios order by fun_cod;");
                                                  while ($i = pg_fetch_assoc($var)) {
                                                    echo "<option value='" . $i["fun_cod"] . "'>" . $i["fun_cod"] . " - " . $i["fun_nom"] . "</option>";
                                                        }
                                                  ?>
                                              </select>
                                        </div>
                                    </div>
                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Fecha</label>
                                                    <input class="form-control" type="text" id="fecha" value="<?php echo $fecha; ?>" disabled/>
                                                </div>
                                            </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Dias de Atención</label>
                                                

                                              <select class="form-control selectpicker" data-size="10" data-live-search="true" id="dias">
                                                <option>Elija una Opcion</option>
                                                  <?php
                                                  $var = pg_query("select * from dias order by dias_cod;");
                                                  while ($i = pg_fetch_assoc($var)) {
                                                    echo "<option value='" . $i["dias_cod"] . "'>" . $i["dias_cod"] . " - " . $i["dias_desc"] . "</option>";
                                                        }
                                                  ?>
                                              </select>
                                        </div>
                                    </div>

                                    
   
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Seleccionar Especialidad</label>
                                                 <select class="form-control selectpicker" data-size="10" data-live-search="true" id="especialidad">
                                                <option>Elija una Opcion</option>
                                                  <?php
                                                  $var = pg_query("select * from v_especialidades order by esp_cod;");
                                                  while ($i = pg_fetch_assoc($var)) {
                                                    echo "<option value='" . $i["esp_cod"] . "'>" . $i["esp_cod"] . " - " . $i["esp_desc"] . "</option>";
                                                        }
                                                  ?>
                                              </select>
                                        </div>
                                    </div>
                                    

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Profesion</label>
                                            
                                                    <input class="form-control" type="text"  id="profesion" placeholder="profesion" disabled />
                                               
                                        </div>
                                    </div>

                                    
                                     <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Hora desde</label>
                                            
                                                    <input class="form-control" type="time"  id="hora_desde"/>
                                               
                                        </div>
                                    </div>

                                     <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Hora hasta</label>
                                            
                                                    <input class="form-control" type="time"  id="hora_hasta"/>
                                               
                                        </div>
                                    </div>
                                        <div class="col-md-1">
                                        <div class="form-group">
                                            <label> Nº Cupos</label>
                                            
                                                    <input class="form-control" type="number"  id="cupo"/>
                                               
                                        </div>
                                    </div>
                                    <input type="hidden" id="detalle" value="">
                                                            <input type="hidden" id="usuario" value="<?php echo $_SESSION["id"]; ?>">
                                                            <input type="hidden" id="funcionario" value="<?php echo $_SESSION["fun_cod"]; ?>">
                                                            <input type="hidden" id="empresa" value="<?php echo $_SESSION["emp_cod"]; ?>">
                                                            <input type="hidden" id="sucursal" value="<?php echo $_SESSION["suc_cod"]; ?>">
                                    
                                <div class="col-md-12">
                                        <div class="form-group">
                                            <br>
                                            <input type="button" class="btn btn-info btn-block agregar" id="agregar" value="AGREGAR"/>
                                        </div>
                                </div>
                                    <div class="col-md-12">
                                    <div class="table-responsive table-bordered">
                                        <table class="table table-responsive" id="grilladetalle">
                                        <thead>
                                            <tr>
                                                <th>Código</th>
                                                <th>Especialidad</th>
                                                <th>Fecha</th>
                                                <th>Hora Desde</th>
                                                <th>Hora Hasta</th>
                                                <th>Cupos</th>
                                                <th>Dias de Atención</th>
                                             
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                        <!-- <tfoot>
                                            <tr>
                                                <th colspan="5" class="text-right" id="total">Total: 0.00 Gs.</th>
                                            </tr>
                                        </tfoot> -->
                                    </table>
                                </div><br>
                                </div>
                                <div class="col-md-12">
                                        <div class="form-group">
                                    <button type="submit" class="btn btn-primary pull-right" id="grabar"><span class="fa fa-save"></span> GRABAR</button>
                                        </div>
                                </div>

                        </div>
                      </div>
                    </div>
                </div> 

                <div class="col-md-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Lista de Agendas Profesionales</h2>
                    <ul class="nav navbar-right panel_toolbox">
                      <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                      </li>
                      <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>
                        
                      </li>
                      <li><a class="close-link"><i class="fa fa-close"></i></a>
                      </li>
                    </ul>
                      <div class="row">
              <div class="col-md-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Weekly Summary <small>Activity shares</small></h2>
                    <ul class="nav navbar-right panel_toolbox">
                      <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                      </li>
                      <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>
                        <ul class="dropdown-menu" role="menu">
                          <li><a href="#">Settings 1</a>
                          </li>
                          <li><a href="#">Settings 2</a>
                          </li>
                        </ul>
                      </li>
                      <li><a class="close-link"><i class="fa fa-close"></i></a>
                      </li>
                    </ul>
                    <div class="clearfix"></div>
                  </div>
                  <div class="x_content">

                    <div class="row" style="border-bottom: 1px solid #E0E0E0; padding-bottom: 5px; margin-bottom: 5px;">
                      <div class="col-md-7" style="overflow:hidden;">
                        <span class="sparkline_one" style="height: 160px; padding: 10px 25px;">
                                      <canvas width="200" height="60" style="display: inline-block; vertical-align: top; width: 94px; height: 30px;"></canvas>
                                  </span>
                        <h4 style="margin:18px">Weekly sales progress</h4>
                      </div>

                      <div class="col-md-5">
                        <div class="row" style="text-align: center;">
                          <div class="col-md-4">
                            <canvas class="canvasDoughnut" height="110" width="110" style="margin: 5px 10px 10px 0"></canvas>
                            <h4 style="margin:0">Bounce Rates</h4>
                          </div>
                          <div class="col-md-4">
                            <canvas class="canvasDoughnut" height="110" width="110" style="margin: 5px 10px 10px 0"></canvas>
                            <h4 style="margin:0">New Traffic</h4>
                          </div>
                          <div class="col-md-4">
                            <canvas class="canvasDoughnut" height="110" width="110" style="margin: 5px 10px 10px 0"></canvas>
                            <h4 style="margin:0">Device Share</h4>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>


                    <div class="clearfix"></div>
                  </div>
                  <div class="panel-body">
                            <div class="dataTable_wrapper">
                                <table class="table" style="color: #000;" id="agendas">
                                    <thead>
                                        <tr width="80px">
                                            <th></th>
                                            <th>Codigo</th>
                                            <th>Funcionario</th>
                                            <th>Profesion</th>
                                            <th>Estado</th>
                                            <th>Acciones</th>
                                            
                                        </tr>
                                    </thead>
                                </table>
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
                                    <button type="button" class="btn btn-danger" id="hide" data-dismiss="modal">Cancelar</button>
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

<script src="../js/agenda.js"></script>
 

<script src="../js/jquery.dataTables.js"></script>
<script src="../js/fnReloadAjax.js"></script>
<script src="../js/dataTables.bootstrap.js"></script>

<script src="../js/humane.js"></script>
<script src="../js/bootstrap-select.js"></script>
 <script src="../vendors/DateJS/build/date.js"></script>
   <!-- <script src="../vendors/moment/min/moment.min.js"></script> -->
    <script src="../gentelella-master/vendors/bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="../gentelella-master/build/js/custom.min.js"></script>
     <script src="../vendors/bootstrap-daterangepicker/daterangepicker.js"></script>
     <script src="../vendors/moment/min/moment.min.js"></script>
  </body>
</html>
