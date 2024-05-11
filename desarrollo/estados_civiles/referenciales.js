      //TABLA

$(function(){
  var tabla = $('#referencial').dataTable({
                    responsive: true,
                    "columns":
            [
                { "data": "cod" },
                { "data": "desc" },
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
     if(desc!==""){
     $.ajax({
         url: "grabar.php",
         type: "POST",
         data: {cod:'0', desc: desc, ope:1}
     }).done(function(msg){
         humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
        $("#desc").val('');
         refrescarDatos();
         });
      }else{
         humane.log("<span class='fa fa-info'></span> Por favor ingrese la descripcion", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
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
           data: {cod: cod, desc: '', ope: 3}
        }).done(function(msg){
            $("#cerrar2").click();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            refrescarDatos();
            }); 
  });
  //FIN BORRAR
  
  //EDITAR
  $(document).on("click",".editar",function(){
     var pos = $(".editar").index(this);
     var cod, desc;
     $("#referencial tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
        cod = $(this).html(); 
     });
     $("#referencial tbody tr:eq("+pos+")").find("td:eq(1)").each(function(){
        desc = $(this).html(); 
     });
     $("#cod_edit").val(cod);
     $("#desc_edit").val(desc);
     $("#desc_edit").focus();
  });
  
  $(document).on("click","#guardar_edit",function(){
     var cod= $("#cod_edit").val();
     var desc= $("#desc_edit").val();
     if(desc!==""){
         $.ajax({
             url: "grabar.php",
             type: "POST",
             data: {cod: cod, desc: desc, ope:2}
         }).done(function(msg){
                $("#cerrar").click();
                humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
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
});

//FIN EDITAR