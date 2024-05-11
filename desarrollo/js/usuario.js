$(function(){
    //se declara una variable tabla en el cual se inicializa el dataTable y se especifican la columnas
    //que va a contener y las etiquetas de los datos json 
   var tabla = $("#personas").dataTable({
      "columns":
        [   
            { "data": "codigo"},
            { "data": "nom" },
            { "data": "funnom" }, 
            { "data": "car" }, 
            { "data": "grupo" },
            { "data": "estado" },
            { "data": "acciones"}
    ]
 });
    tabla.fnReloadAjax( 'datos.php' );
    
      //refresca datos de la tabla
function refrescarDatos(){
        tabla.fnReloadAjax();
    }
    ///GUARDAR
    $(document).on("click","#btnsave",function(){
        //se guardan los valores de los campos de textos en las variables correspondientes
        var fun = $("#fun").val();
        var usu = $("#usu").val();
        var gru = $("#gru").val();
        var suc = $("#suc").val();
        var pass = $("#pass").val();
       
        //Si todas las variables son distintas de vacio (!=="")
        if(fun !== "" && usu !== "" && gru !== "" && suc !== "" && pass !== ""){
            //se ejecuta la peticion 
            $.ajax({
                   type: "POST",
                   url: "grabar.php",
                   data: {codigo:0,fun:fun,usu:usu,pass:pass,gru:gru,suc:suc,foto:'',ope:1 }
                }).done(function(msg){
                    //por ultimo se muestra el mensaje de respuesta en un alert
                     humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
                     //se actualizan los datos de la tabla
                     refrescarDatos();
                     //y se vacian los campos
                     vaciar();
                });
        }else{
            //Si algun campo esta vacio se muestra un mensaje de alerta
                humane.log("<span class='fa fa-info'>Verifique los campos</span>", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
            }
    });
    
    //Borrar
    //capturamos la posicion del boton borrar(X)
    $(document).on("click",".eliminar",function(){
        var pos = $( ".eliminar" ).index( this );
        $("#personas tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var id;
            id = $(this).html();
            $("#cod_eliminar").val(id);
            $(".msg").html("<h4>DESEA DESACTIVAR EL REGISTRO N°:"+id+"</h4>");
        });
    });
            //FIN CUADRO DE DIALOGO
            //INICIO FUNCION DESACTIVAR
    $(document).on("click","#delete",function(){
        var cod = $( "#cod_eliminar" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:cod,fun:0,usu:0,pass:'',gru:0,suc:0,foto:'',ope:4}
        }).done(function(msg){
             $('#confirmacion').modal("hide");
           // cargar();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
            refrescarDatos();
        });
    });

//FIN DESACTIVAR
   
       //REINICIAR CONTRASEÑA
       $(document).on("click",".reiniciar",function(){
        var pos = $(".reiniciar").index(this);
        $("#personas tbody tr:eq("+pos+")").find('td:eq(0)').each(function(){
            var id;
            id = $(this).html();
            $("#cod_reiniciar").val(id);
            $(".msg").html("<h4>Desea reiniciar la constraseña del usuario Nro."+id+"</h4>");
        });
    });

    $(document).on("click","#reini",function(){
        var cod = $("#cod_reiniciar").val();
        $.ajax({
            type: 'POST',
            url: 'grabar.php',
            data: {codigo:cod,fun:0,usu:'',pass:'',gru:0,suc:0,foto:'',ope:3}
            // -- select sp_usuarios(2,1,1,'','',1,'',3) // para reiniciar contraseña
        }).done(function(msg){
            $('#reiniciar').modal("hide");
            //cargar cambios
            humane.log("<span class='fa-fa-check'></span>"+msg,{timeout:4000, clickToClose: true, addnCls:'humane-flatty-success'});
            refrescarDatos();
        });
    });
    //FIN REINICIAR CONTRASEÑA


//ACTIVAR
                //INICIO CUADRO DE DIALOGO
    $(document).on("click",".activar",function(){
        var pos = $( ".activar" ).index( this );
        $("#personas tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var id;
            id = $(this).html();
            $("#cod_activar").val(id);
            $(".msgactive").html("<h4>DESEA ACTIVAR EL REGISTRO NROº:"+id+" ?</h4>");

        });
    });

                //FIN CUADRO DE DIALOGO
                //INICIO FUNCION ACTIVAR
    $(document).on("click","#okactive",function(){
        var cod = $( "#cod_activar" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:cod,fun:0,usu:0,pass:'',gru:0,suc:0,foto:'',ope:5}
           
        }).done(function(msg){
            
            $('#activacion').modal("hide");
           // cargar();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
            refrescarDatos();
        });

    });
 

    //EDITAR
   $(document).on("click",".editar",function(){
       var pos = $(".editar").index(this);
       $("#personas tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
           
         var  cod = $(this).html(); 
         $("#cod_edit").val(cod);
            $.ajax({
                type: 'POST',
                url: 'editar.php',
                async: true,
                data: {cod: cod} 
             }).done(function(msg){
                 var dame = eval("("+msg+")");
                 console.log(dame)
                $("#cod_edit").val(cod);
                $("#fun_edit").val(dame.fun_cod).trigger('change');
                $("#usu_edit").val(dame.usu_name);
                $("#gru_edit").val(dame.gru_id).trigger('change');
                $("#suc_edit").val(dame.suc_cod).trigger('change');            
               
             });
   });
   });




   $(document).on("click","#btn_edit",function(){
       var cod,fun,usu,gru,suc;
        cod  = $("#cod_edit").val();
        fun  = $("#fun_edit").val();
        usu  = $("#usu_edit").val();
        suc  = $("#suc_edit").val();
        gru  = $("#gru_edit").val();
        cargo_funcionario = $("#cargo_funcionario_edit").val();
        if(fun !== "" && usu !== "" && suc !== ""&& gru!== "" ){
            $.ajax({
                   type: "POST",
                   url: "grabar.php",
                   data: {codigo:cod,fun:fun,usu:usu,pass:'',gru:gru,suc:suc,foto:'',ope:2}
                }).done(function(msg){
                     humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
                     refrescarDatos();
                     $('#cerrar').click();
                });
        }else{
                humane.log("<span class='fa fa-info'></span> Complete todos los campos vacios", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
            }
   });
    //funcion para vaciar los campos de texto del agregar
    function vaciar(){
     $("#fun").val('');
     $("#usu").val('');
     $("#gru").val('');
     $("#suc").val('');
     $("#pass").val('');
}
});