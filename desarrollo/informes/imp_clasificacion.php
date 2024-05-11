<?php

require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$rows = array();
$sql = ("select * from clasificaciones order by 1");
$result = pg_query($sql);
while ($row = pg_fetch_array($result)) {
    $rows[] = $row;
}
$datos = $rows;
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function clasificacion($datos)
    {
        $this->Image('../informes/img.png',20,15,150,40,'png');
        $this->Cell(165,30,"");
        $this->Ln();
         $this->Ln();
        $this->Cell(165,10,"REPORTE DE CLASIFICACIONES");
        $this->Ln();
        //Titulo
        $header = array('Codigo','Descripcion',);
        // Cabecera
        $this->Cell(23,7,$header[0],1);
        $this->Cell(165,7,$header[1],1);
        $this->Ln();
        // Datos
        foreach($datos as $row)
        {
            $this->Cell(23,6,$row["cla_cod"],1);
            $this->Cell(165,6,$row["cla_desc"],1);
            $this->Ln();
        }
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->clasificacion($datos);
$pdf->Output();
?>




