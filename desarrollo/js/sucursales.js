 //JS FUNCIONA TODO!!
 $(function(){

     var tabla =  $('#sucursales').dataTable({
    "columns":
    [
        { "data": "codigo" },
        { "data": "emp" },
        { "data": "suc" },
        { "data": "dir" },
        { "data": "tel" },
        { "data": "email" },
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
   

    $(document).on("click","#btnsave",function(){     //#btnsave  es el id del boton  guardar
        var empresa,sucursal,dir,tel,email;
        var empresa = $("#emp").val();
        var sucursal = $("#suc").val();
        var dir = $("#dir").val();
        var tel = $("#tel").val();
        var  email = $("#email").val();
       
         if(empresa!=="",sucursal!=="",dir !=="",tel!=="",email!==""){ 
              $.ajax({
            type: "POST",
            url: "grabar.php",                //grabar: variable, grabar:variable, grabar:variable del sp=en grabar de la  linea  14
            data: {codigo:0,emp:empresa,suc:sucursal,dir:dir,tel:tel,email:email,ope:1}
        }).done(function(msg){
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
           // $("#btnsave").html("AGREGAR.");
            $('#emp > option[value=""]').attr('selected',true);  //combo
            $("#suc").val('');
            $("#dir").val('');
            $("#tel").val('');
            $("#email").val('');
           refrescarDatos();
           });
           }else{
         humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
            
        }
        });
       
    
//FIN AGREGAR
//ELIMINAR
$(document).on("click",".confirmar",function(){
        var pos = $(".confirmar").index(this);
        var cod;
       $("#sucursales tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
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
           data: {codigo: codigo, emp: 0, suc: '', dir: '', tel: '', email: '', ope:3}
        }).done(function(msg){
            $("#cerrar2").click();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            refrescarDatos();
            }); 
  });


//FIN ELIMINAR

//ACTIVACION
  $(document).on("click",".activar",function(){
        var pos = $(".activar").index(this);
        var cod;
        $("#sucursales tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
             cod = $(this).html();
        });
        $("#activar").val(cod);
        $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea activar el Registro Nro. '+cod+' ?</h4>');
  });
  $(document).on("click","#activar",function(){
      var codigo = $("#activar").val();
      $.ajax({
        type: 'POST',
        url: 'grabar.php',
        data: {codigo: codigo, emp: 0, suc: '', dir: '', tel: '', email: '', ope:4}

      }).done(function(msg){
        $("#activacion").modal("hide");

        humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
        refrescarDatos();
      });
  });

//   $(".msg").html("<span class='fa-fa-check'></span>",+msg,{timeout:4000, clickToClose:true, addnCls:'humane-flatty-success'});
//FIN ACTIVACION
//EDITAR
    $(document).on("click",".editar",function(){
        $("#btn_edit").html("Guardar cambios");
        //alert("ok");
        //$("#btn_edit").attr("disabled","disabled");
        var pos = $( ".editar" ).index( this );
        $("#sucursales tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var cod = $(this).html();
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
                $('#emp_edit').val(dame.emp_cod).trigger('change');
                $('#suc_edit').val(dame.suc_nom);
                $('#dir_edit').val(dame.suc_dir);
                $('#tel_edit').val(dame.suc_tel);
                $('#email_edit').val(dame.suc_email);
                
            });
        });
    });

    $(document).on("click","#btn_edit",function(){
        var cod,emp,suc,dir,tel,email;
        emp = $("#emp_edit").val();
        suc = $("#suc_edit").val();
        dir = $("#dir_edit").val();
        tel = $("#tel_edit").val();
        email = $("#email_edit").val();
        
        cod = $("#cod_edit").val();
        
        $("#btn_edit").html("Editando...");
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:cod,emp:emp,suc:suc,dir:dir,tel:tel,email:email,ope:2}
        }).done(function(msg){
            $('#cerrar').click();
            refrescarDatos();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
        });
    });

    
//FIN EDITAR

$(function () {
   

    $(".chosen-select").chosen({width: "100%"});
   

});



});