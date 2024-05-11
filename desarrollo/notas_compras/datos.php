<?php
require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("select * from v_notas_compras_cab  ");
$notacompras = pg_fetch_all($sql);
                                                                                          
if(!empty($notacompras)){

        $button_borrar = '<button type=\'button\' class=\'btn btn-primary btn-circle   delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Anular\'><i class=\'fa fa-times\'></i></button>';
        
        $button = $button_borrar;
        
        $datos['data']=[];
        foreach($notacompras as $key => $notacompras){
                $notanro = $notacompras['nota_com_nro'];
                $compcod = $notacompras['comp_cod'];
                $tiponota = $notacompras['nota_com_tipo'];
                $notacredmotivo = $notacompras['nota_cred_motivo'];
        
                $datos['data'][$key]['notanro']      = $notacompras['nota_com_nro'];
                $datos['data'][$key]['cod']          = $notacompras['comp_cod'];
                $datos['data'][$key]['fecha']        = $notacompras['nota_com_fecha'];
                $datos['data'][$key]['timbrado']     = $notacompras['nota_com_timbrado'];
                $datos['data'][$key]['nro_factura']  = $notacompras['nota_com_factura'];
                $datos['data'][$key]['tipo_factura'] = $notacompras['nota_com_tipo'];
                $datos['data'][$key]['estado']       = $notacompras['nota_com_estado'];
                $datos['data'][$key]['acciones']     =  $button;
        
                // $sqldetalle = pg_query(" SELECT * from v_compras_det where prov_cod = '"+$notacompras['prov_cod']+"' " + " AND prov_timb_nro = ' "+$notacompras['prov_timb_nro']+"' +  " and nro_factura = '"+$notacompras['nro_factura']+"'  );
                
                // $sqldetalle = pg_query('SELECT * from v_compras_det where prov_cod = \'.$notacompras[\'prov_cod\'].\' AND prov_timb_nro = \'.$notacompras[\'prov_timb_nro\'].\' and nro_factura = \'.$notacompras[\'nro_factura\'].' );
        
                if($tiponota == "CREDITO" && $notacredmotivo == "DEVOLUCION"){
        
                        $sqldetalle = pg_query("SELECT * from v_notas_compras_det  where nota_com_nro = '$notanro' and comp_cod = '$compcod' " );
                        $detalles = pg_fetch_all($sqldetalle);
                        
                        foreach ($detalles as $key2 => $detalle) {
                                $datos['data'][$key]['detalle'][$key2]['codigo'] = $detalle['item_cod'];
                                $datos['data'][$key]['detalle'][$key2]['descripcion'] = $detalle['item_desc'];
                                $datos['data'][$key]['detalle'][$key2]['marca'] = $detalle['mar_cod'].' - '.$detalle['mar_desc'];
                                $datos['data'][$key]['detalle'][$key2]['cantidad'] = $detalle['nota_com_cant'];
                                $datos['data'][$key]['detalle'][$key2]['precio'] = $detalle['nota_com_precio'];
                                    
                        }
        
                }elseif ($tiponota == "CREDITO" && $notacredmotivo == "DESCUENTO") {
                        $datos['data'][$key]['detalle']['tipo'] = 'debito';
                        $datos['data'][$key]['detalle']['codigo'] = '-';
                        $datos['data'][$key]['detalle']['descripcion'] = '-';
                        $datos['data'][$key]['detalle']['marca'] = '-';
                        $datos['data'][$key]['detalle']['cantidad'] = '-';
                        $datos['data'][$key]['detalle']['precio'] = '-';
                
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
}else{
        $datos['data']=[];
        $datos['data']['notanro'] = '-';
        $datos['data']['cod'] = '-';
        $datos['data']['fecha'] = '-';
     //   $datos['data']['proveedor'] = '-';
        $datos['data']['tipo_factura'] = '-';
        $datos['data']['estado'] = '-';
        $datos['data']['acciones'] =  '-';
}

?>