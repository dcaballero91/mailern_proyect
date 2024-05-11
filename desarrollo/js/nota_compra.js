//alert(" llamando!! ");
$(function(){

var Path ='imp_compras.php';
//alert(" llamando!! ");
var dt = $('#pedido').dataTable( {
    
        "columns": [
            {
                "class":          "details-control",
                "orderable":      false,
                "data":           null,
                "defaultContent": "<a><span class='fa fa-plus'></span></a>"
            },
            { "data": "codigo" }, 
            { "data": "nro" },
            { "data": "ffactura" },
            { "data": "proveedor" },
            { "data": "plazo" },
            { "data": "estado" },
          //  { "data": "total" },
            
            { "data": "acciones"}
        ]
     
    
} );
dt.fnReloadAjax('datos.php');
 function refrescarDatos(){
      dt.fnReloadAjax();
  }

 var detailRows = [];
      
   $('#pedido tbody').on( 'click', 'tr td.details-control', function () {        
        var tr = $(this).closest('tr');
        var row = $('#pedido').DataTable().row( tr );    
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
   dt.on( 'draw', function () {
        $.each( detailRows, function ( i, id ) {
            $('#'+id+' td.details-control').trigger( 'click' );
        } );
    } );



                //TABLA del DETALLE
function format ( d )
{
    //var x,detalle,subtotal;
    var detalle ='<table  class="table table-striped table-bordered nowrap table-hover">\n\
<tr width=90px class="info"><th>Codigo</th><th>Descripion</th><th>Cantidad</th><th>Precio Unitario</th><th>Tipo Impuesto</th><th>Tipo Iva</th><th>Subtotal</th></tr>';
      var total=0;
      var subtotal;
   for(var x=0;x<d.detalle.length;x++){
           subtotal = d.detalle[x].cantidad * d.detalle[x].precio;
         total += parseInt(subtotal);
         
          detalle+= '<tr>' +
            '<td>'+ d.detalle[x].codigo +'</td>' +
            
            '<td>' + d.detalle[x].descripcion + '</td>' + //OBS:la descripcion llama desde el datos.php ..
           '<td>'+ d.detalle[x].cantidad +'</td>' +
             '<td>' + d.detalle[x].precio + '</td>' +
           
            '<td>' + d.detalle[x].tipoiva + '</td>' +
            '<td>' + d.detalle[x].ivatotal + '</td>' +
             '<td>' + subtotal + '</td>' +
            '</tr>';
    }
     detalle+= '</tbody>' +
        '<tfoot>' +
        '<tr>' +
        '<td></td>' +
        '<td></td>' +
        '<td></td>' +
        '<td></td>' +
        '<td></td>' +
        '<td></td>' +
        '<td></td>' +
        '</tr>' +
        '<tr>' +
        '<td>Total</td>' +
        '<td></td>' +
        //'<td></td>' +
        '<td></td>' +
        '<td></td>' +
        '<td></td>' +
        '<td></td>' +
        //'<td></td>' +
        '<td>'+ total+' Gs.</td>' +
        '</tr>' +
        '</tfoot>' +
        '</table></center>';
                   //AQUI SE CREA LA OPCION PARA IMPRIMIR DENTRO DEL DETALLE...
    return detalle+'<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
                <div class="row">'+                       
                    '<div class="col-md-2">' +
                             '<div class="col-md-12 pull-center">'+
                                 '<a href="../informes/'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                             '</div>'+
                    '</div>'+

                '</div>';
}


// INSERTAR GRILLA DE ordencompras 


//FUNCION DE PRECIO
$(function(){
    $("#item").change(function(){
        precio();
       tipoiva();
       tipoitem();
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
    function tipoiva(){
        var cod = $('#item').val();
        $.ajax({
            type: "POST",
            url: "tipoiva.php",
            data: {cod: cod}
        }).done(function(tipoiva){
            $("#tipoiva").val(tipoiva);
            $("#cantidad").focus();
        });
    }
    function tipoitem(){
        var cod = $('#item').val();
        $.ajax({
            type: "POST",
            url: "tipoitem.php",
            data: {cod: cod}
        }).done(function(tipoitem){
            $("#tipoitem").val(tipoitem);
            $("#cantidad").focus();
        });
    }
    
    
    
    
    
    
} );
// FUNCION DE IVA

//FUNCION GRILLA ;
      $(document).on("click",".agregar",function(){
            $("#detalle-grilla").css({display:'block'});
            var producto = $('#item option:selected').html();
            var procod = $('#item').val();
            var cant = $('#cantidad').val();
            var prec = $('#precio').val();
            prec = prec.replace(" Gs.","");
           var subtotal = cant * prec;
            var repetido = false;
            var co = 0;
            
            var tipoiva = $('#tipoiva').val();
            var ivatotal = subtotal * tipoiva / 100;


            
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
                                    if(i===5){
                                        $(this).text(tipoiva);
                                    }
                                    if(i===6){
                                      $(this).text(ivatotal);
                                    }
                                });
                            });
                        }
                    }
                });
            });
            if (!repetido) {
                $('#grilladetalle > tbody:last').append('<tr class="ultimo"><td>' + procod + '</td><td>' + producto + '</td><td>' + cant + '</td><td>' + prec + '</td><td>' + subtotal + '</td><td>' + tipoiva + '</td><td>' + ivatotal + '</td><td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  blue; color: black;"/></td></tr>');
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
            var campo1, campo2, campo3, campo4, campo5;
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
                        salida = salida + campo3 + ',';
                        break;
                    case 5:
                        campo4 = $(this).text();
                        salida = salida + campo4 + ',';
                        break;                    
                    case 6:
                        campo5 = $(this).text();
                        salida = salida + campo5;
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

            //FUNCION INSERTAR
// Insert
    $(document).on("click",".grabar",function(){
        
        var nro,  emp, suc,usu, fun, proveedor,tfactura,plazo,cuotas,ffactura,detalle;
        nro = $("#nro").val();
        emp = $("#empresa").val();
        suc = $("#sucursal").val();
        usu = $("#usuario").val();
        fun = $("#funcionario").val();
        proveedor = $("#proveedor").val();
        tfactura = $("#tfactura").val();
        plazo = $("#plazo").val();
        cuotas = $("#cuotas").val();
        ffactura = $("#ffactura").val();
        detalle = $("#detalle").val();
        
        if(nro!=="",emp!=="",suc!=="",usu!=="",fun!=="",proveedor!=="",tfactura!=="",plazo!=="",cuotas!=="",ffactura!=="",detalle!==""){
       
            $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:0,nro:nro,emp:emp,suc:suc,usuario:usu,fun:fun,proveedor:proveedor,tfactura:tfactura,plazo:plazo,cuotas:cuotas,ffactura:ffactura,detalle:detalle,ope:'insercion'}
        }).done(function(msg){
           //alert(msg);
            location.reload();
           humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
              $("#nro").val('');
              $("#emp").val('');
              $("#suc").val('');
              $("#usuario").val('');
              $("#fun").val('');
              $("#proveedor").val('');
              $("#tfactura").val('');
              $("#plazo").val('');
              $("#cuotas").val('');
               $("#ffactura").val('');
              $("#detalle").val('');
         refrescarDatos();
        // vaciar();
         });
      }else{
         humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
     }
      });
    
// Insert 



            ///FUNCION Anular

            //esta parte es para que al hacer clic se posicione y me muestre el mensaje de anular
  $(document).on("click",".delete",function(){
        var pos = $( ".delete" ).index( this );
        $("#pedido tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
            var cod = $(this).html();
            $(".cod_anular").val(cod);
            $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea eliminar el Registro Nro. '+cod+' ?</h4>');
        });
    });
        //esta parte es para que al hacer clic pueda anular
    $(document).on("click","#delete",function(){
        var cod = $("#delete").val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
           
            data: {codigo:cod,nro:0,emp:0,suc:0,usuario:0,fun:0,proveedor:0,tfactura:'',plazo:'',cuotas:'',ffactura:'01-01-2000',detalle:'{{1,1,1}}',ope:'anulacion'}
        //select * from sp_compras (2, 1, 1, 1, 1, 1, 1, 'asd', 'cha', 'ch', '21-01-2014', '{{1,1,1,2,35000,10,1000}}', 'anulacion')
        }).done(function(msg){
             $('#cerrar2').click();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
             refrescarDatos();
        });

    });
    // fin Anular

} );