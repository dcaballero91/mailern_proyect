<?php

require "../funciones/fpdf/fpdf.php";

require "../clases/conexion.php";
$id = $_GET["id"];
// echo $id;
$id2 = explode('/',$id);
// $id2  = $id.str_split('/');
// print_r($id2);
$con = new conexion();
$con->conectar();

$det = array();
// prov_cod = '$id2[0]' and prov_timb_nro = '$id2[1]' 
$sql1 = ("select * from v_compras_cab where nro_factura = '$id2[2]' and prov_cod = '$id2[0]' and prov_timb_nro = '$id2[1]'  ");
$result1 = pg_query($sql1);
$cab = pg_fetch_array($result1);
$sql2 = ("select * from v_compras_det where nro_factura = '$id2[2]' and prov_cod = '$id2[0]' and prov_timb_nro = '$id2[1]'  ");
$result2 = pg_query($sql2);
while ($row = pg_fetch_array($result2)) {
    $det[] = $row;
}

$sql3 = pg_query("SELECT prov_tim_vighasta FROM proveedor_timbrados WHERE prov_timb_nro = ".$id2[1]." ");
$timHasta = pg_fetch_assoc($sql3);
$timVig = $timHasta['prov_tim_vighasta'];

$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function compras($cab, $det, $timVig)
    {
        // Nombre de la empresa y movimiento al que corresponde
        $this->SetFont('Times', 'B', 12);
        $this->Cell(/*1*/90, /*2*/10, /*3*/$cab['emp_nom'], /*4*/'LTR', /*5*/0, /*6*/'C');

        $this->Cell(/*1*/90, /*2*/10, /*3*/'INFORME DE COMPRAS', /*4*/'LTR', /*5*/0, /*6*/'C');
        $this->SetFont('Times', '', 10);
        $this->Ln();
        
        // DIRECCION Y FECHA INICION DE VIGENCIA
        $this->Cell(/*1*/90, /*2*/6, /*3*/utf8_decode(" Dirección:  ".$cab['emp_dir']." "), /*4*/'L', /*5*/0, /*6*/'L');  
        $this->Cell(/*1*/90, /*2*/4, /*3*/utf8_decode('Timbrado N.°: '.$cab['prov_timb_nro'].'') , /*4*/'LR', /*5*/0, /*6*/'C');
        $this->Ln();

        // TELEFONO Y FECHA FIN DE VIGENCIA
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode(" Teléfono:  ".$cab['emp_tel']." "), /*4*/'L', /*5*/0, /*6*/'L'); 
        $this->Cell(/*1*/90, /*2*/6, /*3*/utf8_decode('Fecha Fin Vigencia: '.$timVig.'') , /*4*/'LR', /*5*/0, /*6*/'C');
        $this->Ln();

        //CORREO Y RUC 
        $this->Cell(/*1*/90, /*2*/6, /*3*/utf8_decode(" Correo:  ".$cab['emp_email']." "), /*4*/'LR', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/90, /*2*/6, /*3*/"RUC: ".$cab['prov_ruc']." "  , /*4*/'R', /*5*/0, /*6*/'C');
        $this->Ln();
        
        // NOTA DE REMISION
        $this->Cell(/*1*/90, /*2*/6, /*3*/' RUC:  '.$cab['emp_ruc'].'', /*4*/'LR', /*5*/0, /*6*/'L');
        $this->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
        $this->Cell(/*1*/90, /*2*/6, /*3*/utf8_decode('FACTURA'), /*4*/'LR', /*5*/0, /*6*/'C');
        $this->SetFont('Times', '', 10);//TIPO DE LETRA PARA SUBTITULO
        $this->Ln();

        // NUMERO DE REMISION
        $this->Cell(/*1*/90, /*2*/6, /*3*/'', /*4*/'LBR', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/90, /*2*/6, /*3*/utf8_decode($cab['nro_factura']), /*4*/'LBR', /*5*/0, /*6*/'C');
        $this->Ln();

        //FECHA DE EMISION Y CONDICION DE VENTA
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode("  Fecha de la Factura: ".$cab['comp_fecha_factura']." "), /*4*/'LBR', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode("  Condición de Compra: ".$cab['tipo_fact_desc'].""), /*4*/'LBR', /*5*/0, /*6*/'L');
        $this->Ln();

        //DATOS DEL CLIENTE      
        $this->Cell(/*1*/90, /*2*/6, /*3*/utf8_decode("  Nombre o Razón Social: ".$cab['prov_nombre'].""), /*4*/'L', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/90, /*2*/6, /*3*/utf8_decode("  RUC o C.I: ".$cab['prov_ruc'].""), /*4*/'R', /*5*/0, /*6*/'L');
        $this->Ln();
        $this->Cell(/*1*/180, /*2*/6, /*3*/utf8_decode("  Domicilio: ".$cab['prov_dir'].""), /*4*/'LBR', /*5*/0, /*6*/'L'); //ver dir para que sea dinamico
        $this->Ln();

        $header = array('Cant.','Descripción','Prec. Uni.', 'Exenta', '5%', '10%');
        // Cabecera
        $this->Cell(10,10,$header[0],1);
        $this->Cell(95,10,utf8_decode($header[1]),1);
        $this->Cell(15,10,utf8_decode($header[2]),1);
        $this->Cell(20,10,$header[3],1);
        $this->Cell(20,10,$header[4],1);
        $this->Cell(20,10,$header[5],1);
        $this->Ln();
        // Datos
        $totalGeneral = 0;

        $exenta = 0;
        $iva5 = 0;
        $iva10 = 0 ;
        
        foreach($det as $row)
        {
            $subtotal = $row['comp_precio'] * $row['comp_cantidad'];
            $totalGeneral = $totalGeneral + $subtotal;
            $this->Cell(/*1*/10, /*2*/6, /*3*/utf8_decode($row['comp_cantidad']), /*4*/1, /*5*/0, /*6*/'C');
                $this->SetFont('Times', '', 8);
            $this->Cell(/*1*/95, /*2*/6, /*3*/utf8_decode($row['item_desc'].' '.$row['mar_desc']), /*4*/1, /*5*/0, /*6*/'L');
              //  $this->SetFont('Times', '', 10);
            $this->Cell(/*1*/15, /*2*/6, /*3*/number_format($row["comp_precio"],0,',','.'), /*4*/1, /*5*/0, /*6*/'R');
            
            if($row['tipo_imp_cod'] == '1'){
                $iva10 = $iva10 + $subtotal;
                $this->Cell(/*1*/20, /*2*/6, /*3*/utf8_decode(" "), /*4*/'LBR', /*5*/0, /*6*/'R'); 
                $this->Cell(/*1*/20, /*2*/6, /*3*/utf8_decode("  "), /*4*/'LBR', /*5*/0, /*6*/'R'); 
                $this->Cell(/*1*/20, /*2*/6, /*3*/number_format($subtotal,0,',','.'), /*4*/'LBR', /*5*/1, /*6*/'R'); 
            }elseif ($row['tipo_imp_cod'] == '2') {
                $iva5 = $iva5 + $subtotal;
                $this->Cell(/*1*/20, /*2*/6, /*3*/utf8_decode(" "), /*4*/'LBR', /*5*/0, /*6*/'R'); 
                $this->Cell(/*1*/20, /*2*/6, /*3*/number_format($subtotal,0,',','.'), /*4*/'LBR', /*5*/0, /*6*/'R'); 
                $this->Cell(/*1*/20, /*2*/6, /*3*/utf8_decode("  "), /*4*/'LBR', /*5*/1, /*6*/'R'); 
            }elseif ($row['tipo_imp_cod'] == '3') {
                $exenta = $exenta + $subtotal;
                $this->Cell(/*1*/20, /*2*/6, /*3*/number_format($subtotal,0,',','.'), /*4*/'LBR', /*5*/0, /*6*/'R'); 
                $this->Cell(/*1*/20, /*2*/6, /*3*/utf8_decode("  "), /*4*/'LBR', /*5*/0, /*6*/'R'); 
                $this->Cell(/*1*/20, /*2*/6, /*3*/utf8_decode("  "), /*4*/'LBR', /*5*/1, /*6*/'R'); 
            }
        }

        //SUBTOTALES
        $this->SetFont('Times', '', 10);
        $this->Cell(/*1*/120, /*2*/6, /*3*/utf8_decode("  Subtotales:"), /*4*/'LBR', /*5*/0, /*6*/'L'); 
        $this->SetFont('Times', '', 8);
        $this->Cell(/*1*/20, /*2*/6, /*3*/number_format($exenta,0,',','.'), /*4*/'LBR', /*5*/0, /*6*/'R'); 
        $this->Cell(/*1*/20, /*2*/6, /*3*/number_format($iva5,0,',','.'), /*4*/'LBR', /*5*/0, /*6*/'R'); 
        $this->Cell(/*1*/20, /*2*/6, /*3*/number_format($iva10,0,',','.'), /*4*/'LBR', /*5*/0, /*6*/'R'); 
        $this->Ln();

        //LIQUIDACION DE IVA
        $this->SetFont('Times', '', 10);
        $this->Cell(/*1*/120, /*2*/6, /*3*/utf8_decode("  Liquidación de IVA:"), /*4*/'LBR', /*5*/0, /*6*/'L'); 
        $this->SetFont('Times', '', 8);

        $this->Cell(/*1*/20, /*2*/6, /*3*/number_format($exenta,0,',','.'), /*4*/'LBR', /*5*/0, /*6*/'R'); 
        $this->Cell(/*1*/20, /*2*/6, /*3*/number_format(($iva5/21),0,',','.'), /*4*/'LBR', /*5*/0, /*6*/'R'); 
        $this->Cell(/*1*/20, /*2*/6, /*3*/number_format(($iva10/11),0,',','.'), /*4*/'LBR', /*5*/0, /*6*/'R'); 
        $this->Ln();

        //TOTAL DE IVA
        $totalIVA = ($iva10/11) + ($iva5/21);
        $this->SetFont('Times', '', 10);
        $this->Cell(/*1*/135, /*2*/6, /*3*/utf8_decode("  Total de IVA:"), /*4*/'LB', /*5*/0, /*6*/'L'); 
        $this->Cell(/*1*/15, /*2*/6, /*3*/utf8_decode("  "), /*4*/'B', /*5*/0, /*6*/'R'); 
        $this->Cell(/*1*/15, /*2*/6, /*3*/utf8_decode("  "), /*4*/'B', /*5*/0, /*6*/'R'); 
        $this->Cell(/*1*/15, /*2*/6, /*3*/number_format($totalIVA,0,',','.'), /*4*/'BR', /*5*/0, /*6*/'R'); 
        $this->Ln();

        //TOTAL GENERAL
        $this->SetFont('Times', '', 10);
        $this->Cell(/*1*/135, /*2*/6, /*3*/utf8_decode("  Total General:"), /*4*/'LB', /*5*/0, /*6*/'L'); 
        $this->Cell(/*1*/15, /*2*/6, /*3*/utf8_decode("  "), /*4*/'B', /*5*/0, /*6*/'R'); 
        $this->Cell(/*1*/15, /*2*/6, /*3*/utf8_decode("  "), /*4*/'B', /*5*/0, /*6*/'R'); 
        $this->Cell(/*1*/15, /*2*/6, /*3*/number_format($totalGeneral,0,',','.'), /*4*/'BR', /*5*/0, /*6*/'R'); 
        $this->Ln();

        // DATOS DE LA IMPRENTA
        $this->SetFont('Times', '', 7);
        $this->Cell(/*1*/180, /*2*/6, /*3*/utf8_decode("  Control Interno "), /*4*/'LRB', /*5*/0, /*6*/'L');
        $this->Ln(3);
        
        // $this->SetFont('Times', '', 7);
        // $this->Cell(/*1*/90, /*2*/4, /*3*/utf8_decode("  Habilitacion N.°: 5487 "), /*4*/'LR', /*5*/0, /*6*/'L');
        // $this->Cell(/*1*/90, /*2*/4, /*3*/utf8_decode("  Original:  Comprador"), /*4*/'R', /*5*/0, /*6*/'L');
        // $this->Ln(3);
        // $this->Cell(/*1*/90, /*2*/4, /*3*/utf8_decode("  Copimax Impresiones S.A "), /*4*/'LR', /*5*/0, /*6*/'L');
        // $this->Cell(/*1*/90, /*2*/4, /*3*/utf8_decode("  Copia:  Archivo"), /*4*/'R', /*5*/0, /*6*/'L');
        // $this->Ln(3);
        // $this->Cell(/*1*/90, /*2*/4, /*3*/utf8_decode("  Estados Unidos 987 esq. Pa'i Perez "), /*4*/'LRB', /*5*/0, /*6*/'L');
        // $this->Cell(/*1*/90, /*2*/4, /*3*/utf8_decode("  "), /*4*/'RB', /*5*/0, /*6*/'L');
        // $this->Ln(0);


    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->compras($cab,$det,$timVig);
$pdf->Output();
?>