$(function(){
    //se declara una variable tabla en el cual se inicializa el dataTable y se especifican la columnas
    //que va a contener y las etiquetas de los datos json 
   var tabla = $("#personas").dataTable({
      "columns":
        [   
             { "data": "codigo" },
            { "data": "nom" },
            { "data": "ruc" }, 
            { "data": "dir" },
            { "data": "tel" },
            { "data": "email" },
            { "data": "ciu" },
            { "data": "tipo" },
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
        var nom = $("#proveedor").val();
        var ruc = $("#ruc").val();
        // var fechain = $("#fecha").val();

        
        //Si todas las variables son distintas de vacio (!=="")
        if(nom !== ""  && ruc !== "" ){
            //se ejecuta la peticion 
            $.ajax({
                   type: "POST",
                   url: "grabar.php",
                   data: {codigo:0,nom:nom,ruc:ruc,ope:1 }
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
        
       //**//
        $.ajax({
            type: "POST",
            url: "grabar.php", //data:{codigo: 0,nom: '', ape: '', tel: '', dir: '', ruc:'', ci: '0', fenaci: '11/11/1111', email: '',  nac: 0, esta:0,ciu:0,gen:0,tipo:0,ope: 'eliminacion'}
            data:{codigo: cod,nom:0,ruc:'',ope:3}
         //   data:{codigo:cod,fecha:'25-02-2016',especialidad:'',funcionario:0,profesion:0,ope:'activar'}
            ///select * from sp_especialidades(4,'25-02-2016','esp',1,1,'desactivar')
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
              data:{codigo: cod,nom:0, ruc:'',ope:4}
           
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
                $("#proveedor_edit").val(dame.cli_cod).trigger('change');
                $("#ruc_edit").val(dame.cli_ruc);
                
             });
         });
   });

   $(document).on("click","#btn_edit",function(){
       var cod, pro, ruc
        cod = $("#cod_edit").val();
        pro = $("#proveedor_edit").val();
        ruc = $("#ruc_edit").val();
        if(ruc !=="" && pro !==""){
            $.ajax({
                   type: "POST",
                   url: "grabar.php",
                   data: { codigo: cod, nom:pro,ruc:ruc,ope:2}
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