<?php 
require "../clases/sesion.php";
verifico();
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();

$cant = pg_query("select coalesce(max(aper_cier_cod),0)+1 as aper_cier_cod from v_aperturas_cierres ");
date_default_timezone_set('America/Asuncion');
$fecha = date('d/m/y H:i:s');
$cantidad = pg_fetch_assoc($cant);
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>APERTURAS CIERRES</title>
    <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/bootstrap-select.css">
    <link href="../gentelella-master/vendors/nprogress/nprogress.css" rel="stylesheet">
    <link href="../gentelella-master/build/css/custom.min.css" rel="stylesheet">
    <link href="../css/dataTables.responsive.css" rel="stylesheet">
    <link href="../css/flatty.css" rel="stylesheet">
    <link href="../font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <style>
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
               <h3 class="page-header" style="color:#000000" ><font size="25"  face="arial,verdana"><h3 >APERTURA CIERRE </font></h3>
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
                    <h2><strong>Agregar Nuevo Registro</strong> </h2> 
                    <div class="clearfix"></div>
                  </div>
                      <div class="form-group">
                                    
                                      <div class="col-md-2" id="nro">
                                        <div class="form-group">
                                            <label>Nro.</label>
                                            <input class="form-control" type="text"  id="codigo" value="<?php echo $cantidad["aper_cier_cod"];?>" disabled />
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                          <label>Fecha Apertura</label>
                                          <input class="form-control" type="text" id="feaper" value="<?php echo $fecha ?>" disabled/>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                          <label>Empresa</label>
                                          <input class="form-control" type="text"  value="<?php echo $_SESSION["emp_nom"]; ?>" disabled/>
                                        </div>
                                    </div>
                                   

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Sucursal</label>
                                            
                                                    <input class="form-control" type="text" value="<?php echo $_SESSION["suc_nom"]; ?>" disabled/>
                                               
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Funcionario</label>
                                            
                                                <input  class="form-control" type="text" value="<?php echo $_SESSION["fun_nom"]; ?>" disabled/>
                                            
                                        </div>
                                    </div> 
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label>Caja</label>
                                               
                                              <select class="form-control selectpicker" data-size="5" data-live-search="true" id="caja">
                                                <option value="0">Elija una caja</option>
                                                  <?php
                                                  $var = pg_query("SELECT * from v_cajas where suc_cod = " . $_SESSION['suc_cod'] . " AND usu_cod = ".$_SESSION["id"]." ORDER BY caja_cod" );
                                                  // $var = pg_query("SELECT * FROM v_cajas");
                                                  while ($i = pg_fetch_assoc($var)) {
                                                    echo "<option value='" . $i["caja_cod"] . "'>"  . $i["caja_desc"] . "</option>";
                                                  }
                                                  ?>
                                              </select>
                                        </div>
                                    </div>

                                     
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Monto Apertura</label>
                                            <input class="form-control" type="text" id="aperturamonto" placeholder="0 Gs."  />
                                        </div>
                                    </div>
                                     <!-- <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Fecha Cierre</label>
                                            <input class="form-control" type="text" id="fecierre" placeholder="-- / -- / --"  readonly/>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Monto Cierre</label>
                                            <input class="form-control" type="text" id="ciermonto" value="0" placeholder="0 Gs."  readonly/>
                                        </div>
                                    </div> -->
                         
                                     <div class="col-md-2">
                                        <div class="form-group">
                                            <label></label>
                                            <div class="controls">
                                                <button type="submit" class="btn btn-round btn-dark btn-block" class="fa fa-floppy-o" id="btnsave">APERTURA</button>
                                            </div>
                                        </div>
                                    </div>

                      </div>
                    </div>
                </div>
                        <input type="hidden" id="detalle" value="">
                        <input type="hidden" id="usuario" value="<?php echo $_SESSION["id"]; ?>">
                        <input type="hidden" id="funcionario" value="<?php echo $_SESSION["fun_cod"]; ?>">
                        <input type="hidden" id="empresa" value="<?php echo $_SESSION["emp_cod"]; ?>">
                        <input type="hidden" id="sucursal" value="<?php echo $_SESSION["suc_cod"]; ?>">
                        <!-- <input type="hidden" id="caja" value="<?php echo $_SESSION["caja"]; ?>"/> -->

                
              <div class="col-md-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Lista de Aperturas / Cierres</h2>
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
                    <table class="table table-striped projects"  id="apercierre">
                      <thead>
                        <tr>
                            <th>Cod</th>
                            <!-- <th>Empresa</th> -->
                            <th>Sucursal</th>
                            <th>Fecha Apertura</th>
                            <th>Fecha Cierre</th>
                            <th>Monto Apertura</th>
                            <th width="7%">Caja</th>
                            <th>Sgte. Factura</th>
                            <th>Efectivo</th>
                            <th>Tarjeta</th>
                            <th>Cheque</th>
                            <th>Total Cierre</th>
                            <th width="14%">Acciones</th>
                         </tr>
                      </thead>
                    </table>
                  </div>
                </div>
              </div>

               <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

   
  <div class="modal fade bs-example-modal-lg" id="confirmacion" tabindex="-1" role="dialog" aria-labelledby="true" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                         <div class="modal-header">
                                            <!-- <label class="msg"></label> -->
                                            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span>
                                       </button>
                                      <h4 class="modal-title" id="myModalLabel"><strong>Cierre de Caja</strong></h4>
                                        </div>
                                        <div class="modal-body">
                                            <div class="row">
                                               <p><label class="msg"></label></p>
                                                <div class="col-md-5 col-md-offset-4">
                                                <input type="hidden" id="cod_eliminar" value="">

                                                  </div><br>
                                                <div class="modal-footer">
                                                  <button type="button" class="btn btn-success" id="delete">Cerrar</button>
                                                  <button type="button" class="btn btn-info" id="cerrar2" data-dismiss="modal">Cancelar</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    </div>
                                </div>
                            </div> 
<!-- PRUEBA DE MODAL
 -->         
             <!-- <div class="modal  fade bs-example-modal-lg" tabindex="-1" id="confirmacion2"  role="dialog" aria-labelledby="true" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            
                                            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span>
                                       </button>
                                      <h4 class="modal-title" id="myModalLabel"><strong>Cierre de Caja</strong></h4>
                                        </div>
                                        <div class="modal-body">
                                            <div class="row">
                                               <label class="msg"></label>
                                                <div class="col-md-5 col-md-offset-4">
                                                
                                                  
                                                <input type="hidden" id="cod_eliminar" value="">
                                                </div>
                                                 <div class="modal-footer">
                         
                          <button type="button" class="btn btn-success" id="delete">Cerrar</button>
                         <button type="button" class="btn btn-info" id="cerrar2" data-dismiss="modal">Cancelar</button>
                        </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>  -->

 <!--FIN  PRUEBA DE MODAL
 --> 
           
                </div>
            </div>
        </div>
    </div>
     </div>
    </div>
    <script src="../js/jquery.js"></script>
  
    <script src="../js/apertura_cierre.js"></script>
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


