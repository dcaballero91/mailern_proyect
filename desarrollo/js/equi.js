
    $(document).on("click",".agregar",function(){
            $("#detalle-grilla").css({display:'block'});
           
        var producto = $('#fun option:selected').html();
            var procod = $('#fun').val();
           
           
       
           var repetido = false;
           var co = 0;
            $("#grilladetalle tbody tr").each(function(index) {
                $(this).children("td").each(function(index2) {
                    if (index2 === 0) {
                        co = $(this).text();
                        if (co === procod) {
                            repetido = true;
                            $('#grilladetalle tbody tr').eq(index).each(function() {
                            
                            });
                        }
                    }
                });
            }); 
                            
            if (!repetido) {
                $('#grilladetalle > tbody:last').append('<tr class="ultimo"><td>' + procod + '</td><td>' + producto + '</td><td class="eliminar"><input type="button" value="X" id="bf" class="bf" style="background: red; color: white;"/></td></tr>');
            }
        cargargrilla();
      
    });

    $(document).on("click",".eliminar",function(){
        var parent = $(this).parent();
        $(parent).remove();
        cargargrilla();
    });

    function cargargrilla() {
        var salida = '{';
        $("#grilladetalle tbody tr").each(function(index) {
            var campo1;
            salida = salida + '{';
            $(this).children("td").each(function(index2) {
                switch (index2) {
                    case 0:
                        campo1 = $(this).text();
                        salida = salida + campo1 ;
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
    //GRABAR PEDIDOS
    $(document).on("click",".grabar",function(){
        var desde,hasta,detalle;
       
        desde = $("#desde").val();
        hasta = $("#hasta").val();
        detalle = $("#detalle").val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:0,desde:desde,hasta:hasta,detalle:detalle,ope:'insercion'}
       
        
        }).done(function(msg){
            alert(msg);
            location.reload();
        });
    });
    //ANULAR PEDIDO
    $(document).on("click",".anular",function(){
        var pos = $( ".anular" ).index( this );
        $("#pedido tbody tr:eq("+pos+")").find('td:eq(1)').each(function () {
            var campo2 = $(this).html();
            $("#cod_anular").val(campo2);
        });
    });
    $(document).on("click",".btn-anular",function(){
        var cod = $("#cod_anular").val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:cod,desde:'2000-12-31',hasta:'2000-12-31',detalle:'{{1}}',ope:'anulacion'}
        }).done(function(msg){
            $(".cerrar").click();
            alert(msg);
            location.reload();
        });
    });
