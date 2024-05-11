$(function(){
///TABLA
    var tabla =  $('#lista').dataTable({
        "columns":
            [
                { "data": "codigo" },
                { "data": "descri" },
                { "data": "ultrecibo" },
                // { "data": "puntexp" },
                { "data": "usu" },
                { "data": "suc" },
                { "data": "emp" },
                { "data": "estado" },
                { "data": "acciones"}
            ]
    });
    tabla.fnReloadAjax( 'datos.php' );
    function refrescarDatos(){
        tabla.fnReloadAjax();
    }
   function vaciar(){
    $("#descri").val("");
    $("#ultrecibo").val("");
    $('#suc> option[value="suc_cod"]').attr('selected',true);
    $('#suc').selectpicker('refresh');
    $('#usu> option[value="usu_cod"]').attr('selected',true);
    $('#usu').selectpicker('refresh');
    $("#emp").val("");
    
}

//AGREGAR
    $("#btnsave").attr("disabled","disabled");
    $('#ultrecibo').keyup(function () {
        if($("#ultrecibo").val()===""){
            $("#btnsave").attr("disabled","disabled");
        }else{
            $("#btnsave").removeAttr("disabled");
        }
    });
   refrescarDatos();

    $(document).on("click","#btnsave",function(){
        var descri,suc,emp,usu,ultrecibo;
        descri = $("#descri").val();
        suc = $("#suc").val();
        emp = $("#emp").val();
        usu = $("#usu").val();
        ultrecibo = $("#ultrecibo").val();
      
        // $("#btnsave").attr("disabled","disabled");
        // $("#btnsave").html("AGREGANDO...");
      if(descri !== "" && suc !== "" && usu !== "" && ultrecibo !=="" && emp !=="" ){

        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:0,descri:descri,suc:suc,ultrecibo:ultrecibo,usu:usu,ope:1}
        }).done(function(msg){
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            //se actualizan los datos de la tabla
            refrescarDatos();
            vaciar();
        //alert(msg);
        });
         }else{
            //Si algun campo esta vacio se muestra un mensaje de alerta
                humane.log("<span class='fa fa-info'>Por favor verifique los campos</span>", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });
            }
    });
//FIN AGREGAR


//DESACTIVAR
   
  $(document).on("click",".desactivar",function(){
        var pos = $(".desactivar").index(this);
        var cod;
       $("#lista tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
          cod = $(this).html(); 
       });
        $("#desactivo").val(cod);
        $(".msg").html('<h4 class="modal-title" id="myModalLabel">DESEA DESACTIVAR EL REGISTRO Nro. '+cod+' ?</h4>');
    });
  
  $(document).on("click","#desactivo",function(){
      var cod = $("#desactivo").val();
        $.ajax({
           type: 'POST',
           url: 'grabar.php',
           data: {codigo:cod,descri:'',suc:0,ultrecibo:0,usu:0,ope:5}
        }).done(function(msg){
            $("#hide").click();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            refrescarDatos();
            }); 
  });
//FIN DESACTIVAR

//ACTIVAR   
  $(document).on("click",".activar",function(){
        var pos = $(".activar").index(this);
        var cod;
       $("#lista tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
          cod = $(this).html(); 
       });
        $("#activo").val(cod);
        $(".msg").html('<h4 class="modal-title" id="myModalLabel">DESEA ACTIVAR EL REGISTRO Nro. '+cod+' ?</h4>');
    });
  
  $(document).on("click","#activo",function(){
      var cod = $("#activo").val();
        $.ajax({
           type: 'POST',
           url: 'grabar.php',
           data: {codigo:cod,descri:'',suc:0,ultrecibo:0,usu:0,ope:6}
        }).done(function(msg){
            $("#hide2").click();
            humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
            refrescarDatos();
            }); 
  });
//FIN ACTIVAR

//EDITAR
    $(document).on("click",".editar",function(){
        //$("#btn_edit").attr("disabled","disabled");
        var pos = $(".editar").index(this);
        $("#lista tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
            var cod  = $(this).html();
            $("#cod_edit").val(cod);
            $.ajax({
                type: 'POST',
                async: true,
                url: 'editar.php',
                data:{cod:cod}
            }).done(function(msg){
                var dame = eval("("+msg+")");
                console.log(dame);
                $("#suc_edit").val(dame.suc_cod).trigger('change');
                $("#usu_edit").val(dame.usu_cod).trigger('change');
                $("#ultrecibo_edit").val(dame.caja_ultrecibo);
                $("#descri_edit").val(dame.caja_desc);
  
                $("#descri_edit").focus();
            });

        });

  });

     
    $(document).on("click","#btn_edit",function(){
      //  var descri,ultfactura,suc,puntoexp,ultnc,ultrecibo,emp ;
       var descri = $("#descri_edit").val();
       var suc = $("#suc_edit").val();
       var usu = $("#usu_edit").val();
       var ultrecibo = $("#ultrecibo_edit").val();
       var cod = $("#cod_edit").val();
        
        // $("#btn_edit").attr("disabled","disabled");
        // $("#btn_edit").html("Editando...");
        if(descri!=="" && suc!=="" && usu!=="" && ultrecibo!==""){
        $.ajax({
            type: "POST",
            url: "grabar.php",
            data: {codigo:cod,descri:descri,suc:suc,ultrecibo:ultrecibo,usu:usu,ope:2}
        }).done(function(msg){
            // $('.cerrar').click(); cierra al darle click solamente
            $("#modal_basic").modal("hide");
            $("#hide3").click();
          //  $("#btn_edit").html("Editar");
           humane.log("<span class='fa fa-check'></span> "+msg, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
                refrescarDatos();
                vaciar();
            //alert(msg);
          });
     }   
    });

    // $("#compra_edit").keypress(function(e){
    //     if(e.which === 13 && $("#compra_edit").val()!==""){
    //         $("#btn_edit").focus();
    //         $("#btn_edit").click();
    //     }else{

    //     }
    // });
    // $('#venta_edit').keyup(function () {
    //     if($("#venta_edit").val()===""){
    //         $("#btn_edit").attr("disabled","disabled");
    //     }else{
    //         $("#btn_edit").removeAttr("disabled");
    //     }
    // });
//FIN EDITAR




 $("#suc").change(function(){
        empresa();
       
    });
function empresa(){
        var cod = $('#suc').val();
        $.ajax({
            type: "POST",
            url: "empresa.php",
            data: {cod: cod}
        }).done(function(empresa){
            $("#emp").val(empresa);
            // $("#emp").focus();
        });
    }
    $("#ultrecibo").keypress(function(e){
    if(e.which === 13){
        $("#btnsave").focus();
        $("#btnsave").click();
    }else{
        
    }
    });
});