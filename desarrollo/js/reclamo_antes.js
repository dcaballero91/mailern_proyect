$(function(){

     var tabla =  $('#reclamos').dataTable({
    "columns":
    [
        { "data": "codigo" },
        { "data": "fecha" },
        { "data": "fechareclamo" },
        { "data": "cli" },
        { "data": "tipo" },
        { "data": "reclamo" },
        { "data": "suc" },
        { "data": "usuario" },
        { "data": "estado" },
        { "data": "acciones"}
        // { "data": "empresa" },
        // { "data": "hora" },
    ]
 });
    tabla.fnReloadAjax( 'datos.php' );
    function refrescarDatos(){
        tabla.fnReloadAjax();
    }
////FIN TABLA

//AGREGAR
   

    $(document).on("click","#btnsave",function(){     //#btnsave  es el id del boton  guardar
 
        var tipo = $("#tipo").val();// tipo reclamo el items
        var tipor = $("#rec_sug").val();// tipo reclamo o sugerencia
        var fechareclamo = $("#fechareclamo").val();
        var reclamo = $("#reclamo").val();//descripcion
        var cli = $("#cli").val();
        var sucr = $("#suc").val();
        var suc = $("#sucursal").val();
        var usu = $("#usuario").val();
       
         if(tipo>0 && fechareclamo!=="" && reclamo !=="" && sucr>0 && cli>0 && tipor>0){ 
                $.ajax({
                type: "POST",
                url: "grabar.php",                
                data: {codigo:0,tipo:tipo,tipor:tipor,reclamo:reclamo,sucr:sucr,suc:suc,usu:usu,cli:cli,fechareclamo:fechareclamo,ope:1}
                  }).done(function(msg){
                    var r = msg.split("_/_");
                    console.log("respuesta es= "+r)
                    var texto = r[0];
                    console.log("este es la variable texto "+ texto);
                    var tipo = r[1];
                    console.log("este es el tipo "+tipo);
                    // console.log("su tipo de dato es: "+typeof(tipo));

                    var err = "error";
                    if(tipo.trim() === err ){
                        alert("holaaaa");
                        texto = texto.split("ERROR:");
                        texto = texto[2];
                       console.log("este es el texto2: "+texto);

                        humane.log("<span class='fa fa-check'></span> " + texto, {
                          timeout: 4000,
                          clickToClose: true,
                          addnCls: "humane-flatty-success"
                        });
                    }
                    if (tipo.trim() =='notice'){
                        alert(" hola desde notice ")
                          texto = texto.split("NOTICE:");
                          texto = texto[1];
                  
                        humane.log("<span class='fa fa-check'></span> " + texto, {
                          timeout: 4000,
                          clickToClose: true,
                          addnCls: "humane-flatty-success"
                        });
                    }
                // humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            // $("#btnsave").html("AGREGAR.");

                $('#rec_sug > option[value="0"]').attr('selected',true);
                $("#rec_sug").selectpicker('refresh');
                $('#tipo > option[value="0"]').attr('selected',true);
                $("#tipo").selectpicker('refresh');
                $('#suc > option[value=""]').attr('selected',true);
                $("#suc").selectpicker('refresh');
                $('#cli > option[value=""]').attr('selected',true);
                $("#cli").selectpicker('refresh');
                $("#fechareclamo").val('');
                $("#reclamo").val('');

            refrescarDatos();
            });
           }else{
         humane.log("<span class='fa fa-check'></span> complete los campos por favor", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
            
        }
        });
       
    
//FIN AGREGAR
//ELIMINAR
$(document).on("click",".eliminar",function(){
        var pos = $(".eliminar").index(this);
        var cod;
       $("#reclamos tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
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
           data: {codigo:codigo,tipo:0,tipor:0,reclamo:'',sucr:0,suc:0,usu:0,cli:0,fechareclamo:'11/11/1111',ope:4}//ELIMINACION
        }).done(function(msg){
            $("#cerrar2").click();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            refrescarDatos();
            }); 
  });


//FIN ELIMINAR

//ANALIZAR
$(document).on("click",".activar",function(){
        var pos = $(".activar").index(this);
        var cod;
       $("#reclamos tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
          cod = $(this).html(); 
       });
        $("#okactive").val(cod);  
        $(".msgactive").html('<h4 class="modal-title" id="myModalLabel">Desea Actualizar el estado del movimiento Nro. '+cod+' ?</h4>');
    });

 $(document).on("click","#okactive",function(){
      var codigo = $("#okactive").val();
        $.ajax({
           type: 'POST',
           url: 'grabar.php',
           data: {codigo:codigo,tipo:0,tipor:0,reclamo:'',sucr:0,suc:0,usu:0,cli:0,fechareclamo:'11/11/1111',ope:3}//ESTADO ANALIZADO
        }).done(function(msg){
            $("#hide").click();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            refrescarDatos();
            }); 
  });


//FIN ANALIZAR

//EDITAR
    $(document).on("click",".editar",function(){
        $("#btn_edit").html("Guardar cambios");
        //alert("ok");
        //$("#btn_edit").attr("disabled","disabled");
        var pos = $( ".editar" ).index( this );
        $("#reclamos tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var cod = $(this).html();
            $("#cod_edit").val(cod);
            $.ajax({
                type: 'POST',
                url: 'editar.php',
                async: true,
                data: {cod: cod}
            }).done(function(msg){
                var dame = eval("("+msg+")");
                $("#cod_edit").val(cod);
                $("#tipo_edit").val(dame.tipo_recl_item_cod).trigger('change');// tipo reclamo el items
                $("#rec_sug_edit").val(dame.tipo_reclamo_cod).trigger('change');// tipo reclamo o sugerencia
                $("#fechareclamo_edit").val(dame.reclamo_fecha_cliente);
                $("#reclamo_edit").val(dame.reclamo_desc);//descripcion
                $("#cli_edit").val(dame.cli_cod).trigger('change');
                $("#suc_edit").val(dame.suc_reclamo).trigger('change');

               console.log(dame);
            });
        });
    });

    $(document).on("click","#btn_edit",function(){

        var tipo = $("#tipo_edit").val();// tipo reclamo el items
        var tipor = $("#rec_sug_edit").val();// tipo reclamo o sugerencia
        var fechareclamo = $("#fechareclamo_edit").val();
        var reclamo = $("#reclamo_edit").val();//descripcion
        var cli = $("#cli_edit").val();
        var sucr = $("#suc_edit").val();
      
        
        cod = $("#cod_edit").val();
        
        $("#btn_edit").html("Editando...");
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:cod,tipo:tipo,tipor:tipor,reclamo:reclamo,sucr:sucr,suc:0,usu:0,cli:cli,fechareclamo:fechareclamo,ope:2}//MODIFICAR
        }).done(function(msg){
            $('#cerrar').click();
            refrescarDatos();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
        });
    });

    
//FIN EDITAR
});
//Funciones llamar VISTAS...
 $("#suc").change(function(){
        empresa();
       
    });
      
      function empresa(){
        var cod = $('#suc').val();
        $.ajax({
            type: "POST",
            url: "editar.php",
            data: {cod: cod}
        }).done(function(empresa){
            $("#empresa").val(empresa);
            $("#empresa").focus();
        });
    }
