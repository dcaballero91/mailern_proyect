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
$sql = ("select * from v_sucursales order by 1");
$result = pg_query($sql);
while ($row = pg_fetch_array($result)) {
    $rows[] = $row;
}
$datos = $rows;
$con->destruir();
class PDF extends FPDF
{
// Tabla simple
    function sucursal($datos)
    {
        $this->Image('../informes/img.png',20,15,150,40,'png');
        $this->Cell(165,30,"");
        $this->Ln();
        $this->Ln();
        $this->Cell(165,10,"REPORTE DE SUCURSAL");
        $this->Ln();
        //Titulo
        $header = array('Codigo','Empresa','Sucursal','Direccion','Email','Telefono',);
        // Cabecera
        $this->Cell(31,7,$header[0],1);
        $this->Cell(31,7,$header[1],1);
        $this->Cell(31,7,$header[2],1);
        $this->Cell(31,7,$header[3],1);
        $this->Cell(45,7,$header[4],1);
        $this->Cell(25,7,$header[5],1);
        $this->Ln();
        // Datos
        foreach($datos as $row)
        {
            $this->Cell(31,6,$row["suc_cod"],1);
            $this->Cell(31,6,$row["emp_nom"],1);
            $this->Cell(31,6,$row["suc_nom"],1);
            $this->Cell(31,6,$row["suc_dir"],1);
            $this->Cell(45,6,$row["suc_email"],1);
            $this->Cell(25,6,$row["suc_tel"],1);
            $this->Ln();
        }
    }
}
$pdf = new PDF();
// Carga de datos
$pdf->SetFont('Arial','',10);
$pdf->AddPage();
$pdf->sucursal($datos);
$pdf->Output();
?>