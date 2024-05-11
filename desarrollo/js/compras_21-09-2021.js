//Obs: falta la funcion de imprimir
$(function(){

//Path variable para especificar la ruta..

var Path ='imp_compras.php';
var ordencompras = $('#ordencompras').dataTable( {
        "columns": [
            {
                "class":          "details-control",
                "orderable":      false,
                "data":           null,
                "defaultContent": "<a><span class='fa fa-plus'></span></a>"
            },
             { "data": "cod" }, 
             { "data": "nro" }, 
             { "data": "nro_factura" },
             { "data": "fecha" }, 
             { "data": "proveedor" },
             { "data": "ruc" },
             { "data": "tipo_factura" },
             { "data": "plazo" },
             { "data": "cuotas" },
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
        } );
    } );
                //TABLA DETALLE
function format ( d ) {
    // `d` is the original data object for the row
    var deta ='<table  class="table table-striped table-bordered nowrap table-hover">\n\
<tr width=90px class="info"><th>Codigo</th><th>Descripcion</th><th>Cantidad</th><th>Precio Unitario</th><th>Subtotal</th></tr>';
    var total=0;
    var subtotal=0;
     for(var x=0;x<d.detalle.length;x++){
         subtotal = d.detalle[x].cantidad * d.detalle[x].precio;
         total += parseInt(subtotal);

        deta+='<tr>'+
            '<td width=10px>'+d.detalle[x].codigo+'</td>'+
            '<td width=80px>'+d.detalle[x].descripcion+'</td>'+
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
        '<td>'+ total+' Gs.</td>' +
        '</tr>' +
        '</tfoot>' +
        '</table></center>';
                    //AQUI SE CREA LA OPCION PARA IMPRIMIR DENTRO DEL DETALLE...
    return deta+'<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
                <div class="row">'+                
                        
                 '<div class="col-md-2">' +
                    '<div class="col-md-12 pull-center">'+
                       
                   '<a href="../informes/'+Path+'?id='+d.cod+'/'+d.nro+'/'+d.nro_factura+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                            
                    
                '</div>'+

                '</div>';
}

//El signo << + >> realiza modificacion 


// INSERTAR GRILLA DE ordencompras 

     $("#item").change(function(){
        precio();
        stock();
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
            var depfinal = depcod + '. ' +   deposito;
            prec = prec.replace(" Gs.","");
            var subtotal = cant * prec;
             if(procod>0 && producto!=="" && cant>0 && prec>0 && depcod>0 && subtotal!==0){ 
            var repetido = false;
            var co = 0;
            var co2 = 0;
            let fila;
            let bandera = true;
            $("#grilladetalle tbody tr").each(function(fila1) {
                if(bandera){
                    fila = fila1;
                    alert('fila: ' + fila)
                    $(this).children("td").each(function(col1) {
                        if (col1 == 0){
                            co = $(this).text();
                            alert(`co = ${co} y el procod = ${procod}`)
                            if (co == procod) {
                                alert('coincide el producto')
                                $('#grilladetalle tbody tr:eq('+fila+')').children("td").each(function(col2) {
                                    if (col2 == 2) {
                                        co2 = $(this).text();
                                            co2 = co2.split("-");
                                            co2 = co2[0].trim();
                                        if (co2 == marcod && co == procod) {
                                            alert('coincide la marca tambien')
                                            repetido = true;
                                            $("#grilladetalle tbody tr:eq("+fila+")").children('td').each(function(i) {
                                                alert('fila a modificar ' + fila + 'columna ' + i )
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
                $('#grilladetalle > tbody:last').append('<tr class="ultimo"><td>' + procod + '</td><td>' + producto + '</td><td>' + marca + '</td><td>' + cant + '</td><td>' + prec + '</td><td>' + subtotal + '</td><td>' + depfinal + '</td><td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
            }
    }else if(cant < 0 || cant == ""){
        humane.log("<span class='fa fa-info'></span> ATENCION!! La cantidad no puede ser negativo", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
    }else{ //aqui
    humane.log("<span class='fa fa-info'></span> ATENCION!! Por favor complete todos los campos en la grilla", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
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

       

     ///FUNCION Anular

            //esta parte es para que al hacer clic se posicione y me muestre el mensaje de anular
$(document).on("click",".delete",function(){
        var pos = $( ".delete" ).index( this );

        var cod =  $("#ordencompras tbody tr:eq("+pos+")").find('td:eq(1)').html();
        var timb =  $("#ordencompras tbody tr:eq("+pos+")").find('td:eq(2)').html();
        var fact =  $("#ordencompras tbody tr:eq("+pos+")").find('td:eq(3)').html();
    //    alert(`${cod} ${timb} ${fact}`)
       
            $("#delete").val(cod+'/'+timb+'/'+fact);
            $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea eliminar el Registro Nro. '+cod+' / '+timb+' / '+fact+' ?</h4>');

    });
        //esta parte es para que al hacer clic pueda anular
    $(document).on("click","#delete",function(){
        var cod = $( "#delete" ).val();
        var todo = cod.split('/');
        var prov2 = todo[0].trim();
        var timb2 = todo[1].trim()
        var fact2 = todo[2].trim()
        alert(`Este es el prov ${prov2} timb2 ${timb2} fact2 ${fact2}`);

        var suc = $("#sucursal").val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {proveedor:prov2,timbrado:timb2,nrofact:fact2,suc:suc,usu:0,tipo_factura:0,plazo:0,cuotas:0,fechafact:'1/1/1111', depcod:0, detalle:'{{1,1,1}}',ope:2}
    
        }).done(function(msg){
            //$('#confirmacion').modal("hide");
           $('#hide').click();
            // humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
            mostrarMensajes(msg)
             refrescarDatos();
        });

    });

// fin Anular


            //FUNCION INSERTAR
// Insert
    $(document).on("click","#grabar",function(){
        //declaramos las variables que vamos a enviar a nuestro SP
        var nro,plazo,cuotas,suc,emp,usu,fun,proveedor,tipo_factura,detalle,fechafact,depcod,timbrado,nrofact,detalle;
        // nro = $("#nro").val();
        suc = $("#sucursal").val();
        usu = $("#usuario").val();
        proveedor = $("#proveedor").val();
        tipo_factura= $("#tipo_factura").val();
        plazo= $("#plazo").val();
        cuotas= $("#cuotas").val();
        fechafact = $("#fechafact").val();
        timbrado = $("#timbrado").val();
        nrofact = $("#nrofact").val();
        depcod = $("#deposito").val();

        alert(`${proveedor} ${timbrado} ${nrofact} ${fechafact} ${tipo_factura} ${plazo} ${cuotas} ${suc} ${usu} `)
        
        // emp = $("#empresa").val();
        // fun = $("#funcionario").val();
        
       
        //la variable detalle va a tener un valor inicial de "{"
        detalle="{";
        //recorremos nuestra grilla
        $("#grilladetalle tbody tr").each(function(index) {
               //declaramos variables campo 1 y campo3
               //para guardar valores especificos de las columnas de nuestro interes;
            var campo1, campo2,campo3,campo4, campo5;
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
                        campo1 = $(this).text();
                        //y concatenamos al valor de detalle, el valor de campo1 mas ','
                        detalle = detalle + campo1 + ',';
                        //y finalizamos la ejecucion del caso
                        break;
                    //en el caso de que tengas 3 detalles, descomenta el caso 2
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
                            detalle = detalle + campo5;
                        }
                    break;

                }
            });
            //index equivale a tr, es decir el numero de la posicion de una determinada fila. ej: tr(0),tr(1),tr(2)...tr(n);
            //Entonces decimos, si index es menor a la longitud de filas de la tabla con id grilla -1 (menos una unidad)
            //Obs: Restamos una unidad a la longitud por que la longitud usuieza contando a partir de uno (1), recordemos que 
            //las posiciones de las filas usuiezan contando a partir de cero. ej: tr(0) 
            if (index < $("#grilladetalle tbody tr").length - 1) {
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
        alert(detalle);
        //Y decimos, si detalle es distinto de {} y cliente sea distinto de vacio
        if(detalle!=="{}" && proveedor!=="" &&  fechafact!=="" && nrofact!==""){

            // PARA ACTUALIZAR EL orden_estado en ordenes_cab
            // let orden_cod = $("#orden").val();
            // $.ajax({
            //     type: 'POST',
            //     url: 'actualizar_ordcompra.php',
            //     data:{ordencod:orden_cod}
            // })

            //realizamos la peticion
        $.ajax({
            //definimos el tipo
           type: "POST",
           //la ruta
           url: "grabar.php",
           //y por ultimo los datos a enviar
            data: {proveedor:proveedor,timbrado:timbrado,nrofact:nrofact,fechafact:fechafact,tipo_factura:tipo_factura,plazo:plazo,cuotas:cuotas,  depcod:depcod,suc:suc,usu:usu, detalle:detalle,ope:1}
            //--ORDEN: compcod, nrocompra,succod,usucod,provcod,tipofactcod,compplazo,compcuotas,compfechafactura,provtimbcod,nrofactura,depcod, detallecompra[itemcod,compcant,comprecio,tipoimpuesto], operacion
        }).done(function(msg){
           mostrarMensajes(msg);
            //vaciamos la tabla
            $("#grilladetalle tbody tr").remove();
            //y vaciamos todos los campos
            
            vaciar();
            $("#total").html('Total: 0.00 Gs.');
            //solicitamos el ultimo codigo actual
            ultcod();
            //y los datos actualizados de la lista de pedidos
            refrescarDatos();
        });
        
        //si solamente el proveedor esta vacio
    }else if(proveedor ===""){
       //notificamos al usuario que debe completar el campo
        humane.log("<span class='fa fa-info'></span>Selecciona un proveedor. Por favor", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
    //si no se cumple ninguna condicion, quiere decir que el detalle esta vacio    
    }else if(detalle ===""){
        //notificamos al usuario que debe completar el campo
        humane.log("<span class='fa fa-info'></span> Debe agregar detalle", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
    }else{
        humane.log("<span class='fa fa-info'></span> Verifique los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
    }
        
    });
    
// Insert 

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
    
    function traerOrdenCab(ordenid){
      var ordenid = ordenid;
      alert(`este el orden ${ordenid}`)
        alert('holaaa')
            $.ajax({
                type: 'POST',
                url: 'ordencab.php',
                data:{orden:ordenid}
            }).done(function(data){
                // console.log(data)
                if(data.trim() != 'error'){
                    var datos = JSON.parse(data);
                    console.log(datos)
                    $("#proveedor").val(datos.prov_cod).trigger('change');
                    $("#proveedor").attr("disabled", true);
                    $("#tipo_factura").val(datos.tipo_fact_cod).trigger('change');
                    $("#plazo").val(datos.orden_plazo).trigger('change');
                    $("#cuotas").val(datos.orden_cuotas).trigger('change');
                }
            })
        
    }
 // fin  Insert detalle desde la tabla pedidos_compras_det

    

           
// funciones
 $("#tipo_factura").bind( "change", function(event, ui) {
    var tipo = $("#tipo_factura").val();
    if(tipo==='1'){//CONTADO
        $('#tipo').attr('style','display:none');
        $('#cuo').attr('style','display:none');
        $("#cuotas").val(0);
        $('#pla').attr('style','display:none');
        $("#plazo").val(0);
       // $('#cuotas').attr('style','display:none');
        $('#cant').attr('style','display:compact');
    }else{  ///0 CREDITO
        $('#tipo').attr('style','display:compact');
        $('#pla').attr('style','display:compact');
        $('#cuo').attr('style','display:compact');
       
    }
});


    
    function ultcod(){
        $.ajax({
            type: 'POST',
            url: 'ultcod.php'
        }).done(function(ultcod){
            $("#nro").val(ultcod)
        })
    }

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
        // $("#nro").val("");
        $("#plazo").val("");
        $("#cuotas").val("");
        $("#sucursal").val("");
        $("#empresa").val("");
        $("#usuario").val("");
        $("#funcionario").val("");
        $("#proveedor").val(0).trigger('change');
        $("#tipo_factura").val("");
        $("#timbrado").val("");
        $("#nrofact").val("");
        $("#deposito").val("");
        $("#fechafact").val("");
        $("#item").val("");
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
});

// Actualizar el timbrado  cuando cambia el proveedor
$("#proveedor").change(function(){
    timbrado_proveedor()
});

function timbrado_proveedor(){
    let timbrado2 = document.getElementById('timbrado');
    if($("#proveedor").val() > 0){

        var prov = $("#proveedor").val();
        let fragment = document.createDocumentFragment()
        $.ajax({
            type: 'POST',
            url: 'timbrado_prov.php',
            data:{prov:prov}
        }).done(function(timbrado){
            let prov_tim = JSON.parse(timbrado);
            console.log(prov_tim);
        
                for(const prov of prov_tim){
                    console.log(prov.prov_timb_nro);
                const selectItem = document.createElement('OPTION');
                selectItem.setAttribute('value', prov["prov_timb_nro"]);
                selectItem.textContent= `${prov.prov_timb_nro}`;

                fragment.append(selectItem);
                }
                $("#timbrado").children('option').remove();

                let opcion = document.createElement('OPTION');
                opcion.setAttribute('value', 0);
                opcion.textContent = 'Elija un timbrado';

                timbrado2.insertBefore(opcion, timbrado2.children[0]);
                timbrado2.append(fragment);

                timbrado2.append(fragment);
                $("#timbrado").selectpicker('refresh');                
        });
    }else{
        $("#timbrado").children('option').remove();
        let opcion = document.createElement('OPTION');
            opcion.setAttribute('value', 0);
            opcion.textContent = 'Elija primero un proveedor';

            timbrado2.insertBefore(opcion, timbrado2.children[0]);
        $("#timbrado").selectpicker('refresh');
    }
}
