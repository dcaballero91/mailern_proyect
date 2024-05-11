//NOTAS:
//Realiza la Apertura y Cierre de Cajas..
//OBS= //no reconoce el codigo de caja.
  //*FALTA== realizar la suma "Total del Monto"
  //*FALTA== Modal con la cantidad  del (-monto abierto-)



//------------------------------------------------------------------------
 //JS FUNCIONA TODO!!
 $(function(){
var Path ='imp_arqueo.php';
     var tabla =  $('#apercierre').dataTable({
    "columns":
    [
        { "data": "codigo" },
        // { "data": "empresa" },
        { "data": "sucursal" },
        { "data": "feaper" },
        { "data": "fecierre" },
        { "data": "apermonto" },
        { "data": "caja" },
        { "data": "facturasgte" },
        { "data": "montoefect" },
        { "data": "montotarj" },
        { "data": "montocheque" },
         { "data": "total" },
        { "data": "acciones"}

    ]

 });
    tabla.fnReloadAjax( 'datos.php' );
    function refrescarDatos(){
        tabla.fnReloadAjax();
    }
////FIN TABLA


//APERTURA DE CAJA
    $(document).on("click","#btnsave",function(){     //#btnsave  es el id del boton  guardar
        var apermonto = $("#aperturamonto").val();
        var caja = $("#caja").val();
        var usu = $("#usuario").val();
    
        if(apermonto>0 && caja>0){ 
          $.ajax({
              type: "POST",
              url: "grabar.php",                //grabar: variable, grabar:variable, grabar:variable del sp=en grabar de la  linea  14
              data: {codigo:0,apermonto:apermonto,caja:caja,usu:usu,ope:1}
          }).done(function(msg){
            mostrarMensaje(msg);
            $("#aperturamonto").val('');
            $('#caja > option[value=""]').attr('selected',true);  //combo
            refrescarDatos();
          });
        }else{
          humane.log("<span class='fa fa-check'></span> Por favor complete los datos", { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-warning' });      
        }
    });
    
//FIN APERTURA DE CAJA

//CIERRE DE CAJA
$(document).on("click",".confirmar",function(){
        var pos = $(".confirmar").index(this);
        var cod;
        var cajacod;
       $("#apercierre tbody tr:eq("+pos+")").find("td:eq(0)").each(function(){
          cod = $(this).html(); 
       });
       $("#apercierre tbody tr:eq("+pos+")").find("td:eq(5)").each(function(){
          cajacod = $(this).html();
          cajacod = cajacod.split("-");
          cajacod = cajacod[0].trim(); 
       });
        $("#cod_eliminar").val(cajacod);
        $("#delete").val(cod);
        $(".msg").html('<h4 class="modal-title" id="myModalLabel">DESEA CERRAR LA CAJA DEL REGISTRO Nro. '+cod+' ?</h4>');
    });

                        //Button= id="borrar" -->Si
 $(document).on("click","#delete",function(){
      var codigo = $("#delete").val();
      var caja = $("#cod_eliminar").val();
      var usu = $("#usuario").val();
      alert(`Este es el codigo de caja ha ser cerrado ${caja} - ${usu}`)
        $.ajax({
           type: 'POST',
           url: 'grabar.php',   
           data: {codigo: codigo, apermonto: 0, caja:caja, usu:usu, ope: 2}
        }).done(function(msg){                //no reconoce el codigo de caja
            $("#cerrar2").click();
           mostrarMensaje(msg);
            refrescarDatos();
            }); 
  });
//FIN CIERRE DE CAJA 
  function mostrarMensaje(param){
      var r = param.split("_/_");
      var texto = r[0];
      var tipo = r[1];

      if(tipo.trim() == 'notice'){
        texto = texto.split("NOTICE:");
        texto = texto[1]
        humane.log("<span class='fa fa-check'></span> "+texto, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-success' });
      }
      if(tipo.trim() == 'error'){
        texto = texto.split("ERROR:");
        texto = texto[2];
        humane.log("<span class='fa fa-info'></span> "+texto, { timeout: 4000, clickToClose: true, addnCls: 'humane-flatty-error' });
      }
  }


$(function () {
   

    $(".chosen-select").chosen({width: "100%"});
   

});
});



