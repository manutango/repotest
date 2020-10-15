
--Query Carga Real v1 STAGING CAPSA

--INSERT INTO [STO].[INT_FT_LINEA_GESTION_ECONOMICA]
select
top 100
trim([cuenta contable]),
'1' as id_escenario, --'Real'
'1' as id_version, --'Final'
CONVERT(DATE,
	case when trim([Fecha de Contabilizacion]) = '43851' then '21/01/2020' 
		else trim([Fecha de Contabilizacion])
	end,103) as id_fecha,
'' as periodo, --'COMPLETAR! sale de fecha y tipo ejercicio de la empresa'
left(right(('0000' + replace(trim([Cuenta Contable]),'.','')),18),10) + '.' +
left(right(right(('0000' + replace(trim([Cuenta Contable]),'.','')),18),8),5) + '.' +
right(right(right(('0000' + replace(trim([Cuenta Contable]),'.','')),18),8),3) as unidad_contable,
left(right(('0000' + replace(trim([Cuenta Contable]),'.','')),18),10) as centro,
left(right(right(('0000' + replace(trim([Cuenta Contable]),'.','')),18),8),5) + '.' +
right(right(right(('0000' + replace(trim([Cuenta Contable]),'.','')),18),8),3) as cuenta,
substring(left(right(('0000' + replace(trim([Cuenta Contable]),'.','')),18),10),1,2) as empresa,
substring(left(right(('0000' + replace(trim([Cuenta Contable]),'.','')),18),10),3,2) as negocio,
substring(left(right(('0000' + replace(trim([Cuenta Contable]),'.','')),18),10),5,2) as division,
substring(left(right(('0000' + replace(trim([Cuenta Contable]),'.','')),18),10),7,2) as departamento,
substring(left(right(('0000' + replace(trim([Cuenta Contable]),'.','')),18),10),9,2) as actividad,
substring(left(right(('0000' + replace(trim([Cuenta Contable]),'.','')),18),10),1,2) +
substring(left(right(('0000' + replace(trim([Cuenta Contable]),'.','')),18),10),3,2) +
substring(left(right(('0000' + replace(trim([Cuenta Contable]),'.','')),18),10),5,2) as unidad_negocio,
right(right(right(('0000' + replace(trim([Cuenta Contable]),'.','')),18),8),3) as unidad_contable_origen,
'' as proyecto,
trim([Número unidad]) as activo,
'' as activo_tipo,
trim([Codigo de Art]) as articulo,
'' as almacen,
trim([Numero Cliente/Proveedor]) as ente,
trim([Nombre de Equipo]) as equipo,
'' as debito_credito,
'' as tipo_movimiento, --'COMPLETAR! sale del tipo de cuenta'
case when trim([Moneda  extranjera ]) ='' then cast(replace(trim([Moneda Local ]),',','') as float)
	 else cast(replace(trim([Moneda  extranjera ]),',','') as float)
end as monto_origen,
trim([Codigo de moneda]) as moneda_origen,
cast(replace(trim([Unidades Fisicas] ),',','') as float) as unidades_fisicas_origen,
trim([Unidades  de Medida]) as unidad_medida_origen,
ABS(case when cast(replace(trim([Unidades Fisicas] ),',','') as float) = 0 THEN 0
	ELSE
	((
		case when trim([Moneda  extranjera ]) =''
		then cast(replace(trim([Moneda Local ]),',','') as float)
		else cast(replace(trim([Moneda  extranjera ]),',','') as float)
		end
	) / cast(replace(trim([Unidades Fisicas] ),',','') as float))
	END ) as unitario_origen,
trim([Descripcion de la linea del asiento]) as desc_linea_asiento,
case when trim([Moneda  extranjera ]) = '' then 0
	 else 
		case when trim([Moneda Local ]) = '-' then 0
		else ( cast(replace(trim([Moneda Local ]),',','') as float) / cast(replace(trim([Moneda  extranjera ]),',','') as float) )
	end 
end as tc_origen_as_ARS,
'' as ponderador_polinomica_01,
'' as ponderador_polinomica_02,
'' as ponderador_polinomica_03,
'' as ponderador_polinomica_04,
'' as ponderador_polinomica_05,
cast(replace(trim([Unidades Fisicas] ),',','') as float) as unidades_fisicas_unificada, --reemplazar con el valor multiplicado con el factor real, obtenido del maestro de articulos
trim([Unidades  de Medida]) as unidad_medida_unificada, --reemplazar con lo que diga el maestro de articulos
trim([Codigo de moneda]) as moneda_consulta, --reemplazar cuando se tenga el valor real con el que se consulta
ABS(case when cast(replace(trim([Unidades Fisicas] ),',','') as float) = 0 THEN 0
ELSE
((
	case when trim([Moneda  extranjera ]) =''
	then cast(replace(trim([Moneda Local ]),',','') as float)
	else cast(replace(trim([Moneda  extranjera ]),',','') as float)
	end
) / cast(replace(trim([Unidades Fisicas] ),',','') as float))
END ) as unitario_consulta,
case when trim([Moneda  extranjera ]) =''
	then cast(replace(trim([Moneda Local ]),',','') as float)
	else cast(replace(trim([Moneda  extranjera ]),',','') as float)
end as monto_consulta,
trim([Descripcion del asiento]) as desc_asiento,
CONVERT(DATE,
	case when trim([Fecha de Contabilizacion]) = '43851' then '21/01/2020' 
		else trim([Fecha de Contabilizacion])
	end,103) as fecha_contabilizacion,
'' as fecha_recepcion_compromiso,
trim(Auxiliar) as sk_ot_ult_estado, --id_OT
trim([Tp doc OC]) as sk_tipo_doc_oc,
trim([Orden compra]) as nro_oc,
'' as linea_oc,
trim([Numero de Documento]) as nro_documento_asiento,
trim([Tipo de Documento]) as tipo_doc_asiento,
'' as estado_documento_asiento,
trim([Numero de  Batch]) as nro_batch_origen,
trim([Tipo  de Batch]) as tipo_batch_origen,
trim([Descripcion Tipo de Batch]) as Desc_batch_origen,
'CARGA_REAL' as proceso,
'1203 - BARUTTA, Hernan Andrés' as usuario_imputacion
	--into [STO].[INT_FT_LINEA_GESTION_ECONOMICA]

SELECT TOP 100 
trim([UN])+'.'+trim([CTA OBJ])+'.'+trim([CTA AUX])
,*
from DW.STI.[PVW_FT_R55_CAPSA19-20] pfrc
;




/*
TRUNCATE TABLE [STO].[FT_LINEA_GESTION_ECONOMICA]
delete from [STO].[FT_LINEA_GESTION_ECONOMICA]
DROP TABLE [STO].[FT_LINEA_GESTION_ECONOMICA]
SELECT top 100 * FROM [STO].[FT_LINEA_GESTION_ECONOMICA]

SELECT TOP 1 
[Moneda  extranjera ],
*
from DW.STO.[PVW_FT_R55_CAPSA19-20] pfrc

*/
