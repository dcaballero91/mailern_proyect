<?php

require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("select * from v_notas_ventas_cab  ");
$compras = pg_fetch_all($sql);
                                                                                          

$button_borrar = '<button type=\'button\' class=\'btn btn-primary btn-circle   delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Anular\'><i class=\'fa fa-times\'></i></button>';



$button = $button_borrar;



$datos['data']=[];
foreach($compras as $key => $compras){
        $notanro = $compras['nota_ven_cod'];
        $proveedor = $compras['nota_ven_nro_fact'];
        $timbrado = $compras['nota_ven_fecha'];
        $tiponota = $compras['nota_ven_tipo'];
        $motivonota = $compras['nota_ven_motivo'];

        $datos['data'][$key]['notanro'] = $compras['nota_ven_cod'];
        $datos['data'][$key]['nro'] = $compras['nota_ven_nro_fact'];
        $datos['data'][$key]['cod'] = $compras['cli_nom'];
        $datos['data'][$key]['fecha'] = $compras['nota_ven_fecha'];
        $datos['data'][$key]['tipo_factura'] = $compras['nota_ven_tipo'];
        $datos['data'][$key]['estado'] = $compras['nota_ven_estado'];
        $datos['data'][$key]['acciones'] =  $button;

        if($tiponota === "CREDITO" && $motivonota === "ANULACION"){

                $sqldetalle = pg_query("SELECT * FROM v_notas_ven_detalles WHERE nota_ven_cod = '$notanro' " );
                $detalles = pg_fetch_all($sqldetalle);
                
                foreach ($detalles as $key2 => $detalle) {
                        $datos['data'][$key]['detalle'][$key2]['codigo'] = $detalle['item_cod'];
                        $datos['data'][$key]['detalle'][$key2]['descripcion'] = $detalle['item_desc'];
                        $datos['data'][$key]['detalle'][$key2]['marca'] = $detalle['mar_cod'].' - '.$detalle['mar_desc'];
                        $datos['data'][$key]['detalle'][$key2]['cantidad'] = $detalle['nota_ven_cant'];
                        $datos['data'][$key]['detalle'][$key2]['precio'] = $detalle['nota_ven_precio'];
                            
                }

        }elseif ($tiponota == "DEBITO") {
                $datos['data'][$key]['detalle']['tipo'] = 'debito';
                $datos['data'][$key]['detalle']['codigo'] = '-';
                $datos['data'][$key]['detalle']['descripcion'] = '-';
                $datos['data'][$key]['detalle']['marca'] = '-';
                $datos['data'][$key]['detalle']['cantidad'] = '-';
                $datos['data'][$key]['detalle']['precio'] = '-';
        }

                
}

 echo  json_encode($datos);
 return json_encode($datos);

?>