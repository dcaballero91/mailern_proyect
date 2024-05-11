$(function(){
    //definimos que el campo de texto con id cantidad
    //solo acepte numeros, utilizando la funcion del plugin jquery.numeric.js
    
   //se declara una variable tabla en el cual se inicializa el dataTable y se especifican la columnas
    //que va a contener y las etiquetas de los datos json de la cabecera.
    //Para el detalle se agrega una columna extra que va accionar el contenido del detalle
   var tabla =  $('#lista').dataTable({
        "columns":
        [   {//se agrega una columna extra que va a contener la clase "details-conrol"
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
            
        ],
        "order": [[1, 'asc']]
    });
   //se le pasa la funcion fnReloadAjax a la variable tabla, y llamamos a datos.php que contiene los datos json
   tabla.fnReloadAjax( 'datos.php' );
   
   //inicio de la funcion details-row del dataTable
      var detailRows = [];      
      
    $('#lista tbody').on( 'click', 'tr td.details-control', function () {  
        var tr = $(this).closest('tr');
        var row = $('#lista').DataTable().row( tr );
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
        $.each( detailRows, function ( i, id ) {
            $('#'+id+' td.details-control').trigger( 'click' );
        } );
    } );
 
 //funcion encargada de capturar y mostrar los datos del detalle
 function format ( d ) {
    // `d` contiene los datos originales de la fila presionada (que se encuentra en datos.php)
    //se declara la variable deta que va a contener la tabla del detalle
   var deta ='<table class="table table-bordered"><tr class="info"><th>Código</th><th>Producto</th><th>Precio</th><th>Cantidad</th><th>SubTotal</th></tr>';
    //tambien declaramos la variable total y le asignamos un valor de 0
     var total = 0;
     //y utilizamos un bucle for para crear todas las filas de la tabla detalle.
     //for ([expresion-inicial]; [condicion]; [expresion-final])
     //Dentro del parentesis; como expresion-inicial declaramos una variable x que le asignamos un valor de 0
     //y como condicion decimos que si x es menor que la longitud de la matriz detalle 
     //que la expresion-final sea el valor de x sumandole una unidad en el retorno del bucle
     //mientras se cumpla la condicion
     for(var x=0;x<d.detalle.length;x++){
         //en cada recorrido obtenemos los datos de la matriz 
         //detalle en la posicion x(que inicialmente es 0,sumandole 1 en cada recorrido)
         //y por ultimo al elemento que deseamos acceder ej: d.detalle[0].precio
        deta+='<tr>'+
            '<td width=80px>'+d.detalle[x].codigo+'</td>'+
            '<td>'+d.detalle[x].descripcion+'</td>'+
            '<td width=180px>'+d.detalle[x].precio+'</td>'+
            '<td width=180px>'+d.detalle[x].cantidad+'</td>'+
            '<td width=180px>'+d.detalle[x].precio*d.detalle[x].cantidad+'</td>'+
        '</tr>';
total = parseInt(total+d.detalle[x].precio*d.detalle[x].cantidad);
        }
        //y por ultimo retornamos el valor de la variable deta
    return deta+'<tfoot><tr><th colspan="5" class="text-right" >TOTAL: '+total+' Gs.</th></tr></tfoot></table><div class="row">'+                
                '<div class="col-md-3"><strong>Empresa:</strong> </div>'+
                '<div class="col-md-3"><strong>Sucursal:</strong> </div>'+
                '<div class="col-md-2"><strong><a href="lista.php?id='+d.cod+'">Imprimir:</a></strong></div>'+
                '<div class="col-md-4"><div class="col-md-12 pull-right">'+
                '<button class="btn btn-danger btn-block" id="confirmar" data-toggle=\'modal\' data-target=\'#modal_basic\' value="'+d.cod
                +'"><span class="fa fa-minus-circle"></span> Anular</button></div>'+
                '</div></div>';
        
}
   //mostramos el ultimo codigo
   ultcod();
   //funcion para capturar el precio del producto seleccionado
   $("#art").change(function(){
       //llamamos a la funcion que solicita el precio del producto
        marca();
        precio();
        stock();
        //y automaticamente que el el cursor se posicione el campo de texto de cantidad
        $("#cantidad").focus();
    });
    //CARGAR GRILLA
    $(document).on("click","#cargar",function(){
        //declaramos las variables de los datos que queremos
        //visualizar en nuestra grilla
        var producto,cantidad,precio;
        //le asignamos el valor correspondiente a cada variable
        
        producto = $("#art").val();
        cantidad = $("#cantidad").val();
        precio = $('#precio').val();
        var desc=$("#art option:selected").text();
        //si el valor de las variables son distintas de vacio
        if(producto!=="" && cantidad!==""){
            //declaramos una variable repetido con valor false
            var repetido = false;
            //y una variable co con valor 0
            var co = 0;
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
                            //entonces le asignamos el valor de true (verdadero) a 
                            //la variable repetido
                            repetido = true;
                            //y recorremos la fila equivalente a index(que tiene el valor de la fila con codigo repetido)
                            $('#grilla tbody tr').eq(index).each(function() {
                                //y buscamos todos los td de esa fila
                                $(this).find('td').each(function(i) {
                                    //si i(posicion de td) es igual a 3
                                    if(i===3){
                                        //entonces actualizamos el valor de cantidad
                                        $(this).text(cantidad);
                                    }
                                    //si i(posicion de td) es igual a 4
                                    if(i===4){
                                        //entonces actualizamos el valor del subtotal
                                        $(this).html(precio*cantidad+
                                        '<button type=\'button\' class=\'btn btn-xs btn-danger quitar pull-right\' data-placement=\'top\' '+
                                        'title=\'Quitar\'><i class=\'fa fa-times\'></i></button>');
                                    }

//if (pre<=0) {
  //   humane.log("<span class='fa fa-info'></span> La cantidad debe ser mayor a 0", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
    //};
                                    
                                });
                            });
                        }
                    }

                });
            });
            //si no es repetido
            if(!repetido){
                //se agrega una nueva fila con los datos cargados
        $("#grilla > tbody:last").append("<tr><td>"+producto+"</td><td>"+desc+"</td><td>"+precio+"</td><td>"+cantidad+"</td><td>"+precio*cantidad+
                "<button type=\'button\' class=\'btn btn-xs btn-danger quitar pull-right\' "+
                "data-placement=\'top\' title=\'Quitar\'><i class=\'fa fa-times\'></i></button></td></tr>");
                    }
            //se vacian los campos
            vaciar();
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
            //si los campos que se desean agregar a la grilla estan vacios
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
        //declaramos las variables que vamos a enviar a nuestro SP
        var cod,emp,suc,fun,detalle;
        cod = $("#cod").val();
        suc = $("#suc").val();
        emp = $("#emp").val();
        fun = $("#fun").val();
        
        //la variable detalle va a tener un valor inicial de "{"
        detalle="{";
        //recorremos nuestra grilla
        $("#grilla tbody tr").each(function(index) {
               //declaramos variables campo 1 y campo3
               //para guardar valores especificos de las columnas de nuestro interes;
            var campo1,campo3, campo2;
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
                    case 2:
                        //capturamos el valor de la columna 0 y le asignamos ese valor a la variable campo1
                        campo2 = $(this).text();
                        //y concatenamos al valor de detalle, el valor de campo1 mas ','
                        detalle = detalle + campo2 + ',';
                        //y finalizamos la ejecucion del caso
                        break;
                    //en el caso que index2 sea 3
                    case 3:
                        //capturamos el valor de la columna 3 y le asignamos ese valor a la variable campo3
                        campo3 = $(this).text();
                        //y concatenamos al valor de detalle, el valor de campo3 mas ','
                        detalle = detalle + campo3;
                        //y finalizamos la ejecucion del caso
                        break;
                        

                }
            });
            //index equivale a tr, es decir el numero de la posicion de una determinada fila. ej: tr(0),tr(1),tr(2)...tr(n);
            //Entonces decimos, si index es menor a la longitud de filas de la tabla con id grilla -1 (menos una unidad)
            //Obs: Restamos una unidad a la longitud por que la longitud empieza contando a partir de uno (1), recordemos que 
            //las posiciones de las filas empiezan contando a partir de cero. ej: tr(0) 
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
        //Y decimos, si detalle es distinto de {} y cliente sea distinto de vacio
        if(detalle!=="{}" && fun!==""){
            //realizamos la peticion
        $.ajax({
            //definimos el tipo
           type: "POST",
           //la ruta
           url: "grabar.php",
           //y por ultimo los datos a enviar
           data: {codigo:0,cod: cod, emp: emp, suc: suc, fun: fun, detalle: detalle, ope: 'insercion'}
        }).done(function(msg){
            //por ultimo capturamos la respuesta y lo mostramos en un alert,
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            //vaciamos la tabla
        $("#grilla tbody tr").remove();
        //y vaciamos todos los campos
        $('#fun > option[value=""]').attr('selected',true);
        $('#fun').selectpicker('refresh');
        vaciar();
        $("#total").html('Total: 0.00 Gs.');
        //solicitamos el ultimo codigo actual
        ultcod();
        //y los datos actualizados de la lista de pedidos
        refrescarDatos()();
        });
        
    //si solamente el cliente esta vacio
    }else if(fun===""){
       //notificamos al usuario que debe completar el campo
        humane.log("<span class='fa fa-info'></span> Complete todos los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
    //si no se cumple ninguna condicion, quiere decir que el detalle esta vacio    
    }else{
        //notificamos al usuario que debe completar el campo
        humane.log("<span class='fa fa-info'></span> Debe agregar detalle", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
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
    $(document).on("click","#confirmar",function(){
        //capturamos el codigo
        var codigo = $(this).val();
        // y asignamos ese valor al boton "SI" que tiene id anular
        $("#anular").val(codigo);
        //y solicitamos confirmacion
        $(".modal-header").html('<h4 class="modal-title" id="myModalLabel">Desea anular el Pedido de Venta Nro. '+codigo+' ?</h4>');
    });
    
    
    $(document).on("click","#anular",function(){
        //capturamos el valor del boton con id anular
        var codigo = $(this).val();
        //y realizamos la peticion
                       $.ajax({
                          url: "grabar.php",
                          type: "POST",
                          data: {codigo:codigo,cod: '0', suc: '0', emp: '0', fun: '0', detalle: '{}', ope: 'anulacion'}
                       }).done(function(msg){
                           //cerramos el modal,
                           $("#cerrar").click();
                           // mostramos la respuesta en un alert
                            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
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


$(document).on('keypress','#ped',function(e){
        if(e.which===13){
            var pedidoId = $(this).val();
           
            cuota = [];
            $.ajax({
                url: 'pedido.php',
                type: 'POST',
                data: {pedido:pedidoId}
            }).done(function(msg){
            datos = JSON.parse(msg);
            $('#grilla > tbody > tr').remove();
            $('#grilla > tbody:last').append(datos.filas);
            $('#total').html('<strong>'+datos.total+' Gs.</strong>');
        
        });
        
        };
    });









//funcion para capturar el precio del producto
function precio(){
    //guardamos el valor del codigo del producto en la variable cod
    var cod = $('#art').val();
    //si cod es distinto de vacio
    if(cod!==""){
        //realizamos la peticion
    $.ajax({
           type: "POST",
           url: "precio.php",
           data: {cod: cod}
       }).done(function(msg){
           //y mostramos la respuesta en el campo de texto precio
            $("#precio").val(msg);
        });
    }else{
        //si no, vaciamos el campo de texto precio
        $("#precio").val('');
    }
}
function stock(){
        var cod = $('#art').val();
        $.ajax({
            type: "POST",
            url: "stock.php",
            data: {cod: cod}
        }).done(function(stock){
            $("#stock").val(stock);
            $("#stock").focus();
        });
    }
    function marca(){
        var cod = $('#art').val();
        $.ajax({
            type: "POST",
            url: "marcas.php",
            data: {cod: cod}
        }).done(function(marca){
            $("#marca").val(marca);
            $("#marca").focus();
        });
    }

//vaciar campos
function vaciar(){
    $('#art > option[value=""]').attr('selected',true);
    $('#art').selectpicker('refresh');
    $("#precio").val("");
    $("#cantidad").val("");
}

//llamar datos actualizados
function refrescarDatos(){
  tabla.fnReloadAjax();  
};
});