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
    <title>PROVEEDOR - TIMBRADO</title>
    <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/bootstrap-select.css">
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
                   <h1 class="page-header" style="color:#000" ><font size="20"  face="arial,verdana"><h1>PROVEEDOR -TIMBRADO</font></h1>             
              </div>
              

            <div class="row"> 
                <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2><STRONG>Agregar Nuevo Timbrado para el Proveedor</STRONG></h2>  
                    <div class="clearfix"></div>
                  </div>
                      <div class="form-group">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Nombre</label>
                                            <select  id="proveedor" class="form-control selectpicker" data-live-search="true" data-size=3>        
                                                <?php
                                                    $con = new conexion();
                                                    $con->conectar();
                                                    $prov = pg_query("select prov_cod, prov_nombre from v_proveedores order by prov_cod");
                                                    while($i= pg_fetch_assoc($prov)){
                                                        echo "<option value='".$i["prov_cod"]."'>".$i["prov_nombre"]."</option>";
                                                    }
                                                ?>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Timbrado</label>
                                            <input class="form-control" type="text" id="timbrado" placeholder="Timbrado"/>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Fecha Venc. Timbrado</label>
                                            <input class="form-control" type="date" id="vighasta" placeholder="Fecha">
                                        </div>
                                    </div>                                    
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <br>
                                            <input type="button" class=" btn btn-round btn-dark btn-block guardar "  id="btnsave" value="GUARDAR" /> 
                                        </div>
                                    </div>
                        </div>
                    </div>
                </div>

               
              <div class="col-md-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2><strong>Lista de Timbrados del Proveedor</strong></h2>
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
                    <table class="table table-striped projects"  id="personas">
                      <thead>
                        <tr>
                        
                            <th>Timbrado</th>
                            <th>Nombre</th>
                            <th>RUC</th>
                            <th width="15%">Timbrado Vig. hasta</th>
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
                        <div class="row"> <!-- Crea la tabla para el contenido  -->
                           
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Nombre</label>
                                        <select id="proveedor_edit" class="form-control selectpicker" data-live-search="true" data-size="3" disabled="true">
                                        <?php
                                                    $con = new conexion();
                                                    $con->conectar();
                                                    $prov = pg_query("select prov_cod, prov_nombre from v_proveedores order by 1");
                                                    while($i= pg_fetch_assoc($prov)){
                                                        echo "<option value='".$i["prov_cod"]."'>".$i["prov_nombre"]."</option>";
                                                    }
                                                ?>
                                        </select>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Timbrado</label>
                                    <input class="form-control" type="integer" id="tim_edit" disabled/>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Timbrado Vig. Hasta</label>
                                    <input class="form-control" type="date"  id="fecha_edit">
                                </div>
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
    <div class="modal" id="confirmacion" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            <label class="msg"></label>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-5 col-md-offset-4">
                    <input type="hidden" id="tim_eliminar" name="">
                    <input type="hidden" id="prov_eliminar" name="">
                    <button type="button" class="btn btn-primary" id="delete">Si</button>
                    <button type="button" class="btn btn-danger" id="hide" data-dismiss="modal">Cancelar</button>
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
    <script src="../js/proveedor_timbrados.js"></script>
    <script src="../js/jquery.dataTables.js"></script>
    <script src="../js/fnReloadAjax.js"></script>
    <script src="../js/dataTables.bootstrap.js"></script>
    <script src="../js/humane.js"></script>
        <script src="../js/bootstrap-select.js"></script>
    <script src="../gentelella-master/vendors/bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="../gentelella-master/build/js/custom.min.js"></script>
  </body>
</html>
