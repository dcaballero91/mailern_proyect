<?php

require "../funciones/fpdf/fpdf.php";
require "../clases/sesion.php";
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$rows = array();
$sql = ("select * from v_items where tipo_item_cod = 2 order by item_cod");
$result = pg_query($sql);
while ($row = pg_fetch_array($result)) {
    $rows[] = $row;
}
$datos = $rows;
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function items($datos)
    {
        $this->Image('../informes/img.png',20,15,150,40,'png');
        $this->Cell(165,30,"");
        $this->Ln();
        $this->Ln();
        $this->Cell(165,10,"REPORTE DE ITEMS DE SERVICIOS");
        $this->Ln();
       // $this->Ln();

        //Titulo
        $header = array('Cód',' Descripción','Tipo','Precio','Tipo impuesto','Estado');
        // Cabecera
        $this->Cell(10,7,utf8_decode($header[0]),1);
        $this->Cell(60,7,utf8_decode($header[1]),1);
        $this->Cell(30,7,utf8_decode($header[2]),1);
        $this->Cell(30,7,utf8_decode($header[3]),1);
        $this->Cell(30,7,utf8_decode($header[4]),1);
        $this->Cell(30,7,utf8_decode($header[5]),1);
       
        $this->Ln();
        // Datos
        foreach($datos as $row)
        {
            $this->Cell(10,6,utf8_decode($row["item_cod"]),1);
             $this->Cell(60,6,utf8_decode($row["item_desc"]),1);
             $this->Cell(30,6,utf8_decode($row["tipo_item_desc"]),1);
            $this->Cell(30,6,utf8_decode($row["item_precio"]),1);
            $this->Cell(30,6,utf8_decode($row["tipo_imp_desc"]),1);
            $this->Cell(30,6,utf8_decode($row["item_estado"]),1);
            $this->Ln();
            // $this->Cell(10,6,$row["imp_desc"]+'%',1);
        }
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->items($datos);
$pdf->Output();
?>
