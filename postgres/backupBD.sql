PGDMP     /                
    y        
   corregido3    9.3.2    13.1 �   |           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            }           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ~           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    207037 
   corregido3    DATABASE     i   CREATE DATABASE corregido3 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Spanish_Paraguay.1252';
    DROP DATABASE corregido3;
                postgres    false            �           0    0    SCHEMA public    ACL     �   REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    7            t           1255    207038    devolver_dias_int(date)    FUNCTION       CREATE FUNCTION public.devolver_dias_int(entrada date, OUT salida integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
     BEGIN
     salida = (
     case 
     when to_char(entrada,'d') = '1' then 1
     when to_char(entrada,'d') = '2' then 2
     when to_char(entrada,'d') = '3' then 3
     when to_char(entrada,'d') = '4' then 4
     when to_char(entrada,'d') = '5' then 5
     when to_char(entrada,'d') = '6' then 6
     when to_char(entrada,'d') = '7' then 7
  end);
  --select * from devolver_dias_int('27-09-2019')
  end
  $$;
 J   DROP FUNCTION public.devolver_dias_int(entrada date, OUT salida integer);
       public          postgres    false            u           1255    207039    ftrg_ajus_trans()    FUNCTION     �  CREATE FUNCTION public.ftrg_ajus_trans() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	declare retorno record;
		retorno1 record;
		ultcod integer;
begin
	if TG_OP = 'UPDATE' then
		for retorno1 in select * from transferencias_det where trans_cod = (select max(trans_cod) from transferencias_cab)loop
			if retorno1.trans_cantidad > retorno1.trans_cant_recibida then	
				select coalesce(max(ajus_cod),0)+1 into ultcod from ajustes_cab;
			      
				insert into ajustes_cab -- select * from transferencias_cab
				values(
					ultcod,
					current_timestamp,
					'PROCESADO',
					(select suc_cod from transferencias_cab order by trans_cod desc limit 1),
					(select emp_cod from sucursales where suc_cod = (select suc_cod from transferencias_cab order by trans_cod desc limit 1)),
					(select usu_cod from transferencias_cab order by trans_cod desc limit 1),
					(select fun_cod from usuarios where usu_cod = (select usu_cod  from transferencias_cab order by trans_cod desc limit 1)),
					'NEGATIVO'
				);
			
					insert into ajustes_det -- select *from ajustes_det
					values(
						ultcod,
						retorno1.dep_destino,
						retorno1.item_cod,
						3,
						(retorno1.trans_cantidad -  retorno1.trans_cant_recibida)
						
					);
					
			end if;
			perform sp_stock(retorno1.dep_destino,retorno1.item_cod, ((retorno1.trans_cantidad - retorno1.trans_cant_recibida)*-1) );
		end loop;	
	end if;
	return null ;
end
$$;
 (   DROP FUNCTION public.ftrg_ajus_trans();
       public          postgres    false            �           1255    207040    ftrg_ajus_trans1()    FUNCTION       CREATE FUNCTION public.ftrg_ajus_trans1() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	declare retorno record;
		retorno1 record;
		ultcod integer;
begin
	if TG_OP = 'UPDATE' then
			if new.trans_cantidad > new.trans_cant_recibida then	
				select coalesce(max(ajus_cod),0)+1 into ultcod from ajustes_cab;
			      
				insert into ajustes_cab -- select * from transferencias_cab
				values(
					ultcod,
					current_timestamp,
					'PROCESADO',
					(select suc_cod from transferencias_cab order by trans_cod desc limit 1),
					(select emp_cod from sucursales where suc_cod = (select suc_cod from transferencias_cab order by trans_cod desc limit 1)),
					(select usu_cod from transferencias_cab order by trans_cod desc limit 1),
					(select fun_cod from usuarios where usu_cod = (select usu_cod  from transferencias_cab order by trans_cod desc limit 1)),
					'NEGATIVO'
				);
			
					insert into ajustes_det -- select *from transferencias_det
					values(
						ultcod,
						new.dep_destino,
						new.item_cod,
						new.mar_cod,
						3,
						(new.trans_cantidad -  new.trans_cant_recibida)
						
					);
					
			end if;
			perform sp_stock(new.dep_destino,new.item_cod,new.mar_cod,((new.trans_cantidad - new.trans_cant_recibida)*-1) );	
	end if;
	return null ;
end
$$;
 )   DROP FUNCTION public.ftrg_ajus_trans1();
       public          postgres    false            �           1255    333840    ftrg_libro_ventas()    FUNCTION     �  CREATE FUNCTION public.ftrg_libro_ventas() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	declare retorno record;
		grav10 integer =0;
		grav5 integer =0;
		exenta integer =0;
begin
	for retorno in select * from ventas_det_items where ven_cod  = (select max(ven_cod) from ventas_cab) loop
		if retorno.item_cod in (select item_cod from items where tipo_imp_cod = 1 ) then -- items que gravan 10
-- 			select ven_precio into grav10 from ventas_det_items where ven_cod = (select max(ven_cod) from ventas_cab)
			grav10 = grav10 + retorno.ven_precio * retorno.ven_cantidad;

		end if;

		if retorno.item_cod in (select item_cod from items where tipo_imp_cod = 2 ) then -- items que gravan 5
-- 			select ven_precio into grav10 from ventas_det_items where ven_cod = (select max(ven_cod) from ventas_cab)
			grav5 = grav5 +  retorno.ven_precio * retorno.ven_cantidad;

		end if;

		if retorno.item_cod in (select item_cod from items where tipo_imp_cod = 3 ) then -- items que son exentas
-- 			select ven_precio into grav10 from ventas_det_items where ven_cod = (select max(ven_cod) from ventas_cab)
			exenta = exenta + retorno.ven_precio * retorno.ven_cantidad;

		end if;
	end loop;
		
	insert into libro_ventas -- select * from libro_ventas
		values( 
			(select max(ven_cod) from ventas_cab),
			(select max(ven_cod) from ventas_cab),
			exenta,
			grav5 - (grav5 /21),
			grav10 - (grav10 / 11),
			(grav5 / 21),
			(grav10 / 11)
			
		);
	
	return null;
-- 	select * from tipo_impuestos
end
$$;
 *   DROP FUNCTION public.ftrg_libro_ventas();
       public          postgres    false            �           1255    207041 R   listar_fun_ord_trab(integer, date, time without time zone, time without time zone)    FUNCTION     �  CREATE FUNCTION public.listar_fun_ord_trab(in_fun_cod integer, in_fecha date, in_hdesde time without time zone, in_hhasta time without time zone) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE retorno record;
BEGIN
	
	PERFORM * from ordenes_trabajos_det where fun_cod = in_fun_cod and  ((in_hdesde between orden_hdesde and orden_hhasta) or (in_hhasta between orden_hdesde and orden_hhasta))
	and orden_fecha = in_fecha::date;
	if found then	
		raise exception 'ESTE FUNCIONARIO YA POSEE UNA ORDEN DE TRABAJO PARA HOY EN ESA MISMA HORA';
	else
		raise notice 'FUNCIONARIO DISPONIBLE';
	end if;

	
-- select listar_fun_ord_trab(5,'2019-10-27','12:30','12:30')
-- select listar_fun_ord_trab(3,'2020-11-09','10:01','10:30')

-- select * from ordenes_trabajos_cab order by ord_trab_fecha desc
-- select * from ordenes_trabajos_det order by ord_trab_cod desc
-- select * from agendas where fun_agen = 5
END;
$$;
 �   DROP FUNCTION public.listar_fun_ord_trab(in_fun_cod integer, in_fecha date, in_hdesde time without time zone, in_hhasta time without time zone);
       public          postgres    false            w           1255    207042 S   listar_funcionarios1(integer, date, time without time zone, time without time zone)    FUNCTION       CREATE FUNCTION public.listar_funcionarios1(in_dia integer, in_fecha date, in_hdesde time without time zone, in_hhasta time without time zone, OUT agencod integer, OUT funagennom character varying, OUT funagen integer) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
	declare	retorno record;
begin

if(select count(fun_agen) from
 (select agen_cod,fun_agen, fun_agen_nom 
from v_agendas 
where (v_agendas.fun_agen not in (
    select fun_cod 
    from v_reservas_det
    where  fecha_reser = in_fecha 
        and  ((in_hdesde between reser_hdesde and reser_hhasta)
        or (in_hhasta between reser_hdesde and reser_hhasta))
)and dias_cod = in_dia and (in_hdesde between hora_desde and hora_hasta and in_hhasta between hora_desde and hora_hasta)))as nro) = 0 then   
	raise exception 'NO HAY FUNCIONARIOS DISPONIBLES';
end if; 

if(select count(fun_agen) from
 (select agen_cod,fun_agen, fun_agen_nom 
from v_agendas 
where (v_agendas.fun_agen not in (
    select fun_cod 
    from v_reservas_det 
    where  fecha_reser = in_fecha 
        and  ((in_hdesde between reser_hdesde and reser_hhasta)
        or (in_hhasta between reser_hdesde and reser_hhasta))
)and dias_cod = in_dia and (in_hdesde between hora_desde and hora_hasta and in_hhasta between hora_desde and hora_hasta)))as nro) > 0 then

	for retorno in (select agen_cod,fun_agen, fun_agen_nom 
	from v_agendas 
	where (v_agendas.fun_agen not in (
	    select fun_cod 
	    from v_reservas_det 
	    where  fecha_reser = in_fecha 
		and  ((in_hdesde between reser_hdesde and reser_hhasta)
		or (in_hhasta between reser_hdesde and reser_hhasta))
	)and dias_cod = in_dia and (in_hdesde between hora_desde and hora_hasta and in_hhasta between hora_desde and hora_hasta)))loop
		agencod := retorno.agen_cod;
		funagennom := retorno.fun_agen_nom;
		funagen :=retorno.fun_agen;
		return next;
	end loop;
end if;

-- select * from listar_funcionarios1(2,'24-09-2019','12:00:00','13:00:00')
-- select * from v_reservas_det
-- select * from v_agendas where dias_cod = 2

-- select * from v_agendas
end 
$$;
 �   DROP FUNCTION public.listar_funcionarios1(in_dia integer, in_fecha date, in_hdesde time without time zone, in_hhasta time without time zone, OUT agencod integer, OUT funagennom character varying, OUT funagen integer);
       public          postgres    false            �           1255    383092 ^   listar_funcionarios_disponibles(integer, date, time without time zone, time without time zone)    FUNCTION     �  CREATE FUNCTION public.listar_funcionarios_disponibles(in_dia integer, in_fecha date, in_hdesde time without time zone, in_hhasta time without time zone, OUT agencod integer, OUT funagennom character varying, OUT funagen integer, OUT contador integer) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
declare	agendaretorno record;
begin
	IF (select count(fun_cod) from v_agendas_cab
		where agen_cod in( select agen_cod from agendas_det where agen_cod in (
			select agen_cod from agendas_det where dias_cod = in_dia and ((in_hdesde between hora_desde and hora_hasta) and ( in_hhasta between hora_desde and hora_hasta)) 
		))) = 0 THEN
		
		raise exception 'NO EXISTE FUNCIONARIO CON AGENDA QUE COINCIDA CON LO SOLICITADO';
	END IF;
	

	for agendaretorno in select agen_cod, fun_cod, fun_nom from v_agendas_cab
	where agen_cod in( select agen_cod from agendas_det where agen_cod in (
		select agen_cod from agendas_det where dias_cod = in_dia and ((in_hdesde between hora_desde and hora_hasta) and ( in_hhasta between hora_desde and hora_hasta)) 
	)) loop
		if agendaretorno.fun_cod not in ( select fun_cod from reservas_det where 
			in_fecha = fecha_reser and ((in_hdesde between reser_hdesde and reser_hhasta) or ( in_hhasta between reser_hdesde and reser_hhasta)) ) then
				agencod 	:= agendaretorno.agen_cod;
				funagennom  := agendaretorno.fun_nom;
				funagen 	:= agendaretorno.fun_cod;
				return next;
		end if;
	end loop;
	

-- select * from reservas_det
-- select * from agendas_cab where agen_cod = 1 
-- select * from v_agendas_det where dias_cod = 3

-- select * from reservas_det
-- select * from listar_funcionarios_disponibles(5,'2021-09-16','08:00:00','12:00:00')
-- orden: india, infecha, hdesde, hhasta

end
$$;
 �   DROP FUNCTION public.listar_funcionarios_disponibles(in_dia integer, in_fecha date, in_hdesde time without time zone, in_hhasta time without time zone, OUT agencod integer, OUT funagennom character varying, OUT funagen integer, OUT contador integer);
       public          postgres    false            �           1255    251388 p   sp_agendas(integer, integer, integer, integer, time without time zone, time without time zone, integer, integer)    FUNCTION     8  CREATE FUNCTION public.sp_agendas(codigo integer, usucod integer, succod integer, funagen integer, horadesde time without time zone, horahasta time without time zone, diascod integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare ultcod integer;
		retorno record;
		/* ARREGLAR MI PROGRAMACION: LOS PARAMETROS PUES AHORA YA NO REQUIERO DE AGEN_CUPOS QUE ERA UN CAMPO DE LA TABLA */
begin
	select coalesce(max(agen_cod),0)+1 into ultcod from agendas;
	if operacion = 1 then -- insertar
		for retorno in select * from agendas where fun_agen = funagen loop
			if retorno.dias_cod = diascod and ((retorno.hora_desde between horadesde and horahasta)or (retorno.hora_hasta between horadesde and horahasta)) then
				raise exception 'ESTE FUNCIONARIO YA TIENE UNA AGENDA PARA ESTE DIA Y ESTA HORA EN ESPECIFICO';
			end if;
		end loop;
		insert into agendas
		values(
			ultcod,
			'ACTIVO',
			(select fun_cod from usuarios where usu_cod = usucod),
			usucod,
			succod,
			(select emp_cod from sucursales where suc_cod = succod),
			current_timestamp,
			funagen,
			horadesde,
			horahasta,
			diascod
			
		);
		raise notice 'INSERCION DE AGENDAS FUNCIONARIOS EXITOSA';
	end if;

	if operacion = 2 then -- modificar
		for retorno in select * from agendas where fun_agen = funagen loop
			if retorno.dias_cod = diascod and ((retorno.hora_desde between horadesde and horahasta)or (retorno.hora_hasta between horadesde and horahasta)) then
				raise exception 'ESTE FUNCIONARIO YA TIENE UNA AGENDA PARA ESTE DIA Y ESTA HORA EN ESPECIFICO';
			end if;
		end loop;
		
		update agendas set fun_agen = funagen, hora_desde = horadesde, hora_hasta = horahasta,dias_cod = diascod
		where agen_cod = codigo;
		raise notice 'MODIFICACION DE AGENDAS REALIZADA EXITOSAMENTE';
	end if;

	if operacion = 3 then -- eliminar
		delete from agendas where agen_cod = codigo;
		raise notice 'LA AGENDA HA SIDO ELIMINADA EXITOSAMENTE';
	end if;
	-- select sp_agendas(0,1,1,3,'20:00:01','20:20:00',10,1,1)
	-- 	ORDEN: codigo, usucod, succod, funagen, hdesde, hhasta, agencupos, diascod, operacion
end
$$;
 �   DROP FUNCTION public.sp_agendas(codigo integer, usucod integer, succod integer, funagen integer, horadesde time without time zone, horahasta time without time zone, diascod integer, operacion integer);
       public          postgres    false            �           1255    383080 Q   sp_agendas_full(integer, integer, character varying[], integer, integer, integer)    FUNCTION     J
  CREATE FUNCTION public.sp_agendas_full(codigo integer, funcod integer, detalles character varying[], succod integer, usucod integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE ultcod integer;
		dimension varchar = array_length(detalles, 1);
		retorno record;
BEGIN
	select coalesce(max(agen_cod), 0 ) + 1 into ultcod from agendas_cab;	
	--------------------------------- TRABAJAMOS POR LA CABECERA ------------------------------
	IF operacion = 1 then --insertar
		for retorno in select * from agendas_det where agen_cod in( select agen_cod from agendas_cab where fun_cod = funcod ) loop
			for i in 1..dimension loop
				if detalles[i][2]::time >= detalles[i][3]::time then
					raise exception 'LA HORA DESDE NO PUEDE SER MAYOR A LA HORA HASTA';
				end if;

				if retorno.dias_cod = detalles[i][1]::integer and (( retorno.hora_desde between detalles[i][2]::time and detalles[i][3]::time) or
						(retorno.hora_hasta between detalles[i][2]::time and detalles[i][3]::time)) then 
						raise exception 'EL FUNCIONARIO YA POSEE UNA AGENDA PARA ESTE RANGO DE HORAS';
				end if;
			end loop;
		end loop;
	
		insert into agendas_cab --(agen_cod, fun_cod, agen_fecha, agen_estado) -- select * from agendas_cab
		values(
			ultcod,
			funcod,
			current_timestamp,
			'ACTIVO',
			usucod,
			(select fun_cod from usuarios where usu_cod = usucod),
			succod,
			(select emp_cod from sucursales where suc_cod = succod)
		);
		--------------------------------- TRABAJAMOS POR EL DETALLE ------------------------------
		for i in 1..dimension loop
			insert into agendas_det --(agen_cod. dias_cod, hora_desde, hora_hasta)
			values(
				ultcod,
				detalles[i][1]::integer, -- dias_cod
				detalles[i][2]::time without time zone, -- hora_desde
				detalles[i][3]::time without time zone	-- hora_hasta
			);
		end loop;
		
		raise notice 'LA AGENDA DE FUNCIONARIO FUE REALIZADO EXITOSAMENTE';
	END IF;
	
	IF operacion = 2 then -- modificar
		delete from agendas_det where agen_cod = codigo;
		for i in 1..dimension loop
			insert into agendas_det
			values(
				codigo,
				detalles[i][1]::integer, -- dias_cod
				detalles[i][2]::time without time zone, -- hora_desde
				detalles[i][3]::time without time zone	-- hora_hasta
			);
		end loop;
		raise notice 'LA MODIFICACION FUE REALIZADA EXITOSAMENTE';
	END IF;
	
	IF operacion = 3 then -- anular
		update agendas_cab set 
			agen_estado = 'ANULADO'
		where agen_cod = codigo;
		
		raise notice 'LA ANULACION DE LA AGENDA FUE REALIZADO EXITOSAMENTE';
	END IF;
--	select sp_agendas_full (4, 2,'{{2, 14:00, 16:00}}',1  ,1 ,1)
-- select * from agendas_cab
END
$$;
 �   DROP FUNCTION public.sp_agendas_full(codigo integer, funcod integer, detalles character varying[], succod integer, usucod integer, operacion integer);
       public          postgres    false            �           1255    208635 U   sp_ajustes(integer, integer, integer, character varying, integer, integer[], integer)    FUNCTION     i  CREATE FUNCTION public.sp_ajustes(codigo integer, succod integer, usucod integer, ajustipo character varying, deposito integer, detalle integer[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare dimension integer = array_length(detalle, 1);
		ultcod integer;
		item integer;
		dep integer;
		item_cant_actual integer;
		detalle_ajus record;
		tipo_ajuste varchar(20);
begin
	-----------------------------TRABAJAMOS CON LA CABECERA DE AJUSTES ---------------------------
	
	select coalesce(max(ajus_cod),0)+1 into ultcod from ajustes_cab;
	if operacion = 1 then -- insertar
		insert into ajustes_cab
		values(
			ultcod,
			current_timestamp,
			'PROCESADO',
			succod,
			(select emp_cod from sucursales where suc_cod = succod),
			usucod,
			(select fun_cod from usuarios where usu_cod = usucod),
			upper(ajustipo)
		);
		
	 ----------------------------TRABAJAMOS CON LA DETALLE DE AJUSTES ---------------------------
		for i in 1..dimension loop -- mientras hay detalle en la grilla recorrera 
			insert into ajustes_det --(ajus_cod, dep_cod, item_cod,mar_cod mot_cod, ajus_cantidad)-- select * from ajustes_det
			values(ultcod,deposito,detalle[i][1], detalle[i][2], detalle[i][3], detalle[i][4]);

			if ajustipo = 'POSITIVO' then
			perform sp_stock(deposito,detalle[i][1],detalle[i][2],detalle[i][4]);-- select * from stock orden:dep_cod, item_cod, mar_cod, stock_cantidad
			/*
				item = detalle[i][1];
				dep = deposito;
				
				select stock_cantidad into item_cant_actual from stock where item_cod = item and dep_cod = dep;
				item_cant_actual = item_cant_actual + detalle[i][3];

				update stock set stock_cantidad = item_cant_actual where item_cod = item and dep_cod = dep;
			*/
			end if;
			
			if ajustipo = 'NEGATIVO' then
			if detalle[i][4] > (select stock_cantidad from stock where dep_cod = deposito and item_cod = detalle[i][1] and mar_cod =  detalle[i][2] ) then
				raise exception 'EL AJUSTE NO PUEDE SER MAYOR A LA CANTIDAD DISPONIBLE EN STOCK';
			else 
				perform sp_stock(deposito,detalle[i][1],detalle[i][2],detalle[i][4]*-1);-- select * from stock orden:dep_cod, item_cod, mar_cod, stock_cantidad

			end if;
			/*
				 item = detalle[i][1];
				dep = deposito;
				
				select stock_cantidad into item_cant_actual from stock where item_cod = item and dep_cod = dep;
				item_cant_actual = item_cant_actual - detalle[i][3];

				update stock set stock_cantidad = item_cant_actual where item_cod = item and dep_cod = dep;
			*/	
			end if;
			
		end loop;

		raise notice 'AJUSTE DE STOCK REALIZADO EXITOSAMENTE';
	end if;

	if operacion = 2 then -- anular
		if (select ajus_estado from ajustes_cab where ajus_cod = codigo) = 'ANULADO' then
			raise exception 'ESTE AJUSTE DE STOCK YA HA SIDO ANULADO';
		else
			-- actualizamos el estado de ajustes_cab a 'ANULADO'
			update ajustes_cab set ajus_estado = 'ANULADO' where ajus_cod = codigo;
			
			tipo_ajuste = (select ajus_tipo from ajustes_cab where ajus_cod = codigo); -- recuperamos que tipo de ajuste fue el que se realizo 
			
			-- retrocedemos los valores insertado en el stock 
			for detalle_ajus in select * from ajustes_det where ajus_cod = codigo loop
			
				if tipo_ajuste = 'POSITIVO' then
					if (select stock_cantidad from stock where item_cod = detalle_ajus.item_cod and mar_cod = detalle_ajus.mar_cod and dep_cod = detalle_ajus.dep_cod) < detalle_ajus.ajus_cantidad then
						raise exception ' NO PUEDE REALIZAR ESTA ANULACION PORQUE LA CANTIDAD A SER ANULADA ES MAYOR A LA CANTIDAD EN STOCK';
					else	
						update stock set stock_cantidad = stock_cantidad - detalle_ajus.ajus_cantidad where item_cod = detalle_ajus.item_cod and mar_cod = detalle_ajus.mar_cod and dep_cod = detalle_ajus.dep_cod;
					end if;	
				end if;
				
				if tipo_ajuste = 'NEGATIVO' then	
					update stock set stock_cantidad = stock_cantidad + detalle_ajus.ajus_cantidad where item_cod = detalle_ajus.item_cod and mar_cod = detalle_ajus.mar_cod and dep_cod = detalle_ajus.dep_cod;
				end if;
			end loop; 
			raise notice 'ANULACION DE AJUSTE DE STOCK EXITOSA';
		end if;	
	end if;
	-- select stock_cantidad from stock where item_cod = 1 and dep_cod = 1
	-- select * from ajustes_cab
	-- select * from ajustes_det
	-- select * from v_stock 
-- 	select * from stock
	
	--select sp_ajustes(0,1,1,'POSITIVO',1,'{{1,1,1,10}}',1)
	--ORDEN: codigo, succod, usucod, ajustipo,depcod, detalle[ itemcod, marcod, motcod, ajuscantidad], operacion
end
$$;
 �   DROP FUNCTION public.sp_ajustes(codigo integer, succod integer, usucod integer, ajustipo character varying, deposito integer, detalle integer[], operacion integer);
       public          postgres    false            x           1255    207046 A   sp_aperturas_cierres(integer, integer, integer, integer, integer)    FUNCTION     c  CREATE FUNCTION public.sp_aperturas_cierres(codigo integer, apermonto integer, cajacod integer, usucod integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare cierremonto integer;
retorno record;
begin
	if operacion = 1 then -- apertura
		for retorno in select * from cajas where  caja_cod = cajacod loop
			if retorno.usu_cod != usucod then
				raise exception 'ESTA CAJA NO ESTA ASIGNADA A USTED';
			end if;
		end loop;
		perform * from v_aperturas_cierres where usu_cod = (select usu_cod from cajas where caja_cod = cajacod) and fecha_cierreformato is null;
		if found then
			raise exception 'DEBE CERRAR ESTA CAJA PARA PODER REALIZAR UNA NUEVA APERTURA';
		else
			insert into aperturas_cierres 
			values(
				(select coalesce (max(aper_cier_cod),0)+1 from aperturas_cierres),
				current_timestamp,
				apermonto,
				null,
				0,
				cajacod,
				usucod,
				(select suc_cod from cajas where caja_cod = cajacod),
				(select emp_cod from cajas where caja_cod = cajacod),
				(select fun_cod from cajas where caja_cod = cajacod),
				(select timb_cod from v_timbrado_cajas where caja_cod  = cajacod order by tim_vighasta desc limit 1)
			);
			update cajas set caja_estado = 'ABIERTO' where caja_cod = cajacod;
			raise notice 'LA CAJA FUE ABIERTA EXITOSAMENTE';
		end if;
	end if;
	-- select sp_aperturas_cierres(1,150000,1,1) // para apertura
	--ORDEN: apercierrecod, apermonto, cajacod, operacion
	
	if operacion = 2 then -- cerrar
		for retorno in select * from aperturas_cierres where aper_cier_cod = codigo loop
			if retorno.caja_cod != cajacod then
				raise exception 'NO PUEDE CERRAR UNA CAJA QUE NO CORRESPONDE A LA APERTURA-CIERRE';
			end if;
		end loop;
		if (select caja_cod from v_aperturas_cierres where caja_cod = cajacod and aper_cier_cod = codigo)!= cajacod then
			raise exception 'TU NO PUEDES CERRAR ESTA CAJA';
		end if;
		perform * from v_aperturas_cierres where aper_cier_cod = codigo and fecha_cierreformato is not null;
		if found then
			raise exception 'LA CAJA YA FUE CERRADA';
		else
		select (aper_monto::integer + monto_efectivo::integer + monto_tarjeta::integer + monto_cheque::integer)into cierremonto from v_aperturas_cierres where aper_cier_cod = codigo;
			update aperturas_cierres set 
			aper_cier_fecha = current_timestamp,
			aper_cier_monto = cierremonto
			where aper_cier_cod = codigo;

			update cajas set caja_estado = 'CERRADO' where caja_cod = (select caja_cod from v_aperturas_cierres where aper_cier_cod = codigo);
			raise notice 'LA CAJA FUE CERRADA EXITOSAMENTE';
			
-- 			GENERAR RECAUDACIONES A DEPOSITAR
			insert into recaudaciones_dep values((select coalesce(max(recau_dep_cod),0)+1 from recaudaciones_dep),codigo);
		end if;
	end if;
		-- select sp_aperturas_cierres(1,100000,2,2)
		-- ORDEN: codigo, apermonto, cajacod, operacion
	if operacion = 3 then -- reabrir la caja
		for retorno in select * from aperturas_cierres loop
			if retorno.caja_cod != cajacod then
				raise exception 'NO PUEDE REABRIR UNA CAJA QUE NO CORRESPONDA A LA APERTURA-CIERRE';
			end if;
		end loop;
		
		perform * from v_aperturas_cierres where aper_cier_cod = codigo and  fecha_aperformato is not null and fecha_cierreformato is null;
		if found then 
			raise exception 'ESTA CAJA AÚN SIGUE ABIERTO';
		else 
			update aperturas_cierres set 
			aper_cier_fecha = null,
			aper_cier_monto = 0
			where aper_cier_cod = codigo;

			update cajas set caja_estado = 'ABIERTO' where caja_cod = cajacod;
			raise notice 'LA CAJA FUE REABIERTA';
		end if;
	end if;
	-- select sp_aperturas_cierres(1,200000,1,2)
	--ORDEN: apercierrecod, apermonto, cajacod, operacion
	--select * from aperturas_cierres    
	
end;
$$;
 �   DROP FUNCTION public.sp_aperturas_cierres(codigo integer, apermonto integer, cajacod integer, usucod integer, operacion integer);
       public          postgres    false            y           1255    207047 T   sp_bancos(integer, character varying, character varying, character varying, integer)    FUNCTION     P  CREATE FUNCTION public.sp_bancos(codigo integer, bannom character varying, bandir character varying, bantel character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into bancos
		values(
			(select coalesce(max(banco_cod),0)+1 from bancos),
			upper(bannom),
			upper(bandir),
			upper(bantel)
		);
		raise notice '%','EL BANCO'||upper(bannom)||' FUE INSERTADO';
	end if;
	if operacion = 2 then
		update bancos set
		banco_nom = upper(bannom),
		banco_dir = upper(bandir),
		banco_tel = upper(bantel)
		where banco_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then
		delete from bancos 
		where banco_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	--select sp_bancos(1,'itau','presidente franco c/ ayolas','0985-428-428',1)
end;
$$;
 �   DROP FUNCTION public.sp_bancos(codigo integer, bannom character varying, bandir character varying, bantel character varying, operacion integer);
       public          postgres    false            z           1255    207048 K   sp_cajas_or(integer, character varying, integer, integer, integer, integer)    FUNCTION       CREATE FUNCTION public.sp_cajas_or(codigo integer, cajadesc character varying, succod integer, cajaultrecibo integer, usucod integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare temporal varchar;
	tempusu integer;
begin

	if operacion = 1 then --insertar 
		select caja_desc into temporal from cajas where upper(caja_desc) = upper(cajadesc) and (caja_cod != codigo and suc_cod = succod); -- permite la insercion de una misma caja para distintas sucursales
		if found then 
			raise exception 'ESTA CAJA YA FUE REGISTRADA PARA ESTA SUCURSAL';
		else 
			select usu_cod into tempusu from cajas where usu_cod = usucod; -- controla que un usuario no posea mas de una caja
			if found then
				raise exception 'ESTE USUARIOS YA POSEE UNA CAJA ASIGNADA';
			else
				insert into cajas 
				values(
					(select coalesce(max(caja_cod),0)+1 from cajas),
					upper(cajadesc),
					'ACTIVO',
					succod,
					cajaultrecibo,
					(select emp_cod from sucursales where suc_cod = succod),
					usucod,
					(select fun_cod from usuarios where usu_cod = usucod)
					
				);
			end if;
		end if;
	end if;
	
	if operacion = 2 then -- modificar usuario
		if not (select caja_estado from cajas where caja_cod = codigo) != 'INACTIVO' then
			raise exception 'NO PUEDES MODIFICAR UNA CAJA QUE TIENE ESTADO INACTIVO';
		end if;
		select usu_cod into tempusu from cajas where usu_cod = usucod and caja_cod != codigo;
		if found then
			raise exception 'ESTE USUARIO YA POSEE UNA CAJA';
		else 
			update cajas set 
			usu_cod = usucod,
			fun_cod = (select fun_cod from usuarios where usu_cod = usucod),
			caja_ultrecibo = cajaultrecibo,
			caja_desc = cajadesc
			where caja_cod = codigo;
			raise notice 'LA CAJA FUE MODIFICADA EXITOSAMENTE';
		end if;
	end if;
	
	if operacion = 3 then -- abrir caja
		if caja_estado = 'INACTIVO' then
			raise exception 'NO PUEDE ABRIR ESTA CAJA PORQUE ESTA INACTIVO';
		else
			update cajas set caja_estado = 'ABIERTO' where caja_cod = codigo;
			raise notice 'LA CAJA FUE ABIERTA EXITOSAMENTE';
		end if;	
	end if;
	
	if operacion = 4 then -- cerrar caja
		if not caja_estado = 'ABIERTO' then
			raise exception 'ESTA CAJA NO TIENE UN ESTADO ABIERTO';
		else
			update cajas set caja_estado = 'CERRADO' where caja_cod = codigo;
			raise notice 'LA CAJA FUE CERRADO EXITOSAMENTE';
		end if;
	end if;
	
	if operacion = 5 then --  caja en Estado 'INACTIVO'
		if (select caja_estado from cajas where caja_cod = codigo) = 'ABIERTO'  then
			raise exception 'NO PUEDE DESACTIVAR ESTA CAJA PORQUE NO TIENE ESTADO ABIERTO';
		else 
			update cajas set caja_estado = 'INACTIVO' where caja_cod = codigo;
			raise notice 'LA CAJA FUE DESACTIVADA EXITOSAMENTE';
		end if;
	end if;
	
	if operacion = 6 then -- caja en estado 'ACTIVO'
		if (select caja_estado from cajas where caja_cod = codigo) = 'ABIERTO' or (select caja_estado from cajas where caja_cod = codigo)= 'CERRADO' then -- solo se puede activar una caja con estado inactivo
			raise exception 'ESTA CAJA YA ESTA ACTIVO';
		else
			update cajas set caja_estado = 'ACTIVO' where caja_cod = codigo;
			raise notice 'LA CAJA FUE ACTIVADA EXITOSAMENTE';
		end if;	
	end if;
	-- select sp_cajas_or(3,'',0,0,0,5)
	
	-- select sp_cajas_or(1,'caja 2',1,1,2,1)
	--ORDEN: codifo, cajadesc, succod,cajaultrecibo,usucod,operacion
	-- select * from cajas 
end
$$;
 �   DROP FUNCTION public.sp_cajas_or(codigo integer, cajadesc character varying, succod integer, cajaultrecibo integer, usucod integer, operacion integer);
       public          postgres    false            {           1255    207049 .   sp_cargos(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_cargos(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into cargos
		values(
			(select coalesce(max(car_cod),0)+1 from cargos),
			upper(descripcion)
		);
		raise notice '%',' EL CARGO '||upper(descripcion)||' FUE INSERTADO';
	end if;
	-- select sp_cargos(1,'recepcionista',2)
	if operacion = 2 then 
		update cargos set 
		car_desc = upper(descripcion)
		where car_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;

	if operacion = 3 then
		delete from cargos 
		where car_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
end;
$$;
 b   DROP FUNCTION public.sp_cargos(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            |           1255    207050 @   sp_cheques(integer, integer, integer, integer, integer, integer)    FUNCTION     )  CREATE FUNCTION public.sp_cheques(codigo integer, bancod integer, cheqtipo integer, cheqctanro integer, chequenro integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into cheque
		values(
			(select coalesce(max(cheque_cod),0)+1 from cheque),
			bancod,
			cheqtipo,
			cheqctanro,
			chequenro
		);
		raise notice 'EL CHEQUE FUE INSERTADO';
	end if;
	if operacion = 2 then
		update cheque set
		banco_cod = bancod,
		cheque_tipo_cod = cheqtipo,
		cheque_cta_nro = cheqctanro,
		cheque_nro = chequenro
		where banco_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then
		delete from cheque 
		where cheque_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	--select sp_cheques(1,1,1,965400,256,2)
end;
$$;
 �   DROP FUNCTION public.sp_cheques(codigo integer, bancod integer, cheqtipo integer, cheqctanro integer, chequenro integer, operacion integer);
       public          postgres    false            }           1255    207051 9   sp_ciudades(integer, character varying, integer, integer)    FUNCTION     i  CREATE FUNCTION public.sp_ciudades(codigo integer, descripcion character varying, paiscod integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then --insertar
		insert into ciudades
		values(
			(select coalesce(max(ciu_cod),0)+1 from ciudades),
			upper(descripcion),
			paiscod
		);
		raise notice '%', 'LA CIUDAD '||upper(descripcion)||' FUE AGREGADA';
	end if;
	--select sp_ciudades(1,'ñemby',1,1)
	
	if operacion = 2 then -- modificar
		update ciudades set 
		ciu_desc = upper(descripcion),
		pais_cod = paiscod
		where ciu_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	--select sp_ciudades(1,'san lorenzo',1,2)
	
	 if operacion = 3 then --eliminar
		delete from ciudades
		where ciu_cod = codigo;

		raise notice '%','LA CIUDAD FUE ELIMINADA';
		
	 end if;

	 --select sp_ciudades(1,'ñemby',1,3)
end
$$;
 u   DROP FUNCTION public.sp_ciudades(codigo integer, descripcion character varying, paiscod integer, operacion integer);
       public          postgres    false            ~           1255    207052 7   sp_clasificaciones(integer, character varying, integer)    FUNCTION     	  CREATE FUNCTION public.sp_clasificaciones(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then 
		insert into clasificaciones
		values(
			(select coalesce(max(cla_cod),0)+1 from clasificaciones),
			upper(descripcion)
		);
		raise notice '%','LA CLASIFICACION '||upper(descripcion)||' FUE INSERTADA ';
	end if;

	if operacion =2 then 
		update clasificaciones set
		cla_desc = upper(descripcion)
		where cla_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;

	if operacion = 3 then 
		delete from clasificaciones
		where cla_cod = codigo;

		raise notice '%','LA CLASIFICACION'||upper(descripcion)||' FUE ELIMINADA';
	end if;

	--select sp_clasificaciones(2,'crema',2)
end
$$;
 k   DROP FUNCTION public.sp_clasificaciones(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false                       1255    207053 9   sp_clientes(integer, integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_clientes(codigo integer, percod integer, cliruc character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin 
	if operacion = 1 then
		insert into clientes
		values(
			(select coalesce(max(cli_cod),0)+1 from clientes),
			percod,
			'ACTIVO',
			upper(cliruc),
			current_date,
			null
		);
		raise notice 'EL CLIENTE FUE INSERTADO';
	end if;
	--select sp_clientes(1,1,'80025625-4',1) //  para insertar 
	
	if operacion = 2 then -- modificar
		update clientes set
		cli_ruc = upper(cliruc)
		where cli_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	--select sp_clientes(3,0,'80025624-4',2) // para modificar
	
	if operacion = 3 then -- desactivar
		update clientes set
		cli_estado = 'INACTIVO',
		cli_fecha_baja = current_date
		where cli_cod = codigo;

		raise notice 'DESACTIVACION EXITOSA';
	end if;
	--select sp_clientes(3,0,'',3) // para desactivar

	if operacion = 4 then -- activar
		update clientes set
		cli_estado = 'ACTIVO',
		cli_fecha_alta = current_date,
		cli_fecha_baja = null
		where cli_cod = codigo;

		raise notice 'ACTIVACION EXITOSA';
	end if;
	--select sp_clientes(3,0,'',4) // para activar
	
	
end;
$$;
 o   DROP FUNCTION public.sp_clientes(codigo integer, percod integer, cliruc character varying, operacion integer);
       public          postgres    false            �           1255    358464 z   sp_cobros(integer, integer, integer, integer, integer, integer, integer, integer[], character varying[], integer, integer)    FUNCTION     �  CREATE FUNCTION public.sp_cobros(codigo integer, cobefectivo integer, aperciercod integer, usucod integer, succod integer, fcobcod integer, vencod integer, detalletarjetas integer[], detallecheques character varying[], montodisponible integer, operacion integer) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
declare ultcod integer;
			dim_detalle_tarjetas integer = array_length(detalletarjetas, 1);
			dim_detalle_cheques varchar = array_length(detallecheques, 1);
			cuotaActual integer;
			pagoActual integer := 0;
			retorno  record;
			montoTotal integer;
			cuotasaldo integer;
			cuotapagar integer;
begin
	select coalesce(max(cobro_cod),0 ) + 1 into ultcod from cobros_cab;
		montoTotal := montoDisponible;
	
	if (select ven_estado from ventas_cab where ven_cod = vencod) = 'PAGADO' then 
		raise exception 'ESTA VENTA YA HA SIDO PAGADA EN SU TOTALIDAD';
	end if;
	if operacion = 1 then -- cobrar deuda
		insert into cobros_cab
		values(
			ultcod,
			current_timestamp,
			cobefectivo,
			'PAGADO',
			aperciercod,
			(select coalesce(max(cobro_recibo),0 ) + 1 from cobros_cab),
			usucod,
			(select fun_cod from usuarios where usu_cod = usucod),
			succod,
			(select emp_cod from sucursales where suc_cod = succod),
			fcobcod
		);
		------------------------ TRABAJAMOS CON EL DETALLE DE COBROS Y CUENTAS A COBRAR -----------------------------------
		for i in 1..(select count(ven_cod) from cuentas_cobrar where (ctas_estado = 'PENDIENTE' or ctas_estado = 'PARCIAL') and ven_cod = vencod) loop
				
			 	select ctas_saldo into cuotasaldo from cuentas_cobrar where ven_cod = vencod and ctas_cobrar_nro = 
				 (select coalesce(max(ctas_cobrar_nro), 0) + 1 from cuentas_cobrar where ctas_estado = 'PAGADO' and ven_cod = vencod);

				 select coalesce(max(ctas_cobrar_nro), 0) + 1 into cuotapagar from cuentas_cobrar where ctas_estado = 'PAGADO' and ven_cod = vencod;

				if montoTotal > 0 and montoTotal >= cuotasaldo  then -- aun hay plata para pagar una cuota de manera completa
					insert into cobros_det 	-- select * from cobros_det
					values(
						ultcod,
						vencod,
						cuotapagar,
						cuotasaldo
					 );
					update cuentas_cobrar set ctas_estado = 'PAGADO', ctas_saldo = 0, fecha_cobro = current_timestamp where ven_cod = vencod and ctas_cobrar_nro = cuotapagar;

				elseif montoTotal > 0 and cuotasaldo > 0 then  -- pago parcial
					insert into cobros_det 	-- select * from cobros_det
					values(
						ultcod,
						vencod,
						cuotapagar,
						montoTotal
					 );
				update cuentas_cobrar set ctas_estado = 'PARCIAL', ctas_saldo = (cuotasaldo - montoTotal), fecha_cobro = current_timestamp where ven_cod = vencod and ctas_cobrar_nro = cuotapagar;			end if;						
				montoTotal := montoTotal - cuotasaldo;

				if (select sum(ctas_saldo) from cuentas_cobrar where ven_cod = vencod) = 0 then -- La venta ya ha sido pagada completamente
					update ventas_cab set ven_estado = 'PAGADO' where ven_cod = vencod;
				end if;
-- 			raise notice '%', montoTotal;
		end loop;
		
		------------------------------ TRABAJAMOS CON LOS COBROS CON TARJETAS Y CHEQUES -----------------------------------------
		-- select * from formas_cobros
		if fcobcod = 2 then -- tarjetas
			if detalletarjetas != '{}' then
				for i in 1..dim_detalle_tarjetas loop
					insert into cobros_tarjetas 
					values(
						detalletarjetas[i][1], -- cobro_cod
						detalletarjetas[i][2], -- mar_tarj_cod
						detalletarjetas[i][3], -- cob_tarj_nro
						detalletarjetas[i][4], -- cod_auto
						detalletarjetas[i][5], -- ent_cod
						detalletarjetas[i][6], -- ent_ad_cod
						detalletarjetas[i][7]  -- tarj_monto
					);
				end loop;
			end if;
		end if;
		
		if fcobcod = 3 then -- cheques
			if detallecheques != '{}' then
				for i in 1..dim_detalle_cheques loop
					insert into cobros_cheques
					values(
						detallecheques[i][1]::integer, -- cobro_cod
						detallecheques[i][2]::integer, -- ch_cuenta_num
						detallecheques[i][3], 		   -- serie
						detallecheques[i][4]::integer, -- cheq_num
						detallecheques[i][5]::integer, -- cheq_importe
						detallecheques[i][6]::date, -- fecha_emision 
						current_date,		  -- fecha_recepcion
						null,				  -- fecha_cobro
						detallecheques[i][7], -- librador
						detallecheques[i][8]::integer, -- banco_cod 
						detallecheques[i][9]::integer, -- cheque_tipo_cod
						'RECIBIDO'
					);
				end loop;
			end if;
		end if;
		
		
		if fcobcod = 4 then -- todos
			if detalletarjetas != '{}' then
				for i in 1..dim_detalle_tarjetas loop
					insert into cobros_tarjetas 
					values(
						detalletarjetas[i][1], -- cobro_cod
						detalletarjetas[i][2], -- mar_tarj_cod
						detalletarjetas[i][3], -- cob_tarj_nro
						detalletarjetas[i][4], -- cod_auto
						detalletarjetas[i][5], -- ent_cod
						detalletarjetas[i][6], -- ent_ad_cod
						detalletarjetas[i][7]  -- tarj_monto
					);
				end loop;
			end if;
			-- select sp_cobros(0,80000, 1,1,1,4,31,'{{24,1,12314,1111,1,1,40000}}', '{}', 120000, 1)
			if detallecheques != '{}' then
				for i in 1..dim_detalle_cheques loop
					insert into cobros_cheques
					values(
						detallecheques[i][1]::integer, -- cobro_cod
						detallecheques[i][2]::integer, -- ch_cuenta_num
						detallecheques[i][3], 		   -- serie
						detallecheques[i][4]::integer, -- cheq_num
						detallecheques[i][5]::integer, -- cheq_importe
						detallecheques[i][6]::date, -- fecha_emision 
						current_date,		  -- fecha_recepcion
						null,				  -- fecha_cobro
						detallecheques[i][7], -- librador
						detallecheques[i][8]::integer, -- banco_cod 
						detallecheques[i][9]::integer, -- cheque_tipo_cod
						'RECIBIDO'
					);
				end loop;
			end if;
			-- select sp_cobros(0,20000, 1,1,1,4,30,'{{25,1,12314,1111,1,1,40000}}', '{{25,50001214,00,12646,40000,2021-06-03, Cristhian Flores,1,1}}', 120000, 1)
		end if;
		raise notice 'COBRO REALIZADO EXITOSAMENTE';
		
		-----------------------------ACTUALIZAMOS EL NUMERO DE FACTURA -------------------------------------
		if (select venta_nro_fact  from libro_ventas where ven_cod = vencod ) is null then
			-- insertamos el numero de factura en la cabecera de ventas_cab
			update libro_ventas set 
				venta_nro_fact   = (select siguiente_factura from v_aperturas_cierres where aper_cier_cod = aperciercod),
				timb_cod 		 = (select timb_cod from v_aperturas_cierres where aper_cier_cod = aperciercod),
				fecha_vdesde_tim = (select tim_vigdesde from timbrados where timb_cod = (select timb_cod from v_aperturas_cierres where aper_cier_cod = aperciercod)),
				fecha_vhasta_tim = (select tim_vighasta from timbrados where timb_cod = (select timb_cod from v_aperturas_cierres where aper_cier_cod = aperciercod)),
				fecha_factura = current_timestamp,
				cobro_cod = ultcod
			where ven_cod = vencod;
			
			
-- 			update ventas_cab set venta_nro_fact = (select siguiente_factura from v_aperturas_cierres where aper_cier_cod = aperciercod)
-- 			where ven_cod = vencod;
			-- actualizamos el ultimo numero de factura del timbrado
			update timbrados set tim_ultfactura = 
				(select coalesce(max(tim_ultfactura),0)+ 1 from timbrados where timb_cod = 
				(select timb_cod from aperturas_cierres where aper_cier_cod = aperciercod )) where timb_cod = (select timb_cod from aperturas_cierres where aper_cier_cod = aperciercod );
		end if;
	end if;
	
	
	
	-- select sp_cobros(0,200000, 1,1,1,1,35,'{{22,1,12314,1111,1,1,100000}}', '{}', 300000, 1) 
	-- Orden: codigo, cobefectivo, aperciercod, usucod, sucod, fcobcod, vencod, detTarjetas, detCheques, montoTotal, oper
--  select * from timbrados
-- 	select * from cobros_cab
-- 	select * from cobros_det
-- 	select * from cuentas_cobrar where ven_cod = 36
--  select * from ventas_cab 
--  select * from tipo_facturas -- 1. contado, 2. credito
-- 	select * from formas_cobros -- 1.Efectivo, 2.Tarjeta, 3.Cheques, 4.Todos
--	select * from ventas_cab
-- 	select * from cobros_cheques
-- 	select * from cobros_tarjetas

/*
	delete from cobros_det where ven_cod = 32
	delete from cobros_cab where cobro_cod = 20
	update cuentas_cobrar set ctas_saldo = 40000, ctas_estado = 'PENDIENTE', fecha_cobro = null where ven_cod = 32;
*/
end
$$;
   DROP FUNCTION public.sp_cobros(codigo integer, cobefectivo integer, aperciercod integer, usucod integer, succod integer, fcobcod integer, vencod integer, detalletarjetas integer[], detallecheques character varying[], montodisponible integer, operacion integer);
       public          postgres    false            �           1255    216901 v   sp_compras(integer, integer, character varying, date, integer, integer, integer, integer, integer, integer[], integer)    FUNCTION     W"  CREATE FUNCTION public.sp_compras(provcod integer, provtimbnro integer, nrofactura character varying, compfechafactura date, tipofactcod integer, compplazo integer, compcuotas integer, succod integer, usucod integer, detallecompra integer[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare ultcod integer; -- ultimo nro de compra
		dimension integer = array_length(detallecompra, 1);-- longitud de array para detalles compras
		act_stock record; -- sera el encargado de actualizar el stock


		--------variables cuentas a pagar ---------------------
		nro_cuota integer :=1;
		monto_total integer :=0;
		vencimiento_cuota date;
		monto_cuota integer;
		--------fin variables cuentas a pagar -----------------
		
		------------varibales libro_compras-------------------
		total_iva5 integer =0;
		total_iva10 integer =0;
		total_exenta integer =0;
		total_grav10 integer =0;
		total_grav5 integer  =0;


begin
	----------------------------TRABAJAMOS CON LA CABECERA DE COMPRAS ----------------------------------
	
	if operacion = 1 then -- insertar
		insert into compras_cab
		values(
			provcod,
			provtimbnro,
			nrofactura,
			current_timestamp,
			compfechafactura,
			'PENDIENTE',
			tipofactcod,
			compplazo,
			compcuotas,
			usucod,
			(select fun_cod from usuarios where usu_cod = usucod),
			succod,
			(select emp_cod from sucursales where suc_cod = succod)
				
		);
		
			

	
		for i in 1..dimension loop
		---------------------------ACTUALIZAMOS EL STOCK---------------------------------------
			perform sp_stock(detallecompra[i][5], detallecompra[i][1], detallecompra[i][2], detallecompra[i][3]);


			
	---------------------------TRABAJAMOS CON EL DETALLE DE COMPRAS---------------------------------
			insert into compras_det --(prov_cod,dep_cod,item_cod,mar_cod,comp_cantidad,comp_precio,tipo_imp_cod)
			values( -- select * from compras_det
				provcod,
				provtimbnro,
				nrofactura,
				detallecompra[i][5], -- deposito
				detallecompra[i][1], -- item
				detallecompra[i][2], -- marca
				detallecompra[i][3], -- cantidad
				detallecompra[i][4]  -- precio
			);
		
			monto_total:= monto_total + (detallecompra[i][3]*detallecompra[i][4]); -- monto total para cuentas a pagar 
	
			/*
			perform * from stock where dep_cod = detallecompra[i][1] and item_cod = detallecompra[i][2];
			if found then
				update stock set -- select * from stock
				stock_cantidad = stock_cantidad + detallecompra[i][3]
				where dep_cod = detallecompra[i][1] and item_cod = detallecompra[i][2];
			else
				insert into stock values(detallecompra[i][1], detallecompra[i][2], detallecompra[i][3]);
			end if;
			*/
		end loop;
			--------------------------------------------LIBRO COMPRAS ------------------------------------------- select * from items
			
			
			total_iva5 = (select round(((select sum(comp_precio)from compras_det where  item_cod in (select item_cod from items where tipo_imp_cod = 2) and prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura)*(select sum(comp_cantidad) from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 2) and prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura))/21));
			total_grav5 = ((select sum(comp_precio)from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 2) and prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura)*(select sum(comp_cantidad) from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 2) and prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura)) - total_iva5;
			
			total_iva10 = (select round(((select sum(comp_precio)from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 1) and prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura)*(select sum(comp_cantidad) from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 1) and prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura))/11));
			total_grav10 = ((select sum(comp_precio)from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 1) and prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura)*(select sum(comp_cantidad) from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 1) and prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura)) - total_iva10;

			total_exenta = (select (select sum(comp_precio)from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 3) and prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura)*(select sum(comp_cantidad) from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 3) and prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura));

			--------------------------------------------- LIBRO COMPRAS --------------------------------
			
				insert into libro_compras --(prov_cod, prov_timb_nro, nro_factura, comp_exenta, comp_gra5, comp_gra10, iva5, iva10) --select * from libro_compras
				values(provcod, provtimbnro, nrofactura ,total_exenta, total_grav5, total_grav10, total_iva5, total_iva10);
				

		
		---------------------TRABAJAMOS POR LA CUENTAS A PAGAR ---------------------------------
		if tipofactcod = 1 then -- contado
			update compras_cab set comp_estado = 'PAGADO' where prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura;
		end if;
		if tipofactcod = 2 then -- credito
			monto_cuota:= monto_total/compcuotas::integer;
			vencimiento_cuota:= compfechafactura+compplazo::integer;
			
			while nro_cuota <= compcuotas
			loop
				insert into cuentas_pagar --select * from cuentas_pagar
				(
					prov_cod, prov_timb_nro, nro_factura, ctas_pagar_nro, ctas_venc, ctas_monto, ctas_saldo, ctas_estado
				)
				values
				(
					provcod, provtimbnro, nrofactura, nro_cuota, vencimiento_cuota, monto_cuota, monto_cuota, 'PENDIENTE'
				);

				nro_cuota:= nro_cuota+1;
				vencimiento_cuota:= vencimiento_cuota + cast(compplazo as integer);
			end loop;
		end if;
		raise notice 'LA COMPRA FUE REALIZADA CON EXITO';
	end if;

	if operacion = 2 then -- anulacion
		if (select comp_estado from compras_cab where prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura) = 'PAGADO' then
			raise exception 'LA COMPRA NO PUEDE SER ANULADA PORQUE YA HA SIDO PAGADA';
		end if;
		if (select comp_estado from compras_cab where prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura) = 'ANULADO' then
			raise exception 'ESTA COMPRA YA HA SIDO ANULADO';
		end if;
		update compras_cab set comp_estado = 'ANULADO' where prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura;
		
		--update cuentas_pagar set ctas_estado = 'ANULADO' where comp_cod = codigo; 
		delete from cuentas_pagar where prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura; -- elimina las cuentas a pagar corresponiente a la compra anulada

		delete from libro_compras where prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura; -- elimina el libro_compras corresponiente a la compra anulada
		
		---------------------------------ANULACION EN STOCK-------------
		
		
		for act_stock in select * from compras_det where prov_cod = provcod and prov_timb_nro = provtimbnro and nro_factura = nrofactura loop -- select * from stock
		
			perform sp_stock(act_stock.dep_cod, act_stock.item_cod, act_stock.mar_cod, act_stock.comp_cantidad*-1);
			/*
			update stock set stock_cantidad = stock_cantidad - act_stock.comp_cantidad
			where dep_cod = act_stock.dep_cod and item_cod = act_stock.item_cod;
			*/
		end loop;
		
		raise notice 'ANULACION DE LA COMPRA EXITOSA';
	end if;
	-- select * from cuentas_pagar
	-- select * from compras_cab
	-- select * from compras_det
	-- select * from tipo_impuestos
	-- select * from compras_det order by comp_cod desc
	-- select sum(stock_cantidad)as stock from v_stock where item_cod = 5 and mar_cod = 1 and dep_cod = 1
	-- select * from v_stock where item_cod = 5 and mar_cod = 1
	
	-- select * from libro_compras order by comp_cod desc
	-- select * from items order by item_cod asc
	-- select * from items where tipo_imp_cod = 1
	-- select * from marcas_items

	-- select * from v_items where item_cod in (1,5)
	--select sp_compras(1,1,1,1,1,1,0,0,'2019-08-01',1,'001-001-0000025',1,'{{5,1,2,10000,1}}',1) 
	--ORDEN: compcod, nrocompra,succod,usucod,provcod,tipofactcod,compplazo,compcuotas,compfechafactura,provtimbcod,nrofactura,depcod, detallecompra[itemcod,compcant,comprecio,tipoimpuesto], operacion
end;
$$;
   DROP FUNCTION public.sp_compras(provcod integer, provtimbnro integer, nrofactura character varying, compfechafactura date, tipofactcod integer, compplazo integer, compcuotas integer, succod integer, usucod integer, detallecompra integer[], operacion integer);
       public          postgres    false            �           1255    383207 �   sp_compras_new(integer, integer, integer, date, character varying, date, integer, integer, integer, integer, integer, integer[], integer)    FUNCTION     ]  CREATE FUNCTION public.sp_compras_new(codigo integer, provcod integer, provtimbnro integer, provtimbvig date, nrofactura character varying, compfechafactura date, tipofactcod integer, compplazo integer, compcuotas integer, succod integer, usucod integer, detallecompra integer[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare ultcod integer; -- ultimo nro de compra
		dimension integer = array_length(detallecompra, 1);-- longitud de array para detalles compras
		act_stock record; -- sera el encargado de actualizar el stock

		--------variables cuentas a pagar ---------------------
		nro_cuota integer :=1;
		monto_total integer :=0;
		vencimiento_cuota date;
		monto_cuota integer;
		--------fin variables cuentas a pagar -----------------
		
		------------varibales libro_compras-------------------
		total_iva5 integer =0;
		total_iva10 integer =0;
		total_exenta integer =0;
		total_grav10 integer =0;
		total_grav5 integer  =0;

begin
	----------------------------TRABAJAMOS CON LA CABECERA DE COMPRAS ----------------------------------
	
	if provtimbvig < compfechafactura then
		raise exception 'EL TIMBRADO PARA ESTA FACTURA A CADUCADO';
	end if;
	
	select coalesce(max(comp_cod), 0) + 1 into ultcod from compras_cab;
	if operacion = 1 then -- insertar -- select * from compras_cab
		insert into compras_cab
		values(
			ultcod,
			provcod,
			provtimbnro,
			provtimbvig,
			nrofactura,
			current_timestamp,
			compfechafactura,
			'PENDIENTE',
			tipofactcod,
			compplazo,
			compcuotas,
			usucod,
			(select fun_cod from usuarios where usu_cod = usucod),
			succod,
			(select emp_cod from sucursales where suc_cod = succod)
				
		);
		
			

	
		for i in 1..dimension loop
		---------------------------ACTUALIZAMOS EL STOCK---------------------------------------
			perform sp_stock(detallecompra[i][6], detallecompra[i][1], detallecompra[i][2], detallecompra[i][3]);

			
	---------------------------TRABAJAMOS CON EL DETALLE DE COMPRAS---------------------------------
			insert into compras_det --(comp_cod,dep_cod,item_cod,mar_cod,comp_cantidad,comp_costo,comp_precio)
			values( -- select * from compras_det
				ultcod,
				detallecompra[i][6], -- deposito
				detallecompra[i][1], -- item
				detallecompra[i][2], -- marca
				detallecompra[i][3], -- cantidad
				detallecompra[i][4], -- costo
				detallecompra[i][5]  -- precio
			);
		
			monto_total:= monto_total + (detallecompra[i][3]*detallecompra[i][4]); -- monto total para cuentas a pagar 
			
		end loop;
			--------------------------------------------LIBRO COMPRAS ------------------------------------------- select * from items
			
			
			total_iva5 = (select round(((select sum(comp_costo)from compras_det where  item_cod in (select item_cod from items where tipo_imp_cod = 2) and comp_cod = ultcod)*(select sum(comp_cantidad) from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 2) and comp_cod = ultcod))/21));
			total_grav5 = ((select sum(comp_costo)from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 2) and comp_cod = ultcod)*(select sum(comp_cantidad) from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 2) and comp_cod = ultcod)) - total_iva5;
			
			total_iva10 = (select round(((select sum(comp_costo)from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 1) and comp_cod = ultcod)*(select sum(comp_cantidad) from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 1) and comp_cod = ultcod))/11));
			total_grav10 = ((select sum(comp_costo)from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 1) and comp_cod = ultcod)*(select sum(comp_cantidad) from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 1) and comp_cod = ultcod)) - total_iva10;

			total_exenta = (select (select sum(comp_costo)from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 3) and comp_cod = ultcod)*(select sum(comp_cantidad) from compras_det where item_cod in (select item_cod from items where tipo_imp_cod = 3) and comp_cod = ultcod));

			--------------------------------------------- LIBRO COMPRAS --------------------------------
			
				insert into libro_compras --(comp_cod, comp_exenta, comp_gra5, comp_gra10, iva5, iva10) --select * from libro_compras
				values(ultcod, total_exenta, total_grav5, total_grav10, total_iva5, total_iva10);
				

		
		---------------------TRABAJAMOS POR LA CUENTAS A PAGAR ---------------------------------
		if tipofactcod = 1 then -- contado
			update compras_cab set comp_estado = 'PAGADO' where comp_cod = ultcod;
		end if;
		if tipofactcod = 2 then -- credito
			monto_cuota:= monto_total/compcuotas::integer;
			vencimiento_cuota:= compfechafactura+compplazo::integer;
			
			while nro_cuota <= compcuotas
			loop
				insert into cuentas_pagar --select * from cuentas_pagar
				(
					comp_cod, ctas_pagar_nro, ctas_venc, ctas_monto, ctas_saldo, ctas_estado
				)
				values
				(
					ultcod, nro_cuota, vencimiento_cuota, monto_cuota, monto_cuota, 'PENDIENTE'
				);

				nro_cuota:= nro_cuota+1;
				vencimiento_cuota:= vencimiento_cuota + cast(compplazo as integer);
			end loop;
		end if;
		raise notice 'LA COMPRA FUE REALIZADA CON EXITO';
	end if;

	if operacion = 2 then -- anulacion
		if (select comp_estado from compras_cab where comp_cod = codigo) = 'PAGADO' then
			raise exception 'LA COMPRA NO PUEDE SER ANULADA PORQUE YA HA SIDO PAGADA';
		end if;
		if (select comp_estado from compras_cab where comp_cod = codigo) = 'ANULADO' then
			raise exception 'ESTA COMPRA YA HA SIDO ANULADO';
		end if;
		update compras_cab set comp_estado = 'ANULADO' where comp_cod = codigo;
		
		--update cuentas_pagar set ctas_estado = 'ANULADO' where comp_cod = codigo; 
		delete from cuentas_pagar where comp_cod = codigo; -- elimina las cuentas a pagar corresponiente a la compra anulada

		delete from libro_compras where comp_cod = codigo; -- elimina el libro_compras corresponiente a la compra anulada
		
		---------------------------------ANULACION EN STOCK-------------
		
		
		for act_stock in select * from compras_det where comp_cod = ultcod loop -- select * from stock
		
			perform sp_stock(act_stock.dep_cod, act_stock.item_cod, act_stock.mar_cod, act_stock.comp_cantidad*-1);
			/*
			update stock set stock_cantidad = stock_cantidad - act_stock.comp_cantidad
			where dep_cod = act_stock.dep_cod and item_cod = act_stock.item_cod;
			*/
		end loop;
		
		raise notice 'ANULACION DE LA COMPRA EXITOSA';
	end if;
	-- select * from cuentas_pagar
	-- select * from compras_cab
	-- select * from compras_det
	-- select * from tipo_impuestos
	-- select * from compras_det order by comp_cod desc
	-- select sum(stock_cantidad)as stock from v_stock where item_cod = 5 and mar_cod = 1 and dep_cod = 1
	-- select * from v_stock where item_cod = 5 and mar_cod = 1
	
	-- select * from libro_compras order by comp_cod desc
	-- select * from items order by item_cod asc
	-- select * from items where tipo_imp_cod = 1
	-- select * from marcas_items
	

	-- select * from v_items where item_cod in (1,5)
	-- select sp_compras_new(1,1,12345678,'30-04-2022','001-001-0000025','15-09-2021',2,30,2,1,1,'{{5,1,2,10000,25000,1}}',1) 
	--ORDEN: compcod,provcod,provtimbnro,provtimbvig,nro_factura,comp_fechafactura,tipofactcod,compplazo,compcuotas,succod,usucod,detallecompra[compcod,itemcod, marcod, cant,costo,precio,depcod ], operacion
end;
$$;
 *  DROP FUNCTION public.sp_compras_new(codigo integer, provcod integer, provtimbnro integer, provtimbvig date, nrofactura character varying, compfechafactura date, tipofactcod integer, compplazo integer, compcuotas integer, succod integer, usucod integer, detallecompra integer[], operacion integer);
       public          postgres    false            �           1255    207056 C   sp_depositos(integer, integer, integer, character varying, integer)    FUNCTION     G  CREATE FUNCTION public.sp_depositos(codigo integer, empcod integer, succod integer, depdesc character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into depositos
		values(
			(select coalesce(max(dep_cod),0)+1 from depositos),
			empcod,
			succod,
			upper(depdesc),
			'ACTIVO'
		);
		raise notice '%','EL DEPOSITO '||upper(depdesc)||' FUE INSERTADO';
	end if;
	
	if operacion = 2 then --modificar
		update depositos set
		dep_desc = upper(depdesc)
		where dep_cod = codigo;
		raise notice 'MODIFICACION EXITOSA';
	end if;
	

	if operacion = 3 then --DESACTIVAR
		update depositos set
		dep_estado = 'INACTIVO'
		where dep_cod = codigo;

		raise notice 'DESACTIVACION EXITOSA';
	end if;
		--select sp_depositos(1,1,1,'deposito 6',1)
		--ORDEN: codigo, empcod, succod, depdesc, operacion

		if operacion = 4 then --ACTIVAR
		update depositos set
		dep_estado = 'ACTIVO'
		where dep_cod = codigo;

		raise notice 'ACTIVACION EXITOSA';
	end if;
	
	
	--select sp_depositos(1,1,2,'deposito 1',1)
	-- select * from depositos
end;
$$;
 �   DROP FUNCTION public.sp_depositos(codigo integer, empcod integer, succod integer, depdesc character varying, operacion integer);
       public          postgres    false            �           1255    207057 /   sp_detalle_timbrados(integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.sp_detalle_timbrados(cajacod integer, timbcod integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare retorno record;
begin
	if operacion = 1 then -- insertar 
		for retorno in select * from v_timbrado_cajas loop
			if retorno.caja_cod = cajacod and
				(select tim_vighasta from v_timbrado_cajas vtc where vtc.caja_cod = cajacod and vtc.timb_estado = 'ACTIVO' order by tim_vighasta desc limit 1) > current_date then
				raise exception 'ESTA CAJA YA TIENE UN TIMBRADO AUN VIGENTE ASIGNADO';
			end if;
		end loop;
		insert into detalle_timbrados
		values(cajacod, timbcod);
		raise notice 'RElACION DE CAJA - TIMBRADA REALIZADA EXITOSAMENTE';
	end if;

	if operacion = 2 then -- modificar relacion caja - timbrado
		update detalle_timbrados set timb_cod = timbcod where caja_cod = cajacod;
		raise notice 'RElACION DE CAJA - TIMBRADA MODIFICADA EXITOSAMENTE';
	end if;
	-- select * from detalle_timbrados
end;
$$;
 `   DROP FUNCTION public.sp_detalle_timbrados(cajacod integer, timbcod integer, operacion integer);
       public          postgres    false            �           1255    207058 ,   sp_dias(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_dias(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into dias
		values(
			(select coalesce(max(dias_cod),0)+1 from dias),
			upper(descripcion)
		);
		raise notice '%','EL DIA'||upper(descripcion)||' FUE INSERTADO';
	end if;
	if operacion = 2 then
		update dias set
		dias_desc = upper(descripcion)
		where dias_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then
		delete from dias
		where dias_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	--select sp_dias(2,'lunes',3)
end;
$$;
 `   DROP FUNCTION public.sp_dias(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    207059 |   sp_empresas(integer, character varying, character varying, character varying, character varying, character varying, integer)    FUNCTION       CREATE FUNCTION public.sp_empresas(codigo integer, empnom character varying, empruc character varying, empdir character varying, emptel character varying, empemail character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into empresas
		values(
			(select coalesce(max(emp_cod),0)+1 from empresas),
			upper(empnom),
			upper(empruc),
			upper(empdir),
			upper(emptel),
			lower(empemail)
		);

		raise notice '%',' LA EMPRESA '||upper(empnom)||' FUE INSERTADA';
	end if;
	--select sp_empresas(1,'ASTORE','800668257','AZAHAREZ C/ RESEDAD','0985-429-428','astore@gmail.com',2)
	if operacion = 2 then
		update empresas set
		emp_nom = upper(empnom),
		emp_ruc = upper(empruc),
		emp_dir = upper(empdir),
		emp_tel = upper(emptel),
		emp_email = lower(empemail)
		where emp_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then
		delete from empresas
		where emp_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
end;
$$;
 �   DROP FUNCTION public.sp_empresas(codigo integer, empnom character varying, empruc character varying, empdir character varying, emptel character varying, empemail character varying, operacion integer);
       public          postgres    false            �           1255    207060 �   sp_entidades_adheridas(integer, integer, integer, character varying, character varying, character varying, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_entidades_adheridas(codigo integer, entcod integer, martarjcod integer, entadnom character varying, entaddir character varying, entadtel character varying, entademail character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	--declare duplicado integer;
begin
	if operacion = 1 then -- insertar
		insert into entidades_adheridas
		values(
			(select coalesce(max(ent_ad_cod),0)+1 from entidades_adheridas),
			entcod,
			martarjcod,
			upper(entadnom),
			upper(entaddir),
			upper(entadtel),
			lower(entademail)
		);
		raise notice '%','LA ENTIDAD ' ||upper(entadnom)||' FUE INSERTADO';
	end if;
	--select sp_entidades_adheridas(1,1,1,'cu','fulgencio yegros c/ mcal. lopez','0984-580-302','cu@gmail.com',1)
	--ORDEN: ent_ad_cod , ent_cod, marctarjcod,ent_ad_nom, ent_ad_dir, ent_ad_tel,ent_ad_email, operacion

	if operacion = 2 then -- modificar
		update entidades_adheridas set 
		ent_ad_nom = upper(entadnom),
		ent_ad_dir = upper(entaddir),
		ent_ad_tel = upper(entadtel),
		ent_ad_email = lower(entademail)
		where ent_ad_cod = codigo;

		raise notice 'LA MODIFICACION FUE EXITOSA';
	end if;
	
	--select sp_entidades_adheridas(1,1,1,'cu','fulgencio yegros c/ mcal. lopez','0984-580-302','cu@gmail.com',1)
	--ORDEN: ent_ad_cod , ent_cod, marctarjcod,ent_ad_nom, ent_ad_dir, ent_ad_tel,ent_ad_email, operacion
	
	if operacion = 3 then
		delete from entidades_adheridas where ent_ad_cod = codigo;
		raise notice 'LA ENTIDAD ADHERIDA FUE ELIMINADA';
	end if;
	
end
$$;
 �   DROP FUNCTION public.sp_entidades_adheridas(codigo integer, entcod integer, martarjcod integer, entadnom character varying, entaddir character varying, entadtel character varying, entademail character varying, operacion integer);
       public          postgres    false            �           1255    207061 s   sp_entidades_emisoras(integer, character varying, character varying, character varying, character varying, integer)    FUNCTION     '  CREATE FUNCTION public.sp_entidades_emisoras(codigo integer, entnom character varying, entdir character varying, enttel character varying, entemail character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then -- insertar
		insert into entidades_emisoras
		values(
			(select coalesce(max(ent_cod),0)+1 from entidades_emisoras),
			upper(entnom),
			upper(entdir),
			upper(enttel),
			lower(entemail)
		);
		raise notice '%','LA ENTIDAD ' ||upper(entnom)||' FUE INSERTADO';
	end if;

	if operacion = 2 then -- modificar
		update entidades_emisoras set 
		ent_nom = upper(entnom),
		ent_dir = upper(entdir),
		ent_tel = upper(enttel),
		ent_email = lower(entemail)
		where ent_cod = codigo;

		raise notice 'LA MODIFICACION FUE EXITOSA';
	end if;

	if operacion = 3 then
		delete from entidades_emisoras where ent_cod = codigo;
		raise notice 'LA ENTIDAD EMISORA FUE ELIMINADA';
	end if;
	--select sp_entidades_emisoras(1,'PROCARD','fulgencio yegros c/ eusebio ayala','0984-580-382','procard@gmail.com',2)
end
$$;
 �   DROP FUNCTION public.sp_entidades_emisoras(codigo integer, entnom character varying, entdir character varying, enttel character varying, entemail character varying, operacion integer);
       public          postgres    false            �           1255    207062 6   sp_especialidades(integer, character varying, integer)    FUNCTION     a  CREATE FUNCTION public.sp_especialidades(codigo integer, espdesc character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then -- insertar
		insert into especialidades
		values(
			(select coalesce(max(esp_cod),0)+1 from especialidades ),
			upper(espdesc),
			'ACTIVO'
		);
		raise notice '%','LA ESPECIALIDAD '||upper(espdesc)||' FUE INSERTADA';
	end if;
	
	if operacion = 2 then -- modificar
		update especialidades set esp_desc = upper(espdesc)
		where esp_cod = codigo;
		raise notice 'LA ESPECIALIDAD FUE MODIFICADO EXITOSAMENTE';
	end if;

	if operacion = 3 then -- desactivar
		update especialidades set esp_estado = 'INACTIVO' where esp_cod = codigo;
		raise notice 'LA ESPECIALIDAD FUE DESACTIVADA EXITOSAMENTE';
	end if;
	if operacion = 4 then -- activar
		update especialidades set esp_estado = 'ACTIVO' where esp_cod = codigo;
		raise notice 'LA ESPECIALIDAD FUE ACTIVADA EXITOSAMENTE';
	end if;
	--select sp_especialidades(1,'2019-07-21','doctor en ciencias de la comunicacion',1,1,1)
	--ORDEN: esp_cod, espfecha, espdesc, funcod, profcod,operacion
end;
$$;
 f   DROP FUNCTION public.sp_especialidades(codigo integer, espdesc character varying, operacion integer);
       public          postgres    false            v           1255    207063 7   sp_estados_civiles(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_estados_civiles(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into estados_civiles
		values(
			(select coalesce(max(esta_cod),0)+1 from estados_civiles),
			upper(descripcion)
		);
		raise notice '%','EL ESTADO CIVIL '||upper(descripcion)||' FUE INSERTADO';
	end if;
	if operacion = 2 then
		update estados_civiles set
		esta_desc = upper(descripcion)
		where esta_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then
		delete from estados_civiles
		where esta_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	
end;
$$;
 k   DROP FUNCTION public.sp_estados_civiles(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    207064 5   sp_formas_cobros(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_formas_cobros(codigo integer, fcobdesc character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into formas_cobros 
		values(
			(select coalesce(max(fcob_cod),0)+1 from formas_cobros),
			upper(fcobdesc)
		);
		raise notice 'LA FORMA DE COBRO FUE INSERTADA';
	end if;

	if operacion = 2 then
		update formas_cobros set fcob_desc = upper(fcobdesc)
		where fcob_cod = codigo;

		raise notice 'LA MODIFICACION FUE EXITOSA';
	end if;

	if operacion = 3 then
		delete from formas_cobros where fcob_cod = codigo;
		raise notice 'LA FORMA DE COBRO FUE ELIMINADA';
	end if;
	-- select sp_formas_cobros(1,'contado',1)
end;
$$;
 f   DROP FUNCTION public.sp_formas_cobros(codigo integer, fcobdesc character varying, operacion integer);
       public          postgres    false            �           1255    207065 E   sp_funcionarios(integer, integer, integer, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.sp_funcionarios(codigo integer, percod integer, carcod integer, profcod integer, espcod integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	--enviar de la siguiente forma para insertar -- select sp_funcionarios(3,1,1,1)
	
	if operacion = 1 then --insertar
		insert into funcionarios
		values(
			(select coalesce(max(fun_cod),0)+1 from funcionarios),
			percod,
			carcod,
			'ACTIVO',
			current_date,
			null,
			profcod,
			espcod
		);
		raise notice 'INSERCION EXITOSA';
	end if; 
		
	if operacion = 2 then -- modificar
		update funcionarios set
		car_cod = carcod,
		prof_cod = profcod,
		esp_cod = espcod
		where fun_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;

	--enviar de la siguiente forma para activar y desactivar -- select sp_funcionarios(3,0,0,3)
	
	if operacion = 3 then -- desactivar
		update funcionarios set
		fun_estado = 'INACTIVO',
		fun_fecha_baja = current_date
		where fun_cod = codigo;

		raise notice 'DESACTIVACION EXITOSA';
	end if;

	
	if operacion = 4 then -- activar
		update funcionarios set
		fun_estado = 'ACTIVO',
		fun_fecha_alta = current_date,
		fun_fecha_baja = null
		where fun_cod = codigo;

		raise notice 'ACTIVACION EXITOSA';
	end if;
	
end;
$$;
 �   DROP FUNCTION public.sp_funcionarios(codigo integer, percod integer, carcod integer, profcod integer, espcod integer, operacion integer);
       public          postgres    false            �           1255    207066 /   sp_generos(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_generos(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into generos
		values(
			(select coalesce(max(gen_cod),0)+1 from generos),
			upper(descripcion)
		);
		raise notice '%','EL GENERO '||upper(descripcion)||' FUE INSERTADO';
	end if;
	if operacion = 2 then
		update generos set
		gen_desc = upper(descripcion)
		where gen_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then
		delete from generos
		where gen_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	--select sp_estados_civiles(1,'soltero/a',1)
end;
$$;
 c   DROP FUNCTION public.sp_generos(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    207067 .   sp_grupos(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_grupos(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into perfiles 
		values(
			(select coalesce(max(perfil_cod),0)+1 from perfiles),
			upper(descripcion)
		);
		raise notice '%','EL GRUPO '||upper(descripcion)||' FUE INSERTADO';
	end if;

	if operacion = 2 then 
		update perfiles set
		perfil_desc = upper(descripcion)
		where perfil_cod = codigo;

		raise notice'MODIFICACION EXITOSA';
	end if;

	if operacion = 3 then 
		delete from perfiles
		where perfil_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	--select sp_grupos(3,'gerencia',1)
end;
$$;
 b   DROP FUNCTION public.sp_grupos(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    207068 u   sp_items(integer, integer, character varying, integer, integer, integer, integer, integer, integer, integer, integer)    FUNCTION       CREATE FUNCTION public.sp_items(codigo integer, tipoitem integer, itemdesc character varying, itemcosto integer, itemmin integer, itemmax integer, marcod integer, clacod integer, itemprecio integer, tipoimp integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare	ultcod integer;
begin
	select coalesce(max(item_cod),0)+1 into ultcod from items;
	if operacion = 1 then --insertar 
		insert into items
		values(
			ultcod,
			tipoitem,
			upper(itemdesc),
			itemcosto,
			itemmin,
			itemmax,
			marcod,
			clacod,
			'ACTIVO',
			itemprecio,
			tipoimp
		);
		raise notice '%','EL ITEM '||upper(itemdesc)||' FUE REGISTRADO';
	end if;

	if operacion = 2 then --modificar
		update items set
		item_desc = upper(itemdesc),
		item_costo = itemcosto,
		item_min = itemmin,
		item_max = itemmax,
		mar_cod = marcod,
		cla_cod = clacod,
		item_precio = itemprecio,
		tipo_imp_cod = tipoimp
		where item_cod = codigo;

		raise notice 'MODIFICACION EXITOSA'; 
	end if;
	--select sp_items(2,1,'',800,10,200,1,1,10,1,2) // PARA MODIFICAR CAMPOS	

	if operacion = 3 then -- desactivar producto
		update items set  item_estado = 'INACTIVO' where item_cod = codigo;
		raise notice '%','EL ITEM '||upper((select item_desc from items where item_cod = codigo))||' FUE DESACTIVADO';
	end if;  

	
	if operacion = 4 then -- activar producto
		update items set  item_estado = 'ACTIVO' where item_cod = codigo;
		raise notice '%','EL ITEM '||upper((select item_desc from items where item_cod = codigo))||' FUE ACTIVADO';
	end if;
	/*
	select sp_items(2,1,'hola',0,10,200,1,1,10,1,1)
--ORDEN: item_cod, tipoitem,itemdesc, itemcosto, itemmin, itemmax, marcod, clacod, itemprecio, tipoimp, operacion
	select * from tipo_items
	select * from items
	select * from marcas
	select * from clasificaciones
	
	*/
end;
$$;
 �   DROP FUNCTION public.sp_items(codigo integer, tipoitem integer, itemdesc character varying, itemcosto integer, itemmin integer, itemmax integer, marcod integer, clacod integer, itemprecio integer, tipoimp integer, operacion integer);
       public          postgres    false            �           1255    208606 S   sp_items_sin_marcas(integer, integer, character varying, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.sp_items_sin_marcas(codigo integer, tipoitem integer, itemdesc character varying, itemprecio integer, tipoimp integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare	ultcod integer;
begin
	select coalesce(max(item_cod),0)+1 into ultcod from items;
	if operacion = 1 then --insertar 
		insert into items
		values(
			ultcod,
			tipoitem,
			upper(itemdesc),
			'ACTIVO',
			itemprecio,
			tipoimp
		);
		raise notice '%','EL ITEM '||upper(itemdesc)||' FUE REGISTRADO';
	end if;
	
	if operacion = 2 then --modificar
		update items set
		item_desc = upper(itemdesc),
		item_precio = itemprecio,
		tipo_imp_cod = tipoimp
		where item_cod = codigo;

		raise notice 'MODIFICACION EXITOSA'; 
	end if;
		

	if operacion = 3 then -- desactivar producto
		update items set  item_estado = 'INACTIVO' where item_cod = codigo;
		raise notice '%','EL ITEM '||upper((select item_desc from items where item_cod = codigo))||' FUE DESACTIVADO';
	end if;  

	
	if operacion = 4 then -- activar producto
		update items set  item_estado = 'ACTIVO' where item_cod = codigo;
		raise notice '%','EL ITEM '||upper((select item_desc from items where item_cod = codigo))||' FUE ACTIVADO';
	end if;
	/*
		-- ORDER BY: codigo, tipoitem, itemdesc, itemprecio, tipoimp, operacion
		select sp_items_sin_marcas(12,1,'lima uña', 0, 1, 2)

		
	select * from tipo_items
	select * from items
	*/
end;
$$;
 �   DROP FUNCTION public.sp_items_sin_marcas(codigo integer, tipoitem integer, itemdesc character varying, itemprecio integer, tipoimp integer, operacion integer);
       public          postgres    false            �           1255    207069    sp_libro_compra(integer)    FUNCTION       CREATE FUNCTION public.sp_libro_compra(ultcod integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare total_iva5 integer:=0;
		total_iva10 integer:=0;
		total_exenta integer:=0;
		total_grav10 integer:=0;
		total_grav5 integer :=0;
		retorno record;
BEGIN

		for retorno in select * from compras_det where comp_cod = ultcod loop
			
				total_iva5 = total_iva5 + (select round(((select sum(comp_precio)from compras_det where (select tipo_imp_cod from items where item_cod = retorno.item_cod) = 2 and comp_cod = ultcod and item_cod = retorno.item_cod)*(select sum(comp_cantidad) from compras_det where (select tipo_imp_cod from items where item_cod = retorno.item_cod) = 2 and comp_cod = ultcod and item_cod = retorno.item_cod))/21));
				total_grav5 = total_grav5 + ((select sum(comp_precio)from compras_det where (select tipo_imp_cod from items where item_cod = retorno.item_cod) = 2 and comp_cod =ultcod and item_cod = retorno.item_cod)*(select sum(comp_cantidad) from compras_det where(select tipo_imp_cod from items where item_cod = retorno.item_cod) = 2 and comp_cod = ultcod and item_cod = retorno.item_cod)) - total_iva5;

				total_iva10 = total_iva10 + (select round(((select sum(comp_precio)from compras_det where (select tipo_imp_cod from items where item_cod = retorno.item_cod) = 1 and comp_cod = ultcod and item_cod = retorno.item_cod)*(select sum(comp_cantidad) from compras_det where (select tipo_imp_cod from items where item_cod = retorno.item_cod) = 1 and comp_cod = ultcod and item_cod = retorno.item_cod))/11));
				total_grav10 = total_grav10 + ((select sum(comp_precio)from compras_det where (select tipo_imp_cod from items where item_cod = retorno.item_cod) = 1 and comp_cod = ultcod and item_cod = retorno.item_cod)*(select sum(comp_cantidad) from compras_det where (select tipo_imp_cod from items where item_cod = retorno.item_cod) = 1 and comp_cod = ultcod and item_cod = retorno.item_cod)) - total_iva10;

				total_exenta = total_exenta + (select (select sum(comp_precio)from compras_det where (select tipo_imp_cod from items where item_cod = retorno.item_cod) = 3 and comp_cod = ultcod and item_cod = retorno.item_cod)*(select sum(comp_cantidad) from compras_det where (select tipo_imp_cod from items where item_cod = retorno.item_cod) = 3 and comp_cod = ultcod and item_cod = retorno.item_cod));
				
			perform * from libro_compras where comp_cod = ultcod;
			if not found then
				insert into libro_compras --(libro_comp_cod, comp_cod, comp_exenta, comp_gra5, comp_gra10, iva5, iva10) --select * from libro_compras
				values(2,ultcod,total_exenta, total_grav5, total_grav10, total_iva5, total_iva10);
			else
				update libro_compras set 
					comp_cod = ultcod,
					comp_exenta = total_exenta,
					comp_gra5 = total_grav5,
					comp_gra10 = total_grav10,
					iva5 = total_iva5,
					iva10 = total_iva10
				where comp_cod = ultcod;	
				/*
				if(select tipo_imp_cod from items where item_cod = retorno.item_cod) = 3 then
					update libro_compras set 
					 comp_exenta = comp_exenta + total_exenta
					where comp_cod = ultcod;
				end if;
				if(select tipo_imp_cod from items where item_cod = retorno.item_cod) = 2 then
					update libro_compras set 
					 comp_gra5 = comp_gra5 + total_grav5,
					 iva5 = iva5 + total_iva5
					where comp_cod = ultcod;
				end if;
				if(select tipo_imp_cod from items where item_cod = retorno.item_cod) = 1 then
					update libro_compras set 
					 comp_gra10 = comp_gra10 + total_grav10,
					 iva10 = iva10 + total_iva10
					where comp_cod = ultcod;
				end if;
				*/
			end if;	
		end loop;
			
		
		

END
$$;
 6   DROP FUNCTION public.sp_libro_compra(ultcod integer);
       public          postgres    false            �           1255    207070 6   sp_marca_tarjetas(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_marca_tarjetas(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into marca_tarjetas
		values(
			(select coalesce(max(mar_tarj_cod),0)+1 from marca_tarjetas ),
			upper(descripcion)
		);
		raise notice '%','LA MARCA DE TARJETA '||upper(descripcion)||' FUE INSERTADO';
	end if;
	if operacion = 2 then
		update marca_tarjetas set
		mar_tarj_desc = upper(descripcion)
		where mar_tarj_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then
		delete from marca_tarjetas 
		where mar_tarj_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	--select sp_marca_tarjetas(1,'visa',1)
end;
$$;
 j   DROP FUNCTION public.sp_marca_tarjetas(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    207071 .   sp_marcas(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_marcas(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into marcas
		values(
			(select coalesce(max(mar_cod),0)+1 from marcas),
			upper(descripcion)
		);
		raise notice '%','LA MARCA '||upper(descripcion)||' FUE INSERTADO';
	end if;
	if operacion = 2 then
		update marcas set
		mar_desc = upper(descripcion)
		where mar_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then
		delete from marcas  
		where mar_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	--select sp_tipo_items(1,'servicio',1)
end;
$$;
 b   DROP FUNCTION public.sp_marcas(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    208608 N   sp_marcas_items(integer, integer, integer, integer, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.sp_marcas_items(itemcod integer, marcod integer, itemcosto integer, itemprecio integer, itemmin integer, itemmax integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare retorno integer;
begin
	if operacion = 1 then --insertar 
		select item_cod from marcas_items into retorno where mar_cod = marcod and item_cod = itemcod;
		if found then
			raise exception 'ESTE ITEM CON ESTA MARCA YA EXISTE';
		end if;
		
		if itemcosto > itemprecio then
			raise exception 'EL PRECIO DEL ITEM NO PUEDE SER INFERIOR AL COSTO';
		else
			insert into marcas_items
			values(
				itemcod,
				marcod,
				itemcosto,
				itemprecio,
				itemmin,
				itemmax,
				'ACTIVO'
				
			);
			raise notice ' LA OPERACION FUE REGISTRADA EXITOSAMENTE';
		end if;
	end if;

	if operacion = 2 then --modificar
		if itemcosto > itemprecio then
			raise exception 'EL PRECIO DEL ITEM NO PUEDE SER INFERIOR AL COSTO';
		else
			update marcas_items set
			costo = itemcosto,
			precio = itemprecio,
			item_min = itemmin,
			item_max = itemmax
			where item_cod = itemcod and mar_cod = marcod;
			
			raise notice 'MODIFICACION EXITOSA'; 
		end if;
	end if;

	if operacion = 3 then -- desactivar producto
		update marcas_items set  item_estado = 'INACTIVO' where item_cod = itemcod and mar_cod = marcod;
		raise notice '%','EL ITEM FUE DESACTIVADO';
	end if;  

	
	if operacion = 4 then -- activar producto
		update marcas_items set  item_estado = 'ACTIVO' where item_cod = itemcod and mar_cod = marcod;
		raise notice '%','EL ITEM FUE ACTIVADO';
	end if;

	if operacion = 5 then -- eliminar producto
		delete from marcas_items where item_cod = itemcod and mar_cod = marcod;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	/*
	-- ORDER: itemcod, marcod, itemcosto, itemprecio, itemmin, itemmax, operacion
	
	select  sp_marcas_items(1,3,12000,25000,10,100,5)
	
	select * from marcas_items
	select * from tipo_items
	select * from items
	select * from marcas
	*/
end;
$$;
 �   DROP FUNCTION public.sp_marcas_items(itemcod integer, marcod integer, itemcosto integer, itemprecio integer, itemmin integer, itemmax integer, operacion integer);
       public          postgres    false            �           1255    207072 6   sp_motivo_ajustes(integer, character varying, integer)    FUNCTION     ;  CREATE FUNCTION public.sp_motivo_ajustes(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin -- FALTA VALIDAR AUN --
	if operacion = 1 then -- insertar
		insert into motivo_ajustes
		values((select coalesce(max(mot_cod),0)+1 from motivo_ajustes), upper(descripcion));
		raise notice '%','EL TIPO AJUSTE '||upper(descripcion)||' FUE INSERTADO';
	end if;

	if operacion = 2 then -- modificar
		update motivo_ajustes set mot_desc = upper(descripcion)where mot_cod = codigo;
		raise notice 'MODIFICACION EXITOSA';
	end if;

	if operacion = 3 then -- eliminar
		delete from motivo_ajustes where mot_cod = codigo;
		raise notice 'EL MOTIVO AJUSTE FUE ELIMINADO';
	end if;
	--select sp_motivo_ajustes(1,'sobrantes','positivo',1)
	-- select * from motivo_ajustes
end
$$;
 j   DROP FUNCTION public.sp_motivo_ajustes(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    218606 �   sp_notas_compras(integer, integer, integer, character varying, character varying, integer, integer, integer, character varying, text[], integer)    FUNCTION     p  CREATE FUNCTION public.sp_notas_compras(notanro integer, provcod integer, provtimbnro integer, nrofactura character varying, notatipo character varying, usucod integer, succod integer, notamonto integer, notadesc character varying, detalle text[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare dimension integer = array_length(detalle, 1);
		retorno record;
begin
	if operacion = 1 then -- insertar
		-------------------------------------TRABAJAMOS CON LA CABECECERA DE NOTAS COMPRAS ---------------------------------
		insert into notas_com_cab -- select * from notas_com_cab
		values(
			notanro,
			provcod,
			provtimbnro,
			nrofactura,
			current_timestamp,
			'REGISTRADO',
			upper(notatipo),
			(select fun_cod from usuarios where usu_cod = usucod),
			usucod,
			succod,
			(select emp_cod from sucursales where suc_cod = succod),
			notamonto,
			notadesc
		);
		

		if notatipo = 'CREDITO' then  -- VER EN CASO DE NOTA DEBITO
			
			for i in 1..dimension loop
				-------------------------------------AJUSTAMOS EL STOCK ---------------------------------
				
				perform sp_stock(detalle[i][5]::integer, detalle[i][1]::integer, detalle[i][2]::integer, detalle[i][3]::integer);
				
				
				-------------------------------------TRABAJAMOS CON LA DETALLE DE NOTAS COMPRAS ---------------------------------
				insert into notas_com_det -- (nota_com_nro, prov_cod, prov_timb_nro, nro_factura, dep_cod, item_cod, mar_cod, nota_com_cant, nota_com_precio, nota_com_desc) -- select * from notas_com_det
				values(
					notanro,
					provcod,
					provtimbnro,
					nrofactura,
					detalle[i][5]::integer, --dep_cod
					detalle[i][1]::integer, --item_cod
					detalle[i][2]::integer, --mar_cod
					detalle[i][3]::integer, --nota_com_cant
					detalle[i][4]::integer, --nota_com_precio
					detalle[i][6]::text	--nota_desc
				);
			end loop;
		end if;

		raise notice 'INSERCION DE NOTA COMPRA EXITOSA';
	end if;


	if operacion = 2 then -- anular
		if (select nota_com_estado from notas_com_cab where nota_com_nro = notanro) = 'ANULADO' then
			raise exception 'YA SE HA ANULADO ESTE MOVIMIENTO';
		end if; 

		update notas_com_cab set nota_com_estado = 'ANULADO' where nota_com_nro = notanro;

		if (select nota_com_tipo from notas_com_cab where nota_com_nro = notanro) = 'CREDITO' then -- VER EN CASO DE NOTA DEBITO
			for retorno in select * from notas_com_det where nota_com_nro = notanro loop
				perform sp_stock(retorno.dep_cod, retorno.item_cod, retorno.mar_cod, (retorno.nota_com_cant *-1) );
			end loop;
		end if;

		raise notice 'ANULACION DE NOTA COMPRA EXITOSA';
	end if;
-- 		select sp_notas_compras(001235,1,12356782,'001-001-0000124','CREDITO',1,1,'{{1,1,10,30000,1,hola},{1,2,10,30000,1,hola}}',1)
	--ORDEN: notanro, provcod, provtimbnro, nrofactura, notatipo, usucod, succod, detalle[], operacion

-- select * from compras_cab
-- select * from stock where item_cod = 1 and mar_cod = 1 and dep_cod = 1
-- select * from proveedor_timbrados where prov_cod = 1
-- select * from notas_com_cab
-- select * from v_notas_compras_det
-- select * from stock
-- select nro_factura from compras_cab where comp_estado != 'ANULADO' 
end;	
$$;
 
  DROP FUNCTION public.sp_notas_compras(notanro integer, provcod integer, provtimbnro integer, nrofactura character varying, notatipo character varying, usucod integer, succod integer, notamonto integer, notadesc character varying, detalle text[], operacion integer);
       public          postgres    false            �           1255    399477 �   sp_notas_compras_new(integer, integer, date, integer, date, character varying, character varying, character varying, integer, integer, integer, character varying, text[], integer)    FUNCTION     �  CREATE FUNCTION public.sp_notas_compras_new(notanro integer, compcod integer, notacomfechafactura date, notacomtimbrado integer, notacomtimvighasta date, notacomfactura character varying, notatipo character varying, notacredmotivo character varying, usucod integer, succod integer, notamonto integer, notadesc character varying, detalle text[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare dimension integer = array_length(detalle, 1);
		retorno record;
		ultcod integer;
begin

	if notacomfechafactura > notacomtimvighasta then
		raise exception 'NO PUEDE SER LA FECHA DE FACTURA MAYOR A LA FECHA DE VIGENCIA HASTA DEL TIMBRADO';
	end if;
	
	select coalesce(max(nota_com_nro), 0) + 1 into ultcod from notas_com_cab;
	if operacion = 1 then -- insertar
		-------------------------------------TRABAJAMOS CON LA CABECECERA DE NOTAS COMPRAS ---------------------------------
		insert into notas_com_cab -- select * from notas_com_cab
		values(
			ultcod,
			compcod,
			notacomfechafactura,
			notacomtimbrado,
			notacomtimvighasta,
			notacomfactura,
			current_timestamp,
			'REGISTRADO',
			upper(notatipo),
			(select fun_cod from usuarios where usu_cod = usucod),
			usucod,
			succod,
			(select emp_cod from sucursales where suc_cod = succod),
			notamonto,
			notadesc,
			notacredmotivo
		);
		
		if notatipo = 'CREDITO' and notacredmotivo = 'DEVOLUCION' then  -- VER EN CASO DE NOTA DEBITO
			
			for i in 1..dimension loop
				-------------------------------------AJUSTAMOS EL STOCK ---------------------------------
				
				perform sp_stock(detalle[i][5]::integer, detalle[i][1]::integer, detalle[i][2]::integer, detalle[i][3]::integer);
				
				
				-------------------------------------TRABAJAMOS CON LA DETALLE DE NOTAS COMPRAS ---------------------------------
				insert into notas_com_det -- (nota_com_nro, comp_cod, dep_cod, item_cod, mar_cod, nota_com_cant, nota_com_precio, nota_com_desc) -- select * from notas_com_det
				values(
					ultcod,
					compcod,
					detalle[i][5]::integer, --dep_cod
					detalle[i][1]::integer, --item_cod
					detalle[i][2]::integer, --mar_cod
					detalle[i][3]::integer, --nota_com_cant
					detalle[i][4]::integer, --nota_com_precio
					detalle[i][6]::text	--nota_desc
				);
			end loop;
		end if;

		raise notice 'INSERCION DE NOTA COMPRA EXITOSA';
	end if;

	if operacion = 2 then -- anular
		if (select nota_com_estado from notas_com_cab where nota_com_nro = notanro) = 'ANULADO' then
			raise exception 'YA SE HA ANULADO ESTE MOVIMIENTO';
		end if; 

		update notas_com_cab set nota_com_estado = 'ANULADO' where nota_com_nro = notanro;

		if (select nota_com_tipo from notas_com_cab where nota_com_nro = notanro) = 'CREDITO' then -- VER EN CASO DE NOTA DEBITO
			for retorno in select * from notas_com_det where nota_com_nro = notanro loop
				perform sp_stock(retorno.dep_cod, retorno.item_cod, retorno.mar_cod, (retorno.nota_com_cant *-1) );
			end loop;
		end if;

		raise notice 'ANULACION DE NOTA COMPRA EXITOSA';
	end if;
	-- 	select sp_notas_compras_new(0,1,'06-10-2021',54613388, '30-04-2021','001-001-0007862','CREDITO','DESCUENTO',1,1,0,'','{{}}',1)
	-- 	select sp_notas_compras_new(0,1,'06-10-2021',54613388, '30-04-2021','001-001-0007862','CREDITO','DEVOLUCION',1,1,0,'','{{1,1,10,30000,1,hola}}',1)
	-- ORDEN: notanro, compcod, notacomfechafactura, notacomtimbrado, notacomtimvighasta, notacomfactura, notatipo, usucod, succod, notamonto, notadesc, detalle[], operacion

-- select * from compras_cab
-- select * from stock where item_cod = 1 and mar_cod = 1 and dep_cod = 1
-- select * from proveedor_timbrados where prov_cod = 1
-- select * from notas_com_cab
-- select * from notas_com_det
-- select * from stock
-- select nro_factura from compras_cab where comp_estado != 'ANULADO' 
end;
$$;
 k  DROP FUNCTION public.sp_notas_compras_new(notanro integer, compcod integer, notacomfechafactura date, notacomtimbrado integer, notacomtimvighasta date, notacomfactura character varying, notatipo character varying, notacredmotivo character varying, usucod integer, succod integer, notamonto integer, notadesc character varying, detalle text[], operacion integer);
       public          postgres    false            �           1255    432325 �   sp_notas_remisiones(integer, integer, integer, integer, character varying, numeric, date, character varying, numeric, integer, integer, text[], integer)    FUNCTION     n  CREATE FUNCTION public.sp_notas_remisiones(codigo integer, vencod integer, vehicod integer, chofercod integer, remisiontipo character varying, chofertib numeric, chofertimbvighasta date, choferfactura character varying, chofermonto numeric, usucod integer, succod integer, detalles text[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare dimension integer = array_length(detalles, 1);
			ultcod integer;
begin
	select coalesce(max(nota_rem_cod), 0 ) + 1 into ultcod from notas_remisiones_cab;
	if operacion = 1 then -- insertar
		insert into notas_remisiones_cab 
		values(
			ultcod,
			vencod,
			current_timestamp,
			'PROCESADO',
			vehicod,
			chofercod,
			remisiontipo,
			chofertib,
			chofertimbvighasta,
			choferfactura,
			chofermonto,
			usucod,
			(select fun_cod from usuarios where usu_cod = usucod),
			succod,
			(select emp_cod from sucursales where suc_cod = succod)
			
		);
		------------------- TRABAJAMOS CON EL DETALLE ------------------------------------
		for i in 1..dimension loop
			insert into notas_remisiones_det 
			values(
				ultcod,
				detalles[i][1]::integer,  -- item_cod
				detalles[i][2]::integer,  -- mar_cod
				detalles[i][3]::integer,  -- nota_rem_cant
				detalles[i][4]::integer   -- nota_rem_precio
			);
		end loop;
		
		raise notice 'LA NOTA DE REMISION FUE GENERADA EXITOSAMENTE';
	end if;
	
	if operacion = 2 then
		update notas_remisiones_cab set nota_rem_estado = 'ANULADO' where nota_rem_cod = codigo;
		
		raise notice 'LA ANULACION DE LA NOTA DE REMISION FUE REALIZADA CON EXITO';
	end if;
	-- select sp_notas_remisiones(1, 1, 1, 1, 'interno', 0, null, '', 0, 1, 1, '{{1,1,2,25000}}', 2)
	-- ORDEN: codigo, vencod, vehicod, chofercod, remisiontipo, chofertib, chofertimbvighasta, choferfactura, chofermonto, usu, suc, detalles, ope
	
	-- select * from notas_remisiones_cab
	-- select * from notas_remisiones_det
end
$$;
 4  DROP FUNCTION public.sp_notas_remisiones(codigo integer, vencod integer, vehicod integer, chofercod integer, remisiontipo character varying, chofertib numeric, chofertimbvighasta date, choferfactura character varying, chofermonto numeric, usucod integer, succod integer, detalles text[], operacion integer);
       public          postgres    false            �           1255    424070 �   sp_notas_ventas(integer, integer, character varying, integer, integer, character varying, character varying, numeric, character varying, integer, integer, text[], integer)    FUNCTION     M	  CREATE FUNCTION public.sp_notas_ventas(codigo integer, vencod integer, notavennrofact character varying, timbcod integer, clicod integer, notaventipo character varying, notavenmotivo character varying, notamonto numeric, notadescripcion character varying, usucod integer, succod integer, detalles text[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare ultcod integer;
		dimension integer = array_length(detalles, 1);
begin 
	select coalesce(max(nota_ven_cod), 0) + 1 into ultcod from notas_ven_cab;
	if operacion = 1 then  --insertar
		insert into notas_ven_cab 
		values(
			ultcod,
			vencod,
			notavennrofact,
			current_timestamp,
			'PROCESADO',
			timbcod,
			clicod,
			notaventipo,
			notavenmotivo,
			notamonto,
			notadescripcion,
			(select fun_cod from usuarios where usu_cod = usucod),
			usucod,
			succod,
			(select emp_cod from sucursales where suc_cod = succod)
		);
		------------------------------------- TRABAJAMOS CON EL DETALLE -------------------------------------------------
		
		if notaventipo = 'CREDITO' and notavenmotivo = 'ANULACION' then
			for i in 1..dimension loop
				insert into notas_ven_det 
				values(
					ultcod,
					detalles[i][1]::integer, -- dep_cod
					detalles[i][2]::integer, -- item_cod
					detalles[i][3]::integer, -- mar_cod
					detalles[i][5]::integer, -- nota_ven_cant
					detalles[i][4]::integer, -- nota_ven_precio
					detalles[i][6]::text -- nota_ven_desc
				);
			end loop;
		end if;		
		update timbrados set tim_ultfactura = 
				(select coalesce(max(tim_ultfactura),0)+ 1 from timbrados where timb_cod = timbcod) where timb_cod = timbcod;
				
		raise notice 'LA NOTA DE VENTAS FUE REALIZADA CON EXITO';
	end if;
	
	if operacion = 2 then --anular
		update notas_ven_cab set nota_ven_estado = 'ANULADO' where nota_ven_cod = codigo;
		
		raise notice 'LA NOTA DE VENTA FUE ANULADA';
	end if;
	
-- 	select * from notas_ven_cab
--  select * from notas_ven_det
-- 	select * from sp_notas_ventas(0, 1, '001-001-0000987', 7, 1, 'DEBITO', 'GASTO EXTRA', 100000, 'Gasto por fletes', 1, 1, '{}', 1) // debito
-- 	select * from sp_notas_ventas(0, 1, '001-001-0000987', 7, 1, 'CREDITO', 'DEVOLUCION', 0, '', 1, 1, '{{1,1,1,2,2500,desc}}', 1) // credito
--  ORDEN: codigo, vencod, notavenfact, timbcod, clicod, notaventipo, notavenmotivo, notamonto, notadescripcion, usu, suc, detalles[], ope
end
$$;
 C  DROP FUNCTION public.sp_notas_ventas(codigo integer, vencod integer, notavennrofact character varying, timbcod integer, clicod integer, notaventipo character varying, notavenmotivo character varying, notamonto numeric, notadescripcion character varying, usucod integer, succod integer, detalles text[], operacion integer);
       public          postgres    false            �           1255    207073 +   sp_ordencompra_intermedio(integer, integer)    FUNCTION     �   CREATE FUNCTION public.sp_ordencompra_intermedio(compcod integer, ordencod integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	insert into orden_compra values(1, 1);
	raise notice 'INSERCION EXITOSA' ;
end 
$$;
 S   DROP FUNCTION public.sp_ordencompra_intermedio(compcod integer, ordencod integer);
       public          postgres    false            �           1255    216784 e   sp_ordenes_compras(integer, integer, integer, integer, integer, integer, integer, integer[], integer)    FUNCTION     �  CREATE FUNCTION public.sp_ordenes_compras(codigo integer, ordenplazo integer, ordencuotas integer, succod integer, usucod integer, provcod integer, tipofacturacod integer, detalle integer[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare dimension integer = array_length(detalle, 1);
		ultcod integer;
begin		
	----------------------TRABAJAMOS POR LA CABECERA ORDENES COMPRAS----------------------------
	select coalesce(max(orden_nro),0)+1 into ultcod from ordcompras_cab;
	if operacion = 1 then-- insertar
		insert into ordcompras_cab
		values(
		ultcod,
		current_timestamp,
		ordenplazo,
		ordencuotas,
		'PENDIENTE',
		succod,
		(select emp_cod from sucursales where suc_cod = succod),
		usucod,
		(select fun_cod from usuarios where usu_cod = usucod),
		provcod,
		tipofacturacod
		);
		
	--------------------------AHORA TRABAJOMO POR EL DETALLE ORDENES COMPRAS -----------------
	
		for i in 1..dimension loop
			insert into ordcompras_det -- (orden_nro, item_cod, mar_cod, orden_cantidad, orden_precio) -- select * from ordcompras_det
			values(ultcod,detalle[i][1], detalle[i][2],detalle[i][3], detalle[i][4]);
		end loop;
		raise notice '%','LA ORDEN COMPRA NRO. '||ultcod||' FUE REALIZADA EXITOSAMENTE';
	end if;
	--select sp_ordenes_compras(1,0,0,1,2,1,1,'{{1,1,3,50000}}',1) // para insertar
	--ORDEN: ordencod,ordenplazo,ordencuotas,succod,usucod,provcod,tipofactcod, detalle[ ultcod,itemcod,marcod,ordencantidad,ordenprecio ], operacion

-- 	select * from ordcompras_cab
-- 	select * from ordcompras_cab

	if operacion = 2 then -- anular
		if not (select orden_estado from ordcompras_cab where orden_nro = codigo) = 'PENDIENTE' then
			raise exception 'NO PUEDES ANULAR ESTA ORDEN COMPRA';
		end if;
		update ordcompras_cab set orden_estado = 'ANULADO' where orden_nro = codigo;
		raise notice '%','LA ORDEN COMPRA '||codigo||' FUE ANULADA EXITOSAMENTE';
	end if;
	--select sp_ordenes_compras(1,0,0,0,0,0,0,'{{1,1,1,1}}',2) // para anular
	--ORDEN: ordencod,ordenplazo,ordencuotas,succod,usucod,provcod,tipofactcod, detalle[ ultcod,itemcod,marcod,ordencantidad,ordenprecio ], operacion
end
-- select * from ordcompras_cab
-- select * from ordcompras_det
$$;
 �   DROP FUNCTION public.sp_ordenes_compras(codigo integer, ordenplazo integer, ordencuotas integer, succod integer, usucod integer, provcod integer, tipofacturacod integer, detalle integer[], operacion integer);
       public          postgres    false            �           1255    207075 U   sp_ordenes_trabajos(integer, integer, integer, integer, character varying[], integer)    FUNCTION     *  CREATE FUNCTION public.sp_ordenes_trabajos(codigo integer, succod integer, clicod integer, usucod integer, detalle character varying[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare ultcod integer;
		dimension varchar = array_length(detalle, 1);
begin
         ---------------------------------------TRABAJAMOS POR LA CABECERA DE ORDENES DE TRABAJOS-----------------------------------
	select coalesce(max(ord_trab_cod),0)+1 into ultcod from ordenes_trabajos_cab; 
	if operacion = 1 then 
		for i in 1..dimension loop
			if detalle[i][3]::time without time zone > detalle[i][4]::time without time zone then
				raise exception 'LA HORA DESDE NO PUEDE SER MAYOR A LA HORA HASTA';
			end if;
		end loop;
		
		insert into ordenes_trabajos_cab(ord_trab_cod, ord_trab_nro, emp_cod, suc_cod, fun_cod, ord_trab_fecha, ord_trab_estado, cli_cod, usu_cod)--select * from ordenes_trabajos_cab
		values(
		ultcod,
		ultcod,
		(select emp_cod from sucursales where suc_cod = succod),
		succod,
		(select fun_cod from usuarios where usu_cod = usucod),
		current_timestamp,
		'PENDIENTE',
		clicod,
		usucod 
		);
		
		----------------------------------------------TRABAJAMOS POR LA CABECERA DE ORDENES DE TRABAJOS-----------------------------------
		
		for i in 1..dimension loop
			insert into ordenes_trabajos_det--(ord_trab_cod, item_cod, orden_precio, orden_hdesde, orden_hhasta, ord_trab_desc, fun_cod, orden_estado) -- select * from ordenes_trabajos_det
			values(
				ultcod,
				detalle[i][1]::integer,
				detalle[i][2]::integer,
				detalle[i][3]::time without time zone,
				detalle[i][4]::time without time zone,
				detalle[i][5]::varchar,
				detalle[i][6]::integer,
				'PENDIENTE',
				null,
				current_date
			);
		end loop;
		
		
		----------------------------------------------TRABAJAMOS POR LA TABLA  DE EQUIPOS DE TRABAJOS-----------------------------------
		/*
			for i in 1..dimension loop
				insert into equipos_trabajos --(equi_cod, fun_cod, ord_trab_cod, item_cod, equi_fecha, equi_desc) --select * from equipos_trabajos
				values(
					(select coalesce(max(equi_cod),0)+1 from equipos_trabajos),
					detalle2[i][1]::integer,
					ultcod,
					detalle2[i][2]::integer,
					current_date,
					detalle2[i][3]::varchar
				);
			end loop;
		*/
		raise notice 'LA INSERCION DE LA ORDEN DE TRABAJO FUE INSERTADA EXITOSAMENTE';
	end if;

	if operacion = 2 then -- ACTUALIZAR LA CABECERA  Y LOS DETALLES CON ESTADO 'PROCESADO'
		update ordenes_trabajos_cab set -- select * from ordenes_trabajos_cab
			ord_trab_estado = 'PROCESADO'
		where ord_trab_cod = codigo;

		update ordenes_trabajos_det set -- select * from ordenes_trabajos_det
			orden_estado = 'PROCESADO'
		where ord_trab_cod = codigo;
		
		raise notice '%','EL ORDEN NRO. '||codigo||' FUE PROCCESADO EXITOSAMENTE';
	end if;

	if operacion = 3 then -- ACTUALIZAR LA CABECERA Y LOS DETALLES CON ESTADO 'ANULADO'
		update ordenes_trabajos_cab set -- select * from ordenes_trabajos_cab
			ord_trab_estado = 'ANULADO'
		where ord_trab_cod = codigo;

		update ordenes_trabajos_det set -- select * from ordenes_trabajos_det
			orden_estado = 'ANULADO'
		where ord_trab_cod = codigo;

		raise notice '%','EL ORDEN NRO. '||codigo||' FUE ANULADO EXITOSAMENTE';
	end if;
	
	--	select * from sp_ordenes_trabajos(0,1,1,1,'{{1,20000,10:00,12:00,hola}}','{{2,1,hola}}',1)
	-- 	ORDEN: codigo, succod, clicod, usucod, detalle[itemcod, ordenprecio, hdesde, hhasta, ord_desc], detalle2[fun_cod, item_cod, equi_desc], operacion
end 
-- select * from ordenes_trabajos_cab
-- select * from ordenes_trabajos_det
-- select * from equipos_trabajos
$$;
 �   DROP FUNCTION public.sp_ordenes_trabajos(codigo integer, succod integer, clicod integer, usucod integer, detalle character varying[], operacion integer);
       public          postgres    false            �           1255    207076 .   sp_paises(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_paises(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into paises
		values(
			(select coalesce(max(pais_cod),0)+1 from paises),
			upper(descripcion)
		);

		raise notice '%','EL PAIS '||upper(descripcion)||' FUE INSERTADA';
	end if;
	
	if operacion = 2 then
		update paises set
		pais_desc = upper(descripcion)
		where pais_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	
	if operacion = 3 then
		delete from paises
		where pais_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	--select sp_paises(3,'brasil',2)
end;
$$;
 b   DROP FUNCTION public.sp_paises(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    216770 A   sp_pedidos_compras(integer, integer, integer, integer[], integer)    FUNCTION     �	  CREATE FUNCTION public.sp_pedidos_compras(codigo integer, succod integer, usucod integer, detalle integer[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare dimension integer = array_length(detalle, 1);
		ultcod integer;
begin
	-----------------------TRABAJAMOS PRIMERAMENTE CON LA CABECERA---------------------
	select coalesce(max(ped_nro),0)+1 into ultcod from pedidos_cab;
	if operacion = 1 then --insertar 
		insert into pedidos_cab -- select * from pedidos_cab
		values(
		ultcod,
		current_timestamp,
		'PENDIENTE',
		succod,
		(select emp_cod from sucursales where suc_cod = succod),
		(select fun_cod from usuarios where usu_cod = usucod),
		usucod
		);

	-----------------------AHORA TRABAJAMOS CON EL DETALLE----------------------------
	
		for i in 1..dimension loop -- recorre la matriz mientras aun haiga filas
			insert into pedidos_det -- (ped_cod, item_cod, mar_cod, ped_cantidad, ped_precio) -- select * from pedidos_det 
			values(ultcod, detalle[i][1], detalle[i][2], detalle[i][3], detalle[i][4]);
		end loop;

		raise notice 'EL PEDIDO COMPRA FUE REALIZADO EXITOSAMENTE';
	end if;

	if operacion = 2 then -- modificar

		delete from pedidos_det where ped_nro = codigo;
		
		for i in 1..dimension loop -- select * from pedidos_det
			insert into pedidos_det (ped_nro, item_cod, mar_cod, ped_cantidad, ped_precio)
			values(codigo, detalle[i][1], detalle[i][2], detalle[i][3], detalle[i][4]);
		end loop;
		raise notice 'MODIFICACION EXITOSA'; 
	end if;
		
		-- select * from pedidos_cab order by ped_nro desc
		-- select * from pedidos_det order by ped_nro desc
		
	-- select sp_pedidos_compras(1,1,1,'{{1,1,1,2000},{1,2,1,10000}}',1)// FORMA DE LLAMAR AL SP
	
	-- select sp_pedidos_compras(17,1,1,'{{1,1,1,122000},{1,2,1,150000}}',2)// FORMA DE LLAMAR AL SP
	--ORDEN: pedcod,succod,usucod, detalle[itemcod,marcod,pedcant,precio], operacion

	if operacion = 3 then -- ANULACION 
		if not (select ped_estado from pedidos_cab where ped_nro = codigo) = 'PENDIENTE' then
			raise exception 'NO PUEDE ANULAR ESTE PEDIDO';
		end if;
		update pedidos_cab set ped_estado = 'ANULADO' where ped_nro = codigo;
		raise notice '%','EL PEDIDO '||codigo||' FUE ANULADO';
	end if;

	
	-- select sp_pedidos_compras(2,1,1,'{{1,1,1}}',2) // PARA ANULAR
	--ORDEN: pedcod,succod,usucod, detalle[itemcod,pedcant,precio], operacion
	
	/*--estados del pedido
	 1- PENDIENTE
	 2- PROCESADO
	 3- ANULADO
	*/
end;
$$;
    DROP FUNCTION public.sp_pedidos_compras(codigo integer, succod integer, usucod integer, detalle integer[], operacion integer);
       public          postgres    false            �           1255    207078 R   sp_pedidos_ventas(integer, integer, integer, integer, integer, integer[], integer)    FUNCTION     }  CREATE FUNCTION public.sp_pedidos_ventas(codigo integer, succod integer, pednro integer, usucod integer, clicod integer, detalles integer[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare ultcod integer;
		dimension integer = array_length(detalles, 1);
begin
	---------------------------TRABAJAMOS POR LA CABECERA DE PEDIDOS VENTAS DETALLES---------------------------------
	select coalesce(max(ped_vcod),0)+1 into ultcod from pedidos_vcab;
	if operacion = 1 then -- insertar
		insert into pedidos_vcab
		values(
			ultcod,
			succod,
			(select emp_cod from sucursales where suc_cod = succod),
			current_timestamp,
			ultcod,
			'PENDIENTE',
			(select fun_cod from usuarios where usu_cod = usucod),
			clicod,
			usucod
		); -- select * from pedidos_vcab

	----------------------------TRABAJAMOS POR EL DETALLE DE VENTAS DETALLES-----------------------------------------
		for i in 1..dimension loop
		if detalles[i][3]:: integer <=0 or detalles[i][2]::integer <=0  then
			raise exception 'INGRESE VALORES VALIDOS';
		end if;
			insert into pedidos_vdet --(ped_vcod, item_cod,mar_cod, ped_cantidad, ped_precio) -- select * from pedidos_vdet
			values(ultcod,detalles[i][1], detalles[i][2], detalles[i][3], detalles[i][4]);
		end loop;
		raise notice 'EL PEDIDO DE VENTA FUE REGISTRADA';
	end if;
	-- select * from clientes
	-- select sp_pedidos_ventas(1,1,1,2,1,'{{1,2,15000}}',1)
	-- select sp_pedidos_ventas(4,0,0,0,0,'{{1,1,1}}',2)
	--ORDEN: codigo, succod, pednro, usucod, clicod, detalles[], operacion

	if operacion = 2 then -- anulacion
		if (select ped_estado from pedidos_vcab WHERE ped_vcod = codigo)= 'PROCESADO' then
			raise exception 'NO PUEDE ANULAR EL PEDIDO PORQUE YA HA SIDO PROCESADO';
		end if;
		update pedidos_vcab set ped_estado = 'ANULADO' where ped_vcod = codigo;
		raise notice 'EL PEDIDO VENTA HA SIDO ANULADO';
	end if;
-- 	select * from pedidos_vcab
end;
$$;
 �   DROP FUNCTION public.sp_pedidos_ventas(codigo integer, succod integer, pednro integer, usucod integer, clicod integer, detalles integer[], operacion integer);
       public          postgres    false            �           1255    251410 �   sp_personas(integer, character varying, character varying, character varying, character varying, character varying, date, character varying, integer, integer, integer, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.sp_personas(codigo integer, pernom character varying, perape character varying, perdir character varying, pertel character varying, perci character varying, perfenac date, peremail character varying, paiscod integer, ciucod integer, gencod integer, tipoper integer, estacod integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then -- insertar
		insert into personas
		values(
			(select coalesce(max(per_cod),0)+1 from personas),
			upper(pernom),
			upper(perape),
			upper(perdir),
			upper(pertel),
			upper(perci),
			perfenac,
			lower(peremail),
			paiscod,
			ciucod,
			gencod,
			tipoper,
			estacod
		);
		raise notice 'LA PERSONA FUE INSERTADA';
	end if;

	if operacion = 2 then --modificar
		update personas set
			per_nom = upper(pernom),
			per_ape = upper(perape),
			per_dir = upper(perdir),
			per_tel = upper(pertel),
			per_ci = upper(perci),
			per_fenac = perfenac,
			per_email = lower(peremail),
			pais_cod = paiscod,
			ciu_cod = ciucod,
			gen_cod = gencod,
			tipo_per_cod = tipoper,
			esta_cod = estacod
		where per_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';	
	end if;
	
	if operacion = 3 then -- eliminar
		delete from personas
		where per_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;

	--select sp_personas(1,'alfredo','sanchez','azahares c/ resedad','0984-580-306','6682789','1998-05-29','alfredo@gmail.com',1,1,1,1,1,2)
end;
$$;
 D  DROP FUNCTION public.sp_personas(codigo integer, pernom character varying, perape character varying, perdir character varying, pertel character varying, perci character varying, perfenac date, peremail character varying, paiscod integer, ciucod integer, gencod integer, tipoper integer, estacod integer, operacion integer);
       public          postgres    false            �           1255    207080 �   sp_personas1(integer, character varying, character varying, character varying, character varying, character varying, date, character varying, integer, integer, integer, integer, integer)    FUNCTION       CREATE FUNCTION public.sp_personas1(codigo integer, pernom character varying, perape character varying, perdir character varying, pertel character varying, perci character varying, perfenac date, peremail character varying, paiscod integer, ciucod integer, gencod integer, tipoper integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare retorno record;
begin
	if operacion = 1 then -- insertar
		insert into personas
		values(
			(select coalesce(max(per_cod),0)+1 from personas),
			upper(pernom),
			upper(perape),
			upper(perdir),
			upper(pertel),
			upper(perci),
			perfenac,
			lower(peremail),
			paiscod,
			ciucod,
			gencod,
			tipoper
		);
		raise notice 'LA PERSONA FUE INSERTADA';
	end if;

	if operacion = 2 then --modificar
		update personas set
			per_nom = upper(pernom),
			per_ape = upper(perape),
			per_dir = upper(perdir),
			per_tel = upper(pertel),
			per_ci = upper(perci),
			per_fenac = perfenac,
			per_email = lower(peremail),
			pais_cod = paiscod,
			ciu_cod = ciucod,
			gen_cod = gencod,
			tipo_per_cod = tipoper
		where per_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';	
	end if;
	
	if operacion = 3 then -- eliminar
		for retorno in select * from funcionarios loop
			if retorno.per_cod = codigo then
				raise exception 'NO PUEDES ELIMINAR ESTA PERSONA , PORQUE EXISTE REGISTRO SUYO EN LA TABLA FUNCIONARIOS';
			end if;
		end loop;
		for retorno in select * from proveedores loop
			if retorno.per_cod = codigo then
				raise exception 'NO PUEDES ELIMINAR ESTA PERSONA , PORQUE EXISTE REGISTRO SUYO EN LA TABLA PROVEEDORES';
			end if;
		end loop;
		for retorno in select * from clientes loop
			if retorno.per_cod = codigo then
				raise exception 'NO PUEDES ELIMINAR ESTA PERSONA , PORQUE EXISTE REGISTRO SUYO EN LA TABLA CLIENTES';
			end if;
		end loop;
		
		delete from personas
		where per_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;

	--select sp_personas(1,'alfredo','sanchez','azahares c/ resedad','0984-580-306','6682789','1998-05-29','alfredo@gmail.com',1,1,1,1,2)
end;
$$;
 4  DROP FUNCTION public.sp_personas1(codigo integer, pernom character varying, perape character varying, perdir character varying, pertel character varying, perci character varying, perfenac date, peremail character varying, paiscod integer, ciucod integer, gencod integer, tipoper integer, operacion integer);
       public          postgres    false            �           1255    216964 M   sp_presupuestos(integer, date, integer, integer, integer, integer[], integer)    FUNCTION     �  CREATE FUNCTION public.sp_presupuestos(codigo integer, presuvalidez date, succod integer, clicod integer, usucod integer, detalle integer[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare ultcod integer;
		dimension integer = array_length(detalle, 1);
begin
	-------------------------------TRABAJAMOS CON LA CABECERA DE PRESUPUESTOS ----------------------
	
	select coalesce(max(presu_cod),0)+1 into ultcod from presupuestos_cab;
	if operacion = 1 then --insertar
		if current_date > presuvalidez then
			raise exception 'LA FECHA DE VALIDEZ HASTA NO PUEDE SER MENOR A HOY';
		end if;
		insert into presupuestos_cab 
		values(
			ultcod,
			current_timestamp,
			presuvalidez,
			'PROCESADO',
			succod,
			(select emp_cod from sucursales where suc_cod = succod),
			(select fun_cod from usuarios where usu_cod = usucod),
			clicod,
			usucod
		);
	 -------------------------------TRABAJAMOS CON LA DETALLE DE PRESUPUESTOS ----------------------
		for i in 1..dimension loop
			if detalle[i][2] != 0 then
				insert into presupuestos_det_items 
				values(ultcod, detalle[i][1], detalle[i][2],detalle[i][3],detalle[i][4]); --(presu_cod, item_cod, mar_cod, presu_cantidad, presu_precio	) -- select * from presupuestos_det_items
			else
				insert into presupuestos_det_servicios -- (presu_cod, item_cod, presu_cantidad, presu_precio) -- select * from presupuestos_det_servicios
				values(ultcod,detalle[i][1], detalle[i][3],detalle[i][4]);
			end if;	
		end loop;
		raise notice 'INSERCION DEL PRESUPUESTO REALIZADA EXITOSAMENTE';
	end if;

	if operacion = 2 then -- anular
		update presupuestos_cab set presu_estado = 'ANULADO' where presu_cod = codigo;
		raise notice 'ANULACION DEL PRESUPUESTO REALIZADA EXITOSAMENTE';
	end if;
		--select sp_presupuestos(1,1,'11-09-2019',1,1,1,'{{1,10,10000},{5,10,10000}}',1)
	--ORDEN:codigo, presunro, presuvalidez, succod, clicod, usucod, detalle[item_cod, presu_cantidad, presu_precio], operacion
end
$$;
 �   DROP FUNCTION public.sp_presupuestos(codigo integer, presuvalidez date, succod integer, clicod integer, usucod integer, detalle integer[], operacion integer);
       public          postgres    false            �           1255    366675 _   sp_presupuestos_proveedores(integer, integer, date, date, integer, integer, integer[], integer)    FUNCTION     �	  CREATE FUNCTION public.sp_presupuestos_proveedores(codigo integer, provcod integer, preprovfecha date, preprovvalidez date, succod integer, usucod integer, detalles integer[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare dimension integer = array_length(detalles, 1);
BEGIN
	if operacion = 1 then -- insertar
		if preprovvalidez < current_date then
			raise exception 'LA FECHA DE VALIDEZ DEBE SER MAYOR A LA FECHA ACTUAL';
		end if;
			insert into presupuestos_proveedores_cab
			values(
				codigo,
				provcod,
				preprovfecha,
				'PROCESADO',
				preprovvalidez,
				current_timestamp,
				succod,
				(select emp_cod from sucursales where suc_cod = succod),
				(select fun_cod from usuarios where usu_cod = usucod),
				usucod
			);
			--------------- TRABAJAMOS CON EL DETALLE DE PRESUPUESTOS - PROVEEDORES -----------------
			for i in 1..dimension loop
				if detalles[i][3]::integer <= 0 then 
					raise exception 'LA CANTIDAD NO PUEDE SER MENOR O IGUAL A CERO';
				end if;
				insert into presupuestos_proveedores_det -- select * from presupuestos_proveedores_det
				values(
					codigo,
					provcod,
					preprovfecha,
					detalles[i][1]::integer, -- items
					detalles[i][2]::integer, -- marcas
					detalles[i][3]::integer, -- cantidad
					detalles[i][4]::numeric  -- precio
				);
			end loop;
			raise notice 'PRESUPUESTO DEL PROVEEDOR REGISTRADO EXITOSAMENTE';
	end if;
	if operacion = 2 then -- modificar
		delete from presupuestos_proveedores_det where pre_prov_cod = codigo and prov_cod = provcod
		and pre_prov_fecha = preprovfecha;
		
		update presupuestos_proveedores_cab set pre_prov_validez = preprovvalidez
		where pre_prov_cod = codigo and prov_cod = provcod
		and pre_prov_fecha = preprovfecha;
		
		for i in 1..dimension loop
			insert into presupuestos_proveedores_det 
			values(
				codigo, provcod, preprovfecha, detalles[i][1], detalles[i][2], detalles[i][3], detalles[i][4]
			);
		end loop;
		raise notice 'MODIFICACION EXITOSA';
	end if;
	
	if operacion = 3 then -- anular
		update presupuestos_proveedores_cab set
			pre_prov_estado = 'ANULADO'
		where pre_prov_cod = codigo and prov_cod = provcod and pre_prov_fecha = preprovfecha;
		
		Raise notice 'EL PRESUPUESTO DEL PROVEEDOR HA SIDO ANULADO';
	end if;
	-- ORDEN: codigo, provcod, fecha, validez, succod, usucod, detalles[items, marcas, cant, precio], operacion
	-- select sp_presupuestos_proveedores (1,1,'18-05-2021','19-05-2021',1,1,'{{1,1,4,5000}}',2)
	-- select * from presupuestos_proveedores_cab
	
END
$$;
 �   DROP FUNCTION public.sp_presupuestos_proveedores(codigo integer, provcod integer, preprovfecha date, preprovvalidez date, succod integer, usucod integer, detalles integer[], operacion integer);
       public          postgres    false            �           1255    207082 3   sp_profesiones(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_profesiones(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into profesiones
		values(
			(select coalesce(max(prof_cod),0)+1 from profesiones),
			upper(descripcion)
		);
		raise notice '%','LA PROFESION '||upper(descripcion)||' FUE INSERTADO';
	end if;
	if operacion = 2 then
		update profesiones set
		prof_desc = upper(descripcion)
		where prof_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then
		delete from profesiones  
		where prof_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	--select sp_profesiones(1,'administrador',1)
end;
$$;
 g   DROP FUNCTION public.sp_profesiones(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    284687 f   sp_promociones(integer, date, date, integer, integer, character varying, character varying[], integer)    FUNCTION       CREATE FUNCTION public.sp_promociones(codigo integer, promoinicio date, promofin date, usucod integer, succod integer, promodesc character varying, detalle character varying[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
-- select * from promos_cab
	declare dimension character varying = array_length(detalle, 1);
		ultcod integer;
begin
-----------------------------TRABAJAMOS POR EL CABECERA DE LAS PROMOCIONES ------------------------------

	if  operacion in(1,2) then
		if promoinicio = '1/1/1111' then
			raise exception 'DEBE INGRESAR LA FECHA DE INICIO';
		end if;

		if promofin = '1/1/1111' then
			raise exception 'DEBE INGRESAR LA FECHA DE FINALIZACION';
		end if;

		if promoinicio < current_date then
			raise exception 'LA FECHA DE INICIO DE LA PROMOCION NO PUEDE SER MENOR AL DIA ACTUAL';
		end if;

		if promoinicio > promofin then
			raise exception 'LA FECHA DE INICIO NO PUEDE SER MAYOR A LA FECHA FIN';
		end if;

	end if;

	select coalesce(max(promo_cod),0)+1 into ultcod from promos_cab;
	if operacion = 1 then -- insertar
		
		insert into promos_cab -- select * from promos_cab
		values(ultcod,
		       current_timestamp,
		       promoinicio,
		       promofin,
		       'ACTIVO',
		       usucod,
		       (select fun_cod from usuarios where usu_cod = usucod),
		       succod,
		       (select emp_cod from sucursales where suc_cod = succod),
		       upper(promodesc)
		);
	 -----------------------------TRABAJAMOS POR EL DETALLE DE LAS PROMOCIONES ------------------------------	
		for i in 1..dimension loop
			-- if (select item_precio from items where item_cod = detalle[i][1]) < detalle[i][3] then
-- 				raise exception 'EL DESCUENTO NO PUEDE SER MAYOR AL PRECIO DEL ITEM';
-- 			end if;
			
			if detalle[i][2]::integer = 0 then -- si el parametro de marca llega con cero significa que es un servicio
				insert into promos_det_servicios --(promo_cab, item_cod,promo_desc, promo_precio, tipo_desc) -- select * from promos_det_servicios
				values(
					ultcod,
					detalle[i][1]::integer,
					detalle[i][3]::integer,
					detalle[i][4]::integer,
					detalle[i][5]::varchar
				);
			else
				insert into promos_det_items --(promo_cod, item_cod, mar_cod, descuento, promo_precio, tipo_desc)
				values(
					ultcod,
					detalle[i][1]::integer,
					detalle[i][2]::integer,
					detalle[i][3]::integer,
					detalle[i][4]::integer,
					upper(detalle[i][5]::varchar)
				); -- select * from promos_det_items
			end if;
			
		end loop;
		raise notice 'INSERCION DE PROMOCIONES EXITOSAMENTE';
	end if;

	if operacion = 3 then -- modificar
		update promos_cab set promo_estado = 'ANULADO'  where promo_cod = codigo;
		raise notice 'LA PROMO HA SIDO ANULADA EXITOSAMENTE';
	end if;
	--	select sp_promociones(1,'1/1/1111','15-11-2020',1,1,'hola','{{1,1,5000,25000,monto}}',1)
	-- 	ORDEN: codigo, promoinicio, promofin, usucod, succod, detalle[item_cod, mar_cod, promo_desc, promo_precio, tipo_desc], operacion

	-- select * from promos_cab order by promo_cod desc
	-- 	select * from promos_det_items order by promo_cod desc
end
$$;
 �   DROP FUNCTION public.sp_promociones(codigo integer, promoinicio date, promofin date, usucod integer, succod integer, promodesc character varying, detalle character varying[], operacion integer);
       public          postgres    false            �           1255    207085 <   sp_proveedores(integer, integer, character varying, integer)    FUNCTION       CREATE FUNCTION public.sp_proveedores(codigo integer, percod integer, provruc character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then --insertar
		insert into proveedores
		values(
			(select coalesce(max(prov_cod),0)+1 from proveedores),
			percod,
			upper(provruc),
			'ACTIVO',
			current_date,
			null
		);
		raise notice 'EL PROVEEDOR FUE INSERTADO';
	end if;
	--select sp_proveedores(1,1,'80021921-5',1) // para insertar

	if operacion = 2 then --modificar
		update proveedores set
		prov_ruc = upper(provruc)
		where prov_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	--select sp_proveedores(1,0,'8000000',2) // para modificar - solo se puede modificar el prov_ruc	

	if operacion = 3 then --desactivar
		update proveedores set 
		prov_estado = 'INACTIVO',
		prov_fecha_baja = current_date
		where prov_cod =  codigo;

		raise notice 'DESACTIVACION EXITOSA';
	end if;
	--select sp_proveedores(1,0,'',3) // para desactivar
	
	if operacion = 4 then --activar
		update proveedores set 
		prov_estado = 'ACTIVO',
		prov_fecha_alta= current_date,
		prov_fecha_baja = null
		where prov_cod =  codigo;

		raise notice 'ACTIVACION EXITOSA';
	end if;
	--select sp_proveedores(1,0,'',4) // para activar
end;
$$;
 s   DROP FUNCTION public.sp_proveedores(codigo integer, percod integer, provruc character varying, operacion integer);
       public          postgres    false            �           1255    243191 9   sp_proveedores_timbrados(integer, integer, date, integer)    FUNCTION     �  CREATE FUNCTION public.sp_proveedores_timbrados(provcod integer, provtimbnro integer, provtimvighasta date, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare temporal integer;
			timutilizado record;
begin
	if operacion = 1 then -- insertar
		if (select length(provtimbnro::text) != 8 ) then
			raise exception 'EL NUMERO DE TIMBRADO DEBE POSEER 8 DIGITOS';
		end if;
	
		select prov_timb_nro into temporal from proveedor_timbrados where prov_cod = provcod and prov_timb_nro = provtimbnro;
		if found then
			raise exception 'ESTE TIMBRADO YA HA SIDO REGISTRADO';
		else
			insert into proveedor_timbrados
			values(
				provcod,
				provtimbnro,
				provtimvighasta
			);

			raise notice 'EL TIMBRADO FUE INSERTADO EXITOSAMENTE';
		end if;
	end if;
	
	if operacion = 2 then -- modificar
			update proveedor_timbrados set
			prov_tim_vighasta = provtimvighasta
			where prov_cod = provcod and prov_timb_nro = provtimbnro;
			
			raise notice 'MODIFICACION EXITOSA';
	end if;
	
	if operacion = 3 then -- eliminar
		for timutilizado in select * from compras_cab loop
			if timutilizado.prov_timb_nro = provtimbnro and timutilizado.prov_cod = provcod then
				raise exception 'ESTE TIMBRADO NO PUEDE SER ELIMINADO POR QUE YA HA SIDO UTILIZADO EN COMPRAS';
			end if;
			
			delete from proveedor_timbrados where prov_cod = provcod and prov_timb_nro = provtimbnro;
			
			raise notice 'ELIMINACION DE TIMBRADO EXITOSO';
		end loop;
	end if;
	-- select * from proveedor_timbrados
end
$$;
 ~   DROP FUNCTION public.sp_proveedores_timbrados(provcod integer, provtimbnro integer, provtimvighasta date, operacion integer);
       public          postgres    false            �           1255    207086 h   sp_reclamos_clientes(integer, integer, text, integer, integer, date, integer, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.sp_reclamos_clientes(codigo integer, tiporeclamo integer, reclamodesc text, sucreclamo integer, clicod integer, reclamofechacli date, usucod integer, tipoitemreclamo integer, succod integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then --insertar
		insert into reclamo_clientes
		values(
			(select coalesce(max(reclamo_cod),0)+1 from reclamo_clientes),
			tiporeclamo,
			reclamodesc,
			(select emp_cod from sucursales where suc_cod = succod),
			sucreclamo,
			(select fun_cod from usuarios where usu_cod = usucod),
			clicod,
			'REGISTRADO',
			current_timestamp,
			reclamofechacli,
			usucod,
			tipoitemreclamo,
			succod
		);
		raise notice 'EL RECLAMO FUE INSERTADO';
	end if;

	if operacion = 2 then -- modificar
		update reclamo_clientes set reclamo_desc = reclamodesc, tipo_recl_item_cod = tipoitemreclamo,reclamo_fecha_cliente = reclamofechacli,tipo_reclamo_cod = tiporeclamo,suc_reclamo = sucreclamo
		where reclamo_cod = codigo;
		raise notice 'RECLAMO MODIFICADO EXITOSAMENTE';
	end if;

	if operacion = 3 then -- modificar estado del reclamo
		update reclamo_clientes set reclamo_estado = 'ANALIZADO' where reclamo_cod = codigo;
		raise notice 'ESTE RECLAMO FUE ANALIZADO';
	end if;

	if operacion = 4 then -- eliminar reclamo
		delete from reclamo_clientes where reclamo_cod = codigo;
		raise notice 'RECLAMO ELIMINADO';
	end if;
	--select sp_reclamos_clientes1(1,1,'me gustaria que lo precios se mejoracen',1,1,'2020-01-01',1,2,1,1)
	--ORDEN: reclamocod, tipreclamo, reclamodesc, funcod, sucreclamo, clicod, reclafechacli, usucod, tiporeclamoitem,succod operacion
	/*
		select * from clientes
		select * from reclamo_clientes
		delete from reclamo_clientes
		--select sp_clientes(1,4,'80025625-4',1) //  para insertar 
		--select sp_personas(1,'julio','cabrera','pai perez c/ avda. fdo de la mora','0984-080-306','1234567','1993-05-18','julio@gmail.com',1,1,1,1,1)
		select * from personas
	*/
end;
$$;
 �   DROP FUNCTION public.sp_reclamos_clientes(codigo integer, tiporeclamo integer, reclamodesc text, sucreclamo integer, clicod integer, reclamofechacli date, usucod integer, tipoitemreclamo integer, succod integer, operacion integer);
       public          postgres    false            �           1255    424098 &   sp_recupera_facturas_clientes(integer)    FUNCTION     �  CREATE FUNCTION public.sp_recupera_facturas_clientes(clicod integer, OUT nro_factura character varying) RETURNS SETOF character varying
    LANGUAGE plpgsql
    AS $$
	DECLARE retorno record;
begin
	if (select count(venta_nro_fact) from libro_ventas where ven_cod in (select ven_cod from ventas_cab where cli_cod = 1) and venta_nro_fact is not null) = 0 then
		raise exception 'NO POSEE NINGUN NUMERO DE FACTURA AUN';
	end if;
	
	for retorno in ((select venta_nro_fact from libro_ventas where ven_cod in (select ven_cod from ventas_cab where cli_cod = 1) and venta_nro_fact is not null)) loop
		nro_factura := retorno.venta_nro_fact;
		return next;
	end loop;
	
end
$$;
 g   DROP FUNCTION public.sp_recupera_facturas_clientes(clicod integer, OUT nro_factura character varying);
       public          postgres    false            �           1255    207087 S   sp_reservas(integer, integer, integer, integer, date, character varying[], integer)    FUNCTION     �  CREATE FUNCTION public.sp_reservas(codigo integer, succod integer, clicod integer, usucod integer, reserf date, detalle character varying[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare dimension varchar = array_length(detalle, 1);
		ultcod integer;
begin
	----------------------------------TRABAJAMOS POR LA CABECERA DE RESERVAS-------------------------------------
	
		
	select coalesce(max(reser_cod),0)+1 into ultcod from reservas_cab;
	if operacion = 1 then -- insertar
		if current_date > reserf then
			raise exception 'LA FECHA A RESERVAR NO PUEDE SER MENOR A HOY';
		end if;
		insert into reservas_cab
		values(
			ultcod,
			'PENDIENTE',
			current_timestamp,
			succod,
			(select emp_cod from sucursales where suc_cod = succod),
			clicod,
			(select fun_cod from usuarios where usu_cod = usucod),
			usucod
		);
	 ----------------------------------TRABAJAMOS POR EL DETALLE DE RESERVAS-------------------------------------
		for i in 1..dimension loop -- mientras haya detalle para ser insertado
			if detalle[i][2] > detalle[i][3] then
				raise exception 'LA HORA DESDE NO PUEDE SER MAYOR A LA HORA HASTA';
			end if;

			insert into reservas_det --(reser_cod,reser_hdesde, reser_hhasta, fecha_reser, reser_precio, item_cod, reser_desc, fun_cod)-- select * from reservas_det
			values(
				ultcod,
				detalle[i][2]::time without time zone,--hdesde
				detalle[i][3]::time without time zone,--hhasta
				reserf::date,--fechareserva
				detalle[i][5]::integer,--precio
				detalle[i][1]::integer,--item_cod
				detalle[i][4]::character varying,--descripcion
				detalle[i][6]::integer--funcionario
			);
		end loop;
		raise notice 'LA RESERVA FUE REALIZADA CON EXITO';
	end if;

	if operacion = 2 then -- anular
		update reservas_cab set reser_estado = 'ANULADO' where reser_cod = codigo;
		delete from reservas_det where reser_cod = codigo;
		
		raise notice 'LA RESERVA HA SIDO ANULADA EXITOSAMENTE';
	end if;
-- 	select sp_reservas(0,1,1,1,'07-10-2019','{{12:00:00,14:00:00,35000,2,primera insercion por sp,7}}',1)
	--ORDEN: codigo, succod, clicod, usucod,fecha, detalle[reserhdesde, reserhasta, precio, item_cod, descripcion], operacion

-- select * from reservas_cab
-- select * from reservas_det
-- select * from v_reservas_det
	
end
$$;
 �   DROP FUNCTION public.sp_reservas(codigo integer, succod integer, clicod integer, usucod integer, reserf date, detalle character varying[], operacion integer);
       public          postgres    false            �           1255    208630 ,   sp_stock(integer, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.sp_stock(depcod integer, itemcod integer, marcod integer, cantidad integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare iditem integer;
begin
	select item_cod into iditem from stock where dep_cod = depcod and item_cod = itemcod and mar_cod = marcod; -- PARA SABER SI YA EXISTE ESE ITEM EN STOCK
	if found then
		update stock set stock_cantidad = stock_cantidad + cantidad where dep_cod = depcod and item_cod = itemcod and mar_cod = marcod;
	else
		insert into stock values(depcod, itemcod, marcod, cantidad);
	end if;
	--select sp_stock(1,1,1,-20) -- recibe valores positivos y negativos
	-- select * from stock
end
$$;
 b   DROP FUNCTION public.sp_stock(depcod integer, itemcod integer, marcod integer, cantidad integer);
       public          postgres    false            �           1255    207089 t   sp_sucursales(integer, integer, character varying, character varying, character varying, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_sucursales(codigo integer, empcod integer, sucnom character varying, sucdir character varying, suctel character varying, sucemail character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then -- insertar 
		insert into sucursales
		values(
			(select coalesce(max(suc_cod),0)+1 from sucursales),
			empcod,
			upper(sucnom),
			upper(sucdir),
			upper(suctel),
			upper(sucemail),
			'ACTIVO'
		);
		raise notice '%','LA SUCURSAL '||upper(sucnom)||' FUE REGISTRADA';
	end if;

	if operacion = 2 then
		update sucursales set
		emp_cod = empcod,
		suc_nom = upper(sucnom),
		suc_dir = upper(sucdir),
		suc_tel = upper(suctel),
		suc_email = lower(sucemail)
		where suc_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;

	if operacion = 3 then 
		update sucursales set suc_estado = 'INACTIVO'
		where suc_cod = codigo;

		raise notice 'DESACTIVACION EXITOSA';
	end if;
	
	if operacion = 4 then 
		update sucursales set suc_estado = 'ACTIVO'
		where suc_cod = codigo;
		raise notice 'ACTIVACION EXITOSA';
	end if;
	--select sp_sucursales(1,1,'ñemby','avda. pratgill','0982-320-321','astorenemby@gmail.com',1)
	-- select * from sucursales

	
end;
$$;
 �   DROP FUNCTION public.sp_sucursales(codigo integer, empcod integer, sucnom character varying, sucdir character varying, suctel character varying, sucemail character varying, operacion integer);
       public          postgres    false            �           1255    207090 c   sp_timbrados_or(integer, integer, date, date, integer, integer, integer, integer, integer, integer)    FUNCTION     7  CREATE FUNCTION public.sp_timbrados_or(codigo integer, timbnro integer, timvigdesde date, timvighasta date, succod integer, timnrodesde integer, timnrohasta integer, ultfactura integer, puntoexp integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare temporal integer; 
begin

	if operacion = 1 then -- insertar
	if timvigdesde::date < (current_date - cast(365 as integer)) then
		raise exception 'NO PUEDE REGISTRAR UN TIMBRADO DEL EJERCICIO ANTERIOR';
	end if;
	if timvighasta::date > (current_date + cast(395 as integer)) then
		raise exception 'NO PUEDE REGISTRAR UN TIMBRADO DEL EJERCICIO SIGUIENTE';
	end if;
	if (select length (timbnro::text) != 8) then
		raise exception 'EL TIMBRADO DEBE TENER 8 DIGITOS.';
	end if;
	if timvigdesde > timvighasta then
		raise exception 'LA VIGENCIA DESDE NO PUEDE SER MAYOR A LA VIGENCIA HASTA';
	end if;
	if timnrodesde > timnrohasta then
		raise exception 'EL NUMERO DESDE NO PUEDE SER MAYOR AL NUMERO HASTA';
	end if;
	if not (ultfactura between ((select tim_nrodesde from timbrados where timb_cod = codigo)- 1) and (select tim_nrohasta from timbrados where timb_cod = codigo)) then
		raise exception 'EL NUMERO DE FACTURA NO CORRESPONDE AL TIMBRADO';
	end if;
		select timb_nro into temporal from timbrados where timb_nro = timbnro;
		if found then
			raise exception 'ESTE TIMBRADO YA FUE REGISTRADO';
		else 
			insert into timbrados 
			values(
				(select coalesce(max(timb_cod),0)+1 from timbrados),
				timbnro,
				current_date,
				'ACTIVO',
				timvigdesde,
				timvighasta,
				succod,
				(select emp_cod from sucursales where suc_cod = succod),
				timnrodesde,
				timnrohasta,
				ultfactura,
				puntoexp
			);
			raise notice 'EL TIMBRADO FUE REGISTRADO';
		end if;  
	end if;
	--select sp_timbrados_or(1,12345779,'2020-01-01','2021-01-01',1,1,1500,0,1,1)
	--ORDEN: timbcod, timbnro, timvigdesde, timvighasta, succod,timnrodesde, timnrohasta, ultfactura, puntpexp, operacion
	-- select * from timbrados
	

	if operacion = 2 then -- modificar
		if timvigdesde::date < (current_date - cast(365 as integer)) then
			raise exception 'NO PUEDE REGISTRAR UN TIMBRADO DEL EJERCICIO ANTERIOR';
		end if;
		if timvighasta::date > (current_date + cast(395 as integer)) then
			raise exception 'NO PUEDE REGISTRAR UN TIMBRADO DEL EJERCICIO SIGUIENTE';
		end if;
		if (select length (timbnro::text) !=8 )then -- AQUI PUEDO CAMBIAR SI VARIA LA CANTIDAD DE DIGITOS DEL TIMBRADO DE LA SET
			raise exception 'EL TIMBRADO DEBE TENER 8 DIGITOS';
		end if;	
		if timvigdesde > timvighasta then
			raise exception 'LA VIGENCIA DESDE NO PUEDE SER MAYOR A LA VIGENCIA HASTA';
		end if;
		if timnrodesde > timnrohasta then
			raise exception 'EL NUMERO DESDE NO PUEDE SER MAYOR AL NUMERO HASTA';
		end if;
		if NOT (ultfactura between ((select tim_nrodesde from timbrados where timb_cod = codigo)-1) and (select tim_nrohasta from timbrados where timb_cod = codigo)) then
			raise exception 'EL NUMERO DE FACTURA NO CORRESPONDE AL TIMBRADO';
		end if;
		select timbnro into temporal from timbrados where timb_nro = timbnro and timb_cod != codigo;
		if found then
			raise exception 'ESTE TIMBRADO YA FUE REGISTRADO';
		else	
			update timbrados set
			timb_nro = timbnro,
			tim_vigdesde = timvigdesde,
			tim_vighasta = timvighasta,
			tim_nrodesde = timnrodesde,
			tim_nrohasta = timnrohasta,
			tim_ultfactura = ultfactura,
			suc_cod = succod
			where timb_cod = codigo;
		end if; 
		raise notice 'EL TIMBRADO FUE MODIFICADO EXITOSAMENTE';
	end if;
	--select sp_timbrados_or(1,12345798,'2020-01-05','2021-01-02',1,500,1500,1501,1,2)
	-- select * from timbrados
end;	
$$;
 �   DROP FUNCTION public.sp_timbrados_or(codigo integer, timbnro integer, timvigdesde date, timvighasta date, succod integer, timnrodesde integer, timnrohasta integer, ultfactura integer, puntoexp integer, operacion integer);
       public          postgres    false            �           1255    207091 4   sp_tipo_ajustes(integer, character varying, integer)    FUNCTION     :  CREATE FUNCTION public.sp_tipo_ajustes(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then -- insertar
		insert into tipo_ajustes
		values((select coalesce(max(tipo_ajuste_cod),0)+1 from tipo_ajustes),upper(descripcion));
		raise notice '%','EL TIPO DE AJUSTE '||upper(descripcion)||' FUE INSERTADO';
	end if;

	if operacion = 2 then -- modificar
		update tipo_ajustes set tipo_ajuste_desc = upper(descripcion) where tipo_ajuste_cod = codigo;
		raise notice 'MODIFICACION EXITOSA';
	end if;

	if operacion = 3  then -- eliminar
		delete from tipo_ajustes where tipo_ajuste_cod = codigo;
		raise notice 'EL TIPO AJUSTE FUE ELIMINADO EXITOSAMENTE';
	end if;
	-- select sp_tipo_ajustes(1,'positivo',1)
	-- select * from tipo_ajustes
end;
$$;
 h   DROP FUNCTION public.sp_tipo_ajustes(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    207092 4   sp_tipo_cheques(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_tipo_cheques(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then -- insertar
		insert into tipo_cheques
		values(
			(select coalesce(max(cheque_tipo_cod),0)+1 from tipo_cheques),
			upper(descripcion)
		);
		raise notice '%','EL TIPO DE CHEQUE '||upper(descripcion)||' FUE INSERTADO';
	end if;
	if operacion = 2 then 
		update tipo_cheques set
		cheque_tipo_desc = upper(descripcion)
		where cheque_tipo_cod = codigo;
	end if;
	if operacion = 3 then -- eliminar
		delete from tipo_cheques 
		where cheque_tipo_cod = codigo;
	end if;

	--SELECT sp_tipo_cheques(1,'diferido',2)
end;
$$;
 h   DROP FUNCTION public.sp_tipo_cheques(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    207093 5   sp_tipo_facturas(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_tipo_facturas(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into tipo_facturas
		values(
			(select coalesce(max(tipo_fact_cod),0)+1 from tipo_facturas),
			 upper(descripcion)
		);
		raise notice '%','EL TIPO DE PAGO'||upper(descripcion)||' FUE INSERTADO';
	end if;

	if operacion = 2 then 
		update tipo_facturas set
		tipo_fact_desc = upper(descripcion)
		where tipo_fact_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;

	if operacion = 3 then 
		delete from tipo_facturas 
		where tipo_fact_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	-- select sp_tipo_facturas(1,'contado',1)
end
$$;
 i   DROP FUNCTION public.sp_tipo_facturas(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    207094 6   sp_tipo_impuestos(integer, character varying, integer)    FUNCTION     a  CREATE FUNCTION public.sp_tipo_impuestos(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then -- insertar
		
		if (select length (descripcion) <= 1) then
			raise exception 'VERIFIQUE LOS VALORES DE LOS CAMPOS';
		else
			insert into tipo_impuestos
			values(
				(select coalesce(max(tipo_imp_cod),0)+1 from tipo_impuestos),
				upper(descripcion)
			);
		end if;	
		raise notice 'TIPO DE IMPUESTO INSERTADO';
	end if;

	if operacion = 2 then -- modificar
		update tipo_impuestos set tipo_imp_desc = upper(descripcion) where tipo_imp_cod = codigo;
		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then
		delete from tipo_impuestos where tipo_imp_cod = codigo;
		raise notice 'ELIMINACION EXITOSA';
	end if;
	--select sp_tipo_impuestos(2,'exentas',1)
	
end;
$$;
 j   DROP FUNCTION public.sp_tipo_impuestos(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    207095 2   sp_tipo_items(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_tipo_items(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into tipo_items
		values(
			(select coalesce(max(tipo_item_cod),0)+1 from tipo_items ),
			upper(descripcion)
		);
		raise notice '%','EL GENERO '||upper(descripcion)||' FUE INSERTADO';
	end if;
	if operacion = 2 then
		update tipo_items set
		tipo_item_desc = upper(descripcion)
		where tipo_item_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then
		delete from tipo_items 
		where tipo_item_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	--select sp_tipo_items(1,'producto',1)
end;
$$;
 f   DROP FUNCTION public.sp_tipo_items(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    207096 5   sp_tipo_personas(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_tipo_personas(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into tipo_personas
		values(
			(select coalesce(max(tipo_per_cod),0)+1 from tipo_personas),
			upper(descripcion)
		);
		raise notice '%','EL TIPO PERSONA '||upper(descripcion)||' FUE INSERTADO';
	end if;
	if operacion = 2 then
		update tipo_personas set
		tipo_pers_desc = upper(descripcion)
		where tipo_per_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then
		delete from tipo_personas  
		where tipo_per_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	--select sp_tipo_personas(1,'fisica',1)
end;
$$;
 i   DROP FUNCTION public.sp_tipo_personas(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    207097 :   sp_tipo_reclamo_items(integer, character varying, integer)    FUNCTION       CREATE FUNCTION public.sp_tipo_reclamo_items(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then -- insertar
		insert into tipo_reclamo_items
		values(
			(select coalesce(max(tip_recl_item_cod),0)+1 from tipo_reclamo_items),
			upper(descripcion)
		);
		raise notice '%','EL TIPO DE RECLAMOS  ITEMS '||upper(descripcion)|| 'FUE REGISTRADA';
	end if;

	if operacion = 2 then -- modificar
		update tipo_reclamo_items set tipo_recl_item_desc = upper(descripcion) 
		where tipo_recl_item_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;

	if operacion =  3 then -- eliminar
		delete from tipo_reclamo_items where tipo_recl_item_cod = codigo;
		raise notice 'ELIMINACION EXITOSA';
	end if;
end 
$$;
 n   DROP FUNCTION public.sp_tipo_reclamo_items(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    207098 5   sp_tipo_reclamos(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_tipo_reclamos(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into tipo_reclamos
		values(
			(select coalesce(max(tipo_reclamo_cod),0)+1 from tipo_reclamos),
			upper(descripcion)
		);
		raise notice '%','EL TIPO RECLAMO '||upper(descripcion)||' FUE INSERTADO';
	end if;
	if operacion = 2 then
		update tipo_reclamos set
		tipo_reclamo_desc = upper(descripcion)
		where tipo_reclamo_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then
		delete from tipo_reclamos   
		where tipo_reclamo_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	--select sp_tipo_personas(1,'juridica',1)
end;
$$;
 i   DROP FUNCTION public.sp_tipo_reclamos(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    208680 �   sp_transferencias(integer, integer, integer, date, date, integer, integer, integer, character varying, integer, integer, integer[], integer)    FUNCTION     �  CREATE FUNCTION public.sp_transferencias(codigo integer, succod integer, usucod integer, transfechaenvio date, transfechaentrega date, vehcod integer, transorigen integer, transdestino integer, transenviarrecibir character varying, deporigen integer, depdestino integer, detalle integer[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare dimension integer = array_length(detalle, 1);
		ultcod integer;
		retorno record;
		estado varchar(20);
		item integer;--//para utilizar en recibir(ajuste)
		cant integer;--//
		
begin
	-----------------------------------TRABAJAMOS CON LA CABECERA DE TRANSFERENCIAS---------------------------
	select coalesce(max(trans_cod),0)+1 into ultcod from transferencias_cab;
	if operacion = 1 then -- insertar
		insert into transferencias_cab
		values(
			ultcod,
			current_timestamp,
			'PENDIENTE',
			succod,
			(select emp_cod from sucursales where suc_cod = succod),
			(select fun_cod from usuarios where usu_cod = usucod),
			transfechaenvio,
			transfechaentrega,
			vehcod,
			transorigen,
			transdestino,
			upper(transenviarrecibir),
			usucod						
		);

		-----------------------------------TRABAJAMOS CON LA DETALLE DE TRANSFERENCIAS---------------------------
		for i in 1..dimension loop
			insert into transferencias_det --(trans_cod, dep_origen,item_cod, mar_cod, trans_cantidad, trans_cant_recibida,dep_destino) -- select * from transferencias_det
			values(ultcod,deporigen,detalle[i][1], detalle[i][2],detalle[i][3], detalle[i][4], depdestino);

		 --------------------------------TRABAJAMOS POR LA ACTUALIZACION DEL STOCK ------------------------------
			if transenviarrecibir = 'ENVIO' then
				--update stock set stock_cantidad = stock_cantidad - detalle[i][2] where item_cod = detalle[i][1] and dep_cod = deporigen;
				perform  sp_stock(deporigen,detalle[i][1],detalle[i][2],detalle[i][3]*-1);
			end if;
		end loop;

		raise notice 'INSERCION DE TRANSFERENCIA EXITOSA';
	end if;
	
	if operacion = 2 then --recibir
		for retorno in select trans_estado from transferencias_cab where trans_cod = codigo loop
			if retorno.trans_estado = 'PROCESADO' then
				raise exception 'ESTA TRANSFERNCIA YA FUE RECIBIDA';
			end if;
		end loop;
		
		update transferencias_cab set trans_fecha_entrega = current_timestamp, trans_estado = 'PROCESADO', trans_enviar_recibir = 'RECEPCION', usu_recep = usucod where trans_cod = codigo;

		for i in 1..dimension loop
			if detalle[i][3] > detalle[i][4] then -- si es mayor el enviado al recibido
					
-- 				incremento la diferencia entre lo enviado y recibido en el destino para luego poder hacer el ajuste con el trigger
					perform sp_stock(depdestino, detalle[i][1],detalle[i][2],(detalle[i][3] - detalle[i][4]));

					
-- 					select sp_ajustes(0,succod,usucod,'NEGATIVO',depdestino,'{{item::integer,3,cant::integer}}',1);
					--ORDEN: codigo, succod, usucod, ajustipo,depcod, detalle[ itemcod, motcod, ajuscantidad], operacion
			end if;
			
			update transferencias_det set --(trans_cod, dep_origen,item_cod, mar_cod, trans_cantidad, trans_cant_recibida,dep_destino) -- select * from transferencias_det
			trans_cant_recibida = detalle[i][4]
			where item_cod = detalle[i][1] and mar_cod = detalle[i][2] and dep_destino = depdestino and  trans_cod = codigo;
			
			
		end loop;
		
		for retorno in select * from transferencias_det where trans_cod = codigo loop -- select * from transferencias_det 
			perform sp_stock(retorno.dep_destino,retorno.item_cod,retorno.mar_cod,retorno.trans_cant_recibida);
		end loop;

		raise notice 'RECEPCION DE TRANSFERENCIA EXITOSA';
	end if;	

	if operacion = 3 then -- ANULAR
		estado := (select trans_estado from transferencias_cab where trans_cod = codigo);
		if estado = 'PROCESADO' then
			raise exception 'NO SE PUEDE ANULAR UNA TRANSFERENCIA QUE YA HA SIDO RECIBIDA';
		else
			update transferencias_cab set trans_estado = 'ANULADO' where trans_cod = codigo;

			for retorno in select * from transferencias_det where trans_cod = codigo loop
				if estado = 'PENDIENTE' then
					perform sp_stock(retorno.dep_origen, retorno.item_cod, retorno.mar_cod, retorno.trans_cantidad);
				end if;
			end loop;
		end if;	
	end if;
	
	--select sp_transferencias(1,1,1,'02-09-2019','1/1/1111',1,1,1,'ENVIO',1,3,'{{1,1,10,10}}',2)

	--ORDEN: codigo,succod,usucod,transfechaenvio,transfechaentrega,vehcod,transorigen,transdestino,transenviarrecibir,deporigen,depdestino,detalle{itemcod,marcod,tracant,tracant_rec],operacion

	-- select * from transferencias_det
	-- select * from transferencias_cab
end;
$$;
 4  DROP FUNCTION public.sp_transferencias(codigo integer, succod integer, usucod integer, transfechaenvio date, transfechaentrega date, vehcod integer, transorigen integer, transdestino integer, transenviarrecibir character varying, deporigen integer, depdestino integer, detalle integer[], operacion integer);
       public          postgres    false            �           1255    207100 �   sp_transferencias2(integer, integer, integer, date, date, integer, integer, integer, character varying, integer, integer, integer[], integer)    FUNCTION     V  CREATE FUNCTION public.sp_transferencias2(codigo integer, succod integer, usucod integer, transfechaenvio date, transfechaentrega date, vehcod integer, transorigen integer, transdestino integer, transenviarrecibir character varying, deporigen integer, depdestino integer, detalle integer[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare dimension integer = array_length(detalle, 1);
		ultcod integer;
		retorno record;
		estado varchar(20);
		item integer;--//para utilizar en recibir(ajuste)
		cant integer;--//
		
begin
	-----------------------------------TRABAJAMOS CON LA CABECERA DE TRANSFERENCIAS---------------------------
	select coalesce(max(trans_cod),0)+1 into ultcod from transferencias_cab;
	if operacion = 1 then -- insertar
		insert into transferencias_cab
		values(
			ultcod,
			current_timestamp,
			'PENDIENTE',
			succod,
			(select emp_cod from sucursales where suc_cod = succod),
			(select fun_cod from usuarios where usu_cod = usucod),
			transfechaenvio,
			transfechaentrega,
			vehcod,
			transorigen,
			transdestino,
			upper(transenviarrecibir),
			usucod						
		);

		-----------------------------------TRABAJAMOS CON LA DETALLE DE TRANSFERENCIAS---------------------------
		for i in 1..dimension loop
			insert into transferencias_det --(trans_cod, item_cod, dep_origen,trans_cantidad, trans_cant_recibida,dep_destino) -- select * from transferencias_det
			values(ultcod,detalle[i][1],deporigen, detalle[i][2],detalle[i][3], depdestino);

		 --------------------------------TRABAJAMOS POR LA ACTUALIZACION DEL STOCK ------------------------------
			if transenviarrecibir = 'ENVIO' then
				--update stock set stock_cantidad = stock_cantidad - detalle[i][2] where item_cod = detalle[i][1] and dep_cod = deporigen;
				perform  sp_stock(deporigen,detalle[i][1],detalle[i][2]*-1);
			end if;
		end loop;

		raise notice 'INSERCION DE TRANSFERENCIA EXITOSA';
	end if;
	
	if operacion = 2 then --recibir
		update transferencias_cab set trans_fecha_entrega = current_timestamp, trans_estado = 'PROCESADO', usu_recep = usucod where trans_cod = codigo;

		for i in 1..dimension loop
			update transferencias_det set --(trans_cod, item_cod, dep_origen,trans_cantidad, trans_cant_recibida,dep_destino) -- select * from transferencias_det
			trans_cant_recibida = detalle[i][3]
			where item_cod = detalle[i][1]and dep_destino = depdestino and  trans_cod = codigo;
			
			if detalle[i][2] > detalle[i][3] then
				
					perform sp_stock(depdestino, detalle[i][1],(detalle[i][2] - detalle[i][3]));
-- 					select sp_ajustes(0,succod,usucod,'NEGATIVO',depdestino,'{{item::integer,3,cant::integer}}',1);
					--ORDEN: codigo, succod, usucod, ajustipo,depcod, detalle[ itemcod, motcod, ajuscantidad], operacion
			end if;
			
		end loop;
		
		for retorno in select * from transferencias_det where trans_cod = codigo loop -- select * from transferencias_det 
			perform sp_stock(retorno.dep_destino,retorno.item_cod,retorno.trans_cant_recibida);
		end loop;

		raise notice 'RECEPCION DE TRANSFERENCIA EXITOSA';
	end if;	

	if operacion = 3 then -- ANULAR
		estado := (select trans_estado from transferencias_cab where trans_cod = codigo);
		if estado = 'PROCESADO' then
			raise exception 'NO SE PUEDE ANULAR UNA TRANSFERENCIA QUE YA HA SIDO RECIBIDA';
		else
			update transferencias_cab set trans_estado = 'ANULADO' where trans_cod = codigo;

			for retorno in select * from transferencias_det where trans_cod = codigo loop
				if estado = 'PENDIENTE' then
					perform sp_stock(retorno.dep_origen, retorno.item_cod, retorno.trans_cantidad);
				end if;
			end loop;
		end if;	
	end if;
	
	--select sp_transferencias(10,1,1,'02-09-2019','1/1/1111',1,1,1,'ENVIO',1,3,'{{1,10,10}}',3);
	--ORDEN: codigo,succod,usucod,transfechaenvio,transfechaentrega,vehcod,transorigen,transdestino,transenviarrecibir,deporigen,depdestino,detalle{itemcod,tracant,tracant_rec],operacion
end;
$$;
 5  DROP FUNCTION public.sp_transferencias2(codigo integer, succod integer, usucod integer, transfechaenvio date, transfechaentrega date, vehcod integer, transorigen integer, transdestino integer, transenviarrecibir character varying, deporigen integer, depdestino integer, detalle integer[], operacion integer);
       public          postgres    false            �           1255    207101 q   sp_usuarios(integer, integer, integer, character varying, character varying, integer, character varying, integer)    FUNCTION       CREATE FUNCTION public.sp_usuarios(codigo integer, funcod integer, succod integer, usunom character varying, usupass character varying, gruid integer, usufoto character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then -- insertar
		insert into usuarios
		values(
			(select coalesce(max(usu_cod),0)+1 from usuarios),
			funcod,
			succod,
			(select emp_cod from sucursales where suc_cod = succod),
			upper(usunom),
			md5(usupass),
			'ACTIVO',
			gruid,
			usufoto
		);
		raise notice 'EL USUARIO FUE INSERTADO';
	end if;
	-- select sp_usuarios(2,1,1,'cflores','12345',1,'C:\desktop/img.jpg',1) // para insertar

	if operacion = 2 then --modificar usunombre, usupass y gruid
		update usuarios set -- select * from usuarios
		usu_name = upper(usunom),
		suc_cod = succod,
		perfil_cod = gruid
		where usu_cod = codigo;
		raise notice ' EL USUARIO FUE MODIFICADO EXITOSAMENTE';
	end if;

	if operacion = 3 then  -- reiniciar contraseña
		update usuarios set usu_pass = md5((select usu_name from usuarios where usu_cod = codigo))
		where usu_cod = codigo;
		raise notice 'CONTRASEÑA REINICIADA EXITOSAMENTE';
	end if;
	-- select sp_usuarios(2,1,1,'','',1,'',3) // para reiniciar contraseña

	if operacion = 4 then -- DESACTIVAR USUARIO
		update usuarios set usu_estado = 'INACTIVO' where usu_cod = codigo;
		raise notice 'USUARIO DESACTIVADO EXITOSAMENTE';
	end if;
	-- select sp_usuarios(2,1,1,'','',1,'',5) // para desactivar usuarios
	
	if operacion = 5 then -- ACTIVAR USUARIO
		update usuarios set usu_estado = 'ACTIVO' where usu_cod = codigo;
		raise notice 'USUARIO ACTIVADO EXITOSAMENTE';
	end if;
	--ORDEN: usucod, funcod, succod, usunom, usupass, gruid, usufoto, operacion
	-- select * from funcionarios
	-- select * from usuarios

end;
$$;
 �   DROP FUNCTION public.sp_usuarios(codigo integer, funcod integer, succod integer, usunom character varying, usupass character varying, gruid integer, usufoto character varying, operacion integer);
       public          postgres    false            �           1255    207102 C   sp_vehiculos(integer, integer, integer, character varying, integer)    FUNCTION     (  CREATE FUNCTION public.sp_vehiculos(codigo integer, marca integer, modelo integer, chapa character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into vehiculos
		values(
			(select coalesce(max(vehi_cod),0)+1 from vehiculos),
			marca,
			modelo,
			chapa
		);
		raise notice '%','EL VEHICULO FUE INSERTADO';
	end if;
	if operacion = 2 then -- select * from vehiculos
		update vehiculos set
		veh_mar_cod = marca,
		veh_mod_cod = modelo,
		veh_chapa = upper(chapa)
		where vehi_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then -- desactivacion
		update vehiculos set veh_estado = 'INACTIVO'
		where vehi_cod = codigo;
		raise notice 'DESACTIVACION EXITOSA';
	end if;
	if operacion = 4 then -- activacion
		update vehiculos set veh_estado = 'ACTIVO'
		where vehi_cod = codigo;
		raise notice 'ACTIVACION EXITOSA';
	end if;
	--select sp_vehiculos(1,1,1,'utf 135',3)
	-- alter table vehiculos add column veh_estado varchar(20)
	-- select * from vehiculos
	
end;
$$;
 ~   DROP FUNCTION public.sp_vehiculos(codigo integer, marca integer, modelo integer, chapa character varying, operacion integer);
       public          postgres    false            �           1255    207103 8   sp_vehiculos_marcas(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_vehiculos_marcas(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into vehiculos_marcas
		values(
			(select coalesce(max(veh_mar_cod),0)+1 from vehiculos_marcas),
			upper(descripcion)
		);
		raise notice 'LA MARCA DE VEHICULO FUE INSERTADO';
	end if;
	if operacion = 2 then
		update vehiculos_marcas set
		veh_mar_desc = upper(descripcion)
		where veh_mar_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then
		delete from vehiculos_marcas 
		where veh_mar_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	--select sp_vehiculos_modelos(1,'hilux',2)
end;
$$;
 l   DROP FUNCTION public.sp_vehiculos_marcas(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    208617 9   sp_vehiculos_modelos(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_vehiculos_modelos(codigo integer, descripcion character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	if operacion = 1 then
		insert into vehiculos_modelos
		values(
			(select coalesce(max(veh_mod_cod),0)+1 from vehiculos_modelos),
			upper(descripcion)
		);
		raise notice 'EL MODELO DE VEHICULO FUE INSERTADO';
	end if;
	if operacion = 2 then
		update vehiculos_modelos set
		veh_mod_desc = upper(descripcion)
		where veh_mod_cod = codigo;

		raise notice 'MODIFICACION EXITOSA';
	end if;
	if operacion = 3 then
		delete from vehiculos_modelos
		where veh_mod_cod = codigo;

		raise notice 'ELIMINACION EXITOSA';
	end if;
	--select sp_vehiculos_modelos(1,'hilux',2)
end;
$$;
 m   DROP FUNCTION public.sp_vehiculos_modelos(codigo integer, descripcion character varying, operacion integer);
       public          postgres    false            �           1255    251431 \   sp_ventas(integer, integer, integer, integer, integer, integer, integer, integer[], integer)    FUNCTION        CREATE FUNCTION public.sp_ventas(codigo integer, succod integer, usucod integer, clicod integer, ventatipofact integer, venplazo integer, vencuotas integer, detalleventa integer[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	declare ultcod integer;
		dimension integer = array_length(detalleventa, 1);
		act_stock record;
		
	---------variables cuentas a cobrar --------
	nro_cuota integer :=1;
	monto_total integer :=0;
	vencimiento_cuota date;
	monto_cuota integer :=0;

	---------variables libro ventas ----------
	total_iva5 integer =0;	
	total_iva10 integer =0;	
	total_exenta integer =0;	
	total_grav5 integer =0;	
	total_grav10 integer =0;

		
begin
	----------------TRABAJAMOS POR LA CABECERA DE VENTAS -----------------------
	if operacion = 1 then -- insertar
		select coalesce(max(ven_cod),0)+ 1 into ultcod from ventas_cab; -- select * from ventas_cab
		insert into ventas_cab(ven_cod, ven_fecha,ven_estado, emp_cod, suc_cod, usu_cod, fun_cod, cli_cod, tipo_fact_cod, ven_plazo, ven_cuotas)
		values(
			ultcod,
			current_timestamp,
			'PENDIENTE',
			(select emp_cod from sucursales where suc_cod = succod),
			succod,
			usucod,
			(select fun_cod from usuarios where usu_cod = usucod),
			clicod,
			ventatipofact,
			venplazo,
			vencuotas
		); 
		-------------------------TRABAJAMOS AHORA CON LA VENTA DETALLES --------------------------
		for i in 1..dimension loop
			if (select tipo_item_cod from items where item_cod = detalleventa[i][1] ) = 1 then -- producto	
				insert into ventas_det_items (ven_cod, dep_cod, item_cod, mar_cod, ven_cantidad, ven_precio)-- select * from ventas_det_items
				values(
					ultcod,
					detalleventa[i][3],--depcod
					detalleventa[i][1],--itemcod
					detalleventa[i][2],--marcod
					detalleventa[i][4],--vencantidad
					detalleventa[i][5] --venprecio
				);
			else -- servicio
			
				insert into ventas_det_servicios--(ven_cod, dep_cod, item_cod, ven_cantidad, ven_precio) -- select * from ventas_det_servicios
				values(
					ultcod,
					detalleventa[i][1],--itemcod
					detalleventa[i][4],--vencantidad
					detalleventa[i][5] --venprecio
				);
			end if;

			monto_total := monto_total + (detalleventa[i][4]*detalleventa[i][5]); -- monto total de la venta para cuentas cobrar

			--------------- ACTUALIZAMOS AHORA LA CANTIDAD DEL ITEM EN EL STOCK---------------------
				if(select tipo_item_cod from items where item_cod = detalleventa[i][1]) = 1 then --solo actualiza el stock si es de tipo "PRODUCTO"
				 
				perform sp_stock(detalleventa[i][3], detalleventa[i][1], detalleventa[i][2], detalleventa[i][4]*-1 ); --orden: dep_cod, item_cod, mar_cod, stock_cantidad
			end if;
			
		end loop;
		-------------------- TRABAJAMOS AHORA CON EL LIBRO VENTAS --------------------------------------
		
			/*
			total_iva5 = (select round(((select coalesce(sum(ven_precio),0) from ventas_det_items where  item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod))/21))
			 + (select round(((select coalesce(sum(ven_precio),0) from ventas_det_servicios where  item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod))/21));
			 
			total_grav5 = (((select coalesce(sum(ven_precio),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod))
			  + ((select coalesce(sum(ven_precio),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod))) - total_iva5;
			
			total_iva10 = (select round(((select coalesce(sum(ven_precio),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod))/11))
			  + (select round(((select coalesce(sum(ven_precio),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod))/11));
			  
			total_grav10 = ((select coalesce(sum(ven_precio),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod))
			  + ((select coalesce(sum(ven_precio),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod)) - total_iva10;

			total_exenta = (select (select coalesce(sum(ven_precio),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 3) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 3) and ven_cod = ultcod))
			  + (select (select coalesce(sum(ven_precio),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 3) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 3) and ven_cod = ultcod));
			
			if ventatipofact = 1 then -- contado
				insert into libro_ventas --(libro_ven_cod, ven_cod, ven_exenta, ven_gra5, ven_gra10, ven_iva5, ven_iva10) --select * from libro_ventas
				values(1,ultcod,total_exenta, total_grav5, total_grav10, total_iva5, total_iva10);
			else -- credito
				insert into libro_ventas --(libro_ven_cod, ven_cod, ven_exenta, ven_gra5, ven_gra10, ven_iva5, ven_iva10) --select * from libro_ventas
				values(2,ultcod,total_exenta, total_grav5, total_grav10, total_iva5, total_iva10);
			end if;

			*/
		--------------------- TRABAJAMOS AHORA CON LAS CUENTAS A COBRAR --------------------------------
		if ventatipofact = 2 then -- credito
			monto_cuota:= monto_total/vencuotas::integer;
			vencimiento_cuota := current_date + venplazo::integer;

			while nro_cuota <= vencuotas
			loop
				insert into cuentas_cobrar -- select * from cuentas_cobrar
				(
					ven_cod, ctas_cobrar_nro, ctas_venc, ctas_monto, ctas_saldo, ctas_estado
				)
				values
				(
					ultcod, nro_cuota, vencimiento_cuota, monto_cuota, monto_cuota, 'PENDIENTE'
				);
 
				nro_cuota := nro_cuota+1;
				vencimiento_cuota := vencimiento_cuota + cast(venplazo as integer);
			end loop;
		end if;	
		-----------------------------ACTUALIZAMOS EL NUMERO DE FACTURA -------------------------------------
			-- update timbrados set tim_ultfactura = (select coalesce(max(tim_ultfactura),0)+ 1 from timbrados where timb_cod = timbcod);
			
		raise notice 'LA VENTA FUE REALIZADA EXITOSAMENTE';
	end if;
		-- select sp_ventas(0,1,1,1,2,30,2,'{{1,1,1,2,12000}}', 1)
-- 	ORDEN: codigo, succod, usucod, clicod, ventatipofact, venplazo, vencuotas, detalleventa[ depcod, itemcod, cantidad, venprecio], operacion


-- select * from ventas_cab order by ven_cod desc
-- select * from ventas_det_items where ven_cod = 11
-- select * from libro_compras 
-- select * from libro_ventas order by ven_cod desc
-- select * from cuentas_cobrar
-- select * from cajas
-- select * from detalle_timbrados
-- select * from timbrados
-- select * from v_ventas_detalles
end
$$;
 �   DROP FUNCTION public.sp_ventas(codigo integer, succod integer, usucod integer, clicod integer, ventatipofact integer, venplazo integer, vencuotas integer, detalleventa integer[], operacion integer);
       public          postgres    false            �           1255    342031 h   sp_ventas2(integer, integer, integer, integer, integer, integer, integer, integer[], integer[], integer)    FUNCTION     �&  CREATE FUNCTION public.sp_ventas2(codigo integer, succod integer, usucod integer, clicod integer, ventatipofact integer, venplazo integer, vencuotas integer, detalleventa integer[], libroventas integer[], operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare ultcod integer;
		dimension integer = array_length(detalleventa, 1);
		act_stock record;
		retorno record;
		retornovendet record;
		
	---------variables cuentas a cobrar --------
	nro_cuota integer :=1;
	monto_total integer :=0;
	vencimiento_cuota date;
	monto_cuota integer :=0;

	---------variables libro ventas ----------
	total_iva5 integer =0;	
	total_iva10 integer =0;	
	total_exenta integer =0;	
	total_grav5 integer =0;	
	total_grav10 integer =0;

		
begin
	----------------TRABAJAMOS POR LA CABECERA DE VENTAS -----------------------
	if operacion = 1 then -- insertar
		select coalesce(max(ven_cod),0)+ 1 into ultcod from ventas_cab; -- select * from ventas_cab
		insert into ventas_cab(ven_cod, ven_fecha,ven_estado, emp_cod, suc_cod, usu_cod, fun_cod, cli_cod, tipo_fact_cod, ven_plazo, ven_cuotas)
		values(
			ultcod,
			current_timestamp,
			'PENDIENTE',
			(select emp_cod from sucursales where suc_cod = succod),
			succod,
			usucod,
			(select fun_cod from usuarios where usu_cod = usucod),
			clicod,
			ventatipofact,
			venplazo,
			vencuotas
		); 
		-------------------------TRABAJAMOS AHORA CON LA VENTA DETALLES --------------------------
		for i in 1..dimension loop
			if (select tipo_item_cod from items where item_cod = detalleventa[i][1] ) = 1 then -- producto	
				insert into ventas_det_items (ven_cod, dep_cod, item_cod, mar_cod, ven_cantidad, ven_precio)-- select * from ventas_det_items
				values(
					ultcod,
					detalleventa[i][3],--depcod
					detalleventa[i][1],--itemcod
					detalleventa[i][2],--marcod
					detalleventa[i][4],--vencantidad
					detalleventa[i][5] --venprecio
				);
			else -- servicio
			
				insert into ventas_det_servicios--(ven_cod, dep_cod, item_cod, ven_cantidad, ven_precio) -- select * from ventas_det_servicios
				values(
					ultcod,
					detalleventa[i][1],--itemcod
					detalleventa[i][4],--vencantidad
					detalleventa[i][5] --venprecio
				);
			end if;

			monto_total := monto_total + (detalleventa[i][4]*detalleventa[i][5]); -- monto total de la venta para cuentas cobrar

			--------------- ACTUALIZAMOS AHORA LA CANTIDAD DEL ITEM EN EL STOCK---------------------
				if(select tipo_item_cod from items where item_cod = detalleventa[i][1]) = 1 then --solo actualiza el stock si es de tipo "PRODUCTO"
				 raise notice '%', detalleventa[i][3] ||'-'||detalleventa[i][1]||'-'||detalleventa[i][2]||'-'||detalleventa[i][4]*-1;
				perform sp_stock(detalleventa[i][3], detalleventa[i][1], detalleventa[i][2], detalleventa[i][4]*-1 ); --orden: dep_cod, item_cod, mar_cod, stock_cantidad
			end if;
			
		end loop;
		-------------------- TRABAJAMOS AHORA CON EL LIBRO VENTAS --------------------------------------

			if ventatipofact = 1 then -- contado
				insert into libro_ventas --(libro_ven_cod, ven_cod, ven_exenta, ven_gra5, ven_gra10, ven_iva5, ven_iva10) --select * from libro_ventas
				values(1,ultcod,libroventas[1], libroventas[2] - (libroventas[4]), libroventas[3]- (libroventas[5]), libroventas[4], libroventas[5]);
			else -- credito
				insert into libro_ventas --(libro_ven_cod, ven_cod, ven_exenta, ven_gra5, ven_gra10, ven_iva5, ven_iva10) --select * from libro_ventas
				values(2,ultcod,libroventas[1], (libroventas[2] - libroventas[4]), (libroventas[3] - libroventas[5]), libroventas[4], libroventas[5]);
			end if;
		
			/*
			total_iva5 = (select round(((select coalesce(sum(ven_precio),0) from ventas_det_items where  item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod))/21))
			 + (select round(((select coalesce(sum(ven_precio),0) from ventas_det_servicios where  item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod))/21));
			 
			total_grav5 = (((select coalesce(sum(ven_precio),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod))
			  + ((select coalesce(sum(ven_precio),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 2) and ven_cod = ultcod))) - total_iva5;
			
			total_iva10 = (select round(((select coalesce(sum(ven_precio),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod))/11))
			  + (select round(((select coalesce(sum(ven_precio),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod))/11));
			  
			total_grav10 = ((select coalesce(sum(ven_precio),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod))
			  + ((select coalesce(sum(ven_precio),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 1) and ven_cod = ultcod)) - total_iva10;

			total_exenta = (select (select coalesce(sum(ven_precio),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 3) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_items where item_cod in (select item_cod from items where tipo_imp_cod = 3) and ven_cod = ultcod))
			  + (select (select coalesce(sum(ven_precio),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 3) and ven_cod = ultcod)*(select coalesce(sum(ven_cantidad),0) from ventas_det_servicios where item_cod in (select item_cod from items where tipo_imp_cod = 3) and ven_cod = ultcod));
			
			if ventatipofact = 1 then -- contado
				insert into libro_ventas --(libro_ven_cod, ven_cod, ven_exenta, ven_gra5, ven_gra10, ven_iva5, ven_iva10) --select * from libro_ventas
				values(1,ultcod,total_exenta, total_grav5, total_grav10, total_iva5, total_iva10);
			else -- credito
				insert into libro_ventas --(libro_ven_cod, ven_cod, ven_exenta, ven_gra5, ven_gra10, ven_iva5, ven_iva10) --select * from libro_ventas
				values(2,ultcod,total_exenta, total_grav5, total_grav10, total_iva5, total_iva10);
			end if;

			*/
		--------------------- TRABAJAMOS AHORA CON LAS CUENTAS A COBRAR --------------------------------
		if ventatipofact = 1 then -- contado
			insert into cuentas_cobrar 
			values(
				ultcod, 1, current_date, monto_total, monto_total, 'PENDIENTE', null
			);
		end if;
		if ventatipofact = 2 then -- credito
			monto_cuota:= monto_total/vencuotas::integer;
			vencimiento_cuota := current_date + venplazo::integer;

			while nro_cuota <= vencuotas
			loop
				insert into cuentas_cobrar -- select * from cuentas_cobrar
				(
					ven_cod, ctas_cobrar_nro, ctas_venc, ctas_monto, ctas_saldo, ctas_estado
				)
				values
				(
					ultcod, nro_cuota, vencimiento_cuota, monto_cuota, monto_cuota, 'PENDIENTE'
				);
 
				nro_cuota := nro_cuota+1;
				vencimiento_cuota := vencimiento_cuota + cast(venplazo as integer);
			end loop;
		end if;	
		-----------------------------ACTUALIZAMOS EL NUMERO DE FACTURA -------------------------------------
			-- update timbrados set tim_ultfactura = (select coalesce(max(tim_ultfactura),0)+ 1 from timbrados where timb_cod = timbcod);
			
		raise notice 'LA VENTA FUE REALIZADA EXITOSAMENTE';
	end if;
	
	if operacion = 2 then -- anular
		for retorno in select * from cuentas_cobrar where ven_cod = codigo loop
			if retorno.ctas_estado != 'PENDIENTE' then
				raise exception 'ESTA VENTA NO PUEDE SER ANULADA PUES YA EXISTE UN COBRO PARA ESTE';
			else
				delete from cuentas_cobrar where ven_cod = codigo;
			end if;
		end loop;
		update ventas_cab set ven_estado = 'ANULADO' where ven_cod = codigo;
		delete from libro_ventas where ven_cod = codigo;
		for retorno in select * from ventas_det_items where ven_cod = codigo loop
			perform sp_stock(retorno.dep_cod, retorno.item_cod, retorno.mar_cod, retorno.ven_cantidad);
		end loop;
		
		raise notice 'LA VENTA FUE ANULADA EXITOSAMENTE';
	end if;
	
-- select sp_ventas(0,1,1,1,2,30,2,'{{1,1,1,2,12000}}', 1)
-- 	ORDEN: codigo, succod, usucod, clicod, ventatipofact, venplazo, vencuotas, detalleventa[ depcod, itemcod, cantidad, venprecio], operacion

-- select * from ventas_cab order by ven_cod desc
-- select * from ventas_det_items where ven_cod = 11
-- select * from libro_compras 
-- select * from libro_ventas order by ven_cod desc
-- select * from cuentas_cobrar
-- select * from cajas
-- select * from detalle_timbrados
-- select * from timbrados
-- select * from v_ventas_detalles
end
$$;
 �   DROP FUNCTION public.sp_ventas2(codigo integer, succod integer, usucod integer, clicod integer, ventatipofact integer, venplazo integer, vencuotas integer, detalleventa integer[], libroventas integer[], operacion integer);
       public          postgres    false            �           1255    207107    tg_clientes()    FUNCTION     �  CREATE FUNCTION public.tg_clientes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	if TG_TABLE_NAME = 'clientes' then
		if  TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from clientes 
			where per_cod = new.per_cod -- controla que una misma persona no figure como dos proveedores
			and cli_cod != new.cli_cod;
			if found then
				raise exception 'ESTE CLIENTE YA FUE REGISTRADO';
			else
				perform * from clientes where
				cli_ruc = new.cli_ruc -- contrala que un mismo ruc no sea asignado a distintos clientes
				and cli_cod != new.cli_cod;
				if found then
					raise exception '%','ESTE RUC YA EXISTE.'; -- completar cuando haga la vista;
				else
					return new;
				end if;
			end if;
		end if;
	end if;
end;
$$;
 $   DROP FUNCTION public.tg_clientes();
       public          postgres    false            �           1255    207108    tg_duplicado()    FUNCTION     2-  CREATE FUNCTION public.tg_duplicado() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin

	if 	TG_TABLE_NAME = 'cargos' then
			if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
				perform * from cargos 
				where upper(car_desc) = upper(new.car_desc)
				and car_cod != new.car_cod;
				if found then
					raise exception 'ESTE CARGO YA ESTA REGISTRADO';

				else
					return new;

				end if;
			end if;
	end if;

	if 	TG_TABLE_NAME = 'dias' then
			if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
				perform * from dias 
				where upper(dias_desc) = upper(new.dias_desc)
				and dias_cod != new.dias_cod;
				if found then
					raise exception 'ESTE DIA YA ESTA REGISTRADO';

				else
					return new;

				end if;
			end if;
	end if;

	if TG_TABLE_NAME = 'empresas' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from empresas
			where upper(emp_nom) = upper(new.emp_nom)
			and emp_cod != new.emp_cod;
			if found then 
				raise exception 'ESTA EMPRESA YA FUE REGISTRADO';
			else
				return new;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'sucursales' then
		if TG_OP = 'INSERT' or TG_OP ='UPDATE' then
			perform * from sucursales 
			where upper(suc_nom) = upper(new.suc_nom)
			and suc_cod != new.suc_cod;
			if found then
				raise exception '%','ESTA SUCURSAL YA FUE REGISTRADA';
			else
				return new;
			end if;
			
		end if;
	end if;

	if TG_TABLE_NAME = 'bancos' then
		if TG_OP = 'INSERT' or TG_OP ='UPDATE' then
			perform * from bancos 
			where upper(banco_nom) = upper(new.banco_nom)
			and banco_cod != new.banco_cod;
			if found then
				raise exception '%','ESTE BANCO YA FUE REGISTRADO';
			else
				return new;
			end if;
			
		end if;
	end if;

	if TG_TABLE_NAME = 'clasificaciones' then
		if TG_OP = 'INSERT' or TG_OP ='UPDATE' then
			perform * from clasificaciones 
			where upper(cla_desc) = upper(new.cla_desc)
			and cla_cod != new.cla_cod;
			if found then
				raise exception 'ESTA CLASIFICACION YA FUE REGISTRADO';
			else
				return new;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'estados_civiles' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from estados_civiles
			where esta_desc = new.esta_desc
			and esta_cod != new.esta_cod;
			if found then
				raise exception 'ESTE ESTADO CIVIL YA FUE REGISTRADO';
			else 
				return new;
			end if;
		end if;
	end if;
	if TG_TABLE_NAME = 'generos' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from generos 
			where gen_desc = upper(new.gen_desc)
			and gen_cod != new.gen_cod;
			if found then
				raise exception 'ESTE GENERO YA FUE REGISTRADO';
			else 
				return new;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'depositos' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from depositos 
			where upper(dep_desc) = upper(new.dep_desc) and suc_cod = new.suc_cod --permite que cargue el mismo deposito pero para diferente sucursales
			and dep_cod != new.dep_cod;
			if found then
				raise exception 'ESTE DEPOSITO PARA ESTA SUCURSAL YA FUE REGISTRADO';
			else
				return new;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'entidades_emisoras' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from entidades_emisoras 
			where upper(ent_nom) = upper(new.ent_nom)
			and ent_cod != new.ent_cod;
			if found then
				raise exception 'ESTA ENTIDAD EMISORA YA FUE REGISTRADA';
			else
				return new;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'entidades_adheridas' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from entidades_adheridas 
			where upper(ent_ad_nom) = upper(new.ent_ad_nom) and ent_cod = new.ent_cod -- permite poner la misma entidad adherida para distintas entidades emisoras
			and ent_ad_cod != new.ent_ad_cod;
			if found then
				raise exception 'ESTA ENTIDAD ADHERIDA YA FUE REGISTRADA PARA ESTA ENTIDAD EMISORA';
			else
				return new;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'marca_tarjetas' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from marca_tarjetas 
			where upper(mar_tarj_desc) = upper(new.mar_tarj_desc)
			and mar_tarj_cod != new.mar_tarj_cod;
			if found then
				raise exception 'ESTA MARCA DE TARJETA YA FUE REGISTRADA';
			else
				return new;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'especialidades' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from especialidades 
			where upper(esp_desc) = upper(new.esp_desc)
			and esp_cod != new.esp_cod;
			if found then
				raise exception 'ESTA ESPECIALIDAD YA FUE REGISTRADO';
			else
				return new;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'profesiones' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from profesiones 
			where upper(prof_desc) = upper(new.prof_desc)
			and prof_cod != new.prof_cod;
			if found then
				raise exception 'ESTA PROFESION YA FUE REGISTRADO';
			else
				return new;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'personas' then
		if  TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from personas 
			where per_ci = new.per_ci
			and per_cod != new.per_cod;
			if found then
				raise exception 'ESTA PERSONA YA FUE REGISTRADA';
			else
				return new;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'funcionarios' then
		if  TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from funcionarios 
			where per_cod = new.per_cod -- controla que una misma persona no figure como dos funcionarios
			and fun_cod != new.fun_cod;
			if found then
				raise exception 'ESTE FUNCIONARIO YA FUE REGISTRADO';
			else
				return new;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'proveedores' then
		if  TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from proveedores 
			where per_cod = new.per_cod -- controla que una misma persona no figure como dos proveedores
			and prov_cod != new.prov_cod;
			if found then
				raise exception 'ESTE PROVEEDOR YA FUE REGISTRADO';
			else
				perform * from proveedores where
				prov_ruc = new.prov_ruc -- contrala que un mismo ruc no sea asignado a distintos proveedores
				and prov_cod != new.prov_cod;
				if found then
					raise exception '%','ESTE RUC YA EXISTE. PERTENECE Al PROVEEDOR '||(select per_cod from proveedores where prov_ruc = new.prov_ruc); -- completar cuando haga la vista;
				else
					return new;
				end if;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'usuarios' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform *  from usuarios
			where fun_cod = new.fun_cod  -- controla que un funcionario no tenga dos usuarios
			and usu_cod != new.usu_cod;
			if found then
				raise exception 'ESTE FUNCIONARIO YA TIENE UN USUARIO';
			else
				perform * from usuarios 
				where usu_name = new.usu_name -- controla que no se repita el nombre de usuarios
				and usu_cod != new.usu_cod;
				if found then
					raise exception 'ESTE NOMBRE DE USUARIO YA EXISTE';
				else
					return new;
				end if;

			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'formas_cobros' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from formas_cobros 
			where fcob_desc = upper(new.fcob_desc)
			and fcob_cod != new.fcob_cod;
			if found then
				raise exception 'ESTA FORMA DE COBRO YA FUE REGISTRADA';
			else		
				return new;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'items' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from items 
			where item_desc = upper(new.item_desc)
			and item_cod != new.item_cod;
			if found then
				raise exception 'ESTE ITEM YA FUE REGISTRADA';
			else		
				return new;
			end if;
		end if;
	end if;	

	if TG_TABLE_NAME = 'tipo_impuestos' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from tipo_impuestos  
			where tipo_imp_desc = upper(new.tipo_imp_desc)
			and tipo_imp_cod != new.tipo_imp_cod;
			if found then
				raise exception 'ESTE TIPO DE IMPUESTO YA FUE REGISTRADA';
			else		
				return new;
			end if;
		end if;
	end if;	

	if TG_TABLE_NAME = 'vehiculos_marcas' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from vehiculos_marcas
			where veh_mar_desc = upper(new.veh_mar_desc)
			and veh_mar_cod != new.veh_mar_cod;
			if found then
				raise exception 'ESTA MARCA DE VEHICULO YA FUE REGISTRADA';
			else 
				return new;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'vehiculos_modelos' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from vehiculos_modelos
			where veh_mod_desc = new.veh_mod_desc
			and veh_mod_cod != new.veh_mod_cod;
			if found then
				raise exception 'ESTE MODELO DE VEHICULO YA FUE INSERTADO';
			else
				return new;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'tipo_reclamo_items' then
		if TG_OP = 'INSERT' or  TG_OP = 'UPDATE' then
			perform * from tipo_reclamo_items 
			where tipo_recl_item_desc = upper(new.tipo_recl_item_desc)
			and tipo_recl_item_cod != new.tipo_recl_item_cod;
			if found then
				raise exception 'ESTE TIPO DE RECLAMO ITEMS YA FUE REGISTRADO';
			else
				return new;
			end if;
		end if;
	end if;
	if TG_TABLE_NAME = 'motivo_ajustes' then
		if TG_OP = 'INSERT' or  TG_OP = 'UPDATE' then
			perform * from motivo_ajustes 
			where mot_desc = upper(new.mot_desc)
			and mot_cod != new.mot_cod;
			if found then
				raise exception 'ESTE MOTIVO DE AJUSTE YA FUE REGISTRADO';
			else
				return new;
			end if;
		end if;
	end if;	
	if TG_TABLE_NAME = 'tipo_ajustes' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from tipo_ajustes where
			tipo_ajuste_desc = upper(new.tipo_ajuste_desc)
			and tipo_ajuste_cod != new.tipo_ajuste_cod;
			if found then
				raise exception 'ESTE TIPO DE AJUSTE YA FUE REGISTRADO';
			else 
				return new;
			end if;
		end if;
	end if;
	if TG_TABLE_NAME = 'tipo_personas' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from tipo_personas where
			tipo_pers_desc = upper(new.tipo_pers_desc)
			and tipo_per_cod != new.tipo_per_cod;
			if found then
				raise exception 'EL TIPO DE PERSONAS YA HA SIDO INSERTADO';
			else
				return new;
			end if;
		end if;
	end if;

	if TG_TABLE_NAME = 'paises' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from paises where 
			pais_desc = upper(new.pais_desc)
			and pais_cod != new.pais_cod;
			if found then
				raise exception 'ESTE PAIS YA FUE REGISTRADO';
			else
				return new;
			end if;
		end if;
	end if;
	if TG_TABLE_NAME= 'tipo_reclamos' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from "tipo_reclamos"
			where "tipo_reclamo_desc" = upper(new."tipo_reclamo_desc")
			and "tipo_reclamo_cod" != new."tipo_reclamo_cod";
			if found then
				raise exception 'ESTE TIPO DE RECLAMO YA FUE INSERTADO';
			else
				return new;
			end if;
		end if;
	end if;
	if TG_TABLE_NAME= 'ciudades' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from ciudades
			where ciu_desc = upper(new.ciu_desc) and pais_cod = new.pais_cod -- pueda repetirse en distintos paises
			and ciu_cod != new.ciu_cod;
			if found then
				raise exception 'ESTA CIUDAD PARA ESTE PAIS YA FUE REGISTRADO';
			else
				return new;
			end if;
		end if;
	end if;
	--select sp_vehiculos_marcas(1,'toyota',1)
	/*
		create trigger validarduplicado 
		before insert or update on ciudades
		for each row
		execute procedure tg_duplicado();
		
		select * from ciudades
		
		select sp_tipo_reclamo_items(1,'atencion al cliente',1)

		select sp_usuarios(1,3,1,'cflores','12345',1,'C:\desktop/img.jpg',1) // para insertar
		--ORDEN: usucod, funcod, succod, usunom, usupass, gruid, usufoto, operacion

	*/
end;
$$;
 %   DROP FUNCTION public.tg_duplicado();
       public          postgres    false            �           1255    383090    trg_agendas()    FUNCTION     �  CREATE FUNCTION public.trg_agendas() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	IF TG_TABLE_NAME = 'agendas_cab' OR TG_TABLE_NAME = 'agendas_det' THEN
		IF TG_OP = 'INSERT' THEN
			perform * from agendas_cab
			where fun_cod = new.fun_cod and agen_cod != new.agen_cod;
			if found then
				raise exception 'EL FUNCIONARIO YA TIENE UNA AGENDA, cargue ahi los datos que desea por favor!!';
			else
				return new;
			end if;
		END IF;
	END IF;
end;
$$;
 $   DROP FUNCTION public.trg_agendas();
       public          postgres    false            �           1255    207110    trg_audicargos()    FUNCTION     �  CREATE FUNCTION public.trg_audicargos() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	if TG_OP ='INSERT' then
		insert into auditoria.cargos(car_cod, car_desc_new,aud_accion, aud_fecha, aud_usuario)
		values(new.car_cod, new.car_desc,'INSERCION', current_timestamp,current_user);

		return new;
	end if; 
	if TG_OP = 'UPDATE' THEN
		insert into auditoria.cargos
		values(new.car_cod, new.car_desc,old.car_desc,'MODIFICACION',current_timestamp,current_user);
		return new;
	end if;

	if TG_OP = 'DELETE' then
		insert into auditoria.cargos(car_cod, car_desc_old,aud_accion, aud_fecha, aud_usuario)
		values(old.car_cod,old.car_desc,'BORRADO',current_timestamp, current_user);
		return new;
	end if;
end
$$;
 '   DROP FUNCTION public.trg_audicargos();
       public          postgres    false            �           1255    207111    validarformas_cobros()    FUNCTION     �  CREATE FUNCTION public.validarformas_cobros() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	if TG_TABLE_NAME = 'formas_cobros' then
		if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
			perform * from formas_cobros 
			where fcob_desc = upper(new.fcob_desc)
			and fcob_cod != new.fcob_cod;
			if found then
				raise exception 'ESTA FORMA DE COBRO YA FUE REGISTRADA';
			else		
				return new;
			end if;
		end if;
	end if;
end;
$$;
 -   DROP FUNCTION public.validarformas_cobros();
       public          postgres    false            �            1259    207112    agendas    TABLE     �  CREATE TABLE public.agendas (
    agen_cod integer NOT NULL,
    agen_estado character varying(60) NOT NULL,
    fun_cod integer NOT NULL,
    usu_cod integer NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    agenda_fecha timestamp without time zone,
    fun_agen integer,
    hora_desde time without time zone,
    hora_hasta time without time zone,
    dias_cod integer
);
    DROP TABLE public.agendas;
       public            postgres    false            N           1259    383050    agendas_cab    TABLE       CREATE TABLE public.agendas_cab (
    agen_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    agen_fecha timestamp without time zone,
    agen_estado character varying(20),
    usu_cod integer,
    fun_codigo integer,
    suc_cod integer,
    emp_cod integer
);
    DROP TABLE public.agendas_cab;
       public            postgres    false            O           1259    383070    agendas_det    TABLE     �   CREATE TABLE public.agendas_det (
    agen_cod integer NOT NULL,
    dias_cod integer NOT NULL,
    hora_desde time without time zone NOT NULL,
    hora_hasta time without time zone NOT NULL
);
    DROP TABLE public.agendas_det;
       public            postgres    false            �            1259    207115    ajustes_cab    TABLE     N  CREATE TABLE public.ajustes_cab (
    ajus_cod integer NOT NULL,
    ajus_fecha timestamp without time zone NOT NULL,
    ajus_estado character varying(60) NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    usu_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    ajus_tipo character varying(60) NOT NULL
);
    DROP TABLE public.ajustes_cab;
       public            postgres    false            �            1259    207118    ajustes_det    TABLE     �   CREATE TABLE public.ajustes_det (
    ajus_cod integer NOT NULL,
    dep_cod integer NOT NULL,
    item_cod integer NOT NULL,
    mar_cod integer NOT NULL,
    mot_cod integer NOT NULL,
    ajus_cantidad integer
);
    DROP TABLE public.ajustes_det;
       public            postgres    false            �            1259    207121    aperturas_cierres    TABLE     �  CREATE TABLE public.aperturas_cierres (
    aper_cier_cod integer NOT NULL,
    aper_fecha timestamp without time zone NOT NULL,
    aper_monto integer NOT NULL,
    aper_cier_fecha timestamp without time zone,
    aper_cier_monto integer NOT NULL,
    caja_cod integer NOT NULL,
    usu_cod integer NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    timb_cod integer
);
 %   DROP TABLE public.aperturas_cierres;
       public            postgres    false            �            1259    207124    arqueos    TABLE     �   CREATE TABLE public.arqueos (
    arq_cod integer NOT NULL,
    aper_cier_cod integer NOT NULL,
    arq_cheque integer NOT NULL,
    arq_tarjeta integer NOT NULL,
    arq_efectivo integer NOT NULL
);
    DROP TABLE public.arqueos;
       public            postgres    false            6           1259    268011    asignacion_fondo_fijo    TABLE       CREATE TABLE public.asignacion_fondo_fijo (
    asignacion_responsable_cod integer NOT NULL,
    orden_pago_cod integer NOT NULL,
    ent_cod integer NOT NULL,
    cuenta_corriente_cod integer NOT NULL,
    movimiento_nro integer NOT NULL,
    fecha_asignacion timestamp without time zone,
    caja_cod integer NOT NULL,
    monto_asignado numeric NOT NULL,
    observacion character varying(120),
    fun_cod integer NOT NULL,
    usu_cod integer NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL
);
 )   DROP TABLE public.asignacion_fondo_fijo;
       public            postgres    false            �            1259    207127    avisos_recordatorios    TABLE     �  CREATE TABLE public.avisos_recordatorios (
    aviso_cod integer NOT NULL,
    aviso_desc character varying(60) NOT NULL,
    emp_cod integer NOT NULL,
    suc_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    aviso_estado character varying(60) NOT NULL,
    cli_cod integer NOT NULL,
    aviso_hora time without time zone,
    usu_cod integer NOT NULL,
    item_cod integer NOT NULL
);
 (   DROP TABLE public.avisos_recordatorios;
       public            postgres    false            �            1259    207130    bancos    TABLE     �   CREATE TABLE public.bancos (
    banco_cod integer NOT NULL,
    banco_nom character varying(60) NOT NULL,
    banco_dir character varying(60) NOT NULL,
    banco_tel character varying(20) NOT NULL
);
    DROP TABLE public.bancos;
       public            postgres    false            7           1259    268062    boleta_deposito    TABLE     L  CREATE TABLE public.boleta_deposito (
    ent_cod integer NOT NULL,
    cuenta_corriente_cod integer NOT NULL,
    movimiento_nro integer NOT NULL,
    recau_dep_cod integer NOT NULL,
    aper_cier_cod integer NOT NULL,
    fecha_deposito timestamp without time zone,
    monto numeric NOT NULL,
    estado character varying(20)
);
 #   DROP TABLE public.boleta_deposito;
       public            postgres    false            �            1259    207133    cajas    TABLE     &  CREATE TABLE public.cajas (
    caja_cod integer NOT NULL,
    caja_desc character varying(60) NOT NULL,
    caja_estado character varying(30) NOT NULL,
    suc_cod integer NOT NULL,
    caja_ultrecibo integer NOT NULL,
    emp_cod integer NOT NULL,
    usu_cod integer,
    fun_cod integer
);
    DROP TABLE public.cajas;
       public            postgres    false            �            1259    207136    cargos    TABLE     j   CREATE TABLE public.cargos (
    car_cod integer NOT NULL,
    car_desc character varying(60) NOT NULL
);
    DROP TABLE public.cargos;
       public            postgres    false            �            1259    207139    cheque    TABLE     �   CREATE TABLE public.cheque (
    cheque_cod integer NOT NULL,
    banco_cod integer NOT NULL,
    cheque_tipo_cod integer NOT NULL,
    cheque_cta_nro integer NOT NULL,
    cheque_nro integer NOT NULL
);
    DROP TABLE public.cheque;
       public            postgres    false            L           1259    366740    choferes    TABLE     �   CREATE TABLE public.choferes (
    chofer_cod integer NOT NULL,
    per_cod integer NOT NULL,
    chofer_ruc character varying(60) NOT NULL
);
    DROP TABLE public.choferes;
       public            postgres    false            �            1259    207142    ciudades    TABLE     �   CREATE TABLE public.ciudades (
    ciu_cod integer NOT NULL,
    ciu_desc character varying(60) NOT NULL,
    pais_cod integer
);
    DROP TABLE public.ciudades;
       public            postgres    false            �            1259    207145    clasificaciones    TABLE     s   CREATE TABLE public.clasificaciones (
    cla_cod integer NOT NULL,
    cla_desc character varying(60) NOT NULL
);
 #   DROP TABLE public.clasificaciones;
       public            postgres    false            �            1259    207148    clientes    TABLE     �   CREATE TABLE public.clientes (
    cli_cod integer NOT NULL,
    per_cod integer NOT NULL,
    cli_estado character varying(60) NOT NULL,
    cli_ruc character varying(20),
    cli_fecha_alta date,
    cli_fecha_baja date
);
    DROP TABLE public.clientes;
       public            postgres    false            �            1259    207151 
   cobros_cab    TABLE     �  CREATE TABLE public.cobros_cab (
    cobro_cod integer NOT NULL,
    cobro_fecha timestamp without time zone NOT NULL,
    cobro_efectivo integer NOT NULL,
    cobro_estado character varying(60) NOT NULL,
    aper_cier_cod integer NOT NULL,
    cobro_recibo integer,
    usu_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    fcob_cod integer
);
    DROP TABLE public.cobros_cab;
       public            postgres    false            �            1259    207154    cobros_cheques    TABLE     �  CREATE TABLE public.cobros_cheques (
    cobro_cod integer NOT NULL,
    ch_cuenta_num integer NOT NULL,
    serie character varying(4) NOT NULL,
    cheq_num integer NOT NULL,
    cheq_importe integer,
    fecha_emision date,
    fecha_recepcion date,
    fecha_cobro date,
    librador character varying(60),
    banco_cod integer,
    cheque_tipo_cod integer,
    cheque_estado character varying(10)
);
 "   DROP TABLE public.cobros_cheques;
       public            postgres    false            �            1259    207157 
   cobros_det    TABLE     �   CREATE TABLE public.cobros_det (
    cobro_cod integer NOT NULL,
    ven_cod integer NOT NULL,
    ctas_cobrar_nro integer NOT NULL,
    cobro_monto integer NOT NULL
);
    DROP TABLE public.cobros_det;
       public            postgres    false            �            1259    207160    cobros_tarjetas    TABLE       CREATE TABLE public.cobros_tarjetas (
    cobro_cod integer NOT NULL,
    mar_tarj_cod integer NOT NULL,
    cob_tarj_nro integer NOT NULL,
    cod_auto integer NOT NULL,
    ent_cod integer NOT NULL,
    ent_ad_cod integer NOT NULL,
    tarj_monto integer NOT NULL
);
 #   DROP TABLE public.cobros_tarjetas;
       public            postgres    false            R           1259    383093    compras_cab    TABLE     �  CREATE TABLE public.compras_cab (
    comp_cod integer NOT NULL,
    prov_cod integer NOT NULL,
    prov_timb_nro integer NOT NULL,
    prov_timb_vig date NOT NULL,
    nro_factura character varying NOT NULL,
    comp_fecha timestamp without time zone,
    comp_fecha_factura date,
    comp_estado character varying(20),
    tipo_fact_cod integer NOT NULL,
    comp_plazo integer,
    comp_cuotas integer,
    usu_cod integer,
    fun_cod integer,
    suc_cod integer,
    emp_cod integer
);
    DROP TABLE public.compras_cab;
       public            postgres    false            S           1259    383116    compras_det    TABLE       CREATE TABLE public.compras_det (
    comp_cod integer NOT NULL,
    dep_cod integer NOT NULL,
    item_cod integer NOT NULL,
    mar_cod integer NOT NULL,
    comp_cantidad integer NOT NULL,
    comp_costo numeric NOT NULL,
    comp_precio numeric NOT NULL
);
    DROP TABLE public.compras_det;
       public            postgres    false            �            1259    207169    cuentas_cobrar    TABLE     '  CREATE TABLE public.cuentas_cobrar (
    ven_cod integer NOT NULL,
    ctas_cobrar_nro integer NOT NULL,
    ctas_venc date NOT NULL,
    ctas_monto integer NOT NULL,
    ctas_saldo integer NOT NULL,
    ctas_estado character varying(60) NOT NULL,
    fecha_cobro timestamp without time zone
);
 "   DROP TABLE public.cuentas_cobrar;
       public            postgres    false            1           1259    259760    cuentas_corrientes    TABLE     �   CREATE TABLE public.cuentas_corrientes (
    ent_cod integer NOT NULL,
    cuenta_corriente_cod integer NOT NULL,
    cuenta_corriente_nro integer NOT NULL,
    monto_disponible numeric
);
 &   DROP TABLE public.cuentas_corrientes;
       public            postgres    false            T           1259    383134    cuentas_pagar    TABLE     �   CREATE TABLE public.cuentas_pagar (
    comp_cod integer NOT NULL,
    ctas_pagar_nro integer NOT NULL,
    ctas_venc date,
    ctas_monto integer,
    ctas_saldo integer,
    ctas_estado character varying(20)
);
 !   DROP TABLE public.cuentas_pagar;
       public            postgres    false            ,           1259    251521    cuentas_pagar_fact_varias    TABLE     \  CREATE TABLE public.cuentas_pagar_fact_varias (
    fact_var_cod integer NOT NULL,
    prov_cod integer NOT NULL,
    cuentas_pagar_fact_var_nro integer NOT NULL,
    cuotas integer,
    plazo integer,
    cuotas_monto numeric,
    cuotas_saldo numeric,
    cuotas_estado character varying(20),
    cuotas_fecha_pago timestamp without time zone
);
 -   DROP TABLE public.cuentas_pagar_fact_varias;
       public            postgres    false            2           1259    259773    cuentas_titulares    TABLE     �   CREATE TABLE public.cuentas_titulares (
    titular_cod integer NOT NULL,
    ent_cod integer NOT NULL,
    cuenta_corriente_cod integer,
    cuenta_estado character varying(20),
    observacion character varying(250)
);
 %   DROP TABLE public.cuentas_titulares;
       public            postgres    false            B           1259    358455 
   cuotapagar    TABLE     ;   CREATE TABLE public.cuotapagar (
    "?column?" integer
);
    DROP TABLE public.cuotapagar;
       public            postgres    false            �            1259    207175 	   depositos    TABLE     �   CREATE TABLE public.depositos (
    dep_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    suc_cod integer NOT NULL,
    dep_desc character varying(60) NOT NULL,
    dep_estado character varying(60) NOT NULL
);
    DROP TABLE public.depositos;
       public            postgres    false            �            1259    207178 
   descuentos    TABLE     Y  CREATE TABLE public.descuentos (
    descuento_cod integer NOT NULL,
    item_cod integer NOT NULL,
    descuento_incial integer NOT NULL,
    descuento_nro integer NOT NULL,
    descuento_rebaje integer NOT NULL,
    descuento_monto integer NOT NULL,
    descuento_final integer NOT NULL,
    descuento_estado character varying(60) NOT NULL
);
    DROP TABLE public.descuentos;
       public            postgres    false            �            1259    207181    detalle_timbrados    TABLE     h   CREATE TABLE public.detalle_timbrados (
    caja_cod integer NOT NULL,
    timb_cod integer NOT NULL
);
 %   DROP TABLE public.detalle_timbrados;
       public            postgres    false            �            1259    207184    dias    TABLE     j   CREATE TABLE public.dias (
    dias_cod integer NOT NULL,
    dias_desc character varying(60) NOT NULL
);
    DROP TABLE public.dias;
       public            postgres    false            �            1259    207187    empresas    TABLE       CREATE TABLE public.empresas (
    emp_cod integer NOT NULL,
    emp_nom character varying(60) NOT NULL,
    emp_ruc character varying(60) NOT NULL,
    emp_dir character varying(60) NOT NULL,
    emp_tel character varying(60) NOT NULL,
    emp_email character varying(60) NOT NULL
);
    DROP TABLE public.empresas;
       public            postgres    false            �            1259    207190    entidades_adheridas    TABLE     L  CREATE TABLE public.entidades_adheridas (
    ent_ad_cod integer NOT NULL,
    ent_cod integer NOT NULL,
    mar_tarj_cod integer NOT NULL,
    ent_ad_nom character varying(60) NOT NULL,
    ent_ad_dir character varying(60) NOT NULL,
    ent_ad_tel character varying(60) NOT NULL,
    ent_ad_email character varying(60) NOT NULL
);
 '   DROP TABLE public.entidades_adheridas;
       public            postgres    false            �            1259    207193    entidades_emisoras    TABLE     �   CREATE TABLE public.entidades_emisoras (
    ent_cod integer NOT NULL,
    ent_nom character varying(60) NOT NULL,
    ent_dir character varying(60) NOT NULL,
    ent_tel character varying(60) NOT NULL,
    ent_email character varying(60) NOT NULL
);
 &   DROP TABLE public.entidades_emisoras;
       public            postgres    false            �            1259    207196    equipos_trabajos    TABLE     �   CREATE TABLE public.equipos_trabajos (
    equi_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    ord_trab_cod integer NOT NULL,
    item_cod integer NOT NULL,
    equi_fecha date NOT NULL,
    equi_desc character varying(60) NOT NULL
);
 $   DROP TABLE public.equipos_trabajos;
       public            postgres    false            �            1259    207199    especialidades    TABLE     �   CREATE TABLE public.especialidades (
    esp_cod integer NOT NULL,
    esp_desc character varying(60) NOT NULL,
    esp_estado character varying(60) NOT NULL
);
 "   DROP TABLE public.especialidades;
       public            postgres    false            �            1259    207202    estados_civiles    TABLE     u   CREATE TABLE public.estados_civiles (
    esta_cod integer NOT NULL,
    esta_desc character varying(60) NOT NULL
);
 #   DROP TABLE public.estados_civiles;
       public            postgres    false            *           1259    251468    facturas_varias_cab    TABLE     �  CREATE TABLE public.facturas_varias_cab (
    fact_var_cod integer NOT NULL,
    prov_cod integer NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    usu_cod integer NOT NULL,
    fecha_ope timestamp without time zone,
    tipo_doc_cod integer NOT NULL,
    nro_factura integer NOT NULL,
    fecha_fact date,
    tipo_fact_cod integer NOT NULL,
    estado character varying(20)
);
 '   DROP TABLE public.facturas_varias_cab;
       public            postgres    false            +           1259    251498    facturas_varias_det    TABLE     %  CREATE TABLE public.facturas_varias_det (
    fact_var_cod integer NOT NULL,
    prov_cod integer NOT NULL,
    rubro_cod integer NOT NULL,
    tipo_imp_cod integer NOT NULL,
    monto numeric,
    grav10 integer,
    grav5 integer,
    exentas integer,
    iva10 integer,
    iva5 integer
);
 '   DROP TABLE public.facturas_varias_det;
       public            postgres    false            �            1259    207205    formas_cobros    TABLE     s   CREATE TABLE public.formas_cobros (
    fcob_cod integer NOT NULL,
    fcob_desc character varying(60) NOT NULL
);
 !   DROP TABLE public.formas_cobros;
       public            postgres    false            �            1259    207208    funcionarios    TABLE       CREATE TABLE public.funcionarios (
    fun_cod integer NOT NULL,
    per_cod integer NOT NULL,
    car_cod integer NOT NULL,
    fun_estado character varying(60) NOT NULL,
    fun_fecha_alta date,
    fun_fecha_baja date,
    prof_cod integer,
    esp_cod integer
);
     DROP TABLE public.funcionarios;
       public            postgres    false            �            1259    207211    generos    TABLE     k   CREATE TABLE public.generos (
    gen_cod integer NOT NULL,
    gen_desc character varying(60) NOT NULL
);
    DROP TABLE public.generos;
       public            postgres    false            �            1259    207217    items    TABLE     �   CREATE TABLE public.items (
    item_cod integer NOT NULL,
    tipo_item_cod integer NOT NULL,
    item_desc character varying(60) NOT NULL,
    item_estado character varying(60) NOT NULL,
    item_precio integer NOT NULL,
    tipo_imp_cod integer
);
    DROP TABLE public.items;
       public            postgres    false            U           1259    383144    libro_compras    TABLE     �   CREATE TABLE public.libro_compras (
    comp_cod integer NOT NULL,
    comp_exenta integer,
    comp_gra5 integer,
    comp_gra10 integer,
    iva5 integer,
    iva10 integer
);
 !   DROP TABLE public.libro_compras;
       public            postgres    false            �            1259    207223    libro_ventas    TABLE     �  CREATE TABLE public.libro_ventas (
    libro_ven_cod integer NOT NULL,
    ven_cod integer NOT NULL,
    ven_exenta integer,
    ven_gra5 integer,
    ven_gra10 integer,
    ven_iva5 double precision,
    ven_iva10 double precision,
    venta_nro_fact character varying(20),
    timb_cod integer,
    fecha_vdesde_tim date,
    fecha_vhasta_tim date,
    fecha_factura timestamp without time zone,
    cobro_cod integer
);
     DROP TABLE public.libro_ventas;
       public            postgres    false            �            1259    207226    marca_tarjetas    TABLE     |   CREATE TABLE public.marca_tarjetas (
    mar_tarj_cod integer NOT NULL,
    mar_tarj_desc character varying(60) NOT NULL
);
 "   DROP TABLE public.marca_tarjetas;
       public            postgres    false            �            1259    207229    marcas    TABLE     j   CREATE TABLE public.marcas (
    mar_cod integer NOT NULL,
    mar_desc character varying(60) NOT NULL
);
    DROP TABLE public.marcas;
       public            postgres    false                       1259    208584    marcas_items    TABLE     �   CREATE TABLE public.marcas_items (
    item_cod integer NOT NULL,
    mar_cod integer NOT NULL,
    costo integer,
    precio integer,
    item_min integer,
    item_max integer,
    item_estado character varying(20)
);
     DROP TABLE public.marcas_items;
       public            postgres    false            �            1259    207232    modulos    TABLE     j   CREATE TABLE public.modulos (
    mod_id integer NOT NULL,
    mod_desc character varying(60) NOT NULL
);
    DROP TABLE public.modulos;
       public            postgres    false            �            1259    207235    motivo_ajustes    TABLE     r   CREATE TABLE public.motivo_ajustes (
    mot_cod integer NOT NULL,
    mot_desc character varying(60) NOT NULL
);
 "   DROP TABLE public.motivo_ajustes;
       public            postgres    false            3           1259    267892    movimiento_bancario    TABLE       CREATE TABLE public.movimiento_bancario (
    ent_cod integer NOT NULL,
    cuenta_corriente_cod integer NOT NULL,
    movimiento_nro integer NOT NULL,
    fecha_ope timestamp without time zone,
    fecha_deposito timestamp without time zone,
    fecha_extraccion timestamp without time zone,
    movimiento_monto_debito numeric,
    movimietno_monto_credito numeric,
    estado character varying(20),
    conciliar character varying(60),
    usu_cod integer,
    fun_cod integer,
    suc_cod integer,
    emp_cod integer
);
 '   DROP TABLE public.movimiento_bancario;
       public            postgres    false            X           1259    391292    notas_com_cab    TABLE     a  CREATE TABLE public.notas_com_cab (
    nota_com_nro integer NOT NULL,
    comp_cod integer NOT NULL,
    nota_com_fecha_factura date NOT NULL,
    nota_com_timbrado integer NOT NULL,
    nota_com_tim_vighasta date NOT NULL,
    nota_com_factura character varying(20) NOT NULL,
    nota_com_fecha timestamp without time zone,
    nota_com_estado character varying(20),
    nota_com_tipo character varying(20),
    fun_cod integer,
    usu_cod integer,
    suc_cod integer,
    emp_cod integer,
    nota_monto integer,
    nota_descripcion character varying(120),
    nota_cred_motivo character varying(40)
);
 !   DROP TABLE public.notas_com_cab;
       public            postgres    false            Y           1259    391312    notas_com_det    TABLE     %  CREATE TABLE public.notas_com_det (
    nota_com_nro integer NOT NULL,
    comp_cod integer NOT NULL,
    dep_cod integer NOT NULL,
    item_cod integer NOT NULL,
    mar_cod integer NOT NULL,
    nota_com_cant integer,
    nota_com_precio integer,
    nota_com_desc character varying(120)
);
 !   DROP TABLE public.notas_com_det;
       public            postgres    false            b           1259    432284    notas_remisiones_cab    TABLE     �  CREATE TABLE public.notas_remisiones_cab (
    nota_rem_cod integer NOT NULL,
    ven_cod integer NOT NULL,
    nota_rem_fecha timestamp without time zone,
    nota_rem_estado character varying(20),
    vehi_cod integer,
    chofer_cod integer,
    remision_tipo character varying(20),
    chofer_timb numeric,
    chofer_timb_vighasta date,
    chofer_factura character varying(20),
    chofer_monto numeric,
    usu_cod integer,
    fun_cod integer,
    suc_cod integer,
    emp_cod integer
);
 (   DROP TABLE public.notas_remisiones_cab;
       public            postgres    false            c           1259    432307    notas_remisiones_det    TABLE     �   CREATE TABLE public.notas_remisiones_det (
    nota_rem_cod integer NOT NULL,
    item_cod integer,
    mar_cod integer,
    nota_rem_cant integer,
    nota_rem_precio numeric
);
 (   DROP TABLE public.notas_remisiones_det;
       public            postgres    false            `           1259    415920    notas_ven_cab    TABLE     j  CREATE TABLE public.notas_ven_cab (
    nota_ven_cod integer NOT NULL,
    ven_cod integer NOT NULL,
    nota_ven_nro_fact character varying(20) NOT NULL,
    nota_ven_fecha timestamp without time zone NOT NULL,
    nota_ven_estado character varying(60) NOT NULL,
    timb_cod integer NOT NULL,
    cli_cod integer NOT NULL,
    nota_ven_tipo character varying(60) NOT NULL,
    nota_ven_motivo character varying(20) NOT NULL,
    nota_monto numeric,
    nota_descripcion character varying(256),
    fun_cod integer NOT NULL,
    usu_cod integer NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL
);
 !   DROP TABLE public.notas_ven_cab;
       public            postgres    false            _           1259    415912    notas_ven_det    TABLE     !  CREATE TABLE public.notas_ven_det (
    nota_ven_cod integer NOT NULL,
    dep_cod integer NOT NULL,
    item_cod integer NOT NULL,
    mar_cod integer NOT NULL,
    nota_ven_cant integer NOT NULL,
    nota_ven_precio integer NOT NULL,
    nota_ven_desc character varying(200) NOT NULL
);
 !   DROP TABLE public.notas_ven_det;
       public            postgres    false            �            1259    207250    ordcompras_cab    TABLE     �  CREATE TABLE public.ordcompras_cab (
    orden_nro integer NOT NULL,
    orden_fecha timestamp without time zone NOT NULL,
    orden_plazo integer NOT NULL,
    orden_cuotas integer NOT NULL,
    orden_estado character varying(60) NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    usu_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    prov_cod integer NOT NULL,
    tipo_fact_cod integer NOT NULL
);
 "   DROP TABLE public.ordcompras_cab;
       public            postgres    false            �            1259    207253    ordcompras_det    TABLE     �   CREATE TABLE public.ordcompras_det (
    orden_nro integer NOT NULL,
    item_cod integer NOT NULL,
    mar_cod integer NOT NULL,
    orden_cantidad integer NOT NULL,
    orden_precio integer
);
 "   DROP TABLE public.ordcompras_det;
       public            postgres    false            �            1259    207256    orden_compra    TABLE     d   CREATE TABLE public.orden_compra (
    comp_cod integer NOT NULL,
    orden_cod integer NOT NULL
);
     DROP TABLE public.orden_compra;
       public            postgres    false            -           1259    259656    orden_pago_cab    TABLE     @  CREATE TABLE public.orden_pago_cab (
    orden_pago_cod integer NOT NULL,
    prov_cod integer,
    nro_factura character varying(20),
    fcob_cod integer,
    fecha_ope timestamp without time zone,
    estado character varying(20),
    usu_cod integer,
    fun_cod integer,
    suc_cod integer,
    emp_cod integer
);
 "   DROP TABLE public.orden_pago_cab;
       public            postgres    false            /           1259    259720    orden_pago_det_compras    TABLE     !  CREATE TABLE public.orden_pago_det_compras (
    orden_pago_cod integer NOT NULL,
    prov_cod integer NOT NULL,
    prov_timb_nro integer NOT NULL,
    nro_factura character varying(60) NOT NULL,
    ctas_pagar_nro integer NOT NULL,
    estado character varying(20),
    monto numeric
);
 *   DROP TABLE public.orden_pago_det_compras;
       public            postgres    false            .           1259    259696    orden_pago_detalle_fact_varias    TABLE     �   CREATE TABLE public.orden_pago_detalle_fact_varias (
    orden_pago_cod integer,
    fact_var_cod integer NOT NULL,
    prov_cod integer NOT NULL,
    cuentas_pagar_fact_var_nro integer NOT NULL,
    monto numeric,
    estado character varying(20)
);
 2   DROP TABLE public.orden_pago_detalle_fact_varias;
       public            postgres    false            �            1259    207259    ordenes_trabajos_cab    TABLE     _  CREATE TABLE public.ordenes_trabajos_cab (
    ord_trab_cod integer NOT NULL,
    ord_trab_nro integer NOT NULL,
    emp_cod integer NOT NULL,
    suc_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    ord_trab_fecha date NOT NULL,
    ord_trab_estado character varying(60) NOT NULL,
    cli_cod integer NOT NULL,
    usu_cod integer NOT NULL
);
 (   DROP TABLE public.ordenes_trabajos_cab;
       public            postgres    false            �            1259    207262    ordenes_trabajos_det    TABLE     �  CREATE TABLE public.ordenes_trabajos_det (
    ord_trab_cod integer NOT NULL,
    item_cod integer NOT NULL,
    orden_precio integer,
    orden_hdesde time without time zone,
    orden_hhasta time without time zone,
    ord_trab_desc character varying(120),
    fun_cod integer NOT NULL,
    orden_estado character varying(20),
    observacion character varying(120),
    orden_fecha date
);
 (   DROP TABLE public.ordenes_trabajos_det;
       public            postgres    false            5           1259    267998    otros_cred_deb_bancarios    TABLE     0  CREATE TABLE public.otros_cred_deb_bancarios (
    otro_deb_cred_ban_cod integer NOT NULL,
    ent_cod integer NOT NULL,
    cuenta_corriente_cod integer NOT NULL,
    movimiento_nro integer NOT NULL,
    descripcion character varying(250) NOT NULL,
    tipo_movimiento character varying(20) NOT NULL
);
 ,   DROP TABLE public.otros_cred_deb_bancarios;
       public            postgres    false            �            1259    207265    paginas    TABLE     �   CREATE TABLE public.paginas (
    pag_id integer NOT NULL,
    mod_id integer NOT NULL,
    pag_desc character varying(60) NOT NULL,
    pag_seccion_menu character varying(60) NOT NULL
);
    DROP TABLE public.paginas;
       public            postgres    false            4           1259    267980    pago_cheques    TABLE     )  CREATE TABLE public.pago_cheques (
    orden_pago_cod integer NOT NULL,
    ent_cod integer NOT NULL,
    cuenta_corriente_cod integer NOT NULL,
    movimiento_nro integer NOT NULL,
    estado character varying(20),
    monto_cheque numeric NOT NULL,
    fecha_pago timestamp without time zone
);
     DROP TABLE public.pago_cheques;
       public            postgres    false            �            1259    207268    paises    TABLE     l   CREATE TABLE public.paises (
    pais_cod integer NOT NULL,
    pais_desc character varying(60) NOT NULL
);
    DROP TABLE public.paises;
       public            postgres    false            �            1259    207271    pedido_orden    TABLE     c   CREATE TABLE public.pedido_orden (
    ped_cod integer NOT NULL,
    orden_cod integer NOT NULL
);
     DROP TABLE public.pedido_orden;
       public            postgres    false            �            1259    207274    pedidos_cab    TABLE       CREATE TABLE public.pedidos_cab (
    ped_nro integer NOT NULL,
    ped_fecha timestamp without time zone NOT NULL,
    ped_estado character varying(60) NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    usu_cod integer NOT NULL
);
    DROP TABLE public.pedidos_cab;
       public            postgres    false            �            1259    207277    pedidos_det    TABLE     �   CREATE TABLE public.pedidos_det (
    ped_nro integer NOT NULL,
    item_cod integer NOT NULL,
    mar_cod integer NOT NULL,
    ped_cantidad integer NOT NULL,
    ped_precio integer
);
    DROP TABLE public.pedidos_det;
       public            postgres    false            �            1259    207280    pedidos_vcab    TABLE     [  CREATE TABLE public.pedidos_vcab (
    ped_vcod integer NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    ped_fecha timestamp without time zone NOT NULL,
    ped_nro integer NOT NULL,
    ped_estado character varying(60) NOT NULL,
    fun_cod integer NOT NULL,
    cli_cod integer NOT NULL,
    usu_cod integer NOT NULL
);
     DROP TABLE public.pedidos_vcab;
       public            postgres    false            �            1259    207283    pedidos_vdet    TABLE     �   CREATE TABLE public.pedidos_vdet (
    ped_vcod integer NOT NULL,
    item_cod integer NOT NULL,
    mar_cod integer NOT NULL,
    ped_cantidad integer NOT NULL,
    ped_precio integer
);
     DROP TABLE public.pedidos_vdet;
       public            postgres    false            �            1259    207214    perfiles    TABLE     r   CREATE TABLE public.perfiles (
    perfil_cod integer NOT NULL,
    perfil_desc character varying(60) NOT NULL
);
    DROP TABLE public.perfiles;
       public            postgres    false            �            1259    207286    permisos    TABLE     4  CREATE TABLE public.permisos (
    pag_id integer NOT NULL,
    mod_id integer NOT NULL,
    per_insert character varying(60) NOT NULL,
    per_update character varying(60) NOT NULL,
    per_delete character varying(60) NOT NULL,
    per_select character varying(60) NOT NULL,
    gru_id integer NOT NULL
);
    DROP TABLE public.permisos;
       public            postgres    false            �            1259    207289    personas    TABLE     �  CREATE TABLE public.personas (
    per_cod integer NOT NULL,
    per_nom character varying(60) NOT NULL,
    per_ape character varying(60) NOT NULL,
    per_dir character varying(60) NOT NULL,
    per_tel character varying(60) NOT NULL,
    per_ci character varying(60) NOT NULL,
    per_fenac date NOT NULL,
    per_email character varying(60) NOT NULL,
    pais_cod integer NOT NULL,
    ciu_cod integer NOT NULL,
    gen_cod integer NOT NULL,
    tipo_per_cod integer NOT NULL,
    esta_cod integer
);
    DROP TABLE public.personas;
       public            postgres    false            �            1259    207292    presupuestos_cab    TABLE     g  CREATE TABLE public.presupuestos_cab (
    presu_cod integer NOT NULL,
    presu_fecha timestamp without time zone NOT NULL,
    presu_validez date NOT NULL,
    presu_estado character varying(30) NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    cli_cod integer NOT NULL,
    usu_cod integer NOT NULL
);
 $   DROP TABLE public.presupuestos_cab;
       public            postgres    false            $           1259    216941    presupuestos_det_items    TABLE     �   CREATE TABLE public.presupuestos_det_items (
    presu_cod integer NOT NULL,
    item_cod integer,
    mar_cod integer,
    presu_cantidad integer,
    presu_precio integer
);
 *   DROP TABLE public.presupuestos_det_items;
       public            postgres    false            �            1259    207295    presupuestos_det_servicios    TABLE     �   CREATE TABLE public.presupuestos_det_servicios (
    presu_cod integer NOT NULL,
    item_cod integer NOT NULL,
    presu_cantidad integer NOT NULL,
    presu_precio integer NOT NULL
);
 .   DROP TABLE public.presupuestos_det_servicios;
       public            postgres    false            C           1259    358494    presupuestos_proveedores_cab    TABLE     �  CREATE TABLE public.presupuestos_proveedores_cab (
    pre_prov_cod integer NOT NULL,
    prov_cod integer NOT NULL,
    pre_prov_fecha timestamp without time zone NOT NULL,
    pre_prov_estado character varying(20),
    pre_prov_validez date NOT NULL,
    pre_prov_fecha_operacion timestamp without time zone,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    usu_cod integer NOT NULL
);
 0   DROP TABLE public.presupuestos_proveedores_cab;
       public            postgres    false            D           1259    358514    presupuestos_proveedores_det    TABLE     ;  CREATE TABLE public.presupuestos_proveedores_det (
    pre_prov_cod integer NOT NULL,
    prov_cod integer NOT NULL,
    pre_prov_fecha timestamp without time zone NOT NULL,
    item_cod integer NOT NULL,
    mar_cod integer NOT NULL,
    pre_prov_cantidad integer NOT NULL,
    pre_prov_precio numeric NOT NULL
);
 0   DROP TABLE public.presupuestos_proveedores_det;
       public            postgres    false            �            1259    207298    profesiones    TABLE     q   CREATE TABLE public.profesiones (
    prof_cod integer NOT NULL,
    prof_desc character varying(60) NOT NULL
);
    DROP TABLE public.profesiones;
       public            postgres    false            �            1259    207301 
   promos_cab    TABLE     �  CREATE TABLE public.promos_cab (
    promo_cod integer NOT NULL,
    promo_dfecha timestamp without time zone NOT NULL,
    promo_feinicio date NOT NULL,
    promo_fefin date NOT NULL,
    promo_estado character varying(60) NOT NULL,
    usu_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    promo_desc character varying(120)
);
    DROP TABLE public.promos_cab;
       public            postgres    false            "           1259    216914    promos_det_items    TABLE     �   CREATE TABLE public.promos_det_items (
    promo_cod integer NOT NULL,
    item_cod integer NOT NULL,
    mar_cod integer NOT NULL,
    descuento integer,
    promo_precio integer,
    tipo_desc character varying(20)
);
 $   DROP TABLE public.promos_det_items;
       public            postgres    false            �            1259    207304    promos_det_servicios    TABLE     �   CREATE TABLE public.promos_det_servicios (
    promo_cod integer NOT NULL,
    item_cod integer NOT NULL,
    promo_desc integer NOT NULL,
    promo_precio integer,
    tipo_desc character varying(20)
);
 (   DROP TABLE public.promos_det_servicios;
       public            postgres    false            �            1259    207307    proveedor_timbrados    TABLE     �   CREATE TABLE public.proveedor_timbrados (
    prov_cod integer NOT NULL,
    prov_timb_nro integer NOT NULL,
    prov_tim_vighasta date
);
 '   DROP TABLE public.proveedor_timbrados;
       public            postgres    false            �            1259    207310    proveedores    TABLE     �   CREATE TABLE public.proveedores (
    prov_cod integer NOT NULL,
    per_cod integer NOT NULL,
    prov_ruc character varying(60),
    prov_estado character varying(20),
    prov_fecha_alta date,
    prov_fecha_baja date
);
    DROP TABLE public.proveedores;
       public            postgres    false            �            1259    207313    recaudaciones_dep    TABLE     �   CREATE TABLE public.recaudaciones_dep (
    recau_dep_cod integer NOT NULL,
    aper_cier_cod integer NOT NULL,
    recaudaciones_fecha date,
    monto_efectivo integer,
    monto_cheque integer
);
 %   DROP TABLE public.recaudaciones_dep;
       public            postgres    false            �            1259    207316    reclamo_clientes    TABLE     �  CREATE TABLE public.reclamo_clientes (
    reclamo_cod integer NOT NULL,
    tipo_reclamo_cod integer NOT NULL,
    reclamo_desc text NOT NULL,
    emp_cod integer NOT NULL,
    suc_reclamo integer NOT NULL,
    fun_cod integer NOT NULL,
    cli_cod integer NOT NULL,
    reclamo_estado character varying(60) NOT NULL,
    reclamo_fecha timestamp without time zone,
    reclamo_fecha_cliente date,
    usu_cod integer NOT NULL,
    tipo_recl_item_cod integer,
    suc_cod integer
);
 $   DROP TABLE public.reclamo_clientes;
       public            postgres    false            8           1259    268093    rendicion_fondo_fijo    TABLE     �  CREATE TABLE public.rendicion_fondo_fijo (
    asignacion_responsable_cod integer NOT NULL,
    rendicion_fondo_fijo_cod integer NOT NULL,
    tipo_doc_cod integer NOT NULL,
    prov_cod integer NOT NULL,
    tipo_fact_cod integer NOT NULL,
    nro_factura character varying(60) NOT NULL,
    fecha date NOT NULL,
    monto numeric NOT NULL,
    grav10 integer,
    grav5 integer,
    exentas integer,
    iva10 integer,
    iva5 integer
);
 (   DROP TABLE public.rendicion_fondo_fijo;
       public            postgres    false            9           1259    268142    reposicion_fondo_fijo    TABLE     �  CREATE TABLE public.reposicion_fondo_fijo (
    reposicion_cod integer NOT NULL,
    asignacion_responsable_cod integer NOT NULL,
    rendicion_fondo_fijo_cod integer NOT NULL,
    orden_pago_cod integer NOT NULL,
    ent_cod integer NOT NULL,
    cuenta_corriente_cod integer NOT NULL,
    movimiento_nro integer NOT NULL,
    fecha_reposicion timestamp without time zone,
    estado character varying(20),
    monto_rendicion numeric NOT NULL,
    observacion character varying(120)
);
 )   DROP TABLE public.reposicion_fondo_fijo;
       public            postgres    false            �            1259    207322    reservas_cab    TABLE     B  CREATE TABLE public.reservas_cab (
    reser_cod integer NOT NULL,
    reser_estado character varying(60) NOT NULL,
    reser_fecha timestamp without time zone NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    cli_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    usu_cod integer NOT NULL
);
     DROP TABLE public.reservas_cab;
       public            postgres    false            �            1259    207325    reservas_det    TABLE     O  CREATE TABLE public.reservas_det (
    reser_cod integer NOT NULL,
    reser_hdesde time without time zone NOT NULL,
    reser_hhasta time without time zone NOT NULL,
    fecha_reser date NOT NULL,
    reser_precio integer NOT NULL,
    item_cod integer NOT NULL,
    reser_desc character varying(250),
    fun_cod integer NOT NULL
);
     DROP TABLE public.reservas_det;
       public            postgres    false            >           1259    294427    retorno    TABLE     :   CREATE TABLE public.retorno (
    ord_trab_cod integer
);
    DROP TABLE public.retorno;
       public            postgres    false            (           1259    251433    rubros    TABLE     f   CREATE TABLE public.rubros (
    rubro_cod integer NOT NULL,
    rubro_desc character varying(250)
);
    DROP TABLE public.rubros;
       public            postgres    false            �            1259    207328    servicios_cab    TABLE     �   CREATE TABLE public.servicios_cab (
    serv_cod integer NOT NULL,
    serv_estado character varying(60) NOT NULL,
    serv_fecha timestamp without time zone NOT NULL,
    serv_dfecha timestamp without time zone NOT NULL,
    cli_cod integer NOT NULL
);
 !   DROP TABLE public.servicios_cab;
       public            postgres    false            �            1259    207331    servicios_det    TABLE     �   CREATE TABLE public.servicios_det (
    serv_cod integer NOT NULL,
    tipo_serv_cod integer NOT NULL,
    serv_precio integer NOT NULL,
    serv_desc character varying(60) NOT NULL
);
 !   DROP TABLE public.servicios_det;
       public            postgres    false            �            1259    207334    sesiones    TABLE     r   CREATE TABLE public.sesiones (
    sesion_cod integer NOT NULL,
    sesion_desc character varying(60) NOT NULL
);
    DROP TABLE public.sesiones;
       public            postgres    false            �            1259    207337    stock    TABLE     �   CREATE TABLE public.stock (
    dep_cod integer NOT NULL,
    item_cod integer NOT NULL,
    mar_cod integer NOT NULL,
    stock_cantidad integer
);
    DROP TABLE public.stock;
       public            postgres    false            �            1259    207340 
   sucursales    TABLE     7  CREATE TABLE public.sucursales (
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    suc_nom character varying(60) NOT NULL,
    suc_dir character varying(60) NOT NULL,
    suc_tel character varying(60) NOT NULL,
    suc_email character varying(60) NOT NULL,
    suc_estado character varying(20)
);
    DROP TABLE public.sucursales;
       public            postgres    false            �            1259    207343 	   timbrados    TABLE     �  CREATE TABLE public.timbrados (
    timb_cod integer NOT NULL,
    timb_nro integer NOT NULL,
    tim_fecha_registro date NOT NULL,
    timb_estado character varying(30) NOT NULL,
    tim_vigdesde date NOT NULL,
    tim_vighasta date NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    tim_nrodesde integer,
    tim_nrohasta integer,
    tim_ultfactura integer,
    puntoexp integer
);
    DROP TABLE public.timbrados;
       public            postgres    false            �            1259    207346    tipo_ajustes    TABLE     w   CREATE TABLE public.tipo_ajustes (
    tipo_ajuste_cod integer NOT NULL,
    tipo_ajuste_desc character varying(60)
);
     DROP TABLE public.tipo_ajustes;
       public            postgres    false            �            1259    207349    tipo_cheques    TABLE     w   CREATE TABLE public.tipo_cheques (
    cheque_tipo_cod integer NOT NULL,
    cheque_tipo_desc character varying(60)
);
     DROP TABLE public.tipo_cheques;
       public            postgres    false            )           1259    251438    tipo_documentos    TABLE     u   CREATE TABLE public.tipo_documentos (
    tipo_doc_cod integer NOT NULL,
    tipo_doc_desc character varying(120)
);
 #   DROP TABLE public.tipo_documentos;
       public            postgres    false            �            1259    207352    tipo_facturas    TABLE     }   CREATE TABLE public.tipo_facturas (
    tipo_fact_cod integer NOT NULL,
    tipo_fact_desc character varying(60) NOT NULL
);
 !   DROP TABLE public.tipo_facturas;
       public            postgres    false            �            1259    207355    tipo_impuestos    TABLE     s   CREATE TABLE public.tipo_impuestos (
    tipo_imp_cod integer NOT NULL,
    tipo_imp_desc character varying(20)
);
 "   DROP TABLE public.tipo_impuestos;
       public            postgres    false            �            1259    207358 
   tipo_items    TABLE     z   CREATE TABLE public.tipo_items (
    tipo_item_cod integer NOT NULL,
    tipo_item_desc character varying(60) NOT NULL
);
    DROP TABLE public.tipo_items;
       public            postgres    false            �            1259    207361    tipo_personas    TABLE     |   CREATE TABLE public.tipo_personas (
    tipo_per_cod integer NOT NULL,
    tipo_pers_desc character varying(60) NOT NULL
);
 !   DROP TABLE public.tipo_personas;
       public            postgres    false            �            1259    207364    tipo_reclamo_items    TABLE     �   CREATE TABLE public.tipo_reclamo_items (
    tipo_recl_item_cod integer NOT NULL,
    tipo_recl_item_desc character varying(150)
);
 &   DROP TABLE public.tipo_reclamo_items;
       public            postgres    false            �            1259    207367    tipo_reclamos    TABLE     �   CREATE TABLE public.tipo_reclamos (
    tipo_reclamo_cod integer NOT NULL,
    tipo_reclamo_desc character varying(100) NOT NULL
);
 !   DROP TABLE public.tipo_reclamos;
       public            postgres    false            �            1259    207370    tipo_servicios    TABLE     0  CREATE TABLE public.tipo_servicios (
    tipo_serv_cod integer NOT NULL,
    tipo_serv_desc character varying(60) NOT NULL,
    tipo_serv_precio integer NOT NULL,
    tipo_serv_estado character varying(60) NOT NULL,
    tipo_serv_impuesto character varying(100) NOT NULL,
    esp_cod integer NOT NULL
);
 "   DROP TABLE public.tipo_servicios;
       public            postgres    false            0           1259    259744 	   titulares    TABLE     �   CREATE TABLE public.titulares (
    titular_cod integer NOT NULL,
    titular_nombre character varying(120),
    titular_apellido character varying(120),
    titular_ci character varying(60),
    titular_desc character varying(250)
);
    DROP TABLE public.titulares;
       public            postgres    false            �            1259    207373    transferencias_cab    TABLE       CREATE TABLE public.transferencias_cab (
    trans_cod integer NOT NULL,
    trans_fecha timestamp without time zone NOT NULL,
    trans_estado character varying(60) NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    trans_fecha_envio timestamp without time zone NOT NULL,
    trans_fecha_entrega timestamp without time zone NOT NULL,
    vehi_cod integer NOT NULL,
    trans_origen integer NOT NULL,
    trans_destino integer NOT NULL,
    trans_enviar_recibir character varying(20) NOT NULL,
    usu_cod integer NOT NULL,
    usu_recep integer,
    chofer_cod integer,
    chofer_timbrado character varying(60),
    chofefr_nro_factura character varying(20),
    chofer_nro_factura character varying(20),
    trans_precio numeric
);
 &   DROP TABLE public.transferencias_cab;
       public            postgres    false            �            1259    207376    transferencias_det    TABLE       CREATE TABLE public.transferencias_det (
    trans_cod integer NOT NULL,
    dep_origen integer NOT NULL,
    item_cod integer NOT NULL,
    mar_cod integer NOT NULL,
    trans_cantidad integer NOT NULL,
    trans_cant_recibida integer,
    dep_destino integer
);
 &   DROP TABLE public.transferencias_det;
       public            postgres    false            �            1259    207379    usuarios    TABLE     i  CREATE TABLE public.usuarios (
    usu_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    suc_cod integer NOT NULL,
    emp_cod integer NOT NULL,
    usu_name character varying(60) NOT NULL,
    usu_pass character varying(100) NOT NULL,
    usu_estado character varying(60) NOT NULL,
    perfil_cod integer NOT NULL,
    usu_foto character varying(150)
);
    DROP TABLE public.usuarios;
       public            postgres    false            �            1259    207382 
   v_ciudades    VIEW     �   CREATE VIEW public.v_ciudades AS
 SELECT c.ciu_cod,
    c.ciu_desc,
    p.pais_cod,
    p.pais_desc
   FROM public.ciudades c,
    public.paises p
  WHERE (c.pais_cod = p.pais_cod);
    DROP VIEW public.v_ciudades;
       public          postgres    false    181    215    215    181    181            �            1259    207386 
   v_personas    VIEW     �  CREATE VIEW public.v_personas AS
 SELECT p.per_cod,
    p.per_nom,
    p.per_ape,
    p.per_ci,
    p.per_dir,
    p.per_tel,
    p.per_fenac,
    p.per_email,
    p.ciu_cod,
    vc.ciu_desc,
    vc.pais_cod,
    vc.pais_desc,
    p.gen_cod,
    g.gen_desc,
    p.tipo_per_cod,
    t.tipo_pers_desc
   FROM public.personas p,
    public.v_ciudades vc,
    public.tipo_personas t,
    public.generos g
  WHERE (((vc.ciu_cod = p.ciu_cod) AND (t.tipo_per_cod = p.tipo_per_cod)) AND (g.gen_cod = p.gen_cod));
    DROP VIEW public.v_personas;
       public          postgres    false    201    201    222    222    222    222    222    222    222    222    222    222    222    245    245    252    252    252    252            �            1259    207390    v_funcionarios    VIEW     �  CREATE VIEW public.v_funcionarios AS
 SELECT f.fun_cod,
    (((vp.per_nom)::text || ' '::text) || (vp.per_ape)::text) AS fun_nom,
    vp.per_ci,
    vp.per_tel,
    vp.per_email,
    f.fun_fecha_alta,
    f.fun_fecha_baja,
    f.fun_estado,
    c.car_desc,
    vp.ciu_desc,
    vp.pais_desc,
    vp.gen_desc
   FROM public.funcionarios f,
    public.cargos c,
    public.v_personas vp
  WHERE ((f.per_cod = vp.per_cod) AND (c.car_cod = f.car_cod));
 !   DROP VIEW public.v_funcionarios;
       public          postgres    false    179    179    200    200    200    200    200    200    253    253    253    253    253    253    253    253    253            �            1259    207394    v_sucursales    VIEW     5  CREATE VIEW public.v_sucursales AS
 SELECT s.suc_cod,
    s.suc_nom,
    s.suc_dir,
    s.suc_tel,
    s.suc_email,
    s.emp_cod,
    e.emp_nom,
    e.emp_ruc,
    e.emp_dir,
    e.emp_tel,
    e.emp_email,
    s.suc_estado
   FROM public.sucursales s,
    public.empresas e
  WHERE (e.emp_cod = s.emp_cod);
    DROP VIEW public.v_sucursales;
       public          postgres    false    238    193    193    193    193    193    193    238    238    238    238    238    238                        1259    207398 
   v_usuarios    VIEW     �  CREATE VIEW public.v_usuarios AS
 SELECT u.usu_cod,
    u.fun_cod,
    vf.fun_nom,
    u.usu_name,
    u.usu_pass,
    u.usu_estado,
    u.usu_foto,
    vf.per_ci,
    vf.per_tel,
    vf.per_email,
    vf.fun_estado,
    vf.gen_desc,
    vf.car_desc,
    u.suc_cod,
    vs.suc_nom,
    vs.suc_dir,
    vs.suc_tel,
    vs.suc_email,
    vs.emp_cod,
    vs.emp_nom,
    vf.ciu_desc,
    vf.pais_desc,
    u.perfil_cod AS gru_id,
    g.perfil_desc AS gru_desc
   FROM public.usuarios u,
    public.v_sucursales vs,
    public.v_funcionarios vf,
    public.perfiles g
  WHERE (((vs.suc_cod = u.suc_cod) AND (vf.fun_cod = u.fun_cod)) AND (g.perfil_cod = u.perfil_cod));
    DROP VIEW public.v_usuarios;
       public          postgres    false    254    202    202    251    251    251    251    251    251    251    251    254    254    254    254    254    254    254    254    254    255    255    255    255    255    255    255            &           1259    251383 	   v_agendas    VIEW     �  CREATE VIEW public.v_agendas AS
 SELECT ac.agen_cod,
    to_char(ac.agenda_fecha, ' dd/mm/yyyy HH24:MI:SS'::text) AS agenda_fecha,
    ac.fun_agen,
    vf.fun_nom AS fun_agen_nom,
    ac.agen_estado,
    ac.hora_desde,
    ac.hora_hasta,
    ac.dias_cod,
    d.dias_desc,
    ac.usu_cod,
    vu.usu_name,
    vu.fun_cod,
    vu.fun_nom,
    ac.suc_cod,
    vs.suc_nom,
    vs.emp_cod,
    vs.emp_nom
   FROM public.agendas ac,
    public.v_funcionarios vf,
    public.v_sucursales vs,
    public.v_usuarios vu,
    public.dias d
  WHERE ((((ac.usu_cod = vu.usu_cod) AND (ac.suc_cod = vs.suc_cod)) AND (ac.fun_agen = vf.fun_cod)) AND (d.dias_cod = ac.dias_cod));
    DROP VIEW public.v_agendas;
       public          postgres    false    192    171    171    171    171    171    171    171    171    171    192    254    254    255    255    255    255    256    256    256    256            P           1259    383081    v_agendas_cab    VIEW     �  CREATE VIEW public.v_agendas_cab AS
 SELECT ac.agen_cod,
    to_char(ac.agen_fecha, 'DD/MM/YYYY HH24:MI:SS'::text) AS agen_fecha,
    ac.agen_estado,
    vf.fun_cod,
    vf.fun_nom,
    vf.per_ci AS fun_ci,
    vf.fun_estado,
    ac.usu_cod,
    vu.usu_name,
    vu.fun_cod AS fun_cod_oper,
    vu.fun_nom AS fun_nom_oper,
    ac.suc_cod,
    vs.suc_nom,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_ruc,
    vs.emp_dir,
    vs.emp_tel,
    vs.emp_email
   FROM public.agendas_cab ac,
    public.v_funcionarios vf,
    public.v_usuarios vu,
    public.v_sucursales vs
  WHERE (((ac.fun_cod = vf.fun_cod) AND (vu.usu_cod = ac.usu_cod)) AND (vs.suc_cod = ac.suc_cod));
     DROP VIEW public.v_agendas_cab;
       public          postgres    false    256    334    334    334    334    334    334    256    256    256    255    255    255    255    255    255    255    255    254    254    254    254            Q           1259    383086    v_agendas_det    VIEW     �   CREATE VIEW public.v_agendas_det AS
 SELECT ad.agen_cod,
    ad.dias_cod,
    d.dias_desc,
    ad.hora_desde,
    ad.hora_hasta
   FROM public.agendas_det ad,
    public.dias d
  WHERE (d.dias_cod = ad.dias_cod);
     DROP VIEW public.v_agendas_det;
       public          postgres    false    192    192    335    335    335    335            G           1259    366683    v_ajustes_cab    VIEW     P  CREATE VIEW public.v_ajustes_cab AS
 SELECT ac.ajus_cod,
    to_char(ac.ajus_fecha, 'dd/mm/yyyy HH24:MI:SS'::text) AS fecha_ajuste,
    ac.ajus_estado,
    ac.ajus_tipo,
    ac.usu_cod,
    vu.usu_name,
    vu.fun_cod,
    vu.fun_nom,
    vu.car_desc,
    vu.gru_id,
    vu.gru_desc,
    ac.suc_cod,
    vs.suc_nom,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_dir,
    vs.emp_tel,
    vs.emp_email,
    vs.emp_ruc
   FROM public.ajustes_cab ac,
    public.v_sucursales vs,
    public.v_usuarios vu
  WHERE ((ac.usu_cod = vu.usu_cod) AND (ac.suc_cod = vs.suc_cod))
  ORDER BY ac.ajus_cod DESC;
     DROP VIEW public.v_ajustes_cab;
       public          postgres    false    256    172    256    256    256    172    256    255    255    255    255    255    255    255    172    256    255    172    172    172    256                       1259    207412    v_depositos    VIEW     �  CREATE VIEW public.v_depositos AS
 SELECT d.dep_cod,
    d.dep_desc,
    d.emp_cod,
    vs.emp_nom,
    d.suc_cod,
    vs.suc_nom,
    d.dep_estado,
    vs.suc_dir,
    vs.suc_tel,
    vs.suc_email,
    vs.emp_ruc,
    vs.emp_dir,
    vs.emp_tel,
    vs.emp_email
   FROM public.depositos d,
    public.v_sucursales vs
  WHERE ((d.suc_cod = vs.suc_cod) AND (d.emp_cod = vs.emp_cod));
    DROP VIEW public.v_depositos;
       public          postgres    false    255    255    189    189    255    189    189    189    255    255    255    255    255    255    255    255                       1259    208613    v_marcas_items    VIEW     9  CREATE VIEW public.v_marcas_items AS
 SELECT mi.item_cod,
    i.item_desc,
    mi.mar_cod,
    m.mar_desc,
    mi.costo,
    mi.precio,
    mi.item_min,
    mi.item_max,
    mi.item_estado,
    i.tipo_imp_cod,
    timp.tipo_imp_desc,
    i.tipo_item_cod,
    titem.tipo_item_desc
   FROM public.items i,
    public.marcas m,
    public.marcas_items mi,
    public.tipo_impuestos timp,
    public.tipo_items titem
  WHERE ((((i.tipo_imp_cod = timp.tipo_imp_cod) AND (i.tipo_item_cod = titem.tipo_item_cod)) AND (mi.item_cod = i.item_cod)) AND (mi.mar_cod = m.mar_cod));
 !   DROP VIEW public.v_marcas_items;
       public          postgres    false    206    203    203    206    243    243    244    244    276    276    276    276    276    203    203    276    276                       1259    208636    v_ajustes_det    VIEW     o  CREATE VIEW public.v_ajustes_det AS
 SELECT ad.ajus_cod,
    ad.dep_cod,
    vd.dep_desc,
    ad.item_cod,
    vmi.item_desc,
    ad.mar_cod,
    vmi.mar_desc,
    ad.ajus_cantidad,
    ad.mot_cod,
    ma.mot_desc,
    vmi.tipo_imp_cod,
    vmi.tipo_imp_desc,
    vmi.tipo_item_cod,
    vmi.tipo_item_desc,
    vd.suc_cod,
    vd.suc_nom,
    vd.emp_cod,
    vd.emp_nom
   FROM public.ajustes_det ad,
    public.v_marcas_items vmi,
    public.v_depositos vd,
    public.motivo_ajustes ma
  WHERE ((((ad.item_cod = vmi.item_cod) AND (ad.dep_cod = vd.dep_cod)) AND (ad.mar_cod = vmi.mar_cod)) AND (ad.mot_cod = ma.mot_cod));
     DROP VIEW public.v_ajustes_det;
       public          postgres    false    173    257    278    278    278    278    278    278    278    278    257    257    257    257    257    208    208    173    173    173    173    173                       1259    207424    v_timbrado_cajas    VIEW     �  CREATE VIEW public.v_timbrado_cajas AS
 SELECT dt.caja_cod,
    dt.timb_cod,
    t.tim_fecha_registro,
    t.timb_nro,
    t.timb_estado,
    t.tim_vigdesde,
    t.tim_vighasta,
    t.tim_nrodesde,
    t.tim_nrohasta,
    t.tim_ultfactura,
    ((btrim((to_char(c.suc_cod, '000'::text) || '-'::text)) || btrim((to_char(t.puntoexp, '000'::text) || '-'::text))) || btrim(to_char(t.tim_ultfactura, '0000000'::text))) AS ultima_factura,
    ((btrim((to_char(c.suc_cod, '000'::text) || '-'::text)) || btrim((to_char(t.puntoexp, '000'::text) || '-'::text))) || btrim(to_char((t.tim_ultfactura + 1), '0000000'::text))) AS siguiente_factura,
    t.puntoexp,
    c.caja_desc,
    c.caja_estado,
    c.caja_ultrecibo,
    btrim(to_char(c.caja_ultrecibo, '0000000'::text)) AS ultimo_recibo,
    btrim(to_char((c.caja_ultrecibo + 1), '0000000'::text)) AS siguiente_recibo,
    c.usu_cod,
    u.usu_name,
    c.fun_cod,
    u.fun_nom,
    c.suc_cod,
    s.suc_nom,
    c.emp_cod,
    s.emp_nom
   FROM public.detalle_timbrados dt,
    public.cajas c,
    public.timbrados t,
    public.v_sucursales s,
    public.v_usuarios u
  WHERE ((((dt.caja_cod = c.caja_cod) AND (t.timb_cod = dt.timb_cod)) AND (c.suc_cod = s.suc_cod)) AND (u.usu_cod = c.usu_cod));
 #   DROP VIEW public.v_timbrado_cajas;
       public          postgres    false    178    256    256    256    255    255    255    239    239    239    239    239    239    239    239    239    239    191    191    178    178    178    178    178    178    178                       1259    207429    v_aperturas_cierres    VIEW     1  CREATE VIEW public.v_aperturas_cierres AS
 SELECT ac.aper_cier_cod,
    to_char(ac.aper_fecha, 'dd/mm/yyyy HH24:MI:SS'::text) AS fecha_aperformato,
    ac.aper_monto,
    ( SELECT COALESCE(sum(cob.cobro_efectivo), (0)::bigint) AS "coalesce"
           FROM public.cobros_cab cob
          WHERE ((cob.aper_cier_cod = ac.aper_cier_cod) AND ((cob.cobro_estado)::text <> 'ANULADO'::text))) AS monto_efectivo,
    ( SELECT COALESCE(sum(ct.tarj_monto), (0)::bigint) AS "coalesce"
           FROM public.cobros_tarjetas ct,
            public.cobros_cab cob
          WHERE (((ct.cobro_cod = cob.cobro_cod) AND (cob.aper_cier_cod = ac.aper_cier_cod)) AND ((cob.cobro_estado)::text <> 'ANULADO'::text))) AS monto_tarjeta,
    ( SELECT COALESCE(sum(cc.cheq_importe), (0)::bigint) AS "coalesce"
           FROM public.cobros_cheques cc,
            public.cobros_cab cob
          WHERE (((cc.cobro_cod = cob.cobro_cod) AND (cob.aper_cier_cod = ac.aper_cier_cod)) AND ((cob.cobro_estado)::text <> 'ANULADO'::text))) AS monto_cheque,
    ac.aper_cier_monto,
    to_char(ac.aper_cier_fecha, 'dd/mm/yyyy HH24:MI:SS'::text) AS fecha_cierreformato,
    ac.timb_cod,
    vtc.timb_nro,
    vtc.timb_estado,
    vtc.tim_fecha_registro,
    vtc.tim_vigdesde,
    vtc.tim_vighasta,
    vtc.tim_nrodesde,
    vtc.tim_nrohasta,
    vtc.ultima_factura,
    vtc.tim_ultfactura,
    vtc.siguiente_factura,
    vtc.puntoexp,
    ac.caja_cod,
    vtc.caja_desc,
    vtc.caja_estado,
    vtc.caja_ultrecibo,
    vtc.ultimo_recibo,
    vtc.siguiente_recibo,
    vtc.usu_cod,
    vtc.usu_name,
    vtc.fun_cod,
    vtc.fun_nom,
    vtc.suc_cod,
    vtc.suc_nom,
    vtc.emp_cod,
    vtc.emp_nom
   FROM public.aperturas_cierres ac,
    public.v_timbrado_cajas vtc
  WHERE ((ac.timb_cod = vtc.timb_cod) AND (ac.caja_cod = vtc.caja_cod))
  ORDER BY ac.aper_cier_cod DESC;
 &   DROP VIEW public.v_aperturas_cierres;
       public          postgres    false    258    258    258    174    174    258    258    258    174    174    174    174    174    258    184    184    184    258    184    185    185    187    187    258    258    258    258    258    258    258    258    258    258    258    258    258    258    258    258    258    258                       1259    207434    v_cajas    VIEW     �  CREATE VIEW public.v_cajas AS
 SELECT c.caja_cod,
    c.caja_desc,
    c.caja_estado,
    c.usu_cod,
    vu.usu_name,
    c.caja_ultrecibo,
    to_char(c.caja_ultrecibo, '0000000'::text) AS ultimo_recibo,
    to_char((c.caja_ultrecibo + 1), '0000000'::text) AS siguiente_recibo,
    vu.fun_cod,
    vu.fun_nom,
    vu.usu_estado,
    vu.gru_id,
    vu.gru_desc,
    c.suc_cod,
    vs.suc_nom,
    vs.suc_dir,
    vs.suc_tel,
    vs.suc_email,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_ruc,
    vs.emp_dir,
    vs.emp_tel,
    vs.emp_email,
    vs.suc_estado
   FROM public.cajas c,
    public.v_sucursales vs,
    public.v_usuarios vu
  WHERE ((c.usu_cod = vu.usu_cod) AND (c.suc_cod = vs.suc_cod));
    DROP VIEW public.v_cajas;
       public          postgres    false    256    178    178    256    178    255    178    255    256    256    256    255    255    255    255    178    178    256    256    255    255    255    255    255    255            d           1259    432326 
   v_choferes    VIEW     T  CREATE VIEW public.v_choferes AS
 SELECT ch.chofer_cod,
    ch.per_cod,
    (((p.per_nom)::text || ' '::text) || (p.per_ape)::text) AS chofer_nom,
    ch.chofer_ruc,
    p.per_dir AS chofer_dir,
    p.per_tel AS chofer_tel,
    p.per_email AS chofer_email
   FROM public.choferes ch,
    public.personas p
  WHERE (ch.per_cod = p.per_cod);
    DROP VIEW public.v_choferes;
       public          postgres    false    332    222    332    222    332    222    222    222    222                       1259    207439 
   v_clientes    VIEW       CREATE VIEW public.v_clientes AS
 SELECT c.cli_cod,
    c.per_cod,
    (((vp.per_nom)::text || ' '::text) || (vp.per_ape)::text) AS cli_nom,
    vp.per_ci,
    c.cli_estado,
    c.cli_ruc,
    c.cli_fecha_alta,
    c.cli_fecha_baja,
    vp.per_dir,
    vp.per_fenac,
    vp.per_tel,
    vp.per_email,
    vp.ciu_cod,
    vp.ciu_desc,
    vp.pais_cod,
    vp.pais_desc,
    vp.gen_cod,
    vp.gen_desc,
    vp.tipo_per_cod,
    vp.tipo_pers_desc
   FROM public.clientes c,
    public.v_personas vp
  WHERE (c.per_cod = vp.per_cod);
    DROP VIEW public.v_clientes;
       public          postgres    false    253    253    253    253    253    253    253    253    253    253    253    253    253    253    253    253    183    183    183    183    183    183                       1259    207443    v_cobros_cheques    VIEW     �  CREATE VIEW public.v_cobros_cheques AS
 SELECT cobc.cobro_cod,
    cobc.aper_cier_cod,
    to_char(cobc.cobro_fecha, 'DD/MM/YYYY HH24:MI:SS'::text) AS cobro_fecha,
    cc.ch_cuenta_num,
    cc.serie,
    cc.cheq_num,
    cc.cheq_importe,
    cc.fecha_emision,
    cc.fecha_recepcion,
    cc.fecha_cobro,
    cc.cheque_estado,
    cc.librador,
    cc.banco_cod,
    b.banco_nom,
    cc.cheque_tipo_cod,
    tc.cheque_tipo_desc
   FROM public.cobros_cab cobc,
    public.cobros_cheques cc,
    public.bancos b,
    public.tipo_cheques tc
  WHERE (((cobc.cobro_cod = cc.cobro_cod) AND (cc.banco_cod = b.banco_cod)) AND (cc.cheque_tipo_cod = tc.cheque_tipo_cod));
 #   DROP VIEW public.v_cobros_cheques;
       public          postgres    false    177    177    185    185    185    185    185    185    185    185    184    185    185    185    241    241    184    184    185                       1259    207448    v_cobros_tarjetas    VIEW     �  CREATE VIEW public.v_cobros_tarjetas AS
 SELECT cobc.cobro_cod,
    cobc.aper_cier_cod,
    to_char(cobc.cobro_fecha, 'DD/MM/YYYY HH24:MI:SS'::text) AS cobro_fecha,
    ct.mar_tarj_cod,
    mt.mar_tarj_desc,
    ct.cob_tarj_nro,
    ct.cod_auto,
    ct.tarj_monto,
    ct.ent_cod,
    ee.ent_nom,
    ct.ent_ad_cod,
    ea.ent_ad_nom
   FROM public.cobros_tarjetas ct,
    public.cobros_cab cobc,
    public.marca_tarjetas mt,
    public.entidades_emisoras ee,
    public.entidades_adheridas ea
  WHERE ((((ct.mar_tarj_cod = mt.mar_tarj_cod) AND (ct.ent_cod = ee.ent_cod)) AND (ct.ent_ad_cod = ea.ent_ad_cod)) AND (cobc.cobro_cod = ct.cobro_cod));
 $   DROP VIEW public.v_cobros_tarjetas;
       public          postgres    false    187    194    195    205    205    187    187    187    187    184    184    184    187    195    194    187                       1259    207452    v_proveedores    VIEW     t  CREATE VIEW public.v_proveedores AS
 SELECT pr.prov_cod,
    pr.per_cod,
    (((p.per_nom)::text || ' '::text) || (p.per_ape)::text) AS prov_nombre,
    pr.prov_ruc,
    pr.prov_estado,
    pr.prov_fecha_alta,
    pr.prov_fecha_baja,
    p.per_dir AS prov_dir,
    p.per_tel AS prov_tel,
    p.per_email,
    p.ciu_cod,
    vc.ciu_desc,
    p.tipo_per_cod,
    tp.tipo_pers_desc,
    vc.pais_cod,
    vc.pais_desc
   FROM public.proveedores pr,
    public.personas p,
    public.tipo_personas tp,
    public.v_ciudades vc
  WHERE (((p.per_cod = pr.per_cod) AND (tp.tipo_per_cod = p.tipo_per_cod)) AND (vc.ciu_cod = p.ciu_cod));
     DROP VIEW public.v_proveedores;
       public          postgres    false    222    229    222    229    229    222    229    252    252    252    252    245    245    222    229    222    222    229    222    222            V           1259    383154    v_compras_cab    VIEW     �  CREATE VIEW public.v_compras_cab AS
 SELECT cc.comp_cod,
    cc.prov_cod,
    cc.prov_timb_nro,
    cc.prov_timb_vig,
    cc.nro_factura,
    to_char(cc.comp_fecha, 'DD/MM/YYYY HH24:MI:SS'::text) AS comp_fecha,
    vp.prov_nombre,
    vp.prov_ruc,
    vp.prov_dir,
    cc.comp_fecha_factura,
    cc.comp_estado,
    cc.tipo_fact_cod,
    tf.tipo_fact_desc,
    cc.comp_plazo,
    cc.comp_cuotas,
    cc.usu_cod,
    vu.usu_name,
    cc.fun_cod,
    vu.fun_nom,
    cc.suc_cod,
    vs.suc_nom,
    vs.suc_dir,
    vs.suc_tel,
    vs.suc_email,
    cc.emp_cod,
    vs.emp_nom,
    vs.emp_ruc,
    vs.emp_dir,
    vs.emp_tel,
    vs.emp_email
   FROM public.compras_cab cc,
    public.tipo_facturas tf,
    public.v_usuarios vu,
    public.v_sucursales vs,
    public.v_proveedores vp
  WHERE ((((cc.prov_cod = vp.prov_cod) AND (cc.tipo_fact_cod = tf.tipo_fact_cod)) AND (cc.usu_cod = vu.usu_cod)) AND (cc.suc_cod = vs.suc_cod))
  ORDER BY cc.comp_cod;
     DROP VIEW public.v_compras_cab;
       public          postgres    false    255    255    255    255    255    242    264    264    264    242    256    255    338    338    338    338    338    338    338    338    338    338    338    338    264    255    255    255    255    256    256    338    338    338            W           1259    383159    v_compras_det    VIEW     �  CREATE VIEW public.v_compras_det AS
 SELECT cd.comp_cod,
    cd.dep_cod,
    vd.dep_desc,
    cd.item_cod,
    vmi.item_desc,
    cd.mar_cod,
    vmi.mar_desc,
    cd.comp_cantidad,
    cd.comp_costo,
    cd.comp_precio,
    vmi.tipo_imp_cod,
    vmi.tipo_imp_desc,
    vd.suc_cod,
    vd.suc_nom
   FROM public.compras_det cd,
    public.v_marcas_items vmi,
    public.v_depositos vd
  WHERE (((cd.dep_cod = vd.dep_cod) AND (cd.item_cod = vmi.item_cod)) AND (cd.mar_cod = vmi.mar_cod));
     DROP VIEW public.v_compras_det;
       public          postgres    false    339    339    339    339    339    339    339    278    278    278    278    278    278    257    257    257    257            	           1259    207467    v_entidades_adheridas    VIEW     �  CREATE VIEW public.v_entidades_adheridas AS
 SELECT ea.ent_ad_cod,
    ea.mar_tarj_cod,
    mt.mar_tarj_desc,
    ea.ent_ad_nom,
    ea.ent_ad_dir,
    ea.ent_ad_tel,
    ea.ent_ad_email,
    ea.ent_cod,
    ee.ent_nom
   FROM public.entidades_adheridas ea,
    public.entidades_emisoras ee,
    public.marca_tarjetas mt
  WHERE ((ea.ent_cod = ee.ent_cod) AND (mt.mar_tarj_cod = ea.mar_tarj_cod));
 (   DROP VIEW public.v_entidades_adheridas;
       public          postgres    false    194    194    194    194    205    205    195    195    194    194    194            
           1259    207471    v_funcionarios1    VIEW     )  CREATE VIEW public.v_funcionarios1 AS
 SELECT f.fun_cod,
    f.per_cod,
    (((vp.per_nom)::text || ' '::text) || (vp.per_ape)::text) AS fun_nombre,
    f.car_cod,
    c.car_desc,
    f.fun_estado,
    f.fun_fecha_alta,
    f.fun_fecha_baja,
    f.prof_cod,
    p.prof_desc,
    f.esp_cod,
    e.esp_desc,
    e.esp_estado,
    vp.per_ci,
    vp.per_dir,
    vp.per_tel,
    vp.per_fenac,
    vp.per_email,
    vp.ciu_cod,
    vp.ciu_desc,
    vp.gen_cod,
    vp.gen_desc,
    vp.pais_cod,
    vp.pais_desc,
    vp.tipo_per_cod,
    vp.tipo_pers_desc
   FROM public.funcionarios f,
    public.especialidades e,
    public.cargos c,
    public.profesiones p,
    public.v_personas vp
  WHERE ((((e.esp_cod = f.esp_cod) AND (c.car_cod = f.car_cod)) AND (p.prof_cod = f.prof_cod)) AND (vp.per_cod = f.per_cod));
 "   DROP VIEW public.v_funcionarios1;
       public          postgres    false    200    197    197    197    179    179    253    253    253    253    253    253    253    253    253    253    253    253    253    253    253    253    200    200    225    200    200    200    225    200    200                       1259    208609    v_items    VIEW     j  CREATE VIEW public.v_items AS
 SELECT i.item_cod,
    i.item_desc,
    i.item_estado,
    i.item_precio,
    tit.tipo_item_cod,
    tit.tipo_item_desc,
    ti.tipo_imp_cod,
    ti.tipo_imp_desc
   FROM public.items i,
    public.tipo_impuestos ti,
    public.tipo_items tit
  WHERE ((ti.tipo_imp_cod = i.tipo_imp_cod) AND (tit.tipo_item_cod = i.tipo_item_cod));
    DROP VIEW public.v_items;
       public          postgres    false    203    244    244    243    243    203    203    203    203    203            ^           1259    407722    v_libro_ventas    VIEW     �  CREATE VIEW public.v_libro_ventas AS
 SELECT l.libro_ven_cod,
    l.ven_cod,
    l.ven_exenta,
    l.ven_gra5,
    l.ven_gra10,
    l.ven_iva5,
    l.ven_iva10,
    l.venta_nro_fact,
    l.timb_cod,
    t.timb_nro,
    l.fecha_vdesde_tim,
    l.fecha_vhasta_tim,
    l.fecha_factura,
    l.cobro_cod
   FROM public.libro_ventas l,
    public.timbrados t
  WHERE (l.timb_cod = t.timb_cod);
 !   DROP VIEW public.v_libro_ventas;
       public          postgres    false    204    204    204    204    239    204    204    239    204    204    204    204    204    204    204            [           1259    399488    v_notas_compras_cab    VIEW     �  CREATE VIEW public.v_notas_compras_cab AS
 SELECT ncc.nota_com_nro,
    ncc.comp_cod,
    to_char(ncc.nota_com_fecha, 'dd/mm/yyyy HH24:MI:SS'::text) AS nota_com_fecha,
    ncc.nota_com_fecha_factura,
    ncc.nota_com_timbrado,
    ncc.nota_com_tim_vighasta,
    ncc.nota_com_factura,
    ncc.nota_com_estado,
    ncc.nota_com_tipo,
    ncc.nota_cred_motivo,
    ncc.nota_monto,
    ncc.nota_descripcion,
    cc.prov_cod,
    cc.prov_nombre,
    cc.prov_ruc,
    vu.fun_cod,
    vu.fun_nom,
    ncc.usu_cod,
    vu.usu_name,
    ncc.suc_cod,
    vs.suc_nom,
    vs.suc_dir,
    vs.suc_tel,
    vs.suc_email,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_ruc,
    vs.emp_dir,
    vs.emp_tel,
    vs.emp_email
   FROM public.notas_com_cab ncc,
    public.v_compras_cab cc,
    public.v_usuarios vu,
    public.v_sucursales vs
  WHERE (((ncc.comp_cod = cc.comp_cod) AND (ncc.usu_cod = vu.usu_cod)) AND (ncc.suc_cod = vs.suc_cod));
 &   DROP VIEW public.v_notas_compras_cab;
       public          postgres    false    344    344    344    344    344    344    344    344    344    344    255    255    255    255    255    255    255    255    255    255    255    344    344    256    256    256    256    342    342    342    342    344    344            Z           1259    391332    v_notas_compras_det    VIEW     '  CREATE VIEW public.v_notas_compras_det AS
 SELECT ncd.nota_com_nro,
    ncd.comp_cod,
    ncd.dep_cod,
    vd.dep_desc,
    ncd.item_cod,
    vmi.item_desc,
    ncd.mar_cod,
    vmi.mar_desc,
    ncd.nota_com_cant,
    ncd.nota_com_precio,
    ncd.nota_com_desc,
    vmi.tipo_imp_cod,
    vmi.tipo_imp_desc,
    vmi.tipo_item_cod,
    vmi.tipo_item_desc
   FROM public.notas_com_det ncd,
    public.v_marcas_items vmi,
    public.v_depositos vd
  WHERE (((ncd.dep_cod = vd.dep_cod) AND (ncd.item_cod = vmi.item_cod)) AND (ncd.mar_cod = vmi.mar_cod));
 &   DROP VIEW public.v_notas_compras_det;
       public          postgres    false    278    257    257    345    345    345    345    345    345    345    345    278    278    278    278    278    278    278                       1259    207559 	   vehiculos    TABLE     �   CREATE TABLE public.vehiculos (
    vehi_cod integer NOT NULL,
    veh_mar_cod integer,
    veh_mod_cod integer,
    veh_chapa character varying(15),
    veh_estado character varying(20)
);
    DROP TABLE public.vehiculos;
       public            postgres    false                       1259    207562    vehiculos_marcas    TABLE     s   CREATE TABLE public.vehiculos_marcas (
    veh_mar_cod integer NOT NULL,
    veh_mar_desc character varying(60)
);
 $   DROP TABLE public.vehiculos_marcas;
       public            postgres    false                       1259    207565    vehiculos_modelos    TABLE     t   CREATE TABLE public.vehiculos_modelos (
    veh_mod_cod integer NOT NULL,
    veh_mod_desc character varying(60)
);
 %   DROP TABLE public.vehiculos_modelos;
       public            postgres    false                       1259    207568    v_vehiculos    VIEW     X  CREATE VIEW public.v_vehiculos AS
 SELECT v.vehi_cod,
    v.veh_mar_cod,
    vm.veh_mar_desc,
    v.veh_mod_cod,
    vmo.veh_mod_desc,
    v.veh_chapa,
    v.veh_estado
   FROM public.vehiculos_marcas vm,
    public.vehiculos v,
    public.vehiculos_modelos vmo
  WHERE ((vm.veh_mar_cod = v.veh_mar_cod) AND (vmo.veh_mod_cod = v.veh_mod_cod));
    DROP VIEW public.v_vehiculos;
       public          postgres    false    272    272    271    270    270    270    270    270    271                       1259    207581 
   ventas_cab    TABLE     �  CREATE TABLE public.ventas_cab (
    ven_cod integer NOT NULL,
    ven_fecha timestamp without time zone NOT NULL,
    ven_estado character varying(60) NOT NULL,
    emp_cod integer NOT NULL,
    suc_cod integer NOT NULL,
    usu_cod integer NOT NULL,
    fun_cod integer NOT NULL,
    cli_cod integer NOT NULL,
    tipo_fact_cod integer NOT NULL,
    ven_plazo integer NOT NULL,
    ven_cuotas integer NOT NULL
);
    DROP TABLE public.ventas_cab;
       public            postgres    false            ]           1259    407717    v_ventas_cab    VIEW     	  CREATE VIEW public.v_ventas_cab AS
 SELECT vc.ven_cod,
    to_char(vc.ven_fecha, 'dd/mm/yyyy HH:24:MI:SS'::text) AS ven_fecha,
    vc.ven_estado,
    vc.cli_cod,
    vcli.cli_nom,
    vcli.cli_ruc,
    vcli.per_dir,
    vc.tipo_fact_cod,
    tf.tipo_fact_desc,
    vc.ven_plazo,
    vc.ven_cuotas,
    vc.fun_cod,
    vu.fun_nom,
    vu.usu_cod,
    vu.usu_name,
    vc.suc_cod,
    vs.suc_nom,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_dir,
    vs.emp_ruc,
    vs.emp_email,
    vs.emp_tel
   FROM public.ventas_cab vc,
    public.v_sucursales vs,
    public.v_usuarios vu,
    public.v_clientes vcli,
    public.tipo_facturas tf
  WHERE ((((vc.cli_cod = vcli.cli_cod) AND (vc.tipo_fact_cod = tf.tipo_fact_cod)) AND (vc.fun_cod = vu.fun_cod)) AND (vc.suc_cod = vs.suc_cod));
    DROP VIEW public.v_ventas_cab;
       public          postgres    false    255    255    255    242    242    261    261    256    256    256    256    255    255    255    274    274    274    274    274    274    255    255    274    274    274    261    261            g           1259    440537    v_notas_remisiones_cab    VIEW       CREATE VIEW public.v_notas_remisiones_cab AS
 SELECT nrc.nota_rem_cod,
    nrc.ven_cod,
    vvc.cli_cod,
    vvc.cli_nom,
    vvc.cli_ruc,
    to_char(nrc.nota_rem_fecha, 'dd/mm/yyyy HH24:MI:SS'::text) AS nota_rem_fecha,
    nrc.nota_rem_estado,
    nrc.vehi_cod,
    (((vv.veh_mar_desc)::text || ' - '::text) || (vv.veh_chapa)::text) AS veh_desc,
    nrc.chofer_cod,
    vc.chofer_nom,
    vc.chofer_ruc,
    vc.chofer_dir,
    nrc.remision_tipo,
    nrc.chofer_timb,
    nrc.chofer_timb_vighasta,
    nrc.chofer_factura,
    nrc.chofer_monto,
    nrc.usu_cod,
    vu.usu_name,
    vu.fun_cod,
    vu.fun_nom,
    nrc.suc_cod,
    vs.suc_nom,
    vs.emp_cod,
    vs.emp_nom
   FROM public.notas_remisiones_cab nrc,
    public.v_ventas_cab vvc,
    public.v_vehiculos vv,
    public.v_choferes vc,
    public.v_usuarios vu,
    public.v_sucursales vs
  WHERE (((((nrc.ven_cod = vvc.ven_cod) AND (nrc.vehi_cod = vv.vehi_cod)) AND (nrc.chofer_cod = vc.chofer_cod)) AND (vu.usu_cod = nrc.usu_cod)) AND (vs.suc_cod = nrc.suc_cod));
 )   DROP VIEW public.v_notas_remisiones_cab;
       public          postgres    false    255    349    349    349    349    273    273    356    356    356    354    354    354    354    354    354    354    354    354    354    354    354    354    273    256    256    256    256    255    255    255    356            e           1259    432335    v_notas_remisiones_detalles    VIEW     S  CREATE VIEW public.v_notas_remisiones_detalles AS
 SELECT nrd.nota_rem_cod,
    nrd.item_cod,
    vmi.item_desc,
    nrd.mar_cod,
    vmi.mar_desc,
    nrd.nota_rem_cant,
    nrd.nota_rem_precio
   FROM public.notas_remisiones_det nrd,
    public.v_marcas_items vmi
  WHERE ((nrd.item_cod = vmi.item_cod) AND (nrd.mar_cod = vmi.mar_cod));
 .   DROP VIEW public.v_notas_remisiones_detalles;
       public          postgres    false    355    355    355    355    355    278    278    278    278            a           1259    424090    v_notas_ventas_cab    VIEW     �  CREATE VIEW public.v_notas_ventas_cab AS
 SELECT nvc.nota_ven_cod,
    nvc.ven_cod,
    lv.venta_nro_fact,
    nvc.nota_ven_nro_fact,
    to_char(nvc.nota_ven_fecha, ' dd/mm/yyyy HH24:MI:SS'::text) AS nota_ven_fecha,
    nvc.timb_cod,
    nvc.cli_cod,
    vc.cli_nom,
    vc.cli_ruc,
    nvc.nota_ven_estado,
    nvc.nota_ven_tipo,
    nvc.nota_ven_motivo,
    nvc.nota_monto,
    nvc.nota_descripcion,
    vu.fun_cod,
    vu.fun_nom,
    nvc.usu_cod,
    vu.usu_name,
    nvc.suc_cod,
    vs.suc_nom,
    vs.suc_dir,
    vs.suc_tel,
    vs.suc_email,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_ruc,
    vs.emp_dir,
    vs.emp_tel,
    vs.emp_email
   FROM public.notas_ven_cab nvc,
    public.libro_ventas lv,
    public.timbrados t,
    public.v_clientes vc,
    public.v_usuarios vu,
    public.v_sucursales vs
  WHERE (((((nvc.ven_cod = lv.ven_cod) AND (nvc.usu_cod = vu.usu_cod)) AND (nvc.suc_cod = vs.suc_cod)) AND (nvc.cli_cod = vc.cli_cod)) AND (nvc.timb_cod = t.timb_cod));
 %   DROP VIEW public.v_notas_ventas_cab;
       public          postgres    false    352    352    352    352    352    352    352    352    352    352    352    352    352    261    261    261    256    256    256    256    255    255    255    255    255    255    255    255    255    255    255    239    204    204            f           1259    432339    v_notas_ventas_detalles    VIEW       CREATE VIEW public.v_notas_ventas_detalles AS
 SELECT nvd.nota_ven_cod,
    nvd.dep_cod,
    vd.dep_desc,
    nvd.item_cod,
    vmi.item_desc,
    nvd.mar_cod,
    vmi.mar_desc,
    nvd.nota_ven_cant,
    nvd.nota_ven_precio,
    nvd.nota_ven_desc,
    vmi.tipo_imp_cod,
    vmi.tipo_imp_desc,
    vmi.tipo_item_cod,
    vmi.tipo_item_desc
   FROM public.notas_ven_det nvd,
    public.v_marcas_items vmi,
    public.v_depositos vd
  WHERE (((nvd.dep_cod = vd.dep_cod) AND (nvd.item_cod = vmi.item_cod)) AND (nvd.mar_cod = vmi.mar_cod));
 *   DROP VIEW public.v_notas_ventas_detalles;
       public          postgres    false    351    351    351    351    351    278    278    278    278    278    278    278    257    257    278    351    351                       1259    216775    v_ordenes_compras_cab    VIEW     �  CREATE VIEW public.v_ordenes_compras_cab AS
 SELECT oc.orden_nro,
    to_char(oc.orden_nro, '0000000'::text) AS orden_numero,
    to_char(oc.orden_fecha, 'dd/mm/yyyy HH24:MI:SS'::text) AS orden_fecha,
    oc.tipo_fact_cod,
    tif.tipo_fact_desc,
    oc.orden_plazo,
    oc.orden_cuotas,
    oc.orden_estado,
    oc.prov_cod,
    vp.prov_nombre,
    vp.prov_ruc,
    vp.prov_estado,
    vp.prov_dir,
    vp.prov_tel,
    vp.per_email,
    oc.usu_cod,
    vu.usu_name,
    vu.fun_cod,
    vu.fun_nom,
    vu.car_desc,
    oc.suc_cod,
    vs.suc_nom,
    vs.suc_dir,
    vs.suc_tel,
    vs.suc_email,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_ruc,
    vs.emp_dir,
    vs.emp_tel,
    vs.emp_email
   FROM public.ordcompras_cab oc,
    public.v_proveedores vp,
    public.v_usuarios vu,
    public.v_sucursales vs,
    public.tipo_facturas tif
  WHERE ((((vp.prov_cod = oc.prov_cod) AND (vu.usu_cod = oc.usu_cod)) AND (vs.suc_cod = oc.suc_cod)) AND (oc.tipo_fact_cod = tif.tipo_fact_cod));
 (   DROP VIEW public.v_ordenes_compras_cab;
       public          postgres    false    255    264    264    264    264    264    264    264    256    256    256    256    256    255    255    255    255    255    255    255    255    255    209    209    209    209    209    209    209    209    209    242    242    255                        1259    216780    v_ordenes_compras_det    VIEW     �  CREATE VIEW public.v_ordenes_compras_det AS
 SELECT ocd.orden_nro,
    ocd.item_cod,
    vmi.item_desc,
    ocd.mar_cod,
    vmi.mar_desc,
    ocd.orden_cantidad,
    ocd.orden_precio,
    vmi.item_estado,
    vmi.tipo_imp_cod,
    vmi.tipo_imp_desc,
    vmi.tipo_item_cod,
    vmi.tipo_item_desc
   FROM public.ordcompras_det ocd,
    public.v_marcas_items vmi
  WHERE ((ocd.item_cod = vmi.item_cod) AND (ocd.mar_cod = vmi.mar_cod));
 (   DROP VIEW public.v_ordenes_compras_det;
       public          postgres    false    278    210    210    278    278    278    210    210    278    210    278    278    278    278            \           1259    407685    v_ordenes_trabajos_cab    VIEW     �  CREATE VIEW public.v_ordenes_trabajos_cab AS
 SELECT otc.ord_trab_cod,
    to_char(otc.ord_trab_nro, '0000000'::text) AS ord_trab_nro,
    to_char((otc.ord_trab_fecha)::timestamp with time zone, 'DD/MM/YYYY'::text) AS ord_trab_fecha,
    otc.ord_trab_estado,
    otc.cli_cod,
    c.cli_nom,
    c.cli_ruc,
    vu.usu_cod,
    vu.usu_name,
    vu.fun_cod,
    vu.fun_nom,
    vs.suc_cod,
    vs.suc_nom,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_ruc,
    vs.emp_dir,
    vs.emp_tel,
    vs.emp_email
   FROM public.ordenes_trabajos_cab otc,
    public.v_sucursales vs,
    public.v_usuarios vu,
    public.v_clientes c
  WHERE (((otc.usu_cod = vu.usu_cod) AND (otc.suc_cod = vs.suc_cod)) AND (c.cli_cod = otc.cli_cod));
 )   DROP VIEW public.v_ordenes_trabajos_cab;
       public          postgres    false    256    212    212    212    212    212    212    261    261    261    256    256    256    255    255    255    255    255    255    255    255    212                       1259    215233    v_ordenes_trabajos_det    VIEW     �  CREATE VIEW public.v_ordenes_trabajos_det AS
 SELECT otd.ord_trab_cod,
    otd.item_cod,
    vi.item_desc,
    otd.orden_precio,
    otd.orden_hdesde,
    otd.orden_hhasta,
    otd.ord_trab_desc,
    otd.fun_cod,
    vf.fun_nombre,
    vi.tipo_item_cod,
    vi.tipo_item_desc,
    vi.tipo_imp_cod,
    vi.tipo_imp_desc
   FROM public.ordenes_trabajos_det otd,
    public.v_funcionarios1 vf,
    public.v_items vi
  WHERE ((otd.item_cod = vi.item_cod) AND (otd.fun_cod = vf.fun_cod));
 )   DROP VIEW public.v_ordenes_trabajos_det;
       public          postgres    false    266    277    277    277    277    277    277    213    213    213    213    213    213    213    266                       1259    216764    v_pedidos_compras_cab    VIEW     z  CREATE VIEW public.v_pedidos_compras_cab AS
 SELECT pc.ped_nro,
    to_char(pc.ped_nro, '0000000'::text) AS pedido_nro,
    to_char(pc.ped_fecha, ' dd/mm/yyyy HH24:MI:SS'::text) AS fecha,
    pc.ped_estado,
    pc.usu_cod,
    vu.usu_name,
    vu.fun_cod,
    vu.fun_nom,
    vu.gru_id,
    vu.gru_desc,
    vs.suc_cod,
    vs.suc_nom,
    vs.suc_dir,
    vs.suc_tel,
    vs.suc_email,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_ruc,
    vs.emp_dir,
    vs.emp_tel,
    vs.emp_email
   FROM public.pedidos_cab pc,
    public.v_usuarios vu,
    public.v_sucursales vs
  WHERE ((vu.usu_cod = pc.usu_cod) AND (vs.suc_cod = pc.suc_cod));
 (   DROP VIEW public.v_pedidos_compras_cab;
       public          postgres    false    255    256    256    256    256    256    217    217    217    217    217    255    255    255    255    255    255    255    255    255    255    256                       1259    216771    v_pedidos_compras_det    VIEW     �  CREATE VIEW public.v_pedidos_compras_det AS
 SELECT pd.ped_nro,
    pd.item_cod,
    vmi.item_desc,
    pd.mar_cod,
    vmi.mar_desc,
    pd.ped_cantidad,
    pd.ped_precio,
    vmi.tipo_imp_cod,
    vmi.tipo_imp_desc,
    vmi.tipo_item_cod,
    vmi.tipo_item_desc
   FROM public.pedidos_det pd,
    public.v_marcas_items vmi
  WHERE ((pd.item_cod = vmi.item_cod) AND (pd.mar_cod = vmi.mar_cod));
 (   DROP VIEW public.v_pedidos_compras_det;
       public          postgres    false    218    278    278    218    218    218    278    278    278    278    278    278    218                       1259    207503    v_pedidos_ventas_cab    VIEW     �  CREATE VIEW public.v_pedidos_ventas_cab AS
 SELECT pvc.ped_vcod,
    to_char(pvc.ped_nro, '0000000'::text) AS ped_nro,
    to_char(pvc.ped_fecha, 'dd/mm/yyyy HH24:MI:SS'::text) AS ped_fecha,
    pvc.cli_cod,
    vc.cli_nom,
    vc.cli_ruc,
    vc.per_email,
    vc.tipo_per_cod,
    vc.tipo_pers_desc,
    pvc.ped_estado,
    pvc.usu_cod,
    vu.usu_name,
    vu.fun_cod,
    vu.fun_nom,
    pvc.suc_cod,
    vs.suc_nom,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_dir,
    vs.emp_email,
    vs.emp_ruc,
    vs.emp_tel
   FROM public.pedidos_vcab pvc,
    public.v_clientes vc,
    public.v_sucursales vs,
    public.v_usuarios vu
  WHERE (((pvc.cli_cod = vc.cli_cod) AND (pvc.usu_cod = vu.usu_cod)) AND (pvc.suc_cod = vs.suc_cod));
 '   DROP VIEW public.v_pedidos_ventas_cab;
       public          postgres    false    255    219    219    219    219    261    261    261    261    261    261    256    256    256    256    255    255    255    255    255    255    255    219    219    219                       1259    208658    v_pedidos_ventas_det    VIEW     �  CREATE VIEW public.v_pedidos_ventas_det AS
 SELECT pvd.ped_vcod,
    pvd.item_cod,
    vmi.item_desc,
    pvd.mar_cod,
    vmi.mar_desc,
    pvd.ped_cantidad,
    pvd.ped_precio,
    vmi.item_estado,
    vmi.tipo_imp_cod,
    vmi.tipo_imp_desc,
    vmi.tipo_item_cod,
    vmi.tipo_item_desc
   FROM public.pedidos_vdet pvd,
    public.v_marcas_items vmi
  WHERE ((pvd.item_cod = vmi.item_cod) AND (pvd.mar_cod = vmi.mar_cod));
 '   DROP VIEW public.v_pedidos_ventas_det;
       public          postgres    false    278    220    220    220    220    220    278    278    278    278    278    278    278    278            H           1259    366698    v_presupuestos_cab    VIEW     �  CREATE VIEW public.v_presupuestos_cab AS
 SELECT pc.presu_cod,
    to_char(pc.presu_fecha, 'dd/mm/yyyy HH24:MI:SS'::text) AS presu_fecha,
    pc.presu_validez,
    pc.presu_estado,
    pc.cli_cod,
    vc.cli_nom,
    vc.cli_ruc,
    vc.tipo_per_cod,
    vc.tipo_pers_desc,
    pc.usu_cod,
    vu.usu_name,
    vu.fun_cod,
    vu.fun_nom,
    pc.suc_cod,
    vs.suc_nom,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_ruc,
    vs.emp_tel,
    vs.emp_email,
    vs.emp_dir
   FROM public.presupuestos_cab pc,
    public.v_sucursales vs,
    public.v_usuarios vu,
    public.v_clientes vc
  WHERE (((pc.cli_cod = vc.cli_cod) AND (pc.usu_cod = vu.usu_cod)) AND (pc.suc_cod = vs.suc_cod));
 %   DROP VIEW public.v_presupuestos_cab;
       public          postgres    false    255    255    255    261    255    255    255    223    223    223    255    261    255    261    256    256    256    223    223    256    261    261    223    223            %           1259    216969    v_presupuestos_det_items    VIEW     �  CREATE VIEW public.v_presupuestos_det_items AS
 SELECT pdi.presu_cod,
    pdi.item_cod,
    vmi.item_desc,
    pdi.mar_cod,
    vmi.mar_desc,
    pdi.presu_cantidad,
    pdi.presu_precio,
    vmi.tipo_imp_cod,
    vmi.tipo_imp_desc,
    vmi.tipo_item_cod,
    vmi.tipo_item_desc
   FROM public.presupuestos_det_items pdi,
    public.v_marcas_items vmi
  WHERE ((pdi.item_cod = vmi.item_cod) AND (pdi.mar_cod = vmi.mar_cod));
 +   DROP VIEW public.v_presupuestos_det_items;
       public          postgres    false    278    278    278    278    278    278    292    292    292    292    292    278    278            <           1259    284690    v_presupuestos_det_servicios    VIEW     �  CREATE VIEW public.v_presupuestos_det_servicios AS
 SELECT pds.presu_cod,
    pds.item_cod,
    i.item_desc,
    pds.presu_cantidad,
    pds.presu_precio,
    i.tipo_imp_cod,
    ti.tipo_imp_desc,
    i.tipo_item_cod,
    tit.tipo_item_desc
   FROM public.presupuestos_det_servicios pds,
    public.items i,
    public.tipo_impuestos ti,
    public.tipo_items tit
  WHERE (((pds.item_cod = i.item_cod) AND (i.tipo_item_cod = tit.tipo_item_cod)) AND (i.tipo_imp_cod = ti.tipo_imp_cod));
 /   DROP VIEW public.v_presupuestos_det_servicios;
       public          postgres    false    244    224    224    224    203    244    243    243    224    203    203    203            =           1259    284699    v_presupuestos_detalles    VIEW     (  CREATE VIEW public.v_presupuestos_detalles AS
         SELECT v_presupuestos_det_servicios.presu_cod,
            v_presupuestos_det_servicios.item_cod,
            v_presupuestos_det_servicios.item_desc,
            0 AS mar_cod,
            '---'::character varying AS mar_desc,
            v_presupuestos_det_servicios.presu_cantidad,
            v_presupuestos_det_servicios.presu_precio,
            v_presupuestos_det_servicios.tipo_imp_cod,
            v_presupuestos_det_servicios.tipo_imp_desc,
            v_presupuestos_det_servicios.tipo_item_cod,
            v_presupuestos_det_servicios.tipo_item_desc
           FROM public.v_presupuestos_det_servicios
UNION ALL
         SELECT v_presupuestos_det_items.presu_cod,
            v_presupuestos_det_items.item_cod,
            v_presupuestos_det_items.item_desc,
            v_presupuestos_det_items.mar_cod,
            v_presupuestos_det_items.mar_desc,
            v_presupuestos_det_items.presu_cantidad,
            v_presupuestos_det_items.presu_precio,
            v_presupuestos_det_items.tipo_imp_cod,
            v_presupuestos_det_items.tipo_imp_desc,
            v_presupuestos_det_items.tipo_item_cod,
            v_presupuestos_det_items.tipo_item_desc
           FROM public.v_presupuestos_det_items
  ORDER BY 1, 2, 5, 4, 7, 6, 8, 9, 10, 11;
 *   DROP VIEW public.v_presupuestos_detalles;
       public          postgres    false    316    293    293    293    316    316    316    293    293    316    316    316    293    316    316    293    293    293    293    293            F           1259    366678    v_presupuestos_proveedores_cab    VIEW     !  CREATE VIEW public.v_presupuestos_proveedores_cab AS
 SELECT ppc.pre_prov_cod,
    ppc.prov_cod,
    vp.prov_nombre,
    vp.prov_ruc,
    ppc.pre_prov_fecha,
    ppc.pre_prov_estado,
    ppc.pre_prov_validez,
    to_char(ppc.pre_prov_fecha_operacion, 'dd/mm/yyyy HH24:MI:SS'::text) AS fecha_operacion,
    ppc.suc_cod,
    vs.suc_nom,
    ppc.emp_cod,
    vs.emp_nom,
    vs.emp_dir,
    vs.emp_ruc,
    vs.emp_email,
    vs.emp_tel,
    ppc.fun_cod,
    vu.fun_nom,
    ppc.usu_cod,
    vu.usu_name
   FROM public.presupuestos_proveedores_cab ppc,
    public.v_proveedores vp,
    public.v_sucursales vs,
    public.v_usuarios vu
  WHERE (((((ppc.prov_cod = vp.prov_cod) AND (ppc.suc_cod = vs.suc_cod)) AND (ppc.emp_cod = vs.emp_cod)) AND (ppc.fun_cod = vu.fun_cod)) AND (ppc.usu_cod = vu.usu_cod));
 1   DROP VIEW public.v_presupuestos_proveedores_cab;
       public          postgres    false    323    256    256    256    264    264    264    256    323    255    255    323    323    323    323    323    323    323    323    255    255    255    255    255    255            E           1259    366671    v_presupuestos_proveedores_det    VIEW     �  CREATE VIEW public.v_presupuestos_proveedores_det AS
 SELECT ppd.pre_prov_cod,
    ppd.prov_cod,
    ppd.pre_prov_fecha,
    ppd.item_cod,
    vmi.item_desc,
    ppd.mar_cod,
    vmi.mar_desc,
    ppd.pre_prov_cantidad,
    ppd.pre_prov_precio
   FROM public.presupuestos_proveedores_det ppd,
    public.v_marcas_items vmi
  WHERE ((ppd.item_cod = vmi.item_cod) AND (ppd.mar_cod = vmi.mar_cod));
 1   DROP VIEW public.v_presupuestos_proveedores_det;
       public          postgres    false    324    324    324    324    278    278    278    324    278    324    324            K           1259    366723    v_promociones_cab    VIEW     #  CREATE VIEW public.v_promociones_cab AS
 SELECT pc.promo_cod,
    to_char(pc.promo_dfecha, 'dd/mm/yyyy HH24:MI:SS'::text) AS promo_dfecha,
    pc.promo_feinicio,
    pc.promo_fefin,
    pc.promo_estado,
    pc.usu_cod,
    vu.usu_name,
    vu.fun_cod,
    vu.fun_nom,
    pc.suc_cod,
    vs.suc_nom,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_dir,
    vs.emp_ruc,
    vs.emp_tel,
    vs.emp_email
   FROM public.promos_cab pc,
    public.v_usuarios vu,
    public.v_sucursales vs
  WHERE ((pc.usu_cod = vu.usu_cod) AND (pc.suc_cod = vs.suc_cod));
 $   DROP VIEW public.v_promociones_cab;
       public          postgres    false    255    226    226    226    226    226    226    226    255    255    255    255    255    255    255    256    256    256    256            #           1259    216937    v_promos_det_items    VIEW     �  CREATE VIEW public.v_promos_det_items AS
 SELECT pdi.promo_cod,
    pdi.item_cod,
    vmi.item_desc,
    vmi.mar_cod,
    vmi.mar_desc,
    pdi.tipo_desc,
    pdi.descuento,
    pdi.promo_precio,
    vmi.tipo_imp_cod,
    vmi.tipo_imp_desc,
    vmi.tipo_item_cod,
    vmi.tipo_item_desc,
    vmi.precio
   FROM public.promos_det_items pdi,
    public.v_marcas_items vmi
  WHERE ((pdi.item_cod = vmi.item_cod) AND (pdi.mar_cod = vmi.mar_cod));
 %   DROP VIEW public.v_promos_det_items;
       public          postgres    false    290    290    290    278    290    278    278    278    278    278    278    278    278    290    290            :           1259    276495    v_promos_det_servicios    VIEW     �  CREATE VIEW public.v_promos_det_servicios AS
 SELECT pds.promo_cod,
    pds.item_cod,
    i.item_desc,
    i.item_precio,
    pds.promo_desc,
    pds.promo_precio,
    pds.tipo_desc,
    i.tipo_imp_cod,
    ti.tipo_imp_desc,
    i.tipo_item_cod,
    tit.tipo_item_desc
   FROM public.promos_det_servicios pds,
    public.items i,
    public.tipo_impuestos ti,
    public.tipo_items tit
  WHERE (((pds.item_cod = i.item_cod) AND (i.tipo_imp_cod = ti.tipo_imp_cod)) AND (i.tipo_item_cod = tit.tipo_item_cod));
 )   DROP VIEW public.v_promos_det_servicios;
       public          postgres    false    244    227    244    227    227    243    227    243    203    203    203    203    203    227            ;           1259    276504    v_promociones_detalles    VIEW     �  CREATE VIEW public.v_promociones_detalles AS
         SELECT v_promos_det_servicios.promo_cod,
            v_promos_det_servicios.item_cod,
            v_promos_det_servicios.item_desc,
            0 AS mar_cod,
            '---'::character varying AS mar_desc,
            v_promos_det_servicios.item_precio,
            v_promos_det_servicios.promo_desc,
            v_promos_det_servicios.promo_precio,
            v_promos_det_servicios.tipo_desc,
            v_promos_det_servicios.tipo_imp_cod,
            v_promos_det_servicios.tipo_imp_desc,
            v_promos_det_servicios.tipo_item_cod,
            v_promos_det_servicios.tipo_item_desc
           FROM public.v_promos_det_servicios
UNION
         SELECT v_promos_det_items.promo_cod,
            v_promos_det_items.item_cod,
            v_promos_det_items.item_desc,
            v_promos_det_items.mar_cod,
            v_promos_det_items.mar_desc,
            v_promos_det_items.precio AS item_precio,
            v_promos_det_items.descuento AS promo_desc,
            v_promos_det_items.promo_precio,
            v_promos_det_items.tipo_desc,
            v_promos_det_items.tipo_imp_cod,
            v_promos_det_items.tipo_imp_desc,
            v_promos_det_items.tipo_item_cod,
            v_promos_det_items.tipo_item_desc
           FROM public.v_promos_det_items
          GROUP BY v_promos_det_items.promo_cod, v_promos_det_items.item_cod, v_promos_det_items.item_desc, v_promos_det_items.mar_cod, v_promos_det_items.mar_desc, v_promos_det_items.precio, v_promos_det_items.descuento, v_promos_det_items.promo_precio, v_promos_det_items.tipo_desc, v_promos_det_items.tipo_imp_cod, v_promos_det_items.tipo_imp_desc, v_promos_det_items.tipo_item_cod, v_promos_det_items.tipo_item_desc;
 )   DROP VIEW public.v_promociones_detalles;
       public          postgres    false    291    291    291    291    291    314    291    291    314    314    314    314    291    314    291    291    291    314    314    314    314    314    291    291            !           1259    216812    v_proveedor_timbrados    VIEW     "  CREATE VIEW public.v_proveedor_timbrados AS
 SELECT pt.prov_cod,
    vp.prov_nombre,
    pt.prov_timb_nro,
    vp.prov_ruc,
    vp.prov_estado,
    pt.prov_tim_vighasta,
    vp.prov_dir
   FROM public.proveedor_timbrados pt,
    public.v_proveedores vp
  WHERE (pt.prov_cod = vp.prov_cod);
 (   DROP VIEW public.v_proveedor_timbrados;
       public          postgres    false    228    264    264    264    264    264    228    228                       1259    207533    v_recaudaciones_depositar    VIEW       CREATE VIEW public.v_recaudaciones_depositar AS
 SELECT rd.recau_dep_cod,
    vac.aper_cier_cod,
    vac.fecha_aperformato,
    vac.caja_desc,
    vac.aper_monto,
    vac.monto_efectivo,
    vac.monto_tarjeta,
    vac.monto_cheque,
    vac.aper_cier_monto,
    vac.fecha_cierreformato,
    vac.usu_cod,
    vac.usu_name,
    vac.fun_cod,
    vac.fun_nom,
    vac.suc_cod,
    vac.suc_nom,
    vac.emp_cod,
    vac.emp_nom
   FROM public.recaudaciones_dep rd,
    public.v_aperturas_cierres vac
  WHERE (rd.aper_cier_cod = vac.aper_cier_cod);
 ,   DROP VIEW public.v_recaudaciones_depositar;
       public          postgres    false    259    259    259    259    259    259    259    259    259    259    259    259    259    259    259    259    230    230    259            M           1259    374858    v_reclamos_sugerencias    VIEW     I  CREATE VIEW public.v_reclamos_sugerencias AS
 SELECT rc.reclamo_cod,
    to_char(rc.reclamo_fecha, 'dd/mm/yyyy HH24:MI:SS'::text) AS reclamo_fecha,
    rc.tipo_reclamo_cod,
    tipo_reclamos.tipo_reclamo_desc,
    rc.reclamo_estado,
    rc.suc_reclamo,
    suc2.suc_nom AS sucursal_reclamo,
    rc.cli_cod,
    vc.cli_nom,
    vc.cli_ruc,
    rc.reclamo_fecha_cliente,
    rc.tipo_recl_item_cod,
    tri.tipo_recl_item_desc,
    rc.reclamo_desc,
    rc.usu_cod,
    vu.usu_name,
    vu.fun_cod,
    vu.fun_nom,
    rc.suc_cod,
    vs.suc_nom,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_ruc,
    vs.emp_dir,
    vs.emp_tel,
    vs.emp_email
   FROM public.reclamo_clientes rc,
    public.v_clientes vc,
    public.v_sucursales vs,
    public.v_usuarios vu,
    public.tipo_reclamo_items tri,
    public.tipo_reclamos,
    public.sucursales suc2
  WHERE ((((((rc.tipo_reclamo_cod = tipo_reclamos.tipo_reclamo_cod) AND (rc.cli_cod = vc.cli_cod)) AND (rc.tipo_recl_item_cod = tri.tipo_recl_item_cod)) AND (rc.usu_cod = vu.usu_cod)) AND (rc.suc_cod = vs.suc_cod)) AND (rc.suc_reclamo = suc2.suc_cod));
 )   DROP VIEW public.v_reclamos_sugerencias;
       public          postgres    false    261    256    256    256    256    255    255    255    255    255    255    255    255    247    247    246    246    238    238    231    231    231    231    231    231    231    231    231    231    231    261    261            I           1259    366708    v_reservas_cab    VIEW     �  CREATE VIEW public.v_reservas_cab AS
 SELECT rc.reser_cod,
    to_char(rc.reser_fecha, 'dd/mm/yyyy HH24:MI:SS'::text) AS fecha_reser_ope,
    rc.cli_cod,
    vc.cli_nom,
    vc.per_dir,
    vc.cli_ruc,
    rc.reser_estado,
    rc.usu_cod,
    vu.usu_name,
    vu.fun_cod,
    vu.fun_nom,
    rc.suc_cod,
    vs.suc_nom,
    vs.suc_dir,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_ruc,
    vs.emp_tel,
    vs.emp_dir,
    vs.emp_email
   FROM public.reservas_cab rc,
    public.v_clientes vc,
    public.v_usuarios vu,
    public.v_sucursales vs
  WHERE (((rc.cli_cod = vc.cli_cod) AND (rc.usu_cod = vu.usu_cod)) AND (rc.suc_cod = vs.suc_cod));
 !   DROP VIEW public.v_reservas_cab;
       public          postgres    false    232    261    261    261    261    256    256    256    256    255    255    255    255    255    255    255    255    255    232    232    232    232    232                       1259    215227    v_reservas_det    VIEW     �  CREATE VIEW public.v_reservas_det AS
 SELECT rd.reser_cod,
    rd.fecha_reser,
    rd.reser_hdesde,
    rd.reser_hhasta,
    rd.item_cod,
    vi.item_desc,
    rd.reser_precio,
    rd.reser_desc,
    rd.fun_cod,
    "vf'".fun_nombre,
    vi.tipo_item_cod,
    vi.tipo_item_desc,
    vi.tipo_imp_cod,
    vi.tipo_imp_desc
   FROM public.reservas_det rd,
    public.v_items vi,
    public.v_funcionarios1 "vf'"
  WHERE ((rd.item_cod = vi.item_cod) AND (rd.fun_cod = "vf'".fun_cod));
 !   DROP VIEW public.v_reservas_det;
       public          postgres    false    233    233    233    233    233    233    233    233    266    266    277    277    277    277    277    277                       1259    208631    v_stock    VIEW       CREATE VIEW public.v_stock AS
 SELECT s.dep_cod,
    vd.dep_desc,
    s.item_cod,
    vmi.item_desc,
    vmi.mar_cod,
    vmi.mar_desc,
    s.stock_cantidad,
    vmi.item_min,
    vmi.item_max,
    vmi.item_estado,
    vmi.tipo_imp_cod,
    vmi.tipo_imp_desc,
    vmi.tipo_item_cod,
    vmi.tipo_item_desc,
    vd.suc_cod,
    vd.suc_nom,
    vd.dep_estado
   FROM public.stock s,
    public.v_depositos vd,
    public.v_marcas_items vmi
  WHERE (((s.dep_cod = vd.dep_cod) AND (s.item_cod = vmi.item_cod)) AND (s.mar_cod = vmi.mar_cod));
    DROP VIEW public.v_stock;
       public          postgres    false    278    278    278    278    278    278    257    257    257    257    257    237    237    237    237    278    278    278    278    278                       1259    207555    v_timbrados    VIEW       CREATE VIEW public.v_timbrados AS
 SELECT t.timb_cod,
    t.timb_nro,
    t.tim_fecha_registro,
    t.timb_estado,
    t.tim_vigdesde,
    t.tim_vighasta,
    t.tim_nrodesde,
    t.tim_nrohasta,
    t.tim_ultfactura,
    t.puntoexp,
    vs.suc_cod,
    vs.suc_nom,
    vs.suc_estado,
    vs.suc_dir,
    vs.suc_tel,
    vs.suc_email,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_ruc,
    vs.emp_dir,
    vs.emp_tel,
    vs.emp_email
   FROM public.timbrados t,
    public.v_sucursales vs
  WHERE (vs.suc_cod = t.suc_cod);
    DROP VIEW public.v_timbrados;
       public          postgres    false    239    239    239    239    239    239    239    255    255    255    255    255    255    255    255    255    255    255    255    239    239    239    239            J           1259    366713    v_transferencias_cab    VIEW     �  CREATE VIEW public.v_transferencias_cab AS
 SELECT tc.trans_cod,
    to_char(tc.trans_fecha, 'dd/mm/yyyy HH24:MI:SS'::text) AS fecha_trans,
    tc.trans_estado,
    to_char(tc.trans_fecha_envio, 'dd/mm/yyyy HH24:MI:SS'::text) AS fecha_envio,
    to_char(tc.trans_fecha_entrega, 'dd/mm/yyyy HH24:MI:SS'::text) AS fecha_entrega,
    tc.vehi_cod,
    (((((vv.veh_mar_desc)::text || ' '::text) || (vv.veh_mod_desc)::text) || ' '::text) || (vv.veh_chapa)::text) AS veh_desc,
    tc.trans_origen,
    s2.suc_nom AS suc_origen,
    tc.trans_destino,
    s3.suc_nom AS suc_destino,
    tc.trans_enviar_recibir,
    tc.usu_cod,
    vu.usu_name,
    vu.fun_cod,
    vu.fun_nom,
    vu.gru_id,
    vu.gru_desc,
    tc.suc_cod,
    vs.suc_nom,
    vs.emp_cod,
    vs.emp_nom,
    vs.emp_ruc,
    vs.emp_dir,
    vs.emp_tel,
    vs.emp_email
   FROM public.transferencias_cab tc,
    public.v_usuarios vu,
    public.v_sucursales vs,
    public.sucursales s2,
    public.sucursales s3,
    public.v_vehiculos vv
  WHERE (((((tc.usu_cod = vu.usu_cod) AND (tc.suc_cod = vs.suc_cod)) AND (s2.suc_cod = tc.trans_origen)) AND (s3.suc_cod = tc.trans_destino)) AND (vv.vehi_cod = tc.vehi_cod));
 '   DROP VIEW public.v_transferencias_cab;
       public          postgres    false    273    255    256    256    256    256    256    238    273    273    273    238    249    249    249    249    249    249    249    249    249    249    256    255    249    255    255    255    255    255    255                       1259    208686    v_transferencias_det    VIEW     �  CREATE VIEW public.v_transferencias_det AS
 SELECT td.trans_cod,
    td.dep_origen,
    d1.dep_desc AS d_origen_desc,
    td.item_cod,
    vmi.item_desc,
    td.mar_cod,
    vmi.mar_desc,
    td.trans_cantidad,
    td.trans_cant_recibida,
    td.dep_destino,
    d2.dep_desc AS d_destino_desc,
    vmi.item_estado,
    vmi.tipo_imp_cod,
    vmi.tipo_imp_desc,
    vmi.tipo_item_cod,
    vmi.tipo_item_desc
   FROM public.transferencias_det td,
    public.v_marcas_items vmi,
    public.depositos d1,
    public.depositos d2
  WHERE ((((td.item_cod = vmi.item_cod) AND (td.mar_cod = vmi.mar_cod)) AND (td.dep_destino = d2.dep_cod)) AND (td.dep_origen = d1.dep_cod));
 '   DROP VIEW public.v_transferencias_det;
       public          postgres    false    278    278    278    278    278    278    278    250    250    250    250    250    250    250    189    189    278    278                       1259    207584    ventas_det_items    TABLE     �   CREATE TABLE public.ventas_det_items (
    ven_cod integer NOT NULL,
    dep_cod integer NOT NULL,
    item_cod integer NOT NULL,
    mar_cod integer NOT NULL,
    ven_cantidad integer NOT NULL,
    ven_precio integer
);
 $   DROP TABLE public.ventas_det_items;
       public            postgres    false            @           1259    309267    v_ventas_det_items    VIEW     �  CREATE VIEW public.v_ventas_det_items AS
 SELECT vdi.ven_cod,
    vdi.item_cod,
    vmi.item_desc,
    vdi.mar_cod,
    vmi.mar_desc,
    vdi.dep_cod,
    vd.dep_desc,
    vdi.ven_cantidad,
    vdi.ven_precio,
    vmi.tipo_imp_cod,
    vmi.tipo_imp_desc,
    vmi.tipo_item_cod,
    vmi.tipo_item_desc,
        CASE
            WHEN ((vmi.tipo_imp_desc)::text = 'EXENTAS'::text) THEN (vdi.ven_cantidad * vdi.ven_precio)
            ELSE 0
        END AS exenta,
        CASE
            WHEN ((vmi.tipo_imp_desc)::text = 'GRAVADA 5%'::text) THEN (vdi.ven_cantidad * vdi.ven_precio)
            ELSE 0
        END AS grav5,
        CASE
            WHEN ((vmi.tipo_imp_desc)::text = 'GRAVADA 10%'::text) THEN (vdi.ven_cantidad * vdi.ven_precio)
            ELSE 0
        END AS grav10
   FROM public.ventas_det_items vdi,
    public.v_depositos vd,
    public.v_marcas_items vmi
  WHERE (((vdi.item_cod = vmi.item_cod) AND (vdi.mar_cod = vmi.mar_cod)) AND (vdi.dep_cod = vd.dep_cod));
 %   DROP VIEW public.v_ventas_det_items;
       public          postgres    false    275    278    257    257    275    275    275    275    275    278    278    278    278    278    278    278            '           1259    251411    ventas_det_servicios    TABLE     �   CREATE TABLE public.ventas_det_servicios (
    ven_cod integer NOT NULL,
    item_cod integer NOT NULL,
    ven_cantidad integer,
    ven_precio numeric
);
 (   DROP TABLE public.ventas_det_servicios;
       public            postgres    false            ?           1259    309263    v_ventas_det_servicios    VIEW     n  CREATE VIEW public.v_ventas_det_servicios AS
 SELECT vds.ven_cod,
    vds.item_cod,
    vi.item_desc,
    vi.tipo_item_cod,
    vi.tipo_item_desc,
    vi.tipo_imp_cod,
    vi.tipo_imp_desc,
    vds.ven_cantidad,
    vds.ven_precio,
        CASE
            WHEN ((vi.tipo_imp_desc)::text = 'EXENTAS'::text) THEN ((vds.ven_cantidad)::numeric * vds.ven_precio)
            ELSE (0)::numeric
        END AS exenta,
        CASE
            WHEN ((vi.tipo_imp_desc)::text = 'GRAVADA 5%'::text) THEN ((vds.ven_cantidad)::numeric * vds.ven_precio)
            ELSE (0)::numeric
        END AS grav5,
        CASE
            WHEN ((vi.tipo_imp_desc)::text = 'GRAVADA 10%'::text) THEN ((vds.ven_cantidad)::numeric * vds.ven_precio)
            ELSE (0)::numeric
        END AS grav10
   FROM public.ventas_det_servicios vds,
    public.v_items vi
  WHERE (vds.item_cod = vi.item_cod);
 )   DROP VIEW public.v_ventas_det_servicios;
       public          postgres    false    277    277    277    295    295    295    295    277    277    277            A           1259    309272    v_ventas_detalles    VIEW     (  CREATE VIEW public.v_ventas_detalles AS
         SELECT v_ventas_det_servicios.ven_cod,
            v_ventas_det_servicios.item_cod,
            v_ventas_det_servicios.item_desc,
            0 AS mar_cod,
            '---'::character varying AS mar_desc,
            0 AS dep_cod,
            '---'::character varying AS dep_desc,
            v_ventas_det_servicios.ven_cantidad,
            v_ventas_det_servicios.ven_precio,
            v_ventas_det_servicios.tipo_item_cod,
            v_ventas_det_servicios.tipo_item_desc,
            v_ventas_det_servicios.tipo_imp_cod,
            v_ventas_det_servicios.tipo_imp_desc,
            v_ventas_det_servicios.exenta,
            v_ventas_det_servicios.grav5,
            v_ventas_det_servicios.grav10
           FROM public.v_ventas_det_servicios
UNION ALL
         SELECT v_ventas_det_items.ven_cod,
            v_ventas_det_items.item_cod,
            v_ventas_det_items.item_desc,
            v_ventas_det_items.mar_cod,
            v_ventas_det_items.mar_desc,
            v_ventas_det_items.dep_cod,
            v_ventas_det_items.dep_desc,
            v_ventas_det_items.ven_cantidad,
            v_ventas_det_items.ven_precio,
            v_ventas_det_items.tipo_item_cod,
            v_ventas_det_items.tipo_item_desc,
            v_ventas_det_items.tipo_imp_cod,
            v_ventas_det_items.tipo_imp_desc,
            v_ventas_det_items.exenta,
            v_ventas_det_items.grav5,
            v_ventas_det_items.grav10
           FROM public.v_ventas_det_items
  ORDER BY 1, 2, 3, 4, 5, 6, 7, 10, 11, 12, 13;
 $   DROP VIEW public.v_ventas_detalles;
       public          postgres    false    319    320    320    320    320    319    319    319    319    319    319    319    319    320    320    320    319    319    320    320    320    320    320    320    320    320    320    319            �          0    207112    agendas 
   TABLE DATA           �   COPY public.agendas (agen_cod, agen_estado, fun_cod, usu_cod, suc_cod, emp_cod, agenda_fecha, fun_agen, hora_desde, hora_hasta, dias_cod) FROM stdin;
    public          postgres    false    171   a�      n          0    383050    agendas_cab 
   TABLE DATA           x   COPY public.agendas_cab (agen_cod, fun_cod, agen_fecha, agen_estado, usu_cod, fun_codigo, suc_cod, emp_cod) FROM stdin;
    public          postgres    false    334   ��      o          0    383070    agendas_det 
   TABLE DATA           Q   COPY public.agendas_det (agen_cod, dias_cod, hora_desde, hora_hasta) FROM stdin;
    public          postgres    false    335   	�      �          0    207115    ajustes_cab 
   TABLE DATA           w   COPY public.ajustes_cab (ajus_cod, ajus_fecha, ajus_estado, suc_cod, emp_cod, usu_cod, fun_cod, ajus_tipo) FROM stdin;
    public          postgres    false    172   p�      �          0    207118    ajustes_det 
   TABLE DATA           c   COPY public.ajustes_det (ajus_cod, dep_cod, item_cod, mar_cod, mot_cod, ajus_cantidad) FROM stdin;
    public          postgres    false    173   l�                 0    207121    aperturas_cierres 
   TABLE DATA           �   COPY public.aperturas_cierres (aper_cier_cod, aper_fecha, aper_monto, aper_cier_fecha, aper_cier_monto, caja_cod, usu_cod, suc_cod, emp_cod, fun_cod, timb_cod) FROM stdin;
    public          postgres    false    174   Y�                0    207124    arqueos 
   TABLE DATA           `   COPY public.arqueos (arq_cod, aper_cier_cod, arq_cheque, arq_tarjeta, arq_efectivo) FROM stdin;
    public          postgres    false    175   �      e          0    268011    asignacion_fondo_fijo 
   TABLE DATA           �   COPY public.asignacion_fondo_fijo (asignacion_responsable_cod, orden_pago_cod, ent_cod, cuenta_corriente_cod, movimiento_nro, fecha_asignacion, caja_cod, monto_asignado, observacion, fun_cod, usu_cod, suc_cod, emp_cod) FROM stdin;
    public          postgres    false    310   -�                0    207127    avisos_recordatorios 
   TABLE DATA           �   COPY public.avisos_recordatorios (aviso_cod, aviso_desc, emp_cod, suc_cod, fun_cod, aviso_estado, cli_cod, aviso_hora, usu_cod, item_cod) FROM stdin;
    public          postgres    false    176   J�                0    207130    bancos 
   TABLE DATA           L   COPY public.bancos (banco_cod, banco_nom, banco_dir, banco_tel) FROM stdin;
    public          postgres    false    177   g�      f          0    268062    boleta_deposito 
   TABLE DATA           �   COPY public.boleta_deposito (ent_cod, cuenta_corriente_cod, movimiento_nro, recau_dep_cod, aper_cier_cod, fecha_deposito, monto, estado) FROM stdin;
    public          postgres    false    311   ��                0    207133    cajas 
   TABLE DATA           u   COPY public.cajas (caja_cod, caja_desc, caja_estado, suc_cod, caja_ultrecibo, emp_cod, usu_cod, fun_cod) FROM stdin;
    public          postgres    false    178   ѷ                0    207136    cargos 
   TABLE DATA           3   COPY public.cargos (car_cod, car_desc) FROM stdin;
    public          postgres    false    179   B�                0    207139    cheque 
   TABLE DATA           d   COPY public.cheque (cheque_cod, banco_cod, cheque_tipo_cod, cheque_cta_nro, cheque_nro) FROM stdin;
    public          postgres    false    180   ��      m          0    366740    choferes 
   TABLE DATA           C   COPY public.choferes (chofer_cod, per_cod, chofer_ruc) FROM stdin;
    public          postgres    false    332   �                0    207142    ciudades 
   TABLE DATA           ?   COPY public.ciudades (ciu_cod, ciu_desc, pais_cod) FROM stdin;
    public          postgres    false    181   �                0    207145    clasificaciones 
   TABLE DATA           <   COPY public.clasificaciones (cla_cod, cla_desc) FROM stdin;
    public          postgres    false    182   d�      	          0    207148    clientes 
   TABLE DATA           i   COPY public.clientes (cli_cod, per_cod, cli_estado, cli_ruc, cli_fecha_alta, cli_fecha_baja) FROM stdin;
    public          postgres    false    183   ��      
          0    207151 
   cobros_cab 
   TABLE DATA           �   COPY public.cobros_cab (cobro_cod, cobro_fecha, cobro_efectivo, cobro_estado, aper_cier_cod, cobro_recibo, usu_cod, fun_cod, suc_cod, emp_cod, fcob_cod) FROM stdin;
    public          postgres    false    184   �                0    207154    cobros_cheques 
   TABLE DATA           �   COPY public.cobros_cheques (cobro_cod, ch_cuenta_num, serie, cheq_num, cheq_importe, fecha_emision, fecha_recepcion, fecha_cobro, librador, banco_cod, cheque_tipo_cod, cheque_estado) FROM stdin;
    public          postgres    false    185   f�                0    207157 
   cobros_det 
   TABLE DATA           V   COPY public.cobros_det (cobro_cod, ven_cod, ctas_cobrar_nro, cobro_monto) FROM stdin;
    public          postgres    false    186   ��                0    207160    cobros_tarjetas 
   TABLE DATA           {   COPY public.cobros_tarjetas (cobro_cod, mar_tarj_cod, cob_tarj_nro, cod_auto, ent_cod, ent_ad_cod, tarj_monto) FROM stdin;
    public          postgres    false    187   ��      p          0    383093    compras_cab 
   TABLE DATA           �   COPY public.compras_cab (comp_cod, prov_cod, prov_timb_nro, prov_timb_vig, nro_factura, comp_fecha, comp_fecha_factura, comp_estado, tipo_fact_cod, comp_plazo, comp_cuotas, usu_cod, fun_cod, suc_cod, emp_cod) FROM stdin;
    public          postgres    false    338   ʺ      q          0    383116    compras_det 
   TABLE DATA           s   COPY public.compras_det (comp_cod, dep_cod, item_cod, mar_cod, comp_cantidad, comp_costo, comp_precio) FROM stdin;
    public          postgres    false    339   ��                0    207169    cuentas_cobrar 
   TABLE DATA              COPY public.cuentas_cobrar (ven_cod, ctas_cobrar_nro, ctas_venc, ctas_monto, ctas_saldo, ctas_estado, fecha_cobro) FROM stdin;
    public          postgres    false    188   7�      `          0    259760    cuentas_corrientes 
   TABLE DATA           s   COPY public.cuentas_corrientes (ent_cod, cuenta_corriente_cod, cuenta_corriente_nro, monto_disponible) FROM stdin;
    public          postgres    false    305   ��      r          0    383134    cuentas_pagar 
   TABLE DATA           q   COPY public.cuentas_pagar (comp_cod, ctas_pagar_nro, ctas_venc, ctas_monto, ctas_saldo, ctas_estado) FROM stdin;
    public          postgres    false    340   ��      [          0    251521    cuentas_pagar_fact_varias 
   TABLE DATA           �   COPY public.cuentas_pagar_fact_varias (fact_var_cod, prov_cod, cuentas_pagar_fact_var_nro, cuotas, plazo, cuotas_monto, cuotas_saldo, cuotas_estado, cuotas_fecha_pago) FROM stdin;
    public          postgres    false    300   ,�      a          0    259773    cuentas_titulares 
   TABLE DATA           s   COPY public.cuentas_titulares (titular_cod, ent_cod, cuenta_corriente_cod, cuenta_estado, observacion) FROM stdin;
    public          postgres    false    306   I�      j          0    358455 
   cuotapagar 
   TABLE DATA           0   COPY public.cuotapagar ("?column?") FROM stdin;
    public          postgres    false    322   f�                0    207175 	   depositos 
   TABLE DATA           T   COPY public.depositos (dep_cod, emp_cod, suc_cod, dep_desc, dep_estado) FROM stdin;
    public          postgres    false    189   ��                0    207178 
   descuentos 
   TABLE DATA           �   COPY public.descuentos (descuento_cod, item_cod, descuento_incial, descuento_nro, descuento_rebaje, descuento_monto, descuento_final, descuento_estado) FROM stdin;
    public          postgres    false    190   �                0    207181    detalle_timbrados 
   TABLE DATA           ?   COPY public.detalle_timbrados (caja_cod, timb_cod) FROM stdin;
    public          postgres    false    191   �                0    207184    dias 
   TABLE DATA           3   COPY public.dias (dias_cod, dias_desc) FROM stdin;
    public          postgres    false    192   1�                0    207187    empresas 
   TABLE DATA           Z   COPY public.empresas (emp_cod, emp_nom, emp_ruc, emp_dir, emp_tel, emp_email) FROM stdin;
    public          postgres    false    193   ��                0    207190    entidades_adheridas 
   TABLE DATA           �   COPY public.entidades_adheridas (ent_ad_cod, ent_cod, mar_tarj_cod, ent_ad_nom, ent_ad_dir, ent_ad_tel, ent_ad_email) FROM stdin;
    public          postgres    false    194   ��                0    207193    entidades_emisoras 
   TABLE DATA           [   COPY public.entidades_emisoras (ent_cod, ent_nom, ent_dir, ent_tel, ent_email) FROM stdin;
    public          postgres    false    195   ��                0    207196    equipos_trabajos 
   TABLE DATA           l   COPY public.equipos_trabajos (equi_cod, fun_cod, ord_trab_cod, item_cod, equi_fecha, equi_desc) FROM stdin;
    public          postgres    false    196   �                0    207199    especialidades 
   TABLE DATA           G   COPY public.especialidades (esp_cod, esp_desc, esp_estado) FROM stdin;
    public          postgres    false    197   M�                0    207202    estados_civiles 
   TABLE DATA           >   COPY public.estados_civiles (esta_cod, esta_desc) FROM stdin;
    public          postgres    false    198   ��      Y          0    251468    facturas_varias_cab 
   TABLE DATA           �   COPY public.facturas_varias_cab (fact_var_cod, prov_cod, suc_cod, emp_cod, fun_cod, usu_cod, fecha_ope, tipo_doc_cod, nro_factura, fecha_fact, tipo_fact_cod, estado) FROM stdin;
    public          postgres    false    298   ��      Z          0    251498    facturas_varias_det 
   TABLE DATA           �   COPY public.facturas_varias_det (fact_var_cod, prov_cod, rubro_cod, tipo_imp_cod, monto, grav10, grav5, exentas, iva10, iva5) FROM stdin;
    public          postgres    false    299   �                0    207205    formas_cobros 
   TABLE DATA           <   COPY public.formas_cobros (fcob_cod, fcob_desc) FROM stdin;
    public          postgres    false    199   2�                0    207208    funcionarios 
   TABLE DATA           �   COPY public.funcionarios (fun_cod, per_cod, car_cod, fun_estado, fun_fecha_alta, fun_fecha_baja, prof_cod, esp_cod) FROM stdin;
    public          postgres    false    200   u�                0    207211    generos 
   TABLE DATA           4   COPY public.generos (gen_cod, gen_desc) FROM stdin;
    public          postgres    false    201   ��                0    207217    items 
   TABLE DATA           k   COPY public.items (item_cod, tipo_item_cod, item_desc, item_estado, item_precio, tipo_imp_cod) FROM stdin;
    public          postgres    false    203   +�      s          0    383144    libro_compras 
   TABLE DATA           b   COPY public.libro_compras (comp_cod, comp_exenta, comp_gra5, comp_gra10, iva5, iva10) FROM stdin;
    public          postgres    false    341   7�                0    207223    libro_ventas 
   TABLE DATA           �   COPY public.libro_ventas (libro_ven_cod, ven_cod, ven_exenta, ven_gra5, ven_gra10, ven_iva5, ven_iva10, venta_nro_fact, timb_cod, fecha_vdesde_tim, fecha_vhasta_tim, fecha_factura, cobro_cod) FROM stdin;
    public          postgres    false    204   ��                0    207226    marca_tarjetas 
   TABLE DATA           E   COPY public.marca_tarjetas (mar_tarj_cod, mar_tarj_desc) FROM stdin;
    public          postgres    false    205   :�                 0    207229    marcas 
   TABLE DATA           3   COPY public.marcas (mar_cod, mar_desc) FROM stdin;
    public          postgres    false    206   s�      S          0    208584    marcas_items 
   TABLE DATA           i   COPY public.marcas_items (item_cod, mar_cod, costo, precio, item_min, item_max, item_estado) FROM stdin;
    public          postgres    false    276   ��      !          0    207232    modulos 
   TABLE DATA           3   COPY public.modulos (mod_id, mod_desc) FROM stdin;
    public          postgres    false    207   8�      "          0    207235    motivo_ajustes 
   TABLE DATA           ;   COPY public.motivo_ajustes (mot_cod, mot_desc) FROM stdin;
    public          postgres    false    208   U�      b          0    267892    movimiento_bancario 
   TABLE DATA           �   COPY public.movimiento_bancario (ent_cod, cuenta_corriente_cod, movimiento_nro, fecha_ope, fecha_deposito, fecha_extraccion, movimiento_monto_debito, movimietno_monto_credito, estado, conciliar, usu_cod, fun_cod, suc_cod, emp_cod) FROM stdin;
    public          postgres    false    307   ��      t          0    391292    notas_com_cab 
   TABLE DATA             COPY public.notas_com_cab (nota_com_nro, comp_cod, nota_com_fecha_factura, nota_com_timbrado, nota_com_tim_vighasta, nota_com_factura, nota_com_fecha, nota_com_estado, nota_com_tipo, fun_cod, usu_cod, suc_cod, emp_cod, nota_monto, nota_descripcion, nota_cred_motivo) FROM stdin;
    public          postgres    false    344   ��      u          0    391312    notas_com_det 
   TABLE DATA           �   COPY public.notas_com_det (nota_com_nro, comp_cod, dep_cod, item_cod, mar_cod, nota_com_cant, nota_com_precio, nota_com_desc) FROM stdin;
    public          postgres    false    345   ��      x          0    432284    notas_remisiones_cab 
   TABLE DATA           �   COPY public.notas_remisiones_cab (nota_rem_cod, ven_cod, nota_rem_fecha, nota_rem_estado, vehi_cod, chofer_cod, remision_tipo, chofer_timb, chofer_timb_vighasta, chofer_factura, chofer_monto, usu_cod, fun_cod, suc_cod, emp_cod) FROM stdin;
    public          postgres    false    354   ��      y          0    432307    notas_remisiones_det 
   TABLE DATA           o   COPY public.notas_remisiones_det (nota_rem_cod, item_cod, mar_cod, nota_rem_cant, nota_rem_precio) FROM stdin;
    public          postgres    false    355   ��      w          0    415920    notas_ven_cab 
   TABLE DATA           �   COPY public.notas_ven_cab (nota_ven_cod, ven_cod, nota_ven_nro_fact, nota_ven_fecha, nota_ven_estado, timb_cod, cli_cod, nota_ven_tipo, nota_ven_motivo, nota_monto, nota_descripcion, fun_cod, usu_cod, suc_cod, emp_cod) FROM stdin;
    public          postgres    false    352   ��      v          0    415912    notas_ven_det 
   TABLE DATA           �   COPY public.notas_ven_det (nota_ven_cod, dep_cod, item_cod, mar_cod, nota_ven_cant, nota_ven_precio, nota_ven_desc) FROM stdin;
    public          postgres    false    351   ~�      #          0    207250    ordcompras_cab 
   TABLE DATA           �   COPY public.ordcompras_cab (orden_nro, orden_fecha, orden_plazo, orden_cuotas, orden_estado, suc_cod, emp_cod, usu_cod, fun_cod, prov_cod, tipo_fact_cod) FROM stdin;
    public          postgres    false    209   ��      $          0    207253    ordcompras_det 
   TABLE DATA           d   COPY public.ordcompras_det (orden_nro, item_cod, mar_cod, orden_cantidad, orden_precio) FROM stdin;
    public          postgres    false    210   a�      %          0    207256    orden_compra 
   TABLE DATA           ;   COPY public.orden_compra (comp_cod, orden_cod) FROM stdin;
    public          postgres    false    211   ,�      \          0    259656    orden_pago_cab 
   TABLE DATA           �   COPY public.orden_pago_cab (orden_pago_cod, prov_cod, nro_factura, fcob_cod, fecha_ope, estado, usu_cod, fun_cod, suc_cod, emp_cod) FROM stdin;
    public          postgres    false    301   p�      ^          0    259720    orden_pago_det_compras 
   TABLE DATA           �   COPY public.orden_pago_det_compras (orden_pago_cod, prov_cod, prov_timb_nro, nro_factura, ctas_pagar_nro, estado, monto) FROM stdin;
    public          postgres    false    303   ��      ]          0    259696    orden_pago_detalle_fact_varias 
   TABLE DATA           �   COPY public.orden_pago_detalle_fact_varias (orden_pago_cod, fact_var_cod, prov_cod, cuentas_pagar_fact_var_nro, monto, estado) FROM stdin;
    public          postgres    false    302   ��      &          0    207259    ordenes_trabajos_cab 
   TABLE DATA           �   COPY public.ordenes_trabajos_cab (ord_trab_cod, ord_trab_nro, emp_cod, suc_cod, fun_cod, ord_trab_fecha, ord_trab_estado, cli_cod, usu_cod) FROM stdin;
    public          postgres    false    212   ��      '          0    207262    ordenes_trabajos_det 
   TABLE DATA           �   COPY public.ordenes_trabajos_det (ord_trab_cod, item_cod, orden_precio, orden_hdesde, orden_hhasta, ord_trab_desc, fun_cod, orden_estado, observacion, orden_fecha) FROM stdin;
    public          postgres    false    213   ��      d          0    267998    otros_cred_deb_bancarios 
   TABLE DATA           �   COPY public.otros_cred_deb_bancarios (otro_deb_cred_ban_cod, ent_cod, cuenta_corriente_cod, movimiento_nro, descripcion, tipo_movimiento) FROM stdin;
    public          postgres    false    309   ��      (          0    207265    paginas 
   TABLE DATA           M   COPY public.paginas (pag_id, mod_id, pag_desc, pag_seccion_menu) FROM stdin;
    public          postgres    false    214   ��      c          0    267980    pago_cheques 
   TABLE DATA           �   COPY public.pago_cheques (orden_pago_cod, ent_cod, cuenta_corriente_cod, movimiento_nro, estado, monto_cheque, fecha_pago) FROM stdin;
    public          postgres    false    308   ��      )          0    207268    paises 
   TABLE DATA           5   COPY public.paises (pais_cod, pais_desc) FROM stdin;
    public          postgres    false    215   ��      *          0    207271    pedido_orden 
   TABLE DATA           :   COPY public.pedido_orden (ped_cod, orden_cod) FROM stdin;
    public          postgres    false    216   "�      +          0    207274    pedidos_cab 
   TABLE DATA           i   COPY public.pedidos_cab (ped_nro, ped_fecha, ped_estado, suc_cod, emp_cod, fun_cod, usu_cod) FROM stdin;
    public          postgres    false    217   ?�      ,          0    207277    pedidos_det 
   TABLE DATA           [   COPY public.pedidos_det (ped_nro, item_cod, mar_cod, ped_cantidad, ped_precio) FROM stdin;
    public          postgres    false    218   8�      -          0    207280    pedidos_vcab 
   TABLE DATA           }   COPY public.pedidos_vcab (ped_vcod, suc_cod, emp_cod, ped_fecha, ped_nro, ped_estado, fun_cod, cli_cod, usu_cod) FROM stdin;
    public          postgres    false    219   W�      .          0    207283    pedidos_vdet 
   TABLE DATA           ]   COPY public.pedidos_vdet (ped_vcod, item_cod, mar_cod, ped_cantidad, ped_precio) FROM stdin;
    public          postgres    false    220   P�                0    207214    perfiles 
   TABLE DATA           ;   COPY public.perfiles (perfil_cod, perfil_desc) FROM stdin;
    public          postgres    false    202   ��      /          0    207286    permisos 
   TABLE DATA           j   COPY public.permisos (pag_id, mod_id, per_insert, per_update, per_delete, per_select, gru_id) FROM stdin;
    public          postgres    false    221   �      0          0    207289    personas 
   TABLE DATA           �   COPY public.personas (per_cod, per_nom, per_ape, per_dir, per_tel, per_ci, per_fenac, per_email, pais_cod, ciu_cod, gen_cod, tipo_per_cod, esta_cod) FROM stdin;
    public          postgres    false    222   7�      1          0    207292    presupuestos_cab 
   TABLE DATA           �   COPY public.presupuestos_cab (presu_cod, presu_fecha, presu_validez, presu_estado, suc_cod, emp_cod, fun_cod, cli_cod, usu_cod) FROM stdin;
    public          postgres    false    223   ��      U          0    216941    presupuestos_det_items 
   TABLE DATA           l   COPY public.presupuestos_det_items (presu_cod, item_cod, mar_cod, presu_cantidad, presu_precio) FROM stdin;
    public          postgres    false    292   ��      2          0    207295    presupuestos_det_servicios 
   TABLE DATA           g   COPY public.presupuestos_det_servicios (presu_cod, item_cod, presu_cantidad, presu_precio) FROM stdin;
    public          postgres    false    224   -�      k          0    358494    presupuestos_proveedores_cab 
   TABLE DATA           �   COPY public.presupuestos_proveedores_cab (pre_prov_cod, prov_cod, pre_prov_fecha, pre_prov_estado, pre_prov_validez, pre_prov_fecha_operacion, suc_cod, emp_cod, fun_cod, usu_cod) FROM stdin;
    public          postgres    false    323   w�      l          0    358514    presupuestos_proveedores_det 
   TABLE DATA           �   COPY public.presupuestos_proveedores_det (pre_prov_cod, prov_cod, pre_prov_fecha, item_cod, mar_cod, pre_prov_cantidad, pre_prov_precio) FROM stdin;
    public          postgres    false    324   |�      3          0    207298    profesiones 
   TABLE DATA           :   COPY public.profesiones (prof_cod, prof_desc) FROM stdin;
    public          postgres    false    225   A�      4          0    207301 
   promos_cab 
   TABLE DATA           �   COPY public.promos_cab (promo_cod, promo_dfecha, promo_feinicio, promo_fefin, promo_estado, usu_cod, fun_cod, suc_cod, emp_cod, promo_desc) FROM stdin;
    public          postgres    false    226   ��      T          0    216914    promos_det_items 
   TABLE DATA           l   COPY public.promos_det_items (promo_cod, item_cod, mar_cod, descuento, promo_precio, tipo_desc) FROM stdin;
    public          postgres    false    290   ��      5          0    207304    promos_det_servicios 
   TABLE DATA           h   COPY public.promos_det_servicios (promo_cod, item_cod, promo_desc, promo_precio, tipo_desc) FROM stdin;
    public          postgres    false    227   ��      6          0    207307    proveedor_timbrados 
   TABLE DATA           Y   COPY public.proveedor_timbrados (prov_cod, prov_timb_nro, prov_tim_vighasta) FROM stdin;
    public          postgres    false    228   �      7          0    207310    proveedores 
   TABLE DATA           q   COPY public.proveedores (prov_cod, per_cod, prov_ruc, prov_estado, prov_fecha_alta, prov_fecha_baja) FROM stdin;
    public          postgres    false    229   a�      8          0    207313    recaudaciones_dep 
   TABLE DATA           |   COPY public.recaudaciones_dep (recau_dep_cod, aper_cier_cod, recaudaciones_fecha, monto_efectivo, monto_cheque) FROM stdin;
    public          postgres    false    230   ��      9          0    207316    reclamo_clientes 
   TABLE DATA           �   COPY public.reclamo_clientes (reclamo_cod, tipo_reclamo_cod, reclamo_desc, emp_cod, suc_reclamo, fun_cod, cli_cod, reclamo_estado, reclamo_fecha, reclamo_fecha_cliente, usu_cod, tipo_recl_item_cod, suc_cod) FROM stdin;
    public          postgres    false    231   �      g          0    268093    rendicion_fondo_fijo 
   TABLE DATA           �   COPY public.rendicion_fondo_fijo (asignacion_responsable_cod, rendicion_fondo_fijo_cod, tipo_doc_cod, prov_cod, tipo_fact_cod, nro_factura, fecha, monto, grav10, grav5, exentas, iva10, iva5) FROM stdin;
    public          postgres    false    312   ��      h          0    268142    reposicion_fondo_fijo 
   TABLE DATA           �   COPY public.reposicion_fondo_fijo (reposicion_cod, asignacion_responsable_cod, rendicion_fondo_fijo_cod, orden_pago_cod, ent_cod, cuenta_corriente_cod, movimiento_nro, fecha_reposicion, estado, monto_rendicion, observacion) FROM stdin;
    public          postgres    false    313   ��      :          0    207322    reservas_cab 
   TABLE DATA           y   COPY public.reservas_cab (reser_cod, reser_estado, reser_fecha, suc_cod, emp_cod, cli_cod, fun_cod, usu_cod) FROM stdin;
    public          postgres    false    232   ��      ;          0    207325    reservas_det 
   TABLE DATA           �   COPY public.reservas_det (reser_cod, reser_hdesde, reser_hhasta, fecha_reser, reser_precio, item_cod, reser_desc, fun_cod) FROM stdin;
    public          postgres    false    233   T�      i          0    294427    retorno 
   TABLE DATA           /   COPY public.retorno (ord_trab_cod) FROM stdin;
    public          postgres    false    318   ?�      W          0    251433    rubros 
   TABLE DATA           7   COPY public.rubros (rubro_cod, rubro_desc) FROM stdin;
    public          postgres    false    296   _�      <          0    207328    servicios_cab 
   TABLE DATA           `   COPY public.servicios_cab (serv_cod, serv_estado, serv_fecha, serv_dfecha, cli_cod) FROM stdin;
    public          postgres    false    234   |�      =          0    207331    servicios_det 
   TABLE DATA           X   COPY public.servicios_det (serv_cod, tipo_serv_cod, serv_precio, serv_desc) FROM stdin;
    public          postgres    false    235   ��      >          0    207334    sesiones 
   TABLE DATA           ;   COPY public.sesiones (sesion_cod, sesion_desc) FROM stdin;
    public          postgres    false    236   ��      ?          0    207337    stock 
   TABLE DATA           K   COPY public.stock (dep_cod, item_cod, mar_cod, stock_cantidad) FROM stdin;
    public          postgres    false    237   ��      @          0    207340 
   sucursales 
   TABLE DATA           h   COPY public.sucursales (suc_cod, emp_cod, suc_nom, suc_dir, suc_tel, suc_email, suc_estado) FROM stdin;
    public          postgres    false    238   I�      A          0    207343 	   timbrados 
   TABLE DATA           �   COPY public.timbrados (timb_cod, timb_nro, tim_fecha_registro, timb_estado, tim_vigdesde, tim_vighasta, suc_cod, emp_cod, tim_nrodesde, tim_nrohasta, tim_ultfactura, puntoexp) FROM stdin;
    public          postgres    false    239   ��      B          0    207346    tipo_ajustes 
   TABLE DATA           I   COPY public.tipo_ajustes (tipo_ajuste_cod, tipo_ajuste_desc) FROM stdin;
    public          postgres    false    240   ��      C          0    207349    tipo_cheques 
   TABLE DATA           I   COPY public.tipo_cheques (cheque_tipo_cod, cheque_tipo_desc) FROM stdin;
    public          postgres    false    241   ��      X          0    251438    tipo_documentos 
   TABLE DATA           F   COPY public.tipo_documentos (tipo_doc_cod, tipo_doc_desc) FROM stdin;
    public          postgres    false    297   �      D          0    207352    tipo_facturas 
   TABLE DATA           F   COPY public.tipo_facturas (tipo_fact_cod, tipo_fact_desc) FROM stdin;
    public          postgres    false    242   �      E          0    207355    tipo_impuestos 
   TABLE DATA           E   COPY public.tipo_impuestos (tipo_imp_cod, tipo_imp_desc) FROM stdin;
    public          postgres    false    243   P�      F          0    207358 
   tipo_items 
   TABLE DATA           C   COPY public.tipo_items (tipo_item_cod, tipo_item_desc) FROM stdin;
    public          postgres    false    244   ��      G          0    207361    tipo_personas 
   TABLE DATA           E   COPY public.tipo_personas (tipo_per_cod, tipo_pers_desc) FROM stdin;
    public          postgres    false    245   ��      H          0    207364    tipo_reclamo_items 
   TABLE DATA           U   COPY public.tipo_reclamo_items (tipo_recl_item_cod, tipo_recl_item_desc) FROM stdin;
    public          postgres    false    246   ��      I          0    207367    tipo_reclamos 
   TABLE DATA           L   COPY public.tipo_reclamos (tipo_reclamo_cod, tipo_reclamo_desc) FROM stdin;
    public          postgres    false    247   L�      J          0    207370    tipo_servicios 
   TABLE DATA           �   COPY public.tipo_servicios (tipo_serv_cod, tipo_serv_desc, tipo_serv_precio, tipo_serv_estado, tipo_serv_impuesto, esp_cod) FROM stdin;
    public          postgres    false    248   ��      _          0    259744 	   titulares 
   TABLE DATA           l   COPY public.titulares (titular_cod, titular_nombre, titular_apellido, titular_ci, titular_desc) FROM stdin;
    public          postgres    false    304   ��      K          0    207373    transferencias_cab 
   TABLE DATA           :  COPY public.transferencias_cab (trans_cod, trans_fecha, trans_estado, suc_cod, emp_cod, fun_cod, trans_fecha_envio, trans_fecha_entrega, vehi_cod, trans_origen, trans_destino, trans_enviar_recibir, usu_cod, usu_recep, chofer_cod, chofer_timbrado, chofefr_nro_factura, chofer_nro_factura, trans_precio) FROM stdin;
    public          postgres    false    249   ��      L          0    207376    transferencias_det 
   TABLE DATA           �   COPY public.transferencias_det (trans_cod, dep_origen, item_cod, mar_cod, trans_cantidad, trans_cant_recibida, dep_destino) FROM stdin;
    public          postgres    false    250   +�      M          0    207379    usuarios 
   TABLE DATA           |   COPY public.usuarios (usu_cod, fun_cod, suc_cod, emp_cod, usu_name, usu_pass, usu_estado, perfil_cod, usu_foto) FROM stdin;
    public          postgres    false    251   ��      N          0    207559 	   vehiculos 
   TABLE DATA           ^   COPY public.vehiculos (vehi_cod, veh_mar_cod, veh_mod_cod, veh_chapa, veh_estado) FROM stdin;
    public          postgres    false    270   ��      O          0    207562    vehiculos_marcas 
   TABLE DATA           E   COPY public.vehiculos_marcas (veh_mar_cod, veh_mar_desc) FROM stdin;
    public          postgres    false    271   &�      P          0    207565    vehiculos_modelos 
   TABLE DATA           F   COPY public.vehiculos_modelos (veh_mod_cod, veh_mod_desc) FROM stdin;
    public          postgres    false    272   f�      Q          0    207581 
   ventas_cab 
   TABLE DATA           �   COPY public.ventas_cab (ven_cod, ven_fecha, ven_estado, emp_cod, suc_cod, usu_cod, fun_cod, cli_cod, tipo_fact_cod, ven_plazo, ven_cuotas) FROM stdin;
    public          postgres    false    274   ��      R          0    207584    ventas_det_items 
   TABLE DATA           i   COPY public.ventas_det_items (ven_cod, dep_cod, item_cod, mar_cod, ven_cantidad, ven_precio) FROM stdin;
    public          postgres    false    275   ��      V          0    251411    ventas_det_servicios 
   TABLE DATA           [   COPY public.ventas_det_servicios (ven_cod, item_cod, ven_cantidad, ven_precio) FROM stdin;
    public          postgres    false    295   �      x
           2606    207588    agendas agendas_cab_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.agendas
    ADD CONSTRAINT agendas_cab_pk PRIMARY KEY (agen_cod);
 @   ALTER TABLE ONLY public.agendas DROP CONSTRAINT agendas_cab_pk;
       public            postgres    false    171            T           2606    383054    agendas_cab agendas_cab_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.agendas_cab
    ADD CONSTRAINT agendas_cab_pkey PRIMARY KEY (agen_cod);
 F   ALTER TABLE ONLY public.agendas_cab DROP CONSTRAINT agendas_cab_pkey;
       public            postgres    false    334            V           2606    383074    agendas_det agendas_det_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.agendas_det
    ADD CONSTRAINT agendas_det_pk PRIMARY KEY (agen_cod, dias_cod, hora_desde, hora_hasta);
 D   ALTER TABLE ONLY public.agendas_det DROP CONSTRAINT agendas_det_pk;
       public            postgres    false    335    335    335    335            z
           2606    207590    ajustes_cab ajustes_cab_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.ajustes_cab
    ADD CONSTRAINT ajustes_cab_pk PRIMARY KEY (ajus_cod);
 D   ALTER TABLE ONLY public.ajustes_cab DROP CONSTRAINT ajustes_cab_pk;
       public            postgres    false    172            |
           2606    208628    ajustes_det ajustes_det_pk 
   CONSTRAINT     z   ALTER TABLE ONLY public.ajustes_det
    ADD CONSTRAINT ajustes_det_pk PRIMARY KEY (ajus_cod, dep_cod, item_cod, mar_cod);
 D   ALTER TABLE ONLY public.ajustes_det DROP CONSTRAINT ajustes_det_pk;
       public            postgres    false    173    173    173    173            ~
           2606    207594 &   aperturas_cierres aperturas_cierres_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.aperturas_cierres
    ADD CONSTRAINT aperturas_cierres_pk PRIMARY KEY (aper_cier_cod);
 P   ALTER TABLE ONLY public.aperturas_cierres DROP CONSTRAINT aperturas_cierres_pk;
       public            postgres    false    174            �
           2606    207596    arqueos arqueos_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.arqueos
    ADD CONSTRAINT arqueos_pk PRIMARY KEY (arq_cod, aper_cier_cod);
 <   ALTER TABLE ONLY public.arqueos DROP CONSTRAINT arqueos_pk;
       public            postgres    false    175    175            F           2606    268018 0   asignacion_fondo_fijo asignacion_fondo_fijo_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.asignacion_fondo_fijo
    ADD CONSTRAINT asignacion_fondo_fijo_pkey PRIMARY KEY (asignacion_responsable_cod);
 Z   ALTER TABLE ONLY public.asignacion_fondo_fijo DROP CONSTRAINT asignacion_fondo_fijo_pkey;
       public            postgres    false    310            �
           2606    207598 ,   avisos_recordatorios avisos_recordatorios_pk 
   CONSTRAINT     q   ALTER TABLE ONLY public.avisos_recordatorios
    ADD CONSTRAINT avisos_recordatorios_pk PRIMARY KEY (aviso_cod);
 V   ALTER TABLE ONLY public.avisos_recordatorios DROP CONSTRAINT avisos_recordatorios_pk;
       public            postgres    false    176            �
           2606    207600    bancos bancos_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.bancos
    ADD CONSTRAINT bancos_pkey PRIMARY KEY (banco_cod);
 <   ALTER TABLE ONLY public.bancos DROP CONSTRAINT bancos_pkey;
       public            postgres    false    177            H           2606    268069 "   boleta_deposito boleta_deposito_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.boleta_deposito
    ADD CONSTRAINT boleta_deposito_pk PRIMARY KEY (ent_cod, cuenta_corriente_cod, movimiento_nro, recau_dep_cod, aper_cier_cod);
 L   ALTER TABLE ONLY public.boleta_deposito DROP CONSTRAINT boleta_deposito_pk;
       public            postgres    false    311    311    311    311    311            �
           2606    207602    cajas cajas_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.cajas
    ADD CONSTRAINT cajas_pk PRIMARY KEY (caja_cod);
 8   ALTER TABLE ONLY public.cajas DROP CONSTRAINT cajas_pk;
       public            postgres    false    178            �
           2606    207604    cargos cargos_pk 
   CONSTRAINT     S   ALTER TABLE ONLY public.cargos
    ADD CONSTRAINT cargos_pk PRIMARY KEY (car_cod);
 :   ALTER TABLE ONLY public.cargos DROP CONSTRAINT cargos_pk;
       public            postgres    false    179            �
           2606    207606    cheque cheque_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.cheque
    ADD CONSTRAINT cheque_pkey PRIMARY KEY (cheque_cod);
 <   ALTER TABLE ONLY public.cheque DROP CONSTRAINT cheque_pkey;
       public            postgres    false    180            R           2606    366744    choferes choferes_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.choferes
    ADD CONSTRAINT choferes_pkey PRIMARY KEY (chofer_cod);
 @   ALTER TABLE ONLY public.choferes DROP CONSTRAINT choferes_pkey;
       public            postgres    false    332            �
           2606    207608    ciudades ciudades_pk 
   CONSTRAINT     W   ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT ciudades_pk PRIMARY KEY (ciu_cod);
 >   ALTER TABLE ONLY public.ciudades DROP CONSTRAINT ciudades_pk;
       public            postgres    false    181            �
           2606    207610 "   clasificaciones clasificaciones_pk 
   CONSTRAINT     e   ALTER TABLE ONLY public.clasificaciones
    ADD CONSTRAINT clasificaciones_pk PRIMARY KEY (cla_cod);
 L   ALTER TABLE ONLY public.clasificaciones DROP CONSTRAINT clasificaciones_pk;
       public            postgres    false    182            �
           2606    207612    clientes clientes_pk 
   CONSTRAINT     W   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pk PRIMARY KEY (cli_cod);
 >   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pk;
       public            postgres    false    183            �
           2606    207614    cobros_cab cobros_cab_pk 
   CONSTRAINT     ]   ALTER TABLE ONLY public.cobros_cab
    ADD CONSTRAINT cobros_cab_pk PRIMARY KEY (cobro_cod);
 B   ALTER TABLE ONLY public.cobros_cab DROP CONSTRAINT cobros_cab_pk;
       public            postgres    false    184            �
           2606    207616     cobros_cheques cobros_cheques_fk 
   CONSTRAINT     �   ALTER TABLE ONLY public.cobros_cheques
    ADD CONSTRAINT cobros_cheques_fk PRIMARY KEY (cobro_cod, ch_cuenta_num, serie, cheq_num);
 J   ALTER TABLE ONLY public.cobros_cheques DROP CONSTRAINT cobros_cheques_fk;
       public            postgres    false    185    185    185    185            �
           2606    207618    cobros_det cobros_det_pk 
   CONSTRAINT     w   ALTER TABLE ONLY public.cobros_det
    ADD CONSTRAINT cobros_det_pk PRIMARY KEY (cobro_cod, ven_cod, ctas_cobrar_nro);
 B   ALTER TABLE ONLY public.cobros_det DROP CONSTRAINT cobros_det_pk;
       public            postgres    false    186    186    186            �
           2606    207620 "   cobros_tarjetas cobros_tarjetas_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.cobros_tarjetas
    ADD CONSTRAINT cobros_tarjetas_pk PRIMARY KEY (cobro_cod, mar_tarj_cod, cob_tarj_nro, cod_auto);
 L   ALTER TABLE ONLY public.cobros_tarjetas DROP CONSTRAINT cobros_tarjetas_pk;
       public            postgres    false    187    187    187    187            X           2606    383100    compras_cab compras_cab_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.compras_cab
    ADD CONSTRAINT compras_cab_pkey PRIMARY KEY (comp_cod);
 F   ALTER TABLE ONLY public.compras_cab DROP CONSTRAINT compras_cab_pkey;
       public            postgres    false    338            Z           2606    383123    compras_det compras_det_pk 
   CONSTRAINT     z   ALTER TABLE ONLY public.compras_det
    ADD CONSTRAINT compras_det_pk PRIMARY KEY (comp_cod, dep_cod, item_cod, mar_cod);
 D   ALTER TABLE ONLY public.compras_det DROP CONSTRAINT compras_det_pk;
       public            postgres    false    339    339    339    339            �
           2606    207626     cuentas_cobrar cuentas_cobrar_pk 
   CONSTRAINT     t   ALTER TABLE ONLY public.cuentas_cobrar
    ADD CONSTRAINT cuentas_cobrar_pk PRIMARY KEY (ven_cod, ctas_cobrar_nro);
 J   ALTER TABLE ONLY public.cuentas_cobrar DROP CONSTRAINT cuentas_cobrar_pk;
       public            postgres    false    188    188            <           2606    259767 (   cuentas_corrientes cuentas_corrientes_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.cuentas_corrientes
    ADD CONSTRAINT cuentas_corrientes_pk PRIMARY KEY (ent_cod, cuenta_corriente_cod);
 R   ALTER TABLE ONLY public.cuentas_corrientes DROP CONSTRAINT cuentas_corrientes_pk;
       public            postgres    false    305    305            2           2606    259695 6   cuentas_pagar_fact_varias cuentas_pagar_fact_varias_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.cuentas_pagar_fact_varias
    ADD CONSTRAINT cuentas_pagar_fact_varias_pk PRIMARY KEY (fact_var_cod, prov_cod, cuentas_pagar_fact_var_nro);
 `   ALTER TABLE ONLY public.cuentas_pagar_fact_varias DROP CONSTRAINT cuentas_pagar_fact_varias_pk;
       public            postgres    false    300    300    300            \           2606    383138    cuentas_pagar cuentas_pagar_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.cuentas_pagar
    ADD CONSTRAINT cuentas_pagar_pk PRIMARY KEY (comp_cod, ctas_pagar_nro);
 H   ALTER TABLE ONLY public.cuentas_pagar DROP CONSTRAINT cuentas_pagar_pk;
       public            postgres    false    340    340            >           2606    259777 &   cuentas_titulares cuentas_titulares_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.cuentas_titulares
    ADD CONSTRAINT cuentas_titulares_pk PRIMARY KEY (titular_cod, ent_cod);
 P   ALTER TABLE ONLY public.cuentas_titulares DROP CONSTRAINT cuentas_titulares_pk;
       public            postgres    false    306    306            �
           2606    207630    depositos depositos_pk 
   CONSTRAINT     Y   ALTER TABLE ONLY public.depositos
    ADD CONSTRAINT depositos_pk PRIMARY KEY (dep_cod);
 @   ALTER TABLE ONLY public.depositos DROP CONSTRAINT depositos_pk;
       public            postgres    false    189            �
           2606    207632    descuentos descuentos_pk 
   CONSTRAINT     a   ALTER TABLE ONLY public.descuentos
    ADD CONSTRAINT descuentos_pk PRIMARY KEY (descuento_cod);
 B   ALTER TABLE ONLY public.descuentos DROP CONSTRAINT descuentos_pk;
       public            postgres    false    190            �
           2606    207634 &   detalle_timbrados detalle_timbrados_pk 
   CONSTRAINT     t   ALTER TABLE ONLY public.detalle_timbrados
    ADD CONSTRAINT detalle_timbrados_pk PRIMARY KEY (caja_cod, timb_cod);
 P   ALTER TABLE ONLY public.detalle_timbrados DROP CONSTRAINT detalle_timbrados_pk;
       public            postgres    false    191    191            �
           2606    207636    dias dias_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.dias
    ADD CONSTRAINT dias_pk PRIMARY KEY (dias_cod);
 6   ALTER TABLE ONLY public.dias DROP CONSTRAINT dias_pk;
       public            postgres    false    192            �
           2606    207638    empresas empresas_pk 
   CONSTRAINT     W   ALTER TABLE ONLY public.empresas
    ADD CONSTRAINT empresas_pk PRIMARY KEY (emp_cod);
 >   ALTER TABLE ONLY public.empresas DROP CONSTRAINT empresas_pk;
       public            postgres    false    193            �
           2606    207640 *   entidades_adheridas entidades_adheridas_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.entidades_adheridas
    ADD CONSTRAINT entidades_adheridas_pk PRIMARY KEY (ent_ad_cod, ent_cod);
 T   ALTER TABLE ONLY public.entidades_adheridas DROP CONSTRAINT entidades_adheridas_pk;
       public            postgres    false    194    194            �
           2606    207642 (   entidades_emisoras entidades_emisoras_pk 
   CONSTRAINT     k   ALTER TABLE ONLY public.entidades_emisoras
    ADD CONSTRAINT entidades_emisoras_pk PRIMARY KEY (ent_cod);
 R   ALTER TABLE ONLY public.entidades_emisoras DROP CONSTRAINT entidades_emisoras_pk;
       public            postgres    false    195            �
           2606    207644 !   equipos_trabajos equi_trabajos_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.equipos_trabajos
    ADD CONSTRAINT equi_trabajos_pk PRIMARY KEY (equi_cod, fun_cod, ord_trab_cod, item_cod);
 K   ALTER TABLE ONLY public.equipos_trabajos DROP CONSTRAINT equi_trabajos_pk;
       public            postgres    false    196    196    196    196            �
           2606    207646     especialidades especialidades_pk 
   CONSTRAINT     c   ALTER TABLE ONLY public.especialidades
    ADD CONSTRAINT especialidades_pk PRIMARY KEY (esp_cod);
 J   ALTER TABLE ONLY public.especialidades DROP CONSTRAINT especialidades_pk;
       public            postgres    false    197            �
           2606    207648 "   estados_civiles estados_civiles_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.estados_civiles
    ADD CONSTRAINT estados_civiles_pk PRIMARY KEY (esta_cod);
 L   ALTER TABLE ONLY public.estados_civiles DROP CONSTRAINT estados_civiles_pk;
       public            postgres    false    198            .           2606    251472 *   facturas_varias_cab facturas_varias_cab_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.facturas_varias_cab
    ADD CONSTRAINT facturas_varias_cab_pk PRIMARY KEY (fact_var_cod);
 T   ALTER TABLE ONLY public.facturas_varias_cab DROP CONSTRAINT facturas_varias_cab_pk;
       public            postgres    false    298            0           2606    251505 *   facturas_varias_det facturas_varias_det_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.facturas_varias_det
    ADD CONSTRAINT facturas_varias_det_pk PRIMARY KEY (fact_var_cod);
 T   ALTER TABLE ONLY public.facturas_varias_det DROP CONSTRAINT facturas_varias_det_pk;
       public            postgres    false    299            �
           2606    207650    formas_cobros formas_cobros_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public.formas_cobros
    ADD CONSTRAINT formas_cobros_pk PRIMARY KEY (fcob_cod);
 H   ALTER TABLE ONLY public.formas_cobros DROP CONSTRAINT formas_cobros_pk;
       public            postgres    false    199            �
           2606    207652    funcionarios funcionarios_pk 
   CONSTRAINT     _   ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pk PRIMARY KEY (fun_cod);
 F   ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_pk;
       public            postgres    false    200            �
           2606    207654    generos generos_pk 
   CONSTRAINT     U   ALTER TABLE ONLY public.generos
    ADD CONSTRAINT generos_pk PRIMARY KEY (gen_cod);
 <   ALTER TABLE ONLY public.generos DROP CONSTRAINT generos_pk;
       public            postgres    false    201            �
           2606    207656    perfiles grupos_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.perfiles
    ADD CONSTRAINT grupos_pk PRIMARY KEY (perfil_cod);
 <   ALTER TABLE ONLY public.perfiles DROP CONSTRAINT grupos_pk;
       public            postgres    false    202            �
           2606    207658    items items_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pk PRIMARY KEY (item_cod);
 8   ALTER TABLE ONLY public.items DROP CONSTRAINT items_pk;
       public            postgres    false    203            ^           2606    383148    libro_compras libro_compras_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public.libro_compras
    ADD CONSTRAINT libro_compras_pk PRIMARY KEY (comp_cod);
 H   ALTER TABLE ONLY public.libro_compras DROP CONSTRAINT libro_compras_pk;
       public            postgres    false    341            �
           2606    207662    libro_ventas libro_ventas_pk 
   CONSTRAINT     n   ALTER TABLE ONLY public.libro_ventas
    ADD CONSTRAINT libro_ventas_pk PRIMARY KEY (libro_ven_cod, ven_cod);
 F   ALTER TABLE ONLY public.libro_ventas DROP CONSTRAINT libro_ventas_pk;
       public            postgres    false    204    204            �
           2606    207664     marca_tarjetas marca_tarjetas_pk 
   CONSTRAINT     h   ALTER TABLE ONLY public.marca_tarjetas
    ADD CONSTRAINT marca_tarjetas_pk PRIMARY KEY (mar_tarj_cod);
 J   ALTER TABLE ONLY public.marca_tarjetas DROP CONSTRAINT marca_tarjetas_pk;
       public            postgres    false    205            "           2606    208588    marcas_items marcas_items_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.marcas_items
    ADD CONSTRAINT marcas_items_pk PRIMARY KEY (item_cod, mar_cod);
 F   ALTER TABLE ONLY public.marcas_items DROP CONSTRAINT marcas_items_pk;
       public            postgres    false    276    276            �
           2606    207666    marcas marcas_pk 
   CONSTRAINT     S   ALTER TABLE ONLY public.marcas
    ADD CONSTRAINT marcas_pk PRIMARY KEY (mar_cod);
 :   ALTER TABLE ONLY public.marcas DROP CONSTRAINT marcas_pk;
       public            postgres    false    206            �
           2606    207668    modulos modulos_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.modulos
    ADD CONSTRAINT modulos_pk PRIMARY KEY (mod_id);
 <   ALTER TABLE ONLY public.modulos DROP CONSTRAINT modulos_pk;
       public            postgres    false    207            �
           2606    207670     motivo_ajustes motivo_ajustes_pk 
   CONSTRAINT     c   ALTER TABLE ONLY public.motivo_ajustes
    ADD CONSTRAINT motivo_ajustes_pk PRIMARY KEY (mot_cod);
 J   ALTER TABLE ONLY public.motivo_ajustes DROP CONSTRAINT motivo_ajustes_pk;
       public            postgres    false    208            @           2606    267979 +   movimiento_bancario movimiento_bancarios_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.movimiento_bancario
    ADD CONSTRAINT movimiento_bancarios_pk PRIMARY KEY (ent_cod, cuenta_corriente_cod, movimiento_nro);
 U   ALTER TABLE ONLY public.movimiento_bancario DROP CONSTRAINT movimiento_bancarios_pk;
       public            postgres    false    307    307    307            �
           2606    207672    paises nacionalidades_pk 
   CONSTRAINT     \   ALTER TABLE ONLY public.paises
    ADD CONSTRAINT nacionalidades_pk PRIMARY KEY (pais_cod);
 B   ALTER TABLE ONLY public.paises DROP CONSTRAINT nacionalidades_pk;
       public            postgres    false    215            `           2606    391296    notas_com_cab notas_com_cab_pk 
   CONSTRAINT     p   ALTER TABLE ONLY public.notas_com_cab
    ADD CONSTRAINT notas_com_cab_pk PRIMARY KEY (nota_com_nro, comp_cod);
 H   ALTER TABLE ONLY public.notas_com_cab DROP CONSTRAINT notas_com_cab_pk;
       public            postgres    false    344    344            b           2606    391316    notas_com_det notas_com_det_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.notas_com_det
    ADD CONSTRAINT notas_com_det_pk PRIMARY KEY (nota_com_nro, comp_cod, dep_cod, item_cod, mar_cod);
 H   ALTER TABLE ONLY public.notas_com_det DROP CONSTRAINT notas_com_det_pk;
       public            postgres    false    345    345    345    345    345            f           2606    432291 .   notas_remisiones_cab notas_remisiones_cab_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.notas_remisiones_cab
    ADD CONSTRAINT notas_remisiones_cab_pkey PRIMARY KEY (nota_rem_cod);
 X   ALTER TABLE ONLY public.notas_remisiones_cab DROP CONSTRAINT notas_remisiones_cab_pkey;
       public            postgres    false    354            h           2606    432314 .   notas_remisiones_det notas_remisiones_det_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.notas_remisiones_det
    ADD CONSTRAINT notas_remisiones_det_pkey PRIMARY KEY (nota_rem_cod);
 X   ALTER TABLE ONLY public.notas_remisiones_det DROP CONSTRAINT notas_remisiones_det_pkey;
       public            postgres    false    355            d           2606    415927    notas_ven_cab notas_ven_cab_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.notas_ven_cab
    ADD CONSTRAINT notas_ven_cab_pk PRIMARY KEY (nota_ven_cod);
 H   ALTER TABLE ONLY public.notas_ven_cab DROP CONSTRAINT notas_ven_cab_pk;
       public            postgres    false    352            �
           2606    207682     ordcompras_cab ordcompras_cab_pk 
   CONSTRAINT     e   ALTER TABLE ONLY public.ordcompras_cab
    ADD CONSTRAINT ordcompras_cab_pk PRIMARY KEY (orden_nro);
 J   ALTER TABLE ONLY public.ordcompras_cab DROP CONSTRAINT ordcompras_cab_pk;
       public            postgres    false    209            �
           2606    208668     ordcompras_det ordcompras_det_pk 
   CONSTRAINT     x   ALTER TABLE ONLY public.ordcompras_det
    ADD CONSTRAINT ordcompras_det_pk PRIMARY KEY (orden_nro, item_cod, mar_cod);
 J   ALTER TABLE ONLY public.ordcompras_det DROP CONSTRAINT ordcompras_det_pk;
       public            postgres    false    210    210    210            4           2606    259660     orden_pago_cab orden_pago_cab_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.orden_pago_cab
    ADD CONSTRAINT orden_pago_cab_pk PRIMARY KEY (orden_pago_cod);
 J   ALTER TABLE ONLY public.orden_pago_cab DROP CONSTRAINT orden_pago_cab_pk;
       public            postgres    false    301            8           2606    259727 0   orden_pago_det_compras orden_pago_det_compras_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.orden_pago_det_compras
    ADD CONSTRAINT orden_pago_det_compras_pk PRIMARY KEY (orden_pago_cod, prov_cod, prov_timb_nro, nro_factura, ctas_pagar_nro);
 Z   ALTER TABLE ONLY public.orden_pago_det_compras DROP CONSTRAINT orden_pago_det_compras_pk;
       public            postgres    false    303    303    303    303    303            6           2606    259703 @   orden_pago_detalle_fact_varias orden_pago_detalle_fact_varias_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.orden_pago_detalle_fact_varias
    ADD CONSTRAINT orden_pago_detalle_fact_varias_pk PRIMARY KEY (fact_var_cod, prov_cod, cuentas_pagar_fact_var_nro);
 j   ALTER TABLE ONLY public.orden_pago_detalle_fact_varias DROP CONSTRAINT orden_pago_detalle_fact_varias_pk;
       public            postgres    false    302    302    302            �
           2606    207688 ,   ordenes_trabajos_cab ordenes_trabajos_cab_pk 
   CONSTRAINT     t   ALTER TABLE ONLY public.ordenes_trabajos_cab
    ADD CONSTRAINT ordenes_trabajos_cab_pk PRIMARY KEY (ord_trab_cod);
 V   ALTER TABLE ONLY public.ordenes_trabajos_cab DROP CONSTRAINT ordenes_trabajos_cab_pk;
       public            postgres    false    212            �
           2606    215238 ,   ordenes_trabajos_det ordenes_trabajos_det_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.ordenes_trabajos_det
    ADD CONSTRAINT ordenes_trabajos_det_pk PRIMARY KEY (ord_trab_cod, item_cod, fun_cod);
 V   ALTER TABLE ONLY public.ordenes_trabajos_det DROP CONSTRAINT ordenes_trabajos_det_pk;
       public            postgres    false    213    213    213            D           2606    268002 6   otros_cred_deb_bancarios otros_cred_deb_bancarios_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.otros_cred_deb_bancarios
    ADD CONSTRAINT otros_cred_deb_bancarios_pkey PRIMARY KEY (otro_deb_cred_ban_cod);
 `   ALTER TABLE ONLY public.otros_cred_deb_bancarios DROP CONSTRAINT otros_cred_deb_bancarios_pkey;
       public            postgres    false    309            �
           2606    207692    paginas paginas_pk 
   CONSTRAINT     \   ALTER TABLE ONLY public.paginas
    ADD CONSTRAINT paginas_pk PRIMARY KEY (pag_id, mod_id);
 <   ALTER TABLE ONLY public.paginas DROP CONSTRAINT paginas_pk;
       public            postgres    false    214    214            B           2606    267987    pago_cheques pago_cheques_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.pago_cheques
    ADD CONSTRAINT pago_cheques_pk PRIMARY KEY (orden_pago_cod, ent_cod, cuenta_corriente_cod, movimiento_nro);
 F   ALTER TABLE ONLY public.pago_cheques DROP CONSTRAINT pago_cheques_pk;
       public            postgres    false    308    308    308    308            �
           2606    207694    pedido_orden pedido_orden_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.pedido_orden
    ADD CONSTRAINT pedido_orden_pk PRIMARY KEY (ped_cod, orden_cod);
 F   ALTER TABLE ONLY public.pedido_orden DROP CONSTRAINT pedido_orden_pk;
       public            postgres    false    216    216            �
           2606    207696    pedidos_cab pedidos_cab_pk 
   CONSTRAINT     ]   ALTER TABLE ONLY public.pedidos_cab
    ADD CONSTRAINT pedidos_cab_pk PRIMARY KEY (ped_nro);
 D   ALTER TABLE ONLY public.pedidos_cab DROP CONSTRAINT pedidos_cab_pk;
       public            postgres    false    217            �
           2606    208641    pedidos_det pedidos_det_pk 
   CONSTRAINT     p   ALTER TABLE ONLY public.pedidos_det
    ADD CONSTRAINT pedidos_det_pk PRIMARY KEY (ped_nro, item_cod, mar_cod);
 D   ALTER TABLE ONLY public.pedidos_det DROP CONSTRAINT pedidos_det_pk;
       public            postgres    false    218    218    218            �
           2606    207700    pedidos_vcab pedidos_vcab_pk 
   CONSTRAINT     `   ALTER TABLE ONLY public.pedidos_vcab
    ADD CONSTRAINT pedidos_vcab_pk PRIMARY KEY (ped_vcod);
 F   ALTER TABLE ONLY public.pedidos_vcab DROP CONSTRAINT pedidos_vcab_pk;
       public            postgres    false    219            �
           2606    208657    pedidos_vdet pedidos_vdet_pk 
   CONSTRAINT     s   ALTER TABLE ONLY public.pedidos_vdet
    ADD CONSTRAINT pedidos_vdet_pk PRIMARY KEY (ped_vcod, item_cod, mar_cod);
 F   ALTER TABLE ONLY public.pedidos_vdet DROP CONSTRAINT pedidos_vdet_pk;
       public            postgres    false    220    220    220            �
           2606    207704    permisos permisos_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.permisos
    ADD CONSTRAINT permisos_pk PRIMARY KEY (pag_id, mod_id);
 >   ALTER TABLE ONLY public.permisos DROP CONSTRAINT permisos_pk;
       public            postgres    false    221    221            �
           2606    207706    personas personas_pk 
   CONSTRAINT     W   ALTER TABLE ONLY public.personas
    ADD CONSTRAINT personas_pk PRIMARY KEY (per_cod);
 >   ALTER TABLE ONLY public.personas DROP CONSTRAINT personas_pk;
       public            postgres    false    222            �
           2606    207708    presupuestos_cab presu_cod 
   CONSTRAINT     _   ALTER TABLE ONLY public.presupuestos_cab
    ADD CONSTRAINT presu_cod PRIMARY KEY (presu_cod);
 D   ALTER TABLE ONLY public.presupuestos_cab DROP CONSTRAINT presu_cod;
       public            postgres    false    223            &           2606    216945 0   presupuestos_det_items presupuestos_det_items_pk 
   CONSTRAINT     u   ALTER TABLE ONLY public.presupuestos_det_items
    ADD CONSTRAINT presupuestos_det_items_pk PRIMARY KEY (presu_cod);
 Z   ALTER TABLE ONLY public.presupuestos_det_items DROP CONSTRAINT presupuestos_det_items_pk;
       public            postgres    false    292            �
           2606    207710 .   presupuestos_det_servicios presupuestos_det_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.presupuestos_det_servicios
    ADD CONSTRAINT presupuestos_det_pk PRIMARY KEY (presu_cod, item_cod);
 X   ALTER TABLE ONLY public.presupuestos_det_servicios DROP CONSTRAINT presupuestos_det_pk;
       public            postgres    false    224    224            N           2606    358498 <   presupuestos_proveedores_cab presupuestos_proveedores_cab_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.presupuestos_proveedores_cab
    ADD CONSTRAINT presupuestos_proveedores_cab_pk PRIMARY KEY (pre_prov_cod, prov_cod, pre_prov_fecha);
 f   ALTER TABLE ONLY public.presupuestos_proveedores_cab DROP CONSTRAINT presupuestos_proveedores_cab_pk;
       public            postgres    false    323    323    323            P           2606    366677 <   presupuestos_proveedores_det presupuestos_proveedores_det_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.presupuestos_proveedores_det
    ADD CONSTRAINT presupuestos_proveedores_det_pk PRIMARY KEY (pre_prov_cod, prov_cod, pre_prov_fecha, item_cod, mar_cod);
 f   ALTER TABLE ONLY public.presupuestos_proveedores_det DROP CONSTRAINT presupuestos_proveedores_det_pk;
       public            postgres    false    324    324    324    324    324            �
           2606    207712    profesiones profesiones_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.profesiones
    ADD CONSTRAINT profesiones_pk PRIMARY KEY (prof_cod);
 D   ALTER TABLE ONLY public.profesiones DROP CONSTRAINT profesiones_pk;
       public            postgres    false    225            �
           2606    207714    promos_cab promos_cab_pk 
   CONSTRAINT     ]   ALTER TABLE ONLY public.promos_cab
    ADD CONSTRAINT promos_cab_pk PRIMARY KEY (promo_cod);
 B   ALTER TABLE ONLY public.promos_cab DROP CONSTRAINT promos_cab_pk;
       public            postgres    false    226            $           2606    268306 $   promos_det_items promos_det_items_pk 
   CONSTRAINT     |   ALTER TABLE ONLY public.promos_det_items
    ADD CONSTRAINT promos_det_items_pk PRIMARY KEY (promo_cod, item_cod, mar_cod);
 N   ALTER TABLE ONLY public.promos_det_items DROP CONSTRAINT promos_det_items_pk;
       public            postgres    false    290    290    290            �
           2606    215240 "   promos_det_servicios promos_det_pk 
   CONSTRAINT     q   ALTER TABLE ONLY public.promos_det_servicios
    ADD CONSTRAINT promos_det_pk PRIMARY KEY (promo_cod, item_cod);
 L   ALTER TABLE ONLY public.promos_det_servicios DROP CONSTRAINT promos_det_pk;
       public            postgres    false    227    227            �
           2606    216811 *   proveedor_timbrados proveedor_timbrados_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.proveedor_timbrados
    ADD CONSTRAINT proveedor_timbrados_pk PRIMARY KEY (prov_cod, prov_timb_nro);
 T   ALTER TABLE ONLY public.proveedor_timbrados DROP CONSTRAINT proveedor_timbrados_pk;
       public            postgres    false    228    228            �
           2606    207720    proveedores proveedores_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT proveedores_pk PRIMARY KEY (prov_cod);
 D   ALTER TABLE ONLY public.proveedores DROP CONSTRAINT proveedores_pk;
       public            postgres    false    229            �
           2606    268061 &   recaudaciones_dep recaudaciones_dep_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.recaudaciones_dep
    ADD CONSTRAINT recaudaciones_dep_pk PRIMARY KEY (recau_dep_cod, aper_cier_cod);
 P   ALTER TABLE ONLY public.recaudaciones_dep DROP CONSTRAINT recaudaciones_dep_pk;
       public            postgres    false    230    230            �
           2606    207724 $   reclamo_clientes reclamo_clientes_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.reclamo_clientes
    ADD CONSTRAINT reclamo_clientes_pk PRIMARY KEY (reclamo_cod, tipo_reclamo_cod);
 N   ALTER TABLE ONLY public.reclamo_clientes DROP CONSTRAINT reclamo_clientes_pk;
       public            postgres    false    231    231            J           2606    268100 ,   rendicion_fondo_fijo rendicion_fondo_fijo_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.rendicion_fondo_fijo
    ADD CONSTRAINT rendicion_fondo_fijo_pk PRIMARY KEY (asignacion_responsable_cod, rendicion_fondo_fijo_cod);
 V   ALTER TABLE ONLY public.rendicion_fondo_fijo DROP CONSTRAINT rendicion_fondo_fijo_pk;
       public            postgres    false    312    312            L           2606    268149 .   reposicion_fondo_fijo reposicion_fondo_fijo_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.reposicion_fondo_fijo
    ADD CONSTRAINT reposicion_fondo_fijo_pk PRIMARY KEY (reposicion_cod, asignacion_responsable_cod, rendicion_fondo_fijo_cod);
 X   ALTER TABLE ONLY public.reposicion_fondo_fijo DROP CONSTRAINT reposicion_fondo_fijo_pk;
       public            postgres    false    313    313    313            �
           2606    207726    reservas_cab reservas_cab_pk 
   CONSTRAINT     a   ALTER TABLE ONLY public.reservas_cab
    ADD CONSTRAINT reservas_cab_pk PRIMARY KEY (reser_cod);
 F   ALTER TABLE ONLY public.reservas_cab DROP CONSTRAINT reservas_cab_pk;
       public            postgres    false    232            �
           2606    215232    reservas_det reservas_det_pk 
   CONSTRAINT     t   ALTER TABLE ONLY public.reservas_det
    ADD CONSTRAINT reservas_det_pk PRIMARY KEY (reser_cod, fun_cod, item_cod);
 F   ALTER TABLE ONLY public.reservas_det DROP CONSTRAINT reservas_det_pk;
       public            postgres    false    233    233    233            *           2606    251437    rubros rubros_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.rubros
    ADD CONSTRAINT rubros_pkey PRIMARY KEY (rubro_cod);
 <   ALTER TABLE ONLY public.rubros DROP CONSTRAINT rubros_pkey;
       public            postgres    false    296            �
           2606    207730    servicios_cab servicios_cab_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public.servicios_cab
    ADD CONSTRAINT servicios_cab_pk PRIMARY KEY (serv_cod);
 H   ALTER TABLE ONLY public.servicios_cab DROP CONSTRAINT servicios_cab_pk;
       public            postgres    false    234            �
           2606    207732    servicios_det servicios_det_pk 
   CONSTRAINT     q   ALTER TABLE ONLY public.servicios_det
    ADD CONSTRAINT servicios_det_pk PRIMARY KEY (serv_cod, tipo_serv_cod);
 H   ALTER TABLE ONLY public.servicios_det DROP CONSTRAINT servicios_det_pk;
       public            postgres    false    235    235            �
           2606    207734    sesiones sesiones_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.sesiones
    ADD CONSTRAINT sesiones_pk PRIMARY KEY (sesion_cod);
 >   ALTER TABLE ONLY public.sesiones DROP CONSTRAINT sesiones_pk;
       public            postgres    false    236            �
           2606    208600    stock stock_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_pk PRIMARY KEY (dep_cod, item_cod, mar_cod);
 8   ALTER TABLE ONLY public.stock DROP CONSTRAINT stock_pk;
       public            postgres    false    237    237    237            �
           2606    207738    sucursales sucursales_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.sucursales
    ADD CONSTRAINT sucursales_pk PRIMARY KEY (suc_cod, emp_cod);
 B   ALTER TABLE ONLY public.sucursales DROP CONSTRAINT sucursales_pk;
       public            postgres    false    238    238            �
           2606    207740    timbrados timbrados_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.timbrados
    ADD CONSTRAINT timbrados_pk PRIMARY KEY (timb_cod);
 @   ALTER TABLE ONLY public.timbrados DROP CONSTRAINT timbrados_pk;
       public            postgres    false    239                        2606    207742    tipo_ajustes tipo_ajuste_cod_ok 
   CONSTRAINT     j   ALTER TABLE ONLY public.tipo_ajustes
    ADD CONSTRAINT tipo_ajuste_cod_ok PRIMARY KEY (tipo_ajuste_cod);
 I   ALTER TABLE ONLY public.tipo_ajustes DROP CONSTRAINT tipo_ajuste_cod_ok;
       public            postgres    false    240                       2606    207744    tipo_cheques tipo_cheques_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.tipo_cheques
    ADD CONSTRAINT tipo_cheques_pkey PRIMARY KEY (cheque_tipo_cod);
 H   ALTER TABLE ONLY public.tipo_cheques DROP CONSTRAINT tipo_cheques_pkey;
       public            postgres    false    241            ,           2606    251442 "   tipo_documentos tipo_documentos_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.tipo_documentos
    ADD CONSTRAINT tipo_documentos_pk PRIMARY KEY (tipo_doc_cod);
 L   ALTER TABLE ONLY public.tipo_documentos DROP CONSTRAINT tipo_documentos_pk;
       public            postgres    false    297                       2606    207746    tipo_facturas tipo_facturas_pk 
   CONSTRAINT     g   ALTER TABLE ONLY public.tipo_facturas
    ADD CONSTRAINT tipo_facturas_pk PRIMARY KEY (tipo_fact_cod);
 H   ALTER TABLE ONLY public.tipo_facturas DROP CONSTRAINT tipo_facturas_pk;
       public            postgres    false    242                       2606    207748    tipo_items tipo_items_pk 
   CONSTRAINT     a   ALTER TABLE ONLY public.tipo_items
    ADD CONSTRAINT tipo_items_pk PRIMARY KEY (tipo_item_cod);
 B   ALTER TABLE ONLY public.tipo_items DROP CONSTRAINT tipo_items_pk;
       public            postgres    false    244            
           2606    207750    tipo_personas tipo_personas_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.tipo_personas
    ADD CONSTRAINT tipo_personas_pk PRIMARY KEY (tipo_per_cod);
 H   ALTER TABLE ONLY public.tipo_personas DROP CONSTRAINT tipo_personas_pk;
       public            postgres    false    245                       2606    207752 *   tipo_reclamo_items tipo_reclamo_items_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.tipo_reclamo_items
    ADD CONSTRAINT tipo_reclamo_items_pkey PRIMARY KEY (tipo_recl_item_cod);
 T   ALTER TABLE ONLY public.tipo_reclamo_items DROP CONSTRAINT tipo_reclamo_items_pkey;
       public            postgres    false    246                       2606    207754    tipo_reclamos tipo_reclamos_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.tipo_reclamos
    ADD CONSTRAINT tipo_reclamos_pk PRIMARY KEY (tipo_reclamo_cod);
 H   ALTER TABLE ONLY public.tipo_reclamos DROP CONSTRAINT tipo_reclamos_pk;
       public            postgres    false    247                       2606    207756     tipo_servicios tipo_servicios_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.tipo_servicios
    ADD CONSTRAINT tipo_servicios_pk PRIMARY KEY (tipo_serv_cod);
 J   ALTER TABLE ONLY public.tipo_servicios DROP CONSTRAINT tipo_servicios_pk;
       public            postgres    false    248                       2606    207758 #   tipo_impuestos tipos_impuestos_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.tipo_impuestos
    ADD CONSTRAINT tipos_impuestos_pkey PRIMARY KEY (tipo_imp_cod);
 M   ALTER TABLE ONLY public.tipo_impuestos DROP CONSTRAINT tipos_impuestos_pkey;
       public            postgres    false    243            :           2606    259751    titulares titulares_pk 
   CONSTRAINT     ]   ALTER TABLE ONLY public.titulares
    ADD CONSTRAINT titulares_pk PRIMARY KEY (titular_cod);
 @   ALTER TABLE ONLY public.titulares DROP CONSTRAINT titulares_pk;
       public            postgres    false    304                       2606    207760 (   transferencias_cab transferencias_cab_pk 
   CONSTRAINT     m   ALTER TABLE ONLY public.transferencias_cab
    ADD CONSTRAINT transferencias_cab_pk PRIMARY KEY (trans_cod);
 R   ALTER TABLE ONLY public.transferencias_cab DROP CONSTRAINT transferencias_cab_pk;
       public            postgres    false    249                       2606    208674 (   transferencias_det transferencias_det_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.transferencias_det
    ADD CONSTRAINT transferencias_det_pk PRIMARY KEY (trans_cod, dep_origen, item_cod, mar_cod);
 R   ALTER TABLE ONLY public.transferencias_det DROP CONSTRAINT transferencias_det_pk;
       public            postgres    false    250    250    250    250                       2606    207764    usuarios usuarios_pk 
   CONSTRAINT     `   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pk PRIMARY KEY (usu_cod, fun_cod);
 >   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_pk;
       public            postgres    false    251    251                       2606    207766 &   vehiculos_marcas vehiculos_marcas_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.vehiculos_marcas
    ADD CONSTRAINT vehiculos_marcas_pkey PRIMARY KEY (veh_mar_cod);
 P   ALTER TABLE ONLY public.vehiculos_marcas DROP CONSTRAINT vehiculos_marcas_pkey;
       public            postgres    false    271                       2606    207768 (   vehiculos_modelos vehiculos_modelos_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.vehiculos_modelos
    ADD CONSTRAINT vehiculos_modelos_pkey PRIMARY KEY (veh_mod_cod);
 R   ALTER TABLE ONLY public.vehiculos_modelos DROP CONSTRAINT vehiculos_modelos_pkey;
       public            postgres    false    272                       2606    207770    vehiculos vehiculos_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.vehiculos
    ADD CONSTRAINT vehiculos_pk PRIMARY KEY (vehi_cod);
 @   ALTER TABLE ONLY public.vehiculos DROP CONSTRAINT vehiculos_pk;
       public            postgres    false    270                       2606    207772    ventas_cab ventas_cab_pk 
   CONSTRAINT     [   ALTER TABLE ONLY public.ventas_cab
    ADD CONSTRAINT ventas_cab_pk PRIMARY KEY (ven_cod);
 B   ALTER TABLE ONLY public.ventas_cab DROP CONSTRAINT ventas_cab_pk;
       public            postgres    false    274                        2606    301095 $   ventas_det_items ventas_det_items_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.ventas_det_items
    ADD CONSTRAINT ventas_det_items_pk PRIMARY KEY (ven_cod, dep_cod, item_cod, mar_cod);
 N   ALTER TABLE ONLY public.ventas_det_items DROP CONSTRAINT ventas_det_items_pk;
       public            postgres    false    275    275    275    275            (           2606    251418 ,   ventas_det_servicios ventas_det_servicios_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.ventas_det_servicios
    ADD CONSTRAINT ventas_det_servicios_pk PRIMARY KEY (ven_cod, item_cod);
 V   ALTER TABLE ONLY public.ventas_det_servicios DROP CONSTRAINT ventas_det_servicios_pk;
       public            postgres    false    295    295            M           2620    207775    transferencias_det ajus_trans    TRIGGER     ~   CREATE TRIGGER ajus_trans AFTER UPDATE ON public.transferencias_det FOR EACH ROW EXECUTE PROCEDURE public.ftrg_ajus_trans1();
 6   DROP TRIGGER ajus_trans ON public.transferencias_det;
       public          postgres    false    431    250            Q           2620    383091    agendas_cab validaragendas    TRIGGER     w   CREATE TRIGGER validaragendas BEFORE INSERT ON public.agendas_cab FOR EACH ROW EXECUTE PROCEDURE public.trg_agendas();
 3   DROP TRIGGER validaragendas ON public.agendas_cab;
       public          postgres    false    334    446            5           2620    207777    clientes validarclientes    TRIGGER        CREATE TRIGGER validarclientes BEFORE INSERT OR UPDATE ON public.clientes FOR EACH ROW EXECUTE PROCEDURE public.tg_clientes();
 1   DROP TRIGGER validarclientes ON public.clientes;
       public          postgres    false    418    183            1           2620    207782    bancos validarduplicado    TRIGGER        CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.bancos FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 0   DROP TRIGGER validarduplicado ON public.bancos;
       public          postgres    false    419    177            2           2620    207779    cargos validarduplicado    TRIGGER        CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.cargos FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 0   DROP TRIGGER validarduplicado ON public.cargos;
       public          postgres    false    419    179            3           2620    207807    ciudades validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.ciudades FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 2   DROP TRIGGER validarduplicado ON public.ciudades;
       public          postgres    false    419    181            4           2620    207783     clasificaciones validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.clasificaciones FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 9   DROP TRIGGER validarduplicado ON public.clasificaciones;
       public          postgres    false    419    182            6           2620    207785    depositos validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.depositos FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 3   DROP TRIGGER validarduplicado ON public.depositos;
       public          postgres    false    189    419            7           2620    207778    dias validarduplicado    TRIGGER     }   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.dias FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 .   DROP TRIGGER validarduplicado ON public.dias;
       public          postgres    false    419    192            8           2620    207780    empresas validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.empresas FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 2   DROP TRIGGER validarduplicado ON public.empresas;
       public          postgres    false    419    193            9           2620    207787 $   entidades_adheridas validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.entidades_adheridas FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 =   DROP TRIGGER validarduplicado ON public.entidades_adheridas;
       public          postgres    false    194    419            :           2620    207786 #   entidades_emisoras validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.entidades_emisoras FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 <   DROP TRIGGER validarduplicado ON public.entidades_emisoras;
       public          postgres    false    195    419            ;           2620    207789    especialidades validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.especialidades FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 8   DROP TRIGGER validarduplicado ON public.especialidades;
       public          postgres    false    419    197            <           2620    207784     estados_civiles validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.estados_civiles FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 9   DROP TRIGGER validarduplicado ON public.estados_civiles;
       public          postgres    false    198    419            =           2620    207795    formas_cobros validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.formas_cobros FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 7   DROP TRIGGER validarduplicado ON public.formas_cobros;
       public          postgres    false    419    199            >           2620    207792    funcionarios validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.funcionarios FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 6   DROP TRIGGER validarduplicado ON public.funcionarios;
       public          postgres    false    419    200            ?           2620    207796    generos validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.generos FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 1   DROP TRIGGER validarduplicado ON public.generos;
       public          postgres    false    201    419            @           2620    207797    items validarduplicado    TRIGGER     ~   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.items FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 /   DROP TRIGGER validarduplicado ON public.items;
       public          postgres    false    419    203            A           2620    207788    marca_tarjetas validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.marca_tarjetas FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 8   DROP TRIGGER validarduplicado ON public.marca_tarjetas;
       public          postgres    false    205    419            B           2620    207802    motivo_ajustes validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.motivo_ajustes FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 8   DROP TRIGGER validarduplicado ON public.motivo_ajustes;
       public          postgres    false    419    208            C           2620    207805    paises validarduplicado    TRIGGER        CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.paises FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 0   DROP TRIGGER validarduplicado ON public.paises;
       public          postgres    false    419    215            D           2620    207791    personas validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.personas FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 2   DROP TRIGGER validarduplicado ON public.personas;
       public          postgres    false    419    222            E           2620    207790    profesiones validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.profesiones FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 5   DROP TRIGGER validarduplicado ON public.profesiones;
       public          postgres    false    225    419            F           2620    207793    proveedores validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.proveedores FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 5   DROP TRIGGER validarduplicado ON public.proveedores;
       public          postgres    false    419    229            G           2620    207781    sucursales validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.sucursales FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 4   DROP TRIGGER validarduplicado ON public.sucursales;
       public          postgres    false    419    238            H           2620    207803    tipo_ajustes validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.tipo_ajustes FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 6   DROP TRIGGER validarduplicado ON public.tipo_ajustes;
       public          postgres    false    419    240            I           2620    207798    tipo_impuestos validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.tipo_impuestos FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 8   DROP TRIGGER validarduplicado ON public.tipo_impuestos;
       public          postgres    false    243    419            J           2620    207804    tipo_personas validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.tipo_personas FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 7   DROP TRIGGER validarduplicado ON public.tipo_personas;
       public          postgres    false    245    419            K           2620    207801 #   tipo_reclamo_items validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.tipo_reclamo_items FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 <   DROP TRIGGER validarduplicado ON public.tipo_reclamo_items;
       public          postgres    false    246    419            L           2620    207806    tipo_reclamos validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.tipo_reclamos FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 7   DROP TRIGGER validarduplicado ON public.tipo_reclamos;
       public          postgres    false    247    419            N           2620    207794    usuarios validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.usuarios FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 2   DROP TRIGGER validarduplicado ON public.usuarios;
       public          postgres    false    419    251            O           2620    207799 !   vehiculos_marcas validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.vehiculos_marcas FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 :   DROP TRIGGER validarduplicado ON public.vehiculos_marcas;
       public          postgres    false    271    419            P           2620    207800 "   vehiculos_modelos validarduplicado    TRIGGER     �   CREATE TRIGGER validarduplicado BEFORE INSERT OR UPDATE ON public.vehiculos_modelos FOR EACH ROW EXECUTE PROCEDURE public.tg_duplicado();
 ;   DROP TRIGGER validarduplicado ON public.vehiculos_modelos;
       public          postgres    false    419    272            i           2606    207808    agendas agendas_funcionarios    FK CONSTRAINT     �   ALTER TABLE ONLY public.agendas
    ADD CONSTRAINT agendas_funcionarios FOREIGN KEY (fun_agen) REFERENCES public.funcionarios(fun_cod);
 F   ALTER TABLE ONLY public.agendas DROP CONSTRAINT agendas_funcionarios;
       public          postgres    false    2738    171    200            m           2606    207813 &   ajustes_det ajustes_cab_ajustes_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ajustes_det
    ADD CONSTRAINT ajustes_cab_ajustes_det_fk FOREIGN KEY (ajus_cod) REFERENCES public.ajustes_cab(ajus_cod);
 P   ALTER TABLE ONLY public.ajustes_det DROP CONSTRAINT ajustes_cab_ajustes_det_fk;
       public          postgres    false    2682    173    172            t           2606    207818 $   arqueos aperturas_cierres_arqueos_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.arqueos
    ADD CONSTRAINT aperturas_cierres_arqueos_fk FOREIGN KEY (aper_cier_cod) REFERENCES public.aperturas_cierres(aper_cier_cod);
 N   ALTER TABLE ONLY public.arqueos DROP CONSTRAINT aperturas_cierres_arqueos_fk;
       public          postgres    false    2686    174    175                       2606    207823 *   cobros_cab aperturas_cierres_cobros_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cobros_cab
    ADD CONSTRAINT aperturas_cierres_cobros_cab_fk FOREIGN KEY (aper_cier_cod) REFERENCES public.aperturas_cierres(aper_cier_cod);
 T   ALTER TABLE ONLY public.cobros_cab DROP CONSTRAINT aperturas_cierres_cobros_cab_fk;
       public          postgres    false    184    174    2686            �           2606    207828 8   recaudaciones_dep aperturas_cierres_recaudaciones_dep_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.recaudaciones_dep
    ADD CONSTRAINT aperturas_cierres_recaudaciones_dep_fk FOREIGN KEY (aper_cier_cod) REFERENCES public.aperturas_cierres(aper_cier_cod);
 b   ALTER TABLE ONLY public.recaudaciones_dep DROP CONSTRAINT aperturas_cierres_recaudaciones_dep_fk;
       public          postgres    false    174    230    2686                       2606    268101 B   rendicion_fondo_fijo asignacion_fondo_fijo_rendicion_fondo_fijo_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.rendicion_fondo_fijo
    ADD CONSTRAINT asignacion_fondo_fijo_rendicion_fondo_fijo_fk FOREIGN KEY (asignacion_responsable_cod) REFERENCES public.asignacion_fondo_fijo(asignacion_responsable_cod);
 l   ALTER TABLE ONLY public.rendicion_fondo_fijo DROP CONSTRAINT asignacion_fondo_fijo_rendicion_fondo_fijo_fk;
       public          postgres    false    2886    310    312            �           2606    207838 &   cobros_cheques banco_cobros_cheques_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cobros_cheques
    ADD CONSTRAINT banco_cobros_cheques_fk FOREIGN KEY (banco_cod) REFERENCES public.bancos(banco_cod);
 P   ALTER TABLE ONLY public.cobros_cheques DROP CONSTRAINT banco_cobros_cheques_fk;
       public          postgres    false    177    185    2692            {           2606    207843    cheque bancos_cheques    FK CONSTRAINT     ~   ALTER TABLE ONLY public.cheque
    ADD CONSTRAINT bancos_cheques FOREIGN KEY (banco_cod) REFERENCES public.bancos(banco_cod);
 ?   ALTER TABLE ONLY public.cheque DROP CONSTRAINT bancos_cheques;
       public          postgres    false    177    180    2692                       2606    268024 3   asignacion_fondo_fijo caja_asignacion_fondo_fijo_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.asignacion_fondo_fijo
    ADD CONSTRAINT caja_asignacion_fondo_fijo_fk FOREIGN KEY (caja_cod) REFERENCES public.cajas(caja_cod);
 ]   ALTER TABLE ONLY public.asignacion_fondo_fijo DROP CONSTRAINT caja_asignacion_fondo_fijo_fk;
       public          postgres    false    2694    310    178            p           2606    207848 ,   aperturas_cierres cajas_aperturas_cierres_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.aperturas_cierres
    ADD CONSTRAINT cajas_aperturas_cierres_fk FOREIGN KEY (caja_cod) REFERENCES public.cajas(caja_cod);
 V   ALTER TABLE ONLY public.aperturas_cierres DROP CONSTRAINT cajas_aperturas_cierres_fk;
       public          postgres    false    178    2694    174            �           2606    207853 )   detalle_timbrados cajas_detalle_timbrados    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_timbrados
    ADD CONSTRAINT cajas_detalle_timbrados FOREIGN KEY (caja_cod) REFERENCES public.cajas(caja_cod);
 S   ALTER TABLE ONLY public.detalle_timbrados DROP CONSTRAINT cajas_detalle_timbrados;
       public          postgres    false    178    191    2694            �           2606    207858 #   funcionarios cargos_funcionarios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT cargos_funcionarios_fk FOREIGN KEY (car_cod) REFERENCES public.cargos(car_cod);
 M   ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT cargos_funcionarios_fk;
       public          postgres    false    2696    179    200            �           2606    366753 1   transferencias_cab choferes_transferencias_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.transferencias_cab
    ADD CONSTRAINT choferes_transferencias_cab_fk FOREIGN KEY (chofer_cod) REFERENCES public.choferes(chofer_cod);
 [   ALTER TABLE ONLY public.transferencias_cab DROP CONSTRAINT choferes_transferencias_cab_fk;
       public          postgres    false    332    2898    249            �           2606    207863    personas ciudades_personas_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.personas
    ADD CONSTRAINT ciudades_personas_fk FOREIGN KEY (ciu_cod) REFERENCES public.ciudades(ciu_cod);
 G   ALTER TABLE ONLY public.personas DROP CONSTRAINT ciudades_personas_fk;
       public          postgres    false    2700    222    181            u           2606    207873 5   avisos_recordatorios clientes_avisos_recordatorios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.avisos_recordatorios
    ADD CONSTRAINT clientes_avisos_recordatorios_fk FOREIGN KEY (cli_cod) REFERENCES public.clientes(cli_cod);
 _   ALTER TABLE ONLY public.avisos_recordatorios DROP CONSTRAINT clientes_avisos_recordatorios_fk;
       public          postgres    false    2704    183    176            +           2606    415928 '   notas_ven_cab clientes_notas_ven_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_ven_cab
    ADD CONSTRAINT clientes_notas_ven_cab_fk FOREIGN KEY (cli_cod) REFERENCES public.clientes(cli_cod);
 Q   ALTER TABLE ONLY public.notas_ven_cab DROP CONSTRAINT clientes_notas_ven_cab_fk;
       public          postgres    false    2704    352    183            �           2606    207883 -   ordenes_trabajos_cab clientes_ord_trab_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordenes_trabajos_cab
    ADD CONSTRAINT clientes_ord_trab_cab_fk FOREIGN KEY (cli_cod) REFERENCES public.clientes(cli_cod);
 W   ALTER TABLE ONLY public.ordenes_trabajos_cab DROP CONSTRAINT clientes_ord_trab_cab_fk;
       public          postgres    false    183    2704    212            �           2606    207888 %   pedidos_vcab clientes_pedidos_vcab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos_vcab
    ADD CONSTRAINT clientes_pedidos_vcab_fk FOREIGN KEY (cli_cod) REFERENCES public.clientes(cli_cod);
 O   ALTER TABLE ONLY public.pedidos_vcab DROP CONSTRAINT clientes_pedidos_vcab_fk;
       public          postgres    false    219    183    2704            �           2606    207893 -   presupuestos_cab clientes_presupuestos_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.presupuestos_cab
    ADD CONSTRAINT clientes_presupuestos_cab_fk FOREIGN KEY (cli_cod) REFERENCES public.clientes(cli_cod);
 W   ALTER TABLE ONLY public.presupuestos_cab DROP CONSTRAINT clientes_presupuestos_cab_fk;
       public          postgres    false    183    2704    223            �           2606    207898 -   reclamo_clientes clientes_reclamo_clientes_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.reclamo_clientes
    ADD CONSTRAINT clientes_reclamo_clientes_fk FOREIGN KEY (cli_cod) REFERENCES public.clientes(cli_cod);
 W   ALTER TABLE ONLY public.reclamo_clientes DROP CONSTRAINT clientes_reclamo_clientes_fk;
       public          postgres    false    2704    231    183            �           2606    207903 %   reservas_cab clientes_reservas_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservas_cab
    ADD CONSTRAINT clientes_reservas_cab_fk FOREIGN KEY (cli_cod) REFERENCES public.clientes(cli_cod);
 O   ALTER TABLE ONLY public.reservas_cab DROP CONSTRAINT clientes_reservas_cab_fk;
       public          postgres    false    183    232    2704            �           2606    207908 '   servicios_cab clientes_servicios_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.servicios_cab
    ADD CONSTRAINT clientes_servicios_cab_fk FOREIGN KEY (cli_cod) REFERENCES public.clientes(cli_cod);
 Q   ALTER TABLE ONLY public.servicios_cab DROP CONSTRAINT clientes_servicios_cab_fk;
       public          postgres    false    234    183    2704            �           2606    207913 !   ventas_cab clientes_ventas_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ventas_cab
    ADD CONSTRAINT clientes_ventas_cab_fk FOREIGN KEY (cli_cod) REFERENCES public.clientes(cli_cod);
 K   ALTER TABLE ONLY public.ventas_cab DROP CONSTRAINT clientes_ventas_cab_fk;
       public          postgres    false    183    2704    274            �           2606    207918 (   cobros_cheques cobros_cab_cobros_cheques    FK CONSTRAINT     �   ALTER TABLE ONLY public.cobros_cheques
    ADD CONSTRAINT cobros_cab_cobros_cheques FOREIGN KEY (cobro_cod) REFERENCES public.cobros_cab(cobro_cod);
 R   ALTER TABLE ONLY public.cobros_cheques DROP CONSTRAINT cobros_cab_cobros_cheques;
       public          postgres    false    184    185    2706            �           2606    207923 #   cobros_det cobros_cab_cobros_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cobros_det
    ADD CONSTRAINT cobros_cab_cobros_det_fk FOREIGN KEY (cobro_cod) REFERENCES public.cobros_cab(cobro_cod);
 M   ALTER TABLE ONLY public.cobros_det DROP CONSTRAINT cobros_cab_cobros_det_fk;
       public          postgres    false    2706    184    186            �           2606    207928 -   cobros_tarjetas cobros_cab_cobros_tarjetas_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cobros_tarjetas
    ADD CONSTRAINT cobros_cab_cobros_tarjetas_fk FOREIGN KEY (cobro_cod) REFERENCES public.cobros_cab(cobro_cod);
 W   ALTER TABLE ONLY public.cobros_tarjetas DROP CONSTRAINT cobros_cab_cobros_tarjetas_fk;
       public          postgres    false    187    2706    184                        2606    383139 *   cuentas_pagar compras_cab_cuentas_pagar_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cuentas_pagar
    ADD CONSTRAINT compras_cab_cuentas_pagar_fk FOREIGN KEY (comp_cod) REFERENCES public.compras_cab(comp_cod);
 T   ALTER TABLE ONLY public.cuentas_pagar DROP CONSTRAINT compras_cab_cuentas_pagar_fk;
       public          postgres    false    340    338    2904            !           2606    383149 *   libro_compras compras_cab_libro_compras_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.libro_compras
    ADD CONSTRAINT compras_cab_libro_compras_fk FOREIGN KEY (comp_cod) REFERENCES public.compras_cab(comp_cod);
 T   ALTER TABLE ONLY public.libro_compras DROP CONSTRAINT compras_cab_libro_compras_fk;
       public          postgres    false    2904    341    338            $           2606    391297 *   notas_com_cab compras_cab_notas_compras_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_com_cab
    ADD CONSTRAINT compras_cab_notas_compras_fk FOREIGN KEY (comp_cod) REFERENCES public.compras_cab(comp_cod);
 T   ALTER TABLE ONLY public.notas_com_cab DROP CONSTRAINT compras_cab_notas_compras_fk;
       public          postgres    false    344    338    2904                       2606    383124 &   compras_det compras_det_compras_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.compras_det
    ADD CONSTRAINT compras_det_compras_cab_fk FOREIGN KEY (comp_cod) REFERENCES public.compras_cab(comp_cod);
 P   ALTER TABLE ONLY public.compras_det DROP CONSTRAINT compras_det_compras_cab_fk;
       public          postgres    false    338    2904    339                       2606    383129     compras_det compras_det_stock_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.compras_det
    ADD CONSTRAINT compras_det_stock_fk FOREIGN KEY (mar_cod, item_cod, dep_cod) REFERENCES public.stock(mar_cod, item_cod, dep_cod);
 J   ALTER TABLE ONLY public.compras_det DROP CONSTRAINT compras_det_stock_fk;
       public          postgres    false    2810    237    237    339    339    339    237            �           2606    207958 '   cobros_det cuentas_cobrar_cobros_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cobros_det
    ADD CONSTRAINT cuentas_cobrar_cobros_det_fk FOREIGN KEY (ctas_cobrar_nro, ven_cod) REFERENCES public.cuentas_cobrar(ctas_cobrar_nro, ven_cod);
 Q   ALTER TABLE ONLY public.cobros_det DROP CONSTRAINT cuentas_cobrar_cobros_det_fk;
       public          postgres    false    188    2714    188    186    186                       2606    267973 =   movimiento_bancario cuentas_corientes_movimiento_bancarios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.movimiento_bancario
    ADD CONSTRAINT cuentas_corientes_movimiento_bancarios_fk FOREIGN KEY (ent_cod, cuenta_corriente_cod) REFERENCES public.cuentas_corrientes(ent_cod, cuenta_corriente_cod);
 g   ALTER TABLE ONLY public.movimiento_bancario DROP CONSTRAINT cuentas_corientes_movimiento_bancarios_fk;
       public          postgres    false    307    307    305    305    2876            �           2606    259709 [   orden_pago_detalle_fact_varias cuentas_pagar_fact_varias_orden_pago_detalle_fact_vairias_fk    FK CONSTRAINT     )  ALTER TABLE ONLY public.orden_pago_detalle_fact_varias
    ADD CONSTRAINT cuentas_pagar_fact_varias_orden_pago_detalle_fact_vairias_fk FOREIGN KEY (fact_var_cod, prov_cod, cuentas_pagar_fact_var_nro) REFERENCES public.cuentas_pagar_fact_varias(fact_var_cod, prov_cod, cuentas_pagar_fact_var_nro);
 �   ALTER TABLE ONLY public.orden_pago_detalle_fact_varias DROP CONSTRAINT cuentas_pagar_fact_varias_orden_pago_detalle_fact_vairias_fk;
       public          postgres    false    302    300    300    300    2866    302    302            �           2606    207963    stock depositos_stock_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.stock
    ADD CONSTRAINT depositos_stock_fk FOREIGN KEY (dep_cod) REFERENCES public.depositos(dep_cod);
 B   ALTER TABLE ONLY public.stock DROP CONSTRAINT depositos_stock_fk;
       public          postgres    false    237    189    2716                       2606    383075    agendas_det dias_agendas_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.agendas_det
    ADD CONSTRAINT dias_agendas_det_fk FOREIGN KEY (dias_cod) REFERENCES public.dias(dias_cod);
 I   ALTER TABLE ONLY public.agendas_det DROP CONSTRAINT dias_agendas_det_fk;
       public          postgres    false    2722    335    192            �           2606    207968 !   sucursales empresas_sucursales_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sucursales
    ADD CONSTRAINT empresas_sucursales_fk FOREIGN KEY (emp_cod) REFERENCES public.empresas(emp_cod);
 K   ALTER TABLE ONLY public.sucursales DROP CONSTRAINT empresas_sucursales_fk;
       public          postgres    false    2724    238    193            �           2606    207973 6   cobros_tarjetas entidades_adheridas_cobros_tarjetas_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cobros_tarjetas
    ADD CONSTRAINT entidades_adheridas_cobros_tarjetas_fk FOREIGN KEY (ent_ad_cod, ent_cod) REFERENCES public.entidades_adheridas(ent_ad_cod, ent_cod);
 `   ALTER TABLE ONLY public.cobros_tarjetas DROP CONSTRAINT entidades_adheridas_cobros_tarjetas_fk;
       public          postgres    false    194    194    187    187    2726                        2606    259768 ;   cuentas_corrientes entidades_emisoras_cuentas_corrientes_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cuentas_corrientes
    ADD CONSTRAINT entidades_emisoras_cuentas_corrientes_fk FOREIGN KEY (ent_cod) REFERENCES public.entidades_emisoras(ent_cod);
 e   ALTER TABLE ONLY public.cuentas_corrientes DROP CONSTRAINT entidades_emisoras_cuentas_corrientes_fk;
       public          postgres    false    2728    195    305            �           2606    207978 =   entidades_adheridas entidades_emisoras_entidades_adheridas_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.entidades_adheridas
    ADD CONSTRAINT entidades_emisoras_entidades_adheridas_fk FOREIGN KEY (ent_cod) REFERENCES public.entidades_emisoras(ent_cod);
 g   ALTER TABLE ONLY public.entidades_adheridas DROP CONSTRAINT entidades_emisoras_entidades_adheridas_fk;
       public          postgres    false    2728    195    194            �           2606    207988 ,   equipos_trabajos equipos_trabajos_item_codfk    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipos_trabajos
    ADD CONSTRAINT equipos_trabajos_item_codfk FOREIGN KEY (item_cod) REFERENCES public.items(item_cod);
 V   ALTER TABLE ONLY public.equipos_trabajos DROP CONSTRAINT equipos_trabajos_item_codfk;
       public          postgres    false    2744    196    203            �           2606    207993 +   funcionarios especialidades_funcionarios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT especialidades_funcionarios_fk FOREIGN KEY (esp_cod) REFERENCES public.especialidades(esp_cod);
 U   ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT especialidades_funcionarios_fk;
       public          postgres    false    2732    200    197            �           2606    207998 /   tipo_servicios especialidades_tipo_servicios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.tipo_servicios
    ADD CONSTRAINT especialidades_tipo_servicios_fk FOREIGN KEY (esp_cod) REFERENCES public.especialidades(esp_cod);
 Y   ALTER TABLE ONLY public.tipo_servicios DROP CONSTRAINT especialidades_tipo_servicios_fk;
       public          postgres    false    197    248    2732            �           2606    251529 J   cuentas_pagar_fact_varias facturas_varias_cab_cuentas_pagar_fact_varias_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cuentas_pagar_fact_varias
    ADD CONSTRAINT facturas_varias_cab_cuentas_pagar_fact_varias_fk FOREIGN KEY (fact_var_cod) REFERENCES public.facturas_varias_cab(fact_var_cod);
 t   ALTER TABLE ONLY public.cuentas_pagar_fact_varias DROP CONSTRAINT facturas_varias_cab_cuentas_pagar_fact_varias_fk;
       public          postgres    false    300    298    2862            �           2606    358427 &   cobros_cab formas_cobros_cobros_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cobros_cab
    ADD CONSTRAINT formas_cobros_cobros_cab_fk FOREIGN KEY (fcob_cod) REFERENCES public.formas_cobros(fcob_cod);
 P   ALTER TABLE ONLY public.cobros_cab DROP CONSTRAINT formas_cobros_cobros_cab_fk;
       public          postgres    false    199    184    2736            �           2606    259666 +   orden_pago_cab formas_cobros_orden_pago_cab    FK CONSTRAINT     �   ALTER TABLE ONLY public.orden_pago_cab
    ADD CONSTRAINT formas_cobros_orden_pago_cab FOREIGN KEY (fcob_cod) REFERENCES public.formas_cobros(fcob_cod);
 U   ALTER TABLE ONLY public.orden_pago_cab DROP CONSTRAINT formas_cobros_orden_pago_cab;
       public          postgres    false    2736    301    199                       2606    383055 '   agendas_cab funcionarios_agendas_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.agendas_cab
    ADD CONSTRAINT funcionarios_agendas_cab_fk FOREIGN KEY (fun_cod) REFERENCES public.funcionarios(fun_cod);
 Q   ALTER TABLE ONLY public.agendas_cab DROP CONSTRAINT funcionarios_agendas_cab_fk;
       public          postgres    false    2738    334    200            �           2606    208008 .   equipos_trabajos funcionarios_equi_trabajos_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipos_trabajos
    ADD CONSTRAINT funcionarios_equi_trabajos_fk FOREIGN KEY (fun_cod) REFERENCES public.funcionarios(fun_cod);
 X   ALTER TABLE ONLY public.equipos_trabajos DROP CONSTRAINT funcionarios_equi_trabajos_fk;
       public          postgres    false    196    2738    200            �           2606    208013 5   ordenes_trabajos_det funcionarios_ordenes_trabajos_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordenes_trabajos_det
    ADD CONSTRAINT funcionarios_ordenes_trabajos_fk FOREIGN KEY (fun_cod) REFERENCES public.funcionarios(fun_cod);
 _   ALTER TABLE ONLY public.ordenes_trabajos_det DROP CONSTRAINT funcionarios_ordenes_trabajos_fk;
       public          postgres    false    200    213    2738            �           2606    208018 !   usuarios funcionarios_usuarios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT funcionarios_usuarios_fk FOREIGN KEY (fun_cod) REFERENCES public.funcionarios(fun_cod);
 K   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT funcionarios_usuarios_fk;
       public          postgres    false    251    2738    200            �           2606    208023    personas generos_personas_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.personas
    ADD CONSTRAINT generos_personas_fk FOREIGN KEY (gen_cod) REFERENCES public.generos(gen_cod);
 F   ALTER TABLE ONLY public.personas DROP CONSTRAINT generos_personas_fk;
       public          postgres    false    222    201    2740            �           2606    208028    permisos grupos_permisos_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.permisos
    ADD CONSTRAINT grupos_permisos_fk FOREIGN KEY (gru_id) REFERENCES public.perfiles(perfil_cod);
 E   ALTER TABLE ONLY public.permisos DROP CONSTRAINT grupos_permisos_fk;
       public          postgres    false    221    202    2742            �           2606    208033    usuarios grupos_usuarios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT grupos_usuarios_fk FOREIGN KEY (perfil_cod) REFERENCES public.perfiles(perfil_cod);
 E   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT grupos_usuarios_fk;
       public          postgres    false    202    251    2742            v           2606    208038 2   avisos_recordatorios items_avisos_recordatorios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.avisos_recordatorios
    ADD CONSTRAINT items_avisos_recordatorios_fk FOREIGN KEY (item_cod) REFERENCES public.items(item_cod);
 \   ALTER TABLE ONLY public.avisos_recordatorios DROP CONSTRAINT items_avisos_recordatorios_fk;
       public          postgres    false    2744    203    176            �           2606    208043    descuentos items_descuentos_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.descuentos
    ADD CONSTRAINT items_descuentos_fk FOREIGN KEY (item_cod) REFERENCES public.items(item_cod);
 H   ALTER TABLE ONLY public.descuentos DROP CONSTRAINT items_descuentos_fk;
       public          postgres    false    2744    190    203            �           2606    208594 "   marcas_items items_marcas_items_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.marcas_items
    ADD CONSTRAINT items_marcas_items_fk FOREIGN KEY (item_cod) REFERENCES public.items(item_cod);
 L   ALTER TABLE ONLY public.marcas_items DROP CONSTRAINT items_marcas_items_fk;
       public          postgres    false    276    203    2744            �           2606    208053 2   ordenes_trabajos_det items_ordenes_trabajos_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordenes_trabajos_det
    ADD CONSTRAINT items_ordenes_trabajos_det_fk FOREIGN KEY (item_cod) REFERENCES public.items(item_cod);
 \   ALTER TABLE ONLY public.ordenes_trabajos_det DROP CONSTRAINT items_ordenes_trabajos_det_fk;
       public          postgres    false    2744    213    203            �           2606    208068 4   presupuestos_det_servicios items_presupuestos_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.presupuestos_det_servicios
    ADD CONSTRAINT items_presupuestos_det_fk FOREIGN KEY (item_cod) REFERENCES public.items(item_cod);
 ^   ALTER TABLE ONLY public.presupuestos_det_servicios DROP CONSTRAINT items_presupuestos_det_fk;
       public          postgres    false    203    2744    224            �           2606    215241 (   promos_det_servicios items_promos_det_pk    FK CONSTRAINT     �   ALTER TABLE ONLY public.promos_det_servicios
    ADD CONSTRAINT items_promos_det_pk FOREIGN KEY (item_cod) REFERENCES public.items(item_cod);
 R   ALTER TABLE ONLY public.promos_det_servicios DROP CONSTRAINT items_promos_det_pk;
       public          postgres    false    227    2744    203            �           2606    208073 "   reservas_det items_reservas_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservas_det
    ADD CONSTRAINT items_reservas_det_fk FOREIGN KEY (item_cod) REFERENCES public.items(item_cod);
 L   ALTER TABLE ONLY public.reservas_det DROP CONSTRAINT items_reservas_det_fk;
       public          postgres    false    203    2744    233            �           2606    251424 /   ventas_det_servicios items_ventas_det_servicios    FK CONSTRAINT     �   ALTER TABLE ONLY public.ventas_det_servicios
    ADD CONSTRAINT items_ventas_det_servicios FOREIGN KEY (item_cod) REFERENCES public.items(item_cod);
 Y   ALTER TABLE ONLY public.ventas_det_servicios DROP CONSTRAINT items_ventas_det_servicios;
       public          postgres    false    295    203    2744            �           2606    208083 1   cobros_tarjetas marca_tarjetas_cobros_tarjetas_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cobros_tarjetas
    ADD CONSTRAINT marca_tarjetas_cobros_tarjetas_fk FOREIGN KEY (mar_tarj_cod) REFERENCES public.marca_tarjetas(mar_tarj_cod);
 [   ALTER TABLE ONLY public.cobros_tarjetas DROP CONSTRAINT marca_tarjetas_cobros_tarjetas_fk;
       public          postgres    false    2748    205    187            �           2606    208088 9   entidades_adheridas marca_tarjetas_entidades_adheridas_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.entidades_adheridas
    ADD CONSTRAINT marca_tarjetas_entidades_adheridas_fk FOREIGN KEY (mar_tarj_cod) REFERENCES public.marca_tarjetas(mar_tarj_cod);
 c   ALTER TABLE ONLY public.entidades_adheridas DROP CONSTRAINT marca_tarjetas_entidades_adheridas_fk;
       public          postgres    false    2748    194    205            0           2606    432315 9   notas_remisiones_det marcas_items_notas_remisiones_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_remisiones_det
    ADD CONSTRAINT marcas_items_notas_remisiones_det_fk FOREIGN KEY (item_cod, mar_cod) REFERENCES public.marcas_items(item_cod, mar_cod);
 c   ALTER TABLE ONLY public.notas_remisiones_det DROP CONSTRAINT marcas_items_notas_remisiones_det_fk;
       public          postgres    false    2850    355    355    276    276            �           2606    208662 -   ordcompras_det marcas_items_ordcompras_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordcompras_det
    ADD CONSTRAINT marcas_items_ordcompras_det_fk FOREIGN KEY (item_cod, mar_cod) REFERENCES public.marcas_items(item_cod, mar_cod);
 W   ALTER TABLE ONLY public.ordcompras_det DROP CONSTRAINT marcas_items_ordcompras_det_fk;
       public          postgres    false    276    210    210    2850    276            �           2606    208642 '   pedidos_det marcas_items_pedidos_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos_det
    ADD CONSTRAINT marcas_items_pedidos_det_fk FOREIGN KEY (item_cod, mar_cod) REFERENCES public.marcas_items(item_cod, mar_cod);
 Q   ALTER TABLE ONLY public.pedidos_det DROP CONSTRAINT marcas_items_pedidos_det_fk;
       public          postgres    false    276    218    218    2850    276            �           2606    208651 (   pedidos_vdet marcas_items_pedidos_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos_vdet
    ADD CONSTRAINT marcas_items_pedidos_det_fk FOREIGN KEY (item_cod, mar_cod) REFERENCES public.marcas_items(item_cod, mar_cod);
 R   ALTER TABLE ONLY public.pedidos_vdet DROP CONSTRAINT marcas_items_pedidos_det_fk;
       public          postgres    false    220    2850    276    276    220            �           2606    216946 =   presupuestos_det_items marcas_items_presupuestos_det_items_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.presupuestos_det_items
    ADD CONSTRAINT marcas_items_presupuestos_det_items_fk FOREIGN KEY (item_cod, mar_cod) REFERENCES public.marcas_items(item_cod, mar_cod);
 g   ALTER TABLE ONLY public.presupuestos_det_items DROP CONSTRAINT marcas_items_presupuestos_det_items_fk;
       public          postgres    false    276    292    292    276    2850                       2606    358527 I   presupuestos_proveedores_det marcas_items_presupuestos_proveedores_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.presupuestos_proveedores_det
    ADD CONSTRAINT marcas_items_presupuestos_proveedores_det_fk FOREIGN KEY (item_cod, mar_cod) REFERENCES public.marcas_items(item_cod, mar_cod);
 s   ALTER TABLE ONLY public.presupuestos_proveedores_det DROP CONSTRAINT marcas_items_presupuestos_proveedores_det_fk;
       public          postgres    false    276    324    324    276    2850            �           2606    216919 1   promos_det_items marcas_items_promos_det_items_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.promos_det_items
    ADD CONSTRAINT marcas_items_promos_det_items_fk FOREIGN KEY (item_cod, mar_cod) REFERENCES public.marcas_items(item_cod, mar_cod);
 [   ALTER TABLE ONLY public.promos_det_items DROP CONSTRAINT marcas_items_promos_det_items_fk;
       public          postgres    false    2850    290    290    276    276            �           2606    208601    stock marcas_items_stock_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.stock
    ADD CONSTRAINT marcas_items_stock_fk FOREIGN KEY (item_cod, mar_cod) REFERENCES public.marcas_items(item_cod, mar_cod);
 E   ALTER TABLE ONLY public.stock DROP CONSTRAINT marcas_items_stock_fk;
       public          postgres    false    276    2850    276    237    237            �           2606    208589 #   marcas_items marcas_marcas_items_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.marcas_items
    ADD CONSTRAINT marcas_marcas_items_fk FOREIGN KEY (mar_cod) REFERENCES public.marcas(mar_cod);
 M   ALTER TABLE ONLY public.marcas_items DROP CONSTRAINT marcas_marcas_items_fk;
       public          postgres    false    276    206    2750            �           2606    208098    vehiculos marcas_vehiculos    FK CONSTRAINT     �   ALTER TABLE ONLY public.vehiculos
    ADD CONSTRAINT marcas_vehiculos FOREIGN KEY (veh_mar_cod) REFERENCES public.vehiculos_marcas(veh_mar_cod);
 D   ALTER TABLE ONLY public.vehiculos DROP CONSTRAINT marcas_vehiculos;
       public          postgres    false    2842    270    271            �           2606    208103    vehiculos modelos_vehiculos    FK CONSTRAINT     �   ALTER TABLE ONLY public.vehiculos
    ADD CONSTRAINT modelos_vehiculos FOREIGN KEY (veh_mod_cod) REFERENCES public.vehiculos_modelos(veh_mod_cod);
 E   ALTER TABLE ONLY public.vehiculos DROP CONSTRAINT modelos_vehiculos;
       public          postgres    false    270    272    2844            �           2606    208108    paginas modulos_paginas_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.paginas
    ADD CONSTRAINT modulos_paginas_fk FOREIGN KEY (mod_id) REFERENCES public.modulos(mod_id);
 D   ALTER TABLE ONLY public.paginas DROP CONSTRAINT modulos_paginas_fk;
       public          postgres    false    207    2752    214            o           2606    301071 )   ajustes_det motivo_ajustes_ajustes_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ajustes_det
    ADD CONSTRAINT motivo_ajustes_ajustes_det_fk FOREIGN KEY (mot_cod) REFERENCES public.motivo_ajustes(mot_cod);
 S   ALTER TABLE ONLY public.ajustes_det DROP CONSTRAINT motivo_ajustes_ajustes_det_fk;
       public          postgres    false    173    2754    208            
           2606    268070 6   boleta_deposito movimiento_bancario_boleta_deposito_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.boleta_deposito
    ADD CONSTRAINT movimiento_bancario_boleta_deposito_fk FOREIGN KEY (ent_cod, cuenta_corriente_cod, movimiento_nro) REFERENCES public.movimiento_bancario(ent_cod, cuenta_corriente_cod, movimiento_nro);
 `   ALTER TABLE ONLY public.boleta_deposito DROP CONSTRAINT movimiento_bancario_boleta_deposito_fk;
       public          postgres    false    311    307    311    311    307    307    2880                       2606    267993 0   pago_cheques movimiento_bancario_pago_cheques_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.pago_cheques
    ADD CONSTRAINT movimiento_bancario_pago_cheques_fk FOREIGN KEY (ent_cod, cuenta_corriente_cod, movimiento_nro) REFERENCES public.movimiento_bancario(ent_cod, cuenta_corriente_cod, movimiento_nro);
 Z   ALTER TABLE ONLY public.pago_cheques DROP CONSTRAINT movimiento_bancario_pago_cheques_fk;
       public          postgres    false    308    2880    307    307    307    308    308            &           2606    391317 ,   notas_com_det notas_com_cab_notas_com_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_com_det
    ADD CONSTRAINT notas_com_cab_notas_com_det_fk FOREIGN KEY (comp_cod, nota_com_nro) REFERENCES public.notas_com_cab(comp_cod, nota_com_nro);
 V   ALTER TABLE ONLY public.notas_com_det DROP CONSTRAINT notas_com_cab_notas_com_det_fk;
       public          postgres    false    345    345    2912    344    344            /           2606    432320 A   notas_remisiones_det notas_remisiones_cab_notas_remisiones_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_remisiones_det
    ADD CONSTRAINT notas_remisiones_cab_notas_remisiones_det_fk FOREIGN KEY (nota_rem_cod) REFERENCES public.notas_remisiones_cab(nota_rem_cod);
 k   ALTER TABLE ONLY public.notas_remisiones_det DROP CONSTRAINT notas_remisiones_cab_notas_remisiones_det_fk;
       public          postgres    false    355    2918    354            *           2606    415933 )   notas_ven_cab notas_ven_cab_ventas_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_ven_cab
    ADD CONSTRAINT notas_ven_cab_ventas_cab_fk FOREIGN KEY (ven_cod) REFERENCES public.ventas_cab(ven_cod);
 S   ALTER TABLE ONLY public.notas_ven_cab DROP CONSTRAINT notas_ven_cab_ventas_cab_fk;
       public          postgres    false    2846    352    274            �           2606    208128 /   ordcompras_det ordcompras_cab_ordcompras_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordcompras_det
    ADD CONSTRAINT ordcompras_cab_ordcompras_det_fk FOREIGN KEY (orden_nro) REFERENCES public.ordcompras_cab(orden_nro);
 Y   ALTER TABLE ONLY public.ordcompras_det DROP CONSTRAINT ordcompras_cab_ordcompras_det_fk;
       public          postgres    false    2756    209    210            �           2606    208133 +   pedido_orden ordcompras_cab_pedido_orden_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido_orden
    ADD CONSTRAINT ordcompras_cab_pedido_orden_fk FOREIGN KEY (orden_cod) REFERENCES public.ordcompras_cab(orden_nro);
 U   ALTER TABLE ONLY public.pedido_orden DROP CONSTRAINT ordcompras_cab_pedido_orden_fk;
       public          postgres    false    216    2756    209            �           2606    208138 *   orden_compra ordcompras_ordenes_compras_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.orden_compra
    ADD CONSTRAINT ordcompras_ordenes_compras_fk FOREIGN KEY (orden_cod) REFERENCES public.ordcompras_cab(orden_nro);
 T   ALTER TABLE ONLY public.orden_compra DROP CONSTRAINT ordcompras_ordenes_compras_fk;
       public          postgres    false    209    2756    211                       2606    267988 +   pago_cheques orden_pago_cab_pago_cheques_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.pago_cheques
    ADD CONSTRAINT orden_pago_cab_pago_cheques_fk FOREIGN KEY (orden_pago_cod) REFERENCES public.orden_pago_cab(orden_pago_cod);
 U   ALTER TABLE ONLY public.pago_cheques DROP CONSTRAINT orden_pago_cab_pago_cheques_fk;
       public          postgres    false    308    2868    301            �           2606    259728 0   orden_pago_det_compras orden_pago_det_compras_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.orden_pago_det_compras
    ADD CONSTRAINT orden_pago_det_compras_fk FOREIGN KEY (orden_pago_cod) REFERENCES public.orden_pago_cab(orden_pago_cod);
 Z   ALTER TABLE ONLY public.orden_pago_det_compras DROP CONSTRAINT orden_pago_det_compras_fk;
       public          postgres    false    303    301    2868            �           2606    259704 O   orden_pago_detalle_fact_varias orden_pago_detalle_fact_varias_orden_pago_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.orden_pago_detalle_fact_varias
    ADD CONSTRAINT orden_pago_detalle_fact_varias_orden_pago_cab_fk FOREIGN KEY (orden_pago_cod) REFERENCES public.orden_pago_cab(orden_pago_cod);
 y   ALTER TABLE ONLY public.orden_pago_detalle_fact_varias DROP CONSTRAINT orden_pago_detalle_fact_varias_orden_pago_cab_fk;
       public          postgres    false    302    301    2868            �           2606    208143 A   ordenes_trabajos_det ordenes_trabajos_cab_ordenes_trabajos_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordenes_trabajos_det
    ADD CONSTRAINT ordenes_trabajos_cab_ordenes_trabajos_det_fk FOREIGN KEY (ord_trab_cod) REFERENCES public.ordenes_trabajos_cab(ord_trab_cod);
 k   ALTER TABLE ONLY public.ordenes_trabajos_det DROP CONSTRAINT ordenes_trabajos_cab_ordenes_trabajos_det_fk;
       public          postgres    false    212    2760    213            �           2606    208148    permisos paginas_permisos_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.permisos
    ADD CONSTRAINT paginas_permisos_fk FOREIGN KEY (pag_id, mod_id) REFERENCES public.paginas(pag_id, mod_id);
 F   ALTER TABLE ONLY public.permisos DROP CONSTRAINT paginas_permisos_fk;
       public          postgres    false    214    221    221    2764    214                       2606    268019 :   asignacion_fondo_fijo pago_cheque_asignacion_fondo_fijo_fk    FK CONSTRAINT       ALTER TABLE ONLY public.asignacion_fondo_fijo
    ADD CONSTRAINT pago_cheque_asignacion_fondo_fijo_fk FOREIGN KEY (orden_pago_cod, ent_cod, cuenta_corriente_cod, movimiento_nro) REFERENCES public.pago_cheques(orden_pago_cod, ent_cod, cuenta_corriente_cod, movimiento_nro);
 d   ALTER TABLE ONLY public.asignacion_fondo_fijo DROP CONSTRAINT pago_cheque_asignacion_fondo_fijo_fk;
       public          postgres    false    310    310    310    310    2882    308    308    308    308                       2606    268155 :   reposicion_fondo_fijo pago_cheque_reposicion_fondo_fijo_fk    FK CONSTRAINT       ALTER TABLE ONLY public.reposicion_fondo_fijo
    ADD CONSTRAINT pago_cheque_reposicion_fondo_fijo_fk FOREIGN KEY (orden_pago_cod, ent_cod, cuenta_corriente_cod, movimiento_nro) REFERENCES public.pago_cheques(orden_pago_cod, ent_cod, cuenta_corriente_cod, movimiento_nro);
 d   ALTER TABLE ONLY public.reposicion_fondo_fijo DROP CONSTRAINT pago_cheque_reposicion_fondo_fijo_fk;
       public          postgres    false    313    2882    308    308    313    308    313    313    308            }           2606    208153    ciudades paises_ciudades_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT paises_ciudades_fk FOREIGN KEY (pais_cod) REFERENCES public.paises(pais_cod);
 E   ALTER TABLE ONLY public.ciudades DROP CONSTRAINT paises_ciudades_fk;
       public          postgres    false    2766    215    181            �           2606    208158    personas paises_personas    FK CONSTRAINT        ALTER TABLE ONLY public.personas
    ADD CONSTRAINT paises_personas FOREIGN KEY (pais_cod) REFERENCES public.paises(pais_cod);
 B   ALTER TABLE ONLY public.personas DROP CONSTRAINT paises_personas;
       public          postgres    false    215    222    2766            �           2606    208163 (   pedido_orden pedidos_cab_pedido_orden_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido_orden
    ADD CONSTRAINT pedidos_cab_pedido_orden_fk FOREIGN KEY (ped_cod) REFERENCES public.pedidos_cab(ped_nro);
 R   ALTER TABLE ONLY public.pedido_orden DROP CONSTRAINT pedidos_cab_pedido_orden_fk;
       public          postgres    false    217    2770    216            �           2606    208168 &   pedidos_det pedidos_cab_pedidos_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos_det
    ADD CONSTRAINT pedidos_cab_pedidos_det_fk FOREIGN KEY (ped_nro) REFERENCES public.pedidos_cab(ped_nro);
 P   ALTER TABLE ONLY public.pedidos_det DROP CONSTRAINT pedidos_cab_pedidos_det_fk;
       public          postgres    false    218    2770    217            �           2606    208173 )   pedidos_vdet pedidos_vcab_pedidos_vdet_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos_vdet
    ADD CONSTRAINT pedidos_vcab_pedidos_vdet_fk FOREIGN KEY (ped_vcod) REFERENCES public.pedidos_vcab(ped_vcod);
 S   ALTER TABLE ONLY public.pedidos_vdet DROP CONSTRAINT pedidos_vcab_pedidos_vdet_fk;
       public          postgres    false    2774    220    219                       2606    366745    choferes personas_choferes_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.choferes
    ADD CONSTRAINT personas_choferes_fk FOREIGN KEY (per_cod) REFERENCES public.personas(per_cod);
 G   ALTER TABLE ONLY public.choferes DROP CONSTRAINT personas_choferes_fk;
       public          postgres    false    332    2780    222            ~           2606    208178    clientes personas_clientes_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT personas_clientes_fk FOREIGN KEY (per_cod) REFERENCES public.personas(per_cod);
 G   ALTER TABLE ONLY public.clientes DROP CONSTRAINT personas_clientes_fk;
       public          postgres    false    222    183    2780            �           2606    208183 %   funcionarios personas_funcionarios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT personas_funcionarios_fk FOREIGN KEY (per_cod) REFERENCES public.personas(per_cod);
 O   ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT personas_funcionarios_fk;
       public          postgres    false    222    200    2780            �           2606    208188 #   proveedores personas_proveedores_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT personas_proveedores_fk FOREIGN KEY (per_cod) REFERENCES public.personas(per_cod);
 M   ALTER TABLE ONLY public.proveedores DROP CONSTRAINT personas_proveedores_fk;
       public          postgres    false    2780    229    222            �           2606    208193 ?   presupuestos_det_servicios presupuestos_cab_presupuestos_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.presupuestos_det_servicios
    ADD CONSTRAINT presupuestos_cab_presupuestos_det_fk FOREIGN KEY (presu_cod) REFERENCES public.presupuestos_cab(presu_cod);
 i   ALTER TABLE ONLY public.presupuestos_det_servicios DROP CONSTRAINT presupuestos_cab_presupuestos_det_fk;
       public          postgres    false    223    2782    224            �           2606    216951 A   presupuestos_det_items presupuestos_cab_presupuestos_det_items_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.presupuestos_det_items
    ADD CONSTRAINT presupuestos_cab_presupuestos_det_items_fk FOREIGN KEY (presu_cod) REFERENCES public.presupuestos_cab(presu_cod);
 k   ALTER TABLE ONLY public.presupuestos_det_items DROP CONSTRAINT presupuestos_cab_presupuestos_det_items_fk;
       public          postgres    false    223    292    2782                       2606    358522 Y   presupuestos_proveedores_det presupuestos_proveedores_cab_presupuestos_proveedores_det_fk    FK CONSTRAINT       ALTER TABLE ONLY public.presupuestos_proveedores_det
    ADD CONSTRAINT presupuestos_proveedores_cab_presupuestos_proveedores_det_fk FOREIGN KEY (pre_prov_cod, prov_cod, pre_prov_fecha) REFERENCES public.presupuestos_proveedores_cab(pre_prov_cod, prov_cod, pre_prov_fecha);
 �   ALTER TABLE ONLY public.presupuestos_proveedores_det DROP CONSTRAINT presupuestos_proveedores_cab_presupuestos_proveedores_det_fk;
       public          postgres    false    323    2894    323    324    324    324    323            �           2606    208198 (   funcionarios profesiones_funcionarios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT profesiones_funcionarios_fk FOREIGN KEY (prof_cod) REFERENCES public.profesiones(prof_cod);
 R   ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT profesiones_funcionarios_fk;
       public          postgres    false    225    200    2786            �           2606    208203 -   promos_det_servicios promos_cab_promos_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.promos_det_servicios
    ADD CONSTRAINT promos_cab_promos_det_fk FOREIGN KEY (promo_cod) REFERENCES public.promos_cab(promo_cod);
 W   ALTER TABLE ONLY public.promos_det_servicios DROP CONSTRAINT promos_cab_promos_det_fk;
       public          postgres    false    226    227    2788            �           2606    216924 /   promos_det_items promos_cab_promos_det_items_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.promos_det_items
    ADD CONSTRAINT promos_cab_promos_det_items_fk FOREIGN KEY (promo_cod) REFERENCES public.promos_cab(promo_cod);
 Y   ALTER TABLE ONLY public.promos_det_items DROP CONSTRAINT promos_cab_promos_det_items_fk;
       public          postgres    false    2788    290    226            �           2606    208213 4   proveedor_timbrados proveedor_proveedor_timbrados_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.proveedor_timbrados
    ADD CONSTRAINT proveedor_proveedor_timbrados_fk FOREIGN KEY (prov_cod) REFERENCES public.proveedores(prov_cod);
 ^   ALTER TABLE ONLY public.proveedor_timbrados DROP CONSTRAINT proveedor_proveedor_timbrados_fk;
       public          postgres    false    2794    229    228            �           2606    251506 6   facturas_varias_det proveedores_facturas_varias_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.facturas_varias_det
    ADD CONSTRAINT proveedores_facturas_varias_det_fk FOREIGN KEY (prov_cod) REFERENCES public.proveedores(prov_cod);
 `   ALTER TABLE ONLY public.facturas_varias_det DROP CONSTRAINT proveedores_facturas_varias_det_fk;
       public          postgres    false    299    229    2794            �           2606    251473 2   facturas_varias_cab proveedores_facturas_varias_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.facturas_varias_cab
    ADD CONSTRAINT proveedores_facturas_varias_fk FOREIGN KEY (prov_cod) REFERENCES public.proveedores(prov_cod);
 \   ALTER TABLE ONLY public.facturas_varias_cab DROP CONSTRAINT proveedores_facturas_varias_fk;
       public          postgres    false    298    229    2794            �           2606    208233 ,   ordcompras_cab proveedores_ordcompras_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordcompras_cab
    ADD CONSTRAINT proveedores_ordcompras_cab_fk FOREIGN KEY (prov_cod) REFERENCES public.proveedores(prov_cod);
 V   ALTER TABLE ONLY public.ordcompras_cab DROP CONSTRAINT proveedores_ordcompras_cab_fk;
       public          postgres    false    229    209    2794            �           2606    259661 ,   orden_pago_cab proveedores_orden_pago_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.orden_pago_cab
    ADD CONSTRAINT proveedores_orden_pago_cab_fk FOREIGN KEY (prov_cod) REFERENCES public.proveedores(prov_cod);
 V   ALTER TABLE ONLY public.orden_pago_cab DROP CONSTRAINT proveedores_orden_pago_cab_fk;
       public          postgres    false    2794    301    229                       2606    358499 <   presupuestos_proveedores_cab proveedores_presupuestos_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.presupuestos_proveedores_cab
    ADD CONSTRAINT proveedores_presupuestos_cab_fk FOREIGN KEY (prov_cod) REFERENCES public.proveedores(prov_cod);
 f   ALTER TABLE ONLY public.presupuestos_proveedores_cab DROP CONSTRAINT proveedores_presupuestos_cab_fk;
       public          postgres    false    229    323    2794                       2606    268111 8   rendicion_fondo_fijo proveedores_rendicion_fondo_fijo_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.rendicion_fondo_fijo
    ADD CONSTRAINT proveedores_rendicion_fondo_fijo_fk FOREIGN KEY (prov_cod) REFERENCES public.proveedores(prov_cod);
 b   ALTER TABLE ONLY public.rendicion_fondo_fijo DROP CONSTRAINT proveedores_rendicion_fondo_fijo_fk;
       public          postgres    false    312    229    2794            	           2606    268075 4   boleta_deposito recaudaciones_dep_boleta_deposito_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.boleta_deposito
    ADD CONSTRAINT recaudaciones_dep_boleta_deposito_fk FOREIGN KEY (recau_dep_cod, aper_cier_cod) REFERENCES public.recaudaciones_dep(recau_dep_cod, aper_cier_cod);
 ^   ALTER TABLE ONLY public.boleta_deposito DROP CONSTRAINT recaudaciones_dep_boleta_deposito_fk;
       public          postgres    false    2796    230    230    311    311                       2606    268150 C   reposicion_fondo_fijo rendicion_fondo_fijo_reposicion_fondo_fijo_fk    FK CONSTRAINT       ALTER TABLE ONLY public.reposicion_fondo_fijo
    ADD CONSTRAINT rendicion_fondo_fijo_reposicion_fondo_fijo_fk FOREIGN KEY (asignacion_responsable_cod, rendicion_fondo_fijo_cod) REFERENCES public.rendicion_fondo_fijo(asignacion_responsable_cod, rendicion_fondo_fijo_cod);
 m   ALTER TABLE ONLY public.reposicion_fondo_fijo DROP CONSTRAINT rendicion_fondo_fijo_reposicion_fondo_fijo_fk;
       public          postgres    false    2890    312    313    313    312            �           2606    208238 )   reservas_det reservas_cab_reservas_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservas_det
    ADD CONSTRAINT reservas_cab_reservas_det_fk FOREIGN KEY (reser_cod) REFERENCES public.reservas_cab(reser_cod);
 S   ALTER TABLE ONLY public.reservas_det DROP CONSTRAINT reservas_cab_reservas_det_fk;
       public          postgres    false    2800    233    232            �           2606    251511 1   facturas_varias_det rubros_facturas_varias_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.facturas_varias_det
    ADD CONSTRAINT rubros_facturas_varias_det_fk FOREIGN KEY (rubro_cod) REFERENCES public.rubros(rubro_cod);
 [   ALTER TABLE ONLY public.facturas_varias_det DROP CONSTRAINT rubros_facturas_varias_det_fk;
       public          postgres    false    296    2858    299            �           2606    208243 ,   servicios_det servicios_cab_servicios_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.servicios_det
    ADD CONSTRAINT servicios_cab_servicios_det_fk FOREIGN KEY (serv_cod) REFERENCES public.servicios_cab(serv_cod);
 V   ALTER TABLE ONLY public.servicios_det DROP CONSTRAINT servicios_cab_servicios_det_fk;
       public          postgres    false    2804    235    234            n           2606    208622     ajustes_det stock_ajustes_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ajustes_det
    ADD CONSTRAINT stock_ajustes_det_fk FOREIGN KEY (dep_cod, item_cod, mar_cod) REFERENCES public.stock(dep_cod, item_cod, mar_cod);
 J   ALTER TABLE ONLY public.ajustes_det DROP CONSTRAINT stock_ajustes_det_fk;
       public          postgres    false    237    173    2810    237    237    173    173            %           2606    391322 $   notas_com_det stock_notas_com_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_com_det
    ADD CONSTRAINT stock_notas_com_det_fk FOREIGN KEY (dep_cod, mar_cod, item_cod) REFERENCES public.stock(dep_cod, mar_cod, item_cod);
 N   ALTER TABLE ONLY public.notas_com_det DROP CONSTRAINT stock_notas_com_det_fk;
       public          postgres    false    237    237    345    345    345    237    2810            �           2606    208675 *   transferencias_det stock_transferencias_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.transferencias_det
    ADD CONSTRAINT stock_transferencias_fk FOREIGN KEY (dep_origen, item_cod, mar_cod) REFERENCES public.stock(dep_cod, item_cod, mar_cod);
 T   ALTER TABLE ONLY public.transferencias_det DROP CONSTRAINT stock_transferencias_fk;
       public          postgres    false    237    250    250    250    237    2810    237            �           2606    301089 '   ventas_det_items stock_ventas_det_items    FK CONSTRAINT     �   ALTER TABLE ONLY public.ventas_det_items
    ADD CONSTRAINT stock_ventas_det_items FOREIGN KEY (dep_cod, item_cod, mar_cod) REFERENCES public.stock(dep_cod, item_cod, mar_cod);
 Q   ALTER TABLE ONLY public.ventas_det_items DROP CONSTRAINT stock_ventas_det_items;
       public          postgres    false    2810    275    275    275    237    237    237            j           2606    208268 !   agendas sucursales_agendas_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.agendas
    ADD CONSTRAINT sucursales_agendas_cab_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 K   ALTER TABLE ONLY public.agendas DROP CONSTRAINT sucursales_agendas_cab_fk;
       public          postgres    false    2812    238    238    171    171                       2606    383060 !   agendas_cab sucursales_agendas_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.agendas_cab
    ADD CONSTRAINT sucursales_agendas_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 K   ALTER TABLE ONLY public.agendas_cab DROP CONSTRAINT sucursales_agendas_fk;
       public          postgres    false    238    334    334    2812    238            q           2606    208273 1   aperturas_cierres sucursales_aperturas_cierres_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.aperturas_cierres
    ADD CONSTRAINT sucursales_aperturas_cierres_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 [   ALTER TABLE ONLY public.aperturas_cierres DROP CONSTRAINT sucursales_aperturas_cierres_fk;
       public          postgres    false    174    2812    238    238    174                       2606    268029 9   asignacion_fondo_fijo sucursales_asignacion_fondo_fijo_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.asignacion_fondo_fijo
    ADD CONSTRAINT sucursales_asignacion_fondo_fijo_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 c   ALTER TABLE ONLY public.asignacion_fondo_fijo DROP CONSTRAINT sucursales_asignacion_fondo_fijo_fk;
       public          postgres    false    238    2812    238    310    310            w           2606    208278 7   avisos_recordatorios sucursales_avisos_recordatorios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.avisos_recordatorios
    ADD CONSTRAINT sucursales_avisos_recordatorios_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 a   ALTER TABLE ONLY public.avisos_recordatorios DROP CONSTRAINT sucursales_avisos_recordatorios_fk;
       public          postgres    false    238    238    176    176    2812            y           2606    208283    cajas sucursales_cajas_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cajas
    ADD CONSTRAINT sucursales_cajas_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 C   ALTER TABLE ONLY public.cajas DROP CONSTRAINT sucursales_cajas_fk;
       public          postgres    false    178    2812    178    238    238                       2606    383101 "   compras_cab sucursales_compras_cab    FK CONSTRAINT     �   ALTER TABLE ONLY public.compras_cab
    ADD CONSTRAINT sucursales_compras_cab FOREIGN KEY (emp_cod, suc_cod) REFERENCES public.sucursales(emp_cod, suc_cod);
 L   ALTER TABLE ONLY public.compras_cab DROP CONSTRAINT sucursales_compras_cab;
       public          postgres    false    238    338    338    238    2812            �           2606    251478 1   facturas_varias_cab sucursales_facturas_varias_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.facturas_varias_cab
    ADD CONSTRAINT sucursales_facturas_varias_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 [   ALTER TABLE ONLY public.facturas_varias_cab DROP CONSTRAINT sucursales_facturas_varias_fk;
       public          postgres    false    298    298    238    238    2812                       2606    267908 7   movimiento_bancario sucursales_movimientos_bancarios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.movimiento_bancario
    ADD CONSTRAINT sucursales_movimientos_bancarios_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 a   ALTER TABLE ONLY public.movimiento_bancario DROP CONSTRAINT sucursales_movimientos_bancarios_fk;
       public          postgres    false    238    307    2812    307    238            #           2606    391302 )   notas_com_cab sucursales_notas_compras_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_com_cab
    ADD CONSTRAINT sucursales_notas_compras_fk FOREIGN KEY (emp_cod, suc_cod) REFERENCES public.sucursales(emp_cod, suc_cod);
 S   ALTER TABLE ONLY public.notas_com_cab DROP CONSTRAINT sucursales_notas_compras_fk;
       public          postgres    false    344    2812    238    238    344            -           2606    432297 3   notas_remisiones_cab sucursales_notas_remisiones_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_remisiones_cab
    ADD CONSTRAINT sucursales_notas_remisiones_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 ]   ALTER TABLE ONLY public.notas_remisiones_cab DROP CONSTRAINT sucursales_notas_remisiones_fk;
       public          postgres    false    238    238    354    354    2812            )           2606    415938 )   notas_ven_cab sucursales_notas_ven_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_ven_cab
    ADD CONSTRAINT sucursales_notas_ven_cab_fk FOREIGN KEY (emp_cod, suc_cod) REFERENCES public.sucursales(emp_cod, suc_cod);
 S   ALTER TABLE ONLY public.notas_ven_cab DROP CONSTRAINT sucursales_notas_ven_cab_fk;
       public          postgres    false    352    352    2812    238    238            �           2606    208303 /   ordenes_trabajos_cab sucursales_ord_trab_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordenes_trabajos_cab
    ADD CONSTRAINT sucursales_ord_trab_cab_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 Y   ALTER TABLE ONLY public.ordenes_trabajos_cab DROP CONSTRAINT sucursales_ord_trab_cab_fk;
       public          postgres    false    212    212    238    238    2812            �           2606    208308 +   ordcompras_cab sucursales_ordcompras_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordcompras_cab
    ADD CONSTRAINT sucursales_ordcompras_cab_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 U   ALTER TABLE ONLY public.ordcompras_cab DROP CONSTRAINT sucursales_ordcompras_cab_fk;
       public          postgres    false    209    209    238    238    2812            �           2606    259676 +   orden_pago_cab sucursales_orden_pago_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.orden_pago_cab
    ADD CONSTRAINT sucursales_orden_pago_cab_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 U   ALTER TABLE ONLY public.orden_pago_cab DROP CONSTRAINT sucursales_orden_pago_cab_fk;
       public          postgres    false    238    2812    238    301    301            �           2606    208313 %   pedidos_cab sucursales_pedidos_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos_cab
    ADD CONSTRAINT sucursales_pedidos_cab_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 O   ALTER TABLE ONLY public.pedidos_cab DROP CONSTRAINT sucursales_pedidos_cab_fk;
       public          postgres    false    217    217    238    238    2812            �           2606    208318 '   pedidos_vcab sucursales_pedidos_vcab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos_vcab
    ADD CONSTRAINT sucursales_pedidos_vcab_fk FOREIGN KEY (emp_cod, suc_cod) REFERENCES public.sucursales(emp_cod, suc_cod);
 Q   ALTER TABLE ONLY public.pedidos_vcab DROP CONSTRAINT sucursales_pedidos_vcab_fk;
       public          postgres    false    219    219    238    2812    238            �           2606    208323 /   presupuestos_cab sucursales_presupuestos_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.presupuestos_cab
    ADD CONSTRAINT sucursales_presupuestos_cab_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 Y   ALTER TABLE ONLY public.presupuestos_cab DROP CONSTRAINT sucursales_presupuestos_cab_fk;
       public          postgres    false    223    2812    238    238    223                       2606    358504 D   presupuestos_proveedores_cab sucursales_presupuestos_proveedores_cab    FK CONSTRAINT     �   ALTER TABLE ONLY public.presupuestos_proveedores_cab
    ADD CONSTRAINT sucursales_presupuestos_proveedores_cab FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 n   ALTER TABLE ONLY public.presupuestos_proveedores_cab DROP CONSTRAINT sucursales_presupuestos_proveedores_cab;
       public          postgres    false    238    323    323    238    2812            �           2606    208328 #   promos_cab sucursales_promos_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.promos_cab
    ADD CONSTRAINT sucursales_promos_cab_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 M   ALTER TABLE ONLY public.promos_cab DROP CONSTRAINT sucursales_promos_cab_fk;
       public          postgres    false    2812    226    226    238    238            �           2606    208333 /   reclamo_clientes sucursales_reclamo_clientes_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.reclamo_clientes
    ADD CONSTRAINT sucursales_reclamo_clientes_fk FOREIGN KEY (suc_reclamo, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 Y   ALTER TABLE ONLY public.reclamo_clientes DROP CONSTRAINT sucursales_reclamo_clientes_fk;
       public          postgres    false    238    231    231    238    2812            �           2606    208338 '   reservas_cab sucursales_reservas_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservas_cab
    ADD CONSTRAINT sucursales_reservas_cab_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 Q   ALTER TABLE ONLY public.reservas_cab DROP CONSTRAINT sucursales_reservas_cab_fk;
       public          postgres    false    238    232    232    238    2812            �           2606    208343 !   timbrados sucursales_timbrados_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.timbrados
    ADD CONSTRAINT sucursales_timbrados_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 K   ALTER TABLE ONLY public.timbrados DROP CONSTRAINT sucursales_timbrados_fk;
       public          postgres    false    2812    239    239    238    238            �           2606    208348 3   transferencias_cab sucursales_transferencias_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.transferencias_cab
    ADD CONSTRAINT sucursales_transferencias_cab_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 ]   ALTER TABLE ONLY public.transferencias_cab DROP CONSTRAINT sucursales_transferencias_cab_fk;
       public          postgres    false    2812    249    249    238    238            �           2606    208353    usuarios sucursales_usuarios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT sucursales_usuarios_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 I   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT sucursales_usuarios_fk;
       public          postgres    false    238    251    251    238    2812            �           2606    208358 #   ventas_cab sucursales_ventas_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ventas_cab
    ADD CONSTRAINT sucursales_ventas_cab_fk FOREIGN KEY (suc_cod, emp_cod) REFERENCES public.sucursales(suc_cod, emp_cod);
 M   ALTER TABLE ONLY public.ventas_cab DROP CONSTRAINT sucursales_ventas_cab_fk;
       public          postgres    false    238    274    274    238    2812            r           2606    208363 +   aperturas_cierres timbrados_apertura_cierre    FK CONSTRAINT     �   ALTER TABLE ONLY public.aperturas_cierres
    ADD CONSTRAINT timbrados_apertura_cierre FOREIGN KEY (timb_cod) REFERENCES public.timbrados(timb_cod);
 U   ALTER TABLE ONLY public.aperturas_cierres DROP CONSTRAINT timbrados_apertura_cierre;
       public          postgres    false    239    174    2814            �           2606    208368 -   detalle_timbrados timbrados_detalle_timbrados    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_timbrados
    ADD CONSTRAINT timbrados_detalle_timbrados FOREIGN KEY (timb_cod) REFERENCES public.timbrados(timb_cod);
 W   ALTER TABLE ONLY public.detalle_timbrados DROP CONSTRAINT timbrados_detalle_timbrados;
       public          postgres    false    239    191    2814            (           2606    415943 (   notas_ven_cab timbrados_notas_ven_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_ven_cab
    ADD CONSTRAINT timbrados_notas_ven_cab_fk FOREIGN KEY (timb_cod) REFERENCES public.timbrados(timb_cod);
 R   ALTER TABLE ONLY public.notas_ven_cab DROP CONSTRAINT timbrados_notas_ven_cab_fk;
       public          postgres    false    239    2814    352            |           2606    208388    cheque tipo_cheques_cheques    FK CONSTRAINT     �   ALTER TABLE ONLY public.cheque
    ADD CONSTRAINT tipo_cheques_cheques FOREIGN KEY (cheque_tipo_cod) REFERENCES public.tipo_cheques(cheque_tipo_cod);
 E   ALTER TABLE ONLY public.cheque DROP CONSTRAINT tipo_cheques_cheques;
       public          postgres    false    2818    180    241            �           2606    208393 -   cobros_cheques tipo_cheques_cobros_cheques_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cobros_cheques
    ADD CONSTRAINT tipo_cheques_cobros_cheques_fk FOREIGN KEY (cheque_tipo_cod) REFERENCES public.tipo_cheques(cheque_tipo_cod);
 W   ALTER TABLE ONLY public.cobros_cheques DROP CONSTRAINT tipo_cheques_cobros_cheques_fk;
       public          postgres    false    185    241    2818                       2606    268106 ;   rendicion_fondo_fijo tipo_documento_rendicion_fondo_fijo_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.rendicion_fondo_fijo
    ADD CONSTRAINT tipo_documento_rendicion_fondo_fijo_fk FOREIGN KEY (tipo_doc_cod) REFERENCES public.tipo_documentos(tipo_doc_cod);
 e   ALTER TABLE ONLY public.rendicion_fondo_fijo DROP CONSTRAINT tipo_documento_rendicion_fondo_fijo_fk;
       public          postgres    false    312    297    2860            �           2606    251488 6   facturas_varias_cab tipo_documentos_facturas_varias_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.facturas_varias_cab
    ADD CONSTRAINT tipo_documentos_facturas_varias_fk FOREIGN KEY (tipo_doc_cod) REFERENCES public.tipo_documentos(tipo_doc_cod);
 `   ALTER TABLE ONLY public.facturas_varias_cab DROP CONSTRAINT tipo_documentos_facturas_varias_fk;
       public          postgres    false    297    2860    298                       2606    383106 $   compras_cab tipo_factura_compras_cab    FK CONSTRAINT     �   ALTER TABLE ONLY public.compras_cab
    ADD CONSTRAINT tipo_factura_compras_cab FOREIGN KEY (tipo_fact_cod) REFERENCES public.tipo_facturas(tipo_fact_cod);
 N   ALTER TABLE ONLY public.compras_cab DROP CONSTRAINT tipo_factura_compras_cab;
       public          postgres    false    2820    338    242            �           2606    251493 4   facturas_varias_cab tipo_facturas_facturas_varias_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.facturas_varias_cab
    ADD CONSTRAINT tipo_facturas_facturas_varias_fk FOREIGN KEY (tipo_fact_cod) REFERENCES public.tipo_facturas(tipo_fact_cod);
 ^   ALTER TABLE ONLY public.facturas_varias_cab DROP CONSTRAINT tipo_facturas_facturas_varias_fk;
       public          postgres    false    2820    298    242            �           2606    208403 .   ordcompras_cab tipo_facturas_ordcompras_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordcompras_cab
    ADD CONSTRAINT tipo_facturas_ordcompras_cab_fk FOREIGN KEY (tipo_fact_cod) REFERENCES public.tipo_facturas(tipo_fact_cod);
 X   ALTER TABLE ONLY public.ordcompras_cab DROP CONSTRAINT tipo_facturas_ordcompras_cab_fk;
       public          postgres    false    2820    209    242                       2606    268116 :   rendicion_fondo_fijo tipo_facturas_rendicion_fondo_fijo_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.rendicion_fondo_fijo
    ADD CONSTRAINT tipo_facturas_rendicion_fondo_fijo_fk FOREIGN KEY (tipo_fact_cod) REFERENCES public.tipo_facturas(tipo_fact_cod);
 d   ALTER TABLE ONLY public.rendicion_fondo_fijo DROP CONSTRAINT tipo_facturas_rendicion_fondo_fijo_fk;
       public          postgres    false    312    2820    242            �           2606    208408 &   ventas_cab tipo_facturas_ventas_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ventas_cab
    ADD CONSTRAINT tipo_facturas_ventas_cab_fk FOREIGN KEY (tipo_fact_cod) REFERENCES public.tipo_facturas(tipo_fact_cod);
 P   ALTER TABLE ONLY public.ventas_cab DROP CONSTRAINT tipo_facturas_ventas_cab_fk;
       public          postgres    false    274    242    2820            �           2606    251516 9   facturas_varias_det tipo_impuestos_facturas_varias_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.facturas_varias_det
    ADD CONSTRAINT tipo_impuestos_facturas_varias_det_fk FOREIGN KEY (tipo_imp_cod) REFERENCES public.tipo_impuestos(tipo_imp_cod);
 c   ALTER TABLE ONLY public.facturas_varias_det DROP CONSTRAINT tipo_impuestos_facturas_varias_det_fk;
       public          postgres    false    243    2822    299            �           2606    208418    items tipo_impuestos_items    FK CONSTRAINT     �   ALTER TABLE ONLY public.items
    ADD CONSTRAINT tipo_impuestos_items FOREIGN KEY (tipo_imp_cod) REFERENCES public.tipo_impuestos(tipo_imp_cod);
 D   ALTER TABLE ONLY public.items DROP CONSTRAINT tipo_impuestos_items;
       public          postgres    false    203    243    2822            �           2606    208423    items tipo_items_items_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.items
    ADD CONSTRAINT tipo_items_items_fk FOREIGN KEY (tipo_item_cod) REFERENCES public.tipo_items(tipo_item_cod);
 C   ALTER TABLE ONLY public.items DROP CONSTRAINT tipo_items_items_fk;
       public          postgres    false    203    2824    244            �           2606    208428 "   personas tipo_personas_personas_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.personas
    ADD CONSTRAINT tipo_personas_personas_fk FOREIGN KEY (tipo_per_cod) REFERENCES public.tipo_personas(tipo_per_cod);
 L   ALTER TABLE ONLY public.personas DROP CONSTRAINT tipo_personas_personas_fk;
       public          postgres    false    245    222    2826            �           2606    208433 4   reclamo_clientes tipo_reclamo_items_reclamo_clientes    FK CONSTRAINT     �   ALTER TABLE ONLY public.reclamo_clientes
    ADD CONSTRAINT tipo_reclamo_items_reclamo_clientes FOREIGN KEY (tipo_recl_item_cod) REFERENCES public.tipo_reclamo_items(tipo_recl_item_cod);
 ^   ALTER TABLE ONLY public.reclamo_clientes DROP CONSTRAINT tipo_reclamo_items_reclamo_clientes;
       public          postgres    false    231    2828    246            �           2606    208438 2   reclamo_clientes tipo_reclamos_reclamo_clientes_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.reclamo_clientes
    ADD CONSTRAINT tipo_reclamos_reclamo_clientes_fk FOREIGN KEY (tipo_reclamo_cod) REFERENCES public.tipo_reclamos(tipo_reclamo_cod);
 \   ALTER TABLE ONLY public.reclamo_clientes DROP CONSTRAINT tipo_reclamos_reclamo_clientes_fk;
       public          postgres    false    231    2830    247            �           2606    208443 -   servicios_det tipo_servicios_servicios_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.servicios_det
    ADD CONSTRAINT tipo_servicios_servicios_det_fk FOREIGN KEY (tipo_serv_cod) REFERENCES public.tipo_servicios(tipo_serv_cod);
 W   ALTER TABLE ONLY public.servicios_det DROP CONSTRAINT tipo_servicios_servicios_det_fk;
       public          postgres    false    2832    248    235            �           2606    208448 ;   transferencias_det transferencias_cab_transferencias_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.transferencias_det
    ADD CONSTRAINT transferencias_cab_transferencias_det_fk FOREIGN KEY (trans_cod) REFERENCES public.transferencias_cab(trans_cod);
 e   ALTER TABLE ONLY public.transferencias_det DROP CONSTRAINT transferencias_cab_transferencias_det_fk;
       public          postgres    false    250    2834    249            k           2606    208453    agendas usuarios_agendas_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.agendas
    ADD CONSTRAINT usuarios_agendas_cab_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 I   ALTER TABLE ONLY public.agendas DROP CONSTRAINT usuarios_agendas_cab_fk;
       public          postgres    false    2838    251    171    171    251                       2606    383065 #   agendas_cab usuarios_agendas_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.agendas_cab
    ADD CONSTRAINT usuarios_agendas_cab_fk FOREIGN KEY (usu_cod, fun_codigo) REFERENCES public.usuarios(usu_cod, fun_cod);
 M   ALTER TABLE ONLY public.agendas_cab DROP CONSTRAINT usuarios_agendas_cab_fk;
       public          postgres    false    251    2838    334    334    251            l           2606    208458 #   ajustes_cab usuarios_ajustes_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ajustes_cab
    ADD CONSTRAINT usuarios_ajustes_cab_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 M   ALTER TABLE ONLY public.ajustes_cab DROP CONSTRAINT usuarios_ajustes_cab_fk;
       public          postgres    false    251    172    2838    251    172            s           2606    208463 /   aperturas_cierres usuarios_aperturas_cierres_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.aperturas_cierres
    ADD CONSTRAINT usuarios_aperturas_cierres_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 Y   ALTER TABLE ONLY public.aperturas_cierres DROP CONSTRAINT usuarios_aperturas_cierres_fk;
       public          postgres    false    174    174    251    2838    251            x           2606    208468 5   avisos_recordatorios usuarios_avisos_recordatorios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.avisos_recordatorios
    ADD CONSTRAINT usuarios_avisos_recordatorios_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 _   ALTER TABLE ONLY public.avisos_recordatorios DROP CONSTRAINT usuarios_avisos_recordatorios_fk;
       public          postgres    false    176    2838    176    251    251            z           2606    208473    cajas usuarios_cajas    FK CONSTRAINT     �   ALTER TABLE ONLY public.cajas
    ADD CONSTRAINT usuarios_cajas FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 >   ALTER TABLE ONLY public.cajas DROP CONSTRAINT usuarios_cajas;
       public          postgres    false    2838    178    178    251    251            �           2606    208478 !   cobros_cab usuarios_cobros_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cobros_cab
    ADD CONSTRAINT usuarios_cobros_cab_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 K   ALTER TABLE ONLY public.cobros_cab DROP CONSTRAINT usuarios_cobros_cab_fk;
       public          postgres    false    251    184    184    251    2838                       2606    383111     compras_cab usuarios_compras_cab    FK CONSTRAINT     �   ALTER TABLE ONLY public.compras_cab
    ADD CONSTRAINT usuarios_compras_cab FOREIGN KEY (fun_cod, usu_cod) REFERENCES public.usuarios(fun_cod, usu_cod);
 J   ALTER TABLE ONLY public.compras_cab DROP CONSTRAINT usuarios_compras_cab;
       public          postgres    false    2838    338    251    338    251            �           2606    251483 /   facturas_varias_cab usuarios_facturas_varias_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.facturas_varias_cab
    ADD CONSTRAINT usuarios_facturas_varias_fk FOREIGN KEY (fun_cod, usu_cod) REFERENCES public.usuarios(fun_cod, usu_cod);
 Y   ALTER TABLE ONLY public.facturas_varias_cab DROP CONSTRAINT usuarios_facturas_varias_fk;
       public          postgres    false    298    2838    251    251    298                       2606    267903 5   movimiento_bancario usuarios_movimientos_bancarios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.movimiento_bancario
    ADD CONSTRAINT usuarios_movimientos_bancarios_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 _   ALTER TABLE ONLY public.movimiento_bancario DROP CONSTRAINT usuarios_movimientos_bancarios_fk;
       public          postgres    false    2838    251    251    307    307            "           2606    391307 '   notas_com_cab usuarios_notas_compras_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_com_cab
    ADD CONSTRAINT usuarios_notas_compras_fk FOREIGN KEY (fun_cod, usu_cod) REFERENCES public.usuarios(fun_cod, usu_cod);
 Q   ALTER TABLE ONLY public.notas_com_cab DROP CONSTRAINT usuarios_notas_compras_fk;
       public          postgres    false    344    344    251    251    2838            ,           2606    432302 1   notas_remisiones_cab usuarios_notas_remisiones_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_remisiones_cab
    ADD CONSTRAINT usuarios_notas_remisiones_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 [   ALTER TABLE ONLY public.notas_remisiones_cab DROP CONSTRAINT usuarios_notas_remisiones_fk;
       public          postgres    false    251    251    354    354    2838            '           2606    415948 '   notas_ven_cab usuarios_notas_ven_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_ven_cab
    ADD CONSTRAINT usuarios_notas_ven_cab_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 Q   ALTER TABLE ONLY public.notas_ven_cab DROP CONSTRAINT usuarios_notas_ven_cab_fk;
       public          postgres    false    251    251    2838    352    352            �           2606    208498 )   ordcompras_cab usuarios_ordcompras_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordcompras_cab
    ADD CONSTRAINT usuarios_ordcompras_cab_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 S   ALTER TABLE ONLY public.ordcompras_cab DROP CONSTRAINT usuarios_ordcompras_cab_fk;
       public          postgres    false    251    209    209    251    2838            �           2606    259671 )   orden_pago_cab usuarios_orden_pago_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.orden_pago_cab
    ADD CONSTRAINT usuarios_orden_pago_cab_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 S   ALTER TABLE ONLY public.orden_pago_cab DROP CONSTRAINT usuarios_orden_pago_cab_fk;
       public          postgres    false    251    2838    301    301    251            �           2606    208503 5   ordenes_trabajos_cab usuarios_ordenes_trabajos_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordenes_trabajos_cab
    ADD CONSTRAINT usuarios_ordenes_trabajos_cab_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 _   ALTER TABLE ONLY public.ordenes_trabajos_cab DROP CONSTRAINT usuarios_ordenes_trabajos_cab_fk;
       public          postgres    false    251    212    212    251    2838            �           2606    208508 #   pedidos_cab usuarios_pedidos_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos_cab
    ADD CONSTRAINT usuarios_pedidos_cab_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 M   ALTER TABLE ONLY public.pedidos_cab DROP CONSTRAINT usuarios_pedidos_cab_fk;
       public          postgres    false    251    217    217    251    2838            �           2606    208513 %   pedidos_vcab usuarios_pedidos_vcab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos_vcab
    ADD CONSTRAINT usuarios_pedidos_vcab_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 O   ALTER TABLE ONLY public.pedidos_vcab DROP CONSTRAINT usuarios_pedidos_vcab_fk;
       public          postgres    false    219    219    251    251    2838            �           2606    208518 -   presupuestos_cab usuarios_presupuestos_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.presupuestos_cab
    ADD CONSTRAINT usuarios_presupuestos_cab_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 W   ALTER TABLE ONLY public.presupuestos_cab DROP CONSTRAINT usuarios_presupuestos_cab_fk;
       public          postgres    false    223    251    2838    223    251                       2606    358509 E   presupuestos_proveedores_cab usuarios_presupuestos_proveedores_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.presupuestos_proveedores_cab
    ADD CONSTRAINT usuarios_presupuestos_proveedores_cab_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 o   ALTER TABLE ONLY public.presupuestos_proveedores_cab DROP CONSTRAINT usuarios_presupuestos_proveedores_cab_fk;
       public          postgres    false    323    251    251    2838    323            �           2606    208523 !   promos_cab usuarios_promos_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.promos_cab
    ADD CONSTRAINT usuarios_promos_cab_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 K   ALTER TABLE ONLY public.promos_cab DROP CONSTRAINT usuarios_promos_cab_fk;
       public          postgres    false    226    226    251    251    2838            �           2606    208528 -   reclamo_clientes usuarios_reclamo_clientes_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.reclamo_clientes
    ADD CONSTRAINT usuarios_reclamo_clientes_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 W   ALTER TABLE ONLY public.reclamo_clientes DROP CONSTRAINT usuarios_reclamo_clientes_fk;
       public          postgres    false    231    231    251    251    2838            �           2606    208533 %   reservas_cab usuarios_reservas_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservas_cab
    ADD CONSTRAINT usuarios_reservas_cab_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 O   ALTER TABLE ONLY public.reservas_cab DROP CONSTRAINT usuarios_reservas_cab_fk;
       public          postgres    false    232    232    251    251    2838            �           2606    208538 1   transferencias_cab usuarios_transferencias_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.transferencias_cab
    ADD CONSTRAINT usuarios_transferencias_cab_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 [   ALTER TABLE ONLY public.transferencias_cab DROP CONSTRAINT usuarios_transferencias_cab_fk;
       public          postgres    false    251    249    249    251    2838            �           2606    208543 !   ventas_cab usuarios_ventas_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ventas_cab
    ADD CONSTRAINT usuarios_ventas_cab_fk FOREIGN KEY (usu_cod, fun_cod) REFERENCES public.usuarios(usu_cod, fun_cod);
 K   ALTER TABLE ONLY public.ventas_cab DROP CONSTRAINT usuarios_ventas_cab_fk;
       public          postgres    false    251    2838    251    274    274            �           2606    208553 2   transferencias_cab vehiculos_transferencias_cab_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.transferencias_cab
    ADD CONSTRAINT vehiculos_transferencias_cab_fk FOREIGN KEY (vehi_cod) REFERENCES public.vehiculos(vehi_cod);
 \   ALTER TABLE ONLY public.transferencias_cab DROP CONSTRAINT vehiculos_transferencias_cab_fk;
       public          postgres    false    249    270    2840            �           2606    208558 #   cobros_det ventas_cab_cobros_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cobros_det
    ADD CONSTRAINT ventas_cab_cobros_det_fk FOREIGN KEY (ven_cod) REFERENCES public.ventas_cab(ven_cod);
 M   ALTER TABLE ONLY public.cobros_det DROP CONSTRAINT ventas_cab_cobros_det_fk;
       public          postgres    false    2846    186    274            �           2606    208563 *   cuentas_cobrar ventas_cab_ctas_a_cobrar_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.cuentas_cobrar
    ADD CONSTRAINT ventas_cab_ctas_a_cobrar_fk FOREIGN KEY (ven_cod) REFERENCES public.ventas_cab(ven_cod);
 T   ALTER TABLE ONLY public.cuentas_cobrar DROP CONSTRAINT ventas_cab_ctas_a_cobrar_fk;
       public          postgres    false    274    188    2846            �           2606    208568 '   libro_ventas ventas_cab_libro_ventas_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.libro_ventas
    ADD CONSTRAINT ventas_cab_libro_ventas_fk FOREIGN KEY (ven_cod) REFERENCES public.ventas_cab(ven_cod);
 Q   ALTER TABLE ONLY public.libro_ventas DROP CONSTRAINT ventas_cab_libro_ventas_fk;
       public          postgres    false    204    274    2846            .           2606    432292 3   notas_remisiones_cab ventas_cab_notas_remisiones_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_remisiones_cab
    ADD CONSTRAINT ventas_cab_notas_remisiones_fk FOREIGN KEY (ven_cod) REFERENCES public.ventas_cab(ven_cod);
 ]   ALTER TABLE ONLY public.notas_remisiones_cab DROP CONSTRAINT ventas_cab_notas_remisiones_fk;
       public          postgres    false    354    274    2846            �           2606    208578 )   ventas_det_items ventas_cab_ventas_det_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ventas_det_items
    ADD CONSTRAINT ventas_cab_ventas_det_fk FOREIGN KEY (ven_cod) REFERENCES public.ventas_cab(ven_cod);
 S   ALTER TABLE ONLY public.ventas_det_items DROP CONSTRAINT ventas_cab_ventas_det_fk;
       public          postgres    false    2846    275    274            �           2606    251419 7   ventas_det_servicios ventas_cab_ventas_det_servicios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.ventas_det_servicios
    ADD CONSTRAINT ventas_cab_ventas_det_servicios_fk FOREIGN KEY (ven_cod) REFERENCES public.ventas_cab(ven_cod);
 a   ALTER TABLE ONLY public.ventas_det_servicios DROP CONSTRAINT ventas_cab_ventas_det_servicios_fk;
       public          postgres    false    2846    274    295            �     x���1n�0k���.IY� U�4A������'���*�c�.W������{��Ä��X�";N�������)��U2����4Q��%�+��j+]8���^w��~
���$���M��DA�#��e dA+�ew7�����\�]{�����m+t�ٞ��:��j�<�v�J*[�kF�����#1�"MC�>?���l,ex�rtw�sa<�J��b��׋zL<����t�y�Ocq@�u���9���?����p?�7�X�U���'�Ur��暨�      n   o   x�]�1
�0F�Y>�/`!��[�i�Bi��S��$o�x Z�mY-���4���;�%#;�JQϰ�flz�J���yc�6�&��k<N���+�[kQ+���qJi�m`      o   W   x�u�]
�@���0�_��Y��92�m�c�v���I�X���R���iY��sv|S��þ~e�u�E��z,DtF�)�      �   �  x���K�QEǰ
6�����PҊZ��V:�(�_G� Q��v����.�{�m;F�G�#ځx�1(�w�?�_^>N_�;�����?_��V�b:�؆:(�1�J(%<�@Jߝ�~}�DjD��*�	y{�v� - ��5�Z�2��2�026�A�E�t����#��R��d SےR)���hޡE����F�TT�j�a�T,�=�V�O�uA�j���#̩҇�����|���*io=R�%�FKߗ1RuJ1�-�������-��]��hs�5h�RJV��D(��
\(�����ڊ��}�bٚ�B�墥A
b[�_���FS�f[��P���R2Ss�#�#Շ"����|/���d�9����>�da�2�]v��8��βJr���J,��|(�NL@�*^,Rn}��O�ˍjG�SR�O6���+��
q��ji4I���;��T�Q��i������)�Us�"U��8]
ʁr�����:#T1���j�bPi��=R.Ùl���k�u	C�%�ǚ��>��ڦ6�E겄�R�j�G�V?NR�ۃ6ځq`�34ܲ�rR��<�$C�H���X�#׳sZR�K��"(=�����]ޜW����..�9@���w�ٽ���i�@��1���xK�G�o�����N���d�Z�T���uk�/�>�)�H�/!q�kJi��ޠ&'W�{!�Kzz61TN�H�T\NP-�>S��%?���~��#?�V      �   �   x�U�ɑ� �3
f
m�s���1�,n��W����E���>5)�eIJ)8����SNI8E�ERIYD��EHaG4D����|�Yz�N+�$��3�}��np�ݳ��F1�H��,�EV��c�+���^l��	���ٸK!�����.J��(S�s��=�o�����s�^��:�Q�-���&�'j�6ݐ���~D�c�k�          �   x�m�ɕ!�t$�z�Z�ZA8���:��p�����`籃;��!����cG��,��?0>76���Pt�.-���9˳���?�gWA�l�5r�2Sr4O�n�"k�(s2�i�'�-���k.?�j�n�-����#�fyJ���b���������Ҷm7n5I�            x������ � �      e      x������ � �            x������ � �         =   x�3��q�r�tq�qUpr�s�Wp�Wp���q�4��0�51��562������ ]<�      f      x������ � �         a   x�]�A
� ����St�hF��h.��j���Q(Q�[~�7:k�	B,E��C��Z��������r�@�5:RΚ?1��a$n�����=:{"� �L�         h   x��KA�5��h���g7QL$4����p�RWj�h�|!�z�p��6L��o��l�,��|����N������U�]1y!l�*� �?������            x�3�4A#C# ����� ��      m   )   x�3�䴴0715��5�2�4�4122137�5����� ^?]         :   x�3�<<���)�Ӑ˘��1��1��6��	u�9��|��\�����=... _2�         -   x�3�v
�t���2��p����2��w	uq����� �|U      	   U   x�3�44�tt���4426513�420��5��52���2�4���*�0002532�ERe���2�4�D������%ȴ=... CR      
   P   x�]˱�0D�ڞ"$�]����D	��P ���~�a�=��{ʠK�;9�6�]���A�V�^��?��EU/C��            x������ � �            x�3�4Bc �2�4��c���� <�            x������ � �      p   �  x���M��0���)|��D�LP(�Y����%13�kXcO��)�}")J��X�Ԗ�f��!����i,��̈́B�(Y��8jz}<_�?����+P(�u��b�t��O_b�9#�WF��;HɦeO��o�����o/���`"�B�5�6����� �2ЯfP'�.ؕ���q��%����0j6h���)�]K��!�s�m��	K�j���c�j)���ZX�^(ʌ�������yk�#�U�N޿l����?Z�4�!��=����W�fTk��J'1L��(p����f�P�~$P:K�Z����H@�xT ǿf�	Z'�k)�� �hVhu�ϵ3d-|�_�$k*8j��@�8��D��Ʋ��ץA��/�GL:��u;a���`�8��e�����ퟫ�5>r6N�L��T�b�,{�|� ������~3,      q   �   x�m�[� D��bmyx�r���C,M8gtD@��`���h����b^p�R{ڱ*�f�2rj��Z��~���il��ʗ��]~r�N
/��9ּ%y���>���.�K���'�j%J�h���w��9��Z9�_��a����_)��=Mo         M   x��˱� D�ڞ����R�d��?GR��o�>��pa>��M �:�>?R�3"�:=�\4�BODr��S着�fN      `      x������ � �      r   k   x�u�1� ���E�>��.�qp���	FT �K��	�!�p'J������>�ހ�Q�C�wI�Z�U�#-J�	� �=%��OWɦC�sn�K�R�1�V�9      [      x������ � �      a      x������ � �      j      x�3����� a �         P   x�3�4B� �`�#NG��0.CaC��	��1L�U����ቮ�N�0y3�|�kP����?L�(f�Œ=... _,"�            x������ � �            x�3�4�2�4�2�4�2�4bs�=... (P         I   x�3�t����s��2��	�s�2��u
2L8}=]���}�lSN�P�0 Ì3(Rg����������� a"5         e   x�3�trrr�tTp�
utw�0003�025�v�qT�uI&�+���
!��������&F�@l���X��Z���XU���萞������������ �^,         �   x�M̱
�0 ����I��H��Z
g#�)(.PK'��v��?f34�[�c��J�F��b`���t}�;鼖��P����xTYfa�nEj2$T!����Jc���_c������?�J�9�"b         z   x�3���s��s��u�vv�Q��p��4��0�5�0�5�0���K��K-qH�M���K���2��wvr�t�qw�s��W�tu�Vp�Wpvu�8F:�8�UP���X��dT� ��$u         #   x�3�4�4B#CK]C]cΌ��D�=... H�3         _   x�U��	�@E�uRE*�42Y�f�+��C]>��MP��6R'.��z6��=p��q1u1�T�V&���ɏ��E�3����̟}�xI��         ,   x�3���	q��w�2�tvvt1�9]<����=!�=... ۠	      Y      x������ � �      Z      x������ � �         3   x�3�tusu���2�q�rq�2�t�pu�2��w������ �~	c         j   x�}λ
�0����]*=�E;���.���+ZP��!×��˸�P�dlglD��Pqpe߸5��=b�?���-ȧ3U'��q:���ɕ���պË�#��FD6o�.]         ,   x�3��uv�����2�ts�u�1�9�B�<]<��b���� ���         �   x�]�Ar� E�p
N�l��R�J� �.:�T�ԋUN���F����/�+��9\�����U7Xk��G1��&As����!� e�\�q�0r]������Ԅ���7��k�O0	G�g��7�J\�La.`2�q�����hB�2�+z�/7Hs#1L.|0��+a��΋)��e���t'�N����^ M�;�-�r��x3�	x���0�d���&�Q�]v9� �J�N���1Ey+�7����+��렵�UDi�      s   �   x�u��� Dϙb�	"�&���_�*{���wP����^dM�6x���E����~ݵ�a�.͚4�!����oZ�Ġ��p*Q6x��E ~YA=V;��\=v=��c�xV��P&��>m�����L���/H�         V   x��LA
�0:'��R�M	�[��w�e���� �Lf�\�a�6 )t��}G�7�Q�h�!PO�<ܮ�_`y�ŘB���>z�         )   x�3��v�2�tvtr��2��uqrvr����� x��          8   x�3�t�s�2�r���s�2�v
�t���2�t���V�vr	����qqq       S   m   x�}�1
�0E���H�6�U��\����ÄbU�R���4����bw�C��}=���,v#i�Q~L���r�ԉQ>�_�J+H��}��;�S�����ȳ4�j�z���s!\��:6      !      x������ � �      "   A   x�3�ts�	q�q�2��w
����
�~
A�ήΞ�~
.�
!@5�n�A�~Ξ�\1z\\\ |�f      b      x������ � �      t   �   x�}��J�@��=O�����3����	�����ˢY��&|{�KVXi��T�W	,�r ����u�j3��r��@$Er�u�es��.���z�l���w�W�������(��@�z-�rK]r���IB�	w�����؏���4̙���ݺi����]}��x,�S8$I����߭�������c8<�ӎ���ƘO�OP�      u   %   x�3��4B#4500�LI-N.M�+������ f��      x   �   x�e���0�g�)��|N��l2�$�00te`)��E�J��}���>�HX�1K: ��l4�B����yw��H�X.y(��0��&��\[a�b��''ɱ�
t�^�����c����q6Y66��u�C�]�bͽ�Lܢ-��'זϏ�(�ް�.P      y   %   x�3�4B#N#S.#0ϐ�� �3F���qqq �`      w   �  x����n�0����T��/�ol��JUX%����8�T��P����)��֥-PC�!���g<2 @����M�N�(�[�Sm�0,%B���b�o�U����*�q�+�]��8���d�(�����צ�U�N·��k�{�w�r�$ #I�aj�V�v�����'�uj��m����?�=�ҵ��Z�{]\Թ6�.�K��н{z;rf����˦��DO"]P#5aə��Wͥ�>VMb�8V�DsueK_|�R[_ۖL=
� ��)"�_i�};��^Jc	�X��?�PA�DZn���u�zs��yܻ����'D�1�UzQ6�����/�{l�10<� ��G���֏��X�150x,����l6�Qv8(�$ir�[������C��a�ò5�JF��\��ͷp��: �-� pv���֗UU���b���%�      v   P   x�3�4C#N#SΔ��d.C��1���T�(���*nVl�����eh�0�� n�1P7X��4�8%--�+F��� �*1      #   s  x�}�In�0е}
_�?)j�M������Q�q&5���%�V�Qf�,:A*[(Y����=��k7�J&IiP�P�4J�
(t�����	�dͲ~�ީ\K���bG�ME&�Ǘ�ϲM��dT�r�0�ȟ@&ϐ,(]���K�X�����-���r̽�rB�̎<)�dP£��C^����=��3� ��Ws���KT��
�AW��S���z��4)�\�������n���ANQ���T���̹�ښX-�3�"4F�Z��{9֘��Q��ؚP-QL�cRk�9iok�����<��/?���tj �A���F�CvA���cX�]��hw�yk7����AI��,��q��*�I      $   �   x�m��!DϦ�6���:�?De�쓇al`�I]_�Wj�͑��sM2��Sw)B6�MT�,~g�g	T/l/�K�q"t��]��?|$_ܜ�(�ԗv��emY'�R����m����`|����r�1�c�=�Z��A�)78%A�,�q6`m���><*oN�Ѯ���D��b��?�R�o�\J      %   4   x�ɱ� �x��� �b�1�d6�)s3~�	��l3�3�:մ�~��d      \      x������ � �      ^      x������ � �      ]      x������ � �      &   �   x���Kn�0���..��4^(���]����XLa��7z ő �C/m?��:/�y��A���#�����pyD
JGd��#��*�44Kl#�XW��-�]�H,��9D�
Gh�P�hQ5����'MM�VҠ��*iԏ��'�튭�a�=�3�����~:_nD�n���qy�?�H��$bN�@��+|�MY�#Osl0D�#�(�ɢ�v�CT�bQ�T���=�ݏT��d�Z�:����N��K      '   �  x���Mn�0���\ ����*R�ͮT%I�z����La0m$^�y�yN�6 ��@���mJ�K^c�1`��t�a��
�:�@��XW��w������D���*A���C_u�����Q ޭ�?�Q��3獲��'>q �����`a蘺)>�&1��͛��J�����˱ڤ���`p�P�Q��F�;���b��>ɗ)`���4%�}ln�p����4��,����F��|)�ݥ�`�,�0��L#�O?�,�*)��.�_��yJ��$z#	��h���؞�bO<V��@����y��妨����4��<'f�dy�\�E���,]��E�"摒�Z�DM8�[��N�2�.��9���<+,́rM2����,����U)w9N����_�t�      d      x������ � �      (      x������ � �      c      x������ � �      )   8   x�3�trw���s�2�prtu��2�t
r���2�t����u�t����� S
�      *      x������ � �      +   �  x�m�I��@E��)tk�5�^h�v��9B:��{�@�'I7F�񆶒�A�������Ϸ����-|b�P�й%l�Y��h��^�9˸!m\W��8Р4N�~b�@j`i]�\���wF�f�	O��C;��������2��+��N�Zt��.�Nj�1�r-)sޖc������F_W�J�%ˋl����&p�a��8�&��ʁ�+(P#��������~^a+��L3�~	�P���U{�	.%� M+�YW��2���l"�&X�x��C�Њ�\�z�^Q_p�#>��Z��hC]�I���f�V�}/"�B�_��^����*�u����q�Okh�	�㽾�Օ��+|�=���B�<.&�M���9�Y "{ez���C@,Ie�n��a�i�ϱp�_�����Z���e�}�|S[6����U���/j�_�G�'@C��\q�'��F��/k$��e�U14�      ,     x�eSK�0[�a�(��e��)��0ucL��#u@}p[�p�E��$���@F�P�RO,����f%�Jf��`��(i�
�t2�+�Y/����S���9g�Fi���8��y��;z�
��o�ጜaqӚE?�2?O��X6� �����nlS��������E77�}���b�,��{�<^���>�~��\�`���n�9�M�9.ǹo-y!,������Z��Dy+��k݉䲃��F�� �V��~�������      -   �   x�m�=n�0Fg�������-@<������T�"ȓ�އ�4'��H�ԍ���̠���8����:eZ���.�/���~�~�T��&|�梀JI����RA�H�ѥ�������� z���G�l�����iQ�j���_<Q|#?b���}��f��X���������F��}�C�(F��k��a��.��F�\�24���d�0������^Z�@��KnjL      .   [   x�U���0�PL�a�N/鿎�G��5b�t�I����T�%ЁV��X�)��ݑ���g�<���O�\�ëa�W�C��F�Z,ߋ�?� G         O   x�]��	�0Ekk
O�5��?��XF
���Q��kB���z.ȢO7v�&�Q���>����p$�����B����~ �      /      x������ � �      0   �  x�m��n�@��O�P�ݵ�?w9�q�x��D
�CH�đ	�����m!�	�x�[B�ʺ�.����N׀�F��g�
Tʃ�K��T&)�,K��a;t���]�r���v����5	�u�u^�>����_��a�(���i{}B
����Ko������|[��B�3��
K��No�>�8e�²B3�li�����F*N�W�È��������a��unaa���+��3���M��,��VzL�L���$̈́<�"���e����2�Vk�M�0��kܬ����O!e �|�4��O�Q;\�&8\�!�hf��h���XE������}C{�_�(��2��벲#�e�Xk�Uz9�=�*��r.U�����=~$"��	�v�.􊙆X|�֔7�4�nf�%p)>�L��RA��6�i�?�w�W�3�����_�[H�фV�첬���dTC�+O�ehOU�Y��(;�R	��q�t��j�}�R��?w�r�s29
�*n,iH��@��|�q�2��bP<IC:���dwC���}�C������&���4{$m�`USh�=��-k���5�*��hF���to��"�}{�O͟l��;]����tc\��	���;=G�����ð�﯎o��Ӵ~L'���]      1   �   x���KN�0 �u{�^���q��h�b��?ɨ�6��?�qL#�4c�H-X�xZ�<��o�����v������!��rW�<��}�./�{�;U�L���K��l��娭�Bb]!�!\&@����ZB�H>�w0E���;���,a
����zp���vR(���%��v]G8anbf��巔&���X�\����5��,�� ��e?؝O��N8�:      U   F   x�3�4ANc �2B嚠rMQ�f`.��i�e�³�(5�*�1D�s�rA��62�Q�c���� ̼�      2   :   x�3�4�44�46500�2F�9`�o�Ʒ�"\@MHC�10�2������ ��      k   �   x���MN�0���)�@���=3�
�C��q�s0	�� �EU�����<���R%���	����?�ϧ����2���B,N�L��~S3���ѫD���B��9X.�:Q�]Ű�o_�#�aRq,ٴv!̒�q\��ߊ���j*i*E��x���$��Q[���E(�0МZ�=/ɣ8�Ri�XM��^���֐e��kLoཾ��]�����.����vq\0�s��G����4� ͫ��      l   �   x���a� ��p�]��}� ;����T�mNLL��5dH.N��F�W`[ "�|�9c��7]��˞�6YC�H.&�2�Lh���%c���>涞שL��]$_��y��df�|�o�?�C�-�\w��������-�N��t���\̳ٙ;9�gl�߰�~/l5p��,�y�1� �l       3   >   x�3���sw��t�W��s��u�t��2���t�Sp�Spt����	rt�������� v�      4   ]  x���M��0���)�@\������+T%�"ݩY���1V �1�g��P�2���,!�����+TA� N:4�>�~f��ߧ�c������y8tC_]����ڱ4��{�
m04H�T�/aܩ9|u���h��J�
�%�ň�#[�*�A����3=�6-��@���)����8�`����TW�AA�Z�6�H�q85W�Jr&J�/�fp"$�Åx�`�U���c��]<�k3v�@\���BaA�$R�>�{�+^2O$'�\]��>��`@�������ݹUs�[�*-4��!����%\���/P�0� �w &� p�PI���E~�	�$>��l�n]{��ũK�w���り]$��>lɧ�K����]�h��cy�BAP�Ⅱ�B�������l'��	�%[S�O=A( �_�����((���27n� 6��6j��^��9�}����IL��=���~�N�Ze:�4_�͢��o.�8\�40R[6��:ͤ'�za�g�M�Z�;[��5���C�;�F�<���:�`����cz�'�to�T�i��p�����Anٕ��D�3}�ß�ԻOT�ٸNe�>Oԍ��)���x�k      T   �   x�u�M
�0�usIҩu�"n�".������h��>
]|i�%�F����~7�I�?�52��ү�4i������}U�C��I|�O���2��~t&�ћ�sB*�p$������F+P<�Q�����üh"fi      5   p   x�u�1� E��.����h��`��?�BL�K���ϯ��!"P�.���|h[pl��Yn�7c�!�SDm�ñ8��!O?Bt�����r����ߖ��9{D� ��9~      6   ;   x�5���0�w�K��6!ð�(H|O�%כּ�L+��ѓur��
��]��\
���3       7   b   x�m�;
�0��zr����kS���6b���C��A�)?~FQ �CL�m�W(K!6���� �7�(�sxd�h���x
)}*��2��*̪�?���; \z!D      8   (   x�3�4�� .#N#ǘ��1�4ApL9M�=... ��      9   �  x���K��0���)tTz ڹ*��T2���*5�r��FY�s��0�$�1e�_���i؊����������ڢ}g��:�jLe;���<n�����w_W��$ I@#D#%���8#����lE���mi��������s0�QþLYW_����f_�i��E�v(3(�]ojlf�ֺSu��P�D4Ta�h�%���u�˫\��}$��'1�� ����v�a70�$����D��Z4*n��f�ҽi��t��.3`�@c�h��(��G�L���L�j=p��7�L"�(.	1el��X�-GH��2�K�_��e�[�!!QB�p�����B9\����%4A���T������ ����{�d�pz{�<������ i.�ǻb&�5
��sE)�B~�"ϔ[���N�ZD�l�=�N�)UdxU"�>��MJN.�����qXxh�8[`�Y|�2O���Ԩ��]Y�]��`������p�/]���v�����ʀrD�&x���,>���\W��
���z�Y^�]]���2�(�"�ܿb0��2��G��a f��Զ�����w�{�Of����{��c���C���nӢ쯘瘔1�3��@��s�N=c�y��$��k2��RQ�c!�d^>�t 
3iq�	�U���JX$bq/x�^�
K��      g      x������ � �      h      x������ � �      :   G  x�u�Kn�@�5��`�9E�*������'H�@@ V�X�?F��r��/��e`�:τV'u�P���6�qF�9OT����>����.5��vy�)���)nT��]��(LDn욀�v�	�yre�i�r>�u��	0s_]8Q��E K�Z'=�1);ưD}�d[�،:1��k�Iz�^x��LyD�U7��;\��c����e�).�[2�]56`��9/�˹㌧<�����a:��my���r������z�ߩE7�����y[�V�~j!2���Ww�|���:�ͅʹ�q j��0�ڐ\�D�?��q��e��      ;   �  x��T�n�@<�|�� ���0��9X��lV{�K&<6d0����~����`C��Q$#���A1���=��$$��b�ҽ`�nR�s�C'�h���Y�#&�*���$�b����l��P��<#�14��%g����y��-�]!��/��cEG�6���j�x��3c5/�A�Y�)��Emp���EZ��Z����P�����¨�����'7�@�f�@6�˱�aX�ͣX�X��V����;� �X�X����
8���L�BOƟ��M����]՗�6�n�4?Mm�Y��Or9�ʣqN2�t�ޡ����6��3����|^?-כG��+�u�� T����Z��Z4Z���Zo�j]F�����*K�1.���L|M(���u[�iA�3-мV,␌�ꜭ&�8�IS�� ������bIb
f��Ǟfu��;�|~\����omi#�J֏��������	�      i      x�3�������       W      x������ � �      <      x������ � �      =      x������ � �      >      x������ � �      ?   f   x�5���0�PL���%��!'������e8I^��$ ��a�^�]�(��N��ʲ �ASo0��y1��ƨ�f}N�Heԯ^�$LQ�˟��_Ԡ_      @   �   x�3�4�<<���)��1��QO! �1���Ǉ����H��� ��8�K�R�Rs�*�s3s���s9�C<�����f;�)����E�s�����{9+��+8;F9�3�52�е45�V���2�*��=... �+]      A   �   x���;1�ھK�=��)������Z� @nFQ�2��"k�DG�� t<]Ϸ��@�h��K�4�DHH�������,A_?))KD̨��q];�E�=��Xֈy�	��R��u��Q���B.�,���g"oDy#<�m��~���B���]P| �v�w���i	QO      B      x�3��suw���2���3c���� Z9      C   !   x�3�t�Qp�t�2�t�ts�t������ C�      X      x������ � �      D   !   x�3�t��qt��2�tru������� I�D      E   +   x�3�trstqT0U�2�t�p�q�2��r��qqq ��      F   #   x�3��w	u��2�v
�t������� [(      G      x�3�t��tv�2��
�t1c���� H,      H   P   x����0�x
O�L`�G
r�(I��s`Q|q����tѺr�|���3A��"�1V��:J�C�3�dһ�AD�      I   $   x�3�ru�q���2�uwr�s�t����� ^U      J      x������ � �      _      x������ � �      K   a  x���Kn�0���)r��CjW�^8EۙU��R�'�+��"������&j��H�.e;B�5o��c���zn����\��\���i���=�o�ӹ��}u�#����Hvq�<�M�c�w�|���,W5�ٰ���K��ϒkQ.��م�v�N�� �T�$���m5K_2m��S�}�W�-�F\>{DĉS&��V�M�i�g�PUVĹ:f�R|�,��AU�i����3d�ĀR����P��7 �]����΀V���SFs%�*������;���q��7U�V���_�զ�t^��DY"�T�wT޴G�f�)	I��T�
8է*3"��VV�0�:Ѵ�JY���T�Dl��a�Nw���1�u_7��ehD�u�ش��U'b6Wd���1�ֵ��S�����aٝ׶�6ئs�$����4�ڰ~���eT�KV2,�n������w�-C�Cb�S*^�˔�M��.���AkM���R9j=���+��dm>^���r��5� ����:�|��z	���X棤*G�H��d��P�S_��E������u�ֱy�%7��6���k;�p#g]!kqV9d�����v��7�#/�      L   �   x�]���  г�	 k�K��#|� ^��O�a�i���ƞ��R���Ty��	�:��7Y�i�F��v�mS�-?v%�X�w@�n�>�s�8�ڝl[�Ǹq���8��|���:.�@� ��4}��s��� /�}9�      M   �   x����n�0D�����M��;Q�X�,�0��X�e#��#2S$�0�Vofg$h���C��k��b�LеJ"q�2���@�5C{� �Ca����o�K`�$7��+�3��]��CVLqm�։MJ)0��l��m�1����r]�?���:��=]w�Xg�EN91)���Q��h��J��AԻ��\҂¯��횧ET��}��o��~��|)UƊ��kt�      N   ]   x�3�4BNG��0.3Nc ����R��0���sa��o����L�,51��ZŌ9]��̌-`��`s#��MM`�1z\\\ wm�      O   0   x�3��urvuqVpr���2����s���2���q����� Ã	      P   +   x�3�t�qU050�2�t����q�2����s������� �(/      Q   B   x�3�4202�54�52W04�26�25�362�ptwt��4D��\F�,�L���-qi����� ��1      R      x�3�4�Bc �2�4F���qqq \��      V      x������ � �     