<?php
require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";

$id = $_GET["id"];
$con = new conexion();
$con->conectar();

$det = array();
$sql1 = ("select * from v_presupuestos_cab where presu_cod = ".$id." order by 1");
$result1 = pg_query($sql1);
$cab = pg_fetch_array($result1);
$sql2 = ("select * from v_presupuestos_detalles where presu_cod = ".$id." ");
$result2 = pg_query($sql2);
while ($row = pg_fetch_array($result2)) {
    $det[] = $row;
}

$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function presupuestos_cliente($cab,$det)
    {
        // Nombre de la empresa y movimiento al que corresponde
        $this->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
        $this->Cell(/*1*/90, /*2*/10, /*3*/$cab['emp_nom'], /*4*/'LTR', /*5*/0, /*6*/'C');
        $this->Cell(/*1*/90, /*2*/10, /*3*/'PRESUPUESTOS AL CLIENTE', /*4*/'LTR', /*5*/0, /*6*/'C');
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
            
        $this->Cell(/*1*/35, /*2*/5, /*3*/utf8_decode('Presupuesto N.°: '), /*4*/'L', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/5, /*3*/utf8_decode($cab['presu_cod']), /*4*/'R', /*5*/0, /*6*/'L');
        $this->Ln();

        //CUARTA LINEA
        $this->Cell(/*1*/35, /*2*/8, /*3*/utf8_decode('Correo: '), /*4*/'LB', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/8, /*3*/utf8_decode($cab['emp_email']), /*4*/'RB', /*5*/0, /*6*/'L');

        $this->Cell(/*1*/90, /*2*/8, /*3*/'', /*4*/'RB', /*5*/0, /*6*/'L');
        $this->Ln();
        
        //FECHA DE EMISION Y ESTADO
        $this->Cell(/*1*/35, /*2*/8, /*3*/utf8_decode('Fecha de Emisión:'), /*4*/'LB', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/8, /*3*/utf8_decode($cab['presu_fecha']), /*4*/'B', /*5*/0, /*6*/'L');

        $this->Cell(/*1*/35, /*2*/8, /*3*/utf8_decode('Fecha Validez Hasta:'), /*4*/'B', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/55, /*2*/8, /*3*/utf8_decode($cab['presu_validez']), /*4*/'BR', /*5*/0, /*6*/'L');
        $this->Ln();
        
        // NOMBRE O RAZON SOCIAL Y RUC DEL PROVEEDOR
        $this->Cell(/*1*/40, /*2*/8, /*3*/utf8_decode('Nombre o Razón Social:'), /*4*/'L', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/140, /*2*/8, /*3*/utf8_decode($cab['cli_nom']), /*4*/'R', /*5*/0, /*6*/'L');
        $this->Ln();

        $this->Cell(/*1*/20, /*2*/8, /*3*/utf8_decode('RUC:'), /*4*/'LB', /*5*/0, /*6*/'L');
        $this->Cell(/*1*/70, /*2*/8, /*3*/utf8_decode($cab['cli_ruc']), /*4*/'B', /*5*/0, /*6*/'L');
        
        $this->Cell(/*1*/90, /*2*/8, /*3*/'', /*4*/'RB', /*5*/0, /*6*/'L');
        $this->Ln();

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
            $subtotal = $row["presu_cantidad"] * $row["presu_precio"];
            $total = $total + $subtotal;
            $this->Cell(/*1*/15, /*2*/6, /*3*/utf8_decode($row['item_cod']), /*4*/1, /*5*/0, /*6*/'C');
            $this->Cell(/*1*/15, /*2*/6, /*3*/utf8_decode($row['presu_cantidad']), /*4*/1, /*5*/0, /*6*/'R');
                $this->SetFont('Times', '', 8);//TIPO DE LETRA PARA SUBTITULO
            $this->Cell(/*1*/100, /*2*/6, /*3*/utf8_decode($row['item_desc']), /*4*/1, /*5*/0, /*6*/'L');
                $this->SetFont('Times', '', 10);//TIPO DE LETRA PARA SUBTITULO
            $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($row["presu_precio"],0,',','.'), /*4*/1, /*5*/0, /*6*/'R');
            $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($subtotal,0,',','.'), /*4*/1, /*5*/1, /*6*/'R');

        }
        $this->Cell(155,6,'Totales',1);
        $this->Cell(/*1*/25, /*2*/6, /*3*/number_format($total,0,',','.'), /*4*/1, /*5*/1, /*6*/'R');
        $this->Ln();
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->presupuestos_cliente($cab,$det);
$pdf->Output();
?>
