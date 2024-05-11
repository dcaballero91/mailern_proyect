 //JS FUNCIONA TODO!!

 //Obs: Sera que se pdria agregar un boton para desactivar un tipo de especialidad... 
 $(function(){

     var tabla =  $('#especialidades').dataTable({
    "columns":
    [
        { "data": "codigo" },
        { "data": "especialidad"},
        { "data": "estado" },
        { "data": "acciones"}
    ]
 });
    tabla.fnReloadAjax( 'datos.php' );
    function refrescarDatos(){
        tabla.fnReloadAjax();
    }
////FIN TABLA

//AGREGAR


    $(document).on("click", "#btnsave", function () {     //#btnsave  es el id del boton  guardar    
        var especialidad = $("#especialidad").val();
        // var estado = $("#estado").val();

        if (especialidad !== "") {
            $.ajax({
                type: "POST",
                url: "grabar.php", //grabar: variable, grabar:variable, grabar:variable del sp=en grabar de la  linea  14
                data: {codigo:0, especialidad:especialidad,ope:1}
            }).done(function (msg) {
                mostrarMensaje(msg);

                // humane.log("<span class='fa fa-check'></span> " + msg, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
                // limpiar
                $("#especialidad").val('');
                $("#especialidad").val('');

                refrescarDatos();
            });
        } else {
            humane.log("<span class='fa fa-info'> POR FAVOR VERIFIQUE LOS CAMPOS</span> ",  {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
        }
    });

//ELIMINAR
    // $(document).on("click", ".confirmar", function () {
    //     var pos = $(".confirmar").index(this);
    //     var cod;
    //     $("#especialidades tbody tr:eq(" + pos + ")").find("td:eq(0)").each(function () {
    //         cod = $(this).html();
    //     });
    //     $("#delete").val(cod);
    //     $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea eliminar el Registro Nro. ' + cod + ' ?</h4>');
    // });

    
    // $(document).on("click", "#delete", function () {    
    //     var cod = $("#delete").val();
    //     $.ajax({
    //         type: 'POST',
    //         url: 'grabar.php',
    //         data: {codigo: cod, especialidad: '', ope:3}
    //     }).done(function (msg) {
    //         $("#cerrar2").click();
    //         humane.log("<span class='fa fa-check'></span> " + msg, {timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success'});
    //         refrescarDatos();
    //     });
    // });

//FIN ELIMINAR

//EDITAR
    $(document).on("click",".editar",function(){
        $("#btn_edit").html("Guardar cambios");
        //alert("ok");
        //$("#btn_edit").attr("disabled","disabled");
        var pos = $( ".editar" ).index( this );
        $("#especialidades tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var cod = $(this).html();
            $("#cod_edit").val(cod);
            $.ajax({
                type: 'POST',
                url: 'editar.php',
                async: true,
                data: {cod: cod}
            }).done(function(msg){
                var dame = eval("("+msg+")");
                $("#cod_edit").val(cod);
                $("#especialidad_edit").val(dame.esp_desc)        
            });
        });
    });

    $(document).on("click","#btn_edit",function(){
        var cod,esp;
        esp = $("#especialidad_edit").val();
        cod = $("#cod_edit").val();
        $("#btn_edit").html("Editando...");
        if( esp!==""){
            $.ajax({
                type: "POST",
                url: "grabar.php",
                data: {codigo:cod,especialidad:esp,ope:2}
            }).done(function(msg){
                $('#cerrar').click();
                refrescarDatos();
                mostrarMensaje(msg);

                // humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });    
            });
        }else{
            humane.log("<span class='fa fa-info'> Por favor verifique los campos</span> ", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });   
        };
    });

    
//FIN EDITAR

//DESACTIVAR
                //INICIO CUADRO DE DIALOGO
    $(document).on("click",".eliminar",function(){
        var pos = $( ".eliminar" ).index( this );
        $("#especialidades tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
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
            data: {codigo: cod, especialidad: '', ope:3}
        }).done(function(msg){
            $('#confirmacion').modal("hide");
           // cargar();
           mostrarMensaje(msg);

            // humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
            refrescarDatos();
        });
    });
                //FIN FUNCION
    //FIN DESACTIVAR

//ACTIVAR
                //INICIO CUADRO DE DIALOGO
    $(document).on("click",".activar",function(){
        var pos = $( ".activar" ).index( this );
        $("#especialidades tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
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
            data: {codigo: cod, especialidad: '', ope:4}
           
        }).done(function(msg){
            
            $('#activacion').modal("hide");
           // cargar();
           mostrarMensaje(msg);
            // humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
            refrescarDatos();
        });

    });
                //FIN FUNCION
//FIN ACTIVAR
    function mostrarMensaje(res){
        var r = res.split("_/_");
        var texto = r[0];
        var tipo = r[1];

        if(tipo.trim() == 'notice'){
            texto = texto.split("NOTICE:");
            texto = texto[1];
            humane.log("<span class='fa fa-check'></span> "+texto, { timeout: 3000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
        }

        if(tipo.trim() == 'error'){
            texto = texto.split("ERROR:");
            texto = texto[2];
            var msg = texto.split("CONTEXT:");
            var textof = msg[0];
            humane.log("<span class='fa fa-info'></span> "+textof, { timeout: 3000, clickToClose: true, addnCls: 'humane-flatty-error' }); 
        }
    }


});