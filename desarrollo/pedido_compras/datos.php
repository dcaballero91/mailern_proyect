<?php

require '../clases/conexion.php';
$cn = new conexion();
$cn->conectar();
$sql = pg_query("select * from v_pedidos_compras_cab where ped_estado='PENDIENTE' order by ped_nro");
$pedcompras = pg_fetch_all($sql);

    if(!empty($pedcompras)){

        $button_borrar = '<button type=\'button\' class=\'btn btn-primary  delete pull-right\' data-toggle=\'modal\' data-target=\'#confirmacion\' data-placement=\'top\' title=\'Borrar\'><i class=\'fa fa-minus\'></i></button>';

        $button_editar = '<button type=\'button\' class=\'btn btn-info btn-circle pull-right editar\' title=\'Editar\'><i class=\'fa fa-edit\'></i></button>';


        $button = $button_borrar." ".$button_editar;
    
        $datos['data'] = [];
        foreach ($pedcompras as $key => $pedidocompras) {
            $datos['data'][$key]['cod'] = $pedidocompras['ped_nro'];
            $datos['data'][$key]['fun_nom'] = $pedidocompras['fun_nom'];
            $datos['data'][$key]['nro'] = $pedidocompras['pedido_nro'];
            $datos['data'][$key]['fecha'] = $pedidocompras['fecha'];
            $datos['data'][$key]['ruc'] = $pedidocompras['emp_ruc'];
            $datos['data'][$key]['estado'] = $pedidocompras['ped_estado'];
            $datos['data'][$key]['acciones'] = $button;
    
            $sqldetalle = pg_query('select * from v_pedidos_compras_det where ped_nro =' . $pedidocompras['ped_nro']);
            $detalles = pg_fetch_all($sqldetalle);
    
            foreach ($detalles as $key2 => $detalle) {
    
                $datos['data'][$key]['detalle'][$key2]['cod'] = $detalle['ped_nro'];
                $datos['data'][$key]['detalle'][$key2]['codigo'] = $detalle['item_cod'];
                $datos['data'][$key]['detalle'][$key2]['descripcion'] = $detalle['item_desc'];
                $datos['data'][$key]['detalle'][$key2]['marca'] = $detalle['mar_desc'];
                $datos['data'][$key]['detalle'][$key2]['cantidad'] = $detalle['ped_cantidad'];
                $datos['data'][$key]['detalle'][$key2]['precio'] = $detalle['ped_precio'];
            }
        }
        echo json_encode($datos);
        return json_encode($datos);

    }else{
        $datos['data']=[];
        $datos['data']['cod'] = '-';
        $datos['data']['fun_nom'] = '-';
        $datos['data']['nro'] = '-';
        $datos['data']['fecha'] = '-';
        $datos['data']['ruc'] = '-';
        $datos['data']['estado'] = '-';
        $datos['data']['acciones'] =  '-';
      
        echo  json_encode($datos);
        return json_encode($datos);
    }
        

?>