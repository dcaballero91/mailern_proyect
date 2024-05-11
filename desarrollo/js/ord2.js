
//FUNCIONA TODO!!
//alert(" hola eli ");
$(function(){
var Path ='imp_ordenestrabajos.php';
var tabla = $('#tabla').dataTable( {
        "columns": [
            {
                "class":          "details-control",
                "orderable":      false,
                "data":           null,
                "defaultContent": "<a><span class='fa fa-plus'></span></a>"
            },
            { data: "cod" },
            { data: "empresa" },
            { data: "sucursal" },
            { data: "cliente" },
            { data: "funcionario" },
            { data: "estado" },
            { data: "acciones" }
        ],
        language: {
            "sSearch":"Buscar: ",
            "sInfo":"Mostrando resultados del _START_ al _END_ de un total de _TOTAL_ registros",
            "sInfoFiltered": "(filtrado de entre _MAX_ registros)",
            "sZeroRecords":"No hay resultados",
            "sInfoEmpty":"No hay resultados",
            "oPaginate":{
            "sNext":"Siguiente",
            "sPrevious":"Anterior"
          }
        }
    } );

    if(tabla != 'error'){
        tabla.fnReloadAjax('datos.php');
    }

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
        }else {
            
            tr.addClass( 'details' );
            row.child(format(row.data())).show();
            if ( idx === -1 ) {
                detailRows.push( tr.attr('id') );
            }
            $(this).html("<a><span class='fa fa-minus'></span></a>");
            // Add to the 'open' array
        }
    });
 
    // On each draw, loop over the `detailRows` array and show any child rows
    tabla.on( 'draw', function () {
        $.each( detailRows, function ( i, cod ) {
            $('#'+cod+' td.details-control').trigger( 'click' );
        });
    });

function format(d) {
    // `d` is the original data object for the row
    var deta =
      '<table  class="table table-striped table-bordered nowrap table-hover">\n\
    <tr width=80px class="info"><th>Codigo</th><th>Tipo Servicio</th><th>Hora desde</th><th>Hora hasta</th><th>Sugerencias</th><th>Precio</th><th>Subtotal</th></tr>';
    var total = 0;
    var subtotal = 0;
    for (var x = 0; x < d.detalle.length; x++) {
      subtotal = d.detalle[x].precio; // + d.detalle[x].precio;    ///////*****
      total += parseInt(subtotal);

      deta +=
        "<tr>" +
        "<td width=10px>" +
        d.detalle[x].cod +
        "</td>" +
        "<td width=80px>" +
        d.detalle[x].tservicio +
        "</td>" +
        "<td width=50px>" +
        d.detalle[x].hdesde +
        "</td>" +
        "<td width=50px>" +
        d.detalle[x].hhasta +
        "</td>" +
        "<td width=50px>" +
        d.detalle[x].sugerencias +
        "</td>" +
        "<td width=10px>" +
        d.detalle[x].precio +
        "</td>" +
        "<td width=10px>" +
        subtotal +
        "</td>" +
        "</tr>";
    }
    deta +=
      "</tbody>" +
      "<tfoot>" +
      "<tr>" +
      "<td></td>" +
      "<td></td>" +
      "<td></td>" +
      "<td></td>" +
      "<td></td>" +
      "<td></td>" +
      "<td></td>" +
      "</tr>" +
      "<tr>" +
      "<td>  TOTAL</td>" +
      "<td></td>" +
      "<td></td>" +
      "<td></td>" +
      "<td></td>" +
      // '<td></td>' +
      "<td></td>" +
      "<td>" +
      total +
      " Gs.</td>" +
      "</tr>" +
      "</tfoot>" +
      "</table></center>";

    return (
      deta +
      '<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
                <div class="row">' +
      '<div class="col-md-2">' +
      '<div class="col-md-12 pull-center">' +
      '<a href="../informes/' +
      Path +
      "?id=" +
      d.cod +
      '" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>' +

      "</div>" +
      "</div>"
    );
  }


    //INICIO PRIMERA GRILLA
    $(document).on("click",".agregar",function(){
            $("#detalle-grilla").css({display:'block'});
            var servicios = $('#serv option:selected').html();
            var servcod = $('#serv').val();
            var precio = $('#precio').val();
            var fecha = $('#freserva').val();
            var hdesde = $('#hdesde').val();
            var hhasta = $('#hhasta').val();
            var des = $('#des').val();
            var funcod = $('#agencod').val();
            var funcionario = $("#agencod").val() + '-' +$("#agencod option:selected").html();
            
            //fin = fin.replace(" Gs.","");
            var subtotal = precio;
            var repetido = false;
            var co = 0;
            var co2 = 0;
            if(servcod!=="" && servicios!=="" && des!==""){
               $.ajax({
                    type: 'POST',
                    url: 'agregar.php',
                    data:{
                        funcod: funcod,
                        fecha: fecha,
                        hdesde: hdesde,
                        hhasta: hhasta
                    }
               }).done(function(msg){
                   var r = msg.split("_/_");
                   var texto = r[0];
                   var tipo = r[1];

                   if(tipo.trim() == 'notice'){
                                
                        $("#grilladetalle tbody tr").each(function(index) {
                            $(this).children("td").each(function(index2) {
                                if (index2 === 1) {
                                    co = $(this).text();
                                    if (co === servcod) {
                                        // repetido = true;
                                        $('#grilladetalle tbody tr').eq(index).each(function() {
                                            $(this).find('td').each(function(i) {
                                            if(i===7){
                                                co2 = $(this).text();
                                                co2 = co2.split("-");
                                                co2 = co2[0];
                                                // alert(`este es el co2 ${co2}`)
                                                    if(co2 === funcod){
                                                        repetido = true // SI TANTO ITEM COMO FUNCIONARIO SON IGUALES
                                                        $('#grilladetalle tbody tr').eq(index).each(function() {
                                                            $(this).find('td').each(function(i) {
                                                                if(i === 4){
                                                                    $(this).text(hdesde);
                                                                }
                                                                if(i === 5){
                                                                    $(this).text(hhasta);
                                                                }
                                                                if(i === 6){
                                                                    $(this).text(des);
                                                                }
                                                            })
                                                        })
                                                    }
                                            }
                                            });
                                        });
                                    }
                                }
                            });
                        });
                        if (!repetido){
                            $('#grilladetalle > tbody:last').append('<tr class="ultimo"><td>' + 0 + '</td><td>' + servcod + '</td><td>' + servicios + '</td><td>' + precio + '</td><td>' + hdesde + '</td><td>' + hhasta + '</td><td>' + des + '</td><td>' + funcionario + '</td><td>' + subtotal + '</td><td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
                        }
                   }else if(tipo.trim() == 'error'){// SI EL FUNCIONARIO NO ESTA DISPONIBLE
                    texto = texto.split("ERROR:");
                    texto = texto[2];
                    humane.log("<span class='fa fa-info'></span>" +texto ,{ timeout: 7000, clickToClose: true, addnCls: 'humane-flatty-error' });
                   }
               })
            
            }else{ 
                humane.log("<span class='fa fa-info'></span> ATENCION!! Por favor complete todos los campos en la grilla", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
            }
        // cargargrilla();
        $("#f_fin2").val('');
        $("#fun").focus();
    });
    //FIN PRIMERA GRILLA

    $(document).on("click",".eliminar",function(){
        var parent = $(this).parent();
        $(parent).remove();
        // cargargrilla();
    });
       


    //INSERTAR
     $(document).on("click","#grabar",function(){
        var sucursal,funcionario,detalle,usuario, cliente, inicio, fin;
        sucursal    = $("#sucursal").val();
        funcionario = $("#funcionario").val();
        cliente     = $("#cliente").val();
        inicio      = $("#hdesde").val();
        fin         = $("#hhasta").val();
        usuario     = $("#usuario").val();
        resercod    = $("#reservas").val();
        detalle="{";
        $("#grilladetalle tbody tr").each(function(index) {
            var campo1, campo2,campo3, campo4, campo5, campo6;
            detalle = detalle + '{';
            $(this).children("td").each(function(index2) {
                switch (index2) {
                    case 1:
                        campo1 = $(this).text();//codigo item
                        detalle = detalle + campo1 + ',';
                        break;
                    case 3:
                        campo2 = $(this).text();//precio
                       detalle = detalle + campo2 +  ',';
                        break;
                    case 4:
                        campo3 = $(this).text();//hdesde
                        detalle = detalle + campo3 + ',';
                        break;
                    case 5:
                        campo4 = $(this).text();//hhasta
                        detalle = detalle + campo4 + ',';
                        break;
                    case 6:
                        campo5 = $(this).text();//desc
                        detalle = detalle + campo5 + ',';
                        break;
                    case 7:
                        campo6 = $(this).text();//funcionario
                        campo6.split("-");
                        campo6 = campo6[0];
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
        if(detalle!=="{}"){
            $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:0,sucursal:sucursal,cliente:cliente,usuario:usuario, detalle:detalle,ope:1}
            // 	ORDEN: codigo, succod, clicod, usucod, detalle[itemcod, ordenprecio, hdesde, hhasta, ord_desc],  operacion
            }).done(function(msg){
                var r = msg.split("_/_");
                var  tipo = r[1];
                if(tipo.trim()== 'notice'){
                    $.ajax({
                        type: 'POST',
                        url: 'actualizar_reservas.php',
                        data:{resercod:resercod}
                    }) 
                }
                mostrarMensaje(msg)
                vaciar();
                ultcod();
                refrescarDatos();
            });
        
        }else if(cliente===""){
            humane.log("<span class='fa fa-info'></span> Complete todos los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
        }else{
            humane.log("<span class='fa fa-info'></span> Debe agregar detalle", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
        }
    });
    // FIN INSERTAR
    
    // ANULAR
    $(document).on("click",".delete",function(){
        var pos = $( ".delete" ).index( this );
        $("#tabla tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
            var cod;
            cod = $(this).html();
            $("#delete").val(cod);
            $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea eliminar la Orden de trabajo Nro. '+cod+' ?</h4>');
        });
    });

    $(document).on("click","#delete",function(){
        var id = $( "#delete" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:id, sucursal:0, cliente:0, usuario:0, detalle:'{}',ope: 3}
        }).done(function(msg){
            $("#hide").click();
            mostrarMensaje(msg);
            refrescarDatos();
        });

    });
    ///FUNCION ANULAR

    $("#item").change(function(){
        marca();
        f_ini();
        stock();
    });

    function marca(){
        var cod = $('#item').val();
        $.ajax({
            type: "POST",
            url: "marcas.php",
            data: {cod: cod}
        }).done(function(marca){
            $("#marca").val(marca);
            $("#f_fin").focus();
        });
    }
    
    function stock(){
        var cod = $('#item').val();
        $.ajax({
            type: "POST",
            url: "stock.php",
            data: {cod: cod}
        }).done(function(stock){
            $("#stock").val(stock);
            $("#f_fin").focus();
        });
    }

    function vaciar(){
        $("#grilladetalle tbody tr").remove();
        $('#item > option[value=""]').attr('selected',true);
        $('#item').selectpicker('refresh');
        $("#hdesde").val("");
        $("#hhasta").val("");
        $("#des").val("");
        $("#precio").val("")

        $("#grilla tbody tr").remove();
        $('#cliente > option[value=""]').attr('selected',true);
        $('#cliente').selectpicker('refresh');
        $("#total").html('Total: 0.00 Gs.');
        $("#reservas").val(0).trigger('change');
    }

    $("#serv").change(function(){
        cod = $(this).val();
        $.ajax({
            type: 'POST',
            url: 'precio.php',
            data:{cod: cod}
        }).done(function(precio){
            $("#precio").val(precio);
        })
    });

    $("#reservas").change(function (){
        let cod = $(this).val();
        if(cod > 0){
            reservasDetalles(cod);
            $.ajax({
                type: 'POST',
                url: 'reservasdetalles.php',
                data: {cod:cod}
            }).done(function(data){
                var datos = JSON.parse(data);
                $("#grilladetalle > tbody tr").remove();
                $("#grilladetalle > tbody").append(datos.filas)
            })
        }
    })

    function reservasDetalles(codigo){
        $.ajax({
            type: 'POST',
            url: 'reservascabecera.php',
            data:{cod:codigo}
        }).done(function(msg){
             var dame = eval("("+msg+")");
            console.log(msg)
            $("#cliente").val(dame.cli_cod).trigger('change');
            $("#cliente").attr('disabled', true)
        })
    }


// CARGAR DATOS DE FUNCIONARIOS DISPONIBLES
$("#freserva").focusout(function() {
    funcionarios_disponibles();
});
$("#dia").change(function() {
    funcionarios_disponibles();
});
$("#hdesde").focusout(function() {
    funcionarios_disponibles();
    traerdia()
  });
  $("#hhasta").focusout(function() {
    funcionarios_disponibles();
  });
  $("#agencod").focus(function() {
    funcionarios_disponibles();
  });

  
  function funcionarios_disponibles() {
    if (
      $("#freserva").val() !== "" &&
      $("#hdesde").val() !== "" &&
      $("#dia").val() !== "" &&
      $("#hhasta").val() !== ""
    ) {
      let fragment = document.createDocumentFragment();

      var fecha = $("#freserva").val();
      var hhasta = $("#hhasta").val();
      var hdesde = $("#hdesde").val();
      var hdesde = $("#hdesde").val();
      var dia = $("#dia").val();
      $.ajax({
        type: "POST",
        url: "agenda.php",
        data: {
          fecha: fecha,
          hdesde: hdesde,
          hhasta: hhasta,
          dia: dia
        }
      })
        .done(function(msg) {
          var r = msg.split("_/_");
          // console.log(`Este es la respuesta partida ${r}`);
          var texto = r[0];
          var tipo = r[1];

          if (tipo.trim()=='notice') {
            let data = JSON.parse(texto);
            // console.log(data);

            for (func of data) {
              const selectItem = document.createElement("OPTION");
              selectItem.setAttribute("value", func.funagen);
              selectItem.textContent = `${func.funagennom}`;

              fragment.append(selectItem);
            }
            $("#agencod")
              .children("option")
              .remove();
            document.getElementById("agencod").append(fragment);
            $("#agencod").prop("disabled", false);
            $("#agencod").selectpicker("refresh");
          }

          if(tipo.trim()=='error'){
            // alert("hubo un errr");
              texto = texto.split("ERROR:");
              texto = texto[2];
            $("#agencod").children("option").remove();
            $("#agencod").selectpicker("refresh");
            
            humane.log("<span class='fa fa-check'></span> " + texto, {
              timeout: 4000,
              clickToClose: true,
              addnCls: "humane-flatty-error"
            });
            
          }
        })
    }
  }

    function traerdia(){
        var dia = $("#freserva").val();
        $.ajax({
        type: 'POST',
        url: 'traerdia.php',
        data: {dia:dia}
        }).done(function(msg){
            $("#dia").val(msg);
        })
    }

    function ultcod(){
        $.ajax({
            type: 'GET',
            url: 'ultcod.php'
        }).done(function(nro){
            $("#nro").val(nro);
        })
    }

    function refrescarDatos(){
      tabla.fnReloadAjax();
    };

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
    $(function () {
        $(".chosen-select").chosen({width: "100%"});
    });

});

