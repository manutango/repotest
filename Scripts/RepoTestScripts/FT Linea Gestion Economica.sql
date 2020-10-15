
/*
DROP TABLE DW.STO.FT_LINEA_GESTION_ECONOMICA ;

SELECT  
'1' as id_escenario, --'Real'
'1' as id_version, --'Final'
CONVERT(DATE,
			case when trim([Fecha de Contabilizacion]) = '43851' then '21/01/2020' 
				 else trim([Fecha de Contabilizacion])
				 end
		,103) as id_fecha,
'' as periodo, --'COMPLETAR! sale de fecha y tipo ejercicio de la empresa'
( RIGHT(('0000000000'+TRIM(UN)),10) + '.' + RIGHT(('000000'+TRIM([Cta Obj])),5) + '.' + RIGHT(('000'+TRIM([Cta Aux])),3) ) as id_unidad_contable,
RIGHT(('0000000000'+TRIM(UN)),10) as id_centro,
RIGHT(('000000'+TRIM([Cta Obj])),5) as id_cuenta_objeto,
RIGHT(('000'+TRIM([Cta Aux])),3) as id_cuenta_aux,
SUBSTRING(RIGHT(('0000000000'+TRIM(UN)),10),1,2) as id_empresa,
SUBSTRING(RIGHT(('0000000000'+TRIM(UN)),10),3,2) as id_negocio,
SUBSTRING(RIGHT(('0000000000'+TRIM(UN)),10),5,2) as id_division,
SUBSTRING(RIGHT(('0000000000'+TRIM(UN)),10),7,2) as id_departamento,
SUBSTRING(RIGHT(('0000000000'+TRIM(UN)),10),9,2) as id_actividad, 
'ND' as id_unidad_negocio, 
( RIGHT(('0000000000'+TRIM(UN)),10) + '.' + RIGHT(('000000'+TRIM([Cta Obj])),5) + '.' + RIGHT(('000'+TRIM([Cta Aux])),3) ) as id_unidad_contable_origen,
'ND' as id_proyecto, 
ISNULL(TRIM([Número unidad]),'ND') as id_activo, 
'ND' as id_activo_tipo, 
ISNULL(TRIM([Codigo de Art]),'ND') as id_articulo, 
'ND' as id_almacen,
ISNULL(TRIM([Numero Cliente/Proveedor]),'ND') as id_ente,
ISNULL(TRIM([Nombre de Equipo]),'ND') as id_equipo, 
'ND' as debito_credito,
'' as tipo_movimiento, --'COMPLETAR! sale del tipo de cuenta'
case when trim([ Moneda  extranjera ]) ='' 
	 then cast(replace(trim([ Moneda Local ]),',','') as float)
	 else cast(replace(trim([ Moneda  extranjera ]),',','') as float)
	 end as monto_origen,
TRIM([Codigo de moneda]) as id_moneda_origen,
cast(replace(trim([Unidades Fisicas] ),',','') as float) as unidades_fisicas_origen, 
TRIM([Unidades  de Medida]) as id_unidad_medida_origen,
ABS(
	case when cast(replace(trim([Unidades Fisicas] ),',','') as float) = 0 
		 THEN 0
		 ELSE (
		 		(
				case when trim([ Moneda  extranjera ]) =''
					 then cast(replace(trim([ Moneda Local ]),',','') as float)
					 else cast(replace(trim([ Moneda  extranjera ]),',','') as float)
					 end
				) 
				/ cast(replace(trim([Unidades Fisicas] ),',','') as float)
			  )
		 END 
	) as unitario_origen,
TRIM([Descripcion de la linea del asiento]) as desc_linea_asiento,
case when trim([ Moneda  extranjera ]) = '' 
	 then 0
	 else 
		case when trim([ Moneda Local ]) = '-' 
			 then 0
			 else ( cast(replace(trim([ Moneda Local ]),',','') as float) / cast(replace(trim([ Moneda  extranjera ]),',','') as float) )
			 end 
	 end as tc_origen_as_ARS,
0 as ponderador_polinomica_01,
0 as ponderador_polinomica_02,
0 as ponderador_polinomica_03,
0 as ponderador_polinomica_04,
0 as ponderador_polinomica_05,
cast(replace(trim([Unidades Fisicas] ),',','') as float) as unidades_fisicas_unificada, --reemplazar con el valor multiplicado con el factor real, obtenido del maestro de articulos
TRIM([Unidades  de Medida]) as id_unidad_medida_unificada, --reemplazar con lo que diga el maestro de articulos
TRIM([Codigo de moneda]) as id_moneda_consulta, --reemplazar cuando se tenga el valor real con el que se consulta
ABS(
	case when cast(replace(trim([Unidades Fisicas] ),',','') as float) = 0 
		 THEN 0
		 ELSE (
		 		(
				case when trim([ Moneda  extranjera ]) =''
					 then cast(replace(trim([ Moneda Local ]),',','') as float)
					 else cast(replace(trim([ Moneda  extranjera ]),',','') as float)
					 end
				) 
				/ cast(replace(trim([Unidades Fisicas] ),',','') as float)
			  )
		 END 
	) as unitario_consulta,
case when trim([ Moneda  extranjera ]) =''
	 then cast(replace(trim([ Moneda Local ]),',','') as float)
	 else cast(replace(trim([ Moneda  extranjera ]),',','') as float)
	 end as monto_consulta,
TRIM([Descripcion del asiento]) as desc_asiento,
CONVERT(DATE,
			case when trim([Fecha de Contabilizacion]) = '43851' then '21/01/2020' 
				 else trim([Fecha de Contabilizacion])
				 end
		,103) as id_fecha_contabilizacion,
'' as id_fecha_recepcion_compromiso,
trim(Auxiliar) as id_ot_ult_estado, 
trim([Tp doc OC]) as id_tipo_doc_oc,
trim([Orden compra]) as nro_oc,
'' as linea_oc,
trim([Numero de Documento]) as nro_documento_asiento,
trim([Tipo de Documento]) as id_tipo_doc_asiento,
'' as estado_documento_asiento,
trim([Numero de  Batch]) as nro_batch_origen,
trim([Tipo  de Batch]) as tipo_batch_origen,
trim([Descripcion Tipo de Batch]) as desc_batch_origen,
'CARGA_REAL' as id_proceso,
'1203' as id_usuario_imputacion --1203 - BARUTTA, Hernan Andrés
into DW.STO.FT_LINEA_GESTION_ECONOMICA 
FROM DW.STI.[PVW_FT_R55_CAPEX19-20]
WHERE 1=1 
;
*/

/*
SELECT COUNT(*) FROM DW.STI.[PVW_FT_R55_CAPEX19-20]; -- 46254
SELECT COUNT(*) FROM DW.STO.FT_LINEA_GESTION_ECONOMICA ; -- 46254
SELECT top 100 * FROM DW.STO.FT_LINEA_GESTION_ECONOMICA ;
*/


----------------
--TRUNCATE TABLE DW.Modelo_Capsa.FT_LINEA_GESTION_ECONOMICA

--INSERT FACT

INSERT INTO DW.Modelo_Capsa.FT_LINEA_GESTION_ECONOMICA
select
--top 1000
ESC.sk_escenario,
VER.sk_version,
T.sk_fecha,
PER.sk_periodo, 
isnull(UC.sk_unidad_contable,-3) as sk_unidad_contable,
CEN.sk_centro,
isnull(CUE.sk_cuenta,-3) as sk_cuenta,
EMP.sk_empresa,
NEG.sk_negocio,
DIVI.sk_division,
DEP.sk_departamento,
ACT.sk_actividad,
UNG.sk_unidad_negocio,
isnull(UC_ORI.sk_unidad_contable,-3) as sk_unidad_contable_origen,
PROY.sk_proyecto,
isnull(ACTI.sk_activo,-3) as sk_activo,
-3 as sk_activo_tipo, --completar
isnull(ART.sk_articulo,-3) as sk_articulo,
ALMA.sk_almacen,
isnull(ENT.sk_ente,-3) as sk_ente,
EQUI.sk_equipo,
F.debito_credito,
F.tipo_movimiento,
F.monto_origen,
MON_ORIGEN.sk_moneda as sk_moneda_origen,
F.unidades_fisicas_origen,
isnull(UNI_ORIGEN.sk_unidad,-3) as sk_unidad_medida_origen,
F.unitario_origen,
F.desc_linea_asiento,
F.tc_origen_as_ARS,
F.ponderador_polinomica_01,
F.ponderador_polinomica_02,
F.ponderador_polinomica_03,
F.ponderador_polinomica_04,
F.ponderador_polinomica_05,
F.unidades_fisicas_unificada,
isnull(UNIF.sk_unidad,-3) as sk_unidad_medida_unificada,
MON_CONSULTA.sk_moneda as sk_moneda_consulta,
F.unitario_consulta,
F.monto_consulta,
F.desc_asiento,
FECHCONT.sk_fecha as sk_fecha_contabilizacion,
'' as sk_fecha_recepcion_compromiso,
F.id_ot_ult_estado as id_ot, 
isnull(TDOC.sk_tipo_documento,-3) as sk_tipo_doc_oc,
F.nro_oc,
'' as linea_oc,
F.nro_documento_asiento,
isnull(TDASIEN.sk_tipo_documento,-3) as sk_tipo_documento_asiento,
'' as estado_documento_asiento,
F.nro_batch_origen,
F.tipo_batch_origen,
F.desc_batch_origen,
PRO.sk_proceso,
ENTEIMP.sk_ente as sk_usuario_imputacion
--into DW.STO.tmp_ftge
FROM DW.STO.FT_LINEA_GESTION_ECONOMICA F
LEFT JOIN DW.modelo_capsa.DT_ESCENARIO ESC ON F.id_escenario = ESC.id_escenario
LEFT JOIN DW.modelo_capsa.DT_VERSION VER ON F.id_version = VER.id_version
LEFT JOIN DW.modelo_capsa.DT_FECHA T ON F.id_fecha = T.fecha
LEFT JOIN DW.modelo_capsa.DT_FECHA FECHCONT ON F.id_fecha_contabilizacion = FECHCONT.fecha
LEFT JOIN DW.modelo_capsa.DT_UNIDAD_CONTABLE UC ON F.id_unidad_contable = UC.id_unidad_contable
LEFT JOIN DW.modelo_capsa.DT_UNIDAD_CONTABLE UC_ORI ON F.id_unidad_contable_origen = UC_ORI.id_unidad_contable
LEFT JOIN DW.modelo_capsa.DT_CENTRO CEN ON F.id_centro = CEN.id_centro
LEFT JOIN DW.modelo_capsa.DT_CUENTA CUE ON F.id_cuenta_objeto = CUE.id_cuenta_obj and F.id_cuenta_aux = CUE.id_cuenta_aux
LEFT JOIN DW.modelo_capsa.DT_EMPRESA EMP ON F.id_empresa = EMP.id_empresa
LEFT JOIN DW.modelo_capsa.DT_NEGOCIO NEG ON F.id_negocio= NEG.id_negocio
LEFT JOIN DW.modelo_capsa.DT_DIVISION DIVI ON F.id_division= DIVI.id_division
LEFT JOIN DW.modelo_capsa.DT_DEPARTAMENTO DEP ON F.id_departamento= DEP.id_departamento
LEFT JOIN DW.modelo_capsa.DT_ACTIVIDAD ACT ON F.id_actividad = ACT.id_actividad
LEFT JOIN DW.modelo_capsa.DT_MONEDA MON_CONSULTA ON F.id_moneda_origen = MON_CONSULTA.id_moneda
LEFT JOIN DW.modelo_capsa.DT_MONEDA MON_ORIGEN ON F.id_moneda_origen = MON_ORIGEN.id_moneda
LEFT JOIN DW.modelo_capsa.DT_TIPO_DOCUMENTO TDOC ON F.id_tipo_doc_oc = TDOC.id_tipo_documento
LEFT JOIN DW.modelo_capsa.DT_TIPO_DOCUMENTO TDASIEN ON F.id_tipo_doc_asiento = TDASIEN.id_tipo_documento
LEFT JOIN DW.modelo_capsa.DT_UNIDAD UNI_ORIGEN ON F.id_unidad_medida_origen = UNI_ORIGEN.id_unidad
LEFT JOIN DW.modelo_capsa.DT_UNIDAD UNIF ON F.id_unidad_medida_unificada = UNIF.id_unidad
LEFT JOIN DW.modelo_capsa.DT_ENTE ENT ON  F.id_ente = ENT.id_ente
LEFT JOIN DW.modelo_capsa.DT_ENTE ENTEIMP ON F.id_usuario_imputacion = ENTEIMP.id_ente 
LEFT JOIN DW.modelo_capsa.DT_ARTICULO ART ON  F.id_articulo = ART.id_articulo
LEFT JOIN DW.modelo_capsa.DT_ALMACEN ALMA ON  F.id_almacen = ALMA.id_almacen
LEFT JOIN DW.modelo_capsa.DT_PERIODO PER ON PER.tipo_ejercicio = EMP.tipo_ejercicio and PER.sk_mes = T.añomes 
LEFT JOIN DW.modelo_capsa.CT_PROCESO PRO ON F.id_proceso = PRO.id_proceso
LEFT JOIN DW.[modelo_capsa].[DT_UNIDAD_NEGOCIO] UNG ON -2 = UNG.sk_unidad_negocio --F.id_unidad_negocio = UNG.id_unidad_negocio
LEFT JOIN DW.[modelo_capsa].[DT_PROYECTO] PROY ON F.id_proyecto = PROY.id_proyecto
LEFT JOIN DW.[modelo_capsa].[DT_ACTIVO] ACTI ON F.id_activo = ACTI.id_activo
LEFT JOIN DW.[modelo_capsa].[DT_EQUIPO] EQUI ON 'ND' = EQUI.id_equipo
;






/*

SELECT * FROM [modelo_capsa].[DT_UNIDAD_NEGOCIO]
WHERE SK_UNIDAD_NEGOCIO = -2

select * from [modelo_capsa].[DT_PROYECTO]
select * from [modelo_capsa].[DT_ACTIVO]

select * from [modelo_capsa].[DT_EQUIPO] --cuadrilla
where desc_equipo like '%TUR%'



*/





