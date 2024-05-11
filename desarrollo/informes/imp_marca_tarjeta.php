<?php
/**
 * Created by PhpStorm.
 * User: Hector Oviedo
 * Date: 03/07/2016
 * Time: 06:59 PM
 */
require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$rows = array();
$sql = ("select * from marca_tarjetas order by 1");
$result = pg_query($sql);
while ($row = pg_fetch_array($result)) {
    $rows[] = $row;
}
$datos = $rows;
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function marca_tarjeta($datos)
    {
        
        $this->Image('../informes/img.png',20,15,150,40,'png');
        $this->Cell(165,30,"");
        $this->Ln();
        $this->Ln();
        //Titulo
        $header = array('Codigo','Descripcion',);
        // Cabecera
        $this->Cell(23,7,$header[0],1);
        $this->Cell(160,7,$header[1],1);
        $this->Ln();
        // Datos
        foreach($datos as $row)
        {
            $this->Cell(23,6,$row["mar_tarj_cod"],1);
            $this->Cell(160,6,$row["mar_tarj_desc"],1);
            $this->Ln();
        }
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->marca_tarjeta($datos);
$pdf->Output();
?>