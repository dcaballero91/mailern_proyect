$(function(){
    $("#tipoNota").change(function(){
        var tipo = $("#tipoNota").val();
        if(tipo === "INTERNO"){
            $("#timbrado").attr("disabled",true)
            $("#timbVigHasta").attr("disabled",true)
            $("#nroFactura").attr("disabled",true)
            $("#montoFactura").attr("disabled",true)
        }else{ // EXTERNO
            $("#timbrado").attr("disabled",false)
            $("#timbVigHasta").attr("disabled",false)
            $("#nroFactura").attr("disabled",false)
            $("#montoFactura").attr("disabled",false)
        }
    })

    var Path ='imp_notasremisiones.php';
    var tabla = $('#transferencia').dataTable( {
        "columns": [
            {
                "class":          "details-control",
                "orderable":      false,
                "data":           null,
                "defaultContent": "<a><span class='fa fa-plus'></span></a>"
            },
            { "data": "nro"},
            { "data": "empresa"},
            { "data": "fecha"},
            { "data": "funcionario" },
            { "data": "sucursal" },
            { "data": "vehiculo" },            
            { "data": "estado"},
            { "data": "acciones"}
        ]
    } );

    tabla.fnReloadAjax('datos.php');

    var detailRows = [];
    $('#transferencia tbody').on( 'click', 'tr td.details-control', function () {        
        var tr = $(this).closest('tr');
        var row = $('#transferencia').DataTable().row( tr );
        var idx = $.inArray( tr.attr('id'), detailRows );
 
        if ( row.child.isShown() ) {
            tr.removeClass( 'details' );
            row.child.hide();
            $(this).html("<a><span class='fa fa-plus'></span></a>");
            // Remove from the 'open' array
            detailRows.splice( idx, 1 );
        }else {
            tr.addClass( 'details' );
            row.child(format(row.data())).show();
            if ( idx === -1 ) {
                detailRows.push( tr.attr('id') );
            }
            $(this).html("<a><span class='fa fa-minus'></span></a>");
        }
    } );
 
    function format ( d ){ 
    // `d` is the origenginal data object for the row
    var deta ='<table  class="table table-striped table-bordered nowrap table-hover">\n\
    <tr width=80px class="success"><th>Nro</th><th>Item</th><th>Marca</th><th>Cantidad</th><th>Precio</th></tr>';
    var total=0;
    for(var x=0;x<d.detalle.length;x++){
        deta+='<tr>'+
            '<td width=10px>'+d.detalle[x].nro+'</td>'+
            '<td width=80px>'+d.detalle[x].item+'</td>'+
            '<td width=50px>'+d.detalle[x].marca+'</td>'+
            '<td width=50px>'+d.detalle[x].cantidad+'</td>'+
            '<td width=50px>'+d.detalle[x].precio+'</td>'+
        '</tr>';
    }
    deta+= '</tbody>' +
        '<tfoot>' +
        '<tr>' +
        '<td></td>' +
        '<td></td>' +
        '<td></td>' +
        '<td></td>' +
        '<td></td>' +
        '</tr>' +
        '<tr>' +
        '</tr>' +
        '</tfoot>' +
        '</table></center>';

    return deta+'<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
        <div class="row">'+                
            '<div class="col-md-2">' +
                '<div class="col-md-12 pull-center">'+
                   '<a href="../informes/'+Path+'?id='+d.nro+'" target="_blank" class="btn btn-sm btn-success btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+                    
                '</div>'+
            '</div>';
    }
    //CARGAR GRILLA
    $(document).on("click","#cargar",function(){
        var deposito,producto,cantidad,marcod, marca, stock;
        deposito = $("#deposito").val();
        marca = $("#marcas option:selected").text();
        producto = $("#item").val();
        marcod = $("#marcas").val();
        cantidad = parseInt($("#cantidad").val());
        stock = parseInt($("#stocko").val());
        recib = $('#recib').val();
        var destinoc=$("#item option:selected").text();
        if(stock < cantidad){// si no se dispono la cantidad para el envio
            humane.log("<span class='fa fa-info'></span> LA CANTIDAD A SER ENVIADA NO PUEDE SUPERAR LA DISPONIBILIDAD EN STOCK",{ timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-error' });

        }else if(deposito!=="" && producto!=="" && cantidad>0){
            var repetido = false;
            var co = 0;
            var co2 = 0;
            $("#grilla tbody tr").each(function(index) {
                $(this).children("td").each(function(index2) {
                    if (index2 === 0) {
                        co = $(this).text();
                        if (co === producto) {
                            
                            $("#grilla tbody tr").each(function(index) {
                                $(this).children("td").each(function(index2) {
                                    if (index2 === 2) {
                                        co2 = $(this).text();
                                        co2 = $(this).text();
                                            co2 = co2.split("-");
                                            co2 = co2[0].trim();
                                        if (co2 === marcod) {
                                            repetido = true;
                                            $('#grilla tbody tr').eq(index).each(function() {
                                                $(this).find('td').each(function(i) {
                                                    if(i===2){
                                                        $(this).text(marca);
                                                    }
                                                    if(i===3){
                                                        $(this).text(cantidad);
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
            if(!repetido){
            $("#grilla > tbody:last").append("<tr><td>"+producto+"</td><td>"+destinoc+"</td><td>"+marca+"</td><td>"+cantidad+"</td><td>"+recib+
                "<button type=\'button\' class=\'btn btn-xs btn-danger quitar pull-right\' "+
                "data-placement=\'top\' title=\'Quitar\'><i class=\'fa fa-times\'></i></button></td></tr>");
            }
            var subtotal=0,a=0;
            $("#grilla tbody tr").find("td:eq(4)").each(function() {
                a = $(this).text();
                subtotal = parseInt(subtotal)+parseInt(a);
            });
            $("#total").html('Total: '+subtotal+' Gs.');
        }else{
          humane.log("<span class='fa fa-info'></span> Complete todos los campos",{ timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
        }
        
        
    });
    
    //GUARDAR
    $(document).on("click","#guardar",function(){
        var usu             = $("#usuario").val();
        var suc             = $("#sucursal").val();
        var vencod          = $("#ventas").val();
        var vehiculo        = $("#vehiculos").val();
        var chofer          = $("#choferes").val();
        var tipoNota        = $("#tipoNota").val();
        var timbrado        = $("#timbrado").val();
        var timVig          = $("#timbVigHasta").val();
        var nroFact         = $("#nroFactura").val();
        var montoFactura    = $("#montoFactura").val();
        var detalle         = $("#detalle").val();
        var oper            = $("#ope").val();

        if(tipoNota === 'INTERNO'){
            timbrado        = 0
            timVig          = "1/1/1111"
            nroFact         = "-"
            montoFactura    = 0
            if(detalle ==="" || chofer == 0 || vehiculo == 0){
                humane.log("<span class='fa fa-info'></span> Complete todos los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
                return
            }
        }
        debugger
        if(tipoNota === 'EXTERNO'){
            if(detalle ==="" || chofer == 0 || vehiculo == 0 || timbrado ==="" || timVig ==="" || nroFact ==="" || montoFactura === "" ){
                humane.log("<span class='fa fa-info'></span> Complete todos los campos 2", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
                return
            }
        }

        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo: 0,vencod:vencod, vehiculo:vehiculo, chofer:chofer, tipoNota:tipoNota, timbrado:timbrado, timVig:timVig, nroFact:nroFact, montoFactura:montoFactura, usu:usu, suc:suc, detalle:detalle, ope:oper}
        }).done(function(msg){
            mostrarMensaje(msg);
            vaciar();
            ultcod();
            refrescarDatos();
        });
    });
    
    //QUITAR
    $(document).on("click",".quitar",function(){
        var pos = $(".quitar").index(this);
        $("#grilla tbody tr:eq("+pos+")").remove();
        var subtotal=0,a=0;
        $("#grilla tbody tr").find("td:eq(4)").each(function() {
            a = $(this).text();
            subtotal = parseInt(subtotal)+parseInt(a);
        });
        $("#total").html('Total: '+subtotal+' Gs.');
    });
    
    //ANULAR
    $(document).on("click",".delete",function(){
         var pos = $( ".delete" ).index( this );
        $("#transferencia tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
            var cod;
            cod = $(this).html();
            $("#delete").val(cod);
            $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea eliminar el Registro Nro. '+cod+' ?</h4>');
        });
        // $(".modal-header").html('<h4 class="modal-title" id="myModalLabel">DESEA ANULAR LA TRANSFERENCIA NRO. '+codigo+' ?</h4>');
    });
    $(document).on("click","#delete",function(){
        var cod = $("#delete").val();
        $.ajax({
            url: "grabar.php",
            type: "POST",
            data: {codigo: cod,vencod:0, vehiculo:0, chofer:0, tipoNota:'', timbrado:0, timVig:'1/1/1111', nroFact:'', montoFactura:0, usu:0, suc:0, detalle:'{}', ope:2}
        }).done(function(msg){
            $("#hide").click();
            mostrarMensaje(msg);
            refrescarDatos();
        });
    });
    
    function ultcod(){
        $.ajax({
           type: "POST",
           url: "ultcod.php"
        }).done(function(msg){
            $("#cod").val(msg);
        });
    }

    function vaciar(){
        $("#grilla tbody tr").remove();
        $("#vehiculos").val("0").trigger('change');
        $('#tipoNot').val("INTERNO").trigger('change');
        $('#choferes').val("0").trigger('change');
        $('#timbrado').val("");
        $("#timbVigHasta").val("");
        $("#nroFactura").val("");
        $("#montoFactura").val("");
    }

    function refrescarDatos(){
        tabla.fnReloadAjax();  
    };

    function cargarGrillas(){
        detalle="{";
        $("#grilla tbody tr").each(function(index) {
            var campo1,campo3, campo2, campo4;
            detalle = detalle + '{';
            $(this).children("td").each(function(index2) {
                switch (index2) {
                    case 0:
                        campo1 = $(this).text();// codigo
                        detalle = detalle + campo1 + ',';
                        break;
                    case 2:
                        campo2 = $(this).text().split("-");//marca
                        campo2= campo2[0].trim();
                        detalle = detalle + campo2 + ',';
                        break;
                    case 3:
                        campo3 = $(this).text()//cantidad
                        detalle = detalle + campo3 + ',';
                        break;
                    case 4:
                        campo4 = $(this).text();//precio
                        detalle = detalle + campo4;
                        break;  
                }
            });
            if (index < $("#grilla tbody tr").length - 1) {
                detalle = detalle + '},';
            } else {
                detalle = detalle + '}';
            }
        });
        detalle= detalle + '}';
        $('#detalle').val(detalle);
    }   

    // Insert detalle desde la tabla transferncias_det -envio
    $(document).on('change','#ventas',function(e){
        var transenvio = $(this).val();
        $.ajax({
            url: 'ventasDetalles.php',
            type: 'POST',
            data: {trans:transenvio}
        }).done(function(msg){
            if(msg.trim() != 'error'){
                datos = JSON.parse(msg);
                console.log(datos);
                $('#grilla > tbody > tr').remove();
                $('#grilla > tbody:last').append(datos.filas);
                cargarGrillas();
            }else{
                humane.log("<span class='fa fa-info'></span>  ESTA TRANSFERENCIA NO EXITE O BIEN YA FUE RECEPCIONADA !!!", { timeout: 6000, clickToClose: true, addnCls: 'humane-flatty-error' });
            }
        });
    });

    //FUNCION PARA MOSTRAR MENSAJES DESDE LA RESPUESTA DE LAS  CONSULTAS SQL
    function mostrarMensaje(msg){
        var r = msg.split("_/_");
        var texto = r[0];
        var tipo = r[1];
        if(tipo.trim() == 'notice'){
            texto = texto.split("NOTICE:");
            texto = texto[1];
            humane.log("<span class='fa fa-check'></span> "+texto, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
        }else if(tipo.trim() == 'error'){
            texto = texto.split("ERROR:")
            texto = texto[2];
            humane.log("<span class='fa fa-info'></span> "+texto, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-error' });
        }
    }

    $(function () {
        $(".chosen-select").chosen({width: "100%"});
    });
});