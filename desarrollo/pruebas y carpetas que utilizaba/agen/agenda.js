// location.reload(); refresca la pagina completamente.. ;)
//SalonSystems!!!  estos son los valores de mi id = agenda_cab es la parte de (agenda.datos y agenda.js)
$(function(){
  var Path ='imp_agendas.php';
   var agendas = $('#agendas').dataTable({
       "columns":
               [  
           {
            "class":          "details-control",
            "orderable":      false,
            "data":           null,
            "defaultContent": "<a><span class='fa fa-plus'></span></a>"
            },
         {"data": "codigo"},
         {"data": "funcionario"},
         {"data": "profesion"},
         {"data": "estado"},
         {"data": "acciones"}
         
         
       ]
   });
    agendas.fnReloadAjax('datos.php');
function refrescarDatos(){
      agendas.fnReloadAjax();
  }
 var detailRows = [];
      
   $('#agendas tbody').on( 'click', 'tr td.details-control', function () {        
        var tr = $(this).closest('tr');
        var row = $('#agendas').DataTable().row( tr );
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
    agendas.on( 'draw', function () {
        $.each( detailRows, function ( i, id ) {
            $('#'+id+' td.details-control').trigger( 'click' );
        } );
    } );
 
function format ( d ) {
   
    // `d` is the original data object for the row
    var deta ='<table  class="table table-striped table-bordered nowrap table-hover">\n\
<tr width=80px class="info"><th>Codigo</th><th>Especialidad</th><th>Dias de Atención</th><th>Hora Desde</th><th>Hora Hasta</th><th>Cupos</th></tr>';
  //  var total=0;
    for(var x=0;x<d.detalle.length;x++){
       //  subtotal = d.detalle[x].cantidad * d.detalle[x].precio;
      //   total += parseInt(subtotal);

        deta+='<tr>'+
            '<td width=10px>'+d.detalle[x].codigo+'</td>'+
            '<td width=180px>'+d.detalle[x].especialidad+'</td>'+
            '<td width=120px>'+d.detalle[x].dias+'</td>'+
            // '<td width=120px>'+d.detalle[x].fecha+'</td>'+
            '<td width=120px>'+d.detalle[x].hora_desde+'</td>'+
            '<td width=120px>'+d.detalle[x].hora_hasta+'</td>'+
            '<td width=120px>'+d.detalle[x].cupo+'</td>'+
           // '<td width=10px>' + subtotal + '</td>' +
        '</tr>';
        }
    deta+= '</tbody>' +
        '<tfoot>' +
        '<tr>' +
        '<td></td>' +
        '<td></td>' +
        '<td></td>' +
        '<td></td>' +
        // '<td></td>' +
        '<td></td>' +
         '<td></td>' +
        '</tr>' +
        '</tfoot>' +
        '</table></center>';
   return deta+'<tfoot><tr><th colspan="5" class="text-center" ></th></tr></tfoot></table>\n\
                <div class="row">'+                
                        
                 '<div class="col-md-2">' +
                    '<div class="col-md-12 pull-center">'+
                       
                   '<a href="../informes/'+Path+'?id='+d.codigo+'" target="_blank" class="btn btn-sm btn-info btn-block" id="print" ><span class="fa fa-print"></span><b> Imprimir</b></a>'+
                  
                    
                '</div>'+

                '</div>';
}
                                  //INICIO DE FUNCIONES GRABAR Y ANULAR!!

      //INCIO DE FUNCION GRABAR!!!

    $(document).on("click","#grabar",function(){
        var prof,fun,detalle;
       // cod = $("#codigo").val();
        prof = $("#profesion").val();
        fun = $("#funcionario").val();
        detalle = $("#detalle").val();
        
        if(prof!=="",fun!=="",detalle!==""){
       
            $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:0,profesion:2,funcionario:fun,detalle:detalle,ope:'insercion'}
        }).done(function(msg){
          // alert("ESTAS PASANDO POR EL GRABAR AHORA !!");

            //location.reload();
           humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
              //  $("#codigo").val('');
                $("#profesion").val('');
                $("#funcionario").val('');
                $("#detalle").val('');
         refrescarDatos();
        // vaciar();
         });
      }else{
         humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
      }
      });
    
});
                       //INCIO DE FUNCION ANULAR!!!

   $(document).on("click",".delete",function(){
        var pos = $( ".delete" ).index( this );
        $("#agendas tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
            var cod;
            cod = $(this).html();
            $("#delete").val(cod);
             $(".msg").html('<h4 class="modal-title" id="myModalLabel">DESEA CANCELAR EL REGISTRO. '+cod+' ?</h4>');
        });
    });
        //esta parte es para que al hacer clic pueda anular
    $(document).on("click","#delete",function(){
        var id = $( "#delete" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:id,profesion:0,funcionario:0,detalle:'{}',ope:'cancelar'}
            
        }).done(function(msg){
             $('#hide').click();
              
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
           refrescarDatos();
          // location.reload();
        });

    });
//fin  ANULAR

             // AQUI FINALIZA NUESTRA TABLA... 
            
            
             // Comienzo para la grilla..
 
         // AQUI COMIENZA NUESTRA PARTE DE INSERTAR GRILLA!!!
    $("#especialidad").change(function(){
        profesion();
    });

    $(document).on("click",".agregar",function(){
       // alert("esta pasando por el grabar ahora !!");
      $("#detalle-grilla").css({display:'block'});
       var esp = $('#especialidad option:selected').html();
       var especicod = $('#especialidad').val();
       var fecha = $("#fecha").val();
       var hdesde = $("#hora_desde").val();   //   el .val(); trae lo que tiene en ese campo
       var hhasta = $("#hora_hasta").val();
       var cupo = $('#cupo').val();
       var diascod = $('#dias').val();
       var dias = $('#dias option:selected').html();
     if( cupo >= 0 ){
        
        var repetido = false;
         var co = 0;
        $("#grilladetalle tbody tr").each(function(index) {
          $(this).children("td").each(function(index2) {
              if (index2 === 0) {
                co = $(this).text();
                  if (co === especicod) {
                       repetido = true;

                            $('#grilladetalle tbody tr').eq(index).each(function() {
                                $(this).find('td').each(function(i) {
                                    if(i===2){
                                        $(this).html('<button type=\'button\' class=\'btn btn-xs btn-danger quitar-esp pull-right\' data-placement=\'top\' title=\'Quitar\'><i class=\'fa fa-times\'></i></button>');
                                    }
                                     if(i===3){
                                        $(this).text(fecha);
                                    }
                                    if(i===4){
                                        $(this).text(hhasta);
                                    }
                                    if(i===5){
                                        $(this).text(cupo);

                                    }
                                    if(i===6){
                                        $(this).html('<button type=\'button\' class=\'btn btn-xs btn-danger quitar-dias pull-right\' data-placement=\'top\' title=\'Quitar\'><i class=\'fa fa-times\'></i></button>');
                                    }
                                    
                                  
                                });
                            });
                       }
                    }

                });
            });
            
            if(!repetido){
        $('#grilladetalle > tbody:last').append('<tr class="ultimo"><td>' + especicod + '</td><td>' + esp + '</td><td>' + fecha + '</td><td>' + hdesde + '</td><td>' + hhasta + '</td><td>' + cupo + '</td><td>' + diascod + '</td><td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
            }
       }else if (cupo <=0 ){
 humane.log("<span class='fa fa-info'></span> ATENCION!! El numero no puede ser negativo", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
}
cargargrilla();
        $("#especialidad").val('');
        $("#profesion").focus();
    });
    
     
    $(document).on("click",".eliminar",function(){
        var parent = $(this).parent();
        $(parent).remove();
        cargargrilla();
    });

       function cargargrilla() {
           
        var salida = '{';
        $("#grilladetalle tbody tr").each(function(index) {
            var campo1, campo2, campo3, campo4,campo5,campo6;
            salida = salida + '{';
            $(this).children("td").each(function(index2) {
                switch (index2) {
                    case 0:
                        campo1 = $(this).text();
                        salida = salida + campo1 + ',';
                        break;
                    case 2:
                        campo2 = $(this).text();
                        salida = salida + campo2 + ',';
                        break;
                    case 3:
                        campo3 = $(this).text();
                        salida = salida + campo3 + ',';
                        break;
                    case 4:
                        campo4 = $(this).text();
                        salida = salida + campo4 + ',';
                        break;
                    case 5:
                        campo5 = $(this).text();
                        salida = salida + campo5 + ',';
                        break;
                    case 6:
                        campo6 = $(this).text();
                        salida = salida + campo6;
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
    
    
    
    
    
    
  function profesion(){
        var cod = $('#especialidad').val();
        $.ajax({
            type: "POST",
            url: "profesion.php",
            data: {cod: cod}
        }).done(function(profesion){
            $("#profesion").val(profesion);
            $("#profesion").focus();
        });
    }