<?php
require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";

$id = $_GET["id"];
$con = new conexion();
$con->conectar();

$det = array();
$sql1 = ("select * from v_promociones_cab where promo_cod = ".$id." order by 1");
$result1 = pg_query($sql1);
$cab = pg_fetch_array($result1);
$sql2 = ("select * from v_promociones_detalles where promo_cod = ".$id." ");
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
    function presupuestos_cliente($cab,$det)
    {
        // Nombre de la empresa y movimiento al que corresponde
        $this->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
        $this->Cell(/*1*/90, /*2*/10, /*3*/$cab['emp_nom'], /*4*/'LTR', /*5*/0, /*6*/'C');
        $this->Cell(/*1*/90, /*2*/10, /*3*/'COMBOS PROMOCIONALES', /*4*/'LTR', /*5*/0, /*6*/'C');
        $this->Ln();
        
        // DIRECCION Y RUC DE LA EMPRESA
        $this->SetFont('Times', '', 10);//TIPO DE LETRA PARA SUBTITULO
        $this->Cell(/*1*/35, /*2*/8, /*3*/utf8_decode('Dirección:'), /*4*/'L', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/8, /*3*/utf8_decode($cab['emp_dir']), /*4*/'R', /*5*/0, /*6*/'L');
            
        $this->Cell(/*1*/35, /*2*/5, /*3*/utf8_decode('RUC: '), /*4*/'L', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/5, /*3*/utf8_decode($cab['emp_ruc']), /*4*/'R', /*5*/0, /*6*/'L');
        $this->Ln();

        // TELEFONO Y NUMERO DE ORDEN
        $this->SetFont('Times', '', 10);//TIPO DE LETRA PARA SUBTITULO
        $this->Cell(/*1*/35, /*2*/8, /*3*/utf8_decode('Teléfono:'), /*4*/'L', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/8, /*3*/utf8_decode($cab['emp_tel']), /*4*/'R', /*5*/0, /*6*/'L');
            
        $this->Cell(/*1*/35, /*2*/5, /*3*/utf8_decode('Promoción N.°: '), /*4*/'L', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/5, /*3*/utf8_decode($cab['promo_cod']), /*4*/'R', /*5*/0, /*6*/'L');
        $this->Ln();

        //CUARTA LINEA
        $this->Cell(/*1*/35, /*2*/8, /*3*/utf8_decode('Correo: '), /*4*/'LB', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/8, /*3*/utf8_decode($cab['emp_email']), /*4*/'RB', /*5*/0, /*6*/'L');

        $this->Cell(/*1*/90, /*2*/8, /*3*/'', /*4*/'RB', /*5*/0, /*6*/'L');
        $this->Ln();
        
        //FECHA DE EMISION Y ESTADO
        $this->Cell(/*1*/180, /*2*/8, /*3*/utf8_decode('Fecha de registro: '.$cab['promo_dfecha'].''), /*4*/'LBR', /*5*/0, /*6*/'L');
        $this->Ln();

        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('Fecha inicio: '.$cab['promo_feinicio'].''), /*4*/'LB', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('Fecha fin: ' .$cab['promo_fefin'].''), /*4*/'BR', /*5*/0, /*6*/'L');
        $this->Ln();
        

        // DETALLES DE LA PROMOCIONES - Titulo
        $header = array('Código','Descripción','Precio anterior','Descuento', 'Tipo descuento', 'Precio promo');
        // Cabecera
        $this->Cell(15,15,utf8_decode($header[0]),1);
        $this->Cell(65,15,utf8_decode($header[1]),1);
        $this->Cell(25,15,utf8_decode($header[2]),1);
        $this->Cell(25,15,$header[3],1);
        $this->Cell(25,15,$header[4],1);
        $this->Cell(25,15,$header[5],1);
        $this->Ln();
        // Datos
        $total = 0;
        foreach($det as $row)
        {
          $total = $total + $row['promo_precio'];
            $this->Cell(/*1*/15, /*2*/6, /*3*/utf8_decode($row['item_cod']), /*4*/1, /*5*/0, /*6*/'C');
                $this->SetFont('Times', '', 8);//TIPO DE LETRA PARA SUBTITULO
            $this->Cell(/*1*/65, /*2*/6, /*3*/utf8_decode($row['item_desc']), /*4*/1, /*5*/0, /*6*/'L');
                $this->SetFont('Times', '', 10);//TIPO DE LETRA PARA SUBTITULO
            $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($row["item_precio"],0,',','.'), /*4*/1, /*5*/0, /*6*/'R');
            $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($row['promo_desc'],0,',','.'), /*4*/1, /*5*/0, /*6*/'R');
            $this->Cell(/*1*/25, /*2*/6, /*3*/utf8_decode($row['tipo_desc']), /*4*/1, /*5*/0, /*6*/'C');
            $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($row['promo_precio'],0,',','.'), /*4*/1, /*5*/1, /*6*/'R');
        }
        $this->Cell(/*1*/155, /*2*/6, /*3*/'Total promo:', /*4*/1, /*5*/0, /*6*/'L');
        $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($total,0,',','.'), /*4*/1, /*5*/1, /*6*/'R');
        
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->presupuestos_cliente($cab,$det);
$pdf->Output();
?>