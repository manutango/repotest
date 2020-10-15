

ALTER PROC [STO].[SP_FT_PRODUCCION_OIL_GAS_PROD] AS

BEGIN


/*****************************************************************************************************************/
/** SP que carga la tabla de STO para datos de Producción provenientes de SGO CIV 								**/
/*****************************************************************************************************************/


/* Limpieza de tabla de STO */
TRUNCATE TABLE DW.STO.FT_PRODUCCION_OIL_GAS_PROD_1;


/* Inserción de datos de origen BISGO_PRODUCCIONCIV */
INSERT INTO DW.STO.FT_PRODUCCION_OIL_GAS_PROD_1
(
id_escenario_version, id_fecha, id_periodo, id_unidad_negocio, id_empresa, id_grupo_empresa, id_ubicacion, id_proyecto, id_activo, id_pozo_sgo, id_pozo_dw, 
ID_AREA_SGO, id_campaña, id_proceso,
PROD_PETROLEO_CIV, PROD_GAS_CIV, PROD_AGUA_CIV, PROD_PETROLEO_CIV_TEP, PROD_PETROLEO_CIV_CALENDARIO, PROD_GAS_CIV_TEP, 
PROD_GAS_CIV_CALENDARIO, PROD_AGUA_CIV_TEP, PROD_AGUA_CIV_CALENDARIO, PROD_BRUTA_CM, PROD_SN_CM, PROD_NETA_CM, PROD_GAS_CM, PROD_AGUA_CM, PROD_BRUTA_CM_TEP, 
PROD_SN_CM_TEP, PROD_NETA_CM_TEP, PROD_GAS_CM_TEP, PROD_AGUA_CM_TEP, PROD_BRUTA_CM_CAL, PROD_SN_CM_CAL, PROD_NETA_CM_CAL, PROD_GAS_CM_CAL, PROD_AGUA_CM_CAL, 
TEP, TEP_DIA, PRONOSTICO_BRUTA, PRONOSTICO_NETA, PROD_GAS9300CIV, PROD_GAS9300CIV_CAL, PROD_GAS9300CIV_TEP, PRODUCCION_BASE, ID_POZO, PROD_BRUTA_CIV
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
	'ND' as id_proyecto,
	isnull(DA.id_activo,'ND') as id_activo,
	A.ID_POZO_SGO,
	A.ID_POZO_DW,
	A.ID_AREA_SGO,
	isnull(CASE WHEN left(REPLACE(PER.id_ejercicio_grupo,'Ej',''),2) in ('18','19') THEN 'ND' ELSE 'C'+right(REPLACE(PER.id_ejercicio_grupo,'Ej',''),2) END,'ND') as id_campaña,
	'CARGA_REAL_PRODUCCIÓN' as id_proceso,	
	PROD_PETROLEO_CIV,
	PROD_GAS_CIV,
	PROD_AGUA_CIV,
	PROD_PETROLEO_CIV_TEP,
	PROD_PETROLEO_CIV_CALENDARIO,
	PROD_GAS_CIV_TEP,
	PROD_GAS_CIV_CALENDARIO,
	PROD_AGUA_CIV_TEP,
	PROD_AGUA_CIV_CALENDARIO,
	PROD_BRUTA_CM,
	PROD_SN_CM,
	PROD_NETA_CM,
	PROD_GAS_CM,
	PROD_AGUA_CM,
	PROD_BRUTA_CM_TEP,
	PROD_SN_CM_TEP,
	PROD_NETA_CM_TEP,
	PROD_GAS_CM_TEP,
	PROD_AGUA_CM_TEP,
	PROD_BRUTA_CM_CAL,
	PROD_SN_CM_CAL,
	PROD_NETA_CM_CAL,
	PROD_GAS_CM_CAL,
	PROD_AGUA_CM_CAL,
	TEP,
	TEP_DIA,
	PRONOSTICO_BRUTA,
	PRONOSTICO_NETA,
	PROD_GAS9300CIV,
	PROD_GAS9300CIV_CAL,
	PROD_GAS9300CIV_TEP,	
	-1 as PRODUCCION_BASE,
	PO.ID_POZO,
	PROD_BRUTA_CIV = PROD_PETROLEO_CIV + PROD_AGUA_CIV	
FROM DW.staging_in.BISGO_PRODUCCIONCIV A
LEFT OUTER JOIN DW.STO.DT_POZO PO
ON A.ID_POZO_DW = PO.ID_POZO_DW AND A.ID_AREA_SGO = PO.id_area --AND A.ID_POZO_SGO = PO.cod_pozo
LEFT OUTER JOIN DW.staging_aux.FIX_AREAS_UNIDADES_NEGOCIOS UD ON UD.id_area_sgo = A.ID_AREA_SGO AND UD.id_gerencia_operativa = PO.id_gerencia_operativa
LEFT OUTER JOIN dw.STO.DT_UNIDAD_NEGOCIO UN
ON UD.id_unidad_negocio = UN.id_unidad_negocio 
LEFT OUTER JOIN (SELECT nombre_activo, MIN(id_activo) as id_activo
				 FROM DW.STO.DT_ACTIVO WHERE desc_activo NOT LIKE '%NO USAR%' GROUP BY nombre_activo) DA --29545
ON PO.id_pozo_jde = DA.nombre_activo
LEFT OUTER JOIN DW.STO.DT_FECHA DF
ON A.FECHA = DF.FECHA
LEFT OUTER JOIN DW.STO.DT_EMPRESA EMP
ON UN.id_empresa = EMP.id_empresa
LEFT OUTER JOIN (SELECT id_mes, id_periodo, tipo_ejercicio, id_ejercicio_grupo FROM DW.STO.DT_PERIODO WHERE id_ejercicio_subgrupo is null) PER
ON PER.id_mes = DF.añomes AND PER.tipo_ejercicio = EMP.tipo_ejercicio
LEFT OUTER JOIN DW.STO.DT_GRUPO_EMPRESA GEMP
ON GEMP.id_empresa = EMP.id_empresa AND A.FECHA BETWEEN GEMP.fecha_desde and isnull(GEMP.fecha_hasta,getdate())
LEFT OUTER JOIN DW.STO.DT_UBICACION UBI
ON UBI.id_ubicacion = PO.id_zona_sgo AND UBI.id_area = PO.id_area AND UBI.desc_area = PO.desc_area
--WHERE A.ID_POZO_DW = '10331'
;


--Actualizo Proyecto (se asigna "path_EPM" el cual es el id único de esa combinación)
UPDATE F
SET id_proyecto = PROY.path_EPM
FROM DW.STO.FT_PRODUCCION_OIL_GAS_PROD_1 F
INNER JOIN DW.STO.DT_POZO PO
ON F.ID_POZO_DW = PO.ID_POZO_DW AND F.ID_AREA_SGO = PO.id_area AND F.ID_POZO = PO.id_pozo
INNER JOIN DW.STO.DT_PROYECTO PROY
ON F.id_campaña = PROY.id_campaña 
AND isnull(upper(left(PO.desc_etapa,3)),'ND') = PROY.id_proyecto 
AND PO.id_gerencia_operativa = PROY.id_cuenca


END


/*
select *
from DW.STO.DT_PROYECTO
where trim(id_campaña) = 'C20'

SELECT id_proyecto, count(*)
FROM DW.STO.FT_PRODUCCION_OIL_GAS_PROD_1
group by id_proyecto
order by 1
*/







