<?php
 require '../clases/conexion.php';
 $con = new conexion();
 $con->conectar();

//  $sql = pg_query("select coalesce(max(comp_cod),0)+1 as ultcod from compras_cab");
//  $rs = pg_fetch_assoc($sql);
//  echo $rs["ultcod"];

 $nro = pg_query("SELECT ((btrim((to_char(1, '000'::text) || '-'::text)) || btrim((to_char(t.puntoexp, '000'::text) || '-'::text))) || btrim(to_char(t.tim_ultfactura, '0000000'::text))) AS ultima_factura from timbrados t WHERE timb_cod = 6 ");
 $siguiente_factura = pg_fetch_assoc($nro);
 
 echo $siguiente_factura['ulima_factura'];
?>