      //TABLA

$(function(){
    // alert("holaaa")
  var tabla = $('#referencial').dataTable({
                    responsive: true,
                    "columns":
            [
                { "data": "cod" },
                { "data": "desc" },
                { "data": "pais" },
                { "data": "acciones"}
            ]
        });
   
  tabla.fnReloadAjax( 'datos.php' );
  
  function refrescarDatos(){
      tabla.fnReloadAjax();
  }

// AGREGAR

  $(document).on("click","#guardar",function(){
     var desc = $("#desc").val();
     var pais = $("#pais").val();
     if(desc!=="",pais>0){
     $.ajax({
         url: "grabar.php",
         type: "POST",
         data: {cod:0, desc: desc, pais:pais, ope:1}
     }).done(function(msg){
        
        mostrarMensaje(msg)
        //  humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
        $("#desc").val('');
        refrescarDatos();
         });
      }else{
         humane.log("<span class='fa fa-info'></span> Por favor complete los campos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
      }
  });
  //FIN AGREGAR
  
//ELIMINAR

  $(document).on("click",".confirmar",function(){
        var pos = $(".confirmar").index(this);
        var cod;
       $("#referencial tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
          cod = $(this).html(); 
       });
        $("#borrar").val(cod);
        $(".msg").html('<h4 class="modal-title" id="myModalLabel">Desea borrar el Registro Nro. '+cod+' ?</h4>');
    });
  
  $(document).on("click","#borrar",function(){
      var cod = $("#borrar").val();
        $.ajax({
           type: 'POST',
           url: 'grabar.php',
           data: {cod: cod, desc: '',pais:0, ope: 3}
        }).done(function(msg){
            $("#cerrar2").click();
            mostrarMensaje(msg);
            // humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            refrescarDatos();
            }); 
  });
  //FIN BORRAR
  
  //EDITAR
  $(document).on("click",".editar",function(){
    //  var pos = $(".editar").index(this);
    //  var cod, desc,pais;
    //  $("#referencial tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
    //     cod = $(this).html(); 
    //  });
    //  $("#referencial tbody tr:eq("+pos+")").find("td:eq(1)").each(function(){
    //     desc = $(this).html(); 
    //  });
    //  $("#referencial tbody tr:eq("+pos+")").find("td:eq(2)").each(function(){
    //     pais = $(this).val(); 
    //  });
    //  $("#cod_edit").val(cod);
    //  $("#desc_edit").val(desc);
    //  $("#pais_desc").val(pais).trigger('change');
    //  $("#pais_desc").selectpicker('refresh');
    var pos = $(".editar").index(this);
    $("#referencial tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
        var cod = $(this).html();
        $.ajax({
            type: 'POST',
            url: 'editar.php',
            data:{ cod:cod}
        }).done(function(msg){
            var dame = eval("("+msg+")");
            // console.log(dame)
            $("#cod_edit").val(dame.ciu_cod);
            $("#desc_edit").val(dame.ciu_desc);
            $("#pais_desc").val(dame.pais_cod).trigger('change');
      })
    })
     $("#desc_edit").focus();
  });
  
  $(document).on("click","#guardar_edit",function(){
     var cod= $("#cod_edit").val();
     var desc= $("#desc_edit").val();
     var pais= $("#pais_desc").val();
     if(desc!==""){
         $.ajax({
             url: "grabar.php",
             type: "POST",
             data: {cod: cod, desc: desc,pais:pais, ope:2}
         }).done(function(msg){
            
                $("#cerrar").click();
                mostrarMensaje(msg);
                // humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
                refrescarDatos();
         });
     }else{
         humane.log("<span class='fa fa-check'></span>  "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
     }
  });
 

    $("#desc_edit").keypress(function(e){
    if(e.which === 13){
        $("#guardar_edit").focus();
        $("#guardar_edit").click();
    }else{
        
    }
    });
    
    $("#desc").keypress(function(e){
    if(e.which === 13){
        $("#guardar").focus();
        $("#guardar").click();
    }else{
        
    }
    });

    function mostrarMensaje(res){
        var r = res.split("_/_");
        var texto = r[0];
        var tipo = r[1];

        if(tipo.trim() == 'notice'){
            texto = texto.split("NOTICE:");
            texto = texto[1];
            humane.log("<span class='fa fa-check'></span>  "+texto, { timeout: 3000, clickToClose: true, addnCls: 'humane-flatty-success' });
        }

        if(tipo.trim() == 'error'){
            texto = texto.split("ERROR:");
            texto = texto[2];
            var msg = texto.split("CONTEXT:");
            // console.log(msg);
            textof = msg[0];
            
            humane.log("<span class='fa fa-info'></span>  "+textof, { timeout: 3000, clickToClose: true, addnCls: 'humane-flatty-error' });
        }
    }
});

//FIN EDITAR