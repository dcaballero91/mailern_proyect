
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
    <title>EMPRESA</title>
    <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/nprogress/nprogress.css" rel="stylesheet">
    <link href="../gentelella-master/build/css/custom.min.css" rel="stylesheet">
    <link href="../css/dataTables.responsive.css" rel="stylesheet">
    <link href="../css/flatty.css" rel="stylesheet">
    <link href="../font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
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
              <h2 class="page-header" style="color:#000" ><font size="40"  face="arial,verdana"><h2 >EMPRESA</font></h2>
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
                    <h2><strong>Agregar Nueva Empresa</strong> </h2> 
                    <div class="clearfix"></div>
                  </div>
                      <div class="form-group">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Empresa</label>
                                            <input class="form-control" type="text" id="empresa" />
                                        </div>
                                    </div>                                    
                                   <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Ruc</label>
                                            <input class="form-control" type="text" id="ruc" />
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Direccion</label>
                                            <input class="form-control" type="text" id="direccion" />
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Telefono</label>
                                            <input class="form-control" type="text" id="telefono" />
                                        </div>
                                    </div>
                                     <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Email</label>
                                            <input class="form-control" type="text" id="email" />
                                        </div>
                                    </div>
                                     
                                    
                                    
                                     <div class="col-md-2">
                                            <div class="form-group">
                                                <br>
                                              <input type="button" class=" btn btn-round btn-dark btn-block guardar "  id="guardar" value="GUARDAR" /> 
                                            </div>
                                        </div>

                      </div>
                    </div>
                </div>




                
              <div class="col-md-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2><strong>Lista de Empresas</strong></h2>
                    <ul class="nav navbar-right panel_toolbox">
                        <div class="btn-group">
                                    <a href="../informes/imp_empresas.php"  class="btn btn-dark btn-sm fa fa-print" >
                                        <strong>Imprimir</strong>
                                    </a>
                                    
                                </div>
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
                    <table class="table table-striped projects"  id="empresas">
                      <thead>
                        <tr>
                            <th>Cod</th>
                            <th class="span6">Empresa</th>
                            <th class="span6">Ruc</th>
                            <th class="span6">Direccion</th>
                            <th class="span6">Telefono</th>
                            <th class="span6">Email</th>
                            <th width="15%">Acciones</th>
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
                                                <div class="col-md-5">
                                                        <div class="form-group">
                                                            <label>Empresa</label>
                                                            <input class="form-control" type="text" id="empresa_edit" placeholder="razon" />
                                                        </div>
                                                </div>
                                                <div class="col-md-5">
                                                        <div class="form-group">
                                                            <label>Ruc</label>
                                                            <input class="form-control" type="text" id="ruc_edit" placeholder="ruc" />
                                                        </div>
                                                </div>
                                                <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label>Dirección</label>
                                                            <input class="form-control" type="text" id="direccion_edit" placeholder="direccion"/>
                                                        </div>
                                                </div>
                                                <div class="col-md-8">
                                                        <div class="form-group">
                                                            <label>Telefono</label>
                                                            <input class="form-control" type="text" id="telefono_edit" placeholder="telefono" />
                                                        </div>
                                                </div>
                                                <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label>Email</label>
                                                            <input class="form-control" type="text" id="email_edit" placeholder="email"/>
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
                                                <input type="hidden" id="cod_borrar" value="">
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
                                                <button type="button" class="btn btn-primary" id="borrar">Si</button>
                                                <button type="button" class="btn btn-danger" id="cerrar2" data-dismiss="modal">Cancelar</button>
                                                <input type="hidden" id="cod_borrar" value="">
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
    <script src="../js/empresas.js"></script>
    <script src="../js/jquery.dataTables.js"></script>
    <script src="../js/fnReloadAjax.js"></script>
    <script src="../js/dataTables.bootstrap.js"></script>
    <script src="../js/humane.js"></script>
    
    <script src="../gentelella-master/vendors/bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="../gentelella-master/build/js/custom.min.js"></script>
  </body>
</html>
<!-- bloque de cajas

