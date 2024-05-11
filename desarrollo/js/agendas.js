
//ASTORE!!! 
$(function(){
    var Path ='imp_agendas_full.php';
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
    agendas.on( 'draw', function () {
        $.each( detailRows, function ( i, id ) {
            $('#'+id+' td.details-control').trigger( 'click' );
        });
    });
 
    function format ( d ) {
         // `d` is the original data object for the row
        var deta ='<table  class="table table-striped table-bordered nowrap table-hover">\n\
        <tr width=80px class="info"><th>Codigo</th><th>Dias de Atención</th><th>Hora Desde</th><th>Hora Hasta</th></tr>';
        for(var x=0;x<d.detalle.length;x++){
        deta+='<tr>'+
            '<td width=10px>'+d.detalle[x].codigo+'</td>'+
            '<td width=120px>'+d.detalle[x].dias+'</td>'+
            '<td width=120px>'+d.detalle[x].hora_desde+'</td>'+
            '<td width=120px>'+d.detalle[x].hora_hasta+'</td>'+
        '</tr>';
        }
        deta+= '</tbody>' +
        '<tfoot>' +
        '<tr>' +
        '<td></td>' +
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
                    '</div>'+
                '</div>';
    }

    //INCIO DE FUNCION GRABAR!!!
    $(document).on("click","#grabar",function(){
        var nro, fun, detalle, ope, suc, usu;
        nro = $("#nro").val();
        fun = $("#func").val();
        detalle = $("#detalle").val();
        suc = $("#sucursal").val();
        usu = $("#usuario").val();
        ope = $("#operacion").val();
        
        if(fun > 0, detalle.length > 0){
            $.ajax({
                type: "POST",
                url: "grabar.php",
                data: {codigo:nro, fun:fun, detalle:detalle, usu:usu, suc:suc,  ope:ope}
            }).done(function(msg){
                mostrarMensajes(msg);
                vaciar();
                ulcod();
                $("#operacion").val(1);
                $("#grabar").val('Guardar');
                $("#func").attr('disabled', false);
                refrescarDatos();
            });
        }else{
            humane.log("<span class='fa fa-info'></span> Por favor complete todos los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
        }
    });
    


    //INICIO DE FUNCION MODIFICAR
    $(document).on("click", ".editar", function(){
        $("#operacion").val(2);
        $("#grabar").val('Guardar Cambios');
        var pos = $(".editar").index(this);
        let funcod = $("#agendas tbody tr:eq("+pos+")").find('td:eq(2)').html();
            funcod.split('-');
            funcod = funcod[0].trim();
            $("#func").val(funcod).trigger('change');
            $("#func").attr('disabled', true);
        let cod;
        $("#agendas tbody tr:eq("+pos+")").find('td:eq(1)').each(function(){
            cod = $(this).html();
            $("#nro").val(cod);
            $.ajax({
                type:'GET',
                url: 'editar.php',
                data: {cod: cod}
            }).done(function(data){
                let datos = JSON.parse(data);
                $("#grilladetalle > tbody > tr").remove();
                $("#grilladetalle > tbody ").append(datos.filas);
                $("#nro").val(cod)
                cargargrilla();
            })
        })
    });
    //FIN MODIFICAR

    //INCIO DE FUNCION ANULAR!!!
    $(document).on("click",".delete",function(){
        var pos = $( ".delete" ).index( this );
        $("#agendas tbody tr:eq("+pos+")").find('td:eq(1)').each(function (){
            var cod;
            cod = $(this).html();
            $("#delete").val(cod);
            $(".msg").html('<h4 class="modal-title" id="myModalLabel">DESEA ANULAR EL REGISTRO N.°:  '+cod+' ?</h4>');
        });
    });
    //esta parte es para que al hacer clic pueda anular
    $(document).on("click","#delete",function(){
        var id = $( "#delete" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:id,fun:0,detalle:'{}',suc:0,usu:0,ope:3}
            
        }).done(function(msg){
            $('#hide2').click();
            mostrarMensajes(msg)   
            refrescarDatos();
        });
    });
    //FIN  ANULAR

    // AQUI COMIENZA NUESTRA PARTE DE INSERTAR GRILLA!!!
    $(document).on("click","#agregar",function(){
        $("#detalle-grilla").css({display:'block'});
        var codigo = $('#nro').val();
        var hdesde = $("#hora_desde").val();   
        var hhasta = $("#hora_hasta").val();
        var diascod = $('#dias').val();
        var dias = $('#dias option:selected').html();
        
        if(hdesde != "" && hhasta != "" && diascod > 0){
            var repetido = false;
            var diaG = 0;
            var horadesdeG;
            var horahastaG;
            let filac;
            let bandera = true;
            
            $("#grilladetalle tbody tr").each(function(fila) {
                if (bandera){
                    filac = fila;
                    $(this).children("td").each(function(col1) {
                        if (col1 === 1) {
                            diaG = $(this).text().split('-');
                            diaG = diaG[0].trim();

                            if (diaG === diascod) {
                                    // alert('coincide el dia')
                                $("#grilladetalle tbody tr:eq("+filac+")").children("td").each(function(col2) {
                                    if (col2 === 2){
                                        horadesdeG = $(this).text();
                                    }
                                    if (col2 === 3) {
                                        horadesdeG = $(this).text();
                                        if (diaG === diascod && (horadesdeG >= hdesde && horadesdeG <= hhasta) || (horahastaG >= hdesde && horahastaG <= hhasta) ) {
                                            repetido = true
                                            humane.log("<span class='fa fa-info'></span> "+'Ya existe horario dentro de este rango!!!', { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });   
                                        }
                                    }
                                });
                            }
                        }
                    });
                }
            });
            if(!repetido){
                $('#grilladetalle > tbody:last').append('<tr class="ultimo"><td>' + codigo + '</td><td>' + dias + '</td><td>' + hdesde + '</td><td>' + hhasta + '</td><td class="eliminar"><input type="button" value="Х" id="bf"   class="bf"  style="background:  pink; color: black;"/></td></tr>');
            }
            cargargrilla();
            $("#hora_desde").focus();
        }else{
            humane.log("<span class='fa fa-info'></span> "+'VERIFIQUE LOS CAMPOS!!!', { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });   
        }
    });

        
    $(document).on("click",".eliminar",function(){
        var parent = $(this).parent();
        $(parent).remove();
        cargargrilla();
    });

    function cargargrilla() {
        var salida = '{';
        $("#grilladetalle tbody tr").each(function(index) {
            var campo1, campo2, campo3, campo4;
            salida = salida + '{';
            $(this).children("td").each(function(index2) {
                switch (index2) {
                    case 1:
                        campo1 = $(this).text().split('-');
                        campo1 = campo1[0].trim();
                        salida = salida + campo1 + ',';
                        break;
                    case 2:
                        campo2 = $(this).text();
                        salida = salida + campo2 + ',';
                        break;
                    case 3:
                        campo3 = $(this).text();
                        salida = salida + campo3;
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

    function ulcod(){
        $.ajax({
            type: 'GET',
            url: 'ultcod.php',
        }).done(function(msg){
            $("#nro").val(msg);
        })
    }

    function vaciar(){
        $("#func").val(0).trigger('change');
        $("#hora_desde").val("");
        $("#hora_hasta").val("");
        $("#dias").val(0).trigger('change');
        $("#grilladetalle >  tbody >  tr").remove();
        $("#detalle").val("");
    }

    function mostrarMensajes(msg){
        var r = msg.split("_/_");
        var texto = r[0];
        var  tipo = r[1];
        if(tipo.trim() == 'notice'){
            texto = texto.split("NOTICE:")
            texto = texto[1];
            humane.log("<span class='fa fa-check'></span> "+texto, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            
        }
        if(tipo.trim() == 'error'){
            texto = texto.split("ERROR:");
            texto = texto[1];
            let msg = texto.split('CONTEXT:');
            msg = msg[0];
            humane.log("<span class='fa fa-info'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-error' });
        }
    }
});