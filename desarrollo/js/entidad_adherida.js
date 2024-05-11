//JS FUNCIONA TODO!!
$(function(){

     var tabla =  $('#entidad_adherida').dataTable({
    "columns":
    [
        { "data": "codigo" },
        { "data": "entidad" },
        { "data": "marca" },
        { "data": "emisora" },
        { "data": "dir" },
        { "data": "tel" },
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
        var marca = $("#marca").val();
        var entidad = $("#entidad").val();
        var dir = $("#dir").val();
        var tel = $("#tel").val();
        var email = $("#email").val();
        var emisora = $("#emisora").val();
        
        if(marca!=="",entidad!=="",dir!=="",tel!=="",email!=="",emisora !==""){
       
          
            $.ajax({
            type: "POST",
            url: "grabar.php",                //grabar: variable, grabar:variable, grabar:variable del sp=en grabar de la  linea  14
            data: {codigo:'0',marca:marca,entidad:entidad,dir:dir,tel:tel,email:email,emisora:emisora,ope:1}
        }).done(function(msg){
             humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
           
          

            $('#marca > option[value=""]').attr('selected',true);
            $("#entidad").val('');
            $("#dir").val('');
            $("#tel").val('');
            $("#email").val('');
            $('#emisora > option[value=""]').attr('selected',true);
           refrescarDatos();
           });
           }else{
          humane.log("<span class='fa fa-check'></span> Por favor complete todos los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });    
            
        }
        });
       
    
//FIN AGREGAR
//ELIMINAR
$(document).on("click",".confirmar",function(){
        var pos = $(".confirmar").index(this);
        var cod;
       $("#entidad_adherida tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
          cod = $(this).html(); 
       });
        $("#delete").val(cod);
        $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea eliminar el Registro Nro. '+cod+' ?</h4>');
    });

                        //Button= id="borrar" -->Si
 $(document).on("click","#delete",function(){
      var codigo = $("#delete").val();
        $.ajax({
           type: 'POST',
           url: 'grabar.php',
           data: {codigo: codigo, marca: 0, entidad: '', dir: '', tel: '', email: '',emisora:0, ope:2}
        }).done(function(msg){
            $("#cerrar2").click();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            refrescarDatos();
            }); 
  });


//FIN ELIMINAR

   //EDITAR
   $(document).on("click",".editar",function(){
       var pos = $(".editar").index(this);
       $("#entidad_adherida tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
           
         var  cod = $(this).html(); 
         $("#cod_edit").val(cod);
            $.ajax({
                type: 'POST',
                url: 'editar.php',
                async: true,
                data: {cod: cod} 
             }).done(function(msg){
                 var dame = eval("("+msg+")");
                 console.log(dame);
                $("#cod_edit").val(cod);
                $("#entidad_edit").val(dame.ent_ad_nom);
                $('#emisora_edit').val(dame.ent_cod).trigger('change');
                $('#marca_edit').val(dame.mar_tarj_cod).trigger('change');
                $("#dir_edit").val(dame.ent_ad_dir);
                $("#tel_edit").val(dame.ent_ad_tel);
                $("#email_edit").val(dame.ent_ad_email);
                
             });
   });
   });
    $(document).on("click","#btn_edit",function(){
        var cod,entidad,marca,emisora,dir,tel,email;
        marca = $("#marca_edit").val();
        entidad = $("#entidad_edit").val();
        dir = $("#dir_edit").val();
        tel = $("#tel_edit").val();
        email = $("#email_edit").val();
        emisora = $("#emisora_edit").val();
        
        cod = $("#cod_edit").val();
        //$("#btn_edit").attr("disabled","disabled");
       // $("#btn_edit").html("Editando...");
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:cod,marca:marca,entidad:entidad,dir:dir,tel:tel,email:email,emisora:emisora,ope:2}
        }).done(function(msg){
            $('#cerrar').click();
             refrescarDatos();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
      
       
    });
    
    });

    



    
//FIN EDITAR




});