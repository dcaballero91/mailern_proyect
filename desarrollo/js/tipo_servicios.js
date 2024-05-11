 //JS FUNCIONA TODO!!

 //Obs: Sera que se pdria agregar un boton para desactivar un tipo de especialidad... 
 $(function(){

     var tabla =  $('#lista').dataTable({
    "columns":
    [
        { "data": "codigo" },
        { "data": "tserv" },
        { "data": "impuesto" },
        { "data": "precio" },
        { "data": "especialidad" },
        { "data": "estado" },
      
    

        { "data": "acciones"}
    ]
 });
    tabla.fnReloadAjax( 'datos.php' );
    function refrescarDatos(){
        tabla.fnReloadAjax();
    }
////FIN TABLA

//GUARDAR
    $(document).on("click", "#btnsave", function () {     //#btnsave  es el id del boton  guardar
        var tserv, precio;
        var tserv = $("#tserv").val();
        var precio = $("#precio").val();
        var impuesto = $("#impuesto").val();
        var especialidad = $("#especialidad").val();
    
        if (tserv !== "", precio !== "") {
            $.ajax({
                type: "POST",
                url: "grabar.php", //grabar: variable, grabar:variable, grabar:variable del sp=en grabar de la  linea  14
                data: {codigo: '0', tserv: tserv, precio: precio,impuesto:impuesto,especialidad:especialidad, ope: 'insercion'}
            }).done(function (msg) {
                humane.log("<span class='fa fa-check'></span> " + msg, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});

                $("#tserv").val('');
                $("#precio").val('');
                $("#impuesto").val('');
                $("#especialidad").val('');
          
                refrescarDatos();
            });
        } else {
            humane.log("<span class='fa fa-check'></span> " + msg, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
        }
    });
    //FIN GUARDAR
//EDITAR
    $(document).on("click",".editar",function(){
        $("#btn_edit").html("Guardar cambios");
        //alert("ok");
        //$("#btn_edit").attr("disabled","disabled");
        var pos = $( ".editar" ).index( this );
        $("#lista tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var cod = $(this).html();
            $("#cod_edit").val(cod);
            $.ajax({
                type: 'POST',
                url: 'editar.php',
                async: false,
                data: {cod: cod}
            }).done(function(msg){
                var dame = eval("("+msg+")");
                $("#cod_edit").val(cod);
                $("#tserv_edit").val(dame.tipo_serv_desc);
                $("#precio_edit").val(dame.tipo_serv_precio);
                $('#especialidad_edit > option[value="'+dame.esp_cod+'"]').attr('selected',true);
                $('#especialidad_edit').selectpicker('refresh');
                $('#impuesto_edit > option[value="'+dame.tipo_impuesto_serv_cod+'"]').attr('selected',true);
                $('#impuesto_edit').selectpicker('refresh');
               
            });
        });
    });

    $(document).on("click","#btn_edit",function(){
        var cod,tserv,precio,esp,imp;
        
       // fecha = $("#fecha_edit").val();
        tserv = $("#tserv_edit").val();
        precio = $("#precio_edit").val();
        esp = $("#especialidad_edit").val();
        imp = $("#impuesto_edit").val();
        cod = $("#cod_edit").val();
        
        $("#btn_edit").html("Editando...");
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:cod,tserv:tserv, precio: precio,impuesto:imp,especialidad:esp,ope:'modificacion'}
      // sp_tipo_servicios(2,'asdf', 5400, 'EXENTA', 1, 'modificacion')
       }).done(function(msg){
            $('#cerrar').click();
            refrescarDatos();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
        });
    });

    
//FIN EDITAR
//ACTIVAR
                //INICIO CUADRO DE DIALOGO
    $(document).on("click",".activar",function(){
        var pos = $( ".activar" ).index( this );
        $("#lista tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var id;
            id = $(this).html();
            $("#cod_activar").val(id);
            $(".msgactivo").html("<h4>DESEA ACTIVAR EL REGISTRO NROº:<strong> "+id+" </strong> ?</h4>");

        });
    });
 //FIN CUADRO DE DIALOGO
 //INICIO FUNCION ACTIVAR
    $(document).on("click","#okactive",function(){ //  <button type="button" class="btn btn-primary" id="okactive">Si</button>
        var cod = $( "#cod_activar" ).val(); //  <input type="hidden" id="cod_activar" name="">
        $.ajax({
            type: "POST",
            url: "grabar.php",
              data:{codigo:cod, tserv: 0, precio: 0,impuesto:'',especialidad:0, ope:'activar'}
           
        }).done(function(msg){
            
            $('#activacion').modal("hide");
           // cargar();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
            refrescarDatos();
        });

    });
    //FIN FUNCION ACTIVAR               
//FIN ACTIVAR
//DESACTIVAR
   $(document).on("click",".desactivar",function(){
        var pos = $( ".desactivar" ).index( this );
        $("#lista tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var id;
            id = $(this).html();
            $("#cod_desactivar").val(id);
            $(".msgdesactivo").html("<h4>DESEA DESACTIVAR EL REGISTRO NROº: <strong> "+id+" </strong>?</h4>");

        });
    });
     $(document).on("click","#desactivar",function(){ //  <button type="button" class="btn btn-primary" id="okactive">Si</button>
        var cod = $( "#cod_desactivar" ).val(); //  <input type="hidden" id="cod_activar" name="">
        $.ajax({
            type: "POST",
            url: "grabar.php",
              data:{codigo:cod, tserv: 0, precio: 0,impuesto:'',especialidad:0, ope:'desactivar'}
           
        }).done(function(msg){
            
            $('#desactivacion').modal("hide");//<div class="modal" id="desactivacion" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" 
           // cargar();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
            refrescarDatos();
        });

    });
//FIN DESACTIVAR
});