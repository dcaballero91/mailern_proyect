
<?php

require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$rows = array();
$sql = ("select * from v_usuarios order by 1");
$result = pg_query($sql);
while ($row = pg_fetch_array($result)) {
    $rows[] = $row;
}
$datos = $rows;
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function usuarios($datos)
    {
        $this->Image('../informes/img.png',60,11,80,25,'png');
        $this->Cell(165,30,"");
        $this->Ln();
        $this->Cell(165,10,"REPORTE DE USUARIOS");
        $this->Ln();
        //Titulo
        $header = array('Codigo','Usuario','Funcionario', 'Cargo', 'Perfil','Estado');
        // Cabecera
        $this->Cell(15,7,$header[0],1);
        $this->Cell(30,7,$header[1],1);
        $this->Cell(40,7,$header[2],1);
        $this->Cell(60,7,$header[3],1);
        $this->Cell(30,7,$header[4],1);
        $this->Cell(20,7,$header[5],1);
        $this->Ln();
        // Datos
        foreach($datos as $row)
        {
            $this->Cell(15,6,$row["usu_cod"],1);
            $this->Cell(30,6,$row["usu_name"],1);
            $this->Cell(40,6,$row["fun_nom"],1);
            $this->Cell(60,6,$row["car_desc"],1);
            $this->Cell(30,6,$row["gru_desc"],1);
            $this->Cell(20,6,$row["usu_estado"],1);
            $this->Ln();
        }
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->usuarios($datos);
$pdf->Output();
?>
