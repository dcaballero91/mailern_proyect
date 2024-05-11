//Obs: falta la funcion de imprimir
$(function(){

//Path variable para especificar la ruta..

var Path ='imp_ordencompras.php';
var ordencompras = $('#ordencompras').dataTable( {
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
             { "data": "proveedor" },
             { "data": "ruc" },
             { "data": "tipo_factura" },
             { "data": "plazo" },
             { "data": "cuotas" },
             { "data": "estado" }, 
             { "data": "acciones"}
        ]
    } );

ordencompras.fnReloadAjax('datos.php');
 function refrescarDatos(){
      ordencompras.fnReloadAjax();
  }

 var detailRows = [];
      
   $('#ordencompras tbody').on( 'click', 'tr td.details-control', function () {        
        var tr = $(this).closest('tr');
        var row = $('#ordencompras').DataTable().row( tr );
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
    ordencompras.on( 'draw', function () {
        $.each( detailRows, function ( i, cod ) {
            $('#'+cod+' td.details-control').trigger( 'click' );
        } );
    } );
                //TABLA DETALLE
function format ( d ) {
    // `d` is the original data object for the row
    var deta ='<table  class="table table-striped table-bordered nowrap table-hover">\n\
<tr width=90px class="info"><th>Codigo</th><th>Descripcion</th><th>Cantidad</th><th>Precio Unitario</th><th>Subtotal</th></tr>';
    var total=0;
    var subtotal=0;
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
        '<td></td>' + //FILAS ==> <td> 
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
        '<td>'+ total+' Gs.</td>' +
        '</tr>' +
        '</tfoot>' +
        '</table></center>';
                    //AQUI SE CREA LA OPCION PARA IMPRIMIR DENTRO DEL DETALLE...
    return deta+'<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
                <div class="row">'+                
                        
                 '<div class="col-md-2">' +
                    '<div class="col-md-12 pull-center">'+
                       
                   '<a href="../informes/'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                            
                    
                '</div>'+

                '</div>';
}

//El signo << + >> realiza modificacion 


// INSERTAR GRILLA DE ordencompras 

     $("#item").change(function(){
        precio();
        stock();
        marca();
    });


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
            var subtotal=0,a=0;
            //recorremos todas las filas y buscamos la columna (columna es igual a td en html) numero 4
            $("#grilladetalle tbody tr").find("td:eq(4)").each(function() {
                //asignamos el valor de esa columna a la variable a
                        a = $(this).text();
                        //y le asignamos a la variable subtotal el valor resultante
                        //de la suma de subtotal actual + a
                        subtotal = parseInt(subtotal)+parseInt(a);
                    });
                    //y por ultimo mostramos el valor de subtotal
                    //en la fila con id total
             $("#total").html('Total: '+subtotal+' Gs.');
             }else{ //aqui
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

     ///FUNCION Anular

            //esta parte es para que al hacer clic se posicione y me muestre el mensaje de anular
$(document).on("click",".delete",function(){
        var pos = $( ".delete" ).index( this );
        $("#ordencompras tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
            var cod;
            cod = $(this).html();
            $("#delete").val(cod);
            $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea eliminar el Registro Nro. '+cod+' ?</h4>');
        });
    });
        //esta parte es para que al hacer clic pueda anular
    $(document).on("click","#delete",function(){
        var cod = $( "#delete" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
           
            data: {codigo:cod,nro:0,plazo:0,cuotas:0,suc:0,emp:0,usu:0,fun:0,proveedor:0,tipo_factura:0,detalle:'{{1,1,1}}',ope:'anulacion'}
                             // nro:nro,emp:emp,suc:suc,fun:fun,proveedor:proveedor,tipo_factura:tipo_factura,intervalo:intervalo,cuotas:cuotas 
        }).done(function(msg){
            //$('#confirmacion').modal("hide");
           $('#hide').click();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
             refrescarDatos();
        });

    });

// fin Anular


            //FUNCION INSERTAR
// Insert
    $(document).on("click","#grabar",function(){
        
        var nro,plazo,cuotas,suc,emp,usu,fun,proveedor,tipo_factura,detalle;
        nro = $("#nro").val();
        plazo= $("#plazo").val();
        cuotas= $("#cuotas").val();
        suc = $("#sucursal").val();
        emp = $("#empresa").val();
        usu = $("#usuario").val();
        fun = $("#funcionario").val();
        proveedor = $("#proveedor").val();
        tipo_factura= $("#tipo_factura").val();
        detalle = $("#detalle").val();
        
        if(nro!=="",plazo!=="",cuotas!=="",suc!=="",emp!=="",usu!=="",fun!=="",proveedor!=="",tipo_factura!=="",detalle!==""){
       
            $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:0,nro:nro,plazo:plazo,cuotas:cuotas,suc:suc,emp:emp,usu:usu,fun:fun,proveedor:proveedor,tipo_factura:tipo_factura,detalle:detalle,ope:'insercion'}
        }).done(function(msg){
          // alert(msg);
           // location.reload();
           humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
                $("#nro").val('');
                $("#plazo").val('');
                $("#cuotas").val('');
                $("#suc").val('');
                $("#emp").val('');
                 $("#usu").val('');
                $("#fun").val('');
                $("#proveedor").val('');
                $("#tipo_factura").val('');
                $("#detalle").val('');
         refrescarDatos();
        // vaciar();
         });
      }else{
         humane.log("<span class='fa fa-info'></span> Por favor complete primeramente todos los campos en la grilla", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
      }
        });
    
// Insert 

// Insert 

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
            $("#stock").focus();
        });
    }
           
// funciones
 $("#tipo_factura").bind( "change", function(event, ui) {
    var tipo = $("#tipo_factura").val();
    if(tipo==='1'){//CONTADO
        $('#tipo').attr('style','display:none');
        $('#cuo').attr('style','display:none');
        $('#pla').attr('style','display:none');
       // $('#cuotas').attr('style','display:none');
        $('#cant').attr('style','display:compact');
    }else{  ///0 CREDITO
        $('#tipo').attr('style','display:compact');
        $('#pla').attr('style','display:compact');
        $('#cuo').attr('style','display:compact');
       
    }
});

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
// Funciones
$(function () {
    $(".chosen-select").chosen({width: "100%"});  
      
});
});


