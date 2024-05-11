<?php

require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$rows = array();
$sql = ('select * from ctas_a_cobrar order by 1');
$result = pg_query($sql);
while ($row = pg_fetch_array($result)) {
    $rows[] = $row;
}
$datos = $rows;
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function ctas_a_cobrar($datos)
    {
        $this->Image('../img/INFORMES.JPG',60,11,80,25,'JPG');
        $this->Cell(165,30,"");
        $this->Ln();
        $this->Cell(165,10,"REPORTE DE CUENTAS A COBRAR");
        $this->Ln();
        //Titulo
        $header = array('Codigo','Monto','Saldo','Vencimiento','Estado');
        // Cabecera
        $this->Cell(23,7,$header[0],1);
        $this->Cell(35,7,$header[1],1);
        $this->Cell(20,7,$header[2],1);
        $this->Cell(40,7,$header[3],1);
        $this->Cell(40,7,$header[4],1);
        $this->Cell(60,7,$header[5],1);
        $this->Ln();
        // Datos
        foreach($datos as $row)
        {
            $this->Cell(23,6,$row["cta_cobrar_nro"],1);
            $this->Cell(35,6,$row["cuota_monto"],1);
            $this->Cell(20,6,$row["cuota_saldo"],1);
            $this->Cell(40,6,$row["cuota_venc"],1);
            $this->Cell(40,6,$row["cuota_estado"],1);
            $this->Ln();
        }
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->ctas_a_cobrar($datos);
$pdf->Output();
?>
