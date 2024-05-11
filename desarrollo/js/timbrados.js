

//TIMBRADOS FUNCIONA CORRECTAMENTE


$(function(){

     var tabla =  $('#item').dataTable({
    "columns":
    [
        { "data": "codigo" },
        { "data": "descri" },
        { "data": "vigdesde" },
        { "data": "vighasta" },
        { "data": "nrodesde" },
        { "data": "nrohasta" },
        { "data": "ultfact" },
        { "data": "puntexp" },
        { "data": "suc" },
        { "data": "estado" },
        { "data": "acciones"}
    ]
 });
    tabla.fnReloadAjax( 'datos.php' );
    function refrescarDatos(){
        tabla.fnReloadAjax();
    };
////FIN TABLA

//AGREGAR

//    $("#btnsave").attr("disabled","disabled");
//    $('#item').keyup(function () {
//        if($("#item").val()!=="" ){
//                    if($("#descri").val()==="" && $("#costo").val()==="" && $("#venta").val()==="" && $("#min").val()==="" && $("#max").val()==="" && $("#marca").val()==="" && $("#imp").val()==="" && $("#clasificacion").val() ){

//            $("#btnsave").attr("disabled","disabled");
//        }else{
//            $("#btnsave").removeAttr("disabled");
//        }
//        }
//    });
//  });

   $(document).on("click","#btnsave",function(){
        var descri = $("#descri").val();
        var vigdesde = $("#vigdesde").val();
        var vighasta = $("#vighasta").val();
        var nrodesde = $("#nrodesde").val();
        var nrohasta = $("#nrohasta").val();
        var ultfact = $("#ultfact").val();
        var puntexp = $("#puntexp").val();
        var suc = $("#suc").val();
 
        if(descri !=="" && vigdesde !=="" && vighasta !=="" && nrodesde>= 0 && nrohasta>0 && ultfact>=0 && puntexp !=="" && suc !==""){ 
              $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:0,descri:descri,vigdesde:vigdesde, vighasta:vighasta, nrodesde:nrodesde, nrohasta:nrohasta, ultfact:ultfact, puntexp:puntexp, suc:suc, ope:1}
           }).done(function(msg){
           // location.reload();
           $("#descri").val('');
           $("#vigdesde").val('');
           $("#vighasta").val('');
           $("#nrodesde").val('');
           $("#nrohasta").val('');
           $("#ultfact").val('');
           $("#puntexp").val('');
           $('#suc > option[value="0"]').attr('selected',true); 
           refrescarDatos();
             humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            
            $("#btnsave").html("AGREGAR");
        });
        }else {
         humane.log("<span class='fa fa-check'></span>VERIFIQUE LOS CAMPOS POR FAVOR! ", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });    
         refrescarDatos();
        }
    });
//FIN AGREGAR
//FI0N AGREGAR

//EDITAR
    $(document).on("click",".editar",function(){
        // $("#btn_edit").html("Guardar cambios");
        //$("#btn_edit").attr("disabled","disabled");
        var pos = $( ".editar" ).index( this );
        $("#item tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var cod = $(this).html();
            $("#codigo_edit").val(cod);
            $.ajax({
                type: 'POST',
                url: 'editar.php',
                async: true,
                data: {cod: cod}
            }).done(function(msg){
                var dame = eval("("+msg+")");
                console.log(dame)
                $("#codigo_edit").val(cod);
                 $('#descri_edit').val(dame.timb_nro);
                 $('#vigdesde_edit').val(dame.tim_vigdesde);
                 $('#vighasta_edit').val(dame.tim_vighasta);
                 $('#nrodesde_edit').val(dame.tim_nrodesde);
                 $('#nrohasta_edit').val(dame.tim_nrohasta);
                 $('#ultfact_edit').val(dame.tim_ultfactura);
                 $('#puntexp_edit').val(dame.puntoexp);
                 $('#suc_edit').val(dame.suc_cod).trigger('change');
   
            });
        });
    });


    $(document).on("click","#btn_edit",function(){
        var cod = $("#codigo_edit").val();
        var descri = $("#descri_edit").val();
        var vigdesde = $('#vigdesde_edit').val();
        var vighasta = $('#vighasta_edit').val();
        var nrodesde = $('#nrodesde_edit').val();
        var nrohasta= $('#nrohasta_edit').val();
        var ultfact = $('#ultfact_edit').val();
        var puntexp = $('#puntexp_edit').val();
        var suc =  $('#suc_edit').val();
    
        //$("#btn_edit").attr("disabled","disabled");
        // $("#btn_edit").html("Editando...");
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:cod,descri:descri,vigdesde:vigdesde, vighasta:vighasta, nrodesde:nrodesde, nrohasta:nrohasta, ultfact:ultfact, puntexp:puntexp, suc:suc, ope:2}
        }).done(function(msg){
            $('#cerrar').click();
            
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
       refrescarDatos();
       
    });
    
    });

    
    $('#costo_edit').keyup(function () {
        if($("#costo_edit").val()===""){
            $("#btn_edit").attr("disabled","disabled");
        }else{
            $("#btn_edit").removeAttr("disabled");
        }
    });
    $("#venta_edit").keypress(function(e){
        if(e.which === 13 && $("#venta_edit").val()!==""){
            $("#btn_edit").focus();
            $("#btn_edit").click();
        }else{

        }
    });
//FIN EDITAR

//DESACTIVAR
                //INICIO CUADRO DE DIALOGO
    $(document).on("click",".eliminar",function(){
        var pos = $( ".eliminar" ).index( this );
        $("#item tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var id;
            id = $(this).html();
            $("#cod_eliminar").val(id);
            $(".msg").html("<h4>Desea desactivar el registro n°:"+id+"</h4>");
        });
    });
            //FIN CUADRO DE DIALOGO
            //INICIO FUNCION DESACTIVAR
    $(document).on("click","#delete",function(){
        var cod = $( "#cod_eliminar" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:cod,tipoitem:0,descri:'',costo:0,min:0,max:0,marca:0,clasificacion:0,venta:0,imp:0,ope:3}
            
        }).done(function(msg){
            $('#desactivacion').modal("hide");
        //   cargar();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 3000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
            refrescarDatos();
        });
    });
                //FIN FUNCION
    //FIN DESACTIVAR
//ACTIVAR
                //INICIO CUADRO DE DIALOGO
    $(document).on("click",".activar",function(){
        var pos = $( ".activar" ).index( this );
        $("#item tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var id;
            id = $(this).html();
            $("#cod_activar").val(id);
            $(".msgactive").html("<h4>Desea activar el registro n°:"+id+"</h4>");

        });
    });
                //FIN CUADRO DE DIALOGO
                //INICIO FUNCION ACTIVAR
    $(document).on("click","#okactive",function(){
        var cod = $( "#cod_activar" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:cod,tipoitem:0,descri:'',costo:0,min:0,max:0,marca:0,clasificacion:0,venta:0,imp:0,ope:4}
        }).done(function(msg){
            $('#activacion').modal("hide");
           // cargar();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
            refrescarDatos();
        });

    });
                //FIN FUNCION
//FIN ACTIVAR

$(function () {
   

    $(".chosen-select").chosen({width: "100%"});
   

});
});

