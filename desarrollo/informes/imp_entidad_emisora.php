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
$sql = ("select * from entidad_emisora order by 1");
$result = pg_query($sql);
while ($row = pg_fetch_array($result)) {
    $rows[] = $row;
}
$datos = $rows;
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function entidad_emisora($datos)
    {
        $this->Image('../img/INFORMES.JPG',60,11,80,25,'JPG');
        $this->Cell(165,30,"");
        $this->Ln();
        $this->Cell(165,10,"REPORTE DE ENTIDAD EMISORA");
        $this->Ln();
        //Titulo
        $header = array('Codigo','Descripcion','Direccion','Telefono','Email');
        // Cabecera
        $this->Cell(23,7,$header[0],1);
        $this->Cell(35,7,$header[1],1);
        $this->Cell(40,7,$header[2],1);
        $this->Cell(40,7,$header[3],1);
        $this->Cell(60,7,$header[4],1);
        $this->Ln();
        // Datos
        foreach($datos as $row)
        {
            $this->Cell(23,6,$row["entemi_cod"],1);
            $this->Cell(35,6,$row["entemi_nom"],1);
            $this->Cell(40,6,$row["entemi_dire"],1);
            $this->Cell(40,6,$row["entemi_tel"],1);
            $this->Cell(60,6,$row["entemi_email"],1);
            $this->Ln();
        }
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->entidad_emisora($datos);
$pdf->Output();
?>
