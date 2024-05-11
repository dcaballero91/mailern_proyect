<?php

require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("select * from v_promociones_cab where promo_cod in (select promo_cod from v_promociones_detalles ) order by promo_cod");

$promo = pg_fetch_all($sql);
                                                                                          

$button_borrar = '<button type=\'button\' class=\'btn btn-primary btn-circle btn-lg delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Borrar\'><i class=\'fa fa-minus\'></i></button>';



$button = $button_borrar;

if(!empty($promo)){
    
    $datos['data']=[];
    foreach($promo as $key => $cab){
         $datos['data'][$key]['cod'] = $cab['promo_cod'];
         $datos['data'][$key]['dfecha'] = $cab['promo_dfecha'];
         $datos['data'][$key]['feinicio'] = $cab['promo_feinicio'];
         $datos['data'][$key]['fefin'] = $cab['promo_fefin'];
         $datos['data'][$key]['usu'] = $cab['usu_name'];
         $datos['data'][$key]['estado'] = $cab['promo_estado'];
         $datos['data'][$key]['acciones'] =  $button;
    
        $sqldetalle = pg_query('select * from v_promociones_detalles where promo_cod='.$cab['promo_cod']);
        $detalles = pg_fetch_all($sqldetalle);
            
            foreach ($detalles as $key2 => $det) {
            $datos['data'][$key]['detalle'][$key2]['cod'] = $det['promo_cod']; 
            $datos['data'][$key]['detalle'][$key2]['tservicio'] = $det['item_desc'];
            $datos['data'][$key]['detalle'][$key2]['marcas'] = $det['mar_desc'];
            $datos['data'][$key]['detalle'][$key2]['preanterior'] = $det['item_precio'];
            $datos['data'][$key]['detalle'][$key2]['descuento'] = $det['promo_desc'];
            $datos['data'][$key]['detalle'][$key2]['tipodesc'] = $det['tipo_desc'];
            $datos['data'][$key]['detalle'][$key2]['prepromo'] = $det['promo_precio'];
          
            }
    
                    
    }
    
     echo  json_encode($datos);
     return json_encode($datos);

}else{
    $datos['data']=[];
         $datos['data']['cod'] = '-';
         $datos['data']['dfecha'] = '-';
         $datos['data']['feinicio'] = '-';
         $datos['data']['fefin'] = '-';
         $datos['data']['usu'] = '-';
         $datos['data']['estado'] = '-';
         $datos['data']['acciones'] =  '-';
    
    
 
    
     echo  json_encode($datos);
     return json_encode($datos);

}

?>