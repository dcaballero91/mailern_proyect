$(function(){
    //se declara una variable tabla en el cual se inicializa el dataTable y se especifican la columnas
    //que va a contener y las etiquetas de los datos json 
   var tabla = $("#personas").dataTable({
      "columns":
        [   
            { "data": "codigo"},
            { "data": "nom" },
            { "data": "ape" }, 
            { "data": "ci" }, 
            { "data": "dir" },
            { "data": "tel" },
            { "data": "nac" },
            { "data": "tipo" },
            { "data": "acciones"}
    ]
 });
    tabla.fnReloadAjax( 'datos.php' );
    
      //refresca datos de la tabla
function refrescarDatos(){
        tabla.fnReloadAjax();
    }
    ///GUARDAR
    $(document).on("click","#btnsave",function(){
        //se declaran variables que se enviaran al sp
        var nom, ape, ruc, ci, tel, dir, email, fenaci, nac, ciu, tipo ,gen,esta;
        //se guardan los valores de los campos de textos en las variables correspondientes
        var nom = $("#nom").val();
        var ape = $("#ape").val();
        var dir = $("#dir").val();
        var tel = $("#tel").val();
        var ruc = $("#ruc").val();
        var ci = $("#ci").val();           
        var fenaci = $("#fenaci").val();
        var email = $("#email").val();
           var nac = $("#nac").val();
           var esta = $("#esta").val();
           var ciu = $("#ciu").val();
           var gen = $("#gen").val();
           var tipo = $("#tipo").val();

        
        //Si todas las variables son distintas de vacio (!=="")
        if(nom !== "" && ape !== "" && ci !== "" && tel !== "" && dir !== "" && email !== "" && fenaci !=="" && nac !=="" && ciu !=="" && gen !==""){
            //se ejecuta la peticion 
            $.ajax({
                   type: "POST",
                   url: "grabar.php",
                   data: {codigo:0,nom: nom, ape: ape,dir: dir, tel: tel, ci: ci, fenaci: fenaci,  email: email, nac: nac, ciu: ciu, gen: gen, tipo: tipo, esta: esta, ope:1 }
                }).done(function(msg){
                    //por ultimo se muestra el mensaje de respuesta en un alert
                     humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
                     //se actualizan los datos de la tabla
                     refrescarDatos();
                     //y se vacian los campos
                     vaciar();
                });
        }else{
            //Si algun campo esta vacio se muestra un mensaje de alerta
                humane.log("<span class='fa fa-info'>Verifique los campos</span>", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
            }
    });
    
    //Borrar
    //capturamos la posicion del boton borrar(X)
    $(document).on("click",".eliminar",function(){
        var pos = $( ".eliminar" ).index( this );
        $("#personas tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var id;
            id = $(this).html();
            $("#cod_eliminar").val(id);
            $(".msg").html("<h4>DESEA DESACTIVAR EL REGISTRO N°:"+id+"</h4>");
        });
    });
            //FIN CUADRO DE DIALOGO
            //INICIO FUNCION DESACTIVAR
    $(document).on("click","#delete",function(){
        var cod = $( "#cod_eliminar" ).val();
        
       //**//
        $.ajax({
            type: "POST",
            url: "grabar.php", //data:{codigo: 0,nom: '', ape: '', tel: '', dir: '', ruc:'', ci: '0', fenaci: '11/11/1111', email: '',  nac: 0, esta:0,ciu:0,gen:0,tipo:0,ope: 'eliminacion'}
            data:{codigo: cod,nom: '', ape: '', tel: '', dir: '', ci: '0', fenaci: '11/11/1111', email: '', nac:0, ciu:0, gen:0, tipo:0,esta:0, ope:3}
         //   data:{codigo:cod,fecha:'25-02-2016',especialidad:'',funcionario:0,profesion:0,ope:'activar'}
            ///select * from sp_especialidades(4,'25-02-2016','esp',1,1,'desactivar')
        }).done(function(msg){
            $('#confirmacion').modal("hide");
           // cargar();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
            refrescarDatos();
        });
    });

//FIN DESACTIVAR
//ACTIVAR
                //INICIO CUADRO DE DIALOGO
    $(document).on("click",".activar",function(){
        var pos = $( ".activar" ).index( this );
        $("#personas tbody tr:eq("+pos+")").find('td:eq(0)').each(function () {
            var id;
            id = $(this).html();
            $("#cod_activar").val(id);
            $(".msgactive").html("<h4>DESEA ACTIVAR EL REGISTRO NROº:"+id+" ?</h4>");

        });
    });
                //FIN CUADRO DE DIALOGO
                //INICIO FUNCION ACTIVAR
    $(document).on("click","#okactive",function(){
        var cod = $( "#cod_activar" ).val();
        $.ajax({
            type: "POST",
            url: "grabar.php",
              data:{codigo: cod,nom: '', ape: '', tel: '', dir: '', ruc:'', ci: '0', fenaci: '11/11/1111', email: '',  nac: 0, esta:0,ciu:0,gen:0,tipo:0,ope: 'activacion'}
           
        }).done(function(msg){
            
            $('#activacion').modal("hide");
           // cargar();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' }); 
            refrescarDatos();
        });

    });

    //EDITAR
   $(document).on("click",".editar",function(){
       var pos = $(".editar").index(this);
       $("#personas tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
           
         var  cod = $(this).html(); 
         $("#cod_edit").val(cod);
            $.ajax({
                type: 'POST',
                url: 'editar.php',
                async: true,
                data: {cod: cod} 
             }).done(function(msg){
                 var dame = eval("("+msg+")");
                 console.log(dame)
                $("#cod_edit").val(cod);
                $("#nom_edit").val(dame.per_nom);
                $("#ape_edit").val(dame.per_ape);
                $("#dir_edit").val(dame.per_dir);
                $("#tel_edit").val(dame.per_tel);
                $("#ci_edit").val(dame.per_ci);
                $("#fenaci_edit").val(dame.per_fenac);
                $("#email_edit").val(dame.per_email);
                $("#nac_edit").val(dame.pais_cod).trigger('change');
                $("#tipo_edit").val(dame.tipo_per_cod).trigger('change');
                $("#gen_edit").val(dame.gen_cod).trigger('change');
                
               
             });
   });
   });




   $(document).on("click","#btn_edit",function(){
       var cod, nom, ape, ci, dir,tel,ruc,fenaci, ciu,nac,gen,esta, email, tipo,cargo_funcionario;
        cod = $("#cod_edit").val();
        nom = $("#nom_edit").val();
        ape = $("#ape_edit").val();
        ci = $("#ci_edit").val();
        dir = $("#dir_edit").val();
        tel= $("#tel_edit").val();
        ruc = $("#ruc_edit").val();
        fenaci = $("#fenaci_edit").val();
        ciu = $("#ciu_edit").val();
        nac = $("#nac_edit").val();
        gen = $("#gen_edit").val();
        esta = $("#esta_edit").val();
        email = $("#email_edit").val();
        tipo = $("#tipo_edit").val();
        cargo_funcionario = $("#cargo_funcionario_edit").val();
        if(nom !== "" && ape!== "" && ci !== "" && dir !== ""&& tel!== "" && ruc !== "" && fenaci !== "" && ciu !=="" && nac !==""&& gen !== ""&& esta !== ""&& email !== ""&& tipo !== ""&& cargo_funcionario !== ""){
            $.ajax({
                   type: "POST",
                   url: "grabar.php",
                   data: { codigo: cod,nom: nom, ape: ape, dir: dir,tel: tel,ruc: ruc, ci: ci,   fenaci: fenaci, email: email,  nac: nac, esta: esta, ciu: ciu, gen: gen,  tipo:tipo, cargo_funcionario:1, ope:2}
                }).done(function(msg){
                     humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
                     refrescarDatos();
                     $('#cerrar').click();
                });
        }else{
                humane.log("<span class='fa fa-info'></span> Complete todos los campos vacios", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning'});
            }
   });
    //funcion para vaciar los campos de texto del agregar
    function vaciar(){
    $("#nom").val("");
    $("#ape").val("");
    $("#ci").val("");
    $("#tel").val("");
    $("#dir").val("");
    $("#email").val("");
    $("#fec").val("");
    $('#ciud > option[value=""]').attr('selected',true);
    $('#ciud').selectpicker('refresh');
    $('#nac > option[value=""]').attr('selected',true);
    $('#nac').selectpicker('refresh');
    $('#civil > option[value=""]').attr('selected',true);
    $('#civil').selectpicker('refresh');
    
    $("#tipo").val("");
}
});