//FUNCIONA TODO!!
//alert(" hola alfredo ");
$(function() {
  var Path = "imp_reservas.php";
  //alert(" Hola !! ");   //OBS! LO QUE ESTA EN EL DATATABLE ES LO QUE VISUALIZAMOS EN EL HTML..
  var reservas = $("#reservas").dataTable({
    columns: [
      {
        class: "details-control",
        orderable: false,
        data: null,
        defaultContent: "<a><span class='fa fa-plus'></span></a>"
      },
      { data: "cod" },
      { data: "empresa" },
      { data: "sucursal" },
      { data: "cliente" },
      { data: "funcionario" },
      { data: "estado" },
      { data: "acciones" }
      //   { data: "freserva" },
      //    { "data": "especialidad" },
    ],
    language:{
     "sSearch": "Buscar: "
    }
  });

  reservas.fnReloadAjax("datos.php");
  function refrescarDatos() {
    reservas.fnReloadAjax();
  }

  var detailRows = [];

  $("#reservas tbody").on("click", "tr td.details-control", function() {
    var tr = $(this).closest("tr");
    var row = $("#reservas")
      .DataTable()
      .row(tr);
    var idx = $.inArray(tr.attr("id"), detailRows);

    if (row.child.isShown()) {
      tr.removeClass("details");
      row.child.hide();
      $(this).html("<a><span class='fa fa-plus'></span></a>");
      // Remove from the 'open' array
      detailRows.splice(idx, 1);
    } else {
      tr.addClass("details");
      row.child(format(row.data())).show();
      if (idx === -1) {
        detailRows.push(tr.attr("id"));
      }
      $(this).html("<a><span class='fa fa-minus'></span></a>");
      // Add to the 'open' array
    }
  });

  // On each draw, loop over the `detailRows` array and show any child rows
  reservas.on("draw", function() {
    $.each(detailRows, function(i, cod) {
      $("#" + cod + " td.details-control").trigger("click");
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
      //'<a href="'+Path+'?id='+d.cod+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+

      "</div>" +
      "</div>"
    );
  }

  // INSERTAR GRILLA DE PEDIDO Compras

  $(document).on("click", ".agregar", function() {
    $("#detalle-grilla").css({ display: "block" });
    var codtserv = $("#tservicio").val();
    var tserv = $("#tservicio option:selected").html();
        tserv = tserv.split("-");
        tserv = tserv[1];
    var hdesde = $("#hdesde").val();
    var hhasta = $("#hhasta").val();
    var sugerencias = $("#sugerencias").val();
    var precio = $("#precio").val();
    var funcod = $("#agencod").val();
    var funcionario = $("#agencod").val() + '-'+ $("#agencod option:selected").html();;
    precio = precio.replace(" Gs.", "");
    var subtotal = precio;
    var repetido = false;
    var co = 0;
    var co2 = 0;
    $("#grilladetalle tbody tr").each(function(index) {
      $(this)
        .children("td")
        .each(function(index2) {
          if (index2 === 0) {
            co = $(this).text();
            if (co === codtserv) { 
              // repetido = true;
              $("#grilladetalle tbody tr")
                .eq(index)
                .each(function() {
                  $(this)
                    .find("td")
                    .each(function(i) { 
                      if (i === 6 ){
                        co2 = $(this).text();
                        co2 = co2.split("-");
                        co2 = co2[0];
                        alert(co2)
                        if(co2.trim() == funcod){
                          repetido = true;
                          alert(repetido)
                          $("#grilladetalle tbody tr")
                            .eq(index)
                            .each(function() {
                              $(this)
                                .find("td")
                                .each(function(i) {
                                      if (i === 1) {
                                        $(this).text(tserv);
                                      }
                                      if (i === 2) {
                                        $(this).text(hdesde);
                                      }
                                      if (i === 3) {
                                        $(this).text(hhasta);
                                      }
                                      if (i === 4) {
                                        $(this).text(sugerencias);
                                      }
                                      if (i === 5) {
                                        $(this).text(precio);
                                      } 
                                      if (i === 6) {
                                        $(this).text(funcionario);
                                      }
                                      if (i === 7) {
                                        $(this).text(subtotal);
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
    if (!repetido) {
      $("#grilladetalle > tbody:last").append(
        '<tr class="ultimo"><td>' +
          codtserv +
          "</td><td>" +
          tserv +
          "</td><td>" +
          hdesde +
          "</td><td>" +
          hhasta +
          "</td><td>" +
          sugerencias +
          "</td><td>" +
          precio +
          "</td><td>" +
          funcionario +
          "</td><td>" +
          subtotal +
          '</td><td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>'
      );
    }
    cargargrilla();
    $('#tservicio option[value="0"]').attr("selected",true);
    $("#tservicio").selectpicker('refresh');
    $("#tservicio").focus();
  });

 
  $(document).on("click", ".eliminar", function() {
    var parent = $(this).parent();
    $(parent).remove();
    cargargrilla();
  });

  // Ordena de Acuerdo a nuestro Sp de nuestra BD...
  function cargargrilla() {
    var salida = "{";
    $("#grilladetalle tbody tr").each(function(index) {
      var campo1, campo2, campo3, campo4, campo5, campo6;
      salida = salida + "{";
      $(this)
        .children("td")
        .each(function(index2) {
          switch (index2) {
           
            case 0:
            campo1 = $(this).text(); //item
            salida = salida + campo1 + ",";
            break;
            case 2:
              campo2 = $(this).text();//hdesde
              salida = salida + campo2 + ",";
              break;
            case 3:
              campo3 = $(this).text(); //hhasta
              salida = salida + campo3 + ",";
              break;
            case 4:
              campo4 = $(this).text();//descripcion
              salida = salida + campo4+",";
              break;
            //  }
            case 5:
              campo5 = $(this).text();//precio
              salida = salida + campo5 + ',';
              break;
            case 6:
              campo6 = $(this).text();//funcionario
              campo6 = campo6.split("-");
              campo6 = campo6[0].trim();
              salida = salida + campo6;
              break;
          }
        });
      if (index < $("#grilladetalle tbody tr").length - 1) {
        salida = salida + "},";
      } else {
        salida = salida + "}";
      }
    });
    salida = salida + "}";
    $("#detalle").val(salida);
  }
  //FUNCION INSERTAR
  // Insert
  $(document).on("click", "#grabar", function() {
    var rfecha, suc, agencod, cli, usu, hdesde, hhasta, detalle;
    rfecha = $("#freserva").val();
    suc = $("#sucursal").val();
    cli = $("#cliente").val();
    usu = $("#usuario").val();
    hdesde = $("#hdesde").val();
    hhasta = $("#hhasta").val();
    agencod = $("#agencod").val();
    detalle = $("#detalle").val();

    if ((rfecha !== "", suc !== "", cli !== "", usu !== "", detalle !== "", hdesde!=="", hhasta!=="",agencod!=="")) {
      $.ajax({
        type: "POST",
        url: "grabar.php",
        data: {
          cod: 0,
          suc: suc,
          cli: cli,
          usu: usu,
          rfecha:rfecha,
          agencod:agencod,
          detalle: detalle,
          ope: 1
        }
        // ORDEN: codigo, succod, clicod, usucod, detalle[reserhdesde, reserhasta, fecha, precio, item_cod, agencod, descripcion], operacion
      }).done(function(msg) {
        mostrarMensaje(msg);
        refrescarDatos();
         vaciar();
         $("#agencod").children("option").remove();
         $('#agencod >option[value="0"]').attr("selected", true);
         $("#agencod").selectpicker('refresh')
         ultcod();
      });
    } else {
      humane.log(
        "<span class='fa fa-info'></span> Por favor complete todos los campos",
        { timeout: 4000, clickToClose: true, addnCls: "humane-flatty-warning" }
      );
    }
  });

  // Insert

  $(document).on("click", ".delete", function() {
    var pos = $(".delete").index(this);
    $("#reservas tbody tr:eq(" + pos + ")")
      .find("td:eq(1)")
      .each(function() {
        var cod;
        cod = $(this).html();
        $("#delete").val(cod);
        $(".msg").html(
          '<h4 class="modal-title" id="myModalLabel">Desea cancelar la Reserva Nro. ' +
            cod +
            " ?</h4>"
        );
      });
  });
  //esta parte es para que al hacer clic pueda anular
  $(document).on("click", "#delete", function() {
    var id = $("#delete").val();
    $.ajax({
      type: "POST",
      url: "grabar.php",
      data: {
        cod: id,
        suc: 0,
        cli: 0,
        usu: 0,
        rfecha: "11/11/1111",
        agencod:0,
        detalle: "{}",
        ope: 2
      }
    }).done(function(msg) {
      // $('#confirmacion').modal("hide");
      mostrarMensaje(msg);

      $("#hide").click();

      refrescarDatos();
      // location.reload();
    });
  });
  //fin  ANULAR

  // CARGAR DATOS DE FUNCIONARIOS DISPONIBLES
  $("#freserva").focusout(function() {
    funcionarios_disponibles();
    traerdia()
  });
  $("#dia").change(function() {
    funcionarios_disponibles();
  });
  $("#hdesde").focusout(function() {
    funcionarios_disponibles();
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

          // console.log(msg);
          var r = msg.split("_/_");
          // console.log(`Este es la respuesta partida ${r}`);
          var texto = r[0];
          var tipo = r[1];

          if (tipo.trim()=='notice') {
            let data = JSON.parse(texto);
            // console.log(data);

            for (func of data) {
              const selectItem = document.createElement("OPTION");
              selectItem.setAttribute("value", func.agencod);
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
        .fail(function() {
          alert("hay un error");
        });
    }
  }

  $("#tservicio").change(function() {
    precio();
  });

  function traerdia(){
    var dia = $("#freserva").val();
    $.ajax({
      type: 'POST',
      url: 'traerdia.php',
      data: {dia:dia}
    }).done(function(msg){
      $("#dia").val(msg).trigger('change');
      $("#dia").prop("disabled", true);

    })
  }
  function vaciar(){
    $('#cliente >option[value="0"]').attr("selected",true);
    $("#cliente").selectpicker('refresh');
    $("#freserva").val("");
    $("#hdesde").val("");
    $("#hhasta").val("");
    $("#precio").val("");
    $("#sugerencias").val("");
    $('#dia >option[value="0"]').attr("selected",true);
    $("#dia").selectpicker('refresh');
    $('#agencod >option[value="0"]').attr("selected",true);
    $("#agencod").selectpicker('refresh');
    $('#tservicio >option[value="0"]').attr("selected",true);
    $("#tservicio").selectpicker('refresh');
    $("#detalle").val("");
    $("#grilladetalle tbody tr").remove();
  }
  // funciones
  function precio() {
    var cod = $("#tservicio").val();
    $.ajax({
      type: "POST",
      url: "precio.php",
      data: { cod: cod }
    }).done(function(precio) {
      $("#precio").val(precio);
      $("#precio").focus();
    });
  }
  function ultcod(){
    $.ajax({
      type: 'GET',
      url: 'ultcod.php'
    }).done(function(ultcod){
      $("#nro").val(ultcod);
    })
  }
  
  function mostrarMensaje(res){
    var r = res.split("_/_");
    var texto = r[0];
    var tipo = r[1];

    if (tipo.trim()=='notice') {
      texto = texto.split("NOTICE:");
      texto = texto[1];
      humane.log("<span class='fa fa-check'></span> " + texto, {
        timeout: 4000,
        clickToClose: true,
        addnCls: "humane-flatty-success"
      });
    }
    if (tipo.trim()=='error') {
      texto = texto.split("ERROR:");
      texto = texto[2];
      
      humane.log("<span class='fa fa-info'></span> " + texto, {
        timeout: 4000,
        clickToClose: true,
        addnCls: "humane-flatty-error"
      });
    }

  }

  // Funciones
});
