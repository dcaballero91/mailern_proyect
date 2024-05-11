<?php
require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";

$id = $_GET["id"];
$con = new conexion();
$con->conectar();

$det = array();
$sql1 = (" SELECT * FROM v_agendas_cab WHERE agen_cod = '$id' ORDER BY agen_cod ");
$result1 = pg_query($sql1);
$cab = pg_fetch_array($result1);
$sql2 = (" SELECT * FROM v_agendas_det WHERE agen_cod = '$id' ORDER BY dias_cod");
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
        $this->Cell(/*1*/90, /*2*/10, /*3*/'AGENDAS DEL FUNCIONARIO', /*4*/'LTR', /*5*/0, /*6*/'C');
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
            
        $this->Cell(/*1*/35, /*2*/5, /*3*/utf8_decode('Agenda N.°: '), /*4*/'L', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/5, /*3*/utf8_decode($cab['agen_cod']), /*4*/'R', /*5*/0, /*6*/'L');
        $this->Ln();

        //CUARTA LINEA
        $this->Cell(/*1*/35, /*2*/8, /*3*/utf8_decode('Correo: '), /*4*/'LB', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/8, /*3*/utf8_decode($cab['emp_email']), /*4*/'RB', /*5*/0, /*6*/'L');

        $this->Cell(/*1*/90, /*2*/8, /*3*/'', /*4*/'RB', /*5*/0, /*6*/'L');
        $this->Ln();
        
        //FECHA DE EMISION Y ESTADO
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('Fecha de Operacion:  '.$cab['agen_fecha'].''), /*4*/'LB', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('Estado de la agenda:  '.$cab['agen_estado'].''), /*4*/'BR', /*5*/0, /*6*/'L');
        $this->Ln();
        
        // NOMBRE Y APELLIDO
        $this->Cell(/*1*/180, /*2*/8, /*3*/utf8_decode('Nombre y Apellido:  '.$cab['fun_nom'].''), /*4*/'LR', /*5*/0, /*6*/'L');
        $this->Ln();
        // NUMERO DE CI DEL FUNCIONARIO
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('C.I:  '.$cab['fun_ci'].''), /*4*/'LB', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('Estado:  '.$cab['fun_estado'].''), /*4*/'BR', /*5*/0, /*6*/'L');
        $this->Ln();

        // DETALLES DE LA ORDEN DE COMPRA - Titulo
        $header = array('Código','Día','Hora desde','Hora hasta');
        // Cabecera
        $this->Cell(40,10,utf8_decode($header[0]),1);
        $this->Cell(40,10,utf8_decode($header[1]),1);
        $this->Cell(50,10,utf8_decode($header[2]),1);
        $this->Cell(50,10,$header[3],1);
        $this->Ln();
        // Datos
        $total = 0;
        foreach($det as $row)
        {
            $this->Cell(/*1*/40, /*2*/6, /*3*/utf8_decode($row['dias_cod']), /*4*/1, /*5*/0, /*6*/'C');
            $this->Cell(/*1*/40, /*2*/6, /*3*/utf8_decode($row['dias_desc']), /*4*/1, /*5*/0, /*6*/'C');
            $this->Cell(/*1*/50, /*2*/6, /*3*/utf8_decode($row['hora_desde']), /*4*/1, /*5*/0, /*6*/'C');
            $this->Cell(/*1*/50, /*2*/6, /*3*/utf8_decode($row["hora_hasta"]), /*4*/1, /*5*/0, /*6*/'C');
            $this->Ln();
        }
        // $this->Cell(180,10,utf8_decode('Observación: '),1);
        // $this->Ln();
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->presupuestos_cliente($cab,$det);
$pdf->Output();
?>

