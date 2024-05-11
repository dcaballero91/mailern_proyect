
<?php

require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$rows = array();
$sql = ("select * from v_personas order by 1");
$result = pg_query($sql);
while ($row = pg_fetch_array($result)) {
    $rows[] = $row;
}
$datos = $rows;
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function personas($datos)
    {
        $this->Image('../informes/img.png',110,11,80,25,'png');
        $this->Cell(165,30,"");
        $this->Ln();
        $this->Cell(165,10,"REPORTE DE PERSONAS");
        $this->Ln();
        //Titulo
        $header = array('Codigo','Nombre','Apellido', 'CI', 'Genero','Direccion', 'Telefono', 'Pais', 'Tipo Persona');
        // Cabecera
        $this->Cell(15,7,$header[0],1);
        $this->Cell(30,7,$header[1],1);
        $this->Cell(30,7,$header[2],1);
        $this->Cell(20,7,$header[3],1);
        $this->Cell(20,7,$header[4],1);
        $this->Cell(70,7,$header[5],1);
        $this->Cell(30,7,$header[6],1);
        $this->Cell(30,7,$header[7],1);
        $this->Cell(20,7,$header[8],1);
        $this->Ln();
        // Datos
        foreach($datos as $row)
        {
            $this->Cell(15,6,$row["per_cod"],1);
            $this->Cell(30,6,$row["per_nom"],1);
            $this->Cell(30,6,$row["per_ape"],1);
            $this->Cell(20,6,$row["per_ci"],1);
            $this->Cell(20,6,$row["gen_desc"],1);
            $this->Cell(70,6,$row["per_dir"],1);
            $this->Cell(30,6,$row["per_tel"],1);
            $this->Cell(30,6,$row["pais_desc"],1);
            $this->Cell(20,6,$row["tipo_pers_desc"],1);
            $this->Ln();
        }
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',8);
$pdf->AddPage('LANDSCAPE', 'A4');
$pdf->personas($datos);
$pdf->Output();
?>
