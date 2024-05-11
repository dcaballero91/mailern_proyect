
<?php 
require "../clases/sesion.php";
verifico();
require "../clases/conexion.php";

date_default_timezone_set('America/Asuncion');
$fecha = date('d/m/Y H:i:s')
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ITEMS</title>
    <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/bootstrap-select.css">
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
               <h3 class="page-header" style="color:#0a0a0a" ><font size="40"  face="arial,verdana"><h3 >ITEMS</font></h3>
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
                    <h3>Agregar Nuevo Item</h3>  
                    <div class="clearfix"></div>
                  </div>
                      <div class="form-group">
                                     <div class="col-md-3">
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

                                            <input  class="form-control" type="text" value="<?php echo $_SESSION["fun_nom"]?>" disabled/>

                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Seleccionar Tipo Items</label>            
                                                    <select class="form-control selectpicker"  data-size="5" data-live-search="true" id="tipoitem"/>
                                                <option value="0">Elija el tipo de item a registrar</option>
                                                  <?php
                                                  $var = pg_query("select * from tipo_items order by tipo_item_cod;");
                                                  while ($i = pg_fetch_assoc($var)) {
                                                    echo "<option value='" . $i["tipo_item_cod"] ."'>".$i["tipo_item_desc"] . "</option>";
                                                        }
                                                  ?>
                                              </select>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Item</label>   
                                          <input class="form-control" type="text" placeholder="Descripcion"  id="descri"/> 
                                        </div>
                                    </div>
                                     
                                     <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Precio Venta</label>
                                            <input class="form-control"  type="number" id="venta" pattern="[0-9]{3}" placeholder="0Gs."disabled/>
                                        </div>
                                    </div>
                                   
                                          <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Seleccionar Tipo Impuesto</label>
                                                    <select class="form-control selectpicker"  data-size="10" data-live-search="true" id="imp">
                                                    <?php
                                                            $con = new conexion();
                                                            $con->conectar();
                                                            $imp = pg_query("select * from tipo_impuestos order by 1");
                                                            while($i = pg_fetch_assoc($imp)){
                                                                echo "<option value='".$i["tipo_imp_cod"]."'>".$i["tipo_imp_desc"]."</option>";
                                                            }
                                                    ?>
                                                    </select>
                                                </div>
                                            </div>

                                      <div class="col-md-2">
                                            <div class="form-group">
                                                <br>
                                              <input type="button" class=" btn btn-round btn-dark btn-block guardar "  id="btnsave" value="GUARDAR" /> 
                                            </div>
                                        </div>
                                        <input type="hidden" id="detalle" value="">
                                            <input type="hidden" id="usuario" value="<?php echo $_SESSION["id"]; ?>">
                                            <input type="hidden" id="funcionario" value="<?php echo $_SESSION["fun_cod"]; ?>">
                                            <input type="hidden" id="empresa" value="<?php echo $_SESSION["emp_cod"]; ?>">
                                            <input type="hidden" id="sucursal" value="<?php echo $_SESSION["suc_cod"]; ?>">

                      </div>
                    </div>
                </div>




                
              <div class="col-md-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2><strong>Lista de Items</strong></h2>
                    <div class="pull-right">
                                <div class="btn-group">
                                    <a href="../informes/imp_items.php" target="_blank"  class="btn btn-primary btn-sm fa fa-print" >
                                        <strong>Imprimir</strong>
                                    </a>
                                    
                                </div>
                            </div>
                            <!-- <div class="pull-right">
                                <div class="btn-group">
                                    <a href="https://api.whatsapp.com/send?phone=595982694734&text=SU PROXIMA VISITA ES EL 24/11/2018, TIPO DE SERVICIO: COLORACION, HORARIO:16:30, SUCURSAL: JOSEPH CENTRAL, FAVOR  CONFIRMAR SU RESERVA LOS ESPERAMOS.. " target="_blank" class="btn btn-primary btn-sm fa fa-print" >
                                        <strong>Enviar</strong>
                                    </a>
                                    
                                </div>
                            </div> -->
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
                    <table class="table table-striped projects"  id="item">
                      <thead>
                         <tr>
                            <th width="8%">Cod</th>
                            <th>Items</th>
                            <th>Precio</th>
                            <th>Tipo Item</th>
                            <th>Tipo Impuesto</th>
                            <th >Estado</th>
                            <th width="15%">Acciones</th>
                        </tr>
                      </thead>
                    </table>
                  </div>
                </div>
              </div>

              
          <div class="modal fade bs-example-modal"  id="confirmacion" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h2 class="modal-title" id="myModalLabel"><strong>Editar</strong></h2>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>Items</label>
                           <input class="form-control" type="text" id="descri_edit">
                            <input class="form-control" type="hidden" id="codigo_edit" />
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Precio Venta</label>
                                        <input class="form-control" type="text" id="venta_edit" placeholder="0Gs."/>
                                    </div>
                                </div>
                                
                                
                    
                    <div class="col-md-6">
                            <div class="form-group">
                                <label>Seleccionar Tipo Impuesto</label>
                                <select class="form-control selectpicker" data-size="10" data-live-search="true" id="imp_edit">
                                   <?php
                                        $con = new conexion();
                                        $con->conectar();
                                        $imp = pg_query("select * from tipo_impuestos order by 1");
                                        while($i = pg_fetch_assoc($imp)){
                                            echo "<option value='".$i["tipo_imp_cod"]."'>".$i["tipo_imp_desc"]."</option>";
                                        }
                                   ?>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Tipo Items</label>
                                <select class="form-control selectpicker" data-size="10" data-live-search="true" id="tipoitem_edit">
                                   <?php
                                        $con = new conexion();
                                        $con->conectar();
                                        $tipo = pg_query("select * from tipo_items order by 1");
                                        while($i= pg_fetch_assoc($tipo)){
                                            // echo "<option value='".$i['tipo_item_cod']."'>.$i["tipo_item_desc"]."</option>";
                                            echo "<option value='".$i["tipo_item_cod"]."'>".$i["tipo_item_desc"]."</option>";
                                        }
                                   ?>
                                </select>
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
    <div class="modal" id="desactivacion" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            <label class="msg"></label>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-5 col-md-offset-4">
                    <input type="hidden" id="cod_eliminar" name="">
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

        
                </div>
            </div>
        </div>
    </div>
     </div>
    </div>
    <script src="../js/jquery.js"></script>
    <script src="../js/items.js"></script>
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
