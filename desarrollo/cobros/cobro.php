<?php
require "../clases/sesion.php";
verifico();
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
date_default_timezone_set('America/Asuncion');
$fecha = date("d/m/Y H:i:s");
$ultcobro = pg_query(" SELECT coalesce(max(cobro_cod), 0)+ 1 as nro FROM cobros_cab ");
$nros = pg_fetch_assoc($ultcobro);
$sqltim = pg_query('SELECT timb_nro, timb_cod FROM v_aperturas_cierres WHERE tim_vighasta >= current_date AND usu_cod = '.$_SESSION['id']);
$resultim = pg_fetch_assoc($sqltim);
if (!$resultim) {
    header('location:../timbrados/timbrado.php');
}

          //select * from v_aperturas_cierres where usu_cod =1 and aper_cier_fecha is null order by 1;
$sqlaper = pg_query("SELECT * FROM v_aperturas_cierres WHERE usu_cod = " . $_SESSION['id'] . " AND fecha_cierreformato IS NULL");
$resultaper = pg_fetch_assoc($sqlaper);
if ($resultaper) {
    $_SESSION['idapertura'] = $resultaper['aper_cier_cod'];
} else {
    $_SESSION['idapertura'] = null;
    header('location:../aperturas_cierres/apertura_cierre.php');
}
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>COBROS</title>
        <link href="../gentelella-master/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="../gentelella-master/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">    
        <link href="../gentelella-master/build/css/custom.min.css" rel="stylesheet">    
        <link href="../css/flatty.css" rel="stylesheet"> 
        <!-- <link rel="stylesheet" type="text/css" href="../css/chosenselect.css" media="screen"> -->
        <link rel="stylesheet" href="../css/bootstrap-select.css">
        <!--<link rel="stylesheet" href="place.css">-->

        <!--<link rel="stylesheet" type="text/css" href="../../css/chosenselect.css" media="screen">-->
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
                                <h1 class="page-header" style="color: #0e0e0e;" > <font  face=" Century Gothic"> Cobros </h1>
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
                            <div class="col-md-12 ">
                                <div class="x_panel">
                                    <div class="x_title">
                                        <h2>AGREGAR NUEVO</h2>    
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="form-group">
                                        <!--<div class="col-sm-16 col-xs-16">-->  
                                         <div class="col-md-12 ">
                                           
                                            <div class="col-md-2">
                                                <div class="form-group">
                                                    <label>Cobro N.°</label>
                                                    <input class="form-control" type="text" id="cobroNro" value="<?php echo $nros["nro"]; ?>" disabled/>
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <div class="form-group">
                                                    <label>Fecha</label>
                                                    <input class="form-control" type="text" id="fecha" value="<?php echo $fecha; ?>" disabled/>
                                                </div>
                                            </div>

                                            <div class="col-md-2">
                                                <div class="form-group">
                                                    <label>Empresa</label>

                                                    <input class="form-control" type="text"  value="<?php echo $_SESSION["emp_nom"]; ?>" disabled/>


                                                </div>
                                            </div>

                                            <div class="col-md-2">
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
                                            <div class="col-md-1">
                                                <div class="form-group">
                                                    <label>A.C Nro.</label>
                                                    <input class="form-control" type="text" id="apercier" value="<?php echo $resultaper['aper_cier_cod'];?>" disabled />
                                                </div>
                                            </div>
                                           
                                            <div class="col-md-2">
                                                <div class="form-group">
                                                    <label>Timbrado</label>
                                                    <input type="text" class="form-control"  value="<?php echo $resultim['timb_nro']; ?>"disabled />
                                                </div>
                                            </div>

                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Nro. Factura</label>
                                                    <input type="text" class="form-control"  id="nrofact" value="<?php echo $resultaper['siguiente_factura']; ?>"disabled />
                                                </div>
                                            </div>
                                            
                                             <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Seleccionar Cliente</label>
                                                    <select class="form-control selectpicker"  data-size="7" data-live-search="true" id="cliente">
                                                        <option value="0">Seleccione el cliente</option>
                                                        <?php
                                                        $var = pg_query("select * from v_clientes order by cli_cod;");
                                                        while ($i = pg_fetch_assoc($var)) {
                                                            echo "<option value='" . $i["cli_cod"] . "'>" . $i["cli_cod"] . " - " . $i["cli_nom"] .' - ' .$i["cli_ruc"] ."</option>";
                                                        }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>
                                             <div class="col-md-2">
                                                <div class="form-group">
                                                    <label>Venta a cobrar</label>
                                                    <select class="form-control selectpicker"  data-size="7" data-live-search="true" id="venta">
                                                        <option value="0">Elija una opción</option>
                                                        <!-- aqui iran las ventas pendientes -->
                                                    </select>
                                                </div>
                                            </div>
                                           
                                            <div class="col-md-2">
                                                <div class="form-group">
                                                    <label for="deuda">Deuda Total / Saldo Deuda</label>
                                                    <input type="text" class="form-control" required id="deuda" disabled>
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <div class="form-group">
                                                    <label for="cuotaspagadas">Cuotas Pagadas</label>
                                                    <input type="text" class="form-control" required id="cuotaspagadas" disabled>
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <div class="form-group">
                                                    <label for="cuotas">Cuotas a pagar</label>
                                                    <input type="number" min="1" class="form-control" value="0" required id="cuotas">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label for="plazo">Monto</label>
                                                    <input type="monto" class="form-control" value="0" id="monto">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label for="tipofact">Seleccionar forma cobros</label>
                                                    <select class="form-control selectpicker" id="tipoCobro" data-live-search="true" data-size="4">
                                                        <?php
                                                        $var = pg_query("select * from formas_cobros order by 1");
                                                        while ($i = pg_fetch_assoc($var)) {
                                                            echo "<option value='" . $i["fcob_cod"] . "'>" . $i["fcob_cod"] . " - " . $i["fcob_desc"] ."</option>";
                                                        }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>  
                                        <!-- </div> -->

                                            <input type="hidden" id="detalleTarjetas" value="{}">
                                            <input type="hidden" id="detalleCheques" value="{}">
                                            <input type="hidden" id="operacion" value="1">
                                            <input type="hidden" id="ventanro" value="">
                                            <input type="hidden" id="usuario" value="<?php echo $_SESSION["id"]; ?>">
                                            <input type="hidden" id="funcionario" value="<?php echo $_SESSION["fun_cod"]; ?>">
                                            <input type="hidden" id="empresa" value="<?php echo $_SESSION["emp_cod"]; ?>">
                                            <input type="hidden" id="sucursal" value="<?php echo $_SESSION["suc_cod"]; ?>">
                                            <!-- <input type="hidden" id="timbrado" value="<?php# echo $resultim['timb_cod']; ?>"> -->
                                            <input type="hidden" id="codigo" value="0"> <!-- Se calcula en el sp -->

                                            <div class="col-md-2">
                                                <div class="form-group">
                                                    <br>
                                                <input type="button" class=" btn btn-round btn-dark btn-block" data-toggle="modal" data-target="#efectivo" data-placement="top" value="CONFIRMAR" id="confirmar" disabled/> 
                                         
                                                </div>
                                            </div>
                                            <!-- <div class="col-md-2">
                                                <div class="form-group">
                                                    <br>
                                                    <input type="button" onclick="location.reload();"  class="  btn btn-round btn-dark btn-block cancelar" id="cancelar" value="REFRESCAR"/>
                                                </div>
                                            </div> -->
                                        </div>
                                        <!-- Aqui estaba la grilla de  detalle de ventas -->
                                        <div class="span20">
                                            <br>
                                            <input type="submit" class="btn btn-round btn-dark btn-block span20 grabar" id="grabar" value="GUARDAR"/>
                                        </div>

                                  
                                </div>
                            </div>
                        </div> 

                        <div class="col-md-12">
                            <div class="x_panel">
                                <div class="x_title">
                                    <h2>Lista de Ventas</h2>
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
                                        <table class="table" id="tabla">
                                            <thead>
                                                <tr>
                                                    <th width="4%"></th>
                                                    <th width="5%">Venta N.°</th>
                                                    <th width="8%">Fecha venta</th>
                                                    <th width="8%">Cliente</th>
                                                    <th width="8%">RUC</th>
                                                    <th width="8%">Tipo Factura</th>
                                                    <th width="8%">Estado</th>
                                                    <th width="8%">Usuario</th>
                                                    <th width="12%" >Acciones</th>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal" id="efectivo" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <!-- <label class="msg"></label> -->
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <h3 class="modal-title" id="title"><strong>COBROS - EFECTIVO</strong></h3>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>MONTO EFECTIVO</label>
                                                    <input class="form-control" type="number" id="montoEfectivo" placeholder="0 Gs.">
                                                </div>
                                            </div>
                                            <div class="col-md-4" style="margin-left: 130px;">
                                                <div class="form-group">
                                                    <label>SALDO DE LA DEUDA</label>
                                                    <input class="form-control" type="number" id="efectivoSaldoDeuda" placeholder="0 Gs." disabled>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-5 col-md-offset-4">
                                                <button type="button" class="btn btn-primary" id="cobroEfectivo" data-dismiss="modal">Guardar</button>
                                                <button type="button" class="btn btn-primary" id="hide" data-dismiss="modal">Cancelar</button>
                                                <input type="hidden" id="cod_eliminar" value="">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div> 
                        <!-- COBRO TARJETAS SOLO-->
                        <div class="modal" id="tarjetas" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                            <div class="modal-dialog-lg" style="max-width: 1000px; margin: auto;">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <!-- <label class="msg"></label> -->
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <h3 class="modal-title" id="title"><strong>COBROS - TARJETAS</strong></h3>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-md-3" style="margin-left: 230px;">
                                                <div class="form-group">
                                                    <label>Saldo de la Deuda</label>
                                                    <input class="form-control" type="integer" id="DeudaPagarTarjetasSolo" placeholder="0 Gs." disabled>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Total</label>
                                                    <input class="form-control" type="integer" id="MontoPagarTarjetasSolo" placeholder="0 Gs." disabled>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Marca Tarjeta</label>
                                                    <select class="form-control selectpicker" id="tarjetaMarjSolo" data-live-search="true" data-size="4">
                                                        <option value="0">Elije una opción</option>
                                                        <?php
                                                            $var = pg_query(" SELECT * FROM marca_tarjetas ORDER BY 1");
                                                            while($i = pg_fetch_assoc($var)){
                                                                echo "<option value='" . $i["mar_tarj_cod"] . "'>" . $i["mar_tarj_cod"] . " - " . $i["mar_tarj_desc"] ."</option>";
                                                            }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Número de Tarjeta</label>
                                                    <input class="form-control" type="integer" id="tarjetaNumSolo" placeholder="Numero tarjeta">
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Cód. Autorización</label>
                                                    <input class="form-control" type="integer" id="tarjetaCodAutSolo" placeholder="Codigo Autorizacion">
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Entidad Emisora</label>
                                                    <select class="form-control selectpicker" id="tarjetaEntEmiSolo" data-live-search="true" data-size="4">
                                                        <option value="0">Elije una opción</option>
                                                        <?php
                                                            $var = pg_query(" SELECT * FROM entidades_emisoras ORDER BY 1");
                                                            while($i = pg_fetch_assoc($var)){
                                                                echo "<option value='" . $i["ent_cod"] . "'>" . $i["ent_cod"] . " - " . $i["ent_nom"] ."</option>";
                                                            }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Entidad Adherida</label>
                                                    <select class="form-control selectpicker" id="tarjetaEntAdhSolo" data-live-search="true" data-size="4">
                                                        <option value="0">Elije una opción</option>
                                                        <?php
                                                            $var = pg_query(" SELECT * FROM entidades_adheridas ORDER BY 1");
                                                            while($i = pg_fetch_assoc($var)){
                                                                echo "<option value='" . $i["ent_ad_cod"] . "'>" . $i["ent_ad_cod"] . " - " . $i["ent_ad_nom"] ."</option>";
                                                            }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Monto Tarjeta</label>
                                                    <input class="form-control" type="integer" id="tarjetaMonTarjSolo" placeholder="Monto Tarjeta">
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                            
                                                <div class="form-group">
                                                    <input type="button" class=" btn btn-round btn-dark agregarCobroTarjetasSolo btn-block"value="Agregar" id="agregarcobrotarjetasSolo" />
                                                </div>
                                            </div> 
                                        </div>
                                        <div class="col-md-12">
                                            <div class="table-responsive table-bordered">
                                                <table class="table table-responsive" id="grilladetalletarjetasSolo"> 
                                                    <thead>
                                                        <tr>
                                                            <th style="text-align: center;">Codigo</th>
                                                            <th style="text-align: center;">Marca Tarjeta</th>                                                
                                                            <th style="text-align: center;">Numero Tarjeta</th>                                                
                                                            <th style="text-align: center;">Codigo Autorizacion</th>
                                                            <th style="text-align: center;">Entidad Emisora</th>
                                                            <th style="text-align: right;">Entidad Adherida</th>
                                                            <th style="text-align: right;">Monto tarjeta</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                    </tbody>
                                                    <tfoot>
                                                        <tr>
                                                            <th colspan="7" class="text-right" id="totalTarjetasSolo">SUBTOTAL TARJETAS: 0 Gs.</th>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-5 col-md-offset-4">
                                                <button type="button" class="btn btn-primary" id="cobroTarjetasSolo" data-dismiss="modal">Guardar</button>
                                                <button type="button" class="btn btn-primary" id="hide" data-dismiss="modal">Cancelar</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- COBRO TARJETAS SOLO FIN -->
                        <!-- COBRO CHEQUES SOLO -->
                        <div class="modal" id="cheques" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                            <div class="modal-dialog'lg" style="max-width: 1000px; margin: auto;">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <!-- <label class="msg"></label> -->
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <h3 class="modal-title" id="title"><strong>COBROS - CHEQUES</strong></h3>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-md-4" style="margin-left: 230px;">
                                                <div class="form-group">
                                                    <label>Saldo de la Deuda</label>
                                                    <input class="form-control" type="integer" id="montoDeudaChequesSolo" placeholder="0 Gs." disabled>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Total</label>
                                                    <input class="form-control" type="integer" id="MontoPagarChequesSolo" placeholder="0 Gs." disabled>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Número de Cuenta</label>
                                                    <input class="form-control" type="integer" id="numeroCuentaChequeSolo" placeholder="Número de Cuenta">
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Serie</label>
                                                    <input class="form-control" type="integer" id="serieChequeSolo" placeholder="Serie">
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Número de Cheque</label>
                                                    <input class="form-control" type="integer" id="numeroChequeSolo" placeholder="Número de Cheque">
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Cheque Monto</label>
                                                    <input class="form-control" type="integer" id="montoChequeSolo" placeholder="Cheque Monto">
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Cheque Fecha Emision</label>
                                                    <input class="form-control" type="date" id="emisionChequeSolo" placeholder="Cheque Monto">
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Librador</label>
                                                    <input class="form-control" type="integer" id="libradorChequeSolo" placeholder="Librador">
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Bancos</label>
                                                    <select class="form-control selectpicker" id="bancoChequeSolo" data-live-search="true" data-size="4">
                                                        <option value="0">Elije una opcion</option>
                                                        <?php
                                                            $var = pg_query(" SELECT * FROM entidades_emisoras ORDER BY 1");
                                                            while($i = pg_fetch_assoc($var)){
                                                                echo "<option value='" . $i["ent_cod"] . "'>" . $i["ent_cod"] . " - " . $i["ent_nom"] ."</option>";
                                                            }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Tipos de Cheques</label>
                                                    <select class="form-control selectpicker" id="tipoChequeSolo" data-live-search="true" data-size="4">
                                                        <option value="0">Elije una opcion</option>
                                                        <?php
                                                            $var = pg_query(" SELECT * FROM tipo_cheques ORDER BY 1");
                                                            while($i = pg_fetch_assoc($var)){
                                                                echo "<option value='" . $i["cheque_tipo_cod"] . "'>" . $i["cheque_tipo_cod"] . " - " . $i["cheque_tipo_desc"] ."</option>";
                                                            }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-2"><br>
                                                <div class="form-group">
                                                    <input type="button" class=" btn btn-round btn-dark agregarCobroChequesSolo btn-block"value="Agregar" id="agregarcobrochequessolo" />
                                                </div>
                                            </div>  
                                        </div>
                                        <div class="col-md-12">
                                            <div class="table-responsive table-bordered">
                                                <table class="table table-responsive" id="grilladetallechequesSolo">
                                                    <thead>
                                                        <tr>
                                                            <th style="text-align: center;">Codigo</th>
                                                            <th style="text-align: center;">Número de Cuenta</th>                                                
                                                            <th style="text-align: center;">Serie</th>                                                
                                                            <th style="text-align: center;">Número de Cheque</th>
                                                            <th style="text-align: center;">Cheque Monto</th>
                                                            <th style="text-align: center;">Cheque Emision</th>
                                                            <th style="text-align: right;">Librador Cheque</th>
                                                            <th style="text-align: right;">Bancos</th>
                                                            <th style="text-align: right;">Tipo Cheques</th>
                                                            <th style="text-align: right;"></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                    </tbody>
                                                    <tfoot>
                                                        <tr>
                                                            <th colspan="9" class="text-right" id="totalChequesSolo">SUBTOTAL CHEQUE: 0 Gs.</th>
                                                        </tr>

                                                    </tfoot>
                                                </table>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-5 col-md-offset-4">
                                                <button type="button" class="btn btn-primary" id="cobroChequesSolo" data-dismiss="modal">Guardar</button>
                                                <button type="button" class="btn btn-primary" id="hide" data-dismiss="modal">Cancelar</button>
                                                <input type="hidden" id="cod_eliminar" value="">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- COBRO CHEQUES SOLO FIN -->
                        <!-- COBRO TODO -->
                        <div class="modal" id="todos" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                            <div class="modal-dialog-lg" style="max-width: 1000px; margin: auto;">
                                <div class="modal-content">
                                    <!-- cobro todo efeectivo -->
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <h4 class="modal-title" id="title"><strong>COBROS - EFECTIVO</strong></h4>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>MONTO EFECTIVO</label>
                                                    <input class="form-control" type="integer" id="todoMontoEfectivo" placeholder="0 Gs.">
                                                </div>
                                            </div>
                                            <div class="col-md-3" style="margin-left: 230px;">
                                                <div class="form-group">
                                                    <label>Saldo de la Deuda</label>
                                                    <input class="form-control" type="integer" id="todoMontoPagar" placeholder="0 Gs." disabled>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Total</label>
                                                    <input class="form-control" type="integer" id="todoTotal" placeholder="0 Gs." disabled>
                                                </div>
                                            </div>
                                            <!-- <div class="col-md-2"><br>
                                                <div class="form-group">
                                                    <input type="button" class=" btn btn-round btn-dark btn-block"value="Agregar" id="agregarcobro" />
                                                </div>
                                            </div>                -->
                                        </div>
                                    </div>
                                    <!-- cobro todo efeectivo fin -->
                                    <!-- cobro todo tarjetas -->
                                    <div class="modal-header">
                                        <h4 class="modal-title" id="title"><strong>COBROS - TARJETAS</strong></h4>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Marca Tarjeta</label>
                                                    <select class="form-control selectpicker" id="todoMarcaTarjeta" data-live-search="true" data-size="4">
                                                        <option value="0">Elije una opción</option>
                                                        <?php
                                                            $var = pg_query(" SELECT * FROM marca_tarjetas ORDER BY 1");
                                                            while($i = pg_fetch_assoc($var)){
                                                                echo "<option value='" . $i["mar_tarj_cod"] . "'>" . $i["mar_tarj_cod"] . " - " . $i["mar_tarj_desc"] ."</option>";
                                                            }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Número de Tarjeta</label>
                                                    <input class="form-control" type="number" id="todoNumeroTarjeta" placeholder="Numero tarjeta">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Cód. Autorización</label>
                                                    <input class="form-control" type="number" id="todoCodigoAutorizacion" placeholder="Codigo Autorizacion">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Entidad Emisora</label>
                                                    <select class="form-control selectpicker" id="todoEntidadEmisora" data-live-search="true" data-size="4">
                                                        <option value="0">Elije una opción</option>
                                                        <?php
                                                            $var = pg_query(" SELECT * FROM entidades_emisoras ORDER BY 1");
                                                            while($i = pg_fetch_assoc($var)){
                                                                echo "<option value='" . $i["ent_cod"] . "'>" . $i["ent_cod"] . " - " . $i["ent_nom"] ."</option>";
                                                            }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Entidad Adherida</label>
                                                    <select class="form-control selectpicker" id="todoEntidadAdherida" data-live-search="true" data-size="4">
                                                        <option value="0">Elije una opción</option>
                                                        <?php
                                                            $var = pg_query(" SELECT * FROM entidades_adheridas ORDER BY 1");
                                                            while($i = pg_fetch_assoc($var)){
                                                                echo "<option value='" . $i["ent_ad_cod"] . "'>" . $i["ent_ad_cod"] . " - " . $i["ent_ad_nom"] ."</option>";
                                                            }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Monto Tarjeta</label>
                                                    <input class="form-control" type="number" id="todoMontoTarjeta" placeholder="Monto Tarjeta">
                                                </div>
                                            </div>
                                            <div class="col-md-2"><br>
                                                <div class="form-group">
                                                    <input type="button" class=" btn btn-round btn-dark agregarCobroTarjetas btn-block"value="Agregar" id="agregarcobrotarjetas" />
                                                </div>
                                            </div>  
                                        </div>
                                        <div class="col-md-12">
                                            <div class="table-responsive table-bordered">
                                                <table class="table table-responsive" id="grilladetalletarjetas">
                                                    <thead>
                                                        <tr>
                                                            <th style="text-align: center;">Codigo</th>
                                                            <th style="text-align: center;">Marca Tarjeta</th>                                                
                                                            <th style="text-align: center;">Numero Tarjeta</th>                                                
                                                            <th style="text-align: center;">Codigo Autorizacion</th>
                                                            <th style="text-align: center;">Entidad Emisora</th>
                                                            <th style="text-align: right;">Entidad Adherida</th>
                                                            <th style="text-align: right;">Monto tarjeta</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                    </tbody>
                                                    <tfoot>
                                                        <tr>
                                                            <th colspan="7" class="text-right" id="totalTarjetas">SUBTOTAL TARJETAS: 0 Gs.</th>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- cobro todo tarjetas fin -->
                                    <!-- cobro todo cheques -->
                                    <div class="modal-header">
                                        <h4 class="modal-title" id="title"><strong>COBROS - CHEQUES</strong></h4>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Número de Cuenta</label>
                                                    <input class="form-control" type="number" id="todoNumeroCuenta" placeholder="Número de Cuenta">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Serie</label>
                                                    <input class="form-control" type="integer" id="todoSerie" placeholder="Serie">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Número de Cheque</label>
                                                    <input class="form-control" type="number" id="todoNumeroCheque" placeholder="Número de Cheque">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Cheque Monto</label>
                                                    <input class="form-control" type="number" id="todoChequeMonto" placeholder="Cheque Monto">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Cheque Fecha Emision</label>
                                                    <input class="form-control" type="date" id="todoChequeEmision" placeholder="Cheque Monto">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Librador</label>
                                                    <input class="form-control" type="text" id="todoLibrador" placeholder="Librador">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Bancos</label>
                                                    <select class="form-control selectpicker" id="todoBancos" data-live-search="true" data-size="4">
                                                        <option value="0">Elije una opcion</option>
                                                        <?php
                                                            $var = pg_query(" SELECT * FROM entidades_emisoras ORDER BY 1");
                                                            while($i = pg_fetch_assoc($var)){
                                                                echo "<option value='" . $i["ent_cod"] . "'>" . $i["ent_cod"] . " - " . $i["ent_nom"] ."</option>";
                                                            }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Tipos de Cheques</label>
                                                    <select class="form-control selectpicker" id="todoTipoCheques" data-live-search="true" data-size="4">
                                                        <option value="0">Elije una opcion</option>
                                                        <?php
                                                            $var = pg_query(" SELECT * FROM tipo_cheques ORDER BY 1");
                                                            while($i = pg_fetch_assoc($var)){
                                                                echo "<option value='" . $i["cheque_tipo_cod"] . "'>" . $i["cheque_tipo_cod"] . " - " . $i["cheque_tipo_desc"] ."</option>";
                                                            }
                                                        ?>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <div class="form-group">
                                                    <input type="button" class=" btn btn-round btn-dark btn-block agregarCobroCheques"value="Agregar" id="agregarCobroCheque" />
                                                </div>
                                            </div>  
                                        </div>
                                        <div class="col-md-12">
                                            <div class="table-responsive table-bordered">
                                                <table class="table table-responsive" id="grilladetallecheques">
                                                    <thead>
                                                        <tr>
                                                            <th style="text-align: center;">Codigo</th>
                                                            <th style="text-align: center;">Número de Cuenta</th>                                                
                                                            <th style="text-align: center;">Serie</th>                                                
                                                            <th style="text-align: center;">Número de Cheque</th>
                                                            <th style="text-align: center;">Cheque Monto</th>
                                                            <th style="text-align: center;">Cheque Emision</th>
                                                            <th style="text-align: right;">Librador Cheque</th>
                                                            <th style="text-align: right;">Bancos</th>
                                                            <th style="text-align: right;">Tipo Cheques</th>
                                                            <th style="text-align: right;"></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                    </tbody>
                                                    <tfoot>
                                                        <tr>
                                                            <th colspan="9" class="text-right" id="totalCheques">SUBTOTAL CHEQUE: 0 Gs.</th>
                                                        </tr>

                                                    </tfoot>
                                                </table>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-5 col-md-offset-4">
                                                <button type="button" class="btn btn-primary" id="cobroTodo" data-dismiss="modal">Guardar</button>
                                                <button type="button" class="btn btn-primary" id="hide" data-dismiss="modal">Cancelar</button>
                                                <input type="hidden" id="cod_eliminar" value="">
                                            </div>
                                        </div>
                                    </div>
                                    <!-- cobro todo cheques **-->
                                </div>
                            </div>
                        </div>
                        <!-- COBRO TODO FIN -->

                </div>
            </div>
        </div>
    </div>
</div>

<script src="../js/jquery.js"></script>

<script src="../js/cobros.js"></script> 
<script src="../js/cobrosTarjetas.js"></script> 
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
