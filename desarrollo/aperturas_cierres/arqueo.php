<?php

// Include the main TCPDF library (search for installation path).
require_once'../tcpdf/tcpdf.php';
require_once'../clases/conexion2.php';


$sql = "select * from v_aperturas_cierres where aper_cier_cod = ".$_REQUEST['cod'];
$resul = consultas::get_datos($sql);
//$resul = conexion::query($sql);
// create new PDF document
$pdf = new TCPDF('P', 'mm', array(215.9,330.2));
$pdf->SetMargins(17, 15, 18);
$pdf->SetTitle("ARQUEO DE CAJA");
$pdf->SetPrintHeader(false);
$pdf->SetPrintFooter(false);
$pdf->AddPage();

$pdf->Ln(5);
$pdf->SetFont('Times', 'B', 14);
//$pdf->SetLineWidth(5);
$pdf->Cell(0, 0, "AQUEO DE LA APERTURA NRO: ".$resul[0]['aper_cier_cod']." (".$resul[0]['caja_desc'].")", 0, 1, 'C');

//RECUADRO IZQUIERDO
//$pdf->RoundedRect(16, 30, 90, 22, 4.0, '1111', '', $style6, array(200, 200, 200));
//RECUADRO DERECHO
//$pdf->RoundedRect(108, 30, 90, 22, 4.0, '1111', '', $style6, array(200, 200, 200));


$pdf->Ln(7);

//INFORMACION LINEA 1 IZQUIERDA
$pdf->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
$pdf->Cell(/*1*/35, /*2*/1, /*3*/'CAJERO:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
$pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA DATO
$pdf->Cell(/*1*/50, /*2*/1, /*3*/$resul[0]['funcionario'], /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

//SEPARADOR, PARA QUE LA INFORMACION SALGA EN EL RECUADRO DE LA DERECHA
$pdf->Cell(/*1*/8, /*2*/1, /*3*/'', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

//INFORMACION LINEA 1 RECUADRO DERECHO
$pdf->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
$pdf->Cell(/*1*/50, /*2*/1, /*3*/'MONTO EN EFECTIVO:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
$pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA DATO
$pdf->Cell(/*1*/35, /*2*/1, /*3*/  number_format($resul[0]['monto_efectivo'], 0, ',', '.'), /*4*/0, /*5*/1, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

//INFORMACION LINEA 2 IZQUIERDA
$pdf->SetFont('Times', 'B', 12);
$pdf->Cell(/*1*/35, /*2*/1, /*3*/'FECHA APERTURA:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
$pdf->SetFont('Times', '', 12);
$pdf->Cell(/*1*/50, /*2*/1, /*3*/$resul[0]['fecha_aperformat'], /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

//SEPARADOR, PARA QUE LA INFORMACION SALGA EN EL RECUADRO DE LA DERECHA
$pdf->Cell(/*1*/8, /*2*/1, /*3*/'', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

//INFORMACION LINEA 2 RECUADRO DERECHO
$pdf->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
$pdf->Cell(/*1*/50, /*2*/1, /*3*/'MONTO EN CHEQUE:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
$pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA DATO
$pdf->Cell(/*1*/35, /*2*/1, /*3*/number_format($resul[0]['monto_cheque'], 0, ',', '.'), /*4*/0, /*5*/1, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);


//INFORMACION LINEA 3 IZQUIERDA
$pdf->SetFont('Times', 'B', 12);
$pdf->Cell(/*1*/35, /*2*/1, /*3*/'FECHA CIERRE:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
$pdf->SetFont('Times', '', 12);
$pdf->Cell(/*1*/50, /*2*/1, /*3*/$resul[0]['fecha_cierreformat'], /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

//SEPARADOR, PARA QUE LA INFORMACION SALGA EN EL RECUADRO DE LA DERECHA
$pdf->Cell(/*1*/8, /*2*/1, /*3*/'', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

//INFORMACION LINEA 3 RECUADRO DERECHO
$pdf->SetFont('Times', 'B', 12);//TIPO DE LETRA PARA TITULO
$pdf->Cell(/*1*/50, /*2*/1, /*3*/'MONTO EN TARJETA:', /*4*/0, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
$pdf->SetFont('Times', '', 12);//TIPO DE LETRA PARA DATO
$pdf->Cell(/*1*/35, /*2*/1, /*3*/number_format($resul[0]['monto_tarjeta'], 0, ',', '.'), /*4*/0, /*5*/1, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);



//DETALLES DE CHEQUES
$sqlchs = "select * from v_cobros_cheques where aper_cier_cod = ".$resul[0]["aper_cier_cod"]." order by titular";
$rschs = consultas::get_datos($sqlchs);
if($rschs){
    $pdf->Ln(8);
    $pdf->SetFont('Times', 'B', 14);
    //$pdf->SetLineWidth(5);
    $pdf->Cell(0, 0, "DETALLE DE CHEQUES", 0, 1, 'C');
    
    $pdf->SetFont('Times', 'B', 10);//TIPO DE LETRA PARA TITULO
    $pdf->Cell(/*1*/50, /*2*/1, /*3*/'TITULAR', /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->Cell(/*1*/25, /*2*/1, /*3*/'NRO. CHEQUE', /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->Cell(/*1*/50, /*2*/1, /*3*/'ENTIDAD', /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->Cell(/*1*/25, /*2*/1, /*3*/'FECHA PAGO', /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->Cell(/*1*/30, /*2*/1, /*3*/'IMPORTE', /*4*/1, /*5*/1, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

    foreach ($rschs as $chs) {
        $pdf->SetFont('Times', '', 10);//TIPO DE LETRA PARA TITULO
        $pdf->Cell(/*1*/50, /*2*/1, /*3*/$chs['titular'], /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
        $pdf->Cell(/*1*/25, /*2*/1, /*3*/$chs['cheq_num'], /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
        $pdf->Cell(/*1*/50, /*2*/1, /*3*/$chs['ch_cuenta_num'], /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
        $pdf->Cell(/*1*/25, /*2*/1, /*3*/$chs['cobro_fecha'], /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
        $pdf->Cell(/*1*/30, /*2*/1, /*3*/number_format($chs['cheq_importe'], 0, ',', '.'), /*4*/1, /*5*/1, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

    }
}




//DETALLES DE TARJETAS
$sqltars = "select * from v_cobro_tarjetas where id_apercierre = ".$resul[0]['id_apercierre']." order by tarj_tipo,mar_descripcion";
$rstars = consultas::get_datos($sqltars);
if($rstars){
    $pdf->Ln(5);
    $pdf->SetFont('Times', 'B', 14);
    //$pdf->SetLineWidth(5);
    $pdf->Cell(0, 0, "DETALLE DE TARJETAS", 0, 1, 'C');
    
    $pdf->SetFont('Times', 'B', 10);//TIPO DE LETRA PARA TITULO
    $pdf->Cell(/*1*/50, /*2*/1, /*3*/'TARJETA', /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->Cell(/*1*/25, /*2*/1, /*3*/'NRO. TARJETA', /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->Cell(/*1*/50, /*2*/1, /*3*/'ENTIDAD', /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->Cell(/*1*/25, /*2*/1, /*3*/'COD. AUT.', /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    $pdf->Cell(/*1*/30, /*2*/1, /*3*/'IMPORTE', /*4*/1, /*5*/1, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

    foreach ($rstars as $tar) {
        $pdf->SetFont('Times', '', 10);//TIPO DE LETRA PARA TITULO
        $pdf->Cell(/*1*/50, /*2*/1, /*3*/$tar['tarj_tipo']." ".$tar['mar_descripcion'], /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
        $pdf->Cell(/*1*/25, /*2*/1, /*3*/$tar['nro_tarjeta'], /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
        $pdf->Cell(/*1*/50, /*2*/1, /*3*/$tar['ent_descripcion'], /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
        $pdf->Cell(/*1*/25, /*2*/1, /*3*/$tar['cod_auto'], /*4*/1, /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
        $pdf->Cell(/*1*/30, /*2*/1, /*3*/number_format($tar['importe'], 0, ',', '.'), /*4*/1, /*5*/1, /*6*/'R', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

    }
}




//Utilización del método Cell. Fuente http://www.rinconastur.com/php/php91.php
/*Cell(
   1  * $ancho,                       Ancho de la celda expresado unidad de medida establecida en la llamada al constructor TCPDF. Si es cero se extiende desde el punto de inserción hasta el margen derecho de la página
   2  * $alto=0,                      Alto mínimo de la celda expresado en la unidad de medida establecida en la llamada al constructor. La altura de la celda se ajustará al texto contenido en ella. Si se estable altura cero la celda se adaptará a las dimensiones de su contenido
   3  * $texto="",                    Cadena o variable conteniendo el texto que debe incluirse mediante el método Cell. Es aconsejable tomar la cautela de comprobar que la codificación del texto utiliza la misma codificación establecida por el constructor del objeto.
   4  * $borde=0,                     0	  La celda se visualizará sin bordes   /////otro valor/////   1	  Pertime visualizar la celda con un borde del color y ancho especificados por los métodos SetDrawColor y SetLineWidth o por las opciones poder defecto de estos (negro de 1 unidad de espesor)  /////otro valor/////   'LTRB'	  Esta cadena que permite, siempre que se mantenga el orden, elegir todas o varias de las letras indicadas sirve para establecer por qué parte de la de la celda se añadirán bordes. L alude a la izquierda, T a la parte superior, R a la derecha y B a la parte inferior. Por ejemplo: 'TB' dibujaría bordes por la parte superior e inferior de la celda, 'LB' los pondría por la izquierda y por debajo Y 'LRB' pondría bordes por todas partes excepto por la parte inferior.
   
   5  * $salto_de_linea=0,            0	  Cuando no se especifica este valor o se especifica 0 (valor por defecto) se establece que el punto de inserción, después de la llamada a este método, se sitúa justamente en el borde derecho de la celda.        /////otro valor/////        1	  Mediante esta opción, la celda siguiente que se incluya se situará en el margen izquierdo de la página y debajo de la fila actual.        /////otro valor/////        2	  Cuando se indica este valor, la próxima celda que se incluya aparecerá debajo de la actual y alineada al borde izquierdo de esta.
   6  * $alineacion="",               L, C, R o J	  Establece la forma de alineación (izquierda, centrada, derecha o justificada) del texto respecto a la celda contenedora.
   7  * $fondo=false,                 booleano	  Cuando este parámetro está como true la caja contenedora aparece un color de fondo (puede establecerse mediante SetFillColor (negro por defecto).
   8  * $enlace="",                   cadena	Permite incluir una cadena con una dirección URI. El texto se comportaría como un hiperenlace
   9  * $ajuste_horizontal=0,         0	  No realiza ningún ajuste del texto que puede desbordar el espacio delimitado por el recuadro contenedor   ///otro valor/// 1	  Se producirá, sólo si es necesario un estrechamiento del texto hasta lograr que quepa en el recuadro contenedor.  ///otro valor///    2	  Reducirá o expandirá el ancho del texto para ajustarlo a las dimensiones del recuadro contenedor  ///otro valor///    3	  Reducirá la separación entre caracteres (sin alterar el ancho de la tipografía) si resulta necesario para que quepa el texto en el marco contenedor   ///otro valor///    4	  Aumenta o reduce la separación entre caracteres para ajustar el texto al marco contenedor
   10 * $ignore_min_height=false,     booleano	  Cuando la altura asignada a la celda es demasiado pequeña para contener el texto con la fuente establecida si este parámetro está como false (0) la altura de la celda se ajustará para contener el texto. Si esta opción está configurada como true (1) se respetará la altura de la celda y el texto aparecerá fuera de los bordes de esta. 
   11 * $alin_vertical_texto='T',     T	  El borde superior del contenedor se alineará con el valor de la ordenada especificada en el parámetro y   ///otro valor///    A	  El borde superior de las letras se alineará con el valor de la ordenada especificada en el parámetro y    ///otro valor///    L	  La línea base de las letras se alineará con el valor de la ordenada especificada en el parámetro y    ///otro valor///    B	  El borde inferior del contenedor se alineará con el valor de la ordenada especificada en el parámetro y 
   12 * $alineacion_vertical='M'      T	  El texto se alinea verticalmente a la parte superior del contenedor   ///otro valor///    C	  El texto se alinea verticalmente al centro del contenedor ///otro valor///    B	  El texto se alinea verticalmente al borde inferior del contenedor
 )*/

//$pdf->SetFont('Times', 'B', 10);
//$pdf->Cell(/*1*/15, /*2*/1, /*3*/'ID', /*4*/"B", /*5*/0, /*6*/'C', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
//$pdf->Cell(/*1*/60, /*2*/1, /*3*/'RAZON SOCIAL', /*4*/"B", /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
//$pdf->Cell(/*1*/30, /*2*/1, /*3*/'RUC', /*4*/"B", /*5*/0, /*6*/'L',  /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
//$pdf->Cell(/*1*/30, /*2*/1, /*3*/'TELEFONO', /*4*/"B", /*5*/0, /*6*/'L',  /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
//$pdf->Cell(/*1*/60, /*2*/1, /*3*/'DIRECCION', /*4*/"B", /*5*/0, /*6*/'L',  /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
//$pdf->Cell(/*1*/60, /*2*/1, /*3*/'CORREO', /*4*/"B", /*5*/0, /*6*/'L',  /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
//$pdf->Cell(/*1*/42.2, /*2*/1, /*3*/'CIUDAD', /*4*/"B", /*5*/1, /*6*/'L',  /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);

//foreach ($resul as $rs) {
  //  $pdf->SetFont('Times', '', 10);
    //$pdf->Cell(/*1*/15, /*2*/1, /*3*/$rs['id_cliente'], /*4*/"B", /*5*/0, /*6*/'C', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    //$pdf->Cell(/*1*/60, /*2*/1, /*3*/$rs['cli_razonsocial'], /*4*/"B", /*5*/0, /*6*/'L', /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    //$pdf->Cell(/*1*/30, /*2*/1, /*3*/$rs['cli_ruc'], /*4*/"B", /*5*/0, /*6*/'L',  /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    //$pdf->Cell(/*1*/30, /*2*/1, /*3*/$rs['cli_telefono'], /*4*/"B", /*5*/0, /*6*/'L',  /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    //$pdf->Cell(/*1*/60, /*2*/1, /*3*/$rs['cli_direccion'], /*4*/"B", /*5*/0, /*6*/'L',  /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    //$pdf->Cell(/*1*/60, /*2*/1, /*3*/$rs['cli_email'], /*4*/"B", /*5*/0, /*6*/'L',  /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
    //$pdf->Cell(/*1*/42.2, /*2*/1, /*3*/$rs['ciu_descripcion'], /*4*/"B", /*5*/1, /*6*/'L',  /*7*/null, /*8*/null, /*9*/1, /*10*/null, /*11*/null, /*12*/null);
//}




// Close and output PDF document
// This method has several options, check the source code documentation for more information.
$pdf->Output('ARQUEO DE CAJA.pdf', 'I');

//============================================================+
// END OF FILE
//============================================================+

