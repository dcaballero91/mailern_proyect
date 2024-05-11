$(function(){
var Path ='imp_transferencias.php';

var transferencia = $('#transferencia').dataTable( {
        "columns": [
            {
                "class":          "details-control",
                "orderable":      false,
                "data":           null,
                "defaultContent": "<a><span class='fa fa-plus'></span></a>"
            },
            { "data": "nro" },
          //  { "data": "sucursal" },
            { "data": "empresa" },
            { "data": "fecha" },

            { "data": "funcionario" },
            { "data": "vehiculo" },
            { "data": "origen" },
            { "data": "destino" },
            { "data": "estado" },
            { "data": "acciones"}
        ], "order": [[1, 'asc']]
    } );

transferencia.fnReloadAjax('datos.php');
 function refrescarDatos(){
     transferencia.fnReloadAjax();
  };

var detailRows = [];
      
   $('#transferencia tbody').on( 'click', 'tr td.details-control', function () {        
        var tr = $(this).closest('tr');
        var row = $('#transferencia').DataTable().row( tr );
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
    transferencia.on( 'draw', function () {
        $.each( detailRows, function ( i, id ) {
            $('#'+id+' td.details-control').trigger( 'click' );
        } );
    } );
 
function format ( d )
{ 
    // `d` is the original data object for the row
    var deta ='<table  class="table table-striped table-bordered nowrap table-hover">\n\
<tr width=80px class="success"><th>Nro</th><th>Item</th><th>Marca</th><th>Cantidad</th><th>Cantidad Recibida</th><th>Depósito</th></tr>';
    var total=0;
     for(var x=0;x<d.detalle.length;x++){
         subtotal = d.detalle[x].cantidad * d.detalle[x].precio;
         total += parseInt(subtotal);

        deta+='<tr>'+
            '<td width=10px>'+d.detalle[x].nro+'</td>'+
            '<td width=80px>'+d.detalle[x].item+'</td>'+
            '<td width=50px>'+d.detalle[x].marca+'</td>'+
            '<td width=50px>'+d.detalle[x].cantidad+'</td>'+
             '<td width=50px>'+d.detalle[x].recibido+'</td>'+
            '<td width=80px>'+d.detalle[x].deposito+'</td>'+
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
        '<td></td>' +
        '</tr>' +
        '<tr>' +
       
      
        '</tr>' +
        '</tfoot>' +
        '</table></center>';

   return deta+'<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
                <div class="row">'+                
                        
                 '<div class="col-md-2">' +
                    '<div class="col-md-12 pull-center">'+
                       
                   '<a href="../informes/'+Path+'?id='+d.id+'" target="_blank" class="btn btn-sm btn-success btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                   //'<a href="'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                    
                '</div>'+

                '</div>';
}
$(function () {
   

    $(".chosen-select").chosen({width: "100%"});
   

});
});