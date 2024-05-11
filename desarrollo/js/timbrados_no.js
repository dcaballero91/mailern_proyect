$(function(){
 var tabla =  $('#lista').dataTable({
    responsive: true,
    "columns":
    [
        { "data": "codigo" },
        { "data": "nro" },
        { "data": "fedesde" },
        { "data": "fehasta" },
       { "data": "estado" },
        { "data": "acciones"}
    ]
 });

   tabla.fnReloadAjax( 'datos.php' );

    function refrescarDatos(){
      tabla.fnReloadAjax();
    }
////FIN TABLA

//AGREGAR

    $(document).on("click","#guardar",function(){
     var nro = $("#nro").val();
     var fedesde = $("#fedesde").val();
     var fehasta = $("#fehasta").val();
   
    // var humane = $(); //****////****
    if(nro!=="",fedesde!=="",fehasta !==""){
     
       $.ajax({
             url: "grabar.php",
             type: "POST",
            
             data: {codigo:'0', nro: nro, fehasta: fehasta,fedesde:fedesde, ope: 'insercion' }
            }).done(function(msg){ 
               // alert(msg);
               humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
               
                $("#nro").val('');
                $("#fedesde").val('');
                $("#fehasta").val('');
              
               refrescarDatos();
                });
      }else{
         humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
      }
     
    });
//FIN AGREGAR

//ELIMINAR
$(document).on("click",".confirmar",function(){
        var pos = $(".confirmar").index(this);
        var cod;
        
       $("#lista tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
          cod = $(this).html(); 
       });
        $("#borrar").val(cod);
        $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea eliminar el Registro Nro. '+cod+' ?</h4>');
    });

                        //Button= id="borrar" -->( Si ) linea 194 empresas.php
 $(document).on("click","#borrar",function(){
      var codigo = $("#borrar").val();
      //var humane = $(); //****////****
        $.ajax({
           type: 'POST',
           url: 'grabar.php',
           data: {codigo: codigo, empresa: '', ruc: '', direccion: '', telefono: '', email: '', ope: 'eliminacion'}
        }).done(function(msg){
            $("#cerrar2").click();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            refrescarDatos();
            }); 
  });


//FIN ELIMINAR

//EDITAR
$(document).on("click",".editar",function(){    //.editar es del datos.php
 //   alert("llama?");
   // $("#btn_edit").attr("disabled","disabled");
var pos = $( ".editar" ).index( this );

   $("#empresas tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
var cod = $(this).html();
        $("#cod_edit").val(cod);
    }); 
    $("#empresas tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
var empresa, ruc;
      empresa = $(this).html();
        $("#empresa_edit").val(empresa);
        $("#empresa_edit").focus();
        $('#empresa_edit').keyup(function () {
            if($("#empresa_edit").val()==="" || $("#empresa_edit").val()===empresa || $('#ruc_edit').val()===ruc || $('#ruc_edit').val()==="") {
                $("#btn_edit").attr("disabled","disabled");
            }else{
                $("#btn_edit").removeAttr("disabled");
            }
        });
         $('#ruc_edit').keyup(function () {
            if($('#ruc_edit').val()===ruc || $('#ruc_edit').val()==="") {
                $("#btn_edit").attr("disabled","disabled");
            }else{
                $("#btn_edit").removeAttr("disabled");
            }
        });
    });
	
	$("#empresas tbody tr:eq("+pos+")").find('td:eq(2)').each(function () {
var ruc;
        ruc = $(this).html();
        $("#ruc_edit").val(ruc);
       
    });
	
	$("#empresas tbody tr:eq("+pos+")").find('td:eq(3)').each(function () {
var direccion;
        direccion = $(this).html();
        $("#direccion_edit").val(direccion);
        
    });
	
	$("#empresas tbody tr:eq("+pos+")").find('td:eq(4)').each(function () {
var telefono;
        telefono = $(this).html();
        $("#telefono_edit").val(telefono);
        
    });
    $("#empresas tbody tr:eq("+pos+")").find('td:eq(5)').each(function () {
var email;
        email = $(this).html();
        $("#email_edit").val(email);
   
    });
	
    
});
    
$(document).on("click","#btn_edit",function(){
       var cod = $("#cod_edit").val();
       var empresa = $("#empresa_edit").val();
       var ruc = $("#ruc_edit").val();
       var direccion = $("#direccion_edit").val();
       var telefono = $("#telefono_edit").val();
       var email = $("#email_edit").val();
       
 
   $.ajax({
       url: "grabar.php",
       type: "POST",
       data: {codigo: cod, empresa: empresa, ruc: ruc, direccion: direccion, telefono:telefono,  email:email,ope: 'modificacion'}
   }).done(function(msg){
       $('#cerrar').click();
       $("#btn_edit").html("Editar");
     humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
                refrescarDatos();
         });
   
});
    
$("#empresa_edit").keypress(function(e){
if(e.which === 13 && $("#empresa_edit").val()!==""){
    $("#btn_edit").focus();
    $("#btn_edit").click();
}else{
    
}
}); 


//FIN EDITAR    
    

});

                            