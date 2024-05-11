<?php
require "../funciones/fpdf/fpdf.php";
//require "../clases/sesion.php";
require "../clases/conexion.php";
            //$codigo = $_GET["codigo"];
$id = $_GET["id"];
$con = new conexion();
$con->conectar();

$det = array();

$sql1 = ("select * from v_agendas_cab where agen_cod = ".$id." order by 1");
$result1 = pg_query($sql1);
$cab = pg_fetch_array($result1);
$sql2 = ("select * from v_agendas_det where agen_cod = ".$id." ");
$result2 = pg_query($sql2);
while ($row = pg_fetch_array($result2)) {
    $det[] = $row;
}
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function agendas($cab,$det){
       // $this->Image('../img/INFORMES.JPG',60,11,80,25,'JPG');
        $this->Cell(165,30,"");
        $this->Ln();
        $this->Cell(165,10,"Agenda Professional");
          $this->Ln();
        $this->Cell(20,6,utf8_decode('Codigo: '));
        $this->Cell(33,6,$cab["agen_cod"]);
        $this->Cell(25,6,utf8_decode('Funcionario: '));
        $this->Cell(30,6,$cab["fun_nom"]);
        $this->Ln();
        $this->Cell(18,6,utf8_decode('Profesion: '));
        $this->Cell(20,6,$cab["prof_desc"]);
          $this->Ln();
        $this->Cell(18,6,utf8_decode('Estado: '));
        $this->Cell(20,6,$cab["agen_estado"]);
          $this->Ln();
          $this->Ln();
          $this->Ln();
        //Titulo
        $header = array('Codigo','Especialidad','Fecha','Hora desde','Hora Hasta','Dias','Cantidad de Cupos');
        // Cabecera
        $this->Cell(14,7,$header[0],1);
        $this->Cell(40,7,$header[1],1);
        $this->Cell(25,7,$header[2],1);
        $this->Cell(25,7,$header[3],1);
        $this->Cell(25,7,$header[4],1);
        $this->Cell(25,7,$header[5],1);
        $this->Cell(40,7,$header[6],1);
          $this->Ln();
       
        foreach($det as $row)
        {
        $this->Cell(14,7,$row["esp_cod"],1);
        $this->Cell(40,7,$row["esp_desc"],1);
        $this->Cell(25,7,$row["agen_fecha"],1);
        $this->Cell(25,7,$row["agen_hdesde"],1);
        $this->Cell(25,7,$row["agen_hhasta"],1);
        $this->Cell(25,7,$row["dias_desc"],1);
        $this->Cell(40,7,$row["agen_cupos"],1);
        $this->Ln();
    }
}
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->agendas($cab,$det);
$pdf->Output();
?>