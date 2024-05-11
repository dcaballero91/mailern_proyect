$(function(){
    //se declara una variable tabla en el cual se inicializa el dataTable y se especifican la columnas
    //que va a contener y las etiquetas de los datos json 
   var tabla = $("#personas").dataTable({
      "columns":
        [   
            { "data": "codigo"},
            { "data": "nom" },
            { "data": "ci" }, 
            { "data": "tel" },
            { "data": "cargo" },
            { "data": "falta" },
            { "data": "fbaja" },
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
        //se declaran variables que se enviaran al sp
        //se guardan los valores de los campos de textos en las variables correspondientes
        var nom = $("#fun").val();
        var car = $("#cargo").val();
        var falta = $("#falta").val();
        var prof = $("#profesion").val();
        var esp = $("#especialidad").val();  
         
        //Si todas las variables son distintas de vacio (!=="")
        if(nom !== "" && car !== "" && falta !== "" && prof !=="" && esp !==""){
            //se ejecuta la peticion 
            $.ajax({
                   type: "POST",
                   url: "grabar.php",
                   data: {codigo:0,nom:nom,car:car,falta:falta,prof:prof,esp:esp,ope:1}
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
            data: {codigo:cod,nom:0,car:0,falta:'',prof:0,esp:0,ope:3}
        }).done(function(msg){
            $('#confirmacion').modal("hide");
           // cargar();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
            refrescarDatos();
        });
    });
//FIN DESACTIVAR

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
            data: {codigo:cod,nom:0,car:0,falta:'',prof:0,esp:0,ope:4}
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
                 console.log(dame);
                $('#cod_edit').val(cod);
                $('#fun_edit').val(dame.fun_cod).trigger('change');
                $("#cargo_edit").val(dame.car_cod).trigger('change');
                $('#profesion_edit').val(dame.prof_cod).trigger('change');
                $('#especialidad_edit').val(dame.esp_cod).trigger('change');  
             });
   });
   });
   $(document).on("click","#btn_edit",function(){
    var cod = $("#cod_edit").val();
    var nom = $("#fun_edit").val();
    var car = $("#cargo_edit").val();
    // var falta = $("#falta_edit").val();
    var prof = $("#profesion_edit").val();
    var esp = $("#especialidad_edit").val();  
        if(nom !== "" && car!== "" && prof!=="" && esp!=="" ){
            $.ajax({
                   type: "POST",
                   url: "grabar.php",
                   data:{codigo:cod,nom:nom,car:car,prof:prof,esp:esp,ope:2}
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
    $("#nom").val("");
    $("#ape").val("");
    $("#ci").val("");
    $("#tel").val("");
    $("#dir").val("");
    $("#email").val("");
    $("#fec").val("");
    $('#ciud > option[value=""]').attr('selected',true);
    $('#ciud').selectpicker('refresh');
    $('#nac > option[value=""]').attr('selected',true);
    $('#nac').selectpicker('refresh');
    $('#civil > option[value=""]').attr('selected',true);
    $('#civil').selectpicker('refresh');
    
    $("#tipo").val("");
}
});