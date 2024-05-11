 //JS FUNCIONA TODO!!
 $(function(){

     var tabla =  $('#lista').dataTable({
    "columns":
    [
        { "data": "codigo"},
        { "data": "caja"},
        { "data": "timbrado"},
        { "data": "ultfactura"},
        { "data": "ultrecibo"},
        { "data": "suc" },
        { "data": "usu" },
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
        var caja = $("#caja").val();
        var timbrado = $("#timbrado").val();       
       
         if(caja!==""&& timbrado !==""){ 
              $.ajax({
            type: "POST",
            url: "grabar.php",                
            data: {caja:caja, timb:timbrado,ope:1}
        }).done(function(msg){
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
           // $("#btnsave").html("AGREGAR.");
           // $('#sucursal > option[value=""]').attr('selected',false);  //combo
           
            $("#sucursal").prop('disabled', 'disabled'); // PERMITE QUE PUEDE SEGUIR CARGANDO DESEGUIDO
            $("#deposito").val('');
            
           refrescarDatos();
           });
           }else{
         humane.log("<span class='fa fa-check'>VERIFIQUE LOS CAMPOS</span> ", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
            
        }
        });
        
//FIN AGREGAR**
//EDITAR
    $(document).on("click",".editar",function(){
        $("#btn_edit").html("Guardar cambios");
        //alert("ok");
        //$("#btn_edit").attr("disabled","disabled");
        var pos = $( ".editar" ).index( this );
        $("#lista tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var cod = $(this).html();
            $("#cod_edit").val(cod);
            $.ajax({
                type: 'POST',
                url: 'caja_timb.php',
                async: true,
                data: {cod: cod}
            }).done(function(msg){
                var dame = eval("("+msg+")");
                console.log(dame);
                // $("#cod_edit").val(cod);
                $("#caja_edit").val(dame.caja_cod).trigger('change');
                $("#timbrado_edit").val(dame.timb_cod).trigger('change');
            
                
            });
        });
    });

    $(document).on("click","#btn_edit",function(){
        var caja = $("#caja_edit").val();
        var timbrado = $("#timbrado_edit").val();      
        // var cod = $("#cod_edit").val();
        
        $("#btn_edit").html("Editando...");
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {caja:caja, timb:timbrado,ope:2}
        }).done(function(msg){
            $('#cerrar').click();
            refrescarDatos();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
        });
    });

    
//FIN EDITAR

//Borrar
    //capturamos la posicion del boton borrar(X)
//     $(document).on("click",".eliminar",function(){
//         var pos = $( ".eliminar" ).index( this );
//         $("#lista tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
//             var id;
//             id = $(this).html();
//             $("#cod_eliminar").val(id);
//             $(".msg").html("<h4>Desea desactivar el registro n°:"+id+"</h4>");
//         });
//     });
//             //FIN CUADRO DE DIALOGO
//  //INICIO FUNCION DESACTIVAR
//     $(document).on("click","#delete",function(){
//         var cod = $( "#cod_eliminar" ).val();
//         $.ajax({
//             type: "POST",
//             url: "grabar.php", //data:{codigo: 0,nom: '', ape: '', tel: '', dir: '', ruc:'', ci: '0', fenaci: '11/11/1111', email: '',  nac: 0, esta:0,ciu:0,gen:0,tipo:0,ope: 'eliminacion'}
//               data:{codigo: cod, empresa:0, sucursal:0,deposito:'',ope: 3}
//          //   data:{codigo:cod,fecha:'25-02-2016',especialidad:'',funcionario:0,profesion:0,ope:'activar'}
//             ///select * from sp_especialidades(4,'25-02-2016','esp',1,1,'desactivar')
//         }).done(function(msg){
//             $('#confirmacion').modal("hide");
//            // cargar();
//             humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
//             refrescarDatos();
//         });
//     });

//FIN DESACTIVAR

//ACTIVAR
                //INICIO CUADRO DE DIALOGO
    // $(document).on("click",".activar",function(){
    //     var pos = $( ".activar" ).index( this );
    //     $("#lista tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
    //         var id;
    //         id = $(this).html();
    //         $("#cod_activar").val(id);
    //         $(".msgactive").html("<h4>DESEA ACTIVAR EL REGISTRO NRO°:"+id+"</h4>");

    //     });
    // });
    //             //FIN CUADRO DE DIALOGO
    //             //INICIO FUNCION ACTIVAR
    // $(document).on("click","#okactive",function(){
    //     var cod = $( "#cod_activar" ).val();
    //     $.ajax({
    //         type: "POST",
    //         url: "grabar.php",
    //           data:{codigo: cod,empresa:0, sucursal:0,deposito:'',ope: 4}
           
    //     }).done(function(msg){
            
    //         $('#activacion').modal("hide");
    //        // cargar();
    //         humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
    //         refrescarDatos();
    //     });

    // });
//**FIN ELIMINAR**//


//INICIO DE VISTAS
    //  $("#sucursal").change(function(){
    //         empresa();
        
        
    //     });
        
    //       function empresa(){
    //         var cod = $('#sucursal').val();
    //         $.ajax({
    //             type: "POST",
    //             url: "emp.php",
    //             data: {cod: cod}
    //         }).done(function(empresa){
    //             $("#empresa").val(empresa);
    //             $("#deposito").focus();
    //         });
    //     }

    //     $(function () {
    

    //     $(".chosen-select").chosen({width: "100%"});  
    
        
    // });
});
//FIN DE VISTAS