<?php 
require "../clases/sesion.php";
verifico();
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$nro = pg_query("select coalesce(max(nota_rem_cod),0)+1 as nro from notas_remisiones_cab;");
$nros = pg_fetch_assoc($nro);
date_default_timezone_set('America/Asuncion');
$fecha = date("d/m/Y H:i:s");
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>NOTAS DE REMISIONES</title>
        <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="../gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
        <link href="../gentelella-master/build/css/custom.min.css" rel="stylesheet">    
        <link href="../css/flatty.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="../css/chosenselect.css" media="screen">
        <link rel="stylesheet" type="text/css" href="../css/chosenselect.css" media="screen">
        <link rel="stylesheet" href="../css/bootstrap-select.css">
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
                <h1 class="page-header" style="color: #0e0e0e;" > <font  face=" Century Gothic">NOTA DE REMISIONES </h1> 
                    <div class="clearfix"></div>
              </div>
              <div class="title_right">
                <div class="col-md-2 col-sm-2 col-xs-10 pull-right">
                  <div class="input-group">
                  <a href="../repor_reserva/rep_receva.php">
                    <input type="button" class="btn btn-dark" value="Reporte"/></a>
                    
                  </div>
                </div>
              </div>
            </div>

            <div class="row">
               <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>AGREGAR NUEVA NOTA DE REMISIÓN</h2>  
                    <div class="clearfix"></div>
                  </div>
                      <div class="form-group">
                        <div class="col-sm-12">
                            <div class="col-md-1" id="codigo">
                                <div class="form-group">
                                    <label>Codigo</label>
                                    <input class="form-control" type="text" value="<?php echo $nros["nro"]; ?>" id="cod" disabled/>
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
                                            <input class="form-control" type="text"  value="<?php echo $_SESSION["suc_nom"]; ?>" disabled/>
                                        </div>
                                    </div> 
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Funcionario</label>
                                            <input class="form-control" type="text"  value="<?php echo $_SESSION["fun_nom"] ?>" disabled/>
                                        </div>
                                    </div>
    
                                    <div class="col-md-3" id="tem">
                                        <div class="form-group">
                                            <label>Seleccionar Ventas</label>
                                            <select class="form-control selectpicker" data-size="5" data-live-search="true" id="ventas">
                                                <option value="0">Elija una opcion</option>
                                                <?php
                                                    $var = pg_query("SELECT * FROM v_ventas_cab ;");
                                                    while ($i = pg_fetch_assoc($var)) {
                                                        echo "<option value='" . $i["ven_cod"] . "'>" . $i["ven_cod"] . " - " . $i["cli_nom"] . "</option>";
                                                    }
                                                ?>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Seleccionar Vehículo</label>
                                              <select class="form-control selectpicker"data-size="5" data-live-search="true" id="vehiculos">
                                                <option value="0">Elija una Opción</option>
                                                <?php
                                                    $var = pg_query("select * from v_vehiculos order by vehi_cod;");
                                                    while ($i = pg_fetch_assoc($var)) {
                                                        if($i['vehi_cod'] == 1){
                                                            echo "<option value='1'>".$i['veh_mar_desc']."</option>";
                                                        }else{
                                                            echo "<option value='" . $i["vehi_cod"] . "'>" . $i["veh_mar_desc"] . " " . $i["veh_mod_desc"] ." -  "."C.nro: ".$i["veh_chapa"]. "</option>";
                                                        } 
                                                    }
                                                ?>
                                              </select>
                                        </div>
                                    </div> 

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Seleccionar Chofer</label>
                                              <select class="form-control selectpicker"data-size="5" data-live-search="true" id="choferes">
                                                <option value="0">Elija una Opción</option>
                                                <?php
                                                    $var = pg_query("SELECT * FROM v_choferes ORDER BY chofer_cod;");
                                                    while ($i = pg_fetch_assoc($var)) {
                                                        echo "<option value='" . $i["chofer_cod"] . "'>" . $i["chofer_cod"] . " - " . $i["chofer_nom"] . "</option>";
                                                    }
                                                ?>
                                              </select>
                                        </div>
                                    </div> 

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Seleccionar Tipo Remision</label>
                                                <select class="form-control selectpicker"data-size="5" data-live-search="true" id="tipoNota">
                                                    <option value="INTERNO">INTERNO</option>
                                                    <option value="EXTERNO">EXTERNO</option>
                                                </select>
                                        </div>
                                    </div> 

                                     <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Timbrado</label>
                                            <input class="form-control" type="number" id="timbrado" placeholder="Numero del Timbrado" disabled/>
                                        </div>
                                    </div>
                            
                                   <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Timbrado Vigencia Hasta</label>
                                            <input class="form-control" type="date" id="timbVigHasta" disabled/>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Numero Factura</label>
                                            <input class="form-control" type="text" id="nroFactura" placeholder="000-000-0000000" disabled/>
                                        </div>
                                    </div>

                                     <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Monto Factura</label>
                                            <input class="form-control" type="text" id="montoFactura" placeholder="Monto Factura" disabled />
                                        </div>
                                    </div>

                                    <input type="hidden" id="detalle" value="">
                                    <input type="hidden" id="usuario" value="<?php echo $_SESSION["id"]; ?>">
                                    <input type="hidden" id="funcionario" value="<?php echo $_SESSION["fun_cod"]; ?>">
                                    <input type="hidden" id="empresa" value="<?php echo $_SESSION["emp_cod"]; ?>">
                                    <input type="hidden" id="sucursal" value="<?php echo $_SESSION["suc_cod"]; ?>">
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <br>
                                            <input type="button" class="btn btn-round btn-dark btn-block agregar" id="cargar" value="AGREGAR"/>
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                    <div class="table-responsive table-bordered">
                                        <table class="table table-responsive" id="grilla">
                                        <thead>
                                            <tr>
                                                <th>Código</th>
                                                <th>Producto</th>
                                                <th>Marca</th>
                                                <th>Cantidad</th>
                                                <th>Precio</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <th colspan="5" class="text-right" id="total">Total: 0.00 Gs.</th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <button type="submit" class="btn btn-round btn-dark btn-block" id="guardar"><span class="fa fa-save"></span> GRABAR</button>
                                        <input type="hidden" id="ope" value="1">
                                    </div>
                                </div>
                        </div>
                      </div>
                    </div>
                </div> 

                <div class="col-md-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Lista de Tranferencias</h2>
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
                                <table class="table" id="transferencia">
                                    <thead>
                                        <tr>
                                            <th></th>
                                            <th>Código</th>
                                            <th>Empresa</th>
                                            <th>Fecha</th>
                                            <th>Funcionario</th>
                                            <th>Sucursal</th>
                                            <th>Vehiculo</th>
                                            <th>Estado</th>
                                            <th width="10%">Acciones</th>
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
    <script src="../js/nota_remision.js"></script>
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
