<?php

require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query('SELECT * FROM v_aperturas_cierres ORDER BY aper_cier_cod DESC' );
$apercierre = pg_fetch_all($sql);   

if(!empty($apercierre)){
    
    while($apercierre = pg_fetch_array($sql)){
        $button_imp = "<a target='_blank' class='btn btn-primary btn-circle' href='../informes/imp_arqueo.php?cod=".$apercierre["aper_cier_cod"]."' title='IMPRIMIR'>ARQUEO<i class='fa fa print'></i></a>";
        $rec = "<a target='_blank' class='btn btn-primary btn-circle' href='../informes/imp_recaudacion_dep.php?cod=".$apercierre["aper_cier_cod"]."' title='IMPRIMIR'>REC. DEP<i class='fa fa print'></i></a>";
        $cerrar = "<button type='button' class='btn btn-danger btn-circle confirmar pull-right' data-toggle='modal' data-target='#confirmacion' data-placement='top' title='Cerrar Caja'>CIERRE<i class='fa fa print'></i></button>";

        $button = $cerrar." ".$button_imp." ".$rec;
        $totalcierre = totalcierre($apercierre["aper_cier_cod"]);
        $total = 0;
        foreach ($totalcierre as $valor){
            $montocierre = $valor["montocierre"];
            if($montocierre != 0){
                $efectivo = $valor["montoefect"];
                $tarjeta = $valor["montotarj"];
                $cheque = $valor["montocheque"];
                $montoapertura =  $valor["montoapertura"];
                $subtotal = $montoapertura + $efectivo + $tarjeta + $cheque;
                $total = $total + $subtotal;
            }else{
                $total = 0;
            }
        }
        $array[] = array(
            'codigo'     => $apercierre["aper_cier_cod"],
            'sucursal'    => utf8_encode($apercierre["suc_nom"]),
            'feaper'      => $apercierre["fecha_aperformato"],
            'fecierre'    => $apercierre["fecha_cierreformato"],
            'apermonto'   => $apercierre["aper_monto"],
            'caja'        => utf8_encode($apercierre["caja_cod"].'-'.$apercierre["caja_desc"]),
            'facturasgte' => $apercierre["siguiente_factura"],
            'montoefect'  => $apercierre["monto_efectivo"],
            'montotarj'   => $apercierre["monto_tarjeta"],
            'montocheque' => $apercierre["monto_cheque"],
            'acciones'    => $button,
            'total'       => number_format($total,0,',','.').' Gs.',
            'totalcierre' => $totalcierre
        );
        $data = array('data' => $array);
        $json = json_encode($data,JSON_UNESCAPED_UNICODE);
    }
    print_r (utf8_decode($json));

}else{
    $array[] = array(
        'codigo'      => "",
        'sucursal'    => "",
        'feaper'      => "",
        'fecierre'    => "",
        'apermonto'   => "",
        'caja'        => "",
        'facturasgte' => "",
        'montoefect'  => "",
        'montotarj'   => "",
        'montocheque' => "",
        'acciones'    => "",
        'total'       => "",
        'totalcierre' => ""
    );
    $data = array('data' => $array);
    $json = json_encode($data,JSON_UNESCAPED_UNICODE);
    print_r (utf8_decode($json));
}

function totalcierre($cod){
    $sql0 = pg_query('select * from v_aperturas_cierres where aper_cier_cod = '.$cod.' order by 1');
    while ($apercierre = pg_fetch_array($sql0)){
        $totalcierre[] = array('aper_cier_cod' => $apercierre["aper_cier_cod"],
                                'montoapertura' => $apercierre["aper_monto"],
                                'montoefect' => $apercierre["monto_efectivo"],
                                'montotarj' => $apercierre["monto_tarjeta"],
                                'montocheque' => $apercierre["monto_cheque"],
                                'montocierre' => $apercierre["aper_cier_monto"],
                            );
                                
    }
    return $totalcierre;  
}

?>


