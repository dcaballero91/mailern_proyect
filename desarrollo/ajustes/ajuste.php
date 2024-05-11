<?php 
require "../clases/sesion.php";
verifico();
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$nro = pg_query("select coalesce(max(ajus_cod),0)+1 as nro from ajustes_cab;");
$nros = pg_fetch_assoc($nro);
date_default_timezone_set('America/Asuncion');
$fecha = date("d/m/Y H:h:m");
?>
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>AJUSTES</title>
    <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    
    <link href="../gentelella-master/build/css/custom.min.css" rel="stylesheet">
    
    <link href="../css/flatty.css" rel="stylesheet">
       <link rel="stylesheet" type="text/css" href="../css/chosenselect.css" media="screen">
        <link rel="stylesheet" href="../css/bootstrap-select.css">
   <link rel="stylesheet" href="../css/bootstrap-select.css">
    <link rel="stylesheet" href="place.css"> 
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
                                <h1 class="page-header" style="color: #0e0e0e;" > <font  face=" Century Gothic">AJUSTES DE STOCK </h1>
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
                    <h2>AGREGAR NUEVO</h2>  
                    <div class="clearfix"></div>
                  </div>
                      <div class="form-group">
                        <div class="col-sm-12">
                          
                               <div class="col-md-1">
                                        <div class="form-group">
                                            <label>Nro.</label>
                                            <input class="form-control" type="text"  id="nro" value="<?php echo $nros["nro"]; ?>" disabled/>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Fecha</label>
                                            <input class="form-control" type="text" id="fecha" value="<?php echo $fecha; ?>" disabled/>
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
                                            
                                                <input  class="form-control" type="text" value="<?php echo $_SESSION["fun_nom"] ?>" disabled/>
                                            
                                        </div>
                                    </div>

<!-- 
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Seleccionar Depósito</label>
                                              <select class="form-control selectpicker" data-size="10" data-live-search="true" id="deposito">
                                                <option>Elija una Opcion</option>
                                                  <?php
                                                  $var = pg_query("select * from v_depositos order by dep_cod;");
                                                  while ($i = pg_fetch_assoc($var)) {
                                                    echo "<option value='" . $i["dep_cod"] . "'> " . $i["dep_desc"] . "</option>";
                                                        }
                                                  ?>
                                              </select>
                                        </div>
                                    </div> -->
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Seleccionar Deposito</label>
                                              <select class="form-control selectpicker" data-size="5" data-live-search="true" id="dep">
                                              <option value="0">Elija una Opcion</option>
                                                  <?php
                                                  $var = pg_query("select * from depositos where dep_cod in (select dep_cod from stock) and suc_cod = ".$_SESSION["suc_cod"]." order by dep_cod  ;");
                                                  while ($i = pg_fetch_assoc($var)) {
                                                    echo "<option value='" . $i["dep_cod"] . "'>"  . $i["dep_desc"] . "</option>";
                                                        }
                                                  ?>
                                              </select>
                                        </div>
                                    </div>
                                       
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Seleccionar Item</label>
                                              <select class="form-control selectpicker" data-size="10" data-live-search="true" id="item">
                                                    <option value="0">Elija primero un deposito</option>
                                              </select>
                                        </div>
                                    </div>
                                   <div class="col-md-3">
                                     <div class="form-group">
                                        <Label>Marcas</Label>
                                        <select id="marcas" class="form-control selectpicker" data-live-search="true" data-size="5">
                                                        <!-- AQUI CARGARE MARCAS -->
                                              <option value="0">Elija primero un item</option>
                                        </select>
                                     </div>
                                   </div>
                                     
                                 <div class="col-md-2">
                                        <div class="form-group">
                                          <label>Tipo Item</label>
                                            <input class="form-control" type="text" id="tipo" placeholder="tipo de item"  readonly/>
                                        </div>
                                    </div>
                                    <!-- <div class="col-md-2">
                                        <div class="form-group">
                                          <label>Marca</label>
                                            <input class="form-control" type="text" id="marca" placeholder="Marca"  readonly/>
                                        </div>
                                    </div> -->
                                    <div class="col-md-2">
                                        <div class="form-group">
                                          <label>Stock Cantidad</label>
                                            <input class="form-control" type="text" id="stock" placeholder="stock"  readonly/>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Cantidad</label>
                                            <input class="form-control" type="number" id="cantidad" placeholder="cantidad" />
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Tipo Ajuste</label>
                                             <select class="form-control selectpicker"  data-size="10" data-live-search="true" id="tipoajuste">
                                                <option value="POSITIVO">POSITIVO</option>
                                             <option value="NEGATIVO">NEGATIVO</option>
                                              </select>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Motivo Ajuste</label>
                                               <select class="form-control selectpicker"  data-size="10" data-live-search="true" id="motivo">
                                                <option value="0">Elija una Opcion</option>
                                                  <?php
                                                  $var = pg_query("select * from motivo_ajustes order by mot_cod;");
                                                 while ($i = pg_fetch_assoc($var)){
                                                        echo "<option value='".$i["mot_cod"]."'>".$i["mot_cod"]." - ".$i["mot_desc"]."</option>";
                                                    }
                                                    ?>
                                              </select>
                                        </div>
                                    </div><br>
                                   

                                    <input type="hidden" id="detalle" value="">
                                    <input type="hidden" id="usuario" value="<?php echo $_SESSION["id"]; ?>">
                                    <input type="hidden" id="funcionario" value="<?php echo $_SESSION["fun_cod"]; ?>">
                                    <input type="hidden" id="empresa" value="<?php echo $_SESSION["emp_cod"]; ?>">
                                    <input type="hidden" id="sucursal" value="<?php echo $_SESSION["suc_cod"]; ?>"><br>
                                    
                                <div class="col-md-2">
                                        <div class="form-group">
                                       <br>
                                       <input type="button" class="btn btn-round btn-dark btn-block agregar" id="agregar" value="AGREGAR"/>
                                </div>
                                </div>
                                    <div class="col-md-12">
                                    <div class="table-responsive table-bordered">
                                        <table class="table table-responsive" id="grilladetalle">
                                        <thead>
                                            <tr>
                                            <td class="span1"><h5>Codigo</h5></td>
                                            <td class="span5"><h5>Item</h5></td>
                                            <td class="span5"><h5>Marca</h5></td>
                                            <td class="span2"><h5>Motivo</h5></td>
                                            <td class="hidden-phone-portrait span2"><h5>Cantidad</h5>
                                              <!-- <td class="span1"><h4><strong>Cod. Dep</h4></strong></td> -->
                                              <!--   <td class="span2"><h4><strong>Deposito</strong></h4></td> -->
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                        <tfoot>
                                            
                                        </tfoot>
                                    </table>
                                </div><br>
                                </div><br>
                                <div class="span20">
                                    
                                        <input type="submit" class="btn btn-round btn-dark btn-block span20 grabar" id="grabar" value="GUARDAR"/>
                                    </div>

                        </div>
                      </div>
                    </div>
                </div> 

                <div class="col-md-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Lista de Ajustes</h2>
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
                                <table class="table" id="ajustes">
                                    <thead>
                                        <tr><th width="%"></th>
                                            <th width="%">Cod</th>
                                            <th width="%">Fecha</th>
                                            <th width="%">Empresa</th>
                                            <th width="%">Sucursal</th>
                                            <th width="%">Tipo Ajuste</th>
                                            <th width="%">Estado</th>
                                            <th width="8%">Acciones</th>
                                            
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

<script src="../js/ajustes.js"></script>
 

<script src="../js/jquery.dataTables.js"></script>
<script src="../js/fnReloadAjax.js"></script>
<script src="../js/dataTables.bootstrap.js"></script>

<script src="../js/humane.js"></script>
<script src="../js/bootstrap-select.js"></script>
       <script src="../js/chosenselect.js"></script>
    <script src="../gentelella-master/vendors/bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="../gentelella-master/build/js/custom.min.js"></script>
    
    
  </body>
</html>
