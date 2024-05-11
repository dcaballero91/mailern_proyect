<?php
require "../clases/conexion.php";

$desde =  $_GET["desde"]; 
$hasta =  $_GET["hasta"];  
$suc =    $_GET["suc"]; 
$fun =    $_GET["fun"]; 
$est =    $_GET["est"]; 


if ($suc == '0' && $fun == '0'){

    if($est == '0'){
        $where = "WHERE promo_feinicio::date BETWEEN '$desde' AND '$hasta' ORDER BY 1";
    }else if ($est != '0') {
        $where = "WHERE promo_estado = '$est' AND promo_feinicio::date BETWEEN '$desde' AND '$hasta' ORDER BY 1";
    }

}elseif($suc != '0' && $fun != '0'){
    if($est == '0'){
        $where = "where promo_feinicio::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc and fun_cod = $fun order by 1";
    }else if($est != '0' ){
        $where = "where promo_estado = '$det' and promo_feinicio::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc and fun_cod = $fun order by orden_nro";
    }
    
}elseif($fun == '0'){
    
    if($est == '0'){
        $where = "where  promo_feinicio::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
    }else if($est != '0' ){
        $where = "where promo_estado = '$est' and promo_feinicio::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
    }

}elseif($fun != '0'){

    if($est == '0'){
        $where = "where  promo_feinicio::date BETWEEN '$desde' and '$hasta' and fun_cod = $fun order by 1";
    }else if($est != '0' ){
        $where = "where promo_estado = '$est' and promo_feinicio::date BETWEEN '$desde' and '$hasta' and fun_cod = $fun";
    }
    
}elseif ($suc = '0'){
    
    if($est == '0'){
        $where = "where  promo_feinicio::date BETWEEN '$desde' and '$hasta' and fun_cod = $fun order by 1";
    }else if($est != '0' ){
        $where = "where promo_estado = '$est' and promo_feinicio::date BETWEEN '$desde' and '$hasta' and fun_cod = $fun  order by 1";
    }

}elseif($suc != '0'){

    if($est == '0'){
        $where = "where  promo_feinicio::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
    }else if($est != '0' ){
        $where = "where promo_estado = '$est' and promo_feinicio::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
    }
    
}

$con = new conexion();
$con->conectar();
$sql = pg_query("SELECT * FROM v_promociones_cab $where ");
$datos = pg_fetch_all($sql);

if(!empty($datos)){

   function detalle($cod){
        $sql0 = pg_query('select * from v_promociones_detalles where promo_cod = '.$cod.'');
        while ($det = pg_fetch_array($sql0)){
        $detalle[] = array('promo_cod' => $det["promo_cod"],
            'items_cod' => $det["item_cod"],
            'descri'    => $det["item_desc"],
            'descrip'         => $det["mar_desc"],
            'precioAntes'     => $det["item_precio"],
            'monto'     => $det["promo_desc"],
            'precio'    => $det["promo_precio"]);
        }
        return $detalle;
    }   

    $rows = pg_num_rows($sql);
    while($cab = pg_fetch_array($sql)){
        $button_imp = "<a target='_blank' class='btn btn-info btn-mini' href='../informes/imp_promocion.php?id=".$cab["promo_cod"]."'>Imprimir<i class='fa md-clear'></i></a>";
        $detalle = detalle($cab["promo_cod"]);
        $total = 0;
        foreach ($detalle as $valor){
    
            $prec = $valor["precio"];
    
            $subtotal = $prec;
            $total = $total + $subtotal;
        }
        $array[] = array('cod' => $cab["promo_cod"],
            'fecha'         => $cab["promo_feinicio"],
            'proveedor'     => $cab["fun_nom"],
            'prov_ruc'      => $cab["emp_ruc"],
            'prov_direcc'   => $cab["emp_dir"],
            'prov_email'    => $cab["emp_email"],
            'fun_cod'       => $cab["fun_cod"],
            'estado'        => $cab["promo_estado"],
            'acciones'      => $button_imp,
            'total'         => number_format($total,0,',','.').' Gs.','detalle' => $detalle);
    
        $data = array('data' => $array);
        $json = json_encode($data);  

    }
    // function detalle($cod){
    //     $sql0 = pg_query('select * from v_pedidos_compras_det where orden_nro = '.$cod.'');
    //     while ($det = pg_fetch_array($sql0)){
    //     $detalle[] = array('orden_nro' => $det["orden_nro"],
    //         'items_cod' => $det["item_cod"],
    //         'descri'    => $det["item_desc"],
    //         'descrip'   => $det["mar_desc"],
    //         'hasta'     => $det["ped_cantidad"],
    //         'precio'    => $det["ped_precio"]);
    //     }
    //     return $detalle;
    // }   
    
    print_r(utf8_decode($json));
    
    
}else {
    $array[] = array(
    'cod'           => '-',
    'fecha'         => '-',
    'proveedor'     => '-',
    'prov_ruc'      => '-',
    'prov_direcc'   => '-',
    'prov_email'    => '-',
    'fun_cod'       => '-',
    'estado'        => '-',
    'acciones'      => '-',
    'total'         => '-');

    $data = array('data' => $array);
    $json = json_encode($data);  
    print_r(utf8_decode($json));
}

?>