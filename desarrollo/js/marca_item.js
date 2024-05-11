 //JS FUNCIONA TODO!!
 $(function(){

     var tabla =  $('#lista').dataTable({
    "columns":
    [
        { "data": "item"},
        { "data": "marca"},
        { "data": "costo"},
        { "data": "precio"},
        { "data": "itemmin"},
        { "data": "itemmax" },
        { "data": "tipoimp" },
        { "data": "estado" },
        { "data": "acciones"}
    ]
 });
    tabla.fnReloadAjax( 'datos.php' );
    function refrescarDatos(){
        tabla.fnReloadAjax();
    }

////FIN TABLA


 //AGREGAR**
    $(document).on("click","#btnsave",function(){     //#btnsave  es el id del boton  guardar
        var item = $("#item").val();
        var marca = $("#marca").val();       
        var costo = $("#costo").val();       
        var precio = $("#precio").val();       
        var min = $("#min").val();       
        var max = $("#max").val();       
       
         if(item > 0 && marca > 0 && costo > 0 && precio > 0 && min > 0 && max > 0 ){ 
              $.ajax({
            type: "POST",
            url: "grabar.php",                
            data: {item:item,marca:marca,costo:costo,precio:precio,min:min,max:max,ope:1}
        }).done(function(msg){
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });

            //$("#item").prop('disabled', 'disabled'); // PERMITE QUE PUEDE SEGUIR CARGANDO DESEGUIDO
            $("#item").val(0).trigger('change');
            $("#marca").val(0).trigger('change');
            $("#costo").val("");
            $("#precio").val("");
            $("#min").val("");
            $("#max").val("");
            
           refrescarDatos();
           });
           }else{
         humane.log("<span class='fa fa-check'>VERIFIQUE LOS CAMPOS</span> ", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
            
        }
        });
        
//FIN AGREGAR**

//EDITAR
    $(document).on("click",".editar",function(){
        var pos = $(".editar").index( this );
        var itemcod;
        $("#lista tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            itemcod = $(this).html();

            itemcod = itemcod.split('-');
            itemcod = itemcod[0].trim();
        });

        var marcod;
        $("#lista tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
          marcod = $(this).html();
            marcod = marcod.split('-');
            marcod = marcod[0].trim();
        });
    
            $.ajax({
                type: 'POST',
                url: 'editar.php',
                async: true,
                data: {marcod: marcod, itemcod: itemcod}
            }).done(function(msg){
                var dame = eval("("+msg+")");
                console.log(dame);
                // $("#cod_edit").val(cod);
                $("#item_edit").val(dame.item_cod).trigger('change');
                $("#marca_edit").val(dame.mar_cod).trigger('change');
                $("#costo_edit").val(dame.costo)
                $("#precio_edit").val(dame.precio)
                $("#min_edit").val(dame.item_min)
                $("#max_edit").val(dame.item_max)
            });
    });

    $(document).on("click","#btn_edit",function(){
        var item = $("#item_edit").val();
        var marca = $("#marca_edit").val();      
        var costo = $("#costo_edit").val();      
        var precio = $("#precio_edit").val();      
        var min = $("#min_edit").val();      
        var max = $("#max_edit").val();      
      
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {item:item,marca:marca,costo:costo,precio:precio,min:min,max:max,ope:2}
        }).done(function(msg){
            $('#cerrar').click();
            refrescarDatos();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
        });
    });

    
//FIN EDITAR

//DESACTIVAR
              //  INICIO CUADRO DE DIALOGO
    $(document).on("click",".desactivar",function(){
        var pos = $( ".desactivar" ).index( this );
        var cod = $("#lista tbody tr:eq("+pos+")").find('td:eq(0)').html();
        var itemcod = cod.split('-')
            itemcod = cod[0];
        var mar = $("#lista tbody tr:eq("+pos+")").find('td:eq(1)').html();
        var marcod = mar.split('-');
            marcod = marcod[0];

        $("#cod_desactivar").val(itemcod);
        $("#mar_desactivar").val(marcod);
        $(".msgactive").html("<h4>DESEA DESACTIVAR EL REGISTRO NRO°:"+cod+' / '+mar+"</h4>");
    });
                //FIN CUADRO DE DIALOGO
                //INICIO FUNCION DESACTIVAR
    $(document).on("click","#okdesactive",function(){
        var item = $( "#cod_desactivar" ).val();
        var marca = $( "#mar_desactivar" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {item:item,marca:marca,costo:0,precio:0,min:0,max:0,ope:3}
        }).done(function(msg){
            $('#desactivacion').modal("hide");
           // cargar();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
            refrescarDatos();
        });

    });
// FIN DESACTIVAR


//ACTIVAR
        //  INICIO CUADRO DE DIALOGO
        $(document).on("click",".activar",function(){
        var pos = $( ".activar" ).index( this );
        var cod = $("#lista tbody tr:eq("+pos+")").find('td:eq(0)').html().split('-');
        var itemcod = cod[0];
        var mar = $("#lista tbody tr:eq("+pos+")").find('td:eq(1)').html().split('-');
        var marcod = cod[0];

        $("#cod_activar").val(itemcod);
        $("#mar_activar").val(marcod);
        $(".msgactive").html("<h4>DESEA ACTIVAR EL REGISTRO NRO°:"+cod+' / '+mar+"</h4>");
    });
                //FIN CUADRO DE DIALOGO
                //INICIO FUNCION ACTIVAR
    $(document).on("click","#okactive",function(){
        var item = $( "#cod_activar" ).val();
        var marca = $( "#mar_activar" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {item:item,marca:marca,costo:0,precio:0,min:0,max:0,ope:4}
        }).done(function(msg){
            $('#activacion').modal("hide");
            // cargar();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
            refrescarDatos();
        });

    });
// FIN ACTIVAR


//ELIMINAR
    // capturamos la posicion del boton borrar(X)
    $(document).on("click",".eliminar",function(){
        var pos = $( ".eliminar" ).index( this );
        var cod =  $("#lista tbody tr:eq("+pos+")").find('td:eq(0)').html().split('-');
            cod = cod[0];
        var mar =  $("#lista tbody tr:eq("+pos+")").find('td:eq(1)').html().split('-');
            mar = mar[0];
        $("#cod_eliminar").val(cod);
        $("#mar_eliminar").val(mar);
        $(".msg").html("<h4>Desea desactivar el item: "+cod+ ' / '+ mar+"</h4>");
    });
            //FIN CUADRO DE DIALOGO
 //INICIO FUNCION DESACTIVAR
    $(document).on("click","#delete",function(){
        var item = $( "#cod_eliminar" ).val();
        var marca = $( "#mar_eliminar" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php", 
            data: {item:item,marca:marca,costo:0,precio:0,min:0,max:0,ope:5}
        }).done(function(msg){
            $('#confirmacion').modal("hide");
           // cargar();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
            refrescarDatos();
        });
    });

//FIN ELIMINAR


});
//FIN DE VISTAS