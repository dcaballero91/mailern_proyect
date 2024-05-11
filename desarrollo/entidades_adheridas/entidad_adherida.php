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
    <title>ENTIDAD ADHERIDA</title>
    <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/nprogress/nprogress.css" rel="stylesheet">
    <link href="../gentelella-master/build/css/custom.min.css" rel="stylesheet">
    <link href="../css/dataTables.responsive.css" rel="stylesheet">
    <link href="../css/flatty.css" rel="stylesheet">
    <link href="../font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
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
               <h3 class="page-header" style="color:#000" ><font size="40"  face="arial,verdana"><h3 >ENTIDAD ADHERIDA</font></h3>
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
                    <h2><strong>Agregar Nueva Entidad Adherida</strong> </h2> 
                    <div class="clearfix"></div>
                  </div>
                      <div class="form-group">
                                    
                                     
                                    
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Entidad Adherida</label>
                                            <input class="form-control" type="text" id="entidad"placeholder="Entidad Adherida" />
                                        </div>
                                    </div>
                                     <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Entidad Emisora</label>
                                           <select class="form-control selectpicker" data-live-search="true" id="emisora">
                                            <option value="">Seleccione</option>
                                              <?php
                                                    $con = new conexion();
                                                    $con ->conectar();
                                                    $ent = pg_query("select * from entidades_emisoras order by 1;");
                                                    while ($i = pg_fetch_assoc($ent)){
                                                        echo "<option value='".$i["ent_cod"]."'>".$i["ent_nom"]."</option>";
                                                    }
                                                    ?>
                                        </select>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Marca Tarjeta</label>
                                           <select class="form-control selectpicker" data-live-search="true" id="marca">
                                            <option value="">Seleccione</option>
                                              <?php
                                                    $con = new conexion();
                                                    $con ->conectar();
                                                    $ent = pg_query("select * from marca_tarjetas order by 1;");
                                                    while ($i = pg_fetch_assoc($ent)){
                                                        echo "<option value='".$i["mar_tarj_cod"]."'>".$i["mar_tarj_desc"]."</option>";
                                                    }
                                                    ?>
                                        </select>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Direccion</label>
                                            <input class="form-control" type="email" id="dir"placeholder="Direccion" />
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Telefono</label>
                                            <input class="form-control" type="tel" id="tel" placeholder="Telefono" />
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Email</label>
                                            <input class="form-control" type="email" id="email" placeholder="Email" />
                                        </div>
                                    </div>
                                    
                                    
                                     <div class="col-md-2">
                                        <div class="form-group">
                                            <label></label>
                                            <div class="controls">
                                                <button type="submit" class="btn btn-round btn-dark btn-block guardar " id="btnsave">Guardar</button>
                                            </div>
                                        </div>
                                    </div>

                      </div>
                    </div>
                </div>




                
              <div class="col-md-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Lista de Entidades Adheridas</h2>
                   
                    <ul class="nav navbar-right panel_toolbox">
                         <div class="btn-group">
                                    <a href="../informes/imp_entidad_adherida.php"  class="btn btn-info btn-sm fa fa-print" >
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
                    <table class="table table-striped projects"  id="entidad_adherida">
                      <thead>
                        <tr>
                                     <th width="8%">Cod</th>
                                    <th>Entidad Adherida</th>
                                    <th>Marca Tarjeta</th>
                                    <th>Entidad Emisora</th>
                                   <th>Direccion</th>
                                    <th>Telefono</th>
                                    <th>Email</th>
                                     <th width="10%">Acciones</th>
                         </tr>
                      </thead>
                    </table>
                  </div>
                </div>
              </div>

              
    <div class="modal fade bs-example-modal-lg" id="modal_basic" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
         <div class=" modal-dialog-lg">
          <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h2 class="modal-title" id="myModalLabel"><strong>Editar</strong></h2>
            </div>
            <div class="modal-body">
                <div class="row">
                     <div class="col-md-1">
                             <div class="form-group">
                                      <label>Código</label>
                                        <input class="form-control" type="integer" id="cod_edit" disabled/>
                              </div>
                    </div>
                   <div class="col-md-2">
                             <div class="form-group">
                                 <label>Entidad Adherida</label>
                                <input class="form-control" type="text" id="entidad_edit" placeholder="Entidad" />
                             </div>
                  </div>
               <!--  <div class="col-md-4">
                        <div class="form-group">
                            <label>Entidad Adherida</label>
                            <input class="form-control" type="text" id="entidad_edit" />
                            <input class="form-control" type="hidden" id="cod_edit" />
                        </div>
                    </div> -->

                     <div class="col-md-3">
                        <div class="form-group">
                            <label>Entidad Emisora</label>
                            <select class="form-control selectpicker" data-live-search="true" id="emisora_edit">
                                <option value="">Seleccione</option>
                                  <?php
                                    $con = new conexion();
                                    $con ->conectar();
                                    $ent = pg_query("select * from entidades_emisoras order by 1;");
                                    while ($ii = pg_fetch_assoc($ent)){
                                        echo "<option value='".$ii["ent_cod"]."'>".$ii["ent_nom"]."</option>";
                                    }
                                    ?>
                            </select>
                        </div>
                    </div>
                     
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Marca Tarjeta</label>
                            <select class="form-control selectpicker" data-live-search="true" id="marca_edit">
                                            <option value="">Seleccione</option>
                                              <?php
                                                    $con = new conexion();
                                                    $con ->conectar();
                                                    $mar = pg_query("select * from marca_tarjetas order by 1;");
                                                    while ($i = pg_fetch_assoc($mar)){
                                                        echo "<option value='".$i["mar_tarj_cod"]."'>".$i["mar_tarj_desc"]."</option>";
                                                    }
                                                    ?>
                                        </select>
                        </div>
                    </div>
                        
                    
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Direccion</label>
                            <input class="form-control" type="text" id="dir_edit" />
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Telefono</label>
                            <input class="form-control" type="text" id="tel_edit" />
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label>Email</label>
                            <input class="form-control" type="text" id="email_edit" />
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
    <script src="../js/entidad_adherida.js"></script>
    <script src="../js/jquery.dataTables.js"></script>
    <script src="../js/fnReloadAjax.js"></script>
    <script src="../js/dataTables.bootstrap.js"></script>
    <script src="../js/humane.js"></script>
      <script src="../js/bootstrap-select.js"></script>
    <script src="../gentelella-master/vendors/bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="../gentelella-master/build/js/custom.min.js"></script>
  </body>
</html>
<!-- bloque de cajas

