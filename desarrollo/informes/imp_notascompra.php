<?php

require "../funciones/fpdf/fpdf.php";

require "../clases/conexion.php";
$id = $_GET["id"];
$id2 = explode('/', $id);

$con = new conexion();
$con->conectar();

$det = array();
$sql1 = ("SELECT * from v_notas_compras_cab where nota_com_nro = ' $id2[0] ' and comp_cod = '$id2[1]' ");
$result1 = pg_query($sql1);
$cab = pg_fetch_array($result1);
$sql2 = ("SELECT * from v_notas_compras_det where nota_com_nro = ' $id2[0] ' and comp_cod = '$id2[1]' ");
$result2 = pg_query($sql2);
while ($row = pg_fetch_array($result2)) {
    $det[] = $row;
}
// MultiCell($w, $h, $txt, $border=0, $align='J', $fill=0, $ln=1, $x='', $y='', $reseth=true, $stretch=0, $ishtml=false, $autopadding=true, $maxh=0)
//Cell($w, $h=0, $txt='', $border=0, $ln=0, $align='', $fill=0, $link='', $stretch=0, $ignore_min_height=false, $calign='T', $valign='M')

$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function notascompras($cab,$det)
    {
        // Nombre de la empresa y movimiento al que corresponde
        $this->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
        $this->Cell(/*1*/90, /*2*/10, /*3*/$cab['emp_nom'], /*4*/'LTR', /*5*/0, /*6*/'C');
        $this->Cell(/*1*/90, /*2*/10, /*3*/utf8_decode('NOTA DE '.$cab['nota_com_tipo']. ''), /*4*/'LTR', /*5*/0, /*6*/'C');
        $this->Ln();
        
        // DIRECCION Y RUC DE LA EMPRESA
        $this->SetFont('Times', '', 10);//TIPO DE LETRA PARA SUBTITULO
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('Dirección: '.$cab['emp_dir'].''), /*4*/'L', /*5*/0, /*6*/'L');
            
        $this->Cell(/*1*/90, /*2*/5, /*3*/utf8_decode('RUC:  '.$cab['emp_ruc'].''), /*4*/'LR', /*5*/0, /*6*/'L');
        $this->Ln();

        // TELEFONO Y NUMERO DE ORDEN
        $this->SetFont('Times', '', 10);//TIPO DE LETRA PARA SUBTITULO
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('Teléfono:  '.$cab['emp_tel'].''), /*4*/'LR', /*5*/0, /*6*/'L');

        $this->Cell(/*1*/90, /*2*/5, /*3*/utf8_decode('Nota N.°:  '.$cab['nota_com_nro'].''), /*4*/'LR', /*5*/0, /*6*/'L');
        $this->Ln();

        //CUARTA LINEA
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('Correo:  '.$cab['emp_email'].''), /*4*/'LBR', /*5*/0, /*6*/'L');

        $this->Cell(/*1*/90, /*2*/8, /*3*/'', /*4*/'RB', /*5*/0, /*6*/'L');
        $this->Ln();
        
        //FECHA DE EMISION Y ESTADO
        $this->Cell(/*1*/35, /*2*/8, /*3*/utf8_decode('Fecha de Emisión:'), /*4*/'LB', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/8, /*3*/utf8_decode($cab['nota_com_fecha']), /*4*/'B', /*5*/0, /*6*/'L');

        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('Estado:  '.$cab['nota_com_estado'].''), /*4*/'BR', /*5*/0, /*6*/'L');
        $this->Ln();
        
        // NOMBRE O RAZON SOCIAL Y RUC DEL PROVEEDOR
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('Nombre o Razón Social:  '.$cab['prov_nombre']. ''), /*4*/'L', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('RUC: '.$cab['prov_ruc'].''), /*4*/'R', /*5*/0, /*6*/'L');
        $this->Ln();
        
        // TIMBRADO Y NUMERO DE FACTURA
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('Timbrado: '.$cab['nota_com_timbrado']. ''), /*4*/'L', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('Factura N.°: '.$cab['nota_com_factura'].''), /*4*/'R', /*5*/0, /*6*/'L');
        $this->Ln();
        
        if($cab['nota_com_tipo'] == 'CREDITO' && $cab['nota_cred_motivo'] == 'DEVOLUCION'){

            // DETALLES DE LA ORDEN DE COMPRA - Titulo
            $header = array('Codigo','Cantidad','Descripción','Precio','Subtotal');
            // Cabecera
            $this->Cell(15,15,$header[0],1);
            $this->Cell(15,15,$header[1],1);
            $this->Cell(100,15,utf8_decode($header[2]),1);
            $this->Cell(25,15,$header[3],1);
            $this->Cell(25,15,$header[4],1);
            $this->Ln();
            // Datos
            $total = 0;
            foreach($det as $row)
            {
                $subtotal = $row["nota_com_cant"] * $row["nota_com_precio"];
                $total = $total + $subtotal;
                $this->Cell(/*1*/15, /*2*/6, /*3*/utf8_decode($row['item_cod']), /*4*/1, /*5*/0, /*6*/'C');
                $this->Cell(/*1*/15, /*2*/6, /*3*/utf8_decode($row['nota_com_cant']), /*4*/1, /*5*/0, /*6*/'R');
                    $this->SetFont('Times', '', 8);//TIPO DE LETRA PARA SUBTITULO
                $this->Cell(/*1*/100, /*2*/6, /*3*/utf8_decode($row['item_desc']), /*4*/1, /*5*/0, /*6*/'L');
                    $this->SetFont('Times', '', 10);//TIPO DE LETRA PARA SUBTITULO
                $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($row["nota_com_precio"],0,',','.'), /*4*/1, /*5*/0, /*6*/'R');
                $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($subtotal,0,',','.'), /*4*/1, /*5*/1, /*6*/'R');
    
            }
            $this->Cell(155,6,'Totales',1);
            $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($total,0,',','.'), /*4*/1, /*5*/1, /*6*/'R');
            $this->Ln();
        }else if($cab['nota_com_tipo'] == 'DEBITO'){
            $this->Cell(/*1*/180, /*2*/8, /*3*/utf8_decode('Monto: '.$cab['nota_monto']. ''), /*4*/'LTRB', /*5*/1, /*6*/'L');
           // $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('Factura N.°: '.$cab['nota_com_factura'].''), /*4*/'R', /*5*/0, /*6*/'L');
        }
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->notascompras($cab,$det);
$pdf->Output();
?>
