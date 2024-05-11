
//FUNCIONA TODO!!
//alert(" hola eli ");
$(function(){
var Path ='imp_pedidocompras.php';
//alert(" Hola !! ");
var tabla = $('#tabla').dataTable( {
        "columns": [
            {
                "class":          "details-control",
                "orderable":      false,
                "data":           null,
                "defaultContent": "<a><span class='fa fa-plus'></span></a>"
            },
            { "data": "cod" },
            { "data": "nro" },
            { "data": "fecha" },
            { "data": "suc" },
            { "data": "usu" },
            { "data": "estado" },
            { "data": "acciones"}
        ]
    } );

tabla.fnReloadAjax('datos.php');
 

 var detailRows = [];
      
   $('#tabla tbody').on( 'click', 'tr td.details-control', function () {        
        var tr = $(this).closest('tr');
        var row = $('#tabla').DataTable().row( tr );
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
<tr width=80px class="info"><th>Codigo</th><th>Descripcion</th><th>Cantidad</th><th>Precio Unitario</th><th>Subtotal</th></tr>';
    var total=0;
    var totalgral = (precio);
     for(var x=0;x<d.detalle.length;x++){
         subtotal = d.detalle[x].cantidad * d.detalle[x].precio;
         total += parseInt(subtotal);

        deta+='<tr>'+
            '<td width=10px>'+d.detalle[x].codigo+'</td>'+
            '<td width=80px>'+d.detalle[x].descripcion+'</td>'+
             
            '<td width=50px>'+d.detalle[x].cantidad+'</td>'+
            
            '<td width=50px>'+d.detalle[x].precio+'</td>'+
            '<td width=10px>' + subtotal + '</td>' +
 

        '</tr>';
        }
    deta+= '</tbody>' +
        '<tfoot>' +
        '<tr>' +
        '<td></td>' +
        '<td></td>' +
        '<td></td>' +
        '<td></td>' +
        
         '<td></td>' +
        '</tr>' +
        '<tr>' +
        '<td>Total</td>' +
        '<td></td>' +
       
         '<td></td>' +
        '<td></td>' +
        '<td>'+ total +' Gs.</td>' +
        // totales += "<th style=\"text-align: right;\"><h4>"+ totalgral.toLocaleString() +"</h4></th>";
        '</tr>' +
        '</tfoot>' +
        '</table></center>';

   return deta+'<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
                <div class="row">'+                
                        
                 '<div class="col-md-2">' +
                    '<div class="col-md-12 pull-center">'+
                       
                   '<a href="../informes/'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-primary btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                   //'<a href="'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                    
                '</div>'+

                '</div>';
}


// INSERTAR GRILLA DE PEDIDO Compras
  $(document).on("click",".agregar",function(){
            $("#detalle-grilla").css({display:'block'});
            var producto = $('#item option:selected').html();
            var procod = $('#item').val();
            var cant = $('#cantidad').val();
            var prec = $('#precio').val();
            prec = prec.replace(" Gs.","");
            var subtotal = cant * prec;
            if(procod!=="" && producto!=="" && cant!=="" && prec!=="" && subtotal!==0){  
            var repetido = false;
            var co = 0;
            $("#grilladetalle tbody tr").each(function(index) {
                $(this).children("td").each(function(index2) {
                    if (index2 === 0) {
                        co = $(this).text();
                        if (co === procod) {
                            repetido = true;
                            $('#grilladetalle tbody tr').eq(index).each(function() {
                                $(this).find('td').each(function(i) {
                                    if(i===2){
                                        $(this).text(cant);
                                    }
                                    if(i===3){
                                        $(this).text(prec);
                                    }
                                    if(i===4){
                                        $(this).text(subtotal);
                                    }
                                });
                            });
                        }
                    }
                });
            });
            if (!repetido) {
                $('#grilladetalle > tbody:last').append('<tr class="ultimo"><td>' + procod + '</td><td>' + producto + '</td><td>' + cant + '</td><td>' + prec + '</td><td>' + subtotal + '</td><td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
            }
            }else{ 
 humane.log("<span class='fa fa-info'></span> ATENCION!! Por favor complete todos los campos en la grilla", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
}
        cargargrilla();
        $("#cantidad").val('');
        $("#item").focus();
    });


      $(document).on("click",".eliminar",function(){
        var parent = $(this).parent();
        $(parent).remove();
        cargargrilla();
    });

       function cargargrilla() {
           
        var salida = '{';
        $("#grilladetalle tbody tr").each(function(index) {
            var campo1, campo2, campo3;
            salida = salida + '{';
            $(this).children("td").each(function(index2) {
                switch (index2) {
                    case 0:
                        campo1 = $(this).text();
                        salida = salida + campo1 + ',';
                        break;
                    case 2:
                        campo2 = $(this).text();
                        salida = salida + campo2 + ',';
                        break;
                    case 3:
                        campo3 = $(this).text();
                        salida = salida + campo3;
                        break;
                }
            });
            if (index < $("#grilladetalle tbody tr").length - 1) {
                salida = salida + '},';
            } else {
                salida = salida + '}';
            }
        });
        salida = salida + '}';
        $('#detalle').val(salida);
    }

$(document).on("click",".delete",function(){
        var pos = $( ".delete" ).index( this );
        $("#tabla tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
            var cod;
            cod = $(this).html();
            $("#delete").val(cod);
             $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea eliminar el Registro Nro. '+cod+' ?</h4>');
        });
    });
        //esta parte es para que al hacer clic pueda anular
    $(document).on("click","#delete",function(){
        var id = $( "#delete" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:id,nro:0,val:'11/11/1111',suc:0,emp:0,fun:0,cli:0,detalle:'{{1,1,1}}',ope:'anulacion'}
        }).done(function(msg){
          // $('#confirmacion').modal("hide");
              $("#hide").click();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
             refrescarDatos();
        });

    });
//fin  ANULAR
            //FUNCION INSERTAR
// Insert
    $(document).on("click","#grabar",function(){
        var nro,suc,emp,fun,detalle;
        nro = $("#nro").val();
        suc = $("#suc").val();
        emp = $("#emp").val();
        fun = $("#fun").val();
        detalle = $("#detalle").val();
        var cli = $("#cli").val();
        var val = $("#val").val();

        if(nro!=="",suc!=="",emp!=="",fun!=="",detalle!=="",cli!=="",val!==""){
       
            $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:0,nro:nro,val:val,suc:suc,emp:emp,fun:fun,cli:cli,detalle:detalle,ope:'insercion'}
        }).done(function(msg){
          // alert(msg);
           
           humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
   $("#grilladetalle tbody tr").remove();
        //y vaciamos todos los campos
        $('#fun > option[value=""]').attr('selected',true);
        $('#fun').selectpicker('refresh');
        //vaciar();
        
        //solicitamos el ultimo codigo actual
        //ultcod();
         refrescarDatos();
         //vaciar();
         });
      }else{
         humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
      }
        });
    
// Insert 
            ///FUNCION Anular

 $("#item").change(function(){
        marca();
        precio();
        
        stock();
    });

function marca(){
        var cod = $('#item').val();
        $.ajax({
            type: "POST",
            url: "marcas.php",
            data: {cod: cod}
        }).done(function(marca){
            $("#marca").val(marca);
            $("#cantidad").focus();
        });
    }
    
function stock(){
        var cod = $('#item').val();
        $.ajax({
            type: "POST",
            url: "stock.php",
            data: {cod: cod}
        }).done(function(stock){
            $("#stock").val(stock);
            $("#cantidad").focus();
        });
    }
    function vaciar(){
    $('#item > option[value=""]').attr('selected',true);
    $('#item').selectpicker('refresh');
    $("#precio").val("");
    $("#cantidad").val("");
}


// funciones
    function precio(){
        var cod = $('#item').val();
        $.ajax({
            type: "POST",
            url: "precio.php",
            data: {cod: cod}
        }).done(function(precio){
            $("#precio").val(precio);
            $("#cantidad").focus();
        });
    }
    function refrescarDatos(){
      tabla.fnReloadAjax();
  };
// Funciones
$(function () {
   

    $(".chosen-select").chosen({width: "100%"});
   

});
});

