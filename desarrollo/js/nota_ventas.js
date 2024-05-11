

// $(document).ready(function() {
    $("#motivo_nota").change(function verificarMotNota(){
        var valor = $("#motivo_nota").val();
        if(valor === "DESCUENTO"){
            $("#item").prop("disabled", true);
            $("#item").val(0).trigger('change');
            $("#marcas").prop("disabled", true);
            $("#marcas").val(0).trigger('change');
            $("#deposito").prop("disabled", true);
            $("#deposito").val(0).trigger('change');
            $("#cantidad").prop("disabled", true);
            $("#notamonto").prop("disabled", false);
        }else if(valor === "ANULACION") {
            $("#item").prop("disabled", false)
            $("#item").val(0).trigger('change');
            $("#marcas").prop("disabled", false);
            $("#marcas").val(0).trigger('change');
            $("#deposito").prop("disabled", false);
            $("#deposito").val(0).trigger('change');
            $("#cantidad").prop("disabled", false);
            $("#notamonto").prop("disabled", true);
        }
    })
// })

$("#tipo_nota").change(function(){
    var tipoNota = $("#tipo_nota").val()
    if(tipoNota === 'DEBITO'){
        $("#item").prop("disabled", true);
        $("#item").val(0).trigger('change');
        $("#marcas").prop("disabled", true);
        $("#marcas").val(0).trigger('change');
        $("#deposito").prop("disabled", true);
        $("#deposito").val(0).trigger('change');
        $("#cantidad").prop("disabled", true);
        $("#notamonto").prop("disabled", false);
    }else if(tipoNota === 'CREDITO'){
        // verificarMotNota();
    }
})

$("#fechafactura").change(function(){
    let fechafactura = $("#fechafactura").val();
    let timbradovighasta = $("#timbradovighasta").val();

    if(fechafactura > timbradovighasta ){
        humane.log("<span class='fa fa-info'></span>La fecha de la factura no puede ser mayor a la fecha de vencimiento del timbrado", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-error' });
        return
    }
})

//Obs: falta la funcion de imprimir
$(function(){

var Path ='imp_notasventa.php';
var ordencompras = $('#ordencompras').dataTable( {
        "columns": [
            {
                "class":          "details-control",
                "orderable":      false,
                "data":           null,
                "defaultContent": "<a><span class='fa fa-plus'></span></a>"
            },
             { "data": "notanro" }, 
             { "data": "nro" }, 
             { "data": "cod" }, 
             { "data": "fecha" }, 
             { "data": "tipo_factura" },
             { "data": "estado" }, 
             { "data": "acciones"}
        ]
    } );

    ordencompras.fnReloadAjax('datos.php');
    function refrescarDatos(){
        ordencompras.fnReloadAjax();
    }

    var detailRows = [];
      
   $('#ordencompras tbody').on( 'click', 'tr td.details-control', function () {        
        var tr = $(this).closest('tr');
        var row = $('#ordencompras').DataTable().row( tr );
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
    ordencompras.on( 'draw', function () {
        $.each( detailRows, function ( i, cod ) {
            $('#'+cod+' td.details-control').trigger( 'click' );
        });
    } );

    //TABLA DETALLE
    function format ( d ) {
        // `d` is the original data object for the row
        var deta ='<table  class="table table-striped table-bordered nowrap table-hover">\n\
        <tr width=90px class="info"><th>Codigo</th><th>Descripcion</th><th>Marca</th><th>Cantidad</th><th>Precio Unitario</th><th>Subtotal</th></tr>';
        var total=0;
        var subtotal=0;
        for(var x=0;x<d.detalle.length;x++){
            subtotal = d.detalle[x].cantidad * d.detalle[x].precio;
            total += parseInt(subtotal);

            deta+='<tr>'+
                '<td width=10px>'+d.detalle[x].codigo+'</td>'+
                '<td width=80px>'+d.detalle[x].descripcion+'</td>'+
                '<td width=80px>'+d.detalle[x].marca+'</td>'+
                '<td width=50px>'+d.detalle[x].cantidad+'</td>'+
                '<td width=50px>'+d.detalle[x].precio+'</td>'+
                '<td width=10px>' + subtotal + '</td>' +
            '</tr>';
            }
        deta+= '</tbody>' +
            '<tfoot>' +
            '<tr>' +        
            '<td></td>' + //FILAS ==> <td> 
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
            '<td>'+ total+' Gs.</td>' +
            '</tr>' +
            '</tfoot>' +
            '</table></center>';
                        //AQUI SE CREA LA OPCION PARA IMPRIMIR DENTRO DEL DETALLE...
        return deta+'<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
            <div class="row">'+                
                    
            '<div class="col-md-2">' +
                '<div class="col-md-12 pull-center">'+
                
            '<a href="../informes/'+Path+'?id='+d.notanro+'/'+d.cod+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                        
                
            '</div>'+

            '</div>';
    }

    // INSERTAR GRILLA DE ordencompras 
    $("#item").change(function(){
        precio();
        marca();
    });


    $(document).on("click",".agregar",function(){
            $("#detalle-grilla").css({display:'block'});
            var producto = $('#item option:selected').html();
            var marca = $('#marcas option:selected').html();

            var procod = $('#item').val();
            var marcod = $('#marcas').val();
            var cant = $('#cantidad').val();
            var prec = $('#precio').val();   
            var depcod = $('#deposito').val();   
            var deposito = $('#deposito option:selected').html();  
            var descripcion = $('#descripcion').val();  
            var depfinal = depcod + '. ' +   deposito;
            prec = prec.replace(" Gs.","");
            var subtotal = cant * prec;
             if(procod>0 && producto!=="" && cant>0 && prec>0 && depcod>0 && subtotal!==0){ 
            var repetido = false;
            var co = 0;
            var co2 = 0;
            $("#grilladetalle tbody tr").each(function(index) {
                $(this).children("td").each(function(index2) {
                    if (index2 === 0){
                        co = $(this).text();
                        if (co === procod) {
                            
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
                                                    if(i===2){
                                                        $(this).text(marca);
                                                    }
                                                    if(i===3){
                                                        $(this).text(cant);
                                                    }
                                                    if(i===4){
                                                        $(this).text(precio);
                                                    }
                                                    if(i===5){
                                                        $(this).text(subtotal);
                                                    }
                                                });
                                            });
                                        }
                                    }
                                });
                            });
                        }
                    }
                });
            });
            if (!repetido) {
                $('#grilladetalle > tbody:last').append('<tr class="ultimo"><td>' + procod + '</td><td>' + producto + '</td><td>' + marca + '</td><td>' + cant + '</td><td>' + prec + '</td><td>' + subtotal + '</td><td>' + depfinal + '</td><td>' + descripcion + '</td><td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
            }
    // }else if(cant < 0 || cant == ""){
    //     humane.log("<span class='fa fa-info'></span> ATENCION!! La cantidad no puede ser negativo", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
    }else{ //aqui
        humane.log("<span class='fa fa-info'></span> ATENCION!! Por favor complete todos los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
    }
        // cargargrilla();
        $("#cantidad").val('');
        $("#item").val("0").trigger('change');
    });

    $(document).on("click",".eliminar",function(){
        var parent = $(this).parent();
        $(parent).remove();
        // cargargrilla();
    });     

    //FUNCION ANULAR
    //esta parte es para que al hacer clic se posicione y me muestre el mensaje de anular
    $(document).on("click",".delete",function(){
        var pos = $( ".delete" ).index( this );

        var nro =  $("#ordencompras tbody tr:eq("+pos+")").find('td:eq(1)').html();
        var prov =  $("#ordencompras tbody tr:eq("+pos+")").find('td:eq(2)').html();
        var timb =  $("#ordencompras tbody tr:eq("+pos+")").find('td:eq(3)').html();
        var fact =  $("#ordencompras tbody tr:eq("+pos+")").find('td:eq(4)').html();
       
        $("#delete").val(nro+'/'+prov+'/'+timb+'/'+fact);
        $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea eliminar el Registro Nro. '+nro+' / '+prov+' / '+timb+' / '+fact+' ?</h4>');
    });
    //esta parte es para que al hacer clic pueda anular
    $(document).on("click","#delete",function(){
        var cod = $( "#delete" ).val();
        var todo = cod.split('/');
        var nro2 = todo[0].trim();
        var prov2 = todo[1].trim();
        var timb2 = todo[2].trim();
        var fact2 = todo[3].trim();
        alert(`Este es el nro ${nro2} prov ${prov2} timb2 ${timb2} fact2 ${fact2}`);

        var suc = $("#sucursal").val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {notanro:nro2,proveedor:prov2,timbrado:timb2,nrofact:fact2,tipo_nota:0,suc:0,usu:0, detalle:'{{1,1,1}}',ope:2}
            // --ORDEN: notanro, provcod, provtimbnro, nrofactura, notatipo, usucod, succod, detalle[], operacion
    
        }).done(function(msg){
            //$('#confirmacion').modal("hide");
           $('#hide').click();
            // humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
            mostrarMensajes(msg)
            refrescarDatos();
        });

    });
    // FIN ANULAR


    //FUNCION INSERTAR
    $(document).on("click","#grabar",function(){
        var vencod             = $("#nrofact option:selected").val();
        var nrofactura          = $("#notanumero").val();
        var timbrado            = $("#timbrado").val();
        var clicod              = $("#clientes option:selected").val();
        var tipo_nota           = $("#tipo_nota").val();
        var tipo_mot_nota       = $("#motivo_nota").val();
        var notamonto           = $("#notamonto").val();
        var desc                = $("#descripcion").val();
        var usu                 = $("#usuario").val();
        var suc                 = $("#sucursal").val();
        alert(`notanro: ${nrofactura} vencod: ${vencod} tipo_nota: ${tipo_nota}  suc:${suc} usu: ${usu} notamonto: ${notamonto} desc: ${desc}`)
        debugger
        if(tipo_nota === 'DEBITO' || (tipo_nota === 'CREDITO' && tipo_mot_nota === 'DESCUENTO')){
            if(notamonto > 0 && desc!=="" && vencod > 0 && nrofactura !=="" && tipo_nota!=="" && timbrado !==""){
                $.ajax({
                type: "POST",
                url: "grabar.php",
                data: {notanro:0, vencod:vencod, nrofactura:nrofactura, timbrado:timbrado, clicod:clicod, tipo_nota:tipo_nota, tipo_mot_nota:tipo_mot_nota, notamonto:notamonto, desc:desc, usu:usu, suc:suc, detalle:'{}', ope:1}
                //ORDEN: codigo, vencod, notavenfact, timbcod, clicod, notaventipo, notavenmotivo, notamonto, notadescripcion, usu, suc, detalles[], ope
                }).done(function(msg){
                    mostrarMensajes(msg);
                });
                actualizarFacturas();
                vaciar();
                $("#total").html('Total: 0.00 Gs.');        
                refrescarDatos();
            }

        }else if(tipo_nota === 'CREDITO' && tipo_mot_nota === 'ANULACION'){
                detalle="{";
                $("#grilladetalle tbody tr").each(function(index) {
                    var campo1, campo2,campo3,campo4, campo5, campo6;
                    detalle = detalle + '{';
                    $(this).children("td").each(function(index2) {
                        switch (index2) {
                            case 0:
                                campo1 = $(this).text();
                                detalle = detalle + campo1 + ',';
                                break;
                            case 2:
                                campo2 = $(this).text().split("-");
                                campo2 = campo2[0].trim();
                            detalle = detalle + campo2 + ',';
                                break;
                            case 3:
                                campo3 = $(this).text();
                                detalle = detalle + campo3+ ',';
                                break;
                            case 4:
                                campo4 = $(this).text();
                                detalle = detalle + campo4+ ',';
                                break;
                            case 6:
                                // este
                                if($("#orden").val() > 0){
                                    campo5 = $('#ordenid'+campo1).val()
                                    detalle = detalle + campo5;
                                }else{
                                    campo5 =  $(this).text();
                                    campo5 = campo5.split(".");
                                    campo5 = campo5[0].trim();
                                    detalle = detalle + campo5 + ',';
                                }
                                break;
                            case 7:
                                campo6 = $("#descripcion").val();
                                detalle = detalle + campo6;
                                break;
                        }
                    });

                    if (index < $("#grilladetalle tbody tr").length - 1) {
                        detalle = detalle + '},';
                    } else {
                        detalle = detalle + '}';
                    }
                });
                detalle= detalle + '}';

            if(detalle!=="{}" && vencod > 0 && nrofactura !== "" && tipo_nota!=="" && timbrado !==""){
                $.ajax({
                type: "POST",
                url: "grabar.php",
                data: {notanro:0, vencod:vencod, nrofactura:nrofactura, timbrado:timbrado, clicod:clicod, tipo_nota:tipo_nota, tipo_mot_nota:tipo_mot_nota, notamonto:0, desc:desc, usu:usu, suc:suc, detalle:detalle, ope:1}
                //ORDEN: codigo, vencod, notavenfact, timbcod, clicod, notaventipo, notavenmotivo, notamonto, notadescripcion, usu, suc, detalles[], ope
                }).done(function(msg){
                    mostrarMensajes(msg);
                    $("#grilladetalle tbody tr").remove();                    
                    vaciar();
                    $("#total").html('Total: 0.00 Gs.');
                    actualizarFacturas();
                    refrescarDatos();
                });

            }else if(vencod ===""){
                humane.log("<span class='fa fa-info'></span>Selecciona un proveedor. Por favor", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
            }else if(detalle ===""){
                humane.log("<span class='fa fa-info'></span> Debe agregar detalle", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
            }else{
                humane.log("<span class='fa fa-info'></span> Verifique los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
            }
        }       
    });
    // FIN INSERTAR

    // Insert detalle desde la tabla pedidos_compras_det
    $("#orden").change(function(){
        var ordenId = $(this).val();
        if(ordenId > 0){
            cuota = [];
            $.ajax({
                url: 'orden.php',
                type: 'POST',
                data: {orden:ordenId}
            }).done(function(msg){
                datos = JSON.parse(msg);
                $('#grilladetalle > tbody > tr').remove();
                $('#grilladetalle > tbody:last').append(datos.filas);
                $('#total').html('<strong>'+datos.total+' Gs.</strong>');
                
                $("#item").attr("disabled", true)
                $("#cantidad").attr("disabled", true)
            });
            setTimeout(function(){traerOrdenCab(ordenId)},1000)
        }else{
            $("#item").removeAttr("disabled", true)
            $("#cantidad").removeAttr("disabled", true)
            $("#marcas").removeAttr("disabled", true)
            $('#grilladetalle > tbody > tr').remove();
            $("#total").html('Total: 0.00 Gs.');
        };
    });
    
    // fin  Insert detalle desde la tabla pedidos_compras_de
    $("#marcas").change(function(){
        stock();
        precio();
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
        var suc = $("#sucursal").val();
        // alert(`este es suc ${suc}`)
        if(item>0 && mar > 0){
            $.ajax({
                type: "POST",
                url: "stock.php",
                data: {item:item, mar:mar, suc:suc}
            }).done(function(stock){
                //alert(`stock ${stock}`)
                $("#stock").val(stock);
                $("#deposito").focus();
            });
        }
    }

    function precio(){
        var item = $('#item').val();
        var mar = $('#marcas').val();
        if(mar>0 && item >0){
            $.ajax({
                type: "POST",
                url: "precio.php",
                data: {item:item, mar:mar}
            }).done(function(precio){
                // alert(precio)
                $("#precio").val(precio);
            });
        }
    }

    function vaciar(){
        $("#nrofactura").val("");
        $("#tipo_factura").val("");
        $("#deposito").val(0).trigger('change');
        $("#clientes").val(0).trigger('change');
        $("motivo_nota").val(0).trigger('change');
        $("#item").val(0).trigger('change');
        $("#descripcion").val("");
        $("#notamonto").val(0);
    }
    //FUNCION PARA MOSTRAR SOLO LA PARTE QUE QUEREMOS DE LA RESPUESTO DEL SERVIDOR
    function mostrarMensajes(msg){
        var r = msg.split("_/_");
        var texto = r[0];
        var  tipo = r[1];
        if(tipo.trim()== 'notice'){
            texto = texto.split("NOTICE:")
            texto = texto[1];
            humane.log("<span class='fa fa-check'></span> "+texto, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
        }
        if(tipo.trim() == 'error'){
            texto = texto.split("ERROR:");
            texto = texto[2];
            humane.log("<span class='fa fa-info'></span> "+texto, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-error' });
        }
    }
    // Funciones
    $(function () {
        $(".chosen-select").chosen({width: "100%"});   
    });


    // obtener el numero de factura y timbrado  cuando cambia el proveedor
    $("#clientes").change(function(){
        // $("#nrofact").children('option').remove();
        var select = document.getElementById("nrofact");
        var length = select.options.length;
        for (i = length-1; i >= 0; i--) {
        select.options[i] = null;
        }
        factura_proveedor()
    });

    function factura_proveedor(){
        let factura2 = document.getElementById('nrofact');
        if($("#clientes").val() > 0){

            var cli = $("#clientes").val();
            let fragment = document.createDocumentFragment()
            $.ajax({
                type: 'POST',
                url: 'factura_ventas.php',
                data:{cli:cli}
            }).done(function(facturas){
                console.log(facturas)
                    
                    let nrofactura = JSON.parse(facturas);
                    console.log(nrofactura);
            
                    for(const factura of nrofactura){
                        console.log(factura.nro_factura);
                        if(factura["nro_factura"] != undefined){
                            const selectItem = document.createElement('OPTION');
                            selectItem.setAttribute('value', `${factura.ven_cod}`);
                            selectItem.textContent= `${factura.ven_cod} - ${factura.nro_factura}`;
                            fragment.append(selectItem);
                        }
                    }
                    $("#nrofact").children('option').remove();

                    let opcion = document.createElement('OPTION');
                    opcion.setAttribute('value', 0);
                    opcion.textContent = 'Elija una factura';

                    factura2.insertBefore(opcion, factura2.children[0]);
                    factura2.append(fragment);

                    factura2.append(fragment);
                    $("#nrofact").selectpicker('refresh');     
            });
        }else{
            $("#nrofact").children('option').remove();
            let opcion = document.createElement('OPTION');
                opcion.setAttribute('value', 0);
                opcion.textContent = 'Elija primero un proveedor';

                factura2.insertBefore(opcion, factura2.children[0]);
                $("#nrofact").selectpicker('refresh');

                $("#timbrado").val("")
        }
    }

    function actualizarFacturas(){
        $.ajax({
            type: 'GET',
            url: 'ultcod.php',
        }).done(function(msg){
            $("#nrofact").val(msg).selectpicker('refresh')
        })
    }
});
