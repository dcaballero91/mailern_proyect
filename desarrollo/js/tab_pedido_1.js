/**
 * Created by user pc on 05/07/2016.
 */
$(function(){

    $(document).on("click",".buscar",function(){
        $("#tabla-reporte").css({display:'block'});
        var desde,hasta,cliente,fun;
        desde = $("#btn-enabled-date-desde").val();
        hasta = $("#btn-enabled-date-hasta").val();
        cliente = $("#cliente").val();
        fun = $("#funcionario").val();
        dt.fnReloadAjax( "datos.php?desde="+desde+"&hasta="+hasta+"&cliente="+cliente+"&fun="+fun+"" );
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
            { "data": "cliente" },
            { "data": "cli_ruc" },
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