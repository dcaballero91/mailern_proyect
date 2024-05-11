$(function(){
     var Path ='imp_reclamos_sugerencias.php';
     var tabla =  $('#reclamos').dataTable({
    "columns":
    [
        {
            "class":          "details-control",
            "orderable":      false,
            "data":           null,
            "defaultContent": "<a><span class='fa fa-plus'></span></a>"
        },
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
    ]
 });
    tabla.fnReloadAjax( 'datos.php' );
    function refrescarDatos(){
        tabla.fnReloadAjax();
    }
    tabla.fnReloadAjax('datos.php');

 var detailRows = [];
      
   $('#reclamos tbody').on( 'click', 'tr td.details-control', function () {        
        var tr = $(this).closest('tr');
        var row = $('#reclamos').DataTable().row( tr );
        var idx = $.inArray( tr.attr('id'), detailRows );
 
        if ( row.child.isShown() ) {
            tr.removeClass( 'details' );
            row.child.hide();
            $(this).html("<a><span class='fa fa-plus'></span></a>");
            // Remove from the 'open' array
            detailRows.splice( idx, 1 );
        }
        else {
            
            tr.addClass( 'details' );
            row.child(format(row.data())).show();
            if ( idx === -1 ) {
                detailRows.push( tr.attr('id') );
            }
            $(this).html("<a><span class='fa fa-minus'></span></a>");
            // Add to the 'open' array
           
        }
    } );
 
    // On each draw, loop over the `detailRows` array and show any child rows
    tabla.on( 'draw', function () {
        $.each( detailRows, function ( i, cod ) {
            $('#'+cod+' td.details-control').trigger( 'click' );
        } );
    } );
 
    function format ( d )
    { 
        // `d` is the original data object for the row
        var deta ='<table  class="table table-striped table-bordered nowrap table-hover">\n\
    <tr width=80px class="info"><th></th><th></th><th></th><th></th><th> </th><th></th></tr>';
        // var total=0;
        // var totalgral = (precio);
        // for(var x=0;x<d.detalle.length;x++){
        //     subtotal = d.detalle[x].cantidad * d.detalle[x].precio;       
        //     total += parseInt(subtotal);

        //     // deta+='<tr>'+
        //     //     '<td width=10px>'+d.detalle[x].codigo+'</td>'+
        //     //     '<td width=80px>'+d.detalle[x].descripcion+'</td>'+
        //     //     '<td width=50px>'+d.detalle[x].marca+'</td>'+
        //     //     '<td width=50px>'+d.detalle[x].cantidad+'</td>'+
                
        //     //     '<td width=50px>'+d.detalle[x].precio+'</td>'+
        //     //     '<td width=10px>' + subtotal + '</td>' +
    
        //     '</tr>';
        //     }
        // deta+= '</tbody>' +
        //     '<tfoot>' +
        //     '<tr>' +
        //     '<td></td>' +
        //     '<td></td>' +
        //     '<td></td>' +
        //     '<td></td>' +
        //     '<td></td>' +
        //     '<td></td>' +
        //     '</tr>' +
        //     '<tr>' +
        //     '<td>Total</td>' +
        //     '<td></td>' +
        //     '<td></td>' +
        //     '<td></td>' +
        //     '<td></td>' +
        //     '<td>'+ total +' Gs.</td>' +
        //     // totales += "<th style=\"text-align: right;\"><h4>"+ totalgral.toLocaleString() +"</h4></th>";
        //     '</tr>' +
        //     '</tfoot>' +
        //     '</table></center>';

    return deta+'<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
                    <div class="row">'+                
                            
                    '<div class="col-md-2">' +
                        '<div class="col-md-12 pull-center">'+
                        
                    '<a href="../informes/'+Path+'?id='+d.codigo+'" target="_blank" class="btn btn-sm btn-primary btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                    //'<a href="'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                        
                    '</div>'+

                    '</div>';
    }
//FIN TABLA




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
                   mostrarMensaje(msg)
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
       $("#reclamos tbody tr:eq("+pos+")").find("td:eq(1)").each(function(){
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
            mostrarMensaje(msg)
           // humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            refrescarDatos();
            }); 
  });


//FIN ELIMINAR

//ANALIZAR
$(document).on("click",".activar",function(){
        var pos = $(".activar").index(this);
        var cod;
       $("#reclamos tbody tr:eq("+pos+")").find("td:eq(1)").each(function(){
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
            mostrarMensaje(msg)
            //humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
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
        $("#reclamos tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
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
            mostrarMensaje(msg)
           // humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
        });
    });

    
//FIN EDITAR
});

function mostrarMensaje(msg){
    var r = msg.split("_/_");
    var texto = r[0];
    var tipo = r[1];

    if(tipo.trim() == 'notice'){
        texto = texto.split("NOTICE:");
        texto = texto[1];

        humane.log("<span class='fa fa-check'></span>"+ texto, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
        // humane.log("<span class='fa fa-check'></span> " + msg, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
    }
    if(tipo.trim() == 'error'){
        texto = texto.split("ERROR:");
        texto = texto[2];

        humane.log("<span class='fa fa-info'></span>"+ texto, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-error'});
    }
}

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
