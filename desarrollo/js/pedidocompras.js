
//FUNCIONA TODO!!
//alert(" hola eli ");
$(function(){
var Path ='imp_pedidocompras.php';
// var Path ='libro.pdf';
//alert(" Hola !! ");

var tabla = $('#tabla').dataTable( {
        "columns": [
            {
                "class":          "details-control",
                "orderable":      false,
                "data":           null,
                "defaultContent": "<a><span class='fa fa-plus'></span></a>"
            },
            { "data": "cod" },
            { "data": "nro" },
            { "data": "fecha" },
            { "data": "ruc" },
            { "data": "estado" },
            { "data": "acciones"}
        ]
    });

tabla.fnReloadAjax('datos.php');

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
 
function format ( d )
{ 
    // `d` is the original data object for the row
    var deta ='<table  class="table table-striped table-bordered nowrap table-hover">\n\
<tr width=80px class="info"><th>Codigo</th><th>Descripcion</th><th>Marca</th><th>Cantidad</th><th>Precio Unitario</th><th>Subtotal</th></tr>';
    var total=0;
    var totalgral = (precio);
     for(var x=0;x<d.detalle.length;x++){
         subtotal = d.detalle[x].cantidad * d.detalle[x].precio;       
         total += parseInt(subtotal);

        deta+='<tr>'+
            '<td width=10px>'+d.detalle[x].codigo+'</td>'+
            '<td width=80px>'+d.detalle[x].descripcion+'</td>'+
             '<td width=50px>'+d.detalle[x].marca+'</td>'+
            '<td width=50px>'+d.detalle[x].cantidad+'</td>'+
            
            '<td width=50px>'+d.detalle[x].precio+'</td>'+
            '<td width=10px>' + subtotal + '</td>' +
 
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
        '</tr>' +
        '<tr>' +
        '<td>Total</td>' +
        '<td></td>' +
        '<td></td>' +
         '<td></td>' +
        '<td></td>' +
        '<td>'+ total +' Gs.</td>' +
        // totales += "<th style=\"text-align: right;\"><h4>"+ totalgral.toLocaleString() +"</h4></th>";
        '</tr>' +
        '</tfoot>' +
        '</table></center>';

   return deta+'<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
                <div class="row">'+                
                        
                 '<div class="col-md-2">' +
                    '<div class="col-md-12 pull-center">'+
                       
                   '<a href="../informes/'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-primary btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                   //'<a href="'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                    
                '</div>'+

                '</div>';
}


// INSERTAR GRILLA DE PEDIDO Compras
  $(document).on("click",".agregar",function(){
            $("#detalle-grilla").css({display:'block'});
            var producto = $('#item option:selected').html();
            var marca = $('#marcas option:selected').html();

            var procod = $('#item').val();
            var marcod = $('#marcas').val();
            var cant = $('#cantidad').val();
            var prec = $('#precio').val();
            prec = prec.replace(" Gs.","");
            var subtotal = cant * prec;
            if(procod!=="" && producto!=="" && cant>0 && prec>0 && subtotal!==0 && marcod>0){  
            var repetido = false;
            var co = 0;
            var co2 = 0;
            let filac;
            let bandera = true;
            
            $("#grilladetalle tbody tr").each(function(fila) {
                if (bandera){
                    filac = fila;
                    $(this).children("td").each(function(col1) {
                        if (col1 === 0) {
                            co = $(this).text();
                            if (co === procod) {
                                    // alert('coincide el producto')
                                $("#grilladetalle tbody tr:eq("+filac+")").children("td").each(function(col2) {
                                    if (col2 === 2) {
                                            co2 = $(this).text();
                                            co2 = $(this).text();
                                            co2 = co2.split("-");
                                            co2 = co2[0].trim();
                                        if (co === procod &&co2 === marcod) {
                                            // alert('coincide la marca tambien')
                                            repetido = true
                                            $("#grilladetalle tbody tr:eq("+filac+")").children('td').each(function(i) {
                                                // alert('fila a modificar ' + filac + 'columna ' + i )
                                                    if(i===2){
                                                        $(this).text(marca);
                                                    }
                                                    if(i===3){
                                                        $(this).text(cant);
                                                    }
                                                    if(i===4){
                                                        $(this).text(prec);
                                                    }
                                                    if(i===5){
                                                        $(this).text(subtotal);
                                                    }
                                                bandera = false;
                                                // debugger
                                            }); 
                                        }
                                    }
                                });
                            }
                        }
                    });
                }
            });

            if (!repetido) {
                $('#grilladetalle > tbody:last').append('<tr class="ultimo"><td>' + procod + '</td><td>' + producto + '</td><td>' + marca + '</td><td>' + cant + '</td><td>' + prec + '</td><td>' + subtotal + '</td><td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
            }
            var subtotal=0,a=0;
            //recorremos todas las filas y buscamos la columna (columna es igual a td en html) numero 4
            $("#grilladetalle tbody tr").find("td:eq(5)").each(function() {
                //asignamos el valor de esa columna a la variable a
                        a = $(this).text();
                        //y le asignamos a la variable subtotal el valor resultante
                        //de la suma de subtotal actual + a
                        subtotal = parseInt(subtotal)+parseInt(a);
                    });
                    //y por ultimo mostramos el valor de subtotal
                    //en la fila con id total
             $("#total").html('Total: '+subtotal+' Gs.');
            }else{ 
 humane.log("<span class='fa fa-info'></span> ATENCION!! Por favor, verifique todos los campos en la grilla", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
}
        cargargrilla();
        $("#cantidad").val('');
        $("#item").focus();
    });


      $(document).on("click",".eliminar",function(){
        var parent = $(this).parent();
        $(parent).remove();
        cargargrilla();
        
    });
// starts cargargrilla
       function cargargrilla() {     
        var salida = '{';
        $("#grilladetalle tbody tr").each(function(index) {
            var campo1, campo2, campo3, campo4;
            salida = salida + '{';
            $(this).children("td").each(function(index2) {
                switch (index2) {
                    case 0:
                        campo1 = $(this).text();
                        salida = salida + campo1 + ',';
                        break;
                    case 2:
                        campo2 = $(this).text().split('-');
                        campo2 = campo2[0].trim();
                        salida = salida + campo2 + ',';
                        break;
                    case 3:
                        campo3 = $(this).text();
                        salida = salida + campo3 + ',';
                        break;
                    case 4:
                        campo4 = $(this).text();
                        salida = salida + campo4;
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

$(document).on("click",".delete",function(){
        $("#operacion").val(3)
        var pos = $( ".delete" ).index( this );
        $("#tabla tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
            var cod;
            cod = $(this).html();
            $("#delete").val(cod);
             $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea eliminar el Registro Nro. '+cod+' ?</h4>');
        });
    });
        //esta parte es para que al hacer clic pueda anular
    $(document).on("click","#delete",function(){
        var id = $( "#delete" ).val();
        var ope = $("#operacion").val()

        if(ope == 3){
            // alert(`entro en anulacion ${ope}`)
            $.ajax({
                type: "POST",
                url: "grabar.php",
                data: {codigo:id,suc:0,usu:0,detalle:'{{1,1,1}}',ope:ope}
            }).done(function(msg){
              // $('#confirmacion').modal("hide");
                  $("#hide").click();
                humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
                 refrescarDatos();
            });
        }

    });
//fin  ANULAR



            //FUNCION INSERTAR
// Insert
    $(document).on("click","#grabar",function(){
        var nro,suc,emp,usu,detalle, ope;
        suc = $("#sucursal").val();
        emp = $("#empresa").val();
        usu = $("#usuario").val();
        detalle = $("#detalle").val();
        ope = $("#operacion").val();
        if( ope !== '2'){
            if(nro!=="" && suc!=="" && emp!=="" && usu!=="" && detalle!==""){
                // alert(`entro en anulacion ${ope}`)
                $.ajax({
                type: "POST",
                url: "grabar.php",
                data: {codigo:0,suc:suc,usu:usu,detalle:detalle,ope:ope}
            }).done(function(msg){
              // alert(msg);
               
               humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
                $("#grilladetalle tbody tr").remove();
                //y vaciamos todos los campos
                $('#item').val(0).trigger('change');
                // $('#funcionario').selectpicker('refresh');
                //vaciar();
                
                //solicitamos el ultimo codigo actual
                ultcod();
                refrescarDatos();
                vaciar();
             });
          }else{
             humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
          }
        }
        });
    
// Insert


// FUNCION EDITAR
$(document).on("click", ".editar", function(){
    $("#operacion").val(2);
    $("#grabar").val('Guardar Cambios');
    var pos = $(".editar").index(this);
    let cod;
    $("#tabla tbody tr:eq("+pos+")").find('td:eq(1)').each(function(){
         cod = $(this).html();
         $("#pedidonro").val(cod);
        $.ajax({
            type:'GET',
            url: 'editar.php',
            data: {cod: cod}
        }).done(function(data){
           let datos = JSON.parse(data)
           $("#grilladetalle > tbody > tr").remove();
           $("#grilladetalle > tbody ").append(datos.filas);
            $("#nro").val(cod)
            cargargrilla();
        })
    })
});

$(document).on("click","#grabar",function(){
    var ope = $("#operacion").val()
    var pedcod = $("#pedidonro").val()
    // alert(pedcod)
    detalle = $("#detalle").val();
    if( ope == '2'){
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:pedcod,suc:0,usu:0,detalle:detalle,ope:ope}
        }).done(function(msg){
          // $('#confirmacion').modal("hide");
              $("#hide").click();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
            refrescarDatos();
            vaciar();
        });

        $("#grabar").val('Guardar')
        $("#operacion").val(1)
        $("#total").val('0 Gs.')
    }

});
// FIN FUNCION EDITAR

            ///FUNCION getvalues

 $("#item").change(function(){
     if ($("#item").val() === 0){
        $("#marca").val();
         $('#cantidad').val();
         $('#precio').val();
     }else{
        marca();
        // precio();    
        // stock();
     }
    });
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
                $("#stock").val(stock);
                $("#cantidad").focus();
            });
        }
    }

 function vaciar(){
    $('#item > option[value="0"]').attr('selected',true);
    $('#item').selectpicker('refresh');
    $("#precio").val("");
    $("#marca").val("");
    $("#stock").val("");
    $("#cantidad").val("");
    $("#grilladetalle tbody tr").remove();
}


// funciones
function ultcod(){
    $.ajax({
        type: 'GET',
        url: 'ultcod.php'
    }).done(function(msg){
        $("#nro").val(msg);
    })
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
    function refrescarDatos(){
      tabla.fnReloadAjax();
  };
    // Funciones
    $(function () {
        $(".chosen-select").chosen({width: "100%"});
    });
});

