
ALTER PROC [STO].[SP_FT_CONTROLES_OIL_GAS_INY] AS

BEGIN


/*****************************************************************************************************************/
/** SP que carga la tabla de STO para datos de CONTROLES INYECCI�N provenientes de SGO CIV 					**/
/*****************************************************************************************************************/


/* Limpieza de tabla de STO */
TRUNCATE TABLE DW.STO.FT_CONTROLES_OIL_GAS_INY;


/* Inserci�n de datos de origen SGO_CONTROLES_PRODUCCION */
INSERT INTO DW.STO.FT_CONTROLES_OIL_GAS_INY
(
id_escenario_version, id_fecha, id_periodo, id_unidad_negocio, id_empresa, id_grupo_empresa, id_ubicacion, id_activo, id_pozo_sgo, id_pozo_dw, id_pozo, id_area_dw, 
id_campa�a, id_proceso, id_control, caudal_agua_inyectada, capitulo_iv, neta_asociada, dias_sin_control, diferencia_control_anterior, diferencia_agua_inyectada_programada, 
presion_satelite, presion_boca_pozo, presion_casing, caudal_objetivo, caudal_programado
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
	A.id_pozo_dw,
	PO.id_pozo,	
	A.id_area_dw,
	isnull(CASE WHEN left(REPLACE(PER.id_ejercicio_grupo,'Ej',''),2) in ('18','19') THEN 'ND' ELSE 'C'+right(REPLACE(PER.id_ejercicio_grupo,'Ej',''),2) END,'ND') as id_campa�a,
	'CARGA_REAL_CONTROLES_INYECCI�N' as id_proceso,
	cast(A.ID_AREA_DW as varchar)  +'-'+  cast(A.ID_POZO_DW as varchar)  +'-'+ cast(cast(A.fecha as date) as varchar)  +'-'+  cast(A.ID_POZO_SGO as varchar) +'-'+
	cast(ROW_NUMBER() OVER(ORDER BY A.ID_AREA_DW, A.ID_POZO_DW, A.FECHA, A.ID_POZO_SGO) as varchar) as id_control,
	A.caudal_agua_inyectada,
	A.capitulo_iv,
	A.neta_asociada,
	A.dias_sin_control,
	A.diferencia_control_anterior,
	A.diferencia_agua_inyectada_programada,
	A.presion_satelite,
	A.presion_boca_pozo,
	A.presion_casing,
	A.caudal_objetivo,
	A.caudal_programado		 	
FROM DW.staging_in.SGO_CONTROLES_INYECCION A
LEFT OUTER JOIN DW.STO.DT_FECHA DF
ON A.FECHA = DF.FECHA
LEFT OUTER JOIN DW.STO.DT_POZO PO
ON A.id_pozo_dw = PO.ID_POZO_DW AND A.ID_AREA_DW = PO.id_area --AND A.id_pozo_sgo = PO.cod_pozo
LEFT OUTER JOIN DW.staging_aux.FIX_AREAS_UNIDADES_NEGOCIOS UD ON UD.id_area_sgo = A.ID_AREA_DW AND UD.id_gerencia_operativa = PO.id_gerencia_operativa
LEFT OUTER JOIN dw.STO.DT_UNIDAD_NEGOCIO UN
ON UD.id_unidad_negocio = UN.id_unidad_negocio
LEFT OUTER JOIN (SELECT nombre_activo, MIN(id_activo) as id_activo
				 FROM DW.STO.DT_ACTIVO WHERE desc_activo NOT LIKE '%NO USAR%' GROUP BY nombre_activo) DA --29545
ON PO.id_pozo_jde = DA.nombre_activo
LEFT OUTER JOIN DW.STO.DT_EMPRESA EMP
ON UN.id_empresa = EMP.id_empresa
LEFT OUTER JOIN (SELECT id_mes, id_periodo, tipo_ejercicio, id_ejercicio_grupo FROM DW.STO.DT_PERIODO WHERE id_ejercicio_subgrupo is null) PER
ON PER.id_mes = DF.a�omes AND PER.tipo_ejercicio = EMP.tipo_ejercicio
LEFT OUTER JOIN DW.STO.DT_GRUPO_EMPRESA GEMP
ON GEMP.id_empresa = EMP.id_empresa AND A.FECHA BETWEEN GEMP.fecha_desde and isnull(GEMP.fecha_hasta,getdate())
LEFT OUTER JOIN DW.STO.DT_UBICACION UBI
ON UBI.id_ubicacion = PO.id_zona_sgo AND UBI.id_area = PO.id_area AND UBI.desc_area = PO.desc_area
--WHERE A.ID_POZO_DW = 12277
;


END








