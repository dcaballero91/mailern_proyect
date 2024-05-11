<?php
require "../clases/conexion.php";

$desde =  $_GET["desde"]; 
$hasta =  $_GET["hasta"];  
$suc =    $_GET["suc"]; 
$prov =    $_GET["fun"]; 
$est =    $_GET["est"]; 


if ($suc == '0' && $prov == '0'){

    if($est == '0'){
        $where = "WHERE orden_fecha::date BETWEEN '$desde' AND '$hasta' ORDER BY orden_nro";
    }else if ($est != '0') {
        $where = "WHERE orden_estado = '$est' AND orden_fecha::date BETWEEN '$desde' AND '$hasta' ORDER BY orden_nro";
    }

}elseif($suc != '0' && $prov != '0'){
    if($est == '0'){
        $where = "where orden_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc and prov_cod = $prov order by orden_nro";
    }else if($est != '0' ){
        $where = "where orden_estado = '$det' and orden_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc and prov_cod = $prov order by orden_nro";
    }
    
}elseif($prov == '0'){
    
    if($est == '0'){
        $where = "where  orden_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
    }else if($est != '0' ){
        $where = "where orden_estado = '$est' and orden_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
    }

}elseif($prov != '0'){

    if($est == '0'){
        $where = "where  orden_fecha::date BETWEEN '$desde' and '$hasta' and prov_cod = $prov order by 1";
    }else if($est != '0' ){
        $where = "where orden_estado = '$est' and orden_fecha::date BETWEEN '$desde' and '$hasta' and prov_cod = $prov";
    }
    
}elseif ($suc = '0'){
    
    if($est == '0'){
        $where = "where  orden_fecha::date BETWEEN '$desde' and '$hasta' and prov_cod = $prov order by 1";
    }else if($est != '0' ){
        $where = "where orden_estado = '$est' and orden_fecha::date BETWEEN '$desde' and '$hasta' and prov_cod = $prov  order by 1";
    }

}elseif($suc != '0'){

    if($est == '0'){
        $where = "where  orden_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by orden_nro";
    }else if($est != '0' ){
        $where = "where orden_estado = '$est' and orden_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by orden_nro";
    }
    
}

$con = new conexion();
$con->conectar();
$sql = pg_query("SELECT * FROM v_ordenes_compras_cab $where ");
$datos = pg_fetch_all($sql);

if(!empty($datos)){

   function detalle($cod){
        $sql0 = pg_query('select * from v_ordenes_compras_det where orden_nro = '.$cod.'');
        while ($det = pg_fetch_array($sql0)){
        $detalle[] = array('orden_nro' => $det["orden_nro"],
            'items_cod' => $det["item_cod"],
            'descri'    => $det["item_desc"],
            'descrip'   => $det["mar_desc"],
            'hasta'     => $det["orden_cantidad"],
            'precio'    => $det["orden_precio"]);
        }
        return $detalle;
    }   

    $rows = pg_num_rows($sql);
    while($cab = pg_fetch_array($sql)){
        $button_imp = "<a target='_blank' class='btn btn-info btn-mini' href='../informes/imp_ordencompras.php?id=".$cab["orden_nro"]."'>Imprimir<i class='fa md-clear'></i></a>";
        $detalle = detalle($cab["orden_nro"]);
        $total = 0;
        foreach ($detalle as $valor){
    
            $prec = $valor["precio"];
    
            $subtotal = $prec;
            $total = $total + $subtotal;
        }
        $array[] = array('cod' => $cab["orden_nro"],
            'fecha'         => $cab["orden_fecha"],
            'proveedor'     => $cab["prov_nombre"],
            'prov_ruc'      => $cab["prov_ruc"],
            'prov_direcc'   => $cab["prov_dir"],
            'prov_email'    => $cab["per_email"],
            'fun_cod'       => $cab["fun_cod"],
            'estado'        => $cab["orden_estado"],
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