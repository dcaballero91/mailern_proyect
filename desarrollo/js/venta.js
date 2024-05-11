
$(document).ready(function() {
        var Path = 'imp_ventas.php';
        var dt = $('#tabla').dataTable({
        "columns": [
            {
                "class": "details-control",
                "orderable": false,
                "data": null,
                "defaultContent": "<a><span class='fa fa-plus'></span></a>"
            },
            {"data": "codigo"},
            // {"data": "nro"},
            {"data": "ffactura"},
            {"data": "cliente"},
            {"data": "tipofactcod"},
            {"data": "estado"},
            { "data": "usuario" },
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
      var codigo = $("#cod_eliminar").val();
    $.ajax({
        type: "POST",
        url: "grabar.php",
        data: {codigo: codigo, sucursal: 0, usuario: 0, cliente: 0, tipofact: 0, plazo: 0, cuotas: 0, detalle: '{}', detalle2: '{}', ope:2}
    }).done(function (msg) {
        $('#hide').click();
        // humane.log("<span class='fa fa-check'></span> " + msg, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
        mostrarMensaje(msg);
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
<tr width=90px class="success"><th>Codigo</th><th>Descripción</th><th>Marca</th><th>Sección</th><th>Cantidad</th><th>Precio Unitario</th><th>Exenta</th><th>Grav 5</th><th>Grav 10</th><th>Subtotal</th></tr>';
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

//aqui estaba el cierre

// INSERTAR GRILLA DE ordencompras 
$(document).on("click","#grabar",function(){
  //alert("boton");
//$(document).on("click",".agregar",function agregar_fila(){
   //         $("#detalle-grilla").css({display:'block'});
//
    var nro, emp, suc, usu, fun, cliente, tfactura, plazo, cuotas, apercier,timbrado,deposito,detalle,detalle2;
    nro = $("#nro").val();
    // emp = $("#empresa").val();
    suc = $("#sucursal").val();
    usu = $("#usuario").val();
    // fun = $("#funcionario").val();
    cliente = $("#cliente").val();
    tfactura = $("#tipofact").val();
    nrofactura = $("#nrofact").val();
    plazo = $("#plazo").val();
    cuotas = $("#cuotas").val();
   apercier = $("#apercier").val();
    timbrado = $("#timbrado").val();
   deposito = $("#cboiddeposito").val();
   
   detalle = $("#detalle").val();
   detalle2 = $("#detalle2").val();
      
    if ( cliente > 0  && plazo !== "" && cuotas !== "" && nrofactura !== "" && timbrado !== ""  && detalle !== "") {
    
       $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo: 0, sucursal: suc, usuario: usu, cliente: cliente, tipofact: tfactura, plazo: plazo, cuotas: cuotas, detalle: detalle, detalle2: detalle2, ope:1}
        }).done(function (msg) {
        //   humane.log("<span class='fa fa-check'></span> " + msg, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
          mostrarMensaje(msg);
          $("#grilladetalle tbody tr").remove();
          calcularTotales();
          $("#tfactura").val('');
          $("#cliente").val('0').trigger('change');
          $("#item").val('0').trigger('change');
          $("#plazo").val('');
          $("#precio").val('');
          $("#stock").val('');
          $("#cuotas").val('');
          $("#ffactura").val('');
          $("#cboiddeposito").val('');
          $("#total").val('');
          $("#detalle").val('');
        //   refrescarDatos();
        actualizarNroFactura()
        ultcod();
        refrescarDatos();
           // vaciar();
       });
  } else {
     humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
    }
});

//ACTUALIZAR NRO FACTURA
function actualizarNroFactura(){
    var usu = $("#usuario").val();
    $.ajax({
        type: 'GET',
        url: 'actualizarNroFactura.php',
        data:{usu:usu}
    }).done(function(nroFactura){
        $("#nrofact").val(nroFactura);
    })
}
//ACTUALIZAR EL NRO DE LA VENTA
function ultcod(){
    $.ajax({
        type: 'GET',
        url: 'ultcod.php',

    }).done(function(cod){
        // alert(cod)
        $("#nro").val(cod);
    })
}



   function cargargrilla() {
        var salida = '{';
        $("#grilladetalle tbody tr").each(function(index) {
            var campo1, campo2, campo3, campo4, campo5;   //,campo5;
            salida = salida + '{';
            $(this).children("td").each(function(index2) {
                switch (index2) {
                    case 0: //codigo
                        campo1 = $(this).text().replace(".","");
                        salida = salida + campo1 + ',';
                        break;
                    case 2://marcas
                        campo2 = $(this).text();
                        campo2 = campo2.split('-');
                        campo2 = campo2[0].trim();
                        salida = salida + campo2 + ',';
                        break;
                    case 3://deposito
                        campo3 = $(this).text();
                        campo3 = campo3.split('-');
                        campo3 = campo3[0].trim();
                        salida = salida + campo3 + ',';
                        break;
                    case 4://cantidad
                        campo4 = $(this).text().replace(".","");
                        salida = salida + campo4 + ',';
                        break;
                     case 5://precio
                        campo5 = $(this).text().replace(".","");
                        salida = salida + campo5;
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
    

// FUNCION DE IVA
function calcularTotales() {
    var exe = 0;
    var g5 = 0;
    var g10 = 0;
    $("#grilladetalle tbody tr").each(function (fila) {
        $(this).children("td").each(function (col) {
            if (col === 6) {
                exe = exe + parseInt($(this).text().replace(/\./g, ""));
            }
            if (col === 7) {
                g5 = g5 + parseInt($(this).text().replace(/\./g, ""));
            }
            if (col === 8) {
                g10 = g10 + parseInt($(this).text().replace(/\./g, ""));
            }
        });
    });
    var totales = "<tr>";
    totales += "<th colspan=\"6\">SUB TOTALES</th>";
    totales += "<th style=\"text-align: right;\">" + exe.toLocaleString() + "</th>";
    totales += "<th style=\"text-align: right;\">" + g5.toLocaleString() + "</th>";
    totales += "<th style=\"text-align: right;\">" + g10.toLocaleString() + "</th>";
    totales += "<th></th>";
    totales += "</tr>";
    var iva5 = Math.round((g5 / 21));
    var iva10 = Math.round((g10 / 11));
    totales += "<tr>";
    totales += "<th colspan=\"7\">LIQUIDACION DE IVA</th>";
    totales += "<th style=\"text-align: right;\">" + iva5.toLocaleString() + "</th>";
    totales += "<th style=\"text-align: right;\">" + iva10.toLocaleString() + "</th>";
    totales += "<th style=\"text-align: right;\"></th>";
    totales += "</tr>";
    var totaliva = Math.round((g5 / 21) + (g10 / 11));
    totales += "<th colspan=\"8\">TOTAL DE IVA</th>";
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
    totales += "<th colspan=\"8\"><h4>TOTAL GENERAL</h4></th>";
    totales += "<th style=\"text-align: right;\"><h4>" + totalgral.toLocaleString() +" Gs."+"</h4></th>";
    totales += "<th><h4></h4></th>";
    totales += "</tr>";

    $("#grilladetalle tfoot").html(totales);
    $("#detalle2").val(`{${exe},${g5},${g10},${iva5},${iva10}}`);
}

$(function () {
    $('#cantidad').keypress(function (e) {
        if (e.which === 13) {
            //cargargrilla();
        }
    });

    $(".chosen-select").chosen({width: "100%"});
    calcularTotales();
});


function tiposelect() {
    if ($("#tipofact").val() == "1") {
        $('#plazo').attr('disabled', 'true');
        $('#plazo').val('0');
        $('#cuotas').attr('disabled', 'true');
        $('#cuotas').val('0');
    } else {
        $('#plazo').removeAttr('disabled');
        $('#cuotas').removeAttr('disabled');
    }
}



//TRAER LAS ORDENES DE TRABAJOS DEL CLIENTE SELECCIONADA CON ESTADO PENDIENTE Y DEL DIA ACTUAL
function getOrdenesTrabajos(){
    let cliente = document.getElementById('cliente');
    let ordenesTrabajos = document.getElementById('ordentrabajo');

    var cod = cliente.value;
    let fragment = document.createDocumentFragment();
    if(cod > 0){
        $.ajax({
            type: 'GET',
            url: 'getOrdenesTrabajos.php',
            data:{cod: cod}
        }).done(function(msg){
            if(msg != 'error'){
                var datos = JSON.parse(msg);
                console.log(datos);
    
                for(dato of datos){
                    let selectItem = document.createElement('OPTION');
                    selectItem.setAttribute('value', dato.ord_trab_cod);
                    selectItem.textContent = `${dato.ord_trab_cod} - ${dato.ord_trab_estado}`;
    
                    fragment.append(selectItem);
                }
    
                $("#ordentrabajo").children('option').remove();
    
                let opcion = document.createElement('OPTION');
                opcion.setAttribute('value', 0);
                opcion.textContent = 'Elija su orden trabajo';
    
                ordenesTrabajos.insertBefore(opcion, ordenesTrabajos.children[0]);
                ordenesTrabajos.append(fragment);
                $("#ordentrabajo").selectpicker('refresh');

            }else{
                $("#ordentrabajo").children('option').remove();
    
                let opcion = document.createElement('OPTION');
                opcion.setAttribute('value', 0);
                opcion.textContent = 'Este cliente no posee una orden de trabajo';
    
                ordenesTrabajos.insertBefore(opcion, ordenesTrabajos.children[0]);
                ordenesTrabajos.append(fragment);
                $("#ordentrabajo").selectpicker('refresh');
            }
        })
        
    }else{
        primeraOpcion();
    }
}
//TRAER LAS ORDENES DE TRABAJOS DEL CLIENTE SELECCIONADA CON ESTADO PENDIENTE Y DEL DIA ACTUAL
function getPedidosVentas(){
    let cliente = document.getElementById('cliente');
    let pedidoventa = document.getElementById('pedidoventa');

    var cod = cliente.value;
    let fragment = document.createDocumentFragment();
    if(cod > 0){
        $.ajax({
            type: 'GET',
            url: 'getPedidoVentas.php',
            data:{cod: cod}
        }).done(function(msg){
            if(msg != 'error'){
                var datos = JSON.parse(msg);
                console.log(datos);

                for(dato of datos){
                    let selectItem = document.createElement('OPTION');
                    selectItem.setAttribute('value', dato.ped_vcod);
                    selectItem.textContent = `${dato.ped_vcod} - ${dato.ped_estado}`;

                    fragment.append(selectItem);
                }

                $("#pedidoventa").children('option').remove();

                let opcion = document.createElement('OPTION');
                opcion.setAttribute('value', 0);
                opcion.textContent = 'Elija su pedido venta';

                pedidoventa.insertBefore(opcion, pedidoventa.children[0]);
                pedidoventa.append(fragment);
                $("#pedidoventa").selectpicker('refresh');

            }else{//En caso que el cliente no pedido
                $("#pedidoventa").children('option').remove();

                let opcion = document.createElement('OPTION');
                opcion.setAttribute('value', 0);
                opcion.textContent = 'Este cliente no posee un pedido';

                pedidoventa.insertBefore(opcion, pedidoventa.children[0]);
                pedidoventa.append(fragment);
                $("#pedidoventa").selectpicker('refresh');
            }
        })
    }else{
        primeraOpcion2();
    }
}

//SI AL CAMBIAR SE SELECCIONA LA OPCION NUMERO CERO EN CLIENTES
function primeraOpcion(){
    let cliente = document.getElementById('cliente').value;
    let ordenes = document.getElementById('ordentrabajo');
    if(cliente == '0'){
        $("#ordentrabajo").children('option').remove();
        $("#ordentrabajo").selectpicker('refresh');

        let opcion = document.createElement('OPTION');
        opcion.setAttribute('value', 0);
        opcion.textContent = 'Elija primero un cliente';

        ordenes.insertBefore(opcion, ordenes.children[0]);
        $("#ordentrabajo").selectpicker('refresh');
    }
}
//para pedido ventas del cliente
function primeraOpcion2(){
    let cliente = document.getElementById('cliente').value;
    let ordenes = document.getElementById('pedidoventa');
    if(cliente == '0'){
        $("#pedidoventa").children('option').remove();
        $("#pedidoventa").selectpicker('refresh');

        let opcion = document.createElement('OPTION');
        opcion.setAttribute('value', 0);
        opcion.textContent = 'Elija primero un cliente';

        ordenes.insertBefore(opcion, ordenes.children[0]);
        $("#pedidoventa").selectpicker('refresh');
    }
}

$("#cliente").change(function(){
    getOrdenesTrabajos();
    getPedidosVentas();
})



$("#ordentrabajo").change(function(){
    var cod = $("#ordentrabajo").val();
    // alert(`El cod de ordenes trabajos ${cod}`)
    if(cod > 0){
        $.ajax({
            type:'POST',
            url: 'ordenestrabajos.php',
            data:{cod: cod}
        }).done(function(msg){
            alert(msg)
            var datos = JSON.parse(msg);
            $("#grilladetalle > tbody").append(datos.filas);
            calcularTotales();
            cargargrilla();
        })
    }
})

$("#pedidoventa").change(function(){
    var codigo = $("#pedidoventa").val();
    var suc = $("#sucursal").val();
    // alert(`El codigo de pedido es ${codigo}`)
    if(codigo > 0){
        $.ajax({
            type:'POST',
            url: 'pedidoventas.php',
            data:{cod: codigo, suc:suc}
        }).done(function(msg){
            // alert(msg)
            if(msg.trim() != 'error'){// si no hay cantidad necesaria en stock
                var datos = JSON.parse(msg);
                $("#grilladetalle > tbody").append(datos.filas);
                calcularTotales();
                cargargrilla();
            }else{
                humane.log("<span class='fa fa-check'></span>  NO HAY UN DEPOSITO CON LA CANTIDAD NECESARIA PARA REALIZAR LA VENTA DE ESTE PEDIDO ", {timeout: 8000, clickToClose: true, addnCls: 'humane-flatty-error'});
            }
        })
    }
})

$("#cboiddeposito").change(function(){
    item_deposito();

    $("#precio").val("0");
    $("#tipoimpuesto").val("");
    $("#stock").val("");
    $("#clasificacion").val("");
});

function item_deposito(){
    if($("#cboiddeposito").val() > 0){

        var cod = $("#cboiddeposito").val();
        let fragment = document.createDocumentFragment()
        $.ajax({
            type: 'POST',
            url: 'item.php',
            data:{cod:cod}
        }).done(function(msg){
            let data = document.getElementById("item");
            if(msg != "error"){
                // console.log(msg);
                let items = JSON.parse(msg);
                // console.log(items);
                    
                    for(const item of items){
                        // console.log(prov.prov_timb_nro);
                    const selectItem = document.createElement('OPTION');
                    selectItem.setAttribute('value', item["item_cod"]);
                    selectItem.textContent= `${item.item_desc}`;

                    fragment.append(selectItem);
                    }

                        $("#item").children('option').remove();                        
                        
                        let primero = document.createElement('OPTION');
                        primero.setAttribute('value', 0);
                        primero.textContent = 'Elija una opcion';
                        
                        data.insertBefore(primero, data.children[0]);
                        data.append(fragment);
                        
                        $("#item").selectpicker('refresh')
            }else{
                $("#item").children('option').remove();

                let primero = document.createElement('OPTION');
                primero.setAttribute('value', 0);
                primero.textContent = 'El deposito no posee item actualmente';
                
                data.insertBefore(primero, data.children[0]);                
                $("#item").selectpicker('refresh')
            }
           
                
        });
    }else{
        $("#precio").val("0");
        $("#tipoimpuesto").val("");
        $("#stock").val("");
        $("#clasificacion").val("");

        $("#item").children('option').remove();
        let data2 = document.getElementById('item');

        let primer = document.createElement('OPTION');
        primer.setAttribute('value', 0);
        primer.textContent = 'Elija primero un deposito';

        data2.insertBefore(primer, data2.children[0])
        $("#item").selectpicker('refresh');
    }
}

$("#item").change(function(){
    // getItem();
    marca();
    // stock();
});

$("#tipofact").change(function(){
    if($("#tipofact").val() == 2){
        $("#plazo").removeAttr("disabled", true);
        $("#cuotas").removeAttr("disabled", true);
    }else{
        $("#plazo").attr("disabled", true);
        $("#plazo").val(0);
        $("#cuotas").attr("disabled", true);
        $("#cuotas").val(0);

    }
})

function getStock(){
    var cod = $("#item").val();
    var depcod = $("#cboiddeposito").val();
    if(cod > 0 && depcod > 0){
        // alert(`El depcod es ${depcod} `)
        $.ajax({
            type: 'GET',
            url: 'stock.php',
            data: {cod: cod, depcod:depcod }
        }).done(function(stock){
            $("#stock").val(stock);
        })
    }
}

function getItem(){
    var cod = $("#item").val();
    if(cod > 0){

        $.ajax({
            type: 'GET',
            url: 'getItem.php',
            data: {cod: cod}
        }).done(function(data){
            datos = JSON.parse(data);
            console.log(datos);
            $("#tipoimpuesto").val(datos.tipo_imp_cod + ' - '+ datos.tipo_imp_desc);
        })
    }else{
        $("#tipoimpuesto").val("");
    }
}

        function eliminarfila2(parent) {
            $(parent).remove();
            calcularTotales();
        }

     $(document).on("click",".agregar",function agregar_fila(){
            $("#detalle-grilla").css({display:'block'});
   
            var itemdesc = $('#item option:selected').html();
            var deposito = $('#cboiddeposito option:selected').html();
            var items = $('#item').val();
            var marcod = $('#marcas').val();
            var mardesc = $('#marcas option:selected').html();
            var producto = items.split('~');
            var cant = parseInt($('#cantidad').val());
            var prec = parseInt($('#precio').val());
            var tipoimp = $("#tipoimpuesto").val();

            var exenta = 0;
            var grav5 = 0;
            var grav10 = 0;
            $("#cboiddeposito").attr("enabled","true").trigger('chosen:updated');

            if(items > 0 && cant > 0){//VALIDAMOS QUE LOS CAMPOS DE  ITEM Y CANTIDAD ESTEAN CARGADOS
                if (tipoimp == '3 - EXENTAS') {
                    exenta = cant * prec;
                    grav5 = 0;
                    grav10 = 0;
                } else if (tipoimp === '2 - GRAVADA 5%') {
                    exenta = 0;
                    grav5 = cant * prec;
                    grav10 = 0;
                } else if (tipoimp === '1 - GRAVADA 10%') {
                    exenta = 0;
                    grav5 = 0;
                    grav10 = cant * prec;
                }

                var repetido = false;
                var co = 0;
                let co2 = 0;
                let filac;
                let bandera = true;
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

                    $("#grilladetalle tbody tr").each(function (fila1) {
                        if(bandera){
                            filac = fila1;
                            $(this).children("td").each(function (col1) {
                                if (col1 === 0) {
                                    co = $(this).text();
                                    if (co === items) {
                                        // repetido = true;
                                        $("#grilladetalle tbody tr:eq("+filac+")").children("td").each(function (col2) {
                                            if(col2 === 2){
                                                co2 = $(this).text();
                                                co2 = $(this).text();
                                                co2 = co2.split("-");
                                                co2 = co2[0].trim();

                                                if(co === items && co2 === marcod){
                                                    repetido = true;

                                                    $("#grilladetalle tbody tr:eq("+filac+")").children("td").each(function (i) {
                                                        if(i === 2 ){
                                                            $(this).text(mardesc.toLocaleString());
                                                        }
                                                        if (i === 3) {
                                                            $(this).text(deposito.toLocaleString());
                                                            //var cantgrilla = parseInt($(this).html());
                                                        }
                                                        if (i === 4) {
                
                                                            $(this).text(cant.toLocaleString());
                                                        }
                                                        if (i === 5) {
                
                                                            $(this).text(prec.toLocaleString());
                                                        }
                                                        if (i === 6) {
                                                            //exenta = (exenta+parseInt($(this).text().replace(/\./g,"")));
                                                            $(this).text(exenta.toLocaleString());
                                                        }
                                                        if (i === 7) {
                                                            //grav5 = (grav5+parseInt($(this).text().replace(/\./g,"")));
                                                            $(this).text(grav5.toLocaleString());
                                                        }
                                                        if (i === 8) {
                                                            //grav10 = (grav10+parseInt($(this).text().replace(/\./g,"")));
                                                            $(this).text(grav10.toLocaleString());
                                                        }
                                                        bandera = false;
                                                    });
                                                }

                                            }
        
                                            
                                        });
                                    }
                                }
        
                            });
                            
                        }
                }); /////////////// FALTA VALIDAR REPETICIONES DE ITEMS ///////////// 11-11-2020

                if (!repetido) {
                    $('#grilladetalle > tbody:last').append('<tr><td style="text-align: center;">' + producto[0] + '</td><td>' + itemdesc + '</td><td style="text-align: center;">' + mardesc + '</td><td style="text-align: center;">' + deposito + '</td><td style="text-align: center;">' + cant.toLocaleString() + '</td><td style="text-align: right;">' + prec.toLocaleString() + '</td><td style="text-align: right;">' + exenta.toLocaleString() + '</td><td style="text-align: right;">' + grav5.toLocaleString() + '</td><td style="text-align: right;">' + grav10.toLocaleString() + '</td><td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
                    // <td style="text-align: right;" onclick="eliminarfila($(this).parent())"><button type="button" class="btn btn-danger btn-xs"><span class="glyphicon glyphicon-remove"></span></button></td>
                    contador++;
                }
                calcularTotales();
                cargargrilla();
                $('#cantidad').val("");

            }else{
                humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
            }

            // function eliminarfila(parent) {
            //     $(parent).remove();
            //     calcularTotales();
            // }
});

        $(document).on("click",".eliminar",function(){
            var parent = $(this).parent();
            $(parent).remove();
            cargargrilla();
            calcularTotales();
            
        });

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

///////////////////////////////////////////////////////////////////////////////////////////////////////
$("#marcas").change(function(){
    stock();
    precio();
    getItem();
})

function marca(){
    let marcas = document.getElementById('marcas');
    let fragment = document.createDocumentFragment();

    var cod = $('#item').val();
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
                    humane.log("<span class='fa fa-info'></span>  ESTE ITEM NECESITA TENER UNA MARCA ASIGNADA EN MARCAS - ITEMS ", { timeout: 6000, clickToClose: true, addnCls: 'humane-flatty-error' });

                    $("#marcas").children('option').remove();
                    let opcion = document.createElement('OPTION');
                        opcion.setAttribute('value', 0);
                        opcion.textContent = 'Elija primero un item';
            
                        marcas.insertBefore(opcion, marcas.children[0]);
                    $("#marcas").selectpicker('refresh');

                    $("#precio").val("");
                    $("#stock").val("");
                } 
            });

        }else{
            $("#marcas").children('option').remove();
            let opcion = document.createElement('OPTION');
                opcion.setAttribute('value', 0);
                opcion.textContent = 'Elija primero un item';
    
                marcas.insertBefore(opcion, marcas.children[0]);
            $("#marcas").selectpicker('refresh');

            $("#stock").val("")
            $("#precio").val("")
        }
    }


    function stock(){
        var item = $('#item').val();
        var mar = $("#marcas").val();
        var dep = $("#cboiddeposito").val()
        var suc = $("#sucursal").val();
        // alert(`este es suc ${suc}`)
        if(item>0 && mar > 0){

            $.ajax({
                type: "POST",
                url: "stock.php",
                data: {item:item, mar:mar, dep:dep, suc:suc}
            }).done(function(stock){
                $("#stock").val(stock);
                $("#cantidad").focus();
            });
        }
    }

    function precio(){
        var item = $('#item').val();
        var mar = $('#marcas').val();
        if(mar>0 && item>0){

            $.ajax({
                type: "POST",
                url: "precio.php",
                data: {item:item, mar:mar}
            }).done(function(precio){
                // alert(precio)
                $("#precio").val(precio);
                $("#cantidad").focus();
            });
        }
    }

///////////////////////////////////////////////////////////////////////////////////////////////////////

$(function () {
    $('#agregar').keypress(function (e) {
        if (e.which === 13) {
            // agregar_fila();
        }
    });

    $(".chosen-select").chosen({width: "100%"});  
    // getMercaderias();
    tiposelect();
    calcularTotales();
    });

    // function eliminarfila(parent) {
    //     $(parent).remove();
    //     calcularTotales();
    // }

});
