<?php

require "../funciones/fpdf/fpdf.php";
require "../clases/conexion.php";
$id = $_GET["id"];
$con = new conexion();
$con->conectar();

$det = array();

$sql1 = ("select * from v_transferencias_cab where trans_cod = ".$id."");
$result1 = pg_query($sql1);
$cab = pg_fetch_array($result1);
$sql2 = ("select * from v_transferencias_det where trans_cod = ".$id." ");
$result2 = pg_query($sql2);
while ($row = pg_fetch_array($result2)) {
    $det[] = $row;
}
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function pedidocompras($cab,$det)
    {
    //    $this->Image('../img/INFORMES.JPG',60,11,80,25,'JPG');
       $this->Image('../informes/img.png',60,11,80,25,'png');
        $this->Cell(165,30,"");
        $this->Ln();
        $this->Cell(165,10,"NOTAS DE REMISION");
        $this->Ln();

        $this->Cell(20,6,utf8_decode('NOTA N°: '));
        $this->Cell(33,6,$cab["trans_cod"]);
        $this->Cell(15,6,utf8_decode('Fecha: '));
        $this->Cell(30,6,$cab["fecha_envio"]);
        $this->Ln();
        $this->Cell(30,6,utf8_decode('Funcionario: '));
        $this->Cell(30,6,$cab["fun_nom"]);
        $this->Ln();
        $this->Cell(15,6,utf8_decode('Estado: '));
        $this->Cell(30,6,$cab["trans_estado"]);
        $this->Ln();
        $this->Cell(18,6,utf8_decode('Empresa: '));
        $this->Cell(20,6,$cab["emp_nom"]);
        // $this->Cell(9,6,utf8_decode('RUC: '));
        // $this->Cell(12,6,$cab["emp_ruc"]);
        // $this->Ln();
        // $this->Cell(18,6,utf8_decode('Direccion: '));
        // $this->Cell(60,6,utf8_decode($cab["emp_dir"]));
        // $this->Ln();
        // $this->Cell(15,6,utf8_decode('Email: '));
        // $this->Cell(50,6,utf8_decode($cab["emp_email"]));
        // $this->Ln();
        // $this->Cell(15,6,utf8_decode('Vehiculo: '));
        // $this->Cell(30,6,$cab["vehi_desc"]);
        // $this->Ln();
        $this->Cell(15,6,utf8_decode('Origen: '));
        $this->Cell(30,6,utf8_decode($cab["suc_origen"]));
        $this->Ln();
        $this->Cell(15,6,utf8_decode('Destino: '));
        $this->Cell(30,6,utf8_decode($cab["suc_destino"]));
        $this->Ln();
        $this->Ln();
        $this->Ln();
        //Titulo
        $header = array('Codigo','Item','Marca','Cantidad','Cantidad Recibida','Deposito');
        // Cabecera
        $this->Cell(14,7,$header[0],1);
        $this->Cell(70,7,$header[1],1);
        $this->Cell(50,7,$header[2],1);
        $this->Cell(25,7,$header[3],1);
        $this->Cell(35,7,$header[4],1);
        $this->Ln();
        // Datos
        $total = 0;
        foreach($det as $row)
        {
            //$subtotal = $row["ped_cantidad"] * $row["ped_precio"];
           // $total = $total + $subtotal;
            $this->Cell(14,6,$row["trans_cod"],2);
            $this->Cell(70,6,$row["item_desc"],2);
            $this->Cell(50,6,$row["mar_desc"],2);
            $this->Cell(25,6,$row["trans_cantidad"],2);
            $this->Cell(20,6,$row["trans_cant_recibida"],2);
          //  $this->Cell(25,6,number_format($row["ped_precio"],0,',','.'),2);
           // $this->Cell(25,6,number_format($subtotal,0,',','.'),2);
            $this->Ln();
        }
        $this->Cell(159,6,'Totales',1);
        $this->Cell(35,6,number_format($total,0,',','.'),1);
        $this->Ln();
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->pedidocompras($cab,$det);
$pdf->Output();
?>