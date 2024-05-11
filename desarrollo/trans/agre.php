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

<script language="javascript" type="text/javascript" src="jquery-1.3.2.min.js"></script>

<script language="javascript" type="text/javascript" src="extras/js/jquery/jquery-1.3.2.min.js"></script>
        <script language="javascript" type="text/javascript">
            $(document).ready(function(){
                $(".contenido").hide();
                $("#combito").change(function(){
                $(".contenido").hide();
                    $("#div_" + $(this).val()).show();
                });
            });
        </script>



<select id="combito">
            <option></option>
            <option value="1">conejos</option>
            <option value="2">gatos</option>
            <option value="3">patos</option>
        </select>
        


                            <div class="col-md-1" id="div_1" class="contenido" hidden="">
                                        <div class="form-group">
                                            <label>Codigo</label>
                                            <input class="form-control" type="text" id="cod"/>
                                        </div>
                            </div>



                            



        <div id="div_2" class="contenido" hidden="">
            <p>contenido para gatos</p>
        </div>
        <div id="div_3" class="contenido" hidden="">
            <p>contenido para patos</p>
        </div>