<?php

require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";
$con = new conexion();
$con->conectar();
$rows = array();
$sql = ("select * from v_entidades_adheridas order by 1");
$result = pg_query($sql);
while ($row = pg_fetch_array($result)) {
    $rows[] = $row;
}
$datos = $rows;
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function entidad_adherida($datos)
    {
       $this->Image('../informes/img.png',20,15,150,40,'png');
        $this->Cell(165,30,"");
        $this->Ln();
        $this->Ln();
        $this->Cell(165,10,"REPORTE DE ENTIDAD ADHERIDA");
        $this->Ln();
        //Titulo
        $header = array('Codigo','Descripcion','Direccion','Telefono','Email');
        // Cabecera
        $this->Cell(23,7,$header[0],1);
        $this->Cell(35,7,$header[1],1);
        $this->Cell(40,7,$header[2],1);
        $this->Cell(50,7,$header[3],1);
        $this->Cell(30,7,$header[4],1);
        $this->Ln();
        // Datos
        foreach($datos as $row)
        {
            $this->Cell(23,6,$row["ent_ad_cod"],1);
            $this->Cell(35,6,$row["ent_ad_nom"],1);
             $this->Cell(40,6,$row["ent_ad_dir"],1);
              $this->Cell(50,6,$row["ent_ad_tel"],1);
               $this->Cell(30,6,$row["ent_ad_email"],1);
            $this->Ln();
        }
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->entidad_adherida($datos);
$pdf->Output();
?>
