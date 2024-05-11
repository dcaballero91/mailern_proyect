//ATENCION = HAY QUE VALIDAR LOS PRECIOS Y LAS FECHAS !!!
//
//
//  select  sp_promociones(1, '25-11-2016', '28-11-2016', '{{1,promos,25000},{2,promos,30000},{3,promos,38000}}','insercion')

$(function () {
    var Path = 'imp_promocion.php';
//alert(" Hola !! ");   //OBS! LO QUE ESTA EN EL DATATABLE ES LO QUE VISUALIZAMOS EN EL HTML..
    var promociones = $('#promociones').dataTable({
        "columns": [
            {
                "class": "details-control",
                "orderable": false,
                "data": null,
                "defaultContent": "<a><span class='fa fa-plus'></span></a>"
            },
            {"data": "cod"},
            {"data": "dfecha"},
            {"data": "feinicio"},
            {"data": "fefin"},
            {"data": "usu"},
            {"data": "estado"},
            {"data": "acciones"}
        ]
    });

    promociones.fnReloadAjax('datos.php');
    function refrescarDatos() {
        promociones.fnReloadAjax();
    }

    var detailRows = [];

    $('#promociones tbody').on('click', 'tr td.details-control', function () {
        var tr = $(this).closest('tr');
        var row = $('#promociones').DataTable().row(tr);
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
    promociones.on('draw', function () {
        $.each(detailRows, function (i, cod) {
            $('#' + cod + ' td.details-control').trigger('click');
        });
    });

    function format(d)
    {
        // `d` is the original data object for the row
        var deta = '<table  class="table table-striped table-bordered nowrap table-hover">\n\
<tr width=40px class="info"><th>Codigo</th><th>Items</th><th>Marca</th><th>Precio Anterior</th><th>Descuento</th><th>tipo Descuento</th><th>Precio Promocion</th><th>Subtotal</th></tr>';
        var total = 0;
       // var subtotal = 0;
        for (var x =0;x<d.detalle.length; x++) {
            subtotal = d.detalle[x].preanterior - d.detalle[x].descuento;    ///////*****
            total += parseInt(subtotal);

            deta += '<tr>' +
                    //'<td width=10px>' + d.detalle[x].cod + '</td>' +
                     '<td width=120px>' + d.detalle[x].cod + '</td>' +
                     '<td width=120px>' + d.detalle[x].tservicio + '</td>' +
                     '<td width=120px>' + d.detalle[x].marcas + '</td>' +
                     '<td width=120px>' + d.detalle[x].preanterior + '</td>' +
                     '<td width=120px>' + d.detalle[x].descuento + '</td>' +
                     '<td width=120px>' + d.detalle[x].tipodesc + '</td>' +
                     '<td width=120px>' + d.detalle[x].prepromo + '</td>' +
                    '<td width=120px>' + subtotal + '</td>' +
                    '</tr>';
        }
        deta += '</tbody>' +
                '<tfoot>' +
                '<tr>' +
                '<td></td>' +
                '<td></td>' +
                '<td></td>' +
                '<td></td>' +
                '<td></td>' +
                '<td></td>' +
                 '<td></td>' +
                '<td></td>' +
                '</tr>' +
                '<tr>' +
                '<td>  TOTAL</td>' +
                '<td></td>' +
                '<td></td>' +
                '<td></td>' +
                '<td></td>' +
                '<td></td>' +
                '<td></td>' +
                 
                '<td>' + total + ' Gs.</td>' +
                '</tr>' +
                '</tfoot>' +
                '</table></center>';

        return deta + '<tfoot><tr><th colspan="6" class="text-center" ></th></tr></tfoot></table>\n\
                <div class="row">' +
                '<div class="col-md-2">' +
                '<div class="col-md-12 pull-center">' +
                '<a href="../informes/' + Path + '?id=' + d.cod + '" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>' +
                //'<a href="'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+

                '</div>' +
                '</div>';
    }


// INSERTAR GRILLA DE Promociones

    $(document).on("click", ".agregar", function () {
        $("#detalle-grilla").css({display: 'block'});
        var tserv = $('#tservicio option:selected').html(); // ITEM DESC
        var marcas = $('#marcas option:selected').html(); // ITEM DESC
        var codtserv = $('#tservicio').val(); // CODIGO ITEM
        var preanterior = parseInt($('#preanterior').val());// PRECIO ITEM
        var marcod = $('#marcas').val();// MARCA
        var descuento = parseInt($('#prepromo').val());// PRECIO PROMOCION """ antes se llamaba prepromo esta variable ""
        var tipoDesc = $('#tipoDescuento').val();
        var tipoDescuento = $('#tipoDescuento option:selected').html();
        //preanterior = preanterior.replace(" Gs.","");
       // prepromo = prepromo.replace(" Gs.","");
       var subtotal = 0;
       if(tipoDesc == '1'){
           subtotal = preanterior - descuento;
       }else if(tipoDesc == '2'){
            var totalDescuento = (preanterior * descuento) / 100;
            subtotal = preanterior - totalDescuento;
       }

       if(tipoDescuento.trim() === 'MONTO'){
                if(descuento >= preanterior){
                    debugger
                    humane.log("<span class='fa fa-info'></span> ATENCION!! El descuento no puede ser mayor al costo del item", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });

                }else{
                    var repetido = false;
                    var co = 0;
                    var co2 = 0;
                
                    if(marcas === 'Elija primero un item con marca'){
                        marcas = "-";
                    }
                    if(codtserv>0  && preanterior>0 && descuento>0 && tipoDesc >0 ){
            
                            $("#grilladetalle tbody tr").each(function (index) {
                                $(this).children("td").each(function (index2) {
                                    if (index2 === 0) {
                                        co = $(this).text();
                                        if (co === codtserv) {
                                            $("#grilladetalle tbody tr").each(function(index) {
                                                $(this).children("td").each(function(index2) {
                                                    if (index2 === 2) {
                                                        co2 = $(this).text();
                                                        co2 = $(this).text();
                                                            co2 = co2.split("-");
                                                            co2 = co2[0].trim();
                                                        if (co2 === marcod) {
                                                            repetido = true;
                                                            $('#grilladetalle tbody tr').eq(index).each(function() {
                                                                $(this).find('td').each(function(i) {
                                                                    // if(i===2){
                                                                    //     $(this).text(marca);
                                                                    // }
                                                                    if(i===3){
                                                                        $(this).text(preanterior);
                                                                    }
                                                                    if(i===4){
                                                                        $(this).text(descuento);
                                                                    }
                                                                    if(i===5){
                                                                        $(this).text(subtotal);
                                                                    }
                                                                    if(i===6){
                                                                        $(this).text(tipoDescuento);
                                                                    }
                                                                });
                                                            });
                                                        }
                                                    }
                                                });
                                            });
                                        //  ----
                                        }
                                    }
                                });
                            });
                        
                            if (!repetido) {
                                $('#grilladetalle > tbody:last').append('<tr class="ultimo"><td>' + codtserv + '</td><td>' + tserv + '</td><td>' + marcas + '</td><td>' + preanterior + '</td><td>' + descuento + '</td><td>'+subtotal+'</td><td>' + tipoDescuento + '</td><td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
                            }
                            cargargrilla();
                            $("#tservicio").val('0').trigger('change');
                            $("#preanterior").val('');
                    }else{
                        humane.log("<span class='fa fa-info'></span> ATENCION!! Por favor complete todos los campos en la grilla", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
                    }
                }
       }else if(tipoDescuento.trim() === 'PORCENTAJE'){
                if(descuento >= 100){
                    humane.log("<span class='fa fa-info'></span> ATENCION!! El descuento no puede ser mayor al 99%", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
                }else{
                    var repetido = false;
                    var co = 0;
                    var co2 = 0;
                
                    if(marcas === 'Elija primero un item con marca'){
                        marcas = "-";
                    }
                    if(codtserv>0  && preanterior>0 && descuento>0 && tipoDesc >0){
            
                            $("#grilladetalle tbody tr").each(function (index) {
                                $(this).children("td").each(function (index2) {
                                    if (index2 === 0) {
                                        co = $(this).text();
                                        if (co === codtserv) {
                                            $("#grilladetalle tbody tr").each(function(index) {
                                                $(this).children("td").each(function(index2) {
                                                    if (index2 === 2) {
                                                        co2 = $(this).text();
                                                        co2 = $(this).text();
                                                            co2 = co2.split("-");
                                                            co2 = co2[0].trim();
                                                        if (co2 === marcod) {
                                                            repetido = true;
                                                            $('#grilladetalle tbody tr').eq(index).each(function() {
                                                                $(this).find('td').each(function(i) {
                                                                    // if(i===2){
                                                                    //     $(this).text(marca);
                                                                    // }
                                                                    if(i===3){
                                                                        $(this).text(preanterior);
                                                                    }
                                                                    if(i===4){
                                                                        $(this).text(descuento);
                                                                    }
                                                                    if(i===5){
                                                                        $(this).text(subtotal);
                                                                    }
                                                                    if(i===6){
                                                                        $(this).text(tipoDescuento);
                                                                    }
                                                                });
                                                            });
                                                        }
                                                    }
                                                });
                                            });
                                        //  ----
                                        }
                                    }
                                });
                            });
                        
                            if (!repetido) {
                                $('#grilladetalle > tbody:last').append('<tr class="ultimo"><td>' + codtserv + '</td><td>' + tserv + '</td><td>' + marcas + '</td><td>' + preanterior + '</td><td>' + descuento + '</td><td>'+subtotal+'</td><td>' + tipoDescuento + '</td><td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
                            }
                            cargargrilla();
                            $("#tservicio").val('0').trigger('change');
                            $("#preanterior").val('');
                    }else{
                        humane.log("<span class='fa fa-info'></span> ATENCION!! Por favor complete todos los campos en la grilla", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
                    }
                }
       }

           
               
            
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
          var campo1, campo2, campo3, campo4, campo5;
            salida = salida + '{';
            $(this).children("td").each(function (index2) {
                switch (index2) {
                    case 0:
                        campo1 = $(this).text();
                        salida = salida + campo1 + ',';
                        break;
                    case 2:
                        if($(this).text() !== '-'){
                            campo2 = $(this).text();
                            campo2 = campo2.split('-');
                            campo2 = campo2[0].trim();
                            salida = salida + campo2 + ',';
                            break;
                        }
                        
                        salida = salida + 0 + ',';
                        break;
                    case 4:
                        campo3 = $(this).text();
                        salida = salida + campo3 + ',';
                        break;

                    case 5:
                        campo4 = $(this).text();
                        salida = salida + campo4 + ',' ;
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
    $(document).on("click", "#grabar", function () {
        var dfecha, feinicio,fefin,usu,suc,prodesc,tipodesc, detalle;
        dfecha = $("#dfecha").val();
        feinicio = $("#feinicio").val();
        fefin = $("#fefin").val();
        usu = $("#usuario").val();
        suc = $("#sucursal").val();
        prodesc = $("#descrip").val();
        tipodesc = $("#tipoDescuento option:selected").html();
        
        detalle = $("#detalle").val();

        if (dfecha !== "", feinicio !== "", fefin !== "", detalle !== "", prodesc !=="" && tipodesc !== "") {

            $.ajax({
                type: "POST",
                url: "grabar.php",
                data: {cod: 0, feinicio: feinicio, fefin: fefin, usu:usu, suc:suc, prodesc:prodesc, detalle: detalle, ope: 1}
                // -- 	ORDEN: codigo, promoinicio, promofin, usucod, succod, promodesc, detalle[], operacion
            }).done(function (msg) {
                mostrarMensaje(msg)
                // humane.log("<span class='fa fa-check'></span> " + msg, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
                
                refrescarDatos();
                 vaciar();
            });
        } else {
            humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
        }
    });



    // ANULAR 
    $(document).on("click", ".delete", function () {
        var pos = $(".delete").index(this);
        $("#promociones tbody tr:eq(" + pos + ")").find('td:eq(1)').each(function () {
            var cod;
            cod = $(this).html();
            $("#delete").val(cod);
            $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea Finalizar la Promocion Nro. ' + cod + ' ?</h4>');
        });
    });
    //esta parte es para que al hacer clic pueda anular
    $(document).on("click", "#delete", function () {
        var id = $("#delete").val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {cod: id, feinicio: '11/11/111', fefin: '11/11/1111', usu:0, suc:0, prodesc:'', detalle: '{}',tipodesc:'', ope: 3}
        }).done(function (msg) {
            $('#hide').click();
            mostrarMensaje(msg)
            // humane.log("<span class='fa fa-check'></span> " + msg, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
            refrescarDatos();
        });

    });
    // FIN ANULAR

    function vaciar(){
        $("#feinicio").val("");
        $("#fefin").val("");
        $("#preanterior").val("");
        $('#tservicio > option[value="0"] ').attr("selected", true); 
        $('#tservicio').selectpicker('refresh');
        $("#prepromo").val(""); 
        $("#descrip").val("");
        $("#grilladetalle tbody tr").remove()
        $("#detalle").val("");
        $("#tipoDescuento").val(0).trigger('change')
    }

    $("#tservicio").change(function(){
        marca();
        precio2();
    })

    $("#marcas").change(function(){
        precio();
    })

function marca(){
let marcas = document.getElementById('marcas');
let fragment = document.createDocumentFragment();

var cod = $('#tservicio').val();
    if(cod > 0){
        $.ajax({
            type: "POST",
            url: "marcas.php",
            data: {cod: cod}
        }).done(function(data){
            // alert(data)
            if(data != 'error'){
            var datos = JSON.parse(data)
                // console.log(datos)
            
                for(const mar of datos){
                const selectItem = document.createElement('OPTION');
                selectItem.setAttribute('value', mar["mar_cod"]);
                selectItem.textContent= `${mar.mar_cod} - ${mar.mar_desc}`;

                fragment.append(selectItem);
                }
                $("#marcas").children('option').remove();

                let opcion = document.createElement('OPTION');
                opcion.setAttribute('value', 0);
                opcion.textContent = 'Elija una marca';

                marcas.insertBefore(opcion, marcas.children[0]);
                marcas.append(fragment);

                marcas.append(fragment);
                $("#marcas").selectpicker('refresh');    
            }else{//SI AUN NO POSEE LA RELACION ITEM- MARCAS
                // humane.log("<span class='fa fa-info'></span>  ESTE ITEM NECESITA TENER UNA MARCA ASIGNADA EN MARCAS - ITEMS ", { timeout: 6000, clickToClose: true, addnCls: 'humane-flatty-error' });

                $("#marcas").children('option').remove();
                let opcion = document.createElement('OPTION');
                    opcion.setAttribute('value', 0);
                    opcion.textContent = 'Elija primero un item con marca';
        
                    marcas.insertBefore(opcion, marcas.children[0]);
                $("#marcas").selectpicker('refresh');

                $("#precio").val("");
              
            } 
        });

    }else{
        $("#marcas").children('option').remove();
        let opcion = document.createElement('OPTION');
            opcion.setAttribute('value', 0);
            opcion.textContent = 'Elija primero un item';

            marcas.insertBefore(opcion, marcas.children[0]);
        $("#marcas").selectpicker('refresh');

        $("#precio").val("")
    }
}



// funciones
// function ultcod(){
// $.ajax({
//     type: 'GET',
//     url: 'ultcod.php'
// }).done(function(msg){
//     $("#nro").val(msg);
// })
// }

function precio(){
    var item = $('#tservicio').val();
    var mar = $('#marcas').val();
    if(mar>0 && item>0){

        $.ajax({
            type: "POST",
            url: "precio.php",
            data: {item:item, mar:mar}
        }).done(function(precio){
            // alert(precio)
            if(precio != 'error'){
                $("#cantidad").focus();
                $("#preanterior").val(precio);
            }
        });
    }
}
function precio2(){
    var item = $('#tservicio').val();
    if(item>0){

        $.ajax({
            type: "POST",
            url: "precio2.php",
            data: {cod:item}
        }).done(function(precio){
            // alert(precio)
            if(precio != 'error'){
                $("#preanterior").val(precio);
            }
        });
    }
}
function mostrarMensaje(msg){
    var r = msg.split("_/_");
    var texto = r[0];
    var tipo = r[1];

    if(tipo.trim() == 'notice'){
        texto = texto.split("NOTICE:");
        texto = texto[1];

        humane.log("<span class='fa fa-check'></span>"+ texto, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
        // humane.log("<span class='fa fa-check'></span> " + msg, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
    }
    if(tipo.trim() == 'error'){
        texto = texto.split("ERROR:");
        texto = texto[2];

        humane.log("<span class='fa fa-info'></span>"+ texto, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-error'});
    }
}

// Funciones
});


