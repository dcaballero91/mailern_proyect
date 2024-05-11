/**
 * Created by user pc on 05/07/2016.
 */
$(function(){

    $(document).on("click",".buscar",function(){
        $("#tabla-reporte").css({display:'block'});
        var desde,hasta,cliente,fun;
        desde = $("#btn-enabled-date-desde").val();
        hasta = $("#btn-enabled-date-hasta").val();
      
        fun = $("#funcionario").val();
        dt.fnReloadAjax( "datos.php?desde="+desde+"&hasta="+hasta+"&fun="+fun+"" );
    });

    var tabla = $('#pedido').DataTable( {
        "columns": [
            {
                "class":          "details-control",
                "defaultContent": ""
            },
            { "data": "cod" },
            { "data": "nro" },
            { "data": "fecha" },
            { "data": "estado" },
            { "data": "total" },
            { "data": "acciones"}
        ]
    } );
    cargar();
    tabla.fnReloadAjax( "datos.php?desde=2&hasta=5&cliente=5&fun=7" );
    function cargar(){
        tabla.fnReloadAjax( "datos.php?desde=2&hasta=5&cliente=5&fun=7" );
    }

});