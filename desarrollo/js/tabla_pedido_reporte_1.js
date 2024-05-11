/**
 * Created by user pc on 04/07/2016.
 */

$(document).on("click",".buscar",function(){
    $("#tabla-reporte").css({display:'block'});
    var desde,hasta,cliente,fun;
    desde = $("#btn-enabled-date-desde").val();
    hasta = $("#btn-enabled-date-hasta").val();
    cliente = $("#cliente").val();
    fun = $("#funcionario").val();
    $.ajax({
        url : 'datos.php',
        data : { desde:desde,hasta:hasta,cliente:cliente,fun:fun },
        type : 'GET',
        success : function(json) {
            alert(json);
            function format ( d ) {
                var x,detalle,subtotal;
                detalle = '<center><table class="table" cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;color:#ffffff;">' +
                    '<thead>' +
                    '<tr>' +
                    '<td>Cod</td>' +
                    
                     '<td>Tipo Servicio</td>' +
                    '<td>Servicio</td>' +
                    '<td>Desde</td>' +
                    '<td>Hasta</td>' +
                    '<td>Precio</td>' +
                    '<td>Subtotal</td>' +
                    '</tr>' +
                    '</thead>' +
                    '<tbody>';
                for(x=0; x < d.detalle.length; x++) {
                    subtotal = d.detalle[x].precio;
                    detalle+= '<tr>' +
                        '<td>'+ d.detalle[x].items_cod +'</td>' +
                        
                        '<td>' + d.detalle[x].descri + '</td>' +
                        '<td>' + d.detalle[x].descrip + '</td>' +
                        '<td>'+ d.detalle[x].desde +'</td>' +
                        '<td>'+ d.detalle[x].hasta +'</td>' +
                        '<td>' + d.detalle[x].precio + '</td>' +
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
                    
                    '</tr>' +
                    '<tr>' +
                    '<td>Total</td>' +
                    '<td></td>' +
                    '<td></td>' +
                    '<td></td>' +
                    '<td></td>' +
                    '<td></td>' +
                    '<td>'+ d.total+'</td>' +
                    '</tr>' +
                    '</tfoot>' +
                    '</table></center>';

                return  detalle
            }

            $(document).ready(function() {
                var dt = $('#pedido').DataTable( {
                    "ajax": "datos.php?desde="+desde+"&hasta="+hasta+"&cliente="+cliente+"&fun="+fun+"",
                    "columns": [
                        {
                            "class":          "details-control",
                            "orderable":      false,
                            "data":           null,
                            "defaultContent": ""
                        },
                        { "data": "cod" },
                        
                        { "data": "fecha" },
                        { "data": "proveedor" },
                         //{ "data": "prov_ape" },
                        { "data": "prov_ruc" },
                        { "data": "estado" },
                        { "data": "total" },
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
        }
    });
});
