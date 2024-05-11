<?php
require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";

$id = $_GET["id"];
$con = new conexion();
$con->conectar();

$det = array();
$sql1 = ("select * from v_ordenes_compras_cab where orden_nro = ".$id." order by 1");
$result1 = pg_query($sql1);
$cab = pg_fetch_array($result1);
$sql2 = ("select * from v_ordenes_compras_det where orden_nro = ".$id." ");
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
    function ordencompras($cab,$det)
    {
        // Nombre de la empresa y movimiento al que corresponde
        $this->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
        $this->Cell(/*1*/90, /*2*/10, /*3*/$cab['emp_nom'], /*4*/'LTR', /*5*/0, /*6*/'C');
        $this->Cell(/*1*/90, /*2*/10, /*3*/'ORDEN DE COMPRA', /*4*/'LTR', /*5*/0, /*6*/'C');
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
            
        $this->Cell(/*1*/35, /*2*/5, /*3*/utf8_decode('Orden N.°: '), /*4*/'L', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/5, /*3*/utf8_decode($cab['orden_nro']), /*4*/'R', /*5*/0, /*6*/'L');
        $this->Ln();

        //CUARTA LINEA
        $this->Cell(/*1*/35, /*2*/8, /*3*/utf8_decode('Correo: '), /*4*/'LB', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/8, /*3*/utf8_decode($cab['emp_email']), /*4*/'RB', /*5*/0, /*6*/'L');

        $this->Cell(/*1*/90, /*2*/8, /*3*/'', /*4*/'RB', /*5*/0, /*6*/'L');
        $this->Ln();
        
        //FECHA DE EMISION Y ESTADO
        $this->Cell(/*1*/35, /*2*/8, /*3*/utf8_decode('Fecha de Emisión:'), /*4*/'LB', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/8, /*3*/utf8_decode($cab['orden_fecha']), /*4*/'B', /*5*/0, /*6*/'L');

        $this->Cell(/*1*/35, /*2*/8, /*3*/utf8_decode('Estado:'), /*4*/'B', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/8, /*3*/utf8_decode($cab['orden_estado']), /*4*/'BR', /*5*/0, /*6*/'L');
        $this->Ln();

        // TIPO FACTURA, CUOTAS Y PLAZOS
        $this->Cell(/*1*/35, /*2*/8, /*3*/utf8_decode('Tipo de Factura:'), /*4*/'LB', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/8, /*3*/utf8_decode($cab['tipo_fact_desc']), /*4*/'B', /*5*/0, /*6*/'L');

        $this->Cell(/*1*/20, /*2*/8, /*3*/utf8_decode('Cuotas:'), /*4*/'B', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/10, /*2*/8, /*3*/utf8_decode($cab['orden_cuotas']), /*4*/'B', /*5*/0, /*6*/'L');
        
        $this->Cell(/*1*/20, /*2*/8, /*3*/utf8_decode('Plazo:'), /*4*/'B', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/10, /*2*/8, /*3*/utf8_decode($cab['orden_plazo']), /*4*/'B', /*5*/0, /*6*/'L');
        
        $this->Cell(/*1*/30, /*2*/8, /*3*/'', /*4*/'RB', /*5*/0, /*6*/'L');
        $this->Ln();
        
        // NOMBRE O RAZON SOCIAL Y RUC DEL PROVEEDOR
        $this->Cell(/*1*/40, /*2*/8, /*3*/utf8_decode('Nombre o Razón Social:'), /*4*/'L', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/140, /*2*/8, /*3*/utf8_decode($cab['prov_nombre']), /*4*/'R', /*5*/0, /*6*/'L');
        $this->Ln();

        $this->Cell(/*1*/20, /*2*/8, /*3*/utf8_decode('RUC:'), /*4*/'LB', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/70, /*2*/8, /*3*/utf8_decode($cab['prov_ruc']), /*4*/'B', /*5*/0, /*6*/'L');
        
        $this->Cell(/*1*/90, /*2*/8, /*3*/'', /*4*/'RB', /*5*/0, /*6*/'L');
        $this->Ln();

        // DETALLES DE LA ORDEN DE COMPRA - Titulo
        $header = array('Codigo','Cantidad','Descripción');
        // Cabecera
        $this->Cell(15,15,$header[0],1);
        $this->Cell(15,15,$header[1],1);
        $this->Cell(150,15,utf8_decode($header[2]),1);
        // $this->Cell(25,15,$header[3],1);
        // $this->Cell(25,15,$header[4],1);
        $this->Ln();
        // Datos
        $total = 0;
        foreach($det as $row)
        {
            $subtotal = $row["orden_cantidad"] * $row["orden_precio"];
           // $total = $total + $subtotal;
            $this->Cell(/*1*/15, /*2*/6, /*3*/utf8_decode($row['item_cod']), /*4*/1, /*5*/0, /*6*/'C');
            $this->Cell(/*1*/15, /*2*/6, /*3*/utf8_decode($row['orden_cantidad']), /*4*/1, /*5*/0, /*6*/'R');
                $this->SetFont('Times', '', 8);//TIPO DE LETRA PARA SUBTITULO
            $this->Cell(/*1*/150, /*2*/6, /*3*/utf8_decode($row['item_desc']), /*4*/1, /*5*/1, /*6*/'LR');

            //     $this->SetFont('Times', '', 10);//TIPO DE LETRA PARA SUBTITULO
            // $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($row["orden_precio"],0,',','.'), /*4*/1, /*5*/0, /*6*/'R');
            // $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($subtotal,0,',','.'), /*4*/1, /*5*/1, /*6*/'R');

        }
        // $this->Cell(155,6,'Totales',1);
        // $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($total,0,',','.'), /*4*/1, /*5*/1, /*6*/'R');
        // $this->Ln();
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->ordencompras($cab,$det);
$pdf->Output();
?>
