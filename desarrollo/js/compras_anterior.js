//alert(" llamando!! ");
//esta parte es para que al hacer clic se posicione y me muestre el mensaje de anular



    
//alert(" llamando!! ");
    $(document).ready(function() {
        var Path = 'imp_compras.php';
        var dt = $('#tabla').dataTable({
        "columns": [
            {
                "class": "details-control",
                "orderable": false,
                "data": null,
                "defaultContent": "<a><span class='fa fa-plus'></span></a>"
            },
            {"data": "codigo"},
            {"data": "nro"},
            {"data": "ffactura"},
            {"data": "proveedor"},
            {"data": "plazo"},
            {"data": "estado"},
            // { "data": "total" },

            {"data": "acciones"}
        ]


    });
    dt.fnReloadAjax('datos.php');
    function refrescarDatos() {
        dt.fnReloadAjax();
    }
    
    $(document).on("click", ".delete", function () {
    var pos = $(".delete").index(this);
    $("#tabla tbody tr:eq(" + pos + ")").find('td:eq(1)').each(function () {
        var codigo = $(this).html();
        $("#cod_eliminar").val(codigo);
        $(".msg").html('<h4 class="modal-title" id="myModalLabel">DESEA ELIMINAR EL REGISTRO NROº. ' + codigo + ' ?</h4>');
    });
});
//esta parte es para que al hacer clic pueda anular
$(document).on("click", "#delete", function () {
   // var codigo = $("#delete").val();
      var codigo = $("#cod_eliminar").val();
    $.ajax({
        type: "POST",
        url: "grabar.php",
        // data: {codigo:codigo, ope: 'anulacion'}
        data: {codigo:codigo, nro: 0, empresa: 0, sucursal: 0, usuario: 0, funcionario: 0, proveedor: 0, tipofact: '', plazo: 0, cuotas: 0, ffactura: '01-01-2017',timbrado:0,cboiddeposito:0, detalle: '{{1,1,1}}', ope: 2}
        //select * from sp_compras (2, 1, 1, 1, 1, 1, 1, 'asd', 'cha', 'ch', '21-01-2014', '{{1,1,1,2,35000,10,1000}}', 'anulacion')
    }).done(function (msg) {
        $('#hide').click();
        humane.log("<span class='fa fa-check'></span> " + msg, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
        refrescarDatos();
    });
});
// fin Anular

    var detailRows = [];
    $('#tabla tbody').on('click', 'tr td.details-control', function () {
        var tr = $(this).closest('tr');
        var row = $('#tabla').DataTable().row(tr);
        var idx = $.inArray(tr.attr('id'), detailRows);
        if (row.child.isShown()) {
            tr.removeClass('details');
            row.child.hide();
            $(this).html("<a><span class='fa fa-plus'></span></a>");
            // Remove from the 'open' array
            detailRows.splice(idx, 1);
        }
        else {

            tr.addClass('details');
            row.child(format(row.data())).show();
            if (idx === -1) {
                detailRows.push(tr.attr('id'));
            }
            $(this).html("<a><span class='fa fa-minus'></span></a>");
            // Add to the 'open' array

        }
    });
    // On each draw, loop over the `detailRows` array and show any child rows
    dt.on('draw', function () {
        $.each(detailRows, function (i, id) {
            $('#' + id + ' td.details-control').trigger('click');
        });
    });
    
    //TABLA del DETALLE
    function format(d){
        //var x,detalle,subtotal;
        var detalle = '<table  class="table table-striped table-bordered nowrap table-hover">\n\
<tr width=90px class="success"><th>Codigo</th><th>Descripción</th><th>Marca</th><th>Deposito</th><th>Cantidad</th><th>Precio Unitario</th><th>Exenta</th><th>Grav 5</th><th>Grav 10</th><th>Subtotal</th></tr>';
        var total = 0;
        var subtotal;
        for (var x = 0; x < d.detalle.length; x++) {
           subtotal = d.detalle[x].cantidad * d.detalle[x].precio;
           total += parseInt(subtotal);
            detalle += '<tr>' +
                    '<td>' + d.detalle[x].codigo + '</td>' +
                    '<td>' + d.detalle[x].item + '</td>' + //OBS:la descripcion llama desde el datos.php ..
                    '<td>' + d.detalle[x].marca + '</td>' +
                    '<td>' + d.detalle[x].cboiddeposito + '</td>' +
                    '<td>' + d.detalle[x].cantidad + '</td>' +
                    '<td>' + d.detalle[x].precio + '</td>' +
                    '<td>' + d.detalle[x].exenta + '</td>' +
                    '<td>' + d.detalle[x].grav5 + '</td>' +
                    '<td>' + d.detalle[x].grav10 + '</td>' +

                  //  '<td>' + totalgral.toLocaleString() + '</td>' +
                    '</tr>';
        }
        detalle += '</tbody>' +
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
               '<td></td>' +
                '<td></td>' +
                //'<td></td>' +
                '<td>' + total + ' Gs.</td>' +
                '</tr>' +
                '</tfoot>' +
                '</table></center>';
        //AQUI SE CREA LA OPCION PARA IMPRIMIR DENTRO DEL DETALLE...
        return detalle + '<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
                <div class="row">' +
                '<div class="col-md-2">' +
                '<div class="col-md-12 pull-center">' +
                '<a href="../informes/' + Path + '?id=' + d.cod + '" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>' +
                '</div>' +
                '</div>' +
                '</div>';
    }

});

// INSERTAR GRILLA DE ordencompras 
$(document).on("click","#grabar",function(){
  //alert("boton");
//$(document).on("click",".agregar",function agregar_fila(){
   //         $("#detalle-grilla").css({display:'block'});
//
    var nro, emp, suc, usu, fun, proveedor, tfactura, plazo, cuotas, ffactura,timbrado,deposito,detalle;
    nro = $("#nro").val();
    emp = $("#empresa").val();
    suc = $("#sucursal").val();
    usu = $("#usuario").val();
    fun = $("#funcionario").val();
    proveedor = $("#proveedor").val();
    tfactura = $("#tipofact").val();
    plazo = $("#plazo").val();
    cuotas = $("#cuotas").val();
    ffactura = $("#ffactura").val();
    timbrado = $("#timbrado").val();
   deposito = $("#cboiddeposito").val();
   
    detalle = $("#detalle").val();
      
    //if (nro !== "", emp !== "", suc !== "", usu !== "", fun !== "", proveedor !== "", tfactura !== "", plazo !== "", cuotas !== "", ffactura !== "", timbrado !== "",  cboiddeposito !== "",detalle !== "") {
//(integer, integer, integer, integer, integer, integer, integer, character varying, integer, integer, date, integer, integer, text[], integer)
      // alert("boton21");
       $.ajax({
            type: "POST",
            url: "grabar.php",//SELECT public.sp_comp(4,4,1,1,1,1,1,'CONTADO','0','1','09-06-2018',1,1,'{{4,1,1,1,15000}}',1);
            data: {codigo: 0, nro: nro, empresa: emp, sucursal: suc, usuario: usu, funcionario: fun, proveedor: proveedor, tipofact: tfactura, plazo: plazo, cuotas: cuotas, ffactura: ffactura,timbrado:timbrado, cboiddeposito:deposito,detalle: detalle, ope:1}
        }).done(function (msg) {
            alert(msg);
            
              location.reload();
//           humane.log("<span class='fa fa-check'></span> " + msg, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
//           $("#nro").val('');
//           $("#emp").val('');
//           $("#suc").val('');
//           $("#usuario").val('');
//           $("#fun").val('');
//           $("#proveedor").val('');
//           $("#tfactura").val('');
//           $("#plazo").val('');
//           $("#cuotas").val('');
//           $("#ffactura").val('');
//           $("#cboiddeposito").val('');
//           $("#detalle").val('');
//           refrescarDatos();
           // vaciar();
       });
//   } else {
//      humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
});





   function cargargrilla() {
        var salida = '{';
        $("#grilladetalle tbody tr").each(function(index) {
            var campo1, campo2, campo3, campo4;   //,campo5;
            salida = salida + '{';
            $(this).children("td").each(function(index2) {
                switch (index2) {
                    case 0: //codigo
                        campo1 = $(this).text().replace(".","");
                        salida = salida + campo1 + ',';
                        break;
                    case 2://cantidad de acuerdo a la grilla de la interfaz
                        campo2 = $(this).text().replace(".","");
                        salida = salida + campo2 + ',';
                        break;
                    case 3://precio
                        campo3 = $(this).text().replace(".","");
                        salida = salida + campo3 + ',';
                        break;
                    case 4://exenta
                        campo4 = $(this).text().replace(".","");
                        salida = salida + campo4;
                        break;
                    
//                    case 5:
//                        campo5 = $(this).text();
//                        salida = salida + campo5;
//                        break;
                }
            });
            if (index < $("#grilladetalle tbody tr").length - 1) {
                salida = salida + '},';
            } else {
                salida = salida + '}';
            }
        });
        salida = salida + '}';  //la ultima llave del array
        $('#detalle').val(salida);
    }
    
//FUNCION INSERTAR
// Insert
 
// Insert 










// FUNCION DE IVA
function calcularTotales() {
    var exe = 0;
    var g5 = 0;
    var g10 = 0;
    $("#grilladetalle tbody tr").each(function (fila) {
        $(this).children("td").each(function (col) {
            if (col === 4) {
                exe = exe + parseInt($(this).text().replace(/\./g, ""));
            }
            if (col === 5) {
                g5 = g5 + parseInt($(this).text().replace(/\./g, ""));
            }
            if (col === 6) {
                g10 = g10 + parseInt($(this).text().replace(/\./g, ""));
            }
        });
    });
    var totales = "<tr>";
    totales += "<th colspan=\"4\">SUB TOTALES</th>";
    totales += "<th style=\"text-align: right;\">" + exe.toLocaleString() + "</th>";
    totales += "<th style=\"text-align: right;\">" + g5.toLocaleString() + "</th>";
    totales += "<th style=\"text-align: right;\">" + g10.toLocaleString() + "</th>";
    totales += "<th></th>";
    totales += "</tr>";
    var iva5 = Math.round((g5 / 21));
    var iva10 = Math.round((g10 / 11));
    totales += "<tr>";
    totales += "<th colspan=\"5\">LIQUIDACION DE IVA</th>";
    totales += "<th style=\"text-align: right;\">" + iva5.toLocaleString() + "</th>";
    totales += "<th style=\"text-align: right;\">" + iva10.toLocaleString() + "</th>";
    totales += "<th style=\"text-align: right;\"></th>";
    totales += "</tr>";
    var totaliva = Math.round((g5 / 21) + (g10 / 11));
    totales += "<th colspan=\"6\">TOTAL DE IVA</th>";
    totales += "<th style=\"text-align: right;\">" + totaliva.toLocaleString() + "</th>";
    totales += "<th></th>";
    totales += "</tr>";
//
//      var totalgral = (exe + g5 + g10);
 //   totales += "<tr class=\"danger\">";
 //   totales += "<th colspan=\"6\"><h4>TOTAL DESCUENTO</th>";
  //  totales += "<th style=\"text-align: right;\">" + totalgral.toLocaleString() + "</th>";
  //  totales += "<th></th>";
  //  totales += "</tr>";
//    
    var totalgral = (exe + g5 + g10);
    totales += "<tr class=\"danger\">";
    totales += "<th colspan=\"6\"><h4>TOTAL GENERAL</h4></th>";
    totales += "<th style=\"text-align: right;\"><h4>" + totalgral.toLocaleString() + "</h4></th>";
    totales += "<th><h4></h4></th>";
    totales += "</tr>";

    $("#grilladetalle tfoot").html(totales);
}

$(function () {
    $('#cantidad').keypress(function (e) {
        if (e.which === 13) {
            //cargargrilla();
        }
    });

    $(".chosen-select").chosen({width: "100%"});
   

    // getMercaderias();

    calcularTotales();
});

// function getMercaderias() {
//     var dep = $('#cboiddeposito').val();
//     //alert(dep);
//     var ajax_load = "<div class='progress'>" + "<div id='progress_id' class='progress-bar progress-bar-striped active' " +
//             "role='progressbar' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100' style='width: 45%'>" +
//             "Cargando...</div></div>";
//     $("#prog").html(ajax_load);



//     $.post("item.php", {dep_cod: dep})
//             .done(function (data) {
//                 //alert(data);
//                 var ajax_load = "<div class='progress'>" + "<div id='progress_id' class='progress-bar progress-bar-striped active' " +
//                         "role='progressbar' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100' style='width: 100%'>" +
//                         "Completado</div></div>";
//                 $("#prog").html(ajax_load);
//                 setTimeout('$("#prog").html("")', 1000);
//                 $("#item").html(data).trigger('chosen:updated');
//                 merselect();

//             });

// }


function tiposelect() {
    if ($("#tipofact").val() === "CONTADO") {
        $('#plazo').attr('disabled', 'true');
        $('#plazo').val('0');
        $('#cuotas').attr('disabled', 'true');
        $('#cuotas').val('1');
    } else {
        $('#plazo').removeAttr('disabled');
        $('#cuotas').removeAttr('disabled');
    }
}


// function merselect() {

//     var cod = $("#item").val();
//     //bootbox.alert("EL ID ES: "+id);
//     var dat = cod.split("~");
//     //alert(id);
//     //var letra = NumeroALetras(parseInt(dat[1]));
//     //alert(letra);
//     $("#precio").val(dat[1]);
//     $("#tipoimpuesto").val(dat[2]);
//     $("#stock").val(dat[3]);
//     $("#tipoitem").val(dat[4]);
//     $('#cantidad').select();
// }



     $(document).on("click",".agregar",function agregar_fila(){
            $("#detalle-grilla").css({display:'block'});
   
    var itemdesc = $('#item option:selected').html();
            var items = $('#item').val();
            var producto = items.split('~');
            var cant = parseInt($('#cantidad').val());
            var prec = parseInt($('#precio').val());
            var exenta = 0;
            var grav5 = 0;
            var grav10 = 0;
            //$("#cboiddeposito").attr("disabled","true").trigger('chosen:updated');
          //  $("#cboiddeposito").attr("enable","true").trigger('chosen:updated');

            if (producto[2] === 'EXENTA') {
                exenta = cant * prec;
                grav5 = 0;
                grav10 = 0;
            } else if (producto[2] === 'GRAVADA 5') {
                exenta = 0;
                grav5 = cant * prec;
                grav10 = 0;
            } else if (producto[2] === 'GRAVADA 10') {
                exenta = 0;
                grav5 = 0;
                grav10 = cant * prec;
            }

            var repetido = false;
            var co = 0;
            var contador = 0;
            
            //if (parseInt(producto[3]) < parseInt(cant)) {
//                bootbox.confirm('SOLO HAY ' + producto[3] + ' EN STOCK ESTE PRODUCTO. ¿DESEA VENDER TODOS?',function (resp){
//                    if(resp){
//                        $('#cantidad').val(producto[3]);
//                        agregar_fila();
//                    }else{
//                        $('#cantidad').val("");
//                    }
//                });
                
           // } else {
                $("#grilladetalle tbody tr").each(function (index) {
                    $(this).children("td").each(function (index2) {
                        if (index2 === 0) {
                            co = $(this).text();
                            if (co === producto[0]) {
                                repetido = true;
                                $('#grilladetalle tbody tr').eq(index).each(function () {
                                    $(this).find('td').each(function (i) {
                                        if (i === 2) {
                                            //var cantgrilla = parseInt($(this).html());
                                            
                                            $(this).text(cant.toLocaleString());
                                        }
                                        if (i === 3) {

                                            $(this).text(prec.toLocaleString());
                                        }
                                        if (i === 4) {
                                            //exenta = (exenta+parseInt($(this).text().replace(/\./g,"")));
                                            $(this).text(exenta.toLocaleString());
                                        }
                                        if (i === 5) {
                                            //grav5 = (grav5+parseInt($(this).text().replace(/\./g,"")));
                                            $(this).text(grav5.toLocaleString());
                                        }
                                        if (i === 6) {
                                            //grav10 = (grav10+parseInt($(this).text().replace(/\./g,"")));
                                            $(this).text(grav10.toLocaleString());
                                        }

                                    });
                                });
                            }
                        }

                    });
                });

                if (!repetido) {
                    $('#grilladetalle > tbody:last').append('<tr><td style="text-align: center;">' + producto[0] + '</td><td>' + itemdesc + '</td><td style="text-align: center;">' + cant.toLocaleString() + '</td><td style="text-align: right;">' + prec.toLocaleString() + '</td><td style="text-align: right;">' + exenta.toLocaleString() + '</td><td style="text-align: right;">' + grav5.toLocaleString() + '</td><td style="text-align: right;">' + grav10.toLocaleString() + '</td><td style="text-align: right;" onclick="eliminarfila($(this).parent())"><button type="button" class="btn btn-danger btn-xs"><span class="glyphicon glyphicon-remove"></span></button></td></tr>');
                    contador++;
                }
                calcularTotales();
                cargargrilla();
                $('#cantidad').val("");
            //}
});

$(function () {
    $('#agregar').keypress(function (e) {
        if (e.which === 13) {
            agregar_fila();
        }
    });

    $(".chosen-select").chosen({width: "100%"});  
    
    // getMercaderias();
    tiposelect();
    calcularTotales();
    
});

function eliminarfila(parent) {
    $(parent).remove();
    calcularTotales();
}


$("#proveedor").change(function(){
    timbrado_proveedor()
});

function timbrado_proveedor(){
    var prov = $("#proveedor").val();
    const fragment = document.createDocumentFragment()
    $.ajax({
        type: 'POST',
        url: 'timbrado_prov.php',
        data:{prov:prov}
    }).done(function(timbrado){
        let prov_tim = JSON.parse(timbrado);
         console.log(prov_tim);
        let timbrado2 = $("#timbrado2");
            
            for(const prov of prov_tim){
                console.log(prov.prov_timb_nro);
            const selectItem = document.createElement('OPTION');
            selectItem.setAttribute('value', prov["prov_timb_nro"]);
            selectItem.textContent= `${prov.prov_timb_nro}`;

            fragment.append(selectItem);
            }
            // if(timbrado2.children[timbrado2.index[0]].value === undefined ){        
            //     timbrado2.removeChild(timbrado2.children[0])
            // }
                timbrado2.append(fragment).trigger('change');
                // console.log(timbrado2.children("0").)
            
    });
}