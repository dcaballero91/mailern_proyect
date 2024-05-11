$(function(){
var Path ='imp_ajustes.php';
//alert(" Hola !! ");
var ajustes = $('#ajustes').dataTable( {
        "columns": [
            {
                "class":          "details-control",
                "orderable":      false,
                "data":           null,
                "defaultContent": "<a><span class='fa fa-plus'></span></a>"
            },
            { "data": "codigo" },
            { "data": "fecha" },
            { "data": "empresa" },
            { "data": "sucursal" },
            { "data": "tipoajuste" },
           //  { "data": "funcionario" },
            { "data": "estado" },
            { "data": "acciones"}
        ], "order": [[1, 'asc']]
    } );

ajustes.fnReloadAjax('datos.php');
 function refrescarDatos(){
      ajustes.fnReloadAjax();
  }

 var detailRows = [];
      
   $('#ajustes tbody').on( 'click', 'tr td.details-control', function () {        
        var tr = $(this).closest('tr');
        var row = $('#ajustes').DataTable().row( tr );
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
    ajustes.on( 'draw', function () {
        $.each( detailRows, function ( i, cod ) {
            $('#'+cod+' td.details-control').trigger( 'click' );
        } );
    } );
 
function format ( d )
{ 
    // `d` is the original data object for the row
    var deta ='<table  class="table table-striped table-bordered nowrap table-hover">\n\
<tr width=80px class="info"><th>Codigo</th><th>Deposito</th><th>Item</th><th>Marca</th><th>Motivo Ajuste</th><th>Cantidad</th></tr>';
    //var total=0;
    //var subtotal;
     for(var x=0;x<d.detalle.length;x++){
      //   subtotal = d.detalle[x].cantidad * d.detalle[x].precio;
        // total += parseInt(subtotal);

        deta+='<tr>'+
            '<td width=10px>'+d.detalle[x].cod+'</td>'+
            '<td width=50px>'+d.detalle[x].dep+'</td>'+
            '<td width=80px>'+d.detalle[x].item+'</td>'+
            '<td width=80px>'+d.detalle[x].marca+'</td>'+
            '<td width=50px>'+d.detalle[x].motivo+'</td>'+
            '<td width=50px>'+d.detalle[x].cantidad+'</td>'+
            //'<td width=10px>' + subtotal + '</td>' +
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
        '<td></td>' +
       // '</tr>' +
       // '<tr>' +
       // '<td>Total</td>' +
       // '<td></td>' +
       // '<td></td>' +
       // '<td></td>' +
       // '<td>'+ total+' Gs.</td>' +
        '</tr>' +
        '</tfoot>' +
        '</table></center>';

   return deta+'<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
                <div class="row">'+                
                        
                 '<div class="col-md-2">' +
                    '<div class="col-md-12 pull-center">'+
                       
                   '<a href="../informes/'+Path+'?id='+d.codigo+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                   //'<a href="'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                    
                '</div>'+

                '</div>';
}


// INSERTAR GRILLA DE PEDIDO Compras

   // funciones
    $("#dep").change(function(){
        deposito_item();
    });

   function deposito_item(){
    if($("#dep").val() > 0){

        var dep = $("#dep").val();
        var suc = $("#sucursal").val();
        let fragment = document.createDocumentFragment()
        let item = document.getElementById('item');
        $.ajax({
            type: 'POST',
            url: 'dep_item.php',
            data:{dep:dep, suc:suc}
        }).done(function(data){

            let datajson = JSON.parse(data);       
                
                for(const info of datajson){
                const selectItem = document.createElement('OPTION');
                selectItem.setAttribute('value', info["item_cod"]);
                selectItem.textContent= `${info.item_desc}`;

                fragment.append(selectItem);
                }
                $("#item").children('option').remove();

                let primeroption = document.createElement('OPTION')
                primeroption.setAttribute('value', 0)
                primeroption.textContent = 'Elija una opcion';
                item.insertBefore(primeroption, item.children[0]);

                item.append(fragment);
                $("#item").selectpicker('refresh')

        });
    }else{
        $("#item").children('option').remove();
        let primeroption = document.createElement('OPTION')
            primeroption.setAttribute('value', 0)
            primeroption.textContent = 'Elija primero un deposito';
            item.insertBefore(primeroption, item.children[0]);

        // $('#item').selectpicker('refresh');
        $("#marcas").val(0).trigger('change');
        $("#precio").val("");
        $("#stock").val("")
        $("#tipo").val("tipo de item")
    }
}
function  stock (){
    var cod = $("#item").val();
    var mar = $("#marcas").val();
    var dep = $("#dep").val();
    // alert(` el valor de item ${cod} mar ${mar} dep ${dep}`)
     if(cod > 0){
        $.ajax({
            type: "POST",
            url: "stock.php",
            data: {cod: cod, mar:mar,dep:dep}
        }).done(function(stock){
            $("#stock").val(stock);
        });
    }
}

    $("#marcas").change(function(){
        stock();
    })

    $("#item").change(function(){
        marca();
        
    })

function marca(){
let marcas = document.getElementById('marcas');
let fragment = document.createDocumentFragment();

var dep = $("#dep").val();
var cod = $('#item').val();
    if(cod > 0 && dep > 0){
        $.ajax({
            type: "POST",
            url: "marca.php",
            data: {cod: cod, dep:dep}
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

    

 $(function(){
     
    $("#item").change(function(){
        tipoitem();
    });



     function  tipoitem(){
         var ver = $("#item").val();
        //  alert(ver)
         if(ver > 0){
            var item = $('#item').val().split('-');
            var cod = item[0];
            $.ajax({
                type: "POST",
                url: "tipoitem.php",
                data: {cod: cod}
            }).done(function(tipoitem){
                $("#tipo").val(tipoitem);
                // $("#cantidad").focus();
            });
         }
       
    }
    
    // function  stock(){
    //     var cod = $("#item").val();
    //     var mar = $("#marcas").val();
    //     var dep = $("#dep").val();
    //     alert(` el valor de item ${cod} mar ${mar} dep ${dep}`)
    //      if(cod > 0){
    //         $.ajax({
    //             type: "POST",
    //             url: "stock.php",
    //             data: {cod: cod, mar:mar,dep:dep}
    //         }).done(function(stock){
    //             $("#stock").val(stock);
    //             $("#cantidad").focus();
    //         });
    //     }
    // }

});
// Funciones

    $(document).on("click",".agregar",function(){
        $("#detalle-grilla").css({display:'block'});
        var coditems = $('#item').val();
        var marcod = $('#marcas').val();

        var items = $('#item option:selected').html();
        var marcas = $('#marcas option:selected').html();
        var motivo = $('#motivo option:selected').html();
        var codmotivo = $('#motivo').val();
        var cant = $('#cantidad').val(); 
        var cantStock = $("#stock").val();
        var tipoAjuste  = $("#tipoajuste").val() 
            // debugger
            if( parseInt(cant) > parseInt(cantStock) && tipoAjuste === "NEGATIVO"){
                // debugger
                humane.log("<span class='fa fa-info'></span> LA CANTIDAD A AJUSTAR NO PUEDE SER MAYOR A LA DISPONIBLE", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-error' });
                return
            }
                
            if(coditems!=="" && items!=="" && codmotivo>0   && cant>0){  
                var repetido = false;
                var co = 0;
                var co2 = 0;
                $("#grilladetalle tbody tr").each(function(index) {
                    $(this).children("td").each(function(index2) {
                        if (index2 === 0) {
                            co = $(this).text();
                            if (co === coditems) {
                                
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
                                                    
                                                        if(i===3){
                                                            $(this).text(motivo);
                                                        }
                                                        if(i===4){
                                                            $(this).text(cant);
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
                    $('#grilladetalle > tbody:last').append('<tr class="ultimo"><td>' + coditems + '</td><td>' + items + '</td><td>' + marcas + '</td><td>' + motivo + '</td><td>' + cant + '</td><td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
                }
            }else{ 
                humane.log("<span class='fa fa-info'></span> ATENCION!! Por favor complete todos los campos en la grilla", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
            }
        cargargrilla();
        $("#item").focus();
    });


      $(document).on("click",".eliminar",function(){
        var parent = $(this).parent();
        $(parent).remove();
        cargargrilla();
    });

    function cargargrilla() {
           
        var salida = '{';
        $("#grilladetalle tbody tr").each(function(index) {
            var campo1, campo2, campo3,campo4;
            salida = salida + '{';
            $(this).children("td").each(function(index2) {
                switch (index2) {
                    case 0:
                        campo1 = $(this).text();//item
                        salida = salida + campo1 + ',';
                        break;
                    case 2:
                        campo2 = $(this).text();// marca
                        campo2 = campo2.split("-")
                        campo2 = campo2[0].trim()
                        salida = salida + campo2 + ',';
                        break;
                    case 3:
                        campo3 = $(this).text();// motivo
                        campo3 = campo3.split("-");
                        campo3 = campo3[0].trim();
                        salida = salida + campo3 + ',';
                        break;
                    case 4:
                        campo4 = $(this).text(); // cantidad
                        salida = salida + campo4;  

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

    // FUNCION ANULAR.
    $(document).on("click",".delete",function(){
        var pos = $( ".delete" ).index( this );
        $("#ajustes tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
            var cod;
            cod = $(this).html();
            $("#delete").val(cod);
             $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea eliminar el Registro Nro. '+cod+' ?</h4>');
        });
    });

    //esta parte es para que al hacer clic pueda anular
    $(document).on("click","#delete",function(){
        var id = $( "#delete" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:id,sucursal:0,usuario:0,tipoajuste:'',deposito:0,detalle:'{{1,1,1}}',ope:2}
        }).done(function(msg){
             $('#hide').click();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
             refrescarDatos();
        });

    });
    //FIN ANULAR

    function ultcod(){
        $.ajax({
            type: 'GET',
            url: 'ultcod.php'
        }).done(function(ult){
            $("#nro").val(ult);
        })
    }

    //FUNCION INSERTAR
    $(document).on("click",".grabar",function(){
        var suc,usu,tajuste,dep,detalle;
        suc = $("#sucursal").val();
        dep = $("#dep").val();
        usu = $("#usuario").val();
        tajuste = $("#tipoajuste").val();
        detalle = $("#detalle").val();
    
        if(suc!=="",dep>0,usu!=="",tajuste!=="",detalle!==""){
       
            $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:0,sucursal:suc,usuario:usu,tipoajuste:tajuste,deposito:dep, detalle:detalle,ope:1}
            }).done(function(msg){
                mostrarMensajes(msg);

                var  r = msg.split("_/_");
                var  tipo = r[1];
                if(tipo.trim()== 'notice'){
                    vaciar();
                }
                
                refrescarDatos();
                ultcod()
            });
        }else{
         humane.log("<span class='fa fa-info'></span> Por favor verifique todos los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
        }
    });
    
    


    $(function () {
        $(".chosen-select").chosen({width: "100%"});
    });

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

    function vaciar(){
        $("#grilladetalle tbody tr").remove();
        $('#dep').val(0).trigger('change');
        $('#motivo').val(0).trigger('change');
        $("#cantidad").val("");
        $("#tipo").val("tipo de item");
        $("#dep").val("0").trigger('change');
        $("#stock").val("");
        $("#tipoajuste").val("");
        $("#item").val("0").trigger('change');
        $("#detalle").val("");
    }

});