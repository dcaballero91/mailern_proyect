<?php

require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$rows = array();
$sql = ("select * from apertura_cierre order by 1");
$result = pg_query($sql);
while ($row = pg_fetch_array($result)) {
    $rows[] = $row;
}
$datos = $rows;
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function apertura_cierre($datos)
    {
        $this->Image('../img/INFORMES.JPG',60,11,80,25,'JPG');
        $this->Cell(165,30,"");
        $this->Ln();
        $this->Cell(165,10,"REPORTE DE APERTURA CIERRE");
        $this->Ln();
        //Titulo
        $header = array('Apertura Nro','Funcionario','Fecha Apertura','Monto Apertura','Fecha Cierre','Monto Cierre');
        // Cabecera
        $this->Cell(23,7,$header[0],1);
        $this->Cell(30,7,$header[1],1);
        $this->Cell(35,7,$header[2],1);
        $this->Cell(45,7,$header[3],1);
        $this->Cell(25,7,$header[4],1);
         $this->Cell(30,7,$header[4],1);
        $this->Ln();
        // Datos
        foreach($datos as $row)
        {
            $this->Cell(23,6,$row["aper_nro"],1);
            $this->Cell(30,6,$row["caja_cod"],1);
            $this->Cell(35,6,$row["aper_fecha"],1);
            $this->Cell(45,6,$row["aper_monto"],1);
            $this->Cell(25,6,$row["cier_fecha"],1);
            $this->Cell(30,6,$row["cier_monto"],1);
            $this->Ln();
        }
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->apertura_cierre($datos);
$pdf->Output();
?>
