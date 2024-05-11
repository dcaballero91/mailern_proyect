<?php
/**
 * Created by PhpStorm.
 * User: Alfredo Sanchez
 * Date: 20/12/2019
 * Time: 06:59 PM
 */
require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$rows = array();
$sql = ("select * from generos order by 1");
$result = pg_query($sql);
while ($row = pg_fetch_array($result)) {
    $rows[] = $row;
}
$datos = $rows;
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function genero($datos)
    {
        $this->Image('../informes/img.png',60,11,80,25,'png');
        $this->Cell(165,30,"");
        $this->Ln();
        $this->Cell(165,10,"REPORTE DE GENERO");
        $this->Ln();
        //Titulo
        $header = array('Código','Descripción',);
        // Cabecera
        $this->Cell(23,7,utf8_decode($header[0]),1);
        $this->Cell(165,7,utf8_decode($header[1]),1);
        $this->Ln();
        // Datos
        foreach($datos as $row)
        {
            $this->Cell(23,6,utf8_decode($row["gen_cod"]),1);
            $this->Cell(165,6,utf8_decode($row["gen_desc"]),1);
            $this->Ln();
        }
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->genero($datos);
$pdf->Output();
?>