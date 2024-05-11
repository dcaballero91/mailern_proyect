$(function(){
    //se declara una variable tabla en el cual se inicializa el dataTable y se especifican la columnas
    //que va a contener y las etiquetas de los datos json 
   var tabla = $("#personas").dataTable({
      "columns":
        [   
          
            { "data": "nro" },
            { "data": "nombre"},
            { "data": "ruc" }, 
            { "data": "vighasta" }, 
            { "data": "esta"},
            { "data": "acciones"}
    ]
 });
    tabla.fnReloadAjax( 'datos.php' );
    
      //refresca datos de la tabla
function refrescarDatos(){
        tabla.fnReloadAjax();
    }

   

    //AGREGAR
    $(document).on("click","#btnsave",function(){
        //se declaran variables que se enviaran al sp
        var provcod = $("#proveedor").val();
        var tim = $("#timbrado").val();
        var fecha = $("#vighasta").val();
        
        //Si todas las variables son distintas de vacio (!=="")
        if(provcod > 0  && tim > 0 && fecha !== "" ){
            //se ejecuta la peticion 
            $.ajax({
                   type: "POST",
                   url: "grabar.php",
                   data: {prov:provcod,tim:tim,fecha:fecha,ope:1 }
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
                humane.log("<span class='fa fa-info'></span> Complete los campos vacios", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
            }
    });
    
    //Borrar
    //capturamos la posicion del boton borrar(X)
    $(document).on("click",".eliminar",function(){
        var pos = $( ".eliminar" ).index( this );

        $("#personas tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var timb;
            timb = $(this).html();
            $("#tim_eliminar").val(timb);
            $(".msg").html("<h4>Desea desactivar el registro n°:"+timb+"</h4>");
        });

        $("#personas tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
            var provnro = $(this).html();
                provnro = provnro.split("-");
                provnro = provnro[0].trim();
                $("#prov_eliminar").val(provnro);
                // console.log(provnro)
        });

    });
            //FIN CUADRO DE DIALOGO
            //INICIO FUNCION DESACTIVAR
    $(document).on("click","#delete",function(){
        var tim = $( "#tim_eliminar" ).val();
        var prov = $( "#prov_eliminar" ).val();
        
       //**//
        $.ajax({
            type: "POST",
            url: "grabar.php", 
            data: {prov:prov,tim:tim,fecha:'1/1/1111',ope:3 }
        }).done(function(msg){
            $('#confirmacion').modal("hide");
           // cargar();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
            refrescarDatos();
        });
    });

//FIN DESACTIVAR

//EDITAR
   $(document).on("click",".editar",function(){
       var pos = $(".editar").index(this);
       $("#personas tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
           var  tim = $(this).html(); 
           $("#tim_edit").val(tim);

            $("#personas tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
                var provnro = $(this).html();
                    provnro = provnro.split("-");
                    provnro = provnro[0].trim();
                    $("#proveedor_edit").val(provnro).trigger('change');
                    // console.log(provnro)
            });

            $("#personas tbody tr:eq("+pos+")").find('td:eq(3)').each(function () {
                var fecha = $(this).html();
                $("#fecha_edit").val(fecha);
            });

         });
   });

   $(document).on("click","#btn_edit",function(){
       var  prov, tim, fecha;
        prov = $("#proveedor_edit").val();
        tim = $("#tim_edit").val();
        fecha= $("#fecha_edit").val();
        if(tim > 0 && prov >0 && fecha!==""){
            $.ajax({
                   type: "POST",
                   url: "grabar.php",
                   data: {prov:prov,tim:tim,fecha:fecha,ope:2 }
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
    $("#proveedor").val(1).trigger('change');
    $("#vighasta").val("");
    $("#timbrado").val("");
}
});