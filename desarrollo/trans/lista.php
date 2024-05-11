<?php

require('../reportes/fpdf.php');
require "../clases/conexion.php";
class PDF extends FPDF
{
var $widths;
var $aligns;

function SetWidths($w)
{
	//Set the array of column widths
	$this->widths=$w;
}

function SetAligns($a)
{
	//Set the array of column alignments
	$this->aligns=$a;
}

function Row($data)
{
	//Calculate the height of the row
	$nb=0;
	for($i=0;$i<count($data);$i++)
		$nb=max($nb,$this->NbLines($this->widths[$i],$data[$i]));
	$h=5*$nb;
	//Issue a page break first if needed
	$this->CheckPageBreak($h);
	//Draw the cells of the row
	for($i=0;$i<count($data);$i++)
	{
		$w=$this->widths[$i];
		$a=isset($this->aligns[$i]) ? $this->aligns[$i] : 'L';
		//Save the current position
		$x=$this->GetX();
		$y=$this->GetY();
		//Draw the border
		
		$this->Rect($x,$y,$w,$h);

		$this->MultiCell($w,5,$data[$i],0,$a,'true');
		//Put the position to the right of the cell
		$this->SetXY($x+$w,$y);
	}
	//Go to the next line
	$this->Ln($h);
}

function CheckPageBreak($h)
{
	//If the height h would cause an overflow, add a new page immediately
	if($this->GetY()+$h>$this->PageBreakTrigger)
		$this->AddPage($this->CurOrientation);
}

function NbLines($w,$txt)
{
	//Computes the number of lines a MultiCell of width w will take
	$cw=&$this->CurrentFont['cw'];
	if($w==0)
		$w=$this->w-$this->rMargin-$this->x;
	$wmax=($w-2*$this->cMargin)*1000/$this->FontSize;
	$s=str_replace("\r",'',$txt);
	$nb=strlen($s);
	if($nb>0 and $s[$nb-1]=="\n")
		$nb--;
	$sep=-1;
	$i=0;
	$j=0;
	$l=0;
	$nl=1;
	while($i<$nb)
	{
		$c=$s[$i];
		if($c=="\n")
		{
			$i++;
			$sep=-1;
			$j=$i;
			$l=0;
			$nl++;
			continue;
		}
		if($c==' ')
			$sep=$i;
		$l+=$cw[$c];
		if($l>$wmax)
		{
			if($sep==-1)
			{
				if($i==$j)
					$i++;
			}
			else
				$i=$sep+1;
			$sep=-1;
			$j=$i;
			$l=0;
			$nl++;
		}
		else
			$i++;
	}
	return $nl;
}

function Header()
{

	$this->SetFont('Arial','',10);
	$this->Text(20,14,'TECHNO SOLUTION',0,'C', 0);
	$this->Text(220,14,'Fecha: '.date('d-m-Y').'',0,'C', 0);
	$this->Ln(30);

}

function Footer()
{
	$this->SetY(-15);
	$this->SetFont('Arial','B',8);
	$this->Cell(100,10,'Sistema Gestion',0,0,'L');

}

}

	$cod= $_GET['id'];
	$cn = new conexion();
	$cn->conectar();
	
	
	$nro = pg_query('select * from v_trans where nro_tranfer= '.$cod);
	
	
	
	$fila = pg_fetch_array($nro);

	$pdf=new PDF('L','mm','Letter');
	
	$pdf->AddPage();
	$pdf->SetMargins(20,20,30);
	$pdf->Ln(10);

    $pdf->SetFont('Arial','',12);
    $pdf->Cell(30, 8, '', 0);
    $pdf->Cell(100,8,' '.$fila['empre_nombre'],0,0);
    $pdf->Cell(0,8,' '.$fila['sucnom1'],0,1);
    $pdf->SetFont('Arial','',8);
    $pdf->Cell(80,8,'Direccion: '.$fila['empre_dir'],0,0); 
    $pdf->Cell(60,8,'Telefono: '.$fila['empre_tel'],0,0);
    $pdf->Cell(60,8,'Direccion: '.$fila['sucur_direc'],0,0);
	$pdf->Cell(60,8,'Telefono: '.$fila['sucur_tel'],0,1);
	$pdf->Ln(10);
	$pdf->SetFont('Arial','',12);
    $pdf->Cell(178,10,'Nro de Remision: '.$fila['nro_tranfer'],0,0);
    $pdf->Cell(178,10,'Origen: '.$fila['sucnom2'],0,0);
   
	$pdf->Cell(0,10,'Fecha: '.$fila['sucnom3'],0,1);
	$pdf->Cell(178,10,'Funcionario: '.$fila['fun_nom'].' '.$fila['fun_ape'],0,0);
	 $pdf->Cell(178,10,'Destino: '.$fila['sucnom3'],0,0);
	
	
	 
	$pdf->Ln(10);
	$pdf->Ln(10);
	
	$pdf->SetWidths(array(30, 80, 40, 50, 50));
	$pdf->SetFont('Arial','B',10);
	$pdf->SetFillColor(	107,85,47,47,47);
    $pdf->SetTextColor(255);

		for($i=0;$i<1;$i++)
			{
				$pdf->Row(array('Codigo', 'Producto','Cantidad','Cant. Recib','Deposito'));
			}
	
	$deta = $cn->conectar();	
	$deta = pg_query('select * from v_tan_deta where nro_tranfer= '.$cod);
	

	$totaluni = 0;
	$total = 0;
	
	$numfilas = pg_num_rows($deta);
	
	for ($i=0; $i<$numfilas; $i++)
		{
			$fila = pg_fetch_array($deta);
			$pdf->SetFont('Arial','',10);
			
	


			if($i%2 == 1)
			{
				$pdf->SetFillColor(225,219,212);
    			$pdf->SetTextColor(0);
				$pdf->Row(array($fila['nro_tranfer'], $fila['item_des'], $fila['tra_cantidad'],$fila['cant_recib'],$fila['depo_nom']));
			}
			else
			{
				$pdf->SetFillColor(115,112,109);
    			$pdf->SetTextColor(0);
				$pdf->Row(array($fila['nro_tranfer'], $fila['item_des'], $fila['tra_cantidad'],$fila['cant_recib'],$fila['depo_nom']));
			}
		}
		

$pdf->Output();
?>