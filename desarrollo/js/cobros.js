
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
            {"data": "ffactura"},
            {"data": "cliente"},
            {"data": "ruc"},
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
        data: {codigo:codigo, nro: 0, empresa: 0, sucursal: 0, usuario: 0, funcionario: 0, cliente: 0, tipofact: '', plazo:'', cuotas: '', timbrado:0,apercier:1,cboiddeposito:0, detalle: '{{1,1,1}}', detalle2: '{}', ope: 2}
    }).done(function (msg) {
        $('#hide').click();
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
<tr width=90px class="success"><th>Venta N.°</th><th>Cuotas</th><th>Vencimiento</th><th>Monto</th><th>Saldo</th><th>Estado</th><th>Fecha cobro</th></tr>';
        var total = 0;
        var subtotal;
        for (var x = 0; x < d.detalle.length; x++) {
           subtotal = d.detalle[x].cantidad * d.detalle[x].precio;
           total += parseInt(subtotal);
            detalle += '<tr>' +
                    '<td>' + d.detalle[x].ven_cod + '</td>' +
                    '<td>' + d.detalle[x].cuotas + '</td>' + 
                    '<td>' + d.detalle[x].venc + '</td>' +
                    '<td>' + d.detalle[x].monto + '</td>' +
                    '<td>' + d.detalle[x].saldo + '</td>' +
                    '<td>' + d.detalle[x].estado + '</td>' +
                    '<td>' + d.detalle[x].fecha_cobro + '</td>' +
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
                '</tfoot>' +
                '</table></center>';
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

    // INSERTAR COBROS TODOS
    $(document).on("click","#cobroTodo",function(){

        var efectivo, aperciercod, suc, usu, fcobro, vencod, detalleTarjetas, detalleCheques,montoDisponible;
        efectivo = $("#todoMontoEfectivo").val();
        if(efectivo == "") efectivo = 0;
        aperciercod = $("#apercier").val();
        usu = $("#usuario").val();
        suc = $("#sucursal").val();
        fcobro = $("#tipoCobro").val();
        vencod = $("#ventanro").val();
        detalleTarjetas = $("#detalleTarjetas").val();
        detalleCheques = $("#detalleCheques").val();
        montoDisponible = $("#todoTotal").val();
        // debugger
        if ( aperciercod > 0 && fcobro > 0 && vencod > 0 && montoDisponible > 0) {
            $.ajax({
                type: "POST",
                url: "grabar.php",
                data: {codigo: 0, efectivo:efectivo, aperciercod:aperciercod, usuario: usu, sucursal:suc, fcobro: fcobro, vencod: vencod, detalleTarjetas: detalleTarjetas, detalleCheques: detalleCheques, montoDisponible:montoDisponible, ope:1}
            }).done(function (msg) {
                mostrarMensaje(msg);
                limpiarCampos()
                // actualizarNroFactura()
                refrescarDatos();
            });
        } else {
        humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
        }
    });

    // COBRAR EFECTIVO
    $(document).on("click","#cobroEfectivo",function(){
        var efectivo, aperciercod, suc, usu, fcobro, vencod, detalleTarjetas, detalleCheques,montoDisponible;
        efectivo = $("#montoEfectivo").val();
        if(efectivo == "") efectivo = 0;
        aperciercod = $("#apercier").val();
        usu = $("#usuario").val();
        suc = $("#sucursal").val();
        fcobro = $("#tipoCobro").val();
        vencod = $("#ventanro").val();
        detalleTarjetas = $("#detalleTarjetas").val();
        detalleCheques = $("#detalleCheques").val();
        montoDisponible = $("#totalEfectivo").val();
        // debugger
        if ( aperciercod > 0 && fcobro > 0 && vencod > 0 ) {
            let saldoDeuda = parseInt($("#efectivoSaldoDeuda").val())

            if(efectivo <= saldoDeuda){
                $.ajax({
                    type: "POST",
                    url: "grabar.php",
                    data: {codigo: 0, efectivo:efectivo, aperciercod:aperciercod, usuario: usu, sucursal:suc, fcobro: fcobro, vencod: vencod, detalleTarjetas: detalleTarjetas, detalleCheques: detalleCheques, montoDisponible:efectivo, ope:1}
                }).done(function (msg) {
                    mostrarMensaje(msg);
                    limpiarCampos();
                    // actualizarNroFactura();
                    refrescarDatos();
                });
            }else{
                humane.log("<span class='fa fa-info'></span> EL MONTO A PAGAR NO PUEDE SE MAYOR A LA DEUDA TOTAL", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
            }
        } else {
        humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
        }
    });

    /////////////////////////////////////////////// COBRAR TARJETAS SOLO //////////////////////////////////////////////////////////////////
    $(document).on("click","#cobroTarjetasSolo",function(){
        var montoTarjeta, aperciercod, suc, usu, fcobro, vencod, detalleTarjetas, detalleCheques,montoDisponible;
        montoTarjeta = $("#MontoPagarTarjetasSolo").val();
        if(montoTarjeta == "") montoTarjeta = 0;
        aperciercod = $("#apercier").val();
        usu = $("#usuario").val();
        suc = $("#sucursal").val();
        fcobro = $("#tipoCobro").val();
        vencod = $("#ventanro").val();
        detalleTarjetas = $("#detalleTarjetas").val();
        detalleCheques = $("#detalleCheques").val();
       // montoDisponible = $("#totalEfectivo").val();
        if ( aperciercod > 0 && fcobro > 0 && vencod > 0 ) {
            let saldoDeuda = parseInt($("#DeudaPagarTarjetasSolo").val())

            if(montoTarjeta <= saldoDeuda){
                $.ajax({
                    type: "POST",
                    url: "grabar.php",
                    data: {codigo: 0, efectivo:0, aperciercod:aperciercod, usuario: usu, sucursal:suc, fcobro: fcobro, vencod: vencod, detalleTarjetas: detalleTarjetas, detalleCheques: detalleCheques, montoDisponible:montoTarjeta, ope:1}
                }).done(function (msg) {
                    mostrarMensaje(msg);
                    limpiarCampos();
                    actualizarNroFactura();
                    refrescarDatos();
                });
            }else{
                humane.log("<span class='fa fa-info'></span> EL MONTO A PAGAR NO PUEDE SE MAYOR A LA DEUDA TOTAL", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
            }
        } else {
            humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
        }
    });

    function cargarGrillaTarjetasSolo() {
        $('#detalleTarjetas').val("")
        var salida = '{';
        $("#grilladetalletarjetasSolo tbody tr").each(function(index) {
            var campo1, campo2, campo3, campo4, campo5, campo6, campo7;
            salida = salida + '{';
            $(this).children("td").each(function(index2) {
                switch (index2) {
                    case 0: //codigo
                        campo1 = $(this).text().replace(".","");
                        salida = salida + campo1 + ',';
                        break;
                    case 1://marcas tarjetas
                        campo2 = $(this).text();
                        campo2 = campo2.split('-');
                        campo2 = campo2[0].trim();
                        salida = salida + campo2 + ',';
                        break;
                    case 2://Numero de tarjeta
                        campo3 = $(this).text().replace(".","");
                        salida = salida + campo3 + ',';
                        break;
                    case 3://codigo autorizacion
                        campo4 = $(this).text().replace(".","");
                        salida = salida + campo4 + ',';
                        break;
                    case 4://entidad emisora 
                        campo5 = $(this).text();
                        campo5 = campo5.split('-');
                        campo5 = campo5[0].trim();
                        salida = salida + campo5 + ',';
                        break;
                    case 5://entidad adherida
                       campo6 = $(this).text();
                       campo6 = campo6.split('-');
                       campo6 = campo6[0].trim();
                       salida = salida + campo6 + ',';
                       break;
                    case 6://monto tarjeta
                       campo7 = $(this).text().replace(".","");
                       salida = salida + campo7;
                       break;
                }
            });
            if (index < $("#grilladetalletarjetasSolo tbody tr").length - 1) {
                salida = salida + '},';
            } else {
                salida = salida + '}';
            }
        });
        salida = salida + '}';  //la ultima llave del array
        $('#detalleTarjetas').val(salida);
    }
    
    $(document).on("click",".agregarCobroTarjetasSolo",function(){
            $("#detalle-grilla").css({display:'block'});
            let cobroCod = $("#cobroNro").val();
            var todoMarTarj = $('#tarjetaMarjSolo option:selected').html();
            var todoMarTarjCod = $('#tarjetaMarjSolo').val();
            var todoNumTarj = $('#tarjetaNumSolo').val();
            var todoCodAut = $('#tarjetaCodAutSolo').val();
            var todoEntEmi = $('#tarjetaEntEmiSolo option:selected').html();
            var todoEntAdh = $('#tarjetaEntAdhSolo option:selected').html();
            var todoMonTarj = parseInt($('#tarjetaMonTarjSolo').val());
            // alert(`${todoMarTarj} - ${todoNumTarj} - ${todoCodAut} - ${todoEntEmi} - ${todoEntAdh} - ${todoMonTarj}`)

            if(todoMonTarj > 0 && todoNumTarj > 0 && todoCodAut > 0){
                var todoTotal = $("#MontoPagarTarjetasSolo").val()
                var todoMontoPagar = parseInt($("#DeudaPagarTarjetasSolo").val())
                if(todoTotal == ""){
                    todoTotal = 0;
                }
                
                var totalAcumulado = (parseInt(todoTotal) + todoMonTarj)
                if( totalAcumulado  <= todoMontoPagar){
                    var repetido = false;
                    var co = 1;
                    let co2 = 0;
                    let co3 = 0;
                    let filac;
                    let bandera = true;
                    var contador = 0;
                    $("#grilladetalletarjetasSolo tbody tr").each(function (fila1) {
                        if(bandera){
                            filac = fila1;
                            $(this).children("td").each(function (col1) {
                                if (col1 === 1) {
                                    co = $(this).text().split('-');
                                    co = co[0].trim();
                                    if (co === todoMarTarjCod) {
                                        // repetido = true;
                                        $("#grilladetalletarjetasSolo tbody tr:eq("+filac+")").children("td").each(function (col2) {
                                            if(col2 === 2){
                                                co2 = $(this).text();
                                                if(co === todoMarTarjCod && co2 === todoNumTarj){
                                                    $("#grilladetalletarjetasSolo tbody tr:eq("+filac+")").children("td").each(function(col3){
                                                        if(col3 === 3){
                                                            co3 = $(this).text();
                                                            if(co === todoMarTarjCod && co2 === todoNumTarj && co3 === todoCodAut){ //  si coincide marca, num tarj y autori.
                                                                repetido = true;
                                                                humane.log("<span class='fa fa-info'></span> YA SE HA CARGADO ESTA TARJETA CON ESTE COD. DE  AUTIRAZACION", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
                                                                bandera = false;
                                                            }
                                                        }
                                                    })
                                                }
                                            }
                                        });
                                    }
                                }            
                            });
                        }
                    });
                    if (!repetido) {
                        $('#grilladetalletarjetasSolo > tbody:last').append('<tr><td style="text-align: center;">' + cobroCod + '</td><td style="text-align: center;">' + todoMarTarj + '</td><td style="text-align: center;">' + todoNumTarj + '</td><td style="text-align: center;">' + todoCodAut + '</td><td style="text-align: center;">' + todoEntEmi + '</td><td style="text-align: center;">' + todoEntAdh + '</td><td style="text-align: right;">' + todoMonTarj + '</td><td class="eliminarDetalleTarjetasSolo"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
                        contador++;
                    }
                    cargarGrillaTarjetasSolo();
                    calcularTotalesTarjetasSolo();
                    calcularTotalSolo() 
                }else{
                    humane.log("<span class='fa fa-info'></span> EL MONTO A PAGAR NO PUEDE SER MAYOR AL MONTO DE LA DEUDA", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
                }
            }else{
                humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos de la tarjeta", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
            }
    });

    $(document).on("click",".eliminarDetalleTarjetasSolo",function(){
        var parent = $(this).parent();
        $(parent).remove();
        cargarGrillaTarjetasSolo();
        calcularTotalesTarjetasSolo();
        calcularTotalSolo(); 
    });

    function calcularTotalesTarjetasSolo() {
        var totalTarjetas = 0;
        $("#grilladetalletarjetasSolo tbody tr").each(function (fila) {
            $(this).children("td").each(function (col) {
                if (col === 6) {
                    totalTarjetas = totalTarjetas + parseInt($(this).text().replace(/\./g, ""));
                }
            });
        });
        $("#totalTarjetasSolo").text(`Subtotal Tarjetas: ${totalTarjetas} Gs.`)
    }  

    function calcularTotalSolo() {
        var totalPagar    = 0;
        var totalTarjetas = $("#totalTarjetasSolo").text().split(' ');
            totalTarjetas = parseInt(totalTarjetas[2].trim());
        var    totalDeuda = $("#DeudaPagarTarjetasSolo").val();
        totalPagar = totalTarjetas
        if( totalDeuda >= totalPagar){
            $("#MontoPagarTarjetasSolo").val(totalPagar)
        }else{
            humane.log("<span class='fa fa-info'></span> EL MONTO A PAGAR NO PUEDE SER MAYOR AL MONTO DE LA DEUDA2", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
        }
    }    

    /////////////////////////////////////////////// COBRAR TARJETAS SOLO FIN ///////////////////////////////////////////////////////////


    /////////////////////////////////////////////// COBRAR CHEQUES SOLO /////////////////////////////////////////////////////////////////
    $(document).on("click","#cobroChequesSolo",function(){
        var montoTarjeta, aperciercod, suc, usu, fcobro, vencod, detalleTarjetas, detalleCheques,montoDisponible;
        montoCheque = $("#MontoPagarChequesSolo").val();
        if(montoTarjeta == "") montoTarjeta = 0;
        aperciercod = $("#apercier").val();
        usu = $("#usuario").val();
        suc = $("#sucursal").val();
        fcobro = $("#tipoCobro").val();
        vencod = $("#ventanro").val();
        detalleTarjetas = $("#detalleTarjetas").val();
        detalleCheques = $("#detalleCheques").val();
       // montoDisponible = $("#totalEfectivo").val();
        // debugger
        if ( aperciercod > 0 && fcobro > 0 && vencod > 0 ) {
            let saldoDeuda = parseInt($("#montoDeudaChequesSolo").val())

            if(montoCheque <= saldoDeuda){
                $.ajax({
                    type: "POST",
                    url: "grabar.php",
                    data: {codigo: 0, efectivo:0, aperciercod:aperciercod, usuario: usu, sucursal:suc, fcobro: fcobro, vencod: vencod, detalleTarjetas: detalleTarjetas, detalleCheques: detalleCheques, montoDisponible:montoCheque, ope:1}
                }).done(function (msg) {
                    mostrarMensaje(msg);
                    limpiarCampos();
                    actualizarNroFactura();
                    refrescarDatos();
                });
            }else{
                humane.log("<span class='fa fa-info'></span> EL MONTO A PAGAR NO PUEDE SE MAYOR A LA DEUDA TOTAL", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
            }
        } else {
            humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
        }
    });

    function cargarGrillaChequesSolo() {
        $('#detalleCheques').val("");
        var salida = '{';
        $("#grilladetallechequesSolo tbody tr").each(function(index) {
            var campo1, campo2, campo3, campo4, campo5, campo6, campo7;
            salida = salida + '{';
            $(this).children("td").each(function(index2) {
                switch (index2) {
                    case 0: //codigo
                        campo1 = $(this).text().replace(".","");
                        salida = salida + campo1 + ',';
                        break;
                    case 1://numero cuenta
                        campo2 = $(this).text();
                        salida = salida + campo2 + ',';
                        break;
                    case 2://serie
                        campo3 = $(this).text().replace(".","");
                        salida = salida + campo3 + ',';
                        break;
                    case 3://numero cheque
                        campo4 = $(this).text().replace(".","");
                        salida = salida + campo4 + ',';
                        break;
                    case 4://monto cheque 
                        campo5 = $(this).text();
                        salida = salida + campo5 + ',';
                        break;
                    case 5://cheque emision
                        campo6 = $(this).text();
                        salida = salida + campo6 + ',';
                        break;
                    case 6://librador
                       campo7 = $(this).text();
                       salida = salida + campo7 + ',';
                       break;
                    case 7://Banco
                       campo8 = $(this).text().replace(".","");
                       campo8 = campo8.split('-');
                       campo8 = campo8[0].trim();
                       salida = salida + campo8 + ',';
                       break;
                    case 8://tipo cheque
                       campo9 = $(this).text().replace(".","");
                       campo9 = campo9.split('-');
                       campo9 = campo9[0].trim();
                       salida = salida + campo9;
                       break;
                }
            });
            if (index < $("#grilladetallechequesSolo tbody tr").length - 1) {
                salida = salida + '},';
            } else {
                salida = salida + '}';
            }
        });
        salida = salida + '}';  //la ultima llave del array
        $('#detalleCheques').val(salida);
    }
    
    $(document).on("click",".agregarCobroChequesSolo",function(){
            $("#detalle-grilla").css({display:'block'});
            let cobroCod = $("#cobroNro").val();
            var todoNumCuen = $('#numeroCuentaChequeSolo').val();
            var todoSerie = $('#serieChequeSolo').val();
            var todoNumCheq = $('#numeroChequeSolo').val();
            var todoCheqMon = parseInt($('#montoChequeSolo').val());
            var todoLib = $('#libradorChequeSolo').val();
            var todoCheqEmi = $('#emisionChequeSolo').val();
            var todoBan = $('#bancoChequeSolo option:selected').html();
            var todoTipCheq = $('#tipoChequeSolo option:selected').html();   
            // alert(`${todoNumCuen} - ${todoSerie} - ${todoNumCheq} - ${todoCheqMon} - ${todoLib} - ${todoBan} - ${todoTipCheq}`)
            if(todoCheqMon > 0 && todoNumCuen > 0 && todoSerie.length > 0 && todoSerie.length <= 2 && todoNumCheq > 0 && todoLib !==""){
                var todoTotal = $("#MontoPagarChequesSolo").val()
                var todoMontoPagar = parseInt($("#montoDeudaChequesSolo").val())
                if(todoTotal == ""){
                    todoTotal = 0;
                }
                var totalAcumulado = (parseInt(todoTotal) + todoCheqMon)
                
                if(totalAcumulado <= todoMontoPagar){
                    var repetido = false;
                    var co = 0;
                    let co2 = 0;
                    let co3 = 0;
                    let filac;
                    let bandera = true;
                    var contador = 0;
                    $("#grilladetallechequesSolo tbody tr").each(function (fila1) {
                        if(bandera){
                            filac = fila1;
                            $(this).children("td").each(function (col1) {
                                if (col1 === 1) {
                                    co = $(this).text();
                                    if (co === todoNumCuen) {
                                        // repetido = true;
                                        $("#grilladetallechequesSolo tbody tr:eq("+filac+")").children("td").each(function(col2) {
                                            if(col2 === 2){
                                                co2 = $(this).text(); 
                                                if(co === todoNumCuen && co2 === todoSerie){
                                                    $("#grilladetallechequesSolo tbody tr:eq("+filac+")").children("td").each(function(col3){
                                                        if(col3 === 3){
                                                            co3 = $(this).text();  
                                                            // debugger
                                                            if(co === todoNumCuen && co2 === todoSerie && co3 === todoNumCheq ){
                                                                repetido = true;
                                                                humane.log("<span class='fa fa-info'></span> ESTE NUMERO CHEQUE YA HA SIDO CARGADO", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
                                                            }
                                                            bandera = false;
                                                        }
                                                    })
                                                }
                                            }
                                        });
                                    }
                                }
                            });
                        }
                    });
    
                    if (!repetido) {
                        $('#grilladetallechequesSolo > tbody:last').append('<tr><td style="text-align: center;">' + cobroCod + '</td><td style="text-align: center;">' + todoNumCuen + '</td><td style="text-align: center;">' + todoSerie + '</td><td style="text-align: center;">' + todoNumCheq + '</td><td style="text-align: center;">' + todoCheqMon + '</td><td style="text-align: center;">' + todoCheqEmi + '</td><td style="text-align: center;">' + todoLib + '</td><td style="text-align: right;">' + todoBan + '</td><td style="text-align: right;">' + todoTipCheq + '</td><td class="eliminarDetalleChequesSolo"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
                        contador++;
                    }
                    cargarGrillaChequesSolo();
                    calcularTotalesChequesSolo();
                    calcularTotalChequesSolo();
                }else{
                    humane.log("<span class='fa fa-info'></span> EL MONTO A PAGAR NO PUEDE SER MAYOR AL MONTO DE LA DEUDA", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
                }
            }else{
                humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos de cheques", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
            }
    });

    $(document).on("click",".eliminarDetalleChequesSolo",function(){
        var parent = $(this).parent();
        $(parent).remove();
        $("#totalChequesSolo").text(`Subtotal Cheques: 0 Gs.`)
        cargarGrillaChequesSolo();
        calcularTotalesChequesSolo();
        calcularTotalChequesSolo(); 
        
    });

    function calcularTotalesChequesSolo() {
        var totalCheques = 0;
        $("#grilladetallechequesSolo tbody tr").each(function (fila) {
            $(this).children("td").each(function (col) {
                if (col === 4) {
                    totalCheques = totalCheques + parseInt($(this).text().replace(/\./g, ""));
                }
            });
        });
        $("#totalChequesSolo").text(`Subtotal Cheques: ${totalCheques} Gs.`)
    }    

    function calcularTotalChequesSolo() {
        var totalPagar    = 0;
        var totalCheques  = $("#totalChequesSolo").text().split(' ');
            totalCheques  = parseInt(totalCheques[2].trim());
        var totalDeuda    = $("#montoDeudaChequesSolo").val()

        totalPagar = totalCheques;
        // debugger
        if( totalDeuda >= totalPagar){
            $("#MontoPagarChequesSolo").val(totalPagar)
        }else{
            humane.log("<span class='fa fa-info'></span> EL MONTO A PAGAR NO PUEDE SER MAYOR AL MONTO DE LA DEUDA 2", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
        }
    }    
    /////////////////////////////////////////////// COBRAR CHEQUES SOLO FIN /////////////////////////////////////////////////////////////////

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

   function cargarGrillaTarjetas() {
        $('#detalleTarjetas').val("")
        var salida = '{';
        $("#grilladetalletarjetas tbody tr").each(function(index) {
            var campo1, campo2, campo3, campo4, campo5, campo6, campo7;
            salida = salida + '{';
            $(this).children("td").each(function(index2) {
                switch (index2) {
                    case 0: //codigo
                        campo1 = $(this).text().replace(".","");
                        salida = salida + campo1 + ',';
                        break;
                    case 1://marcas tarjetas
                        campo2 = $(this).text();
                        campo2 = campo2.split('-');
                        campo2 = campo2[0].trim();
                        salida = salida + campo2 + ',';
                        break;
                    case 2://Numero de tarjeta
                        campo3 = $(this).text().replace(".","");
                        salida = salida + campo3 + ',';
                        break;
                    case 3://codigo autorizacion
                        campo4 = $(this).text().replace(".","");
                        salida = salida + campo4 + ',';
                        break;
                    case 4://entidad emisora 
                        campo5 = $(this).text();
                        campo5 = campo5.split('-');
                        campo5 = campo5[0].trim();
                        salida = salida + campo5 + ',';
                        break;
                    case 5://entidad adherida
                       campo6 = $(this).text();
                       campo6 = campo6.split('-');
                       campo6 = campo6[0].trim();
                       salida = salida + campo6 + ',';
                       break;
                    case 6://monto tarjeta
                       campo7 = $(this).text().replace(".","");
                       salida = salida + campo7;
                       break;
                }
            });
            if (index < $("#grilladetalletarjetas tbody tr").length - 1) {
                salida = salida + '},';
            } else {
                salida = salida + '}';
            }
        });
        salida = salida + '}';  //la ultima llave del array
        $('#detalleTarjetas').val(salida);
    }
    
    $(document).on("click",".agregarCobroTarjetas",function (){
            $("#detalle-grilla").css({display:'block'});
            let cobroCod = $("#cobroNro").val();
            var todoMarTarj = $('#todoMarcaTarjeta option:selected').html();
            var todoMarTarjCod = $('#todoMarcaTarjeta').val();
            var todoNumTarj = $('#todoNumeroTarjeta').val();
            var todoCodAut = $('#todoCodigoAutorizacion').val();
            var todoEntEmi = $('#todoEntidadEmisora option:selected').html();
            var todoEntAdh = $('#todoEntidadAdherida option:selected').html();
            var todoMonTarj = parseInt($('#todoMontoTarjeta').val());
            // alert(`${todoMarTarj} - ${todoNumTarj} - ${todoCodAut} - ${todoEntEmi} - ${todoEntAdh} - ${todoMonTarj}`)

            if(todoMonTarj > 0 && todoNumTarj > 0 && todoCodAut > 0){
                var todoTotal = $("#todoTotal").val()
                var todoMontoPagar = parseInt($("#todoMontoPagar").val())
                if(todoTotal == ""){
                    todoTotal = 0;
                }
                var totalAcumulado = (parseInt(todoTotal) + todoMonTarj)
                if( totalAcumulado  <= todoMontoPagar){
                    var repetido = false;
                    var co = 1;
                    let co2 = 0;
                    let co3 = 0;
                    let filac;
                    let bandera = true;
                    var contador = 0;
                    $("#grilladetalletarjetas tbody tr").each(function (fila1) {
                        if(bandera){
                            filac = fila1;
                            $(this).children("td").each(function (col1) {
                                if (col1 === 1) {
                                    co = $(this).text().split('-');
                                    co = co[0].trim();
                                    if (co === todoMarTarjCod) {
                                        // repetido = true;
                                        $("#grilladetalletarjetas tbody tr:eq("+filac+")").children("td").each(function (col2) {
                                            if(col2 === 2){
                                                co2 = $(this).text();
                                                if(co === todoMarTarjCod && co2 === todoNumTarj){
                                                    $("#grilladetalletarjetas tbody tr:eq("+filac+")").children("td").each(function(col3){
                                                        if(col3 === 3){
                                                            co3 = $(this).text();
                                                            if(co === todoMarTarjCod && co2 === todoNumTarj && co3 === todoCodAut){ //  si coincide marca, num tarj y autori.
                                                                repetido = true;
                                                                humane.log("<span class='fa fa-info'></span> YA SE HA CARGADO ESTA TARJETA CON ESTE COD. DE  AUTIRAZACION", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
                                                                bandera = false;
                                                            }
                                                        }
                                                    })
                                                }
                                            }
                                        });
                                    }
                                }            
                            });
                        }
                    });
                    if (!repetido) {
                        $('#grilladetalletarjetas > tbody:last').append('<tr><td style="text-align: center;">' + cobroCod + '</td><td style="text-align: center;">' + todoMarTarj + '</td><td style="text-align: center;">' + todoNumTarj + '</td><td style="text-align: center;">' + todoCodAut + '</td><td style="text-align: center;">' + todoEntEmi + '</td><td style="text-align: center;">' + todoEntAdh + '</td><td style="text-align: right;">' + todoMonTarj + '</td><td class="eliminarDetalleTarjetas"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
                        contador++;
                    }
                    cargarGrillaTarjetas();
                    calcularTotalesTarjetas();
                    calcularTotal() 
                }else{
                    humane.log("<span class='fa fa-info'></span> EL MONTO A PAGAR NO PUEDE SER MAYOR AL MONTO DE LA DEUDA", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
                }
            }else{
                humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos tarjetas", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
            }
    });

    $(document).on("click",".eliminarDetalleTarjetas",function(){
        var parent = $(this).parent();
        $(parent).remove();
        cargarGrillaTarjetas();
        calcularTotalesTarjetas();
        calcularTotal(); 
    });

    // CALCULAR TOTALES TARJETAS
    function calcularTotalesTarjetas() {
        var totalTarjetas = 0;
        $("#grilladetalletarjetas tbody tr").each(function (fila) {
            $(this).children("td").each(function (col) {
                if (col === 6) {
                    totalTarjetas = totalTarjetas + parseInt($(this).text().replace(/\./g, ""));
                }
            });
        });
        $("#totalTarjetas").text(`Subtotal Tarjetas: ${totalTarjetas} Gs.`)
    }    
    // CALCULAR TOTALES TARJETAS FIN 

    // CALCULAR TOTALES CHEQUES
    function calcularTotalesCheques() {
        var totalCheques = 0;
        $("#grilladetallecheques tbody tr").each(function (fila) {
            $(this).children("td").each(function (col) {
                if (col === 4) {
                    totalCheques = totalCheques + parseInt($(this).text().replace(/\./g, ""));
                }
            });
        });
        $("#totalCheques").text(`Subtotal Cheques: ${totalCheques} Gs.`)
    }    
    // CALCULAR TOTALES CHEQUES FIN 

     // CALCULAR TOTAL  =  efectivo + total cheque + total tarjetas
     $("#todoMontoEfectivo").on('change', function(){
         calcularTotal();
     })

     function calcularTotal() {
        var totalPagar    = 0;
        var totalCheques  = $("#totalCheques").text().split(' ');
            totalCheques  = parseInt(totalCheques[2].trim());
        var totalTarjetas = $("#totalTarjetas").text().split(' ');
            totalTarjetas = parseInt(totalTarjetas[2].trim());
        var totalEfectivo = $("#todoMontoEfectivo").val()
        var totalDeuda    = $("#todoMontoPagar").val()
        if(totalEfectivo == "") {
            totalEfectivo = 0;
        }
        totalPagar = parseInt(totalEfectivo) + totalTarjetas + totalCheques;
        // debugger
        if( totalDeuda >= totalPagar){
            $("#todoTotal").val(totalPagar)
        }else{
            humane.log("<span class='fa fa-info'></span> EL MONTO A PAGAR NO PUEDE SER MAYOR AL MONTO DE LA DEUDA", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
        }
    }    
    // CALCULAR TOTAL FIN 

    // COBRO EN CHEQUE GRILLA DETALLE 
    function cargarGrillaCheques(tabla) {
        $('#detalleCheques').val("");
        var salida = '{';
        $("#grilladetallecheques tbody tr").each(function(index) {
            var campo1, campo2, campo3, campo4, campo5, campo6, campo7;
            salida = salida + '{';
            $(this).children("td").each(function(index2) {
                switch (index2) {
                    case 0: //codigo
                        campo1 = $(this).text().replace(".","");
                        salida = salida + campo1 + ',';
                        break;
                    case 1://numero cuenta
                        campo2 = $(this).text();
                        salida = salida + campo2 + ',';
                        break;
                    case 2://serie
                        campo3 = $(this).text().replace(".","");
                        salida = salida + campo3 + ',';
                        break;
                    case 3://numero cheque
                        campo4 = $(this).text().replace(".","");
                        salida = salida + campo4 + ',';
                        break;
                    case 4://monto cheque 
                        campo5 = $(this).text();
                        salida = salida + campo5 + ',';
                        break;
                    case 5://cheque emision
                        campo6 = $(this).text();
                        salida = salida + campo6 + ',';
                        break;
                    case 6://librador
                       campo7 = $(this).text();
                       salida = salida + campo7 + ',';
                       break;
                    case 7://Banco
                       campo8 = $(this).text().replace(".","");
                       campo8 = campo8.split('-');
                       campo8 = campo8[0].trim();
                       salida = salida + campo8 + ',';
                       break;
                    case 8://tipo cheque
                       campo9 = $(this).text().replace(".","");
                       campo9 = campo9.split('-');
                       campo9 = campo9[0].trim();
                       salida = salida + campo9;
                       break;
                }
            });
            if (index < $("#grilladetallecheques tbody tr").length - 1) {
                salida = salida + '},';
            } else {
                salida = salida + '}';
            }
        });
        salida = salida + '}';  //la ultima llave del array
        $('#detalleCheques').val(salida);
    }
    
    $(document).on("click",".agregarCobroCheques",function(){
            $("#detalle-grilla").css({display:'block'});
            let cobroCod = $("#cobroNro").val();
            var todoNumCuen = $('#todoNumeroCuenta').val();
            var todoSerie = $('#todoSerie').val();
            var todoNumCheq = $('#todoNumeroCheque').val();
            var todoCheqMon = parseInt($('#todoChequeMonto').val());
            var todoCheqEmi = $('#todoChequeEmision').val();
            var todoLib = $('#todoLibrador').val();
            var todoBan = $('#todoBancos option:selected').html();
            var todoTipCheq = $('#todoTipoCheques option:selected').html();   
            // alert(`${todoNumCuen} - ${todoSerie} - ${todoNumCheq} - ${todoCheqMon} - ${todoLib} - ${todoBan} - ${todoTipCheq}`)

            if(todoCheqMon > 0 && todoNumCuen > 0 && todoSerie.length > 0 && todoSerie.length <= 2 && todoNumCheq > 0 && todoLib !==""){
                var todoTotal = $("#todoTotal").val()
                var todoMontoPagar = parseInt($("#todoMontoPagar").val())
                if(todoTotal == ""){
                    todoTotal = 0;
                }
                var totalAcumulado = (parseInt(todoTotal) + todoCheqMon)
                
                if(totalAcumulado <= todoMontoPagar){
                    var repetido = false;
                    var co = 0;
                    let co2 = 0;
                    let co3 = 0;
                    let filac;
                    let bandera = true;
                    var contador = 0;
                    $("#grilladetallecheques tbody tr").each(function (fila1) {
                        if(bandera){
                            filac = fila1;
                            $(this).children("td").each(function (col1) {
                                if (col1 === 1) {
                                    co = $(this).text();
                                    if (co === todoNumCuen) {
                                        // repetido = true;
                                        $("#grilladetallecheques tbody tr:eq("+filac+")").children("td").each(function(col2) {
                                            if(col2 === 2){
                                                co2 = $(this).text(); 
                                                if(co === todoNumCuen && co2 === todoSerie){
                                                    $("#grilladetallecheques tbody tr:eq("+filac+")").children("td").each(function(col3){
                                                        if(col3 === 3){
                                                            co3 = $(this).text();  
                                                            // debugger
                                                            if(co === todoNumCuen && co2 === todoSerie && co3 === todoNumCheq ){
                                                                repetido = true;
                                                                humane.log("<span class='fa fa-info'></span> ESTE NUMERO CHEQUE YA HA SIDO CARGADO", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
                                                            }
                                                            bandera = false;
                                                        }
                                                    })
                                                }
                                            }
                                        });
                                    }
                                }
                            });
                        }
                    });
    
                    if (!repetido) {
                        $('#grilladetallecheques > tbody:last').append('<tr><td style="text-align: center;">' + cobroCod + '</td><td style="text-align: center;">' + todoNumCuen + '</td><td style="text-align: center;">' + todoSerie + '</td><td style="text-align: center;">' + todoNumCheq + '</td><td style="text-align: center;">' + todoCheqMon + '</td><td style="text-align: center;">' + todoCheqEmi + '</td><td style="text-align: center;">' + todoLib + '</td><td style="text-align: right;">' + todoBan + '</td><td style="text-align: right;">' + todoTipCheq + '</td><td class="eliminarDetalleCheques"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
                        contador++;
                    }
                    cargarGrillaCheques();
                    calcularTotalesCheques();
                    calcularTotal();
                }else{
                    humane.log("<span class='fa fa-info'></span> EL MONTO A PAGAR NO PUEDE SER MAYOR AL MONTO DE LA DEUDA", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
                }
            }else{
                humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos de cheques", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
            }
    });

    $(document).on("click",".eliminarDetalleCheques",function(){
        var parent = $(this).parent();
        $(parent).remove();
        cargarGrillaCheques();
        calcularTotalesCheques();
        calcularTotal() 
        
    });

    // COBRO EN CHEQUE GRILLA DETALLE FIN
    $("#cliente").on('change', function(){
        let cliente = $("#cliente").val();
        let ventas = document.getElementById('venta');
        let fragment = document.createDocumentFragment();
        if(cliente > 0){   
            $.ajax({
                type: 'GET',
                url: 'getVentas.php',
                data: {cliente: cliente}
            }).done(function(data){
                if(data != 'error'){ 
                    let datos = JSON.parse(data)
                    console.log(datos)
                    for(const ven of datos){
                        const selectItem = document.createElement('OPTION');
                        selectItem.setAttribute('value', ven["ven_cod"]);
                        selectItem.textContent= `${ven.ven_cod} - ${ven.ven_estado} `;
                        fragment.append(selectItem);
                    }
                    $("#venta").children('option').remove();
    
                    let opcion = document.createElement('OPTION');
                    opcion.setAttribute('value', 0);
                    opcion.textContent = 'Elija una venta a cobrar';
    
                    ventas.insertBefore(opcion, ventas.children[0]);
                    ventas.append(fragment);
    
                    ventas.append(fragment);
                    $("#venta").selectpicker('refresh');    
                }else{//SI AUN NO POSEE UNA VENTA CON ESTADO PENDIENTE A COBRAR
                    humane.log("<span class='fa fa-info'></span>  ESTE CLIENTE NO POSEE UNA VENTA CON ESTADO PENDIENTE ", { timeout: 6000, clickToClose: true, addnCls: 'humane-flatty-error' });
    
                    $("#venta").children('option').remove();
                    let opcion = document.createElement('OPTION');
                        opcion.setAttribute('value', 0);
                        opcion.textContent = 'Elija primero un cliente';
            
                        ventas.insertBefore(opcion, ventas.children[0]);
                    $("#venta").selectpicker('refresh');
                } 
            })
        }
    })
    // traer deuda total y cuotas pagadas
    $("#venta").on('change', function(){
        let ventanro = $("#venta").val()
        if(ventanro > 0){
            getMontoDeuda(ventanro)
            getCuotas(ventanro)
            $("#confirmar").removeAttr("disabled", true);
        }

    })

    function getMontoDeuda(ventanro){
        if(ventanro > 0){
            $.ajax({
                type: 'GET',
                url: 'getMontoDeuda.php',
                data: {ventanro: ventanro}
            }).done(function(data){
                console.log(data)
                let datos = JSON.parse(data)
                $("#deuda").val('')
                $("#deuda").val(`${datos.data[0].monto_deuda} / ${datos.data[0].monto_saldo}`)
                $("#todoMontoPagar").val(datos.data[0].monto_saldo)
                $("#DeudaPagarTarjetasSolo").val(datos.data[0].monto_saldo)
                $("#montoDeudaChequesSolo").val(datos.data[0].monto_saldo)
                $("#efectivoSaldoDeuda").val(datos.data[0].monto_saldo) // para pago solo efectivo
            })
        }
    }

    function getCuotas(ventanro){
        if(ventanro > 0){
            $.ajax({
                type: 'GET',
                url: 'getCuotas.php',
                data: {ventanro: ventanro}
            }).done(function(data){
                let datos = JSON.parse(data)
                console.log(datos)
                $("#cuotaspagadas").val('')
                $("#cuotaspagadas").val(`${datos.data[0].cuotas_pagadas} de ${datos.data[0].cuotas_total}`)
                document.getElementById('cuotas').setAttribute('max', `${datos.data[0].cuotas_total - datos.data[0].cuotas_pagadas}`);
            })
        }
    }
    // fin traer deuda total y cuotas pagadas

    // traer monto de la cuotas a pagar
    $("#cuotas").on('blur', function(){
        let cuotas = $("#cuotas").val();
        let ventanro = $("#venta").val();
        if(cuotas > 0 && ventanro > 0){
            $.ajax({
                type: 'GET',
                url: 'getMontoCuota.php',
                data: {cuotas:cuotas, ventanro: ventanro}
            }).done(function(data){
                console.log(data)
                $("#monto").val('');
                $("#monto").val(data);
                $("#monto").attr("disabled", true);
            })
        }
    })
    // fin traer monto de la cuotas a pagar

    //desplegar modal segun el tipo de cobro
    $("#tipoCobro").on('change', function(){
        let tipoCobro = parseInt($("#tipoCobro").val());
        let btnConfirmar = document.getElementById('confirmar')
        if(tipoCobro === 1){
            btnConfirmar.dataset.target = "#efectivo"
        //    $("#confirmar").data("target", "#efectivo");
        }else if(tipoCobro === 2){
            btnConfirmar.dataset.target = "#tarjetas"
        }else if(tipoCobro === 3){
            btnConfirmar.dataset.target = "#cheques"
        }else if(tipoCobro === 4){
            btnConfirmar.dataset.target = "#todos"
        }
    })
    //desplegar modal segun el tipo de cobro fin

    // FUNCION COBRAR
    $(document).on("click", ".cobrar", function(){

        var pos = $(".cobrar").index(this);
        let cod;
        $("#tabla tbody tr:eq("+pos+")").find('td:eq(1)').each(function(){
             cod = $(this).html();
             $("#ventanro").val(cod);
            //  alert(cod)
            $.ajax({
                type:'GET',
                url: 'cobrar.php',
                data: {cod: cod}
            }).done(function(data){
               let datos = JSON.parse(data)
            //    console.log(datos)
                if (datos.data[0].error){
                    humane.log("<span class='fa fa-info'></span> ESTA VENTA YA HA SIDO COBRADA EN SU TOTALIDAD", {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
                }else{
                    $("#cliente").val(datos.data[0].cliente).trigger('change');
                    $("#cliente").attr("disabled", true);
                    setTimeout(() => {
                        $("#venta").val(datos.data[0].ventanro).trigger('change');
                        $("#venta").attr("disabled", true);   
                    }, 1000);
                }
            })
        })
    });    
    // FIN COBRAR
function limpiarCampos(){
    $("#todoMontoEfectivo").val('');
    $("#tipoCobro").val('1').trigger('change');
    $("#ventanro").val('0').trigger('change');
    $("#grilladetallecheques tbody tr").remove();
    $("#grilladetalletarjetas tbody tr").remove();
    $("#todoTotal").val('');
    $("#cuotas").val('');
    $("monto").val('')
    $("#cliente").val('0').trigger('change');
}

function mostrarMensaje(msg){
    var r = msg.split("_/_");
    var texto = r[0];
    var tipo = r[1];
    if(tipo.trim() == 'notice'){
        texto = texto.split("NOTICE:");
        texto = texto[1];
        humane.log("<span class='fa fa-check'></span>"+ texto, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
    }
    if(tipo.trim() == 'error'){
        texto = texto.split("ERROR:");
        texto = texto[2];
        humane.log("<span class='fa fa-info'></span>"+ texto, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-error'});
    }
}

$(function () {
    $('#agregar').keypress(function (e) {
        if (e.which === 13) {
            // agregar_fila();
        }
    });

    $(".chosen-select").chosen({width: "100%"});  
    });

});
