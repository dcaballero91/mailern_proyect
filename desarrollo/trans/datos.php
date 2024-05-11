<?php
require '../clases/conexion.php';

$cn = new conexion();
$cn->conectar();
$sql = pg_query('select * from v_trans where tran_estado=\'PENDIENTE\' order by nro_tranfer');
$first = 0;
$json = '{"data":[';
while($fila = pg_fetch_array($sql)){
    if($first++)$json .=',';
    $json.='{"cod":"'.$fila['nro_tranfer'].'", 
            "fun":"'.$fila['fun_nom'].' '.$fila['fun_ape'].'", 
            "ori":"'.$fila['sucnom2'].'",
            "des":"'.$fila['sucnom3'].'", 
            "fecha":"'.$fila['tran_fecha'].'",
            "envi":"'.$fila['fecha_envio'].'",
            "entre":"'.$fila['fecha_entrega'].'",
            "vehi":"'.$fila['vehi_chacis'].'",  
            "suc":"'.$fila['sucnom1'].'", 
            "emp":"'.$fila['empre_nombre'].
            //Lo nuevo en datos.php será que dentro del array "data"
            //crearemos otro array con nombre "detalle"
            '", "detalle":[';
    //en el que haremos una consulta del pedido detalle, enviandole como condicion el codigo del pedido que
    //se encuentra en la cabecera que será $fila['ped_cod'];
    //creando las mismas variables anteriores pero añadiendole un nro 2 para poder diferenciarlas
    //ej: sql2, first2, fila2
   $sql2 = pg_query('select * from v_tan_deta where nro_tranfer='.$fila['nro_tranfer']);
    $first2 = 0;
    while($fila2 = pg_fetch_array($sql2)){
        if($first2++)$json .=',';
        $json.='{"pro_cod":"'.$fila2['item_cod'].
                '", "pro_desc":"'.$fila2['item_des'].
                '", "cantidad":"'.$fila2['tra_cantidad'].
                '", "recib":"'.$fila2['cant_recib'].
                '","depo":"'.$fila2['depo_cod'].' '.$fila2['depo_nom'].'"}';
    }
    $json .= ']}';
}
$json .= ']}';
print_r ($json);