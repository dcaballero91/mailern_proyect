<?php
require "../funciones/fpdf/fpdf.php";
//require "../clases/sesion.php";
require "../clases/conexion.php";
            //$codigo = $_GET["codigo"];
$id = $_GET["cod"];
$con = new conexion();
$con->conectar();

$det = array();

$sql1 = ("select * from v_reservas_cab where reser_cod = ".$id." order by 1");
$result1 = pg_query($sql1);
$cab = pg_fetch_array($result1);
$sql2 = ("select * from v_reservas_det where reser_cod = ".$id." ");
$result2 = pg_query($sql2);
while ($row = pg_fetch_array($result2)) {
    $det[] = $row;
}
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function reservas($cab,$det){
        $this->Image('../informes/reportereserva.png',20,15,150,40,'png');
        $this->Cell(165,30,"");
        $this->Ln();
        $this->Ln();
        
        $this->Cell(30,10,"REPORTES DE RESERVAS DE TURNO");
        $this->Ln();
        
        $this->Cell(20,6,utf8_decode('Empresa: '));
       //  $this->Cell(33,6,$cab["emp_cod"]);
        $this->Cell(33,6,$cab["emp_nom"]);
       // $this->Cell(33,6,$cab["emp_dir"]);
        $this->Cell(20,6,utf8_decode('Sucursal: '));
       //  $this->Cell(33,6,$cab["suc_cod"]);
        
        $this->Cell(40,6,$cab["suc_nom"]);
         $this->Cell(20,6,utf8_decode('Direccion: '));
        $this->Cell(33,6,$cab["suc_dir"]);
        $this->Ln();
        
        $this->Cell(20,6,utf8_decode('Codigo: '));
        $this->Cell(33,6,$cab["reser_cod"]);
        $this->Cell(25,6,utf8_decode('Cliente: '));
        $this->Cell(30,6,$cab["cli_nom"].' '.$cab["cli_ape"]);
        $this->Cell(25,6,utf8_decode('Direccion: '));
        $this->Cell(30,6,$cab["cli_dir"]);
        $this->Ln();
       
        $this->Cell(18,6,utf8_decode('Estado: '));
        $this->Cell(20,6,$cab["reser_estado"]);
          $this->Ln();
          $this->Ln();
          $this->Ln();
        //Titulo
        $header = array('Cod','Tipo Servicio','Hora desde','Hora Hasta','Sugerencias','Subtotal');
        // Cabecera
        $this->Cell(10,8,$header[0],1);
        $this->Cell(40,8,$header[1],1);
        $this->Cell(40,8,$header[2],1);
        $this->Cell(40,8,$header[3],1);
        $this->Cell(35,8,$header[4],1);
        $this->Cell(25,8,$header[5],1);
       // $this->Cell(40,7,$header[6],1);
          $this->Ln();
       $total = 0;
        foreach($det as $row)
        {
            $subtotal = $row["tipo_serv_precio"];
            $total =  $total + $subtotal;
        $this->Cell(10,7,$row["tipo_serv_cod"],1);
        $this->Cell(40,7,$row["tipo_serv_desc"],1);
        $this->Cell(40,7,$row["reser_hdesde"],1);
        $this->Cell(40,7,$row["reser_hhasta"],1);
        $this->Cell(35,7,$row["reser_desc"],1);
        
       $this->Cell(25,6,number_format($row["tipo_serv_precio"],0,',','.'),1);
       //$this->Cell(5,6,number_format($subtotal,0,',','.'),1);
       $this->Ln();
        }
        $this->Cell(165,6,'Totales',1);
        $this->Cell(25,6,number_format($total,0,',','.').' Gs.',1);
        $this->Ln();
}
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->reservas($cab,$det);
$pdf->Output();
?>
