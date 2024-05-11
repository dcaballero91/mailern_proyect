<?php
require "../clases/conexion.php";
$cod = $_POST["cod"];
$suc = $_POST["suc"];
$con = new conexion();
$con ->conectar();
$sql = pg_query("select *  from v_pedidos_ventas_det where ped_vcod = $cod ");
$pedidoventas = pg_fetch_all($sql);
// echo $ordentrabajos;

$exenta = 0;
$gravada5 = 0;
$gravada10 = 0;

$depcod = '';
$depdesc = '';
$ped = pg_fetch_assoc($sql);
$deposito = deposito($ped['item_cod'], $ped['ped_cantidad'], $suc);
foreach ($deposito as $valor){
    $depcod = $valor["dep_cod"];
    $depdesc  = $valor["dep_desc"];
}

if($depcod >0  ){// si es que hay un deposito con la cantidad necesaria
        
    // PARA PODER MOSTRAR EL gravada y exenta correspondiente a cada item en la tabla

    $data['filas']= '';
    foreach($pedidoventas as $key => $pedidos){
        if($pedidos['tipo_imp_cod'] = 1){
            $exenta = 0;
            $gravada5 = 0;
            $gravada10 = $pedidos['ped_precio'] * $pedidos['ped_cantidad'];


        }elseif($pedidos['tipo_imp_cod'] = 2){
            $exenta = 0;
            $gravada5 = $pedidos['ped_precio'] * $pedidos['ped_cantidad'];
            $gravada10 = 0;

        }elseif($pedidos['tipo_imp_cod'] = 3){
            $exenta = $pedidos['ped_precio'] * $pedidos['ped_cantidad'];
            $gravada5 = 0;
            $gravada10 = 0;
        }

        $data['filas'].= '<tr>';
        $data['filas'].='<td style="text-align: center;">'.$pedidos['item_cod'].'</td>';
        $data['filas'].='<td style="text-align: left;">'.$pedidos['item_desc'].'</td>';
        $data['filas'].='<td style="text-align: center;">'.$pedidos['mar_cod'].'-'.$pedidos['mar_desc'].'</td>';
        $data['filas'].='<td style="text-align: center;">'.$depcod.' - '.$depdesc.'</td>';
        $data['filas'].='<td style="text-align: center;">'.$pedidos['ped_cantidad'].'</td>';
        $data['filas'].='<td style="text-align: right;">'.$pedidos['ped_precio'].'</td>';
        $data['filas'].='<td style="text-align: right;">'.$exenta.'</td>';
        $data['filas'].='<td style="text-align: right;">'.$gravada5.'</td>';
        $data['filas'].='<td style="text-align: right;">'.$gravada10.'</td>';
        $data['filas'].='<td style="text-align: right;">'.''.'</td>';
        $data['filas'].='</tr>';
    }

    echo json_encode($data);
    return json_encode($data);
}else{// si no hay un deposito con la cantidad necesaria
    $error = "error";
    echo $error;
}


function deposito($item, $cant, $suc){
    $sqldep = pg_query("SELECT * FROM v_stock WHERE item_cod = $item AND suc_cod = $suc AND stock_cantidad > $cant");

    $verificar = pg_fetch_all($sqldep);
    
    if(!empty($verificar)){ // si existe un deposito con la cantidad de item en stock superior a la cantidad a ser vendida
        while($rsdep = pg_fetch_array($sqldep)){
           $deposito [] = array(
               'dep_cod' => $rsdep['dep_cod'],
               'dep_desc' => $rsdep['dep_desc'],
           );
        }
        return $deposito;
    }else{
        $deposito [] = array(
            'dep_cod' => 0,
            'dep_desc' => 0,
        );
        return $deposito;
    }
}
?>

