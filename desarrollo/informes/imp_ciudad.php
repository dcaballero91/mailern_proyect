<?php

require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$rows = array();
$sql = ("select * from v_ciudades order by 1");
$result = pg_query($sql);
while ($row = pg_fetch_array($result)) {
    $rows[] = $row;
}
$datos = $rows;
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function ciudad($datos)
    {
       $this->Image('../informes/img.png',20,15,150,40,'png');
        $this->Cell(165,30,"");
        $this->Ln();
        $this->Ln();
        $this->Cell(165,10,"REPORTE DE CIUDADES");
        $this->Ln();
        //Titulo
        $header = array('Código','Descripción','País');
        // Cabecera
        $this->Cell(23,7,utf8_decode($header[0]),1);
        $this->Cell(80,7,utf8_decode($header[1]),1);
        $this->Cell(80,7,utf8_decode($header[2]),1);
        $this->Ln();
        // Datos
        foreach($datos as $row)
        {
            $this->Cell(23,6,utf8_decode($row["ciu_cod"]),1);
            $this->Cell(80,6,utf8_decode($row["ciu_desc"]),1);
            $this->Cell(80,6,utf8_decode($row["pais_desc"]),1);
            $this->Ln();
        }
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->ciudad($datos);
$pdf->Output();
?>
