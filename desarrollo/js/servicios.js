$(function(){
 var Path = 'imp_servicios.php';
     var servicios =  $('#servicios').dataTable({
    "columns":
    [
           {
                "class":          "details-control",
                "orderable":      false,
                "data":           null,
                "defaultContent": "<a><span class='fa fa-plus'></span></a>"
            },
        { "data": "cod" },
         { "data": "dfecha" },
        { "data": "fecha" },
        
        { "data": "especialidad" },
        { "data": "cliente" },
         { "data": "ci" },
       { "data": "estado" },
        { "data": "acciones"}
    ]
 });
    servicios.fnReloadAjax( 'datos.php' );
    function refrescarDatos(){
        servicios.fnReloadAjax();
    }
////FIN TABLA

//AGREGAR
   
var detailRows = [];
      
   $('#servicios tbody').on( 'click', 'tr td.details-control', function () {        
        var tr = $(this).closest('tr');
        var row = $('#servicios').DataTable().row( tr );
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
    servicios.on( 'draw', function () {
        $.each( detailRows, function ( i, cod ) {
            $('#'+cod+' td.details-control').trigger( 'click' );
        } );
    } );
 
function format(d)
    {
        // `d` is the original data object for the row
        var deta = '<table  class="table table-striped table-bordered nowrap table-hover">\n\
<tr width=80px class="info"><th>Codigo</th><th>Tipo Servicio</th><th>Descripcion</th><th>Precio</th><th>Subtotal</th></tr>';
        var total = 0;
       // var subtotal = 0;
        for (var x =0;x<d.detalle.length; x++) {
            subtotal = d.detalle[x].sprecio; // - d.detalle[x].prepromo;    ///////*****
            total += parseInt(subtotal);

            deta += '<tr>' +
                    //'<td width=10px>' + d.detalle[x].cod + '</td>' +
                     '<td width=180px>' + d.detalle[x].cod + '</td>' +
                     '<td width=180px>' + d.detalle[x].tservicio + '</td>' +
                     '<td width=180px>' + d.detalle[x].descrip + '</td>' +
                     '<td width=180px>' + d.detalle[x].sprecio + '</td>' +
                   //  '<td>' + d.detalle[x].prepromo + '</td>' +
                    '<td width=180px>' + subtotal + '</td>' +
                    '</tr>';
        }
        deta += '</tbody>' +
                '<tfoot>' +
                '<tr>' +
            //    '<td></td>' +
                '<td></td>' +
                '<td></td>' +
                '<td></td>' +
                '<td></td>' +
                 '<td></td>' +
               //  '<td></td>' +
                '</tr>' +
                '<tr>' +
                '<td>  TOTAL</td>' +
                '<td></td>' +
                '<td></td>' +
                '<td></td>' +
               // '<td></td>' +
//               '<td></td>' +
                 
                '<td>' + total + ' Gs.</td>' +
                '</tr>' +
                '</tfoot>' +
                '</table></center>';

        return deta + '<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
                <div class="row">' +
                '<div class="col-md-2">' +
                '<div class="col-md-12 pull-center">' +
                '<a href="../informes/' + Path + '?id=' + d.cod + '" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>' +
                //'<a href="'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+

                '</div>' +
                '</div>';
    }


// INSERTAR GRILLA DE SERVICIOS

    $(document).on("click", ".agregar", function () {
        $("#detalle-grilla").css({display: 'block'});
        var codtserv = $('#tservicio').val();
        var tserv = $('#tservicio option:selected').html();
        var descrip = $('#descrip').val();
        var sprecio = $('#sprecio').val();

       // var preanterior = $('#preanterior').val();
       // var prepromo = $('#prepromo').val();
        //preanterior = preanterior.replace(" Gs.","");
       // prepromo = prepromo.replace(" Gs.","");
        var subtotal = sprecio;
        var repetido = false;
        var co = 0;


        $("#grilladetalle tbody tr").each(function (index) {
            $(this).children("td").each(function (index2) {
                if (index2 === 0) {
                    co = $(this).text();
                    if (co === codtserv) {
                        repetido = true;
                        $('#grilladetalle tbody tr').eq(index).each(function () {
                            $(this).find('td').each(function (i) {
                                if (i === 1) {
                                    $(this).text(tserv);
                                }
                               
                                if (i === 2) {
                                    $(this).text(sprecio);
                                }
                               
                                   if (i === 3) {             //(2,1,'19-12-2016', '{{1,1,25000,servicio}}','insercion')
                                    $(this).text(descrip);
                                }
                                if (i === 5) {
                                    $(this).text(subtotal);
                                }
                            });
                        });
                    }
                }
            });
        });
        if (!repetido) {
            $('#grilladetalle > tbody:last').append('<tr class="ultimo"><td>' + codtserv + '</td><td>' + tserv + '</td><td>' + sprecio + '</td><td>' + descrip + '</td><td>' + subtotal + '</td><td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
        }
        cargargrilla();
        $("#preanterior").val(''); ////////////////////veeeeeeeeeeeerrrrrRRRRRRRRRRRRR
        $("#tservicio").focus(); 
       // $("#prepromo").focus();   ////////////////////veeeeeeeeeeeerrrrrRRRRRRRRRRRRR
    });


    $(document).on("click", ".eliminar", function () {
        var parent = $(this).parent();
        $(parent).remove();
        cargargrilla();
    });

//function cargargrilla ---> Ordena de Acuerdo a nuestro Sp de nuestra BD...
    function cargargrilla() {

        var salida = '{';
        $("#grilladetalle tbody tr").each(function (index) {
          var campo1, campo2, campo3 , campo4;
            salida = salida + '{';
            $(this).children("td").each(function (index2) {
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
                        salida = salida + campo3 + ',' ;
                        break;
               
                 case 4:
                        campo4 = $(this).text();
                        salida = salida + campo4  ;
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
    $(document).on("click", "#grabar", function () {
        var especialidad, fecha, dfecha,cliente, detalle;
        fecha = $("#fecha").val();
        dfecha = $("#dfecha").val();
        especialidad = $("#especialidad").val();
        cliente = $("#cliente").val();
        detalle = $("#detalle").val();

      //  if (dfecha !== "", feinicio !== "", fefin !== "", detalle !== "") {

            $.ajax({
                type: "POST",
                url: "grabar.php",
                data: {codigo: 0, especialidad: especialidad, fecha: fecha,dfecha: dfecha,cliente:cliente, detalle: detalle, ope: 'insercion'}
            }).done(function (msg) {
                alert(msg);
                location.reload();
              //  humane.log("<span class='fa fa-check'></span> " + msg, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
               // $("#dfecha").val();
              //  $("#feinicio").val();
               // $("#fefin").val();
              //  $("#detalle").val();
              //  refrescarDatos();
                
            });
      //  } else {
       //     humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
      //  }
    });



// Insert 

    $(document).on("click", ".delete", function () {
        var pos = $(".delete").index(this);
        $("#servicios tbody tr:eq(" + pos + ")").find('td:eq(1)').each(function () {
            var cod;
            cod = $(this).html();
            $("#delete").val(cod);
            $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea eliminar el Registro Nro. ' + cod + ' ?</h4>');
        });
    });
    //esta parte es para que al hacer clic pueda anular
    $(document).on("click", "#delete", function () {
        var id = $("#delete").val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo: id, especialidad:0,fecha: '21-02-2016',cliente:0, detalle: '{}', ope: 'fin'}
        }).done(function (msg) {
            // $('#confirmacion').modal("hide");
            $('#hide').click();

            humane.log("<span class='fa fa-check'></span> " + msg, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
             refrescarDatos();
            //location.reload();
        });

    });
//fin  ANULAR

    ///FUNCION Anular

    //esta parte es para que al hacer clic se posicione y me muestre el mensaje de anular


    $("#tservicio").change(function () {
        precio();
   });



// funciones
    function precio() {
        var cod = $('#tservicio').val();
        $.ajax({
          type: "POST",
          url: "precio.php",
            data: {cod: cod}
      }).done(function (precio) {
            $("#precio").val(precio);
            $("#tservicio").focus();
        });
    }


// Funciones
});