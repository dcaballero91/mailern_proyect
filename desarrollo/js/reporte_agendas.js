
$(document).on("click",".buscar",function(){
    $("#tabla-reporte").css({display:'block'});
    var desde,hasta,suc,fun, est;
    desde = $("#btn-enabled-date-desde").val();
    hasta = $("#btn-enabled-date-hasta").val();
    est = $("#est").val();
    suc = $("#suc").val();
    fun = $("#fun").val();
    // alert(`${desde} ${hasta} ${suc} ${fun} ${est}`)

    if(desde === "" || hasta === ""){
        humane.log(
            "<span class='fa fa-info'></span> ESTABLEZCA UN RANGO DE FECHA",
            { timeout: 4000, clickToClose: true, addnCls: "humane-flatty-error" }
          );
        return
    }

    if(desde > hasta){
        humane.log(
            "<span class='fa fa-info'></span> La fecha desde no puede ser mayor a la fecha hasta",
            { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-error' }
            );
        return
    }
    $.ajax({
        url : 'datos.php',
        data : { desde:desde,hasta:hasta,suc:suc,fun:fun,est:est },
        type : 'GET',
        success : function(json) {
            // alert(json);
            function format ( d ) {
                var x,detalle,subtotal;
                detalle = '<center><table class="table" cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;color:#ffffff;">' +
                    '<thead>' +
                    '<tr>' +
                    '<td>Cod</td>' +
                    '<td>Dia</td>' +
                    '<td>Hora desde</td>' +
                    '<td>Hora hasta</td>' +
                    // '<td>Subtotal</td>' +
                    '</tr>' +
                    '</thead>' +
                    '<tbody>';
                for(x=0; x < d.detalle.length; x++) {
                    subtotal = d.detalle[x].precio;
                    detalle+= '<tr>' +
                        '<td>'+ d.detalle[x].agen_cod +'</td>' +
                        // '<td>' + d.detalle[x].descri + '</td>' +
                        // '<td>' + d.detalle[x].descrip + '</td>' +
                        
                        '<td>' + d.detalle[x].dia + '</td>' +
                        '<td>'+ d.detalle[x].hdesde +'</td>' +
                        '<td>'+ d.detalle[x].hhasta +'</td>' +
                        // '<td>' + subtotal + '</td>' +
                        '</tr>';
                }
                detalle+= '</tbody>' +
                    '<tfoot>' +
                    '<tr>' +
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
                    
                    // '<td>'+ d.total+'</td>' +
                    '</tr>' +
                    '</tfoot>' +
                    '</table></center>';

                return  detalle
            }

            $(function() {
                var dt = $('#pedido').DataTable({
                    // retrieve: true,
                    destroy: true,
                    // paging: true,
                   "ajax": "datos.php?desde="+desde+"&hasta="+hasta+"&suc="+suc+"&fun="+fun+"&est="+est+"",
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
                        // { "data": "total" },
                        { "data": "acciones"}
                    ],
                    "order": [[1, 'asc']]
                });

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
                });

                // On each draw, loop over the `detailRows` array and show any child rows
                dt.on( 'draw', function () {
                    $.each( detailRows, function ( i, id ) {
                        $('#'+id+' td.details-control').trigger( 'click' );
                    });
                });
            });
        }
    });
});

