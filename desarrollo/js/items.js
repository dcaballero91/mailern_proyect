

//iTEMS FUNCIONA CORRECTAMENTE
$(document).ready(function() {

    $("#tipoitem").change(function(){
        var valor = $("#tipoitem").val();
        if(valor === "1" || valor === "0"){
            $("#venta").prop("disabled", true);
            $("#venta").val("0");
        }else if(valor == "2") {
            $("#venta").prop("disabled", false)
        }
    })

})

$(function(){

     var tabla =  $('#item').dataTable({
    "columns":
    [
        { "data": "codigo" },
        { "data": "descri" },
        { "data": "precio" },
        // { "data": "min" },
        { "data": "tipo_item" },
        { "data": "imp" },
        { "data": "estado" },
        { "data": "acciones"}
    ]
 });
    tabla.fnReloadAjax( 'datos.php' );
    function refrescarDatos(){
        tabla.fnReloadAjax();
    };
////FIN TABLA

//AGREGAR

//    $("#btnsave").attr("disabled","disabled");
//    $('#item').keyup(function () {
//        if($("#item").val()!=="" ){
//                    if($("#descri").val()==="" && $("#costo").val()==="" && $("#venta").val()==="" && $("#min").val()==="" && $("#max").val()==="" && $("#marca").val()==="" && $("#imp").val()==="" && $("#clasificacion").val() ){

//            $("#btnsave").attr("disabled","disabled");
//        }else{
//            $("#btnsave").removeAttr("disabled");
//        }
//        }
//    });
//  });

   $(document).on("click","#btnsave",function(){
        var descri,costo,venta,min,max,mar,imp,cla,tipoitem, dep;
        descri = $("#descri").val();
        venta = $("#venta").val();
        imp = $("#imp").val();
        tipoitem = $("#tipoitem").val(); 
        oper = $("#txtOperacion").val();
    
        if(tipoitem == "2"){//SERVICIO
            if(descri !=="" && venta >0){
                $.ajax({
                    type: "POST",
                    url: "grabar.php",
                    data: {codigo:0,tipoitem:tipoitem,descri:descri,venta:venta,imp:imp,ope:1}
                }).done(function(msg){
                    $("#tipoitem").val("0").trigger('change');
                    $("#descri").val('');
                    $("#venta").val('');
                    $("#imp").val('1').trigger('change');
                
                    refrescarDatos();
                    mostrarMensaje(msg);

                });
            }else{
                humane.log("<span class='fa fa-info'></span>VERIFIQUE LOS CAMPOS POR FAVOR!", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });    
                refrescarDatos();
            };

        }else if(tipoitem == "1"){//PRODUCTO
            if(descri !==""){
                $.ajax({
                    type: "POST",
                    url: "grabar.php",
                    data: {codigo:0,tipoitem:tipoitem,descri:descri,venta:0,imp:imp,ope:1}
                }).done(function(msg){
                    $("#tipoitem").val("0").trigger('change');
                    $("#descri").val('');
                    $("#venta").val('');
                    $("#imp").val('1').trigger('change');
                
                    refrescarDatos();
                    mostrarMensaje(msg);

                });
            }else{
                humane.log("<span class='fa fa-info'></span>VERIFIQUE LOS CAMPOS POR FAVOR!", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });    
                refrescarDatos();
            };
        }
    });
//FIN AGREGAR
//FI0N AGREGAR

//EDITAR
    $(document).on("click",".editar",function(){
        
        var pos = $( ".editar" ).index( this );
        $("#item tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var cod = $(this).html();
            $("#codigo_edit").val(cod);
            $.ajax({
                type: 'POST',
                url: 'editar.php',
                async: true,
                data: {cod: cod}
            }).done(function(msg){
                var dame = eval("("+msg+")");
                // console.log(dame)
                $("#codigo_edit").val(cod);
                 $('#descri_edit').val(dame.item_desc);
                 $('#venta_edit').val(dame.item_precio);
                 $('#imp_edit').val(dame.tipo_imp_cod).trigger('change');
                 $('#tipoitem_edit').val(dame.tipo_item_cod).trigger('change');
            });
        });
    });


    $(document).on("click","#btn_edit",function(){
        var cod,descri,costo,venta,min,max,mar,imp,cla,dep;
        cod = $("#codigo_edit").val();
        descri = $("#descri_edit").val();
        venta = $("#venta_edit").val();
        imp = $("#imp_edit").val();
        tipoitem = $("#tipoitem_edit").val();
        //$("#btn_edit").attr("disabled","disabled");
        // $("#btn_edit").html("Editando...");
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:cod,tipoitem:tipoitem,descri:descri,venta:venta,imp:imp,ope:2}
        }).done(function(msg){
            $('#cerrar').click();
            
            mostrarMensaje(msg);   
            refrescarDatos();
       
        });
    
    });

    
    $('#costo_edit').keyup(function () {
        if($("#costo_edit").val()===""){
            $("#btn_edit").attr("disabled","disabled");
        }else{
            $("#btn_edit").removeAttr("disabled");
        }
    });
    $("#venta_edit").keypress(function(e){
        if(e.which === 13 && $("#venta_edit").val()!==""){
            $("#btn_edit").focus();
            $("#btn_edit").click();
        }else{

        }
    });
//FIN EDITAR

//DESACTIVAR
                //INICIO CUADRO DE DIALOGO
    $(document).on("click",".eliminar",function(){
        var pos = $( ".eliminar" ).index( this );
        $("#item tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var id;
            id = $(this).html();
            $("#cod_eliminar").val(id);
            $(".msg").html("<h4>Desea desactivar el registro n°:"+id+"</h4>");
        });
    });
            //FIN CUADRO DE DIALOGO
            //INICIO FUNCION DESACTIVAR
    $(document).on("click","#delete",function(){
        var cod = $( "#cod_eliminar" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:cod,tipoitem:0,descri:'',costo:0,min:0,max:0,marca:0,clasificacion:0,venta:0,imp:0,ope:3}
            
        }).done(function(msg){
            $('#desactivacion').modal("hide");
        //   cargar();
            mostrarMensaje(msg); 
            refrescarDatos();
        });
    });
                //FIN FUNCION
    //FIN DESACTIVAR
//ACTIVAR
                //INICIO CUADRO DE DIALOGO
    $(document).on("click",".activar",function(){
        var pos = $( ".activar" ).index( this );
        $("#item tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var id;
            id = $(this).html();
            $("#cod_activar").val(id);
            $(".msgactive").html("<h4>Desea activar el registro n°:"+id+"</h4>");

        });
    });
                //FIN CUADRO DE DIALOGO
                //INICIO FUNCION ACTIVAR
    $(document).on("click","#okactive",function(){
        var cod = $( "#cod_activar" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:cod,tipoitem:0,descri:'',costo:0,min:0,max:0,marca:0,clasificacion:0,venta:0,imp:0,dep:0,ope:4}
        }).done(function(msg){
            $('#activacion').modal("hide");
           // cargar();
            mostrarMensaje(msg);
            refrescarDatos();
        });

    });
        
//FIN ACTIVAR
//FUNCION PARA MOSTRAR LOS MENSAJES DE LA DB DE FORMA PERSONALIZADA
    function mostrarMensaje(msg){
        var r = msg.split("_/_");
        var texto = r[0];
        var tipo = r[1];
        
        if(tipo.trim() == 'notice'){
            texto = texto.split("NOTICE:");
            texto = texto[1];
            humane.log("<span class='fa fa-check'></span> "+texto, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
        }
        if(tipo.trim() == 'error'){
            texto = texto.split("ERROR:");
            texto = texto[2];
            var msg = texto.split("CONTEXT:");
            // console.log(msg);
           var textof = msg[0];
            humane.log("<span class='fa fa-info'></span> "+textof, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-error' });
        }
    }

$(function () {
   

    $(".chosen-select").chosen({width: "100%"});
   

});
});

