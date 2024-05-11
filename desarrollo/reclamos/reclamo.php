<?php 

require "../clases/funciones.php";
require "../clases/sesion.php";
require "../clases/conexion.php";
verifico();
$con = new conexion();
$con ->conectar();
$nro = pg_query("select coalesce(max(reclamo_cod))+1 as nro from reclamo_clientes");
$nros = pg_fetch_assoc($nro);

date_default_timezone_set('America/Asuncion');
$fecha = date('d/m/Y H:i:s')

?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RECLAMOS / SUGERENCIAS</title>
    <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../gentelella-master/venadors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="../gentelella-master/vendors/nprogress/nprogress.css" rel="stylesheet">
    <link href="../gentelella-master/build/css/custom.min.css" rel="stylesheet">
    <link href="../css/dataTables.responsive.css" rel="stylesheet">
    <link href="../css/flatty.css" rel="stylesheet">
    <link href="../font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
 <link rel="stylesheet" href="../css/bootstrap-select.css">
    <style>
            body{
                background: url(../imagenes/fon1.jpg) no-repeat center center fixed;
                background-size: cover;
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
               <h3 class="page-header" style="color:#000000" > <font  face="arial,verdana">RECLAMOS / SUGERENCIAS</h3>
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
                    <h2>AGREGAR NUEVO </h2> 
                    <div class="clearfix"></div>
                  </div>
                      <div class="form-group">
                                    <!-- <div class="col-md-1">
                                        <div class="form-group">
                                            <label>Nro.</label>
                                            <input class="form-control" type="text"  id="nro" value="<?php echo $nros["nro"]; ?>" disabled/>
                                        </div>
                                    </div> -->

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Fecha</label>                                            
                                                <input class="form-control" type="text"  value="<?php echo $fecha; ?>" disabled/>                                 
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
                                            
                                             <input class="form-control" type="text" class="form-control" value="<?php echo $_SESSION["suc_nom"];?>" disabled>
                                               
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Funcionario</label>                                            
                                                <input  class="form-control" type="text" value="<?php echo $_SESSION["fun_nom"] ?>" disabled/>
                                        </div>
                                    </div>



                                  <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Seleccionar Sucursal</label>
                                                <select class="form-control selectpicker" data-live-search="true" id="suc">
                                            
                                                    <option value="">Seleccione Sucursal</option>
                                                    <?php
                                                    $cli = pg_query("select * from v_sucursales order by 1;");
                                                    while ($c = pg_fetch_assoc($cli)){
                                                        echo "<option value='".$c["suc_cod"]."'>".$c["suc_nom"]." </option>";
                                                                                                
                                                    }
                                                    ?>
                                                </select>
                                        </div>
                                    </div>

                                   


                                    <!-- <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Seleccionar Funcionario</label>
                                                <select class="form-control selectpicker" data-live-search="true" id="funcionario">
                                            
                                                    <option value="">Seleccione funcionario</option>
                                                    <?php
                                                    $cli = pg_query("select * from v_funcionarios order by 1;");
                                                    while ($c = pg_fetch_assoc($cli)){
                                                        echo "<option value='".$c["fun_cod"]."'>".$c["fun_nom"]." </option>";
                                                                                                
                                                    }
                                                    ?>
                                                </select>
                                        </div>
                                    </div> -->
                                  
                                     <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Fecha de Observacion</label>
                                            <input class="form-control" type="date" id="fechareclamo" value="" />
                                        </div>
                                    </div>

                                   <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Seleccionar Cliente</label>
                                                <select class="form-control selectpicker" data-live-search="true" id="cli" placeholder="cliente">
                                            
                                                    <option value="">Seleccione Cliente</option>
                                                    <?php
                                                    $cli = pg_query("select * from v_clientes order by 1;");
                                                    while ($c = pg_fetch_assoc($cli)){
                                                        echo "<option value='".$c["cli_cod"]."'>".$c["cli_cod"]." - ".$c["cli_nom"]."  ".$c["cli_ape"]."</option>";
                                                                                                
                                                    }
                                                    ?>
                                                </select>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Especificar tipo</label>
                                                <select class="form-control selectpicker" data-live-search="true" id="rec_sug">
                                            
                                                    <option value="0">Seleccione Tipo </option>
                                                    <?php
                                                    $cli = pg_query("select * from tipo_reclamos order by 1;");
                                                    while ($c = pg_fetch_assoc($cli)){
                                                        echo "<option value='".$c["tipo_reclamo_cod"]."'>".$c["tipo_reclamo_cod"]." - ".$c["tipo_reclamo_desc"]." </option>";
                                                                                                
                                                    }
                                                    ?>
                                                </select>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Seleccionar item de reclamos</label>
                                                <select class="form-control selectpicker" data-live-search="true" id="tipo" placeholder="tipo">
                                            
                                                    <option value="0">Seleccione Tipo </option>
                                                    <?php
                                                    $cli = pg_query("select * from tipo_reclamo_items order by 1;");
                                                    while ($c = pg_fetch_assoc($cli)){
                                                        echo "<option value='".$c["tipo_recl_item_cod"]."'>".$c["tipo_recl_item_cod"]." - ".$c["tipo_recl_item_desc"]." </option>";
                                                                                                
                                                    }
                                                    ?>
                                                </select>
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Descripción</label>
                                            
                                                    <textarea class="form-control" type="text"  id="reclamo"/></textarea>
                                               
                                        </div>
                                    </div>
                                    <!--<input type="hidden" id="reclamo" value="">-->
                               <input type="hidden" id="funcionario" value="<?php echo $_SESSION["fun_cod"]; ?>">
                               <input type="hidden" id="usuario" value="<?php echo $_SESSION["id"]; ?>">
                               <input type="hidden" id="empresa" value="<?php echo $_SESSION["emp_cod"]; ?>"> 
                               <input type="hidden" id="sucursal" value="<?php echo $_SESSION["suc_cod"]; ?>"> 
                                     <div class="col-md-2">
                                        <div class="form-group">
                                            <label></label>
                                            <div class="controls">
                                                <button type="submit" class="btn btn-round btn-dark btn-block" id="btnsave">Guardar</button>
                                            </div>
                                        </div>
                                    </div>

                      </div>
                    </div>
                </div>




                
              <div class="col-md-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Lista de Reclamos / Sugerencias de Clientes</h2>
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
                    <table class="table table-striped projects"  id="reclamos">
                      <thead>
                        <tr>
                            <th></th>
                            <th>Cod</th>
                            <th>Fecha</th>
                            <th>Fecha Reclamo</th>
                            <th>Cliente</th>
                            <th>Descripcion</th>
                            <th>Recl / Sug</th>
                            <th>Sucursal</th>
                            <th>Usuario</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                    </tr>
                      </thead>
                    </table>
                  </div>
                </div>
              </div>

              
                            <div class="modal" id="modal_basic" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h2 class="modal-title" id="myModalLabel"><strong>Editar</strong></h2>
            </div>
            <div class="modal-body">
                <div class="row">
                   


                <input type="hidden" value="" id="cod_edit">
                <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Seleccionar Sucursal</label>
                                                <select class="form-control selectpicker" data-live-search="true" id="suc_edit">
                                            
                                                    <option value="">Seleccione Sucursal</option>
                                                    <?php
                                                    $cli = pg_query("select * from v_sucursales order by 1;");
                                                    while ($c = pg_fetch_assoc($cli)){
                                                        echo "<option value='".$c["suc_cod"]."'>".$c["suc_nom"]." </option>";
                                                                                                
                                                    }
                                                    ?>
                                                </select>
                                        </div>
                                    </div>
                                  
                                     <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Fecha de Observacion</label>
                                            <input class="form-control" type="date" id="fechareclamo_edit" value="" />
                                        </div>
                                    </div>

                                   <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Seleccionar Cliente</label>
                                                <select class="form-control selectpicker" data-live-search="true" id="cli_edit" placeholder="cliente">
                                            
                                                    <option value="">Seleccione Cliente</option>
                                                    <?php
                                                    $cli = pg_query("select * from v_clientes order by 1;");
                                                    while ($c = pg_fetch_assoc($cli)){
                                                        echo "<option value='".$c["cli_cod"]."'>".$c["cli_cod"]." - ".$c["cli_nom"]."  ".$c["cli_ape"]."</option>";
                                                                                                
                                                    }
                                                    ?>
                                                </select>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Especificar tipo</label>
                                                <select class="form-control selectpicker" data-live-search="true" id="rec_sug_edit">
                                            
                                                    <option value="">Seleccione Tipo </option>
                                                    <?php
                                                    $cli = pg_query("select * from tipo_reclamos order by 1;");
                                                    while ($c = pg_fetch_assoc($cli)){
                                                        echo "<option value='".$c["tipo_reclamo_cod"]."'>".$c["tipo_reclamo_cod"]." - ".$c["tipo_reclamo_desc"]." </option>";
                                                                                                
                                                    }
                                                    ?>
                                                </select>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Seleccionar item de reclamos</label>
                                                <select class="form-control selectpicker" data-live-search="true" id="tipo_edit" placeholder="tipo">
                                            
                                                    <option value="">Seleccione Tipo </option>
                                                    <?php
                                                    $cli = pg_query("select * from tipo_reclamo_items order by 1;");
                                                    while ($c = pg_fetch_assoc($cli)){
                                                        echo "<option value='".$c["tipo_recl_item_cod"]."'>".$c["tipo_recl_item_cod"]." - ".$c["tipo_recl_item_desc"]." </option>";
                                                                                                
                                                    }
                                                    ?>
                                                </select>
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Descripción</label>
                                            
                                                    <textarea class="form-control" type="text"  id="reclamo_edit"/></textarea>
                                               
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
                    <button type="button" class="btn btn-primary" value="" id="okactive">Si</button>
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
                                                <button type="button" class="btn btn-primary" value="" id="delete">Si</button>
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
    <script src="../js/reclamo.js"></script>
    <script src="../js/jquery.dataTables.js"></script>
    <script src="../js/fnReloadAjax.js"></script>
    <script src="../js/dataTables.bootstrap.js"></script>
    <script src="../js/humane.js"></script>
    <script src="../js/bootstrap-select.js"></script>
    <script src="../gentelella-master/vendors/bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="../gentelella-master/build/js/custom.min.js"></script>
  </body>
</html>