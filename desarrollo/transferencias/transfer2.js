$(function(){

    $("#en").change(function(){
        var tipo = $("#en").val();
        if(tipo === "1"){
            document.getElementById('ope').setAttribute('value', 1);
            $("#item").attr("disabled",false)
            $("#vehiculo").attr("disabled",false)
            $("#depositoo").attr("disabled",false)
            $("#depositod").attr("disabled",false)
            $("#origen").attr("disabled",false)
            $("#destino").attr("disabled",false)
            $("#cantidad").attr("disabled",false)
            $("#feenvio").attr("disabled",false)
            $("#feentrega").attr("disabled",false)
            ultcod();
            $('#cod').attr("disabled",true);

        }else{ //recepcion
             $('#cod').removeAttr('disabled');
             document.getElementById('ope').setAttribute('value', 2);
             $("#item").attr("disabled",true);
             $("#vehiculo").attr("disabled",true)
             $("#depositoo").attr("disabled",true)
            //  $("#depositod").attr("disabled",true)
             $("#origen").attr("disabled",true)
             $("#destino").attr("disabled",true)
             $("#cantidad").attr("disabled",true)
             $("#feenvio").attr("disabled",true)
             $("#feentrega").attr("disabled",true)
             $('#cod').attr("disabled",false);
             $("#cod").focus();
        }
    })

//definimos que el campo de texto con id cantidad

    //solo acepte numeros, utilizando la funcion del plugin jquery.numeric.js
var Path ='imp_transferencia.php';
//alert(" Hola !! ");
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
            { "data": "origen" },
            { "data": "destino" },
            
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
 
 //funcion encargada de capturar y mostrar los datos del detalle
 function format ( d )
{ 
    // `d` is the origenginal data object for the row
    var deta ='<table  class="table table-striped table-bordered nowrap table-hover">\n\
<tr width=80px class="success"><th>Nro</th><th>Item</th><th>Marca</th><th>Cantidad</th><th>Deposito O</th><th>Cantidad Recibida</th><th>Depósito D</th></tr>';
    var total=0;
     for(var x=0;x<d.detalle.length;x++){
     

        deta+='<tr>'+
            '<td width=10px>'+d.detalle[x].nro+'</td>'+
            '<td width=80px>'+d.detalle[x].item+'</td>'+
            '<td width=50px>'+d.detalle[x].marca+'</td>'+
            '<td width=50px>'+d.detalle[x].cantidad+'</td>'+
            '<td width=80px>'+d.detalle[x].deposito+'</td>'+
            '<td width=50px>'+d.detalle[x].recibido+'</td>'+
            '<td width=80px>'+d.detalle[x].depositod+'</td>'+ //deposito de recepcion
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
        '<td></td>' +
        '</tr>' +
        '<tr>' +
        //'<td>Total</td>' +
   //     '<td></td>' +
    //    '<td></td>' +
    //    '<td></td>' +
       // '<td>'+ total+' Gs.</td>' +
        '</tr>' +
        '</tfoot>' +
        '</table></center>';

   return deta+'<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
                <div class="row">'+                
                        
                 '<div class="col-md-2">' +
                    '<div class="col-md-12 pull-center">'+
                       
                   '<a href="../informes/'+Path+'?id='+d.nro+'" target="_blank" class="btn btn-sm btn-success btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                   //'<a href="'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                    
                '</div>'+

                '</div>';
}
    //CARGAR GRILLA
    $(document).on("click","#cargar",function(){
        //declaramos las variables de los datos que queremos
        //visualizar en nuestra grilla
        var deposito,producto,cantidad,marcod, marca, stock;
        //le asignamos el valor correspondiente a cada variable
        deposito = $("#deposito").val();
        marca = $("#marcas option:selected").text();
        producto = $("#item").val();
        marcod = $("#marcas").val();
        cantidad = parseInt($("#cantidad").val());
        stock = parseInt($("#stocko").val());
        recib = $('#recib').val();
        var destinoc=$("#item option:selected").text();
        if(stock < cantidad){// si no se dispono la cantidad para el envio
            humane.log("<span class='fa fa-info'></span> LA CANTIDA A SER ENVIADA NO PUEDE SUPERAR LA DISPONIBILIDAD EN STOCK",{ timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-error' });

        }else if(deposito!=="" && producto!=="" && cantidad>0){
            //declaramos una variable repetido con valor false
            var repetido = false;
            //y una variable co con valor 0
            var co = 0;
            var co2 = 0;
            //recorremos la grilla
            $("#grilla tbody tr").each(function(index) {
                //recorremos todas las filas y buscamos todos los hijos inmediatos "td" de cada fila
                $(this).children("td").each(function(index2) {
                    //index2 retorna la posicion de todos los td;
                    //Si index2 (td) es identico a 0 (posicion en la que se encuentra el codigo que no queremos que se repita)
                    if (index2 === 0) {
                        //guardamos el valor de esa columna en la variable co
                        co = $(this).text();
                        //y decimos, si el valor de co es igual o identico a el
                        //valor de producto (que contiene el codigo del producto)
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
                            
                           //////////
                        }
                    }

                });
            });
            //si no es repetido
            if(!repetido){
                //se agrega una nueva fila con los datos cargados
        $("#grilla > tbody:last").append("<tr><td>"+producto+"</td><td>"+destinoc+"</td><td>"+marca+"</td><td>"+cantidad+"</td><td>"+recib+
                "<button type=\'button\' class=\'btn btn-xs btn-danger quitar pull-right\' "+
                "data-placement=\'top\' title=\'Quitar\'><i class=\'fa fa-times\'></i></button></td></tr>");
                    }
            //se vacian los campos
            // vaciar();
            //declaramos variables para mostrar el total
            var subtotal=0,a=0;
            //recorremos todas las filas y buscamos la columna (columna es igual a td en html) numero 4
            $("#grilla tbody tr").find("td:eq(4)").each(function() {
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
            //si los campos que se destinoean agregar a la grilla estan vacios
            //se mostrara un mensaje de alerta al usuario
          humane.log("<span class='fa fa-info'></span> Complete todos los campos",{ timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
        }
        
        
    });
    //Presionar enter en campo de texto cantidad
    $("#cantidad").keypress(function(e){
        //si la tecla presionada es igual a 13 (valor de la tecla ENTER en el codigo ASCII)
    if(e.which === 13){
        //que el cursor se posicione en el boton cargar
        $("#cargar").focus();
        //y que se haga un click automatico
        $("#cargar").click();
    }
    });
    
    //GUARDAR
    $(document).on("click","#guardar",function(){
        //declaramos las variables que vamos a feenvioar a nuestro SP
        var cod,sucursal,usu,feenvio, feentrega, cantidad,vehiculo,origen,destino,en,depositoo,depositod,detalle,oper;
        cod = $("#cod").val();
        sucursal = $("#sucursal").val();
        usu = $("#usuario").val();
        feenvio = $("#feenvio").val();
        feentrega = $("#feentrega").val();
        vehiculo = $("#vehiculo").val();
        origen = $("#origen").val();
        destino = $("#destino").val();
        depositoo = $("#depositoo").val();
        depositod = $("#depositod").val();
        cantidad = $("#cantidad").val();
        if($("#en").val()==0){ 
             
            en = "RECEPCION";
        }else{
            en = "ENVIO";

        }
        console.log(en);
        depositoo = $("#depositoo").val();
        depositod = $("#depositod").val();
        oper = $("#ope").val();
        // empresa = $("#empresa").val();
        // funcionario = $("#funcionario").val();
        
        
        
        //la variable detalle va a tener un valor inicial de "{"
        detalle="{";
        //recorremos nuestra grilla
        $("#grilla tbody tr").each(function(index) {
               //declaramos variables campo 1 y campo3
               //para guardar valores especificos de las columnas de nuestro interes;
            var campo1,campo3, campo2, campo4;
            // Y a la variable detalle le concatenamos una {
            detalle = detalle + '{';
              //y recorremos todos los hijos inmediatos "td" del objeto "this" (en este caso "this" hace referencia a la fila(tr))
            $(this).children("td").each(function(index2) {
                //comparamos los casos posibles con la funcion switch que recibe
                //como parametro index2 (posicion de la columna)
                switch (index2) {
                    //en el caso que index2 sea 0
                    case 0:
                        //capturamos el valor de la columna 0 y le asignamos ese valor a la variable campo1
                        campo1 = $(this).text();// codigo
                        //y concatenamos al valor de detalle, el valor de campo1 mas ','
                        detalle = detalle + campo1 + ',';
                        //y finalizamos la ejecucion del caso
                        break;
                    case 2:
                        //capturamos el valor de la columna 0 y le asignamos ese valor a la variable campo1
                        campo2 = $(this).text().split("-");//marca
                        campo2= campo2[0].trim();
                        //y concatenamos al valor de detalle, el valor de campo1 mas ','
                        detalle = detalle + campo2 + ',';
                        //y finalizamos la ejecucion del caso
                        break;
                    case 3:
                        //capturamos el valor de la columna 0 y le asignamos ese valor a la variable campo1
                        campo3 = $(this).text()//marca
                        //y concatenamos al valor de detalle, el valor de campo1 mas ','
                        detalle = detalle + campo3 + ',';
                        //y finalizamos la ejecucion del caso
                        break;
                    //en el caso que index2 sea 3
                    case 4:
                        //capturamos el valor de la columna 3 y le asignamos ese valor a la variable campo3
                        if($("#en").val() == 1){

                            campo4 = $(this).text();
                            //y concatenamos al valor de detalle, el valor de campo3 mas ','
                            detalle = detalle + campo4;
                            //y finalizamos la ejecucion del caso
                        }else{
                            campo4 = $(this).children().val();
                            //y concatenamos al valor de detalle, el valor de campo3 mas ','
                            detalle = detalle + campo4;
                            //y finalizamos la ejecucion del caso
                            
                        }
                        break;
                        

                }
            });
            //index equivale a tr, es decir el numero de la posicion de una determinada fila. ej: tr(0),tr(1),tr(2)...tr(n);
            //Entonces decimos, si index es menor a la longitud de filas de la tabla con id grilla -1 (menos una unidad)
            //Obs: Restamos una unidad a la longitud por que la longitud empieza contando a pitemir de uno (1), recordemos que 
            //las posiciones de las filas empiezan contando a pitemir de cero. ej: tr(0) 
            if (index < $("#grilla tbody tr").length - 1) {
                //si cumple la condicion, concatenamos al valor actual de detalle el siguiente valor '},'
                detalle = detalle + '},';
            } else {
                //si no es asi, concatenamos a detalle el valor '}' y damos fin al recorrido
                detalle = detalle + '}';
            }
        });
        //al valor actual de detalle concatenamos '}'
        //obteniendo asi el valor final de detalle.
        detalle= detalle + '}';

        // PREGUNTAMOS SI ES OPERACION DE ENVIO O RECEPCION
        if($("#en").val() == 1){//ENVIO

            //Y decimos, si detalle es distinto de {} y cliente sea distinto de vacio
            if(detalle!=="{}" && cantidad>0 && origen>0 && destino>0 && depositoo>0 && depositod>0 && feentrega !="" && feenvio !=""){
                        //realizamos la peticion
                    $.ajax({
                        //definimos el tipo
                    type: "POST",
                    //la ruta
                    url: "grabar.php",
                    //y por ultimo los datos a feenvioar
                    data: {codigo: cod,sucursal: sucursal,usu:usu, feenvio:feenvio, feentrega:feentrega, vehiculo:vehiculo,  origen:origen, destino:destino, en:en, depositoo: depositoo,depositod:depositod, detalle: detalle, ope: oper}
                    }).done(function(msg){
                        //por ultimo capturamos la respuesta y lo mostramos en un alert,
                            mostrarMensaje(msg);
                        //vaciamos la tabla
                            $("#grilla tbody tr").remove();
                            //y vaciamos todos los campos
                            // vaciar();
                            $('#item').val("0").trigger('change');
                            $("#cantidad").val("");
                            $("#cantidad").val("");
                            $("#feenvio").val("");
                            $("#feentrega").val("");
                            $("#vehiculo").val("0").trigger('change');
                            $("#origen").val("");
                            $("#destino").val("");
                            $('#depositoo').val("0").trigger('change');
                            $('#depositod').val("0").trigger('change');
                            //solicitamos el ultimo codigo actual
                            ultcod();
                            //y los datos actualizados de la lista de pedidos
                            refrescarDatos();
                    });
                    
                //si solamente el cliente esta vacio
                }else if(origen===""){
                //notificamos al usuario que debe completar el campo
                    humane.log("<span class='fa fa-info'></span> Complete todos los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
                //si no se cumple ninguna condicion, quiere decir que el detalle esta vacio    
                }else{
                    //notificamos al usuario que debe completar el campo
                    humane.log("<span class='fa fa-info'></span> Verifique los campos por favor!! ", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
                }
        }else{//RECEPCION 

                    if(detalle!=="{}" && origen>0 && destino>0 && depositoo>0 && depositod>0 && feentrega !="" && feenvio !=""){
                        //realizamos la peticion
                    $.ajax({
                        //definimos el tipo
                    type: "POST",
                    //la ruta
                    url: "grabar.php",
                    //y por ultimo los datos a feenvioar
                    data: {codigo: cod,sucursal: sucursal,usu:usu, feenvio:feenvio, feentrega:feentrega, vehiculo:vehiculo,  origen:origen, destino:destino, en:en, depositoo: depositoo,depositod:depositod, detalle: detalle, ope: oper}
                    }).done(function(msg){
                        //por ultimo capturamos la respuesta y lo mostramos en un alert,
                            mostrarMensaje(msg);
                        //vaciamos la tabla
                            $("#grilla tbody tr").remove();
                            //y vaciamos todos los campos
                            // vaciar();
                            $('#item').val("0").trigger('change');
                            $("#cantidad").val("");
                            $("#cantidad").val("");
                            $("#feenvio").val("");
                            $("#feentrega").val("");
                            $("#vehiculo").val("0").trigger('change');
                            $("#origen").val("");
                            $("#destino").val("");
                            $('#depositoo').val("0").trigger('change');
                            $('#depositod').val("0").trigger('change');
                            //solicitamos el ultimo codigo actual
                            ultcod();
                            //y los datos actualizados de la lista de pedidos
                            refrescarDatos();
                    });
                    
                //si solamente el cliente esta vacio
                }else if(origen===""){
                //notificamos al usuario que debe completar el campo
                    humane.log("<span class='fa fa-info'></span> Complete todos los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
                //si no se cumple ninguna condicion, quiere decir que el detalle esta vacio    
                }else{
                    //notificamos al usuario que debe completar el campo
                    humane.log("<span class='fa fa-info'></span> Verifique los campos por favor!! ", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
                }
        }
        
    });
    
    //QUITAR
    $(document).on("click",".quitar",function(){
        //asignamos a la variable  pos la posicion del boton con clase quitar
       var pos = $(".quitar").index(this);
       //Removemos la fila del boton presionado
        $("#grilla tbody tr:eq("+pos+")").remove();
        //y actualizamos el total
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
        //capturamos el valor del boton con id anular
        var cod = $("#delete").val();
        //y realizamos la peticion
                       $.ajax({
                          url: "grabar.php",
                          type: "POST",
                          data: {codigo: cod,sucursal:0,usu:0, feenvio:'1/1/1111', feentrega:'1/1/1111', vehiculo:0,  origen:0, destino:0, en:0, depositoo: 0,depositod:0, detalle: '{}', ope: 3}
                       }).done(function(msg){
                           //cerramos el modal,
                           $("#hide").click();
                           // mostramos la respuesta en un alert
                           mostrarMensaje(msg);
                           //y solicitamos los datos actualizados
                       refrescarDatos();
                       });
            
    });
    
    //funcion para obtener el ultimo codigo actual
    function ultcod(){
    $.ajax({
           type: "POST",
           url: "ultcod.php"
       }).done(function(msg){
            $("#cod").val(msg);
        });
}




$("#item").change(function(){
    marca();
})

function marca(){
let marcas = document.getElementById('marcas');
let fragment = document.createDocumentFragment();

var cod = $('#item').val();
var dep = $("#depositoo").val();
    if(cod > 0){
        $.ajax({
            type: "POST",
            url: "marcas.php",
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

                // $("#precio").val("");
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

          $("#stocko").val("0");
            $("#stockd").val("0");
        // $("#precio").val("")
    }
}

$("#marcas").change(function(){
    stockOrigen();
    stockDestino();
})

function stockOrigen(){
    var dep = $("#depositoo").val();
    var item = $("#item").val()
    if(dep>0 && item >0){
        $.ajax({
            type: 'GET',
            url: 'stock.php',
            data:{dep:dep, item:item}
        }).done(function(stock){
            // alert(stock)
            $("#stocko").val(stock);
        })
    }

}


function stockDestino(){
    var dep = $("#depositod").val();
    var item = $("#item").val()
    if(dep>0 && item >0){
        $.ajax({
            type: 'GET',
            url: 'stock.php',
            data:{dep:dep, item:item}
        }).done(function(stock){
            // alert(stock)
            $("#stockd").val(stock);
        })
    }

}

//vaciar campos
function vaciar(){
    $('#item > option[value=""]').attr('selected',true);
    $('#item').selectpicker('refresh');
    $("#cantidad").val("");
    $("#cantidad").val("");
    //  $("#cod").val("");
    $("#sucursal").val("");
    $("#usuario").val("");
    $("#feenvio").val("");
    $("#feentrega").val("");
    $("#vehiculo >option[value='']").attr('selected',true);
    $("#vehiculo").selectpicker('refresh');
    $("#origen").val("");
    $("#destino").val("");
    $('#depositoo >option[value=""]').attr('selected',true);
    $('#depositoo').selectpicker('refresh');
    $('#depositod >option[value=""]').attr('selected',true);
    $('#depositod').selectpicker('refresh');
    //   $("#ope").val();
}

//llamar datos actualizados
function refrescarDatos(){
  tabla.fnReloadAjax();  
};
// Insert detalle desde la tabla transferncias_det -envio
$(document).on('keypress','#cod',function(e){
    if(e.which===13){
        var transenvio = $(this).val();
       
        $.ajax({
            url: 'transenvio.php',
            type: 'POST',
            data: {trans:transenvio}
        }).done(function(msg){
            if(msg.trim() != 'error'){

                datos = JSON.parse(msg);
                console.log(datos);
                $('#grilla > tbody > tr').remove();
                $('#grilla > tbody:last').append(datos.filas);
            }else{
                humane.log("<span class='fa fa-info'></span>  ESTA TRANSFERENCIA NO EXITE O BIEN YA FUE RECEPCIONADA !!!", { timeout: 6000, clickToClose: true, addnCls: 'humane-flatty-error' });
            }
    
    });
    
    };
});

$(document).on('keypress','#cod',function(e){
    if(e.which===13){
        var transenvio = $(this).val();
       
        cuota = [];
        $.ajax({
            url: 'trans_cab.php',
            type: 'POST',
            data: {transcab:transenvio}
        }).done(function(msg){
            // alert(msg)
            if(msg.trim() != 'error'){

                data = JSON.parse(msg);
                console.log(data);
              
                $("#origen").val(data[0].trans_origen).trigger("change");
                $("#origen").attr('disabled',true);
                $("#destino").val(data[0].trans_destino).trigger("change");
                $("#destino").attr('disabled',true);
                $("#vehiculo").val(data[0].vehi_cod).trigger("change");
                $("#vehiculo").attr('disabled',true);
                $("#feenvio").val(data[0].fecha_envio).trigger('change');
                $("#feenvio").attr('disabled', true);
                $("#cantidad").attr('disabled', true);
                $("#feentrega").val(data[0].fecha_entrega).trigger("change");
                $("#feentrega").attr('disabled', true);

                setTimeout(function(){ hola(transenvio); }, 2000);
            }
    
    });
    
    };
});

function hola(trans){
    // alert(`ESte es el e ${trans}`)
        var transenvio = trans;
       
        cuota = [];
        $.ajax({
            url: 'trans_det.php',
            type: 'POST',
            data: {transcab:transenvio}
        }).done(function(msg){
            // alert(msg)
            if(msg.trim() != 'error'){
                
               var  data = JSON.parse(msg);
                // alert(data);
                console.log(data)
              
                $("#depositod").val(data[0].dep_destino).trigger("change");
                $("#depositoo").val(data[0].dep_origen).trigger("change");
                $("#depositod").attr('disabled',true);
            }
       
        });
    

}

    $("#origen").change(function(){
        if($("#en").val() != "0"){
            traerDepositosOrigen();
        }
    })

    function traerDepositosOrigen(){
     let fragment = document.createDocumentFragment();
     let depositos = document.getElementById('depositoo') ;  
     
     var suc = $("#origen").val();
    if(suc > 0){
        // alert(suc)
        $.ajax({
            type: "GET",
            url: "depositosOrigen.php",
            data: {suc:suc}
        }).done(function(data){
            // alert(data)
            if(data != 'error'){
            var datos = JSON.parse(data)
                // console.log(datos)
            
                for(const dep of datos){
                const selectItem = document.createElement('OPTION');
                selectItem.setAttribute('value', dep["dep_cod"]);
                selectItem.textContent= `${dep.dep_cod} - ${dep.dep_desc}`;

                fragment.append(selectItem);
                }
                $("#depositoo").children('option').remove();

                let opcion = document.createElement('OPTION');
                opcion.setAttribute('value', 0);
                opcion.textContent = 'Elija un deposito';

                depositos.insertBefore(opcion, depositos.children[0]);
                depositos.append(fragment);

                depositos.append(fragment);
                $("#depositoo").selectpicker('refresh');    
            }else{//SI AUN NO POSEE LA RELACION ITEM- MARCAS
                humane.log("<span class='fa fa-info'></span>  ESTA SUCURSAL NO POSEE DEPOSITOS AUN ", { timeout: 6000, clickToClose: true, addnCls: 'humane-flatty-error' });

                $("#depositoo").children('option').remove();
                let opcion = document.createElement('OPTION');
                    opcion.setAttribute('value', 0);
                    opcion.textContent = 'Elija primero una sucursal origen';
        
                    depositos.insertBefore(opcion, depositos.children[0]);
                $("#depositoo").selectpicker('refresh');
            } 
        });

    }else{
        $("#depositoo").children('option').remove();
        let opcion = document.createElement('OPTION');
            opcion.setAttribute('value', 0);
            opcion.textContent = 'Elija primero una sucursal origen';

            depositos.insertBefore(opcion, depositos.children[0]);
            $("#depositoo").selectpicker('refresh');

         }
    }
    // FIN TREAER DEPOSTIO ORIGEN

    
    $("#destino").change(function(){
        if($("#en").val() != "0"){

            traerDepositosDestino();
        }
    })

    function traerDepositosDestino(){
     let fragment = document.createDocumentFragment();
     let depositos = document.getElementById('depositod') ;  
     
     var suc = $("#destino").val();
    if(suc > 0){
        // alert(suc)
        $.ajax({
            type: "GET",
            url: "depositosOrigen.php",
            data: {suc:suc}
        }).done(function(data){
            // alert(data)
            if(data != 'error'){
            var datos = JSON.parse(data)
                // console.log(datos)
            
                for(const dep of datos){
                const selectItem = document.createElement('OPTION');
                selectItem.setAttribute('value', dep["dep_cod"]);
                selectItem.textContent= `${dep.dep_cod} - ${dep.dep_desc}`;

                fragment.append(selectItem);
                }
                $("#depositod").children('option').remove();

                let opcion = document.createElement('OPTION');
                opcion.setAttribute('value', 0);
                opcion.textContent = 'Elija un deposito';

                depositos.insertBefore(opcion, depositos.children[0]);
                depositos.append(fragment);

                depositos.append(fragment);
                $("#depositod").selectpicker('refresh');    
            }else{//SI AUN NO POSEE LA RELACION ITEM- MARCAS
                humane.log("<span class='fa fa-info'></span>  ESTA SUCURSAL NO POSEE DEPOSITOS AUN ", { timeout: 6000, clickToClose: true, addnCls: 'humane-flatty-error' });

                $("#depositoo").children('option').remove();
                let opcion = document.createElement('OPTION');
                    opcion.setAttribute('value', 0);
                    opcion.textContent = 'Elija primero una sucursal destino';
        
                    depositos.insertBefore(opcion, depositos.children[0]);
                $("#depositod").selectpicker('refresh');
            } 
        });

    }else{
        $("#depositod").children('option').remove();
        let opcion = document.createElement('OPTION');
            opcion.setAttribute('value', 0);
            opcion.textContent = 'Elija primero una sucursal destino';

            depositos.insertBefore(opcion, depositos.children[0]);
            $("#depositod").selectpicker('refresh');

         }
    }
    // FIN TREAER DEPOSTIO DESTINO

    //  TRAER ITEMS
    $("#depositoo").change(function(){
            traerItems();
    });

    function traerItems(){
     let fragment = document.createDocumentFragment();
     let items = document.getElementById('item') ;  
     
     var dep = $("#depositoo").val();
    if(dep > 0){
        // alert(suc)
        $.ajax({
            type: "GET",
            url: "traerItem.php",
            data: {dep:dep}
        }).done(function(data){
            // alert(data)
            if(data != 'error'){
            var datos = JSON.parse(data)
                // console.log(datos)
            
                for(const item of datos){
                const selectItem = document.createElement('OPTION');
                selectItem.setAttribute('value', item["item_cod"]);
                selectItem.textContent= `${item.item_cod} - ${item.item_desc}`;

                fragment.append(selectItem);
                }
                $("#item").children('option').remove();

                let opcion = document.createElement('OPTION');
                opcion.setAttribute('value', 0);
                opcion.textContent = 'Elija un item';

                items.insertBefore(opcion, items.children[0]);
                items.append(fragment);

                items.append(fragment);
                $("#item").selectpicker('refresh');    
            }else{//SI ESTE DEPOSITO NO POSEE ITEMS
                humane.log("<span class='fa fa-info'></span>  ESTE DEPOSITO AUN NO TIENE ITEMS PARA TRANSFERIR ", { timeout: 6000, clickToClose: true, addnCls: 'humane-flatty-error' });

                $("#item").children('option').remove();
                let opcion = document.createElement('OPTION');
                    opcion.setAttribute('value', 0);
                    opcion.textContent = 'Elija primero un deposito origen';
        
                    items.insertBefore(opcion, items.children[0]);
                $("#item").selectpicker('refresh');
            } 
        });

    }else{
        $("#item").children('option').remove();
        let opcion = document.createElement('OPTION');
            opcion.setAttribute('value', 0);
            opcion.textContent = 'Elija primero una deposito origen';

            items.insertBefore(opcion, items.children[0]);
            $("#item").selectpicker('refresh');

            let marcas = document.getElementById('marcas')
            $("#marcas").children('option').remove();
            let opcion2 = document.createElement('OPTION');
            opcion2.setAttribute('value', 0);
            opcion2.textContent = 'Elija primero un item';

            marcas.insertBefore(opcion2, marcas.children[0]);
            $("#marcas").selectpicker('refresh');

            $("#stocko").val("0");
            $("#stockd").val("0");
         }
    }
// FIN TRAER ITEMS

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

// fin  Insert detalle desde la tabla pedidos_compras_det

$(function () {

    $(".chosen-select").chosen({width: "100%"});
});
});