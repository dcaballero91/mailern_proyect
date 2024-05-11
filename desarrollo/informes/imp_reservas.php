<?php
require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";

$id = $_GET["id"];
$con = new conexion();
$con->conectar();

$det = array();
$sql1 = ("select * from v_reservas_cab where reser_cod = ".$id." order by 1");
$result1 = pg_query($sql1);
$cab = pg_fetch_array($result1);

$sql2 = ("select * from v_reservas_det where reser_cod = ".$id." ");
$result2 = pg_query($sql2);
while ($row = pg_fetch_array($result2)) {
    $det[] = $row;
}

$sql3 = pg_query("SELECT MIN(reser_hdesde) AS hora_desde FROM  reservas_det WHERE reser_cod = ".$id." ");
$respuesta = pg_fetch_assoc($sql3);
$horaDesde =  $respuesta['hora_desde'];


$sql4 = pg_query("SELECT MAX(reser_hhasta) AS hora_hasta FROM  reservas_det WHERE reser_cod = ".$id." ");
$respuesta2 = pg_fetch_assoc($sql4);
$horaHasta =  $respuesta2['hora_hasta'];

$sql5 = pg_query("SELECT fecha_reser AS fecha_reser FROM  reservas_det WHERE reser_cod = ".$id." ");
$respuesta3 = pg_fetch_assoc($sql5);
$fechaDetalle =  $respuesta3['fecha_reser'];

// MultiCell($w, $h, $txt, $border=0, $align='J', $fill=0, $ln=1, $x='', $y='', $reseth=true, $stretch=0, $ishtml=false, $autopadding=true, $maxh=0)
//Cell($w, $h=0, $txt='', $border=0, $ln=0, $align='', $fill=0, $link='', $stretch=0, $ignore_min_height=false, $calign='T', $valign='M')

//$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function presupuestos_cliente($cab,$det, $fechaDetalle, $horaDesde, $horaHasta)
    {
        // Nombre de la empresa y movimiento al que corresponde
        $this->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
        $this->Cell(/*1*/90, /*2*/10, /*3*/$cab['emp_nom'], /*4*/'LTR', /*5*/0, /*6*/'C');
        $this->Cell(/*1*/90, /*2*/10, /*3*/'RESERVAS DE TURNOS', /*4*/'LTR', /*5*/0, /*6*/'C');
        $this->Ln();
        
        // DIRECCION Y RUC DE LA EMPRESA
        $this->SetFont('Times', '', 10);//TIPO DE LETRA PARA SUBTITULO
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode(' Dirección: '.$cab['emp_dir'].''), /*4*/'L', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode(' RUC: '.$cab['emp_ruc'].''), /*4*/'LR', /*5*/0, /*6*/'L');
        $this->Ln();

        // TELEFONO Y NUMERO DE LA RESERVA
        $this->SetFont('Times', '', 10);//TIPO DE LETRA PARA SUBTITULO
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode(' Teléfono: '.$cab['emp_tel'].''), /*4*/'L', /*5*/0, /*6*/'L');  
            
        $this->Cell(/*1*/90, /*2*/5, /*3*/utf8_decode(' Reserva N.°: '.$cab['reser_cod'].''), /*4*/'LR', /*5*/0, /*6*/'L');
        $this->Ln();

        //CUARTA LINEA
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode(' Correo: '.$cab['emp_email'].''), /*4*/'LBR', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/90, /*2*/8, /*3*/'', /*4*/'RB', /*5*/0, /*6*/'L');
        $this->Ln();
        
        //FECHA DE EMISION Y ESTADO
        $this->Cell(/*1*/180, /*2*/8, /*3*/utf8_decode('Fecha de Emisión: '.$cab['fecha_reser_ope'].''), /*4*/'LBR', /*5*/0, /*6*/'L');
        $this->Ln();

        // NOMBRE O RAZON SOCIAL Y RUC DEL PROVEEDOR
        $this->SetFont('Times', 'B', 10);
        $this->Cell(/*1*/180, /*2*/6, /*3*/utf8_decode('1. DATOS DEL CLIENTE'), /*4*/'LR', /*5*/0, /*6*/'L');
        $this->SetFont('Times', '', 10);
        $this->Ln();
        $this->Cell(/*1*/40, /*2*/6, /*3*/utf8_decode('Nombre o Razón Social:'), /*4*/'L', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/140, /*2*/6, /*3*/utf8_decode($cab['cli_nom']), /*4*/'R', /*5*/0, /*6*/'L');
        $this->Ln();

        $this->Cell(/*1*/20, /*2*/6, /*3*/utf8_decode('RUC:'), /*4*/'LB', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/70, /*2*/6, /*3*/utf8_decode($cab['cli_ruc']), /*4*/'B', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/90, /*2*/6, /*3*/'', /*4*/'RB', /*5*/0, /*6*/'L');
        $this->Ln();

        //HORA DESDE HASTA DE LA RESERVAS
        $this->SetFont('Times', 'B', 10);
        $this->Cell(/*1*/180, /*2*/8, /*3*/utf8_decode('2. HORAS RESERVADAS'), /*4*/'LR', /*5*/0, /*6*/'L');
        $this->SetFont('Times', '', 10);
        $this->Ln();
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('Fecha desde: '.$fechaDetalle.' '.$horaDesde.''), /*4*/'L', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/90, /*2*/8, /*3*/utf8_decode('Fecha hasta: '.$fechaDetalle.' '.$horaHasta.''), /*4*/'R', /*5*/0, /*6*/'L');
        $this->Ln();
            
        //FUNCIONARIOS ASIGNADOS
        $this->SetFont('Times', 'B', 10);
        $this->Cell(/*1*/180, /*2*/10, /*3*/utf8_decode('3. FUNCIONARIOS ASIGNADOS'), /*4*/'LTR', /*5*/0, /*6*/'L');
        $this->SetFont('Times', '', 10);
        $this->Ln();

        $headerFun = array('Código', 'Funcionario', 'Hora desde', 'Hora hasta');
        $this->Cell(15,10,utf8_decode($headerFun[0]),1);
        $this->Cell(115,10,utf8_decode($headerFun[1]),1);
        $this->Cell(25,10,$headerFun[2],1);
        $this->Cell(25,10,$headerFun[3],1);
        $this->Ln();

        foreach ($det as $row) {
            $this->Cell(/*1*/15, /*2*/6, /*3*/utf8_decode($row['item_cod']), /*4*/1, /*5*/0, /*6*/'C');
                $this->SetFont('Times', '', 8);//TIPO DE LETRA PARA SUBTITULO
            $this->Cell(/*1*/115, /*2*/6, /*3*/utf8_decode($row['fun_nombre']), /*4*/1, /*5*/0, /*6*/'L');
                $this->SetFont('Times', '', 10);//TIPO DE LETRA PARA SUBTITULO
            $this->Cell(/*1*/25, /*2*/6, /*3*/$row["reser_hdesde"], /*4*/1, /*5*/0, /*6*/'R');
            $this->Cell(/*1*/25, /*2*/6, /*3*/$row["reser_hhasta"], /*4*/1, /*5*/1, /*6*/'R');
        }

        // DETALLES DE LA ORDEN DE COMPRA - Titulo
        $this->SetFont('Times', 'B', 10);
        $this->Cell(/*1*/180, /*2*/10, /*3*/utf8_decode('4. SERVICIOS RESERVADOS'), /*4*/'LTR', /*5*/0, /*6*/'L');
        $this->SetFont('Times', '', 10);
        $this->Ln();
        $header = array('Código','Descripción','Precio','Subtotal');
        // Cabecera
        $this->Cell(15,10,utf8_decode($header[0]),1);
        $this->Cell(115,10,utf8_decode($header[1]),1);
        $this->Cell(25,10,$header[2],1);
        $this->Cell(25,10,$header[3],1);
        $this->Ln();
        // Datos
        $total = 0;
        foreach($det as $row)
        {
            $subtotal = $row["reser_precio"];
            $total = $total + $subtotal;
            $this->Cell(/*1*/15, /*2*/6, /*3*/utf8_decode($row['item_cod']), /*4*/1, /*5*/0, /*6*/'C');
                $this->SetFont('Times', '', 8);//TIPO DE LETRA PARA SUBTITULO
            $this->Cell(/*1*/115, /*2*/6, /*3*/utf8_decode($row['item_desc']), /*4*/1, /*5*/0, /*6*/'L');
                $this->SetFont('Times', '', 10);//TIPO DE LETRA PARA SUBTITULO
            $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($row["reser_precio"],0,',','.'), /*4*/1, /*5*/0, /*6*/'R');
            $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($subtotal,0,',','.'), /*4*/1, /*5*/1, /*6*/'R');

        }
        $this->Cell(155,6,'Totales',1);
        $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($total,0,',','.'), /*4*/1, /*5*/1, /*6*/'R');
        $this->Ln();
    }
}
$pdf = new PDF();
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->presupuestos_cliente($cab,$det, $fechaDetalle, $horaDesde, $horaHasta);
$pdf->Output();
?>

