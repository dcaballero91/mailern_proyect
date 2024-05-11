<?php
require "../clases/conexion.php";

$desde =  $_GET["desde"]; 
$hasta =  $_GET["hasta"];  
$suc =    $_GET["suc"]; 
$fun =    $_GET["fun"]; 
$est =    $_GET["est"]; 

// $desde =  '01/01/2019'; 
// $hasta =  '12/10/2021';  
// $suc =    '0'; 
// $fun =    '0'; 
// $est =    '0'; 


if ($suc == '0' && $fun == '0'){

    if($est == '0'){
        $where = "WHERE agen_fecha::date BETWEEN '$desde' AND '$hasta' ORDER BY 1";
    }else if ($est != '0') {
        $where = "WHERE agen_estado = '$est' AND agen_fecha::date BETWEEN '$desde' AND '$hasta' ORDER BY 1";
    }

}elseif($suc != '0' && $fun != '0'){
    if($est == '0'){
        $where = "where agen_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc and fun_cod = $fun order by 1";
    }else if($est != '0' ){
        $where = "where agen_estado = '$det' and agen_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc and fun_cod = $fun order by 1";
    }
    
}elseif($fun == '0'){
    
    if($est == '0'){
        $where = "where  agen_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
    }else if($est != '0' ){
        $where = "where agen_estado = '$est' and agen_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
    }

}elseif($fun != '0'){

    if($est == '0'){
        $where = "where  agen_fecha::date BETWEEN '$desde' and '$hasta' and fun_cod = $fun order by 1";
    }else if($est != '0' ){
        $where = "where agen_estado = '$est' and agen_fecha::date BETWEEN '$desde' and '$hasta' and fun_cod = $fun";
    }
    
}elseif ($suc = '0'){
    
    if($est == '0'){
        $where = "where  agen_fecha::date BETWEEN '$desde' and '$hasta' and fun_cod = $fun order by 1";
    }else if($est != '0' ){
        $where = "where agen_estado = '$est' and agen_fecha::date BETWEEN '$desde' and '$hasta' and fun_cod = $fun  order by 1";
    }

}elseif($suc != '0'){

    if($est == '0'){
        $where = "where  agen_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
    }else if($est != '0' ){
        $where = "where agen_estado = '$est' and agen_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
    }
    
}

$con = new conexion();
$con->conectar();
$sql = pg_query("SELECT * FROM v_agendas_cab $where ");
$datos = pg_fetch_all($sql);

if(!empty($datos)){

   function detalle($cod){
        $sql0 = pg_query('select * from v_agendas_det where agen_cod = '.$cod.'');
        while ($det = pg_fetch_array($sql0)){
        $detalle[] = array(
            'agen_cod' => $det["agen_cod"],
            // 'items_cod' => $det["item_cod"],
            // 'descri'    => $det["item_desc"],
            'dia'    => $det["dias_desc"],
            'hdesde'     => $det["hora_desde"],
            'hhasta'    => $det["hora_hasta"]
            // 'descrip'   => $det["mar_desc"],
        );
        }
        return $detalle;
    }   

    $rows = pg_num_rows($sql);
    while($cab = pg_fetch_array($sql)){
        $button_imp = "<a target='_blank' class='btn btn-info btn-mini' href='../informes/imp_agendas_full.php?id=".$cab["agen_cod"]."'>Imprimir<i class='fa md-clear'></i></a>";
        $detalle = detalle($cab["agen_cod"]);
        // $total = 0;
        // foreach ($detalle as $valor){
    
        //     // $prec = $valor["precio"];
    
        //     // $subtotal = $prec;
        //     // $total = $total + $subtotal;
        // }
        $array[] = array('cod' => $cab["agen_cod"],
            'fecha'         => $cab["agen_fecha"],
            'proveedor'     => $cab["fun_nom"],
            'prov_ruc'      => $cab["emp_ruc"],
            'prov_direcc'   => $cab["emp_dir"],
            'prov_email'    => $cab["emp_email"],
            'fun_cod'       => $cab["fun_cod"],
            'estado'        => $cab["agen_estado"],
            'acciones'      => $button_imp,
         //   'total'         => number_format($total,0,',','.').' Gs.',
            'detalle' => $detalle
        );
    
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