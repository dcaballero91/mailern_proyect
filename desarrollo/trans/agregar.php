<?php 
require "../clases/funciones.php";
require "../clases/sesion.php";
require "../clases/conexion.php";
verifico();
?>


<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->

<!-- Mirrored from seantheme.com/color-admin-v2.0/admin/material/form_plugins.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 19 Sep 2016 17:29:11 GMT  Theme White-->
<head>
    <meta charset="utf-8" />
    <title>Transferencia</title>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
    <meta content="" name="description" />
    <meta content="" name="author" />
    
    <!-- ================== BEGIN BASE CSS STYLE ================== -->
    <link href="https://fonts.googleapis.com/css?family=Roboto:100,100italic,300,300italic,400,400italic,500,500italic,700,700italic,900,900italic" rel="stylesheet" type="text/css" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="../material/assets/plugins/jquery-ui/themes/base/minified/jquery-ui.min.css" rel="stylesheet" />
    <link href="../material/assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="../material/assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
    <link href="../material/assets/css/animate.min.css" rel="stylesheet" />
    <link href="../material/assets/css/style.min.css" rel="stylesheet" />
    <link href="../material/assets/css/style-responsive.min.css" rel="stylesheet" />
    <link href="../material/assets/css/theme/default.css" rel="stylesheet" id="theme" />
    <!-- ================== END BASE CSS STYLE ================== -->
    <link rel="stylesheet" href="../dist/css/skins/_all-skins.min.css">
  <link href="../css/bootstrap.css" rel="stylesheet">
    <link href="../css/metisMenu.css" rel="stylesheet">
    
    <link href="../css/dataTables.responsive.css" rel="stylesheet">
    <link href="../css/flatty.css" rel="stylesheet">
    <link href="../font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <!-- ================== BEGIN PAGE LEVEL STYLE ================== -->
    <link href="../material/assets/plugins/bootstrap-datepicker/css/datepicker.css" rel="stylesheet" />
    <link href="../material/assets/plugins/bootstrap-datepicker/css/datepicker3.css" rel="stylesheet" />
    <link href="../material/assets/plugins/ionRangeSlider/css/ion.rangeSlider.css" rel="stylesheet" />
    <link href="../material/assets/plugins/ionRangeSlider/css/ion.rangeSlider.skinNice.css" rel="stylesheet" />
    <link href="../material/assets/plugins/bootstrap-colorpicker/css/bootstrap-colorpicker.min.css" rel="stylesheet" />
    <link href="../material/assets/plugins/bootstrap-timepicker/css/bootstrap-timepicker.min.css" rel="stylesheet" />
    <link href="../material/assets/plugins/password-indicator/css/password-indicator.css" rel="stylesheet" />
    <link href="../material/assets/plugins/bootstrap-combobox/css/bootstrap-combobox.css" rel="stylesheet" />
    <link href="../material/assets/plugins/bootstrap-select/bootstrap-select.min.css" rel="stylesheet" />
    <link href="../material/assets/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css" rel="stylesheet" />
    <link href="../material/assets/plugins/jquery-tag-it/css/jquery.tagit.css" rel="stylesheet" />
    <link href="../material/assets/plugins/bootstrap-daterangepicker/daterangepicker-bs3.css" rel="stylesheet" />
    <link href="../material/assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet" />
    <link href="../material/assets/plugins/bootstrap-eonasdan-datetimepicker/build/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />
    <!-- ================== END PAGE LEVEL STYLE ================== -->
    
    <!-- ================== BEGIN BASE JS ================== -->
    <script src="../material/assets/plugins/pace/pace.min.js"></script>
    <!-- ================== END BASE JS ================== -->
</head>
<body>
    <!-- begin #page-loader -->
    <div id="page-loader">
        <div class="material-loader">
            <svg class="circular" viewBox="25 25 50 50">
                <circle class="path" cx="50" cy="50" r="20" fill="none" stroke-width="2" stroke-miterlimit="10"/>
            </svg>
            <div class="message">Loading...</div>
        </div>
    </div>
    <!-- end #page-loader -->
    
    <!-- begin #page-container -->
    <div id="page-container" class="fade page-sidebar-fixed page-header-fixed page-with-wide-sidebar">
        <!-- begin #header -->
        
        <!-- end #header -->
        
        <!-- begin #sidebar -->
       
        <?php require '../controles/cabecera.php' ?>
        <div id="content" class="content">
            <!-- begin breadcrumb -->
            <ol class="breadcrumb pull-right">
                <li><a href="javascript:;">Inicio</a></li>
                <li><a href="javascript:;">Movimientos</a></li>
                <li class="active">Pedido</li>
            </ol>
           
            <h1 class="page-header">Transferencia<small></small></h1>

<script type="text/javascript">
        function toggle(elemento) {
          
               if(elemento.value=="1"){
                   document.getElementById("uno").style.display = "block";
                   document.getElementById("dos").style.display = "none";
                   document.getElementById("tres").style.display = "block";
               }else{
                   if(elemento.value=="0"){
                        document.getElementById("uno").style.display = "none";
                        document.getElementById("tres").style.display = "none";
                        document.getElementById("dos").style.display = "block";
                    }  
                }
            
        };
</script>

                        <div class="panel panel-inverse overflow-hidden">
                            <div class="panel-heading">
                            <h4 class="panel-title"><span class="label label-success pull-left m-r-10">Agregar Nuevo</span>
                                <h3 class="panel-title">
                                    <a class="accordion-toggle accordion-toggle-styled collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseThree">
                                        <i class="fa fa-plus-circle pull-right"></i> 
                                        Clic Para desplegar
                                    </a>
                                </h3>
                            </div>
                            <div id="collapseThree" class="panel-collapse collapse bg-blue-grey">
                                <div class="panel-body">
                                    
			<div class="col-md-1" id="codigo">
                                        <div class="form-group">
                                            <label>Codigo</label>
                                            <input class="form-control" type="text" id="cod" readonly=""/>
                                        </div>
                            </div>
                            <script src="ajax.js"></script>


                            
                            <div class="col-md-1" id="tipo_credito" style="display:none">
                                        <div class="form-group">
                                            <label>Código</label>
                                            <input class="form-control" type="text" id="cod" onchange="load(this.value)"/>
                                        </div>
                            </div>
                            <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Fecha</label>
                                        <input class="form-control" type="text" id="fecha" readonly="readonly" value="<?php echo date("d / m / Y"); ?>" />
                                        </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Empresa</label>
                                <select class="form-control selectpicker" data-size="10" data-live-search="true" id="emp">
                                        <?php
                                        $cn2 = new conexion();
                                        $cn2->conectar();
                                        $empre = pg_query('select * from empresa order by empre_cod');
                                        while($n=pg_fetch_array($empre)){
                                        echo '<option value="'.$n["empre_cod"].'">'.$n["empre_nombre"].'</option>';
                                                }
                                        ?>
                                </select>
                                </div>
                            </div>

                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Sucursal</label>
                                <select class="form-control selectpicker" data-size="10" data-live-search="true" id="suc">
                                        <?php
                                        $cn2 = new conexion();
                                        $cn2->conectar();
                                        $suc = pg_query('select * from sucursal order by sucur_nro');
                                        while($n=pg_fetch_array($suc)){
                                        echo '<option value="'.$n["sucur_nro"].'">'.$n["sucur_nombre"].'</option>';
                                                }
                                        ?>
                                </select>
                                </div>
                            </div>


                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Funcionario</label>
                                <select class="form-control selectpicker" data-size="10" data-live-search="true" id="fun">
                                        <?php
                                        $cn2 = new conexion();
                                        $cn2->conectar();
                                        $fun = pg_query('select * from v_funcio_per order by fun_cod');
                                        while($n=pg_fetch_array($fun)){
                                        echo '<option value="'.$n["fun_cod"].'">'.$n["fun_nom"].' '.$n["fun_ape"].'</option>';
                                                }
                                        ?>
                                </select>
                                </div>
                            </div>
                            
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Vehiculo</label>
                                <select class="form-control selectpicker" data-size="10" data-live-search="true" id="vehi">
                                        <?php
                                        $cn2 = new conexion();
                                        $cn2->conectar();
                                        $vehi = pg_query('select * from vehiculo order by vehi_cod');
                                        while($n=pg_fetch_array($vehi)){
                                        echo '<option value="'.$n["vehi_cod"].'">'.$n["vehi_chacis"].'</option>';
                                                }
                                        ?>
                                </select>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Deposito</label>
                                <select class="form-control selectpicker" data-size="10" data-live-search="true" id="depo">
                                        <?php
                                        $cn2 = new conexion();
                                        $cn2->conectar();
                                        $depo = pg_query('select * from deposito order by depo_cod');
                                        while($n=pg_fetch_array($depo)){
                                        echo '<option value="'.$n["depo_cod"].'">'.$n["depo_nom"].'</option>';
                                                }
                                        ?>
                                </select>
                                </div>
                            </div>
                            
                            

                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Origen</label>
                                <select class="form-control selectpicker" data-size="10" data-live-search="true" id="ori">
                                        <?php
                                        $cn2 = new conexion();
                                        $cn2->conectar();
                                        $ori = pg_query('select * from sucursal order by sucur_nro');
                                        while($n=pg_fetch_array($ori)){
                                        echo '<option value="'.$n["sucur_nro"].'">'.$n["sucur_nombre"].'</option>';
                                                }
                                        ?>
                                </select>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Destino</label>
                                <select class="form-control selectpicker" data-size="10" data-live-search="true" id="des">
                                        <?php
                                        $cn2 = new conexion();
                                        $cn2->conectar();
                                        $des = pg_query('select * from sucursal order by sucur_nro');
                                        while($n=pg_fetch_array($des)){
                                        echo '<option value="'.$n["sucur_nro"].'">'.$n["sucur_nombre"].'</option>';
                                                }
                                        ?>
                                </select>
                                </div>
                            </div>
                            <div class="col-md-2">
                                        <div class="form-group">
                                            <label>F. Envio</label>
                                            <input class="form-control" type="date" id="envi"/>
                                        </div>
                                </div>
                                <div class="col-md-2">
                                        <div class="form-group">
                                            <label>F. Entrega</label>
                                            <input class="form-control" type="date" id="entre"/>
                                        </div>
                                </div>

                           <div id="myDiv"></div>

                           
                           
                                <div class="col-md-2" id="tem">
                                        <div class="form-group">
                                            <label>Producto</label>

                                            <select class="form-control selectpicker" data-size="10" data-live-search="true" id="art">
                                                <option value="">Eliga una opción</option>
                                                <?php
                                                $item = pg_query('select * from item order by item_cod');
                                                while($n=pg_fetch_array($item)){
                                                    echo '<option value="'.$n["item_cod"].'">'.$n["item_des"].'</option>';
                                                }
                                                ?>
                                            </select>
                                        </div>
                                </div>
                            
                                <div class="col-md-1">
                                        <div class="form-group">
                                            <label>Cantidad</label>
                                            <input class="form-control" type="text" id="cantidad"/>
                                        </div>
                                </div>
                                 <div class="col-md-1" id="cancuotas" style="display:none">
                                        <div class="form-group">
                                            <label>C.Recibida</label>
                                            <input class="form-control" type="text" id="recib" value="0" />
                                        </div>
                                </div>

                                
                                <br><br><br><br><br>
                                <div class="col-md-1">
                                        <div class="form-group">
                                       
                                        <button type="button" class="btn btn-primary" id="cargar"> Cargar</button>
                                </div>
                                </div>


                                <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Tipo orden:</label>
                                        <select class="form-control selectpicker" data-size="10" data-live-search="true" id="en">

                                            
                                            <option value="0">Recepcion</option>
                                            <option value="1" selected="true">Envio</option>
                                            
                                        </select>
                                        </div>
                                        </div>

                                       


                                <div class="col-md-12">
                                    <div class="table-responsive table-bordered">
                                        <table class="table table-responsive" id="grilla">
                                        <thead>
                                            <tr>
                                                <th>Código</th>
                                                <th>Producto</th>
                                                <th>Cantidad</th>
                                                <th>Cant. Recibida</th>
                                               
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                       
                                    </table>
                                </div>
                                </div>
                                <div class="col-md-12">
                                        <div class="form-group">
                                    <button type="submit" class="btn btn-primary pull-right" id="guardar"><span class="fa fa-save"></span> Guardar</button>
                                        </div>
                                </div>


                                </div>
                            </div>
                        </div>



                        <div id="page-wrapper">
                <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Lista de Transferencia
                        </div>
                        <div class="panel-body">
                            <div class="dataTable_wrapper">
                                <table class="table" id="lista">
                                    <thead>
                                        <tr>
                                            <th></th>
                                            <th>Código</th>
                                            <th>Funcionario</th>
                                            <th>Fecha</th>
                                            
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                        <div class="modal" id="modal_basic" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-md-5 col-md-offset-4">
                                            <button type="button" class="btn btn-primary" id="anular">Si</button>
                                            <button type="button" class="btn btn-danger" id="cerrar" data-dismiss="modal">Cancelar</button>
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
        <a href="javascript:;" class="btn btn-icon btn-circle btn-success btn-scroll-to-top fade" data-click="scroll-top"><i class="fa fa-angle-up"></i></a>
        <!-- end scroll to top btn -->
    </div>
    <!-- end page container -->
    
    <!-- ================== BEGIN BASE JS ================== -->
    <script src="../material/assets/plugins/jquery/jquery-1.9.1.min.js"></script>
    <script src="../material/assets/plugins/jquery/jquery-migrate-1.1.0.min.js"></script>
    <script src="../material/assets/plugins/jquery-ui/ui/minified/jquery-ui.min.js"></script>
    <script src="../material/assets/plugins/bootstrap/js/bootstrap.min.js"></script>
    <!--[if lt IE 9]>
        <script src="assets/crossbrowserjs/html5shiv.js"></script>
        <script src="assets/crossbrowserjs/respond.min.js"></script>
        <script src="assets/crossbrowserjs/excanvas.min.js"></script>
    <![endif]-->
    <script src="../material/assets/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <script src="../material/assets/plugins/jquery-cookie/jquery.cookie.js"></script>
    <!-- ================== END BASE JS ================== -->
    
    <script src="tran.js"></script>

    <script src="../js/metisMenu.js"></script>
    <script src="../js/jquery.dataTables.js"></script>
    <script src="../js/fnReloadAjax.js"></script>
    <script src="../js/dataTables.bootstrap.js"></script>
    <script src="../js/sb-admin-2.js"></script>
    <script src="../js/bootstrap-select.js"></script>
    <script src='../js/jquery.numeric.js'></script>
    <script src='../js/humane.js'></script>
    <!-- ================== BEGIN PAGE LEVEL JS ================== -->
    <script src="../material/assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
    <script src="../material/assets/plugins/ionRangeSlider/js/ion-rangeSlider/ion.rangeSlider.min.js"></script>
    <script src="../material/assets/plugins/bootstrap-colorpicker/js/bootstrap-colorpicker.min.js"></script>
    <script src="../material/assets/plugins/masked-input/masked-input.min.js"></script>
    <script src="../material/assets/plugins/bootstrap-timepicker/js/bootstrap-timepicker.min.js"></script>
    <script src="../material/assets/plugins/password-indicator/js/password-indicator.js"></script>
    <script src="../material/assets/plugins/bootstrap-combobox/js/bootstrap-combobox.js"></script>
    <script src="../material/assets/plugins/bootstrap-select/bootstrap-select.min.js"></script>
    <script src="../material/assets/plugins/bootstrap-tagsinput/bootstrap-tagsinput.min.js"></script>
    <script src="../material/assets/plugins/bootstrap-tagsinput/bootstrap-tagsinput-typeahead.js"></script>
    <script src="../material/assets/plugins/jquery-tag-it/js/tag-it.min.js"></script>
    <script src="../material/assets/plugins/bootstrap-daterangepicker/moment.js"></script>
    <script src="../material/assets/plugins/bootstrap-daterangepicker/daterangepicker.js"></script>
    <script src="../material/assets/plugins/select2/dist/js/select2.min.js"></script>
    <script src="../material/assets/plugins/bootstrap-eonasdan-datetimepicker/build/js/bootstrap-datetimepicker.min.js"></script>
    <script src="../material/assets/js/form-plugins.demo.min.js"></script>
    <script src="../material/assets/js/apps.min.js"></script>
    <!-- ================== END PAGE LEVEL JS ================== -->
    
    <script>
        $(document).ready(function() {
            App.init();
            FormPlugins.init();
        });
    </script>
<script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','../../../../www.google-analytics.com/analytics.js','ga');

      ga('create', 'UA-53034621-1', 'auto');
      ga('send', 'pageview');

    </script>
</body>

<!-- Mirrored from seantheme.com/color-admin-v2.0/admin/material/form_plugins.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 19 Sep 2016 17:29:43 GMT -->
</html>


      <!-- 
    <fieldset class="fields2">
    <dl>
        <dt><label>Cual opcion:</label></dt>
        <dd>
            <input type="radio" name="tipo_attach" onclick="toggle(this)" value="a"> Opcion a<br>
            <input type="radio" name="tipo_attach" onclick="toggle(this)" value="b" > Opcion b<br>
            <input type="radio" name="tipo_attach" onclick="toggle(this)" value="c"> Opcion c
        </dd>
    </dl>
</fieldset>
 
<div id="uno" style="display:none">
<p>Hola, soy el div Uno</p>
</div>
 
<div id="dos" style="display:none">
<p>Hola, soy el div dos</p>
</div>-->