$(function(){
   
    
//ELIMINAR
$(document).on("click",".eliminar",function(){
        var pos = $( ".eliminar" ).index( this );
        $("#referencial tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var campo1;
            campo1 = $(this).html();
            $("#cod_eliminar").val(campo1);
        });
});
$(document).on("click",".elimi",function(){
    var cod = $( "#cod_eliminar" ).val();
    $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {descri1: '' ,ruc: '' ,descri2: '',descri3: '',descri4: '2000-12-31',descri5: '',descri6: '',descri7: '',descri8: 0,descri9: 0,descri10: 0,descri11: 0, tipopersona: 0, cargo_funcionario:0, ope: 'eliminacion', codigo: cod}
        }).done(function(msg){
        $('.cerrar').click();
        cargar();
        alert(msg);
    });
                        
});
//FIN ELIMINAR

//ACTIVAR
$(document).on("click",".activar",function(){
        var pos = $( ".activar" ).index( this );
        $("#referencial tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var campo1;
            campo1 = $(this).html();
            $("#cod_activar").val(campo1);
        });
});
$(document).on("click",".acti",function(){
    var cod = $( "#cod_activar" ).val();
    $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {descri1: '' ,ruc: '' ,descri2: '',descri3: '',descri4: '2000-12-31',descri5: '',descri6: '',descri7: '',descri8: 0,descri9: 0,descri10: 0,descri11: 0, tipopersona: 0, cargo_funcionario:0, ope: 'activacion', codigo: cod}
        }).done(function(msg){
        $('.cerrar').click();
        cargar();
        alert(msg);
    });
                        
});
//FIN activar


//EDITAR
    $(document).on("click",".editar",function(){
        //$("#btn_edit").attr("disabled","disabled");
        var pos = $( ".editar" ).index( this );
        $("#referencial tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var cod = $(this).html();
            $("#cod_edit").val(cod);
            $.ajax({
                type: 'POST',
                url: 'editar.php',
                async: false,
                data: {cod: cod}
            }).done(function(msg){
                var dame = eval("("+msg+")");
                $("#cod_edit").val(cod);
                $("#ruc_edit").val(dame.per_ruc);
                $("#descri1_edit").val(dame.per_ci);
                $("#descri2_edit").val(dame.per_nombre);
                $("#descri3_edit").val(dame.per_apellido);
                $("#descri4_edit").val(dame.fnac);
                $("#descri5_edit").val(dame.per_direccion);
                $("#descri6_edit").val(dame.per_telefono);
                $("#descri7_edit").val(dame.per_email);
                $('#descri8_edit > option[value="'+dame.cod_nac+'"]').attr('selected',true);
               //                 <option value=""></option>
            
            //$('#descri8_edit').selectpicker('refresh');
                                $('#descri9_edit > option[value="'+dame.ec_cod+'"]').attr('selected',true);
                //$('#descri9_edit').selectpicker('refresh');
                                $('#descri10_edit > option[value="'+dame.ciu_cod+'"]').attr('selected',true);
                //$('#descri10_edit').selectpicker('refresh');
                                $('#descri11_edit > option[value="'+dame.codigo_gen+'"]').attr('selected',true);
                //$('#descri11_edit').selectpicker('refresh');
                                $('#tipopersona_edit > option[value="'+dame.tipo_persona_cod+'"]').attr('selected',true);
                $('#tipopersona').selectpicker('refresh');


 //               $('#iva_edit > option[value="'+dame.impues_cod+'"]').attr('selected',true);
 //               $('#iva_edit').selectpicker('refresh');
            });
        });
    });

    $(document).on("click","#btn_edit",function(){
        var cod,descri1,descri2,descri3,descri4,descri5,descri6,descri7,descri8,descri9,descri10,descri11,tipopersona,cargo_funcionario,ruc;
        cod = $("#cod_edit").val();
        descri1 = $("#descri1_edit").val();
        ruc = $("#ruc_edit").val();
        descri2 = $("#descri2_edit").val();
        descri3 = $("#descri3_edit").val();
        descri4 = $("#descri4_edit").val();
        descri5 = $("#descri5_edit").val();
        descri6 = $("#descri6_edit").val();
        descri7 = $("#descri7_edit").val();
        descri8 = $("#descri8_edit").val();
        descri9 = $("#descri9_edit").val();
        descri10 = $("#descri10_edit").val();
        descri11 = $("#descri11_edit").val();
        tipopersona = $("#tipopersona_edit").val();
        cargo_funcionario = $("#cargo_funcionario_edit").val();
     //   $("#btn_edit").attr("disabled","disabled");
        $("#btn_edit").html("Editando...");
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:cod, descri1: descri1, ruc:ruc , descri2: descri2, descri3: descri3, descri4: descri4, descri5: descri5, descri6: descri6, descri7: descri7, descri8: descri8, descri9: descri9, descri10: descri10, descri11: descri11, tipopersona: tipopersona, cargo_funcionario:1, ope: 'modificacion' }
        }).done(function(msg){
            $('.cerrar').click();
            $("#btn_edit").html("Editar");
            cargar();
            alert(msg);
        });
    });

//    $("#compra_edit").keypress(function(e){
//        if(e.which === 13 && $("#compra_edit").val()!==""){
//            $("#btn_edit").focus();
//            $("#btn_edit").click();
 //       }else{

//        }
//    });
//    $('#venta_edit').keyup(function () {
//        if($("#venta_edit").val()===""){
 //           $("#btn_edit").attr("disabled","disabled");
 //       }else{
 //           $("#btn_edit").removeAttr("disabled");
  //      }
 //   });
//FIN EDITAR    
    
////TABLA
 var tabla =  $('#referencial').dataTable({ 
    "columns":
    [
                { "data": "codigo" },
                { "data": "descripcion1" },
		{ "data": "descripcion12" },
                { "data": "descripcion2" },
                { "data": "descripcion3" },
		{ "data": "descripcion4" },
		{ "data": "descripcion5" },
                { "data": "descripcion6" },
                { "data": "descripcion8" },
                { "data": "descripcion9" },
                { "data": "descripcion10" },
                { "data": "descripcion11" },
                { "data": "tipopersona" },
                { "data": "estado" },
                { "data": "acciones"}
    ]
 });
            tabla.fnReloadAjax( 'datos.php' );
    function cargar(){
                    tabla.fnReloadAjax();
    }
////FIN TABLA

//AGREGAR
function habilitarcargo(){
//var selectElement = document.getElementById('cargo_funcionario');
//selectElement.textContent = '';
//$("#cargo_funcionario").select()
//var form = theRoot.dataView()
//form.control('cargo_funcionario').tabindex = -1
//$('#cargo_funcionario option value="" >').attr('selected',true);
//$('<option cargo_funcionario="" value=""></option>');
//$("#cargo_funcionario").load('persona.php');

}

$("#cargo_funcionario").attr("disabled","disabled"); 
$(document).on("click","#tipopersona",function(){

        if($("#tipopersona").val()==="2" || $("#tipopersona").val()==="4" || $("#tipopersona").val()==="6" || $("#tipopersona").val()==="7"){
                $("#cargo_funcionario").removeAttr("disabled");
                
        }else{
            
        $("#cargo_funcionario").attr("disabled","disabled");
habilitarcargo();
//        $("#cargo_funcionario > option[value='']").attr('selected',true);
//        document.getElementById (cargo_funcionario) .options.length = 0;
    }
    });



$("#btnsave").attr("disabled","disabled");
     $('#descri1').keyup(function () {
        if($("#descri1").val()===""){
            $("#btnsave").attr("disabled","disabled");
        }else{
            $("#btnsave").removeAttr("disabled");
        }
    });
    cargar();
  
	
    $(document).on("click","#btnsave",function(){
           var descri1 = $("#descri1").val();
           var ruc = $("#ruc").val();
	   var descri2 = $("#descri2").val();
	   var descri3 = $("#descri3").val();
	   var descri4 = $("#descri4").val();
           var descri5 = $("#descri5").val();
           var descri6 = $("#descri6").val();
           var descri7 = $("#descri7").val();
           var descri8 = $("#descri8").val();
           var descri9 = $("#descri9").val();
           var descri10 = $("#descri10").val();
           var descri11 = $("#descri11").val();
           var tipopersona = $("#tipopersona").val();
           var cargo_funcionario = $("#cargo_funcionario").val();
       $("#btnsave").attr("disabled","disabled");
       $("#btnsave").html("AGREGANDO...");
       $.ajax({
             type: "POST",
             url: "grabar.php",
             data: {codigo:0, descri1: descri1, ruc:ruc , descri2: descri2, descri3: descri3, descri4: descri4, descri5: descri5, descri6: descri6, descri7: descri7, descri8: descri8, descri9: descri9, descri10: descri10, descri11: descri11, tipopersona: tipopersona, cargo_funcionario:cargo_funcionario, ope: 'insercion' }
            }).done(function(msg){
                alert(msg);
                cargar();
                $("#btnsave").html("AGREGAR.");
		$("#descri1").val('');
		$("#descri2").val('');
		$("#descri3").val('');
		$("#descri4").val('');
		$("#descri5").val('');
		$("#descri6").val('');
		$("#descri7").val('');
                $('#descri8 > option[value=""]').attr('selected',true);
                $('#descri9 > option[value=""]').attr('selected',true);
                $('#descri10 > option[value=""]').attr('selected',true);
                $('#descri11 > option[value=""]').attr('selected',true);
                $('#tipopersona > option[value=""]').attr('selected',true);

        });
    });
//FIN AGREGAR
});

                            