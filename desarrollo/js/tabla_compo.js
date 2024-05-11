function format ( d ) {
    var x,detalle;
    detalle = '<center><table class="table" cellpadding="5" cellspacing="0" border="0" style="padding-left:50px; color: #ffffff;">' +
        '<thead>' +
        '<tr>' +
        '<td>Cod</td>' +
        '<td>Material</td>' +
         '<td>Materia Prima</td>' +
        '<td>Unidad de medida</td>' +
        '<td>Cantidad</td>' +
        '</tr>' +
        '</thead>' +
        '<tbody>';
    for(x=0; x < d.detalle.length; x++) {
           detalle+= '<tr>' +
            '<td>'+ d.detalle[x].items_cod +'</td>' +
          
            '<td>' + d.detalle[x].descrip + '</td>' +
            '<td>' + d.detalle[x].mat + '</td>' +
            '<td>' + d.detalle[x].uni + '</td>' +
            '<td>'+ d.detalle[x].cantidad +'</td>' +
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
        '</tr>' +
          '</tfoot>' +
        '</table></center>';

    return  detalle
}

$(document).ready(function() {
    var dt = $('#pedido').DataTable( {
        "ajax": "datos.php",
        "columns": [
            {
                "class":          "details-control",
                "orderable":      false,
                "data":           null,
                "defaultContent": ""
            },
            { "data": "cod" },
            { "data": "nro" },
            { "data": "fecha" },
            { "data": "descri" },
            { "data": "estado" },
            { "data": "acciones"}
        ],
        "order": [[1, 'asc']]
    } );

    // Array to track the ids of the details displayed rows
    var detailRows = [];

    $('#pedido tbody').on( 'click', 'tr td.details-control', function () {
        var tr = $(this).closest('tr');
        var row = dt.row( tr );
        var idx = $.inArray( tr.attr('id'), detailRows );

        if ( row.child.isShown() ) {
            tr.removeClass( 'details' );
            row.child.hide();

            // Remove from the 'open' array
            detailRows.splice( idx, 1 );
        }
        else {
            tr.addClass( 'details' );
            row.child( format( row.data() ) ).show();

            // Add to the 'open' array
            if ( idx === -1 ) {
                detailRows.push( tr.attr('id') );
            }
        }
    } );

    // On each draw, loop over the `detailRows` array and show any child rows
    dt.on( 'draw', function () {
        $.each( detailRows, function ( i, id ) {
            $('#'+id+' td.details-control').trigger( 'click' );
        } );
    } );
} );