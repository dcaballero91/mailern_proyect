<?php
require "../clases/funciones.php";
require "../clases/sesion.php";
require "../clases/conexion.php";
verifico();
$con = new conexion();
$con->conectar();

//$nros = pg_fetch_assoc($nro);
$fecha = date("d/m/Y H:h:m");
?>
<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <title>Reservas</title>
        <link href="../css/bootstrap.css" rel="stylesheet">
        <link href="../css/metisMenu.css" rel="stylesheet">
        <link href="../css/sb-admin-2.css" rel="stylesheet">
        <link href="../css/dataTables.bootstrap.css" rel="stylesheet">
        <link href="../css/dataTables.responsive.css" rel="stylesheet">
        <link href="../css/bootstrap-select.css" rel="stylesheet">
        <link href="../css/flatty.css" rel="stylesheet">
        <link href="../font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    </head>
    <body background ="claro.jpg">
        <div id="wrapper">
            <?php require '../controles/menu_cabecera.php' ?>
            <div id="page-wrapper">
                <div id="mensaje"></div>
                <div class="row">
                    <div class="col-xs-30-md-30">
                        <h1 class="page-header" style="color:#08C" ><font size="40"  face="Cooper Black,arial,verdana"><h1 align="center" ><strong>RESERVAS DE TURNOS</strong></font></h1>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="panel panel-info">
                            <div class="panel-heading">
                                <strong>  Agregar Nueva Reserva</strong>
                            </div>

                            <div class="panel-body "><!-- CREA UNA PAGINA BLANCA PARA AGREGAR UN CONTENIDO DENTRO OSEA UN RECUADRO CON CONTENIDO-->
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label>Fecha</label>
                                        <input class="form-control" class="span12" type="text" id="fecha" value="<?php echo $fecha; ?>" disabled/>
                                    </div>
                                </div>   

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Empresa</label>
                                        <div class="controls">
                                            <input class="form-control" type="text"  class="span12"  value="<?php echo $_SESSION["emp_nom"]; ?>" disabled/>
                                        </div>

                                    </div>
                                </div>

                                 <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Sucursal</label>
                                            <div class="controls">
                                                <div class="controls">
                                                <input class="form-control" type="text"  class="span12" value="<?php echo $_SESSION["suc_nom"]; ?>" disabled/>
                                            </div> 
                                            </div>
                                        </div>
                                    </div>
                        

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Funcionario</label>
                                        <div class="controls">
                                            <input  class="form-control" type="text" class="span12" value="<?php echo $_SESSION["fun_nom"] . " " . $_SESSION["fun_ape"]; ?>" disabled/>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label>Fecha a Reservar</label>
                                        <input class="form-control" class="span12" type="date" id="freserva"  />
                                    </div>
                                </div>P

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Cliente</label>
                                        <select class="form-control selectpicker" data-live-search="true" id="cliente" placeholder="cliente">

                                            <option value="">Seleccione Cliente</option>
                                            <?php
                                            $cli = pg_query("select * from v_clientes order by 1;");
                                            while ($c = pg_fetch_assoc($cli)) {
                                                echo "<option value='" . $c["cli_cod"] . "'>" . $c["cli_cod"] . " - " . $c["cli_nom"] . "  " . $c["cli_ape"] . "</option>";
                                            }
                                            ?>
                                        </select>
                                    </div>
                                </div>
                            
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Seleccionar Especialidad</label>
                                    <div class="form-group">

                                        <select class="form-control selectpicker" id="especialidad" required="required" data-placeholder="Select especialidad" class="select-block-level chzn-select" tabindex="-1">
                                            <option value="">seleccione especialidad</option>
                                            <?php
                                            $esp = pg_query("select * from v_especialidades order by esp_cod;");
                                            while ($i = pg_fetch_assoc($esp)) {
                                                echo "<option value='" . $i["esp_cod"] . "'>" . $i["esp_cod"] . " - " . $i["esp_desc"] . "</option>";
                                            }
                                            ?>
                                        </select>
                                    </div>
                                </div>
                            </div>

                             <div class="col-md-3">
                                <div class="form-group">
                                    <label>Seleccionar Tipo de Servicio</label>
                                    <div class="form-group">

                                        <select class="form-control selectpicker" id="tservicio" required="required" data-placeholder="Select especialidad" class="select-block-level chzn-select" tabindex="-1">
                                            <option value="">seleccione servicio</option>
                                            <?php
                                            $tipo = pg_query("select * from v_tipo_servicios order by tipo_serv_cod;");
                                            while ($i = pg_fetch_assoc($tipo)) {
                                                echo "<option value='" . $i["tipo_serv_cod"] . "'>" . $i["tipo_serv_cod"] . " - " . $i["tipo_serv_desc"] . "</option>";
                                            }
                                            ?>
                                        </select>
                                    </div>
                                </div>
                            </div>

                                 <div class="col-md-2">
                                    <div class="form-group">
                                        <label>Precio</label>
                                        
                                        <input class="form-control" type="text" class="span12" id="precio" placeholder="0 Gs." disabled/>
                                    </div>
                                </div>

                        <div class="col-md-2">
                            <div class="form-group">
                                <label>Hora desde</label>
                                <input class="form-control" class="span12" type="time" id="hdesde"  />
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label>Hora hasta</label>
                                <input class="form-control" class="span12" type="time" id="hhasta"  />
                            </div>
                        </div>
                         <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Sugerencias</label>
                                           
                                            <textarea class="form-control" type="text" id="sugerencias"></textarea>
                                        </div>
                                </div>

                        <div class="span20">
                            <br>
                            <input type="button" class="btn btn-info btn-block span20 agregar" id="agregar" value="AGREGAR"/>
                        </div>

                    </div>
                    <div class="panel-heading">
                        <div class="row-fluid" style="display: none;" id="detalle-grilla">
                            <table style="color: #0075b0;" id="grilladetalle" class="table table-striped span10">

                                <thead>
                                                      <tr>
                                                        <td class="span1"><h4><strong>Codigo</h4></strong></td>
                                                        <td class="span2"><h4><strong>Tipo Servicio</strong></h4></td> 
                                                         <td class="span2"><h4><strong>Hora Desde</strong></h4></td>
                                                        <td class="span2"><h4><strong>Hora Hasta</strong></h4></td>
                                                        <td class="span2"><h4><strong>Sugerencias</strong></h4></td>
                                                        <td class="hidden-phone-portrait span2"><h4><strong>Precio</h4></strong></td>
                                                        <td class="span2"><h4><strong>Subtotal</strong></h4></td>
                                                        <td></td>
                                                       </tr>
                                </thead>
                                                    <tbody>

                                                    </tbody>
                            </table>
                        </div>
                                                    </div>   
                                                    </div>
                                                    </div>
                                                    </div>
                                 <input type="hidden" id="detalle" value="">
                                <input type="hidden" id="usuario" value="<?php echo $_SESSION["id"];?>">
                                <input type="hidden" id="funcionario" value="<?php echo $_SESSION["fun_cod"];?>">
                                <input type="hidden" id="empresa" value="<?php echo $_SESSION["emp_cod"];?>">
                                <input type="hidden" id="sucursal" value="<?php echo $_SESSION["suc_cod"];?>">

                                                    </div>
                                                    <div id="page-wrapper"><!--TOMA EL TAMAÑO DE LA PAAGINA SIN TOCAR A LOS DEMAS MENUS del costado!!!!  -->
                                                        <!--    <div class="row">--> 
                                                        <div class="col-lg-25"><!-- CREAR  UN TAMAÑO DE RECUADRO SIN AFECTAR EL TEXTO O BOTON INTRODUCIDO DENTRO DE EL -->
                                                            <div class=" panel-info"><!--CREA UN RECUADRO PARA INTROCUCIR BOTONES O TEXTOS   -->


                                                                <input type="button" class="btn btn-primary btn-block span8" id="grabar" value="Grabar"/>
                                                            </div>      
                                                            <br>
                                                            <div class="panel panel-info"><!--CREA UN RECUADRO DE COLOR CELESTE PARA EL TITULO-->
                                                                <div class="panel-heading"><!--CREA UN RECUADRO PARA EL TITULO-->
                                                                    <strong> Lista de Reservas de Turno</strong>
                                                                </div><br>
                                                                <div class="container"> <!-- CONTENEDOR  -->
                                                                    <div class="row">
                                                                        <table  class="table"  style="color: #000;" id="reservas" >
                                                                            <thead>
                                                                                <tr>
                                                        <th></th>
                                                        <th width="%">Cod</th>
                                                        <th width="%">Fecha Reserva</th>
                                                        <th width="%">Empresa</th>
                                                       <th width="%">Sucursal</th>
                                                        <th width="%">Funcionario</th>
                                                        <th width="%">Especialidad</th>
                                                        <th width="%">Cliente</th>
                                                        <th width="%">Estado</th>
                                                        <th width="8%">Acciones</th>     
                                                    </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                            </tbody>
                                                                        </table>
                                                                        <br>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    </div>


                                                    <!--FIN PAGINA CONTENIDO -->


                                                    <!--Funcion  Desactivar -->
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



                                                    <!--Fin del body -->

                                                    <script src="../js/jquery.js"></script>

                                                    <script src="../js/reservas.js"></script>
                                                    <script src="../js/bootstrap.js"></script>
                                                    <script src="../js/metisMenu.js"></script>
                                                    <script src="../js/jquery.dataTables.js"></script>
                                                    <script src="../js/fnReloadAjax.js"></script>
                                                    <script src="../js/dataTables.bootstrap.js"></script>
                                                    <script src="../js/sb-admin-2.js"></script>
                                                    <script src="../js/humane.js"></script>
                                                    <script src="../js/bootstrap-select.js"></script>
                                                    <script src="../js/humane.js"></script>


                                                    </body>
                                                    </html>