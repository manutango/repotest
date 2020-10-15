
--Query Carga FACT Real v1

--INSERT INTO [modelo_capsa].[FT_LINEA_GESTION_ECONOMICA]

--CAPEX
select
top 100
	ESC.sk_escenario,
	VER.sk_version,
	T.sk_fecha,
	-1 as sk_periodo, --'COMPLETAR! sale de fecha y tipo ejercicio de la empresa' as periodo,
	isnull(UC.sk_unidad_contable,-2),
	CEN.sk_centro,
	isnull(CUE.sk_cuenta,-2) as sk_cuenta,
	EMP.sk_empresa,
	NEG.sk_negocio,
	DIVI.sk_division,
	DEP.sk_departamento,
	ACT.sk_actividad,
	-2 as unidad_negocio,--completar desambiguación
	isnull(UC.sk_unidad_contable,-2) as sk_unidad_contable_origen,
	-2 as proyecto, --completar
	-2 as activo,
	-2 as activo_tipo, --completar
	isnull(ART.sk_articulo,-2) as sk_articulo,
	isnull(ALMA.sk_almacen,-2) as sk_almacen,
	isnull(ENT.sk_ente,-2),
	-2 equipo, --cuadrillas
	0 as debito_credito, --Debe o Haber
	-2 as tipo_movimiento, --completar
	monto_origen,
	MON_ORIGEN.sk_moneda as sk_moneda_origen,
	unidades_fisicas_origen,
	isnull(UNI.sk_unidad,-2) as sk_unidad_medida_origen,
	unitario_origen,
	desc_linea_asiento,
	tc_origen_as_ARS,
	0 ponderador_polinomica_01,
	0 ponderador_polinomica_02,
	0 ponderador_polinomica_03,
	0 ponderador_polinomica_04,
	0 ponderador_polinomica_05,
	unidades_fisicas_unificada,
	isnull(UNI2.sk_unidad,-2) as sk_unidad_medida_unificada,
	MON.sk_moneda as moneda_consulta,
	unitario_consulta,
	monto_consulta,
	desc_asiento,
	fecha_contabilizacion,
	'' as fecha_recepcion_compromiso,
	sk_ot_ult_estado, --id_OT
	isnull(TIPODOC2.sk_tipo_documento_asiento,-2) as sk_tipo_doc_oc,
	nro_oc,
	'' as linea_oc,
	nro_documento_asiento,
	isnull(TIPODOC.sk_tipo_documento_asiento,-2) as sk_tipo_documento_asiento,
	'' as estado_documento_asiento,
	nro_batch_origen,
	tipo_batch_origen,
	Desc_batch_origen,
	PRO.sk_proceso,
	ENTUSUA.sk_ente as sk_usuario_imputacion
from [STO].[INT_FT_LINEA_GESTION_ECONOMICA] F
LEFT JOIN [modelo_capsa].[DT_ESCENARIO] ESC ON F.id_escenario = ESC.id_escenario
LEFT JOIN [modelo_capsa].[DT_VERSION] VER ON F.id_version = VER.id_version
LEFT JOIN [modelo_capsa].[DT_FECHA] T ON F.id_fecha = T.fecha
LEFT JOIN [modelo_capsa].[DT_UNIDAD_CONTABLE] UC ON F.unidad_contable = UC.id_unidad_contable --##### Corregir Dim
LEFT JOIN [modelo_capsa].[DT_CENTRO] CEN ON F.centro = CEN.id_centro
LEFT JOIN [modelo_capsa].[DT_CUENTA] CUE ON F.cuenta = CUE.id_cuenta_obj+'.'+CUE.id_cuenta_aux
LEFT JOIN [modelo_capsa].[DT_EMPRESA] EMP ON F.empresa = EMP.id_empresa
LEFT JOIN [modelo_capsa].[DT_NEGOCIO] NEG ON F.negocio= NEG.id_negocio
LEFT JOIN [modelo_capsa].[DT_DIVISION] DIVI ON F.division= DIVI.id_division
LEFT JOIN [modelo_capsa].[DT_DEPARTAMENTO] DEP ON F.departamento= DEP.id_departamento
LEFT JOIN [modelo_capsa].[DT_ACTIVIDAD] ACT ON F.actividad = ACT.id_actividad
LEFT JOIN [modelo_capsa].[DT_MONEDA] MON ON F.moneda_origen = MON.id_moneda
LEFT JOIN [modelo_capsa].[DT_MONEDA] MON_ORIGEN ON F.moneda_origen = MON_ORIGEN.id_moneda
LEFT JOIN [modelo_capsa].[DT_TIPO_DOCUMENTO] TIPODOC ON F.sk_tipo_doc_oc = TIPODOC.id_tipo_documento_asiento
LEFT JOIN [modelo_capsa].[DT_TIPO_DOCUMENTO] TIPODOC2 ON F.tipo_doc_asiento = TIPODOC.id_tipo_documento_asiento
LEFT JOIN [modelo_capsa].[DT_UNIDAD] UNI ON trim(F.unidad_medida_origen) = trim(UNI.id_unidad)
LEFT JOIN [modelo_capsa].[DT_UNIDAD] UNI2 ON trim(F.unidad_medida_unificada) = trim(UNI2.id_unidad)
LEFT JOIN [modelo_capsa].[CT_PROCESO] PRO ON F.proceso = PRO.id_proceso
LEFT JOIN [modelo_capsa].[DT_ENTE] ENTUSUA ON '1203' = ENTUSUA.id_ente --BARUTTA, Hernan Andrés
LEFT JOIN [modelo_capsa].[DT_ENTE] ENT ON  F.ente = ENT.id_ente
LEFT JOIN [modelo_capsa].[DT_ARTICULO] ART ON  F.articulo = ART.id_articulo
LEFT JOIN [modelo_capsa].[DT_ALMACEN] ALMA ON  F.almacen = ALMA.id_almacen
--WHERE trim(F.unidad_contable) = '0201420000.41101.100'
--WHERE F.articulo = 'TOADVSADES014'
;





/*

select distinct tipo_movimiento
from [STO].[INT_FT_LINEA_GESTION_ECONOMICA] F
where tipo_movimiento <> ''


SELECT * FROM [modelo_capsa].[DT_ALMACEN]



SELECT DISTINCT articulo
from [STO].[INT_FT_LINEA_GESTION_ECONOMICA]
WHERE articulo NOT IN (SELECT DISTINCT ID_ARTICULO FROM [modelo_capsa].[DT_ARTICULO])


WHERE ID_ARTICULO = 'TOADVSADES014'





isnull(UNI2.sk_unidad,-2) as sk_unidad_medida_unificada,

--SELECT * FROM [modelo_capsa].[DT_UNIDAD]
select * from [modelo_capsa].[DT_TIPO_DOCUMENTO]

SELECT * FROM [modelo_capsa].[CT_PROCESO]

select * from [modelo_capsa].[DT_ENTE]
where id_ente = '1203'

select * from [modelo_capsa].[FT_LINEA_GESTION_ECONOMICA]

select id_unidad_contable, count(*)
from [modelo_capsa].[DT_UNIDAD_CONTABLE]
group by id_unidad_contable
order by 2 desc


select *
from [modelo_capsa].[DT_UNIDAD_CONTABLE]
where id_unidad_contable = '0200000000.51502.000'

*/
