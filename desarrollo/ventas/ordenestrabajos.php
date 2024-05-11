<?php
require "../clases/conexion.php";
$cod = $_POST["cod"];
// $suc = $_POST["suc"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("select *  from v_ordenes_trabajos_det where ord_trab_cod = '$cod' ");
$ordentrabajos = pg_fetch_all($sql);
// echo $ordentrabajos;

    
$exenta = 0;
$gravada5 = 0;
$gravada10 = 0;

// $depcod = '';
// $depdesc = '';
// $orden = pg_fetch_assoc($sql);
// $deposito = deposito($orden['item_cod'], $suc);
// foreach ($deposito as $valor){
//     $depcod = $valor["dep_cod"];
//     $depdesc  = $valor["dep_desc"];
// }

// PARA PODER MOSTRAR EL gravada y exenta correspondiente a cada item en la tabla
$data['filas']= '';
foreach($ordentrabajos as $key => $ordentrab){
    if($ordentrab['tipo_imp_cod'] = 1){
        $exenta = 0;
        $gravada5 = 0;
        $gravada10 = $ordentrab['orden_precio'];


    }elseif($ordentrab['tipo_imp_cod'] = 2){
        $exenta = 0;
        $gravada5 = $ordentrab['orden_precio'];
        $gravada10 = 0;

    }elseif($ordentrab['tipo_imp_cod'] = 3){
        $exenta = $ordentrab['orden_precio'];
        $gravada5 = 0;
        $gravada10 = 0;
    }

    $data['filas'].= '<tr>';
    $data['filas'].='<td style="text-align: center;">'.$ordentrab['item_cod'].'</td>';
    $data['filas'].='<td style="text-align: left;">'.$ordentrab['item_desc'].'</td>';
    $data['filas'].='<td style="text-align: center;">'.'0'.'</td>';
    $data['filas'].='<td style="text-align: center;">'.'0'.'</td>';
    $data['filas'].='<td style="text-align: center;">'.'1'.'</td>';
    $data['filas'].='<td style="text-align: right;">'.$ordentrab['orden_precio'].'</td>';
    $data['filas'].='<td style="text-align: right;">'.$exenta.'</td>';
    $data['filas'].='<td style="text-align: right;">'.$gravada5.'</td>';
    $data['filas'].='<td style="text-align: right;">'.$gravada10.'</td>';
    $data['filas'].='<td style="text-align: right;">'.''.'</td>';
    $data['filas'].='</tr>';
}

echo json_encode($data);
return json_encode($data);

// function deposito($item, $suc){
//     $sqldep = pg_query("SELECT * FROM v_stock WHERE item_cod = $item AND suc_cod = $suc ");
//     while($rsdep = pg_fetch_array($sqldep)){
//        $deposito [] = array(
//            'dep_cod' => $rsdep['dep_cod'],
//            'dep_desc' => $rsdep['dep_desc'],
//        );
//     }
//     return $deposito;
// }
?>

