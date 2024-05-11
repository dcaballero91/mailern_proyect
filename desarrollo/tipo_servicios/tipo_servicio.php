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
    <title>TIPO SERVICIO</title>
    <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">

<link rel="stylesheet" href="../css/bootstrap-select.css">
    <link href="../gentelella-master/vendors/nprogress/nprogress.css" rel="stylesheet">
    <link href="../gentelella-master/build/css/custom.min.css" rel="stylesheet">
    <link href="../css/dataTables.responsive.css" rel="stylesheet">
    <link href="../css/flatty.css" rel="stylesheet">
    <link href="../font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">




   
  </head>
  <body class="nav-md">
    <div class="container body">
      <div class="main_container">
        <?php require '../controles/menu_cabecera.php' ?>
        <div class="right_col">
          <div class="">
            <div class="page-title">
              <div class="title_left">
                <h3 class="page-header" style="color:#C4CFDA" ><font size="40"  face="arial,verdana"><h3 >TIPOS DE SERVICIO</font></h3>
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
                    <h2>Tipo Servicio</h2>  
                    <div class="clearfix"></div>
                  </div>
                      <div class="form-group">
                        <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Tipo Servicio</label>
                                            <input class="form-control" type="text" id="tserv" />
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Precio</label>
                                            <input class="form-control" type="text" id="precio" />
                                        </div>
                                    </div>
                                     <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Especialidad</label>
                                            <select class="form-control selectpicker" data-live-search="true" id="especialidad">
                                                
                                                <?php
                                                $con = new conexion();
                                                    $con ->conectar();
                                                    $emp = pg_query("select * from v_especialidades order by 1;");
                                                    while ($i = pg_fetch_assoc($emp)){
                                                        echo "<option value='".$i["esp_cod"]."'>".$i["esp_desc"]."</option>";
                                                    }
                                                    ?>
                                            </select>
                                        </div>
                                    </div>
                                     <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Tipo Impuesto</label>
                                            <select class="form-control selectpicker" data-live-search="true" id="impuesto">
                                                <option value="EXENTA">EXENTA</option>
                                                <option value="GRAVADA 5">GRAVADA 5</option>
                                                <option value="GRAVADA 10">GRAVADA 10</option>

                                            </select>
                                        </div>
                                    </div>
                            <div class="col-md-4">
                                        <div class="form-group">
                                            <button type="submit" class="btn btn-primary" id="btnsave"><span class="fa fa-save"></span> Guardar</button>
                                        </div>
                                </div>
                          </div>
                        </div>
                      </div>
                    </div>
                </div>




                
              <div class="col-md-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Lista de Tipos de Servicios</h2>
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
                  <div class="x_content">

                   

                    <!-- start project list -->
                    <table class="table table-striped projects"  id="lista">
                      <thead>
                        <tr>
                                   <th width="4%">Cod</th>
                                    <th width="4%" >Tipo de Servicios</th>
                                    <th width="4%">Tipo Impuesto</th>
                                    <th width="4%">Precio</th>
                                    <th width="4%">Especialidad</th>
                                    <!--<th width="4%">Precio</th>-->
                                    <th width="4%" >Estado</th>
                                    <th width="1%">Acciones</th>
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
                  <div class="col-md-3">
                                <div class="form-group">
                                    <label>Código</label>
                                    <input class="form-control" type="integer" id="cod_edit" disabled/>
                                </div>
                            </div>
                  <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Tipo Servicio</label>
                                            <input class="form-control" type="text" id="tserv_edit" />
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Precio</label>
                                            <input class="form-control" type="text" id="precio_edit" />
                                        </div>
                                    </div>
                                     <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Especialidad</label>
                                            <select class="form-control selectpicker" data-live-search="true" id="especialidad_edit">
                                                
                                                <?php
                                                $con = new conexion();
                                                    $con ->conectar();
                                                    $emp = pg_query("select * from v_especialidades order by 1;");
                                                    while ($i = pg_fetch_assoc($emp)){
                                                        echo "<option value='".$i["esp_cod"]."'>".$i["esp_desc"]."</option>";
                                                    }
                                                    ?>
                                            </select>
                                        </div>
                                    </div>
                                     <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Tipo Impuesto</label>
                                            <select class="form-control selectpicker" data-live-search="true" id="impuesto_edit">
                                                <option value="EXENTA">EXENTA</option>
                                                <option value="GRAVADA 5">GRAVADA 5</option>
                                                <option value="GRAVADA 10">GRAVADA 10</option>

                                            </select>
                                        </div>
                                    </div>

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
<div class="modal" id="desactivacion" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            <label class="msgdesactivo"></label>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-5 col-md-offset-4">
                    <input type="hidden" id="cod_desactivar" name="">
                    <button type="button" class="btn btn-primary" id="desactivar">Si</button>
                    <button type="button" class="btn btn-danger" id="hide" data-dismiss="modal">Cancelar</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
      <!-- ACTIVAR-->
<div class="modal" id="activacion" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            <label class="msgactivo"></label>
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

                </div>
            </div>
        </div>
    </div>
     </div>
    </div>
    <script src="../js/jquery.js"></script>
    <script src="../js/tipo_servicios.js"></script>
    <script src="../js/jquery.dataTables.js"></script>
    <script src="../js/fnReloadAjax.js"></script>
    <script src="../js/dataTables.bootstrap.js"></script>
    <script src="../js/humane.js"></script>
          <script src="../js/bootstrap-select.js"></script>

    <script src="../gentelella-master/vendors/bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="../gentelella-master/build/js/custom.min.js"></script>
  </body>
</html>
