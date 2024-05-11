   //OBS:funciona todo
    ////TABLA
$(function(){
 var tabla =  $('#entidad_emisora').dataTable({
    responsive: true,
    "columns":
    [
        { "data": "codigo" },
        { "data": "nombre" },
        { "data": "direccion" },
        { "data": "telefono" },
        { "data": "email" },
        { "data": "acciones"}
    ]
 });

   tabla.fnReloadAjax( 'datos.php' );

    function refrescarDatos(){
      tabla.fnReloadAjax();
    }
////FIN TABLA

//AGREGAR

    $(document).on("click","#btnsave",function(){
     var nombre = $("#nombre").val();
	   var direccion = $("#direccion").val();
	   var telefono = $("#telefono").val();
     var email = $("#email").val();
		if(nombre!==""&& direccion!==""&& telefono !==""&& email!==""){
     
       $.ajax({
             type: "POST",
             url: "grabar.php",
             data: {codigo:'0', nombre: nombre,direccion: direccion,telefono: telefono,email: email, ope: 1 }
            }).done(function(msg){
                humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
                 $("#nombre").val('');
                $("#direccion").val('');
                $("#telefono").val('');
                $("#email").val('');
         refrescarDatos();
         });
      }else{
         humane.log("<span class='fa fa-info'></span> Por favor rellene los campos que faltan", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
      }
          
    });
//FIN AGREGAR

//ELIMINAR
$(document).on("click",".confirmar",function(){
        var pos = $(".confirmar").index(this);
        var cod;
       $("#entidad_emisora tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
          cod = $(this).html(); 
       });
        $("#borrar").val(cod);
        $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea eliminar el Registro Nro. '+cod+' ?</h4>');
    });

                        //Button= id="borrar" -->Si
 $(document).on("click","#borrar",function(){
      var codigo = $("#borrar").val();
        $.ajax({
           type: 'POST',
           url: 'grabar.php',
           data: {codigo: codigo, nombre: '',  direccion: '', telefono: '', email: '', ope: 3}
        }).done(function(msg){
            // $("#cerrar2").click();
            $("#confirmacion").modal("hide");
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            refrescarDatos();
            }); 
  });
//FIN ELIMINAR

//EDITAR
$(document).on("click",".editar",function(){
  //  $("#btn_edit").attr("disabled","disabled");
    var pos = $( ".editar" ).index( this );
    $("#entidad_emisora tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
        var nombre, direccion;
        nombre = $(this).html();
        $("#nom_edit").val(nombre);
        $("#nom_edit").focus();
        $('#nom_edit').keyup(function () {
            if($("#nom_edit").val()==="" || $("#nom_edit").val()===nombre || $('#dire_edit').val()===direccion || $('#dire_edit').val()==="") {
                $("#btn_edit").attr("disabled","disabled");
            }else{
                $("#btn_edit").removeAttr("disabled");
            }
        });
         $('#dire_edit').keyup(function () {
            if($('#dire_edit').val()===direccion || $('#dire_edit').val()==="") {
                $("#btn_edit").attr("disabled","disabled");
            }else{
                $("#btn_edit").removeAttr("disabled");
            }
        });
    });
	
	$("#entidad_emisora tbody tr:eq("+pos+")").find('td:eq(2)').each(function () {
        var direccion;
        direccion = $(this).html();
        $("#dire_edit").val(direccion);
       
    });

	$("#entidad_emisora tbody tr:eq("+pos+")").find('td:eq(3)').each(function () {
        var telefono;
        telefono = $(this).html();
        $("#tel_edit").val(telefono);
        
    });
    $("#entidad_emisora tbody tr:eq("+pos+")").find('td:eq(4)').each(function () {
        var email;
        email = $(this).html();
        $("#email_edit").val(email);
   
    });
	
    $("#entidad_emisora tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
        var codigo = $(this).html();
        $("#cod_edit").val(codigo);
    });
});
    
$(document).on("click","#btn_edit",function(){
    var codigo = $("#cod_edit").val();
    var nombre = $("#nom_edit").val();
    var direccion = $("#dire_edit").val();
    var telefono = $("#tel_edit").val();
    var email = $("#email_edit").val();

   $.ajax({
       type: "POST",
       url: "grabar.php",
       data: {codigo: codigo, nombre: nombre, direccion: direccion, telefono:telefono,  email:email,ope:2}
   }).done(function(msg){
       $('#cerrar').click();
       $("#btn_edit").html("Editar");
      humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
                refrescarDatos();
         });
   });
//});
    
$("#nom_edit").keypress(function(e){
if(e.which === 13 && $("#nom_edit").val()!==""){
    $("#btn_edit").focus();
    $("#btn_edit").click();
}else{
    
}
}); 
});
//FIN EDITAR
  


 
    




                            