<?php
    require_once '../tcpdf/tcpdf.php';
    require_once '../clases/conexion2.php';

$sql = "select * from v_recaudaciones_depositar where aper_cier_cod = ".$_REQUEST['cod'];
$resul = consultas::get_datos($sql);
    
// create new PDF document
$pdf = new TCPDF('P', 'mm', array(215.9,330.2));
$pdf->SetMargins(17, 15, 18);
$pdf->SetTitle("RECAUDACIONES A DEPOSITAR");
$pdf->SetPrintHeader(false);
$pdf->SetPrintFooter(false);
$pdf->AddPage();


$pdf->Ln(5);
$pdf->SetFont('Times', 'B', 14);
//$pdf->SetLineWidth(5);
$pdf->Cell(0, 0, "RECAUDACIONES A DEPOSITAR DE LA APERTURA NRO. ".$resul[0]['aper_cier_cod'], 0, 1, 'C');
$pdf->Ln(1);
$pdf->SetFont('Times', 'B', 14);
//$pdf->SetLineWidth(5);
$pdf->Cell(0, 0, "CAJA: ".$resul[0]['caja_desc'], 0, 1, 'C');
$pdf->Ln(7);

//Informacion linea 1 izq.
$pdf->setFont('Times', 'B', 12);
$pdf->Cell(/*1*/35, /*2*/1, /*3*/'CAJERO:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
$pdf->setFont('Times', '', 12);
$pdf->cell(50, 1, $resul[0]['fun_nom'],/*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null );


//SEPARADOR, PARA QUE LA INFORMACION SALGA EN EL RECUADRO DE LA DERECHA
$pdf->Cell(/*1*/8, /*2*/1, /*3*/'', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
    $pdf->Cell(/*1*/50, /*2*/1, /*3*/'MONTO EN EFECTIVO:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA DATO
    $pdf->Cell(/*1*/35, /*2*/1, /*3*/  number_format($resul[0]['monto_efectivo'], 0, ',', '.').' Gs.', /*4*/0, /*5*/1, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    //INFORMACION LINEA 2 IZQUIERDA
    $pdf->SetFont('Times', 'B', 12);
    $pdf->Cell(/*1*/35, /*2*/1, /*3*/'FECHA APERTURA:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->SetFont('Times', '', 12);
    $pdf->Cell(/*1*/50, /*2*/1, /*3*/$resul[0]['fecha_aperformato'], /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    
    //SEPARADOR, PARA QUE LA INFORMACION SALGA EN EL RECUADRO DE LA DERECHA
    $pdf->Cell(/*1*/8, /*2*/1, /*3*/'', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    
    //INFORMACION LINEA 2 RECUADRO DERECHO
    $pdf->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
    $pdf->Cell(/*1*/50, /*2*/1, /*3*/'MONTO EN CHEQUE:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA DATO
    $pdf->Cell(/*1*/35, /*2*/1, /*3*/number_format($resul[0]['monto_cheque'], 0, ',', '.').' Gs.', /*4*/0, /*5*/1, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    
    //INFORMACION LINEA 3 IZQUIERDA
    $pdf->SetFont('Times', 'B', 12);
    $pdf->Cell(/*1*/35, /*2*/1, /*3*/'MONTO APERTURA:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->SetFont('Times', '', 12);
    $pdf->Cell(/*1*/50, /*2*/1, /*3*/number_format($resul[0]['aper_monto'],0,',','.').' Gs.', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    
    //SEPARADOR, PARA QUE LA INFORMACION SALGA EN EL RECUADRO DE LA DERECHA
    $pdf->Cell(/*1*/8, /*2*/1, /*3*/'', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    
    //INFORMACION LINEA 3 RECUADRO DERECHO
    $pdf->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
    $pdf->Cell(/*1*/50, /*2*/1, /*3*/'MONTO EN TARJETA:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA DATO
    $pdf->Cell(/*1*/35, /*2*/1, /*3*/number_format($resul[0]['monto_tarjeta'], 0, ',', '.').' Gs.', /*4*/0, /*5*/1, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    
    //INFORMACION LINEA 4 RECUADRO IZQUIERDO
    $pdf->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
    $pdf->Cell(/*1*/35, /*2*/1, /*3*/'FECHA CIERRE:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA DATO
    $pdf->Cell(/*1*/35, /*2*/1, /*3*/$resul[0]['fecha_cierreformato'], /*4*/0, /*5*/1, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    
    //INFORMACION LINEA 5 RECUADRO DERECHO
    $pdf->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
    $pdf->Cell(/*1*/143, /*2*/1, /*3*/'TOTAL CIERRE:', /*4*/'B', /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA DATO
    $pdf->Cell(/*1*/35, /*2*/1, /*3*/number_format($resul[0]['aper_cier_monto'], 0, ',', '.').' Gs.', /*4*/'B', /*5*/1, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

    //INFORMACION LINEA 6 RECUADRO DERECHO
    $pdf->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
    $pdf->Cell(/*1*/143, /*2*/1, /*3*/'TOTAL A DEPOSITAR:', /*4*/'B', /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA DATO
    $pdf->Cell(/*1*/35, /*2*/1, /*3*/number_format($resul[0]['monto_efectivo']+$resul[0]['monto_cheque'], 0, ',', '.').' Gs.', /*4*/'B', /*5*/1, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    
    
    //DETALLES DE CHEQUES
    $sqlchs = "select * from v_cobros_cheques where aper_cier_cod = ".$resul[0]['aper_cier_cod']." order by cobro_cod";
    $rschs  = consultas::get_datos($sqlchs);
    //$resul = consultas::get_datos($sql);
    if($rschs){
        $pdf->Ln(8);
        $pdf->SetFont('Times', 'B', 14);
        //$pdf->SetLineWidth(5);
        $pdf->Cell(0, 0, "DETALLE DE CHEQUES", 0, 1, 'C');
        
        $pdf->SetFont('Times', 'B', 10);//TIPO DE LETRA PARA TITULO
        $pdf->Cell(/*1*/25, /*2*/1, /*3*/'TITULAR', /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
        $pdf->Cell(/*1*/25, /*2*/1, /*3*/'NRO. CUENTA', /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
        $pdf->Cell(/*1*/25, /*2*/1, /*3*/'SERIE', /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
       $pdf->Cell(/*1*/40, /*2*/1, /*3*/'NRO. CHEQUE', /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
        $pdf->Cell(/*1*/30, /*2*/1, /*3*/'FECHA PAGO', /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
        $pdf->Cell(/*1*/30, /*2*/1, /*3*/'IMPORTE', /*4*/1, /*5*/1, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    
        foreach ($rschs as $chs) {
            $pdf->SetFont('Times', '', 10);//TIPO DE LETRA PARA TITULO
            $pdf->Cell(/*1*/25, /*2*/1, /*3*/$chs['librador'], /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
            $pdf->Cell(/*1*/25, /*2*/1, /*3*/$chs['ch_cuenta_num'], /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
            $pdf->Cell(/*1*/25, /*2*/1, /*3*/$chs['serie'], /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
           $pdf->Cell(/*1*/40, /*2*/1, /*3*/$chs['cheq_num'], /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
            $pdf->Cell(/*1*/30, /*2*/1, /*3*/$chs['cobro_fecha'], /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
            $pdf->Cell(/*1*/30, /*2*/1, /*3*/number_format($chs['cheq_importe'], 0, ',', '.'), /*4*/1, /*5*/1, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    
        }
    }
    // //DETALLES DE TARJETAS
    
    //FIRMANTES
     //INFORMACION LINEA 1 
     $pdf->Ln(10);
     $pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA TITULO
     $pdf->Cell(/*1*/35, /*2*/1, /*3*/'CAJERO:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
     $pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA DATO
     $pdf->Cell(/*1*/50, /*2*/1, /*3*/'', /*4*/'B', /*5*/0, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

         //SEPARADOR, PARA QUE LA INFORMACION SALGA EN EL RECUADRO DE LA DERECHA
    $pdf->Cell(/*1*/8, /*2*/1, /*3*/'', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

     $pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA TITULO
     $pdf->Cell(/*1*/40, /*2*/1, /*3*/'CONTABILIZADO POR:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
     $pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA DATO
     $pdf->Cell(/*1*/50, /*2*/1, /*3*/'', /*4*/'B', /*5*/1, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    
     //INFORMACION LINEA 2   
     $pdf->Ln(8);
     $pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA TITULO
     $pdf->Cell(/*1*/40, /*2*/1, /*3*/'VERIFICADO POR:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
     $pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA DATO
     $pdf->Cell(/*1*/45, /*2*/1, /*3*/'', /*4*/'B', /*5*/0, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
     
           //SEPARADOR, PARA QUE LA INFORMACION SALGA EN EL RECUADRO DE LA DERECHA
    $pdf->Cell(/*1*/8, /*2*/1, /*3*/'', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

     $pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA TITULO
     $pdf->Cell(/*1*/40, /*2*/1, /*3*/'VO. BO. AUDITOR:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
     $pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA DATO
     $pdf->Cell(/*1*/50, /*2*/1, /*3*/'', /*4*/'B', /*5*/0, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

$pdf->Output('RECAUDACIONES A DEPOSITAR.pdf', 'I');
?>