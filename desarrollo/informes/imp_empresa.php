<?php

require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$rows = array();
$sql = ("select * from empresas order by 1");
$result = pg_query($sql);
while ($row = pg_fetch_array($result)) {
    $rows[] = $row;
}
$datos = $rows;
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function empresa($datos)
    {                                 
        $this->Image('../informes/img.png',20,15,150,40,'png');
        $this->Cell(165,30,"");
        $this->Ln();
        $this->Ln();
        $this->Cell(170,20,"REPORTE DE EMPRESA");
        $this->Ln();
        //Titulo
        $header = array('Codigo','Descripcion','Ruc','Direccion','Telefono','Email');
        // Cabecera
        $this->Cell(20,7,$header[0],1);
        $this->Cell(35,7,$header[1],1);
        $this->Cell(20,7,$header[2],1);
        $this->Cell(40,7,$header[3],1);
        $this->Cell(20,7,$header[4],1);
        $this->Cell(60,7,$header[5],1);
        $this->Ln();
        // Datos
        foreach($datos as $row)
        {               //LARGOR ;ANCHOR
            $this->Cell(20,6,$row["emp_cod"],1);
            $this->Cell(35,6,$row["emp_nom"],1);
            $this->Cell(20,6,$row["emp_ruc"],1);
            $this->Cell(40,6,$row["emp_dir"],1);
            $this->Cell(20,6,$row["emp_tel"],1);
            $this->Cell(60,6,$row["emp_email"],1);
            $this->Ln();
        }
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->empresa($datos);
$pdf->Output();
?>