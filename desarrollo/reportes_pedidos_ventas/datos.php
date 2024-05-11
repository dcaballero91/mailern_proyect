<?php
require "../clases/conexion.php";

$desde =  $_GET["desde"]; 
$hasta =  $_GET["hasta"];  
$suc =    $_GET["suc"]; 
$cli =    $_GET["fun"]; 
$est =    $_GET["est"]; 

// $desde =  '01/01/2019'; 
// $hasta =  '12/10/2021';  
// $suc =    '0'; 
// $cli =    '0'; 
// $est =    '0'; 


if ($suc == '0' && $cli == '0'){

    if($est == '0'){
        $where = "WHERE ped_fecha::date BETWEEN '$desde' AND '$hasta' ORDER BY 1";
    }else if ($est != '0') {
        $where = "WHERE ped_estado = '$est' AND ped_fecha::date BETWEEN '$desde' AND '$hasta' ORDER BY 1";
    }

}elseif($suc != '0' && $cli != '0'){
    if($est == '0'){
        $where = "where ped_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc and cli_cod = $cli order by 1";
    }else if($est != '0' ){
        $where = "where ped_estado = '$det' and ped_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc and cli_cod = $cli order by 1";
    }
    
}elseif($cli == '0'){
    
    if($est == '0'){
        $where = "where  ped_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
    }else if($est != '0' ){
        $where = "where ped_estado = '$est' and ped_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
    }

}elseif($cli != '0'){

    if($est == '0'){
        $where = "where  ped_fecha::date BETWEEN '$desde' and '$hasta' and cli_cod = $cli order by 1";
    }else if($est != '0' ){
        $where = "where ped_estado = '$est' and ped_fecha::date BETWEEN '$desde' and '$hasta' and cli_cod = $cli";
    }
    
}elseif ($suc = '0'){
    
    if($est == '0'){
        $where = "where  ped_fecha::date BETWEEN '$desde' and '$hasta' and cli_cod = $cli order by 1";
    }else if($est != '0' ){
        $where = "where ped_estado = '$est' and ped_fecha::date BETWEEN '$desde' and '$hasta' and cli_cod = $cli  order by 1";
    }

}elseif($suc != '0'){

    if($est == '0'){
        $where = "where  ped_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
    }else if($est != '0' ){
        $where = "where ped_estado = '$est' and ped_fecha::date BETWEEN '$desde' and '$hasta' and suc_cod = $suc order by 1";
    }
    
}

$con = new conexion();
$con->conectar();
$sql = pg_query("SELECT * FROM v_pedidos_ventas_cab $where ");
$datos = pg_fetch_all($sql);

if(!empty($datos)){

   function detalle($cod){
        $sql0 = pg_query('select * from v_pedidos_ventas_det where ped_vcod = '.$cod.'');
        while ($det = pg_fetch_array($sql0)){
            $detalle[] = array(
                'ped_vcod' => $det["ped_vcod"],
                'items_cod' => $det["item_cod"],
                'descri'    => $det["item_desc"],
                'descrip'   => $det["mar_desc"],
                'hasta'     => $det["ped_cantidad"],
                'precio'    => $det["ped_precio"]
            );
        }
        return $detalle;
    }   

    $rows = pg_num_rows($sql);
    while($cab = pg_fetch_array($sql)){
        $button_imp = "<a target='_blank' class='btn btn-info btn-mini' href='../informes/imp_pedidoventas.php?id=".$cab["ped_vcod"]."'>Imprimir<i class='fa md-clear'></i></a>";
        $detalle = detalle($cab["ped_vcod"]);
        $total = 0;
        foreach ($detalle as $valor){
    
            $prec = $valor["precio"];
    
            $subtotal = $prec;
            $total = $total + $subtotal;
        }
        $array[] = array('cod' => $cab["ped_vcod"],
            'fecha'         => $cab["ped_fecha"],
            'proveedor'     => $cab["cli_nom"],
            'prov_ruc'      => $cab["cli_ruc"],
            'prov_direcc'   => $cab["emp_dir"],
            'prov_email'    => $cab["per_email"],
            'fun_cod'       => $cab["fun_cod"],
            'estado'        => $cab["ped_estado"],
            'acciones'      => $button_imp,
            'total'         => number_format($total,0,',','.').' Gs.',
            'detalle' => $detalle);
    
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