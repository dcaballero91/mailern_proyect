<?php
// Incluir el archivo de la clase conexion
require_once '../clases/conexion.php';


// Verificar la sesión
verifico();

// Crear una instancia de la clase conexion
$con = new conexion();

// Establecer la conexión
$con->conectar();

// Realizar la consulta utilizando la clase conexion
$fotos = $con->query("SELECT usu_foto FROM usuarios WHERE usu_cod = $_SESSION[id]");

// Verificar si la consulta fue exitosa
if ($fotos) {
    // Iterar sobre los resultados
    while ($foto = $fotos->fetch(PDO::FETCH_ASSOC)) {
        $foto2 = $foto['usu_foto'];
    }
} else {
    // Manejar el caso en que la consulta falle
    echo "Error al ejecutar la consulta";
}
?>
<div class="col-md-3 left_col">
    <div class="left_col scroll-view">
        <div class="navbar nav_title" style="border: 0;">
            <a href="../controles/inicio.php" class="site_title"><i class="fa fa-cut"></i> <span>ASTORE</span></a>
        </div>
        <div class="clearfix"></div>
        <!-- menu profile quick info -->
        <div class="profile clearfix">
            <div class="profile_pic">
                <img src="<?php echo "$foto2"; ?>" alt="..." class="img-circle profile_img">
            </div>
            <div class="profile_info">
                <span>Bienvenido/a</span>
                <h2><?php echo $_SESSION['fun_nom']?></h2>
            </div>
            <div class="clearfix"></div>
        </div>
        <!-- /menu profile quick info -->
        <br />
        <!-- sidebar menu -->
        <div id="sidebar-menu" class="main_menu_side hidden-print main_menu">
            <div class="menu_section">
                <h3 class="page-header" style="color: #ffffff;"> <font  face="Century Gothic">GENERAL</h3>
                <ul class="nav side-menu">
                    <li><a href="../controles/inicio.php"><i class="fa fa-windows fa-fw"></i><strong >Inicio</strong></a></li>
                    <div class="menu_section">  
                        <h3 class="page-header" style="color: #ffffff;" ><font  face="Century Gothic">REFERENCIALES</h3>
                        <ul class="nav side-menu">  
                            <li><a><i class="fa fa-check"></i> Referencial Seguridad <span class="fa fa-chevron-down"></span></a>
                                <ul class="nav child_menu">
                                    <li class="sub_menu"><a href="../usuarios/usuario.php">Usuario</a></li>
                                    <li class="sub_menu"><a href="../perfiles/perfil.php">Perfiles</a></li>
                                </ul>
                            </li> 

                            <li><a><i class="fa fa-users"></i> Referencial Personas <span class="fa fa-chevron-down"></span></a>
                                <ul class="nav child_menu">
                                    <li class="sub_menu"><a href="../personas/persona.php">Personas</a></li>
                                    <li class="sub_menu"><a href="../funcionarios/funcionario.php">Funcionario</a></li>
                                    <li class="sub_menu"><a href="../clientes/cliente.php">Cliente</a></li>
                                    <li class="sub_menu"><a href="../proveedores/proveedor.php">Proveedor</a></li>
                                    <li><a href="../cargos/cargo.php">Cargo</a>
                                    <li><a href="../profesiones/profesion.php">Profesion</a>
                                    <li><a href="../generos/genero.php">Genero</a>
                                    <li><a href="../estados_civiles/estado_civil.php">Estado Civil</a>
                                    <li><a href="../tipo_personas/tipo_persona.php">Tipo Persona</a>
                                    <li><a href="../especialidades/especialidad.php">Especialidad</a>
                                    </li>
                                </ul>
                            </li> 

                            <li><a><i class="fa fa-shopping-cart fa-fw "></i> Referencial Compras <span class="fa fa-chevron-down"></span></a>
                                <ul class="nav child_menu">
                                    <li><a href="../ciudades/ciudad.php">Ciudad</a>
                                    <li><a href="../nacionalidades/nacionalidad.php">Paises</a>
                                    <li><a href="../depositos/deposito.php">Deposito</a>
                                    <li><a href="../proveedor_timbrados/proveedor_timbrado.php">Proveedor Timbrado</a>
                                    <li><a href="../empresas/empresa.php">Empresa</a>
                                    <li><a href="../items/item.php">Items</a>
                                    <li><a href="../marcas/marca.php">Marcas</a>
                                    <li><a href="../marcas_items/marca_item.php">Marcas - Items</a>
                                    <li><a href="../motivos_ajustes/motivo_ajuste.php">Motivo Ajuste</a>
                                    <li><a href="../sucursales/sucursales.php">Sucursal</a>
                                    <li><a href="../tipo_ajustes/tipo_ajuste.php">Tipo Ajuste</a>
                                    <li><a href="../tipo_impuestos/tipo_impuesto.php">Tipo Impuesto</a>
                                    <li><a href="../tipo_items/tipo_item.php">Tipo de Item</a>
                                    <li><a href="../vehiculos/vehiculo.php">Vehiculo</a>
                                    <li><a href="../vehiculos_modelos/vehiculo_modelo.php">Vehiculo Modelos</a>
                                    <li><a href="../vehiculos_marcas/vehiculo_marca.php">Vehiculo Marcas</a></li>
                                </ul>
                            </li> 
                            <li><a><i class="fa fa-cut"></i> Referencial Servicios <span class="fa fa-chevron-down"></span></a>
                                <ul class="nav child_menu">
                                    <li><a href="../dias/dia.php">Dias</a></li> 
                                    <li><a href="../tipo_reclamos/tipo_reclamo.php">Tipo Reclamo</a></li>
                                </ul>
                            </li> 

                            <li><a><i class="fa fa-usd fa-fw"></i>Referencial Ventas<span class="fa fa-chevron-down"></span></a>
                                <ul class="nav child_menu">
                                    <li><a href="../cajas/caja.php">Caja</a>
                                    <li><a href="../timbrados/timbrado.php">Timbrados</a></li>
                                    <li><a href="../cajas_timbrados/caja_timbrado.php">Cajas - Timbrados</a></li>
                                    <li><a href="../forma_cobros/forma_cobro.php">Forma Cobro</a>
                                    <li><a href="../entidades_adheridas/entidad_adherida.php">Entidad Adherida</a>
                                    <li><a href="../entidades_emisoras/entidad_emisora.php">Entidad Emisora</a>
                                    <li><a href="../marca_tarjetas/marca_tarjeta.php">Marca Tarjeta</a>
                                </ul>
                            </li>
                        </ul>
                    
                    </div>
                    <div class="menu_section">
                        <h3 class="page-header" style="color: #ffffff;" > <font  face=" Century Gothic">MOVIMIENTOS </h3>
                        <ul class="nav side-menu">                  
                            <li><a><i class="fa fa-shopping-cart fa-fw "></i> Gestion Compras <span class="fa fa-chevron-down"></span></a>
                                <ul class="nav child_menu">                                    
                                    </li>
                                        <li class="sub_menu"><a href="../presupuestos_proveedores/presupuesto_proveedor.php">Presupuesto Proveedor</a></li>
                                        <li class="sub_menu"><a href="../pedido_compras/pedido_compra.php">Pedido de Compras</a></li>
                                        <li class="sub_menu"><a href="../ordenes_compra/orden_compra.php">Ordenes de Compras</a></li>
                                        <li class="sub_menu"><a href="../compras/compra.php">Compras</a></li>
                                        <li class="sub_menu"><a href="../ajustes/ajuste.php">Ajustes</a></li>
                                        <li class="sub_menu"><a href="../transferencias/transferencia.php">Tranferencias</a></li>
                                        <li class="sub_menu"><a href="../notas_compras/nota_compra.php">Nota de Compras</a></li>
                                    </li>
                                </ul>
                            </li> 
                                    
                            <li><a><i class="fa fa-cut"></i> Gestion Servicios <span class="fa fa-chevron-down"></span></a>
                                <ul class="nav child_menu">                              
                                    <li class="sub_menu"><a href="../promociones/promocion.php">Combo Promocional</a></li>
                                    <li class="sub_menu"><a href="../presupuestos/presupuesto.php">Presupuesto</a></li> 
                                    <li class="sub_menu"><a href="../agendas/agenda.php">Agendas</a></li>
                                    <li class="sub_menu"><a href="../reservas/reserva.php">Reservas de Turnos</a>
                                    <li><a href="../orden_trabajo/orden_trabajo.php">Orden Trabajo</a></li>
                                    <li><a href="../reclamos/reclamo.php">Reclamos / Sugerencias</a><li>
                                </ul>
                            </li> 
                                
                            <li><a><i class="fa fa-money "></i>Gestion Ventas<span class="fa fa-chevron-down"></span></a>
                                <ul class="nav child_menu">
                                    <li class="sub_menu"><a href="../orden_trabajo_confirmacion/orden_trabajo_conf.php">Confirmacion de trabajos</a></li>
                                    <li class="sub_menu"><a href="../pedido_ventas/pedido_venta.php">Pedido de Venta</a></li>
                                    <li><a href="../ventas/venta.php">Ventas</a></li>
                                    <li class="sub_menu"><a href="../aperturas_cierres/apertura_cierre.php">Apertura / Cierre / Arqueo </a></li>
                                    <li><a href="../cobros/cobro.php">Cobros</a></li>
                                    <li><a href="../notas_ventas/nota_venta.php">Notas Ventas</a></li>
                                    <li><a href="../notas_remisiones/nota_remision.php">Notas Remsiones</a></li>
                                </ul>
                            </li>
                        </ul>
                    </div>  
                </ul>
                <div class="menu_section">
                    <h3 class="page-header" style="color: #ffffff;" > <font  face=" Century Gothic">VARIOS</h3>
                    <ul class="nav side-menu"> 
                        <li><a><i class="fa fa-line-chart"></i> REPORTES <span class="fa fa-chevron-down"></span></a>
                            <ul class="nav child_menu">
                                <li><a href="../reportes_pedidos/reporte_pedido_compra.php">Pedido Compras</a></li>
                                <li><a href="../reportes_ordenes_compras/reporte_orden_compra.php">Ordenes Compras</a></li>
                                <li><a href="../reportes_compras/reporte_compra.php">Compras</a></li>
                                <li><a href="../reportes_promociones/reporte_promocion.php">Promociones</a></li>
                                <li><a href="../reportes_agendas/reporte_agenda.php">Agendas Funcionarios</a></li>
                                <li><a href="../reportes_reservas/reporte_reserva.php">Reporte de Reservas</a></li>
                                <!-- <li><a href="../reporte_ordenes_trabajos/reporte_orden_trabajo.php">Reporte de Ordenes Trabajos</a></li> -->
                                <li><a href="../reportes_pedidos_ventas/reporte_pedido_venta.php">Reporte de Pedido Ventas</a></li>
                            </ul>
                        </li>       
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="top_nav">
    <div class="nav_menu">
        <nav>
            <div class="nav toggle">
                <a id="menu_toggle"><i class="fa fa-bars"></i></a>
            </div>
            <ul class="nav navbar-nav navbar-right">
                <li class="">
                    <a href="javascript:;" class="user-profile dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                        <img src="<?php echo "$foto2"; ?>"  alt=""><?php echo $_SESSION['fun_nom'] ?>
                        <span class=" fa fa-angle-down"></span>
                    </a>
                    <ul class="dropdown-menu dropdown-usermenu pull-right">
                        <li><a href="../clases/cerrar_sesion.php"><i class="fa fa-sign-out pull-right"></i> Log Out</a></li>
                    </ul>
                </li>
            </ul>
        </nav>
    </div>
</div>
