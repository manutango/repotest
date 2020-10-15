
ALTER PROC [STO].[SP_FT_CONTROLES_OIL_GAS_PROD] AS

BEGIN


/*****************************************************************************************************************/
/** SP que carga la tabla de STO para datos de CONTROLES PRODUCCIÓN provenientes de SGO CIV 					**/
/*****************************************************************************************************************/


/* Limpieza de tabla de STO */
TRUNCATE TABLE DW.STO.FT_CONTROLES_OIL_GAS_PROD;


/* Inserción de datos de origen SGO_CONTROLES_PRODUCCION */
INSERT INTO DW.STO.FT_CONTROLES_OIL_GAS_PROD
(
id_escenario_version, id_fecha, id_periodo, id_unidad_negocio, id_empresa, id_grupo_empresa, id_ubicacion, id_activo, id_pozo_sgo, id_pozo_dw, id_pozo, id_area_dw, 
id_campaña, id_proceso, id_control, duracion_control_petroleo, tipo_control_petroleo, produccion_bruto, produccion_semi_neto, produccion_agua, procentaje_agua, 
duracion_control_gas, tipo_control_gas, duracion_control_gas_lift, tipo_control_gas_lift, caudal_gas_lift, duracion_control_asistencia_agua, tipo_control_asistencia_agua, 
caudal_asistencia_agua, produccion_gas, capitulo_iv, control_gas_coordinado_petroleo, control_gas_lift_coordinado_petroleo, potencial_bruto, potencial_semi_neto, 
potencial_gas, potencial_gas_lift, potencial_sugerido_bruto, potencial_sugerido_semi_neto, potencial_bruto_agua, dias_sin_control, diferencia_bruto_produccion_potencial, 
diferencia_semi_neto_produccion_potencial, diferencia_gas_produccion_potencial, id_antiguedad, metodo_control
)
SELECT
--top 100
	'Real_Final' as id_escenario_version,
	DF.id_fecha as id_fecha,
	isnull(PER.id_periodo,'ND') as id_periodo,
	isnull(UD.id_unidad_negocio,'ND') as id_unidad_negocio,
	isnull(UN.id_empresa,'ND') as id_empresa,
	isnull(GEMP.id_compuesto_grempfec,'ND') as id_grupo_empresa,
	isnull(UBI.id_ubicacion,'ND') as id_ubicacion,
	isnull(DA.id_activo,'ND') as id_activo,
	A.id_pozo_sgo,
	A.id_pozo,
	PO.id_pozo,
	A.id_area_dw,
	isnull(CASE WHEN left(REPLACE(PER.id_ejercicio_grupo,'Ej',''),2) in ('18','19') THEN 'ND' ELSE 'C'+right(REPLACE(PER.id_ejercicio_grupo,'Ej',''),2) END,'ND') as id_campaña,
	'CARGA_REAL_CONTROLES_PRODUCCIÓN' as id_proceso,
	cast(A.ID_AREA_DW as varchar)  +'-'+  cast(A.ID_POZO as varchar)  +'-'+  cast(cast(A.fecha as date) as varchar)  +'-'+  cast(A.ID_POZO_SGO as varchar) +'-'+
	cast(ROW_NUMBER() OVER(ORDER BY A.ID_AREA_DW, A.ID_POZO, A.FECHA, A.ID_POZO_SGO) as varchar) as id_control,	
	A.duracion_control_petroleo,
	A.tipo_control_petroleo,
	A.produccion_bruto,
	A.produccion_semi_neto,
	A.produccion_agua,
	A.procentaje_agua,
	A.duracion_control_gas,
	A.tipo_control_gas,
	A.duracion_control_gas_lift,
	A.tipo_control_gas_lift,
	A.caudal_gas_lift,
	A.duracion_control_asistencia_agua,
	A.tipo_control_asistencia_agua,
	A.caudal_asistencia_agua,
	A.produccion_gas,
	A.capitulo_iv,
	A.control_gas_coordinado_petroleo,
	A.control_gas_lift_coordinado_petroleo,
	A.potencial_bruto,
	A.potencial_semi_neto,
	A.potencial_gas,
	A.potencial_gas_lift,
	A.potencial_sugerido_bruto,
	A.potencial_sugerido_semi_neto,
	A.potencial_bruto_agua,
	A.dias_sin_control,
	A.diferencia_bruto_produccion_potencial,
	A.diferencia_semi_neto_produccion_potencial,
	A.diferencia_gas_produccion_potencial,
	A.id_antiguedad,
	A.metodo_control	
FROM DW.staging_in.SGO_CONTROLES_PRODUCCION A
LEFT OUTER JOIN DW.STO.DT_FECHA DF
ON A.FECHA = DF.FECHA
LEFT OUTER JOIN DW.STO.DT_POZO PO
ON A.ID_POZO = PO.ID_POZO_DW AND A.ID_AREA_DW = PO.id_area
LEFT OUTER JOIN DW.staging_aux.FIX_AREAS_UNIDADES_NEGOCIOS UD ON UD.id_area_sgo = A.ID_AREA_DW AND UD.id_gerencia_operativa = PO.id_gerencia_operativa
LEFT OUTER JOIN dw.STO.DT_UNIDAD_NEGOCIO UN
ON UD.id_unidad_negocio = UN.id_unidad_negocio
LEFT OUTER JOIN (SELECT nombre_activo, MIN(id_activo) as id_activo
				 FROM DW.STO.DT_ACTIVO WHERE desc_activo NOT LIKE '%NO USAR%' GROUP BY nombre_activo) DA --29545
ON PO.id_pozo_jde = DA.nombre_activo
LEFT OUTER JOIN DW.STO.DT_EMPRESA EMP
ON UN.id_empresa = EMP.id_empresa
LEFT OUTER JOIN (SELECT id_mes, id_periodo, tipo_ejercicio, id_ejercicio_grupo FROM DW.STO.DT_PERIODO WHERE id_ejercicio_subgrupo is null) PER
ON PER.id_mes = DF.añomes AND PER.tipo_ejercicio = EMP.tipo_ejercicio
LEFT OUTER JOIN DW.STO.DT_GRUPO_EMPRESA GEMP
ON GEMP.id_empresa = EMP.id_empresa AND A.FECHA BETWEEN GEMP.fecha_desde and isnull(GEMP.fecha_hasta,getdate())
LEFT OUTER JOIN DW.STO.DT_UBICACION UBI
ON UBI.id_ubicacion = PO.id_zona_sgo AND UBI.id_area = PO.id_area AND UBI.desc_area = PO.desc_area
--where A.id_pozo = 19442 and A.fecha = '2017-06-18 00:00:00'
;


END








