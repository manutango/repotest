


ALTER PROC [STO].[SP_FT_PARADAS_OIL_GAS_PROD] AS

BEGIN


/*****************************************************************************************************************/
/** SP que carga la tabla de STO para datos de PARADAS PRODUCCIÓN provenientes de SGO CIV 					    **/
/*****************************************************************************************************************/


/* Limpieza de tabla de STO */
TRUNCATE TABLE DW.STO.FT_PARADAS_OIL_GAS_PROD;


/* Inserción de datos de origen SGO_PARADAS_PRODUCCION */
INSERT INTO DW.STO.FT_PARADAS_OIL_GAS_PROD
(
id_escenario_version, id_fecha, id_periodo, id_unidad_negocio, id_empresa, id_grupo_empresa, id_ubicacion, id_proyecto, id_activo, id_pozo_sgo, id_pozo_dw, 
id_area_sgo, id_campaña, id_proceso, id_evento, 
duracion, perdida_localizada_bruta, perdida_localizada_sn, perdida_localizada_neta, perdida_localizada_gas, 
programa, evento, id_motivo, codigo_motivo, descripcion_motivo, rubro, responsable, utilidad, afecta_controles, id_causa, descripcion_causa, id_pozo
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
	PO.cod_pozo as id_pozo_sgo,
	A.ID_POZO_DW,
	A.ID_AREA_DW as id_area_sgo, --es area de SGO asignada
	isnull(CASE WHEN left(REPLACE(PER.id_ejercicio_grupo,'Ej',''),2) in ('18','19') THEN 'ND' ELSE 'C'+right(REPLACE(PER.id_ejercicio_grupo,'Ej',''),2) END,'ND') as id_campaña,
	'CARGA_REAL_PARADAS_PRODUCCIÓN' as id_proceso,
	cast(A.ID_AREA_DW as varchar) +'-'+ cast(A.ID_POZO_DW as varchar) +'-'+ substring(cast(A.ID_FECHA as varchar),1,10) +'-'+ cast(A.ID_MOTIVO as varchar) +'-'+ cast(A.ID_CAUSA as varchar)+ '-' +
	cast(ROW_NUMBER() OVER(ORDER BY A.ID_AREA_DW, A.ID_POZO_DW, A.ID_FECHA, A.ID_MOTIVO, A.ID_CAUSA) as varchar) as id_evento,
	duracion, 
	perdida_localizada_bruta, 
	perdida_localizada_sn, 
	perdida_localizada_neta, 
	perdida_localizada_gas, 
	programa, 
	evento, 
	id_motivo, 
	codigo_motivo, 
	descripcion_motivo, 
	rubro, 
	responsable, 
	utilidad, 
	afecta_controles, 
	id_causa, 
	descripcion_causa,
	PO.ID_POZO
FROM DW.staging_in.SGO_PARADAS_PRODUCCION A
LEFT OUTER JOIN DW.STO.DT_FECHA DF
ON A.ID_FECHA = DF.FECHA
LEFT OUTER JOIN DW.STO.DT_POZO PO
ON A.ID_POZO_DW = PO.ID_POZO_DW AND A.ID_AREA_DW = PO.id_area
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
ON GEMP.id_empresa = EMP.id_empresa AND A.ID_FECHA BETWEEN GEMP.fecha_desde and isnull(GEMP.fecha_hasta,getdate())
LEFT OUTER JOIN DW.STO.DT_UBICACION UBI
ON UBI.id_ubicacion = PO.id_zona_sgo AND UBI.id_area = PO.id_area AND UBI.desc_area = PO.desc_area
--WHERE A.ID_POZO_DW = 12277
;


--Actualizo Proyecto (se asigna "path_EPM" el cual es el id único de esa combinación)
UPDATE F
SET id_proyecto = PROY.path_EPM
FROM DW.STO.FT_PARADAS_OIL_GAS_PROD F
INNER JOIN DW.STO.DT_POZO PO
ON F.ID_POZO_DW = PO.ID_POZO_DW AND F.ID_AREA_SGO = PO.id_area AND F.ID_POZO = PO.id_pozo
INNER JOIN DW.STO.DT_PROYECTO PROY
ON F.id_campaña = PROY.id_campaña 
AND isnull(upper(left(PO.desc_etapa,3)),'ND') = PROY.id_proyecto 
AND PO.id_gerencia_operativa = PROY.id_cuenca
;

END








