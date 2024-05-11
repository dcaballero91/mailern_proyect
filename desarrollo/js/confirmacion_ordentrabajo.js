
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
            { data: "cod" },
            { data: "empresa" },
            { data: "sucursal" },
            { data: "cliente" },
            { data: "funcionario" },
            { data: "estado" },
            { data: "acciones" }
        ],
        language: {
            "sSearch":"Buscar: ",
            "sInfo":"Mostrando resultados del _START_ al _END_ de un total de _TOTAL_ registros",
            "sInfoFiltered": "(filtrado de entre _MAX_ registros)",
            "sZeroRecords":"No hay resultados",
            "sInfoEmpty":"No hay resultados",
            "oPaginate":{
            "sNext":"Siguiente",
            "sPrevious":"Anterior"
          }
        }
    } );

    if(tabla != 'error'){

        tabla.fnReloadAjax('datos.php');
    }


 

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
 
    //ESTE SERA UTILIZADO EN VENTAS 
// function format ( d )
// { 
//     // `d` is the original data object for the row
//     var deta ='<table  class="table table-striped table-bordered nowrap table-hover">\n\
// <tr width=80px class="info"><th>Codigo</th><th>Descripcion</th><th>Marca</th><th>f_fin</th><th>f_ini Unitario</th><th>Subtotal</th></tr>';
//     var total=0;
//     var totalgral = (f_ini);
//      for(var x=0;x<d.detalle.length;x++){
//          subtotal = d.detalle[x].f_fin * d.detalle[x].f_ini;
//          total += parseInt(subtotal);

//         deta+='<tr>'+
//             '<td width=10px>'+d.detalle[x].codigo+'</td>'+
//             '<td width=80px>'+d.detalle[x].descripcion+'</td>'+
//              '<td width=50px>'+d.detalle[x].marca+'</td>'+
//             '<td width=50px>'+d.detalle[x].f_fin+'</td>'+
            
//             '<td width=50px>'+d.detalle[x].f_ini+'</td>'+
//             '<td width=10px>' + subtotal + '</td>' +
 

//         '</tr>';
//         }
//     deta+= '</tbody>' +
//         '<tfoot>' +
//         '<tr>' +
//         '<td></td>' +
//         '<td></td>' +
//         '<td></td>' +
//         '<td></td>' +
//         '<td></td>' +
//          '<td></td>' +
//         '</tr>' +
//         '<tr>' +
//         '<td>Total</td>' +
//         '<td></td>' +
//         '<td></td>' +
//          '<td></td>' +
//         '<td></td>' +
//         '<td>'+ total +' Gs.</td>' +
//         // totales += "<th style=\"text-align: right;\"><h4>"+ totalgral.toLocaleString() +"</h4></th>";
//         '</tr>' +
//         '</tfoot>' +
//         '</table></center>';

//    return deta+'<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
//                 <div class="row">'+                
                        
//                  '<div class="col-md-2">' +
//                     '<div class="col-md-12 pull-center">'+
                       
//                    '<a href="../informes/'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-primary btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
//                    //'<a href="'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                    
//                 '</div>'+

//                 '</div>';
// }

//ESTE SERA UTILIZADO EN VENTAS FIN 

function format(d) {
    // `d` is the original data object for the row
    var deta =
      '<table id="grillaordenes"  class="table table-striped table-bordered nowrap table-hover">\n\
<tr width=80px class="info"><th>Codigo</th><th>Tipo Servicio</th><th>Hora desde</th><th>Hora hasta</th><th>Responsable</th><th>Precio</th><th>Subtotal</th><th>Acciones</th></tr>';
    var total = 0;
    var subtotal = 0;
    for (var x = 0; x < d.detalle.length; x++) {
      subtotal = d.detalle[x].precio; // + d.detalle[x].precio;    ///////*****
      total += parseInt(subtotal);

      deta +=
        "<tr>" +
        "<td width=10px>" +
        d.detalle[x].cod +
        "</td>" +
        "<td width=80px>" +
        d.detalle[x].tservicio +
        "</td>" +
        "<td width=50px>" +
        d.detalle[x].hdesde +
        "</td>" +
        "<td width=50px>" +
        d.detalle[x].hhasta +
        "</td>" +
        "<td width=50px>" +
        d.detalle[x].funcionario +
        "</td>" +
        "<td width=10px>" +
        d.detalle[x].precio +
        "</td>" +
        "<td width=10px>" +
        subtotal +
        "</td>" +
        "<td width=10px>" +
        d.detalle[x].acciones +
        "</td>" +
        "</tr>";
    }
    deta +=
      "</tbody>" +
      "<tfoot>" +
      "<tr>" +
      "<td></td>" +
      "<td></td>" +
      "<td></td>" +
      "<td></td>" +
      "<td></td>" +
      "<td></td>" +
      "<td></td>" +
      "</tr>" +
      "<tr>" +
      "<td>  TOTAL</td>" +
      "<td></td>" +
      "<td></td>" +
      "<td></td>" +
      "<td></td>" +
      // '<td></td>' +
      "<td></td>" +
      "<td>" +
      total +
      " Gs.</td>" +
      "</tr>" +
      "</tfoot>" +
      "</table></center>";

    return (
      deta +
      '<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
                <div class="row">' +
      '<div class="col-md-2">' +
      '<div class="col-md-12 pull-center">' +
      '<a href="../informes/' +
      Path +
      "?id=" +
      d.cod +
      '" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>' +
      //'<a href="'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+

      "</div>" +
      "</div>"
    );
  }

    
// ANULAR ORDENES CON LA CABECERA
$(document).on("click",".delete",function(){
        var pos = $( ".delete" ).index( this );
        $("#tabla tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
            var cod;
            cod = $(this).html();
            $("#delete").val(cod);
             $(".msgC").html('<h4 class="modal-title" id="myModalLabel">Desea eliminar la Orden de Trabajo  Nro. '+cod+' ?</h4>');
        });
    });
        //esta parte es para que al hacer clic pueda anular
    $(document).on("click","#delete",function(){
        var id = $( "#delete" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:id,sucursal:0,cliente:0,usuario:0,detalle:'{}',ope:3}
        }).done(function(msg){
          // $('#confirmacion').modal("hide");
              $("#hide").click();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
            //  refrescarDatos();
        });

    });
// FIN ANULAR ORDENES CON LA CABECERA
    
// ORDENAR ORDENES CON LA CABECERA
$(document).on("click",".ordenar",function(){
        var pos = $( ".ordenar" ).index( this );
        $("#tabla tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
            var cod;
            cod = $(this).html();
            $("#ordenar").val(cod);
             $(".msg2").html('<h4 class="modal-title" id="myModalLabel">Desea confirmar la Orden de Trabajo  Nro. '+cod+' ?</h4>');
        });
    });
        //esta parte es para que al hacer clic pueda anular
    $(document).on("click","#ordenar",function(){
        var id = $( "#ordenar" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:id,sucursal:0,cliente:0,usuario:0,detalle:'{}',ope:2}
        }).done(function(msg){
          // $('#confirmacion').modal("hide");
              $("#hide").click();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
            //  refrescarDatos();
        });

    });
// FIN ORDENAR ORDENES CON LA CABECERA


            ///FUNCION Anular
        $(document).on("click",".ordenart",function(){
            let pos = $(".ordenart").index(this);
            alert(pos)
            $("#grillaordenes tbody tr:eq("+pos+")").find("td:eq(1)").each(function(){
                var cod;
                cod = $("#grillaordenes tbody tr:eq("+pos+")").find("td:eq(1)").html();
                alert(cod)
                $("#delete").val(cod);
                $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea ordenar el Registro Nro. '+cod+' ?</h4>');
                
            })

        })

    $(document).on("click",".ordenar2",function(){
        var pos = $(".ordenar2").index(this);
        alert(pos)
        $("#grillaordenes tbody tr:eq("+pos+")").find("td:eq(1)").each(function(){
            var cod;
            cod = $("#grillaordenes tbody tr:eq("+pos+")").find("td:eq(1)").html();
            $("#delete").val(cod);
             $(".msg2").html('<h4 class="modal-title" id="myModalLabel">Desea ordenar el Registro Nro. '+cod+' ?</h4>');
            
        })

    })
 


  

    function refrescarDatos(){
      tabla.fnReloadAjax();
  };
// Funciones
$(function () {
    $(".chosen-select").chosen({width: "100%"});
});

});

