
ALTER PROC modelo_capsa.SP_FT_PRODUCCION_OIL_GAS_PPTO AS

BEGIN


/*****************************************************************************************************************/
/** SP que carga la tabla FT_PRODUCCION_OIL_GAS con datos de PRESUPUESTO de Producción e Inyección              **/
/*****************************************************************************************************************/

--Borro proceso de Presupuesto de Producción e Inyección
DELETE DW.modelo_capsa.FT_PRODUCCION_OIL_GAS
WHERE sk_proceso = 32;


/* Inserción de datos de origen Producción PPTO */
INSERT INTO DW.modelo_capsa.FT_PRODUCCION_OIL_GAS 
(sk_escenario_version, sk_fecha, sk_periodo, sk_unidad_negocio, sk_empresa, sk_grupo_empresa, sk_ubicacion, sk_proyecto, sk_activo, sk_pozo, sk_campaña, sk_proceso, 
PROD_PETROLEO_CIV, PROD_GAS_CIV, PROD_AGUA_CIV, PROD_PETROLEO_CIV_TEP, PROD_PETROLEO_CIV_CALENDARIO, PROD_GAS_CIV_TEP, 
PROD_GAS_CIV_CALENDARIO, PROD_AGUA_CIV_TEP, PROD_AGUA_CIV_CALENDARIO, PROD_BRUTA_CM, PROD_SN_CM, PROD_NETA_CM, PROD_GAS_CM, PROD_AGUA_CM, PROD_BRUTA_CM_TEP, 
PROD_SN_CM_TEP, PROD_NETA_CM_TEP, PROD_GAS_CM_TEP, PROD_AGUA_CM_TEP, PROD_BRUTA_CM_CAL, PROD_SN_CM_CAL, PROD_NETA_CM_CAL, PROD_GAS_CM_CAL, PROD_AGUA_CM_CAL, 
TEP, TEP_DIA, PRONOSTICO_BRUTA, PRONOSTICO_NETA, PROD_GAS9300CIV, PROD_GAS9300CIV_CAL, PROD_GAS9300CIV_TEP, INYECCION_CIV, INYECCION_CIV_TEI, INYECCION_CIV_CAL, 
TEI, PRONOSTICO_INYECCION, PRONOSTICO_EFECTIVO_MES, PRESION_CIV, PRODUCCION_BASE, id_pozo, PROD_BRUTA_CIV)

select 
	isnull(ESCV.sk_escenario_version,-2) as sk_escenario_version,
	isnull(T.sk_fecha,-2) as sk_fecha,
	isnull(PER.sk_periodo,-2) as sk_periodo, 
	isnull(UN.sk_unidad_negocio,-2) as sk_unidad_negocio,
	isnull(EMP.sk_empresa,-2) as sk_empresa,	
	isnull(GEM.sk_grupo_empresa,-2) as sk_grupo_empresa,
	isnull(DU.sk_ubicacion,-2) as sk_ubicacion, 
	isnull(PROY.sk_proyecto,-2) as sk_proyecto,
	isnull(ACT.sk_activo,-2) as sk_activo,
	isnull(POZ.sk_pozo,-2) as sk_pozo,
	isnull(CAMP.sk_campaña,-2) as sk_campaña, 
	isnull(CP.sk_proceso,-2) as sk_proceso, 	
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
	NULL AS INYECCION_CIV,
	NULL AS INYECCION_CIV_TEI, 
	NULL AS INYECCION_CIV_CAL, 
	NULL AS TEI, 
	NULL AS PRONOSTICO_INYECCION, 
	NULL AS PRONOSTICO_EFECTIVO_MES, 
	NULL AS PRESION_CIV,	
	PRODUCCION_BASE,
	F.id_pozo,
	F.PROD_BRUTA_CIV
from DW.STO.FT_PRODUCCION_OIL_GAS_PROD_1 F
LEFT JOIN DW.modelo_capsa.DT_ESCENARIO_VERSION ESCV ON F.id_escenario_version = ESCV.id_escenario_version
LEFT JOIN DW.modelo_capsa.DT_FECHA T ON F.id_fecha = T.fecha
LEFT JOIN DW.modelo_capsa.DT_PERIODO PER ON F.id_periodo = PER.id_periodo
LEFT JOIN DW.modelo_capsa.DT_UNIDAD_NEGOCIO UN ON F.id_unidad_negocio = UN.id_unidad_negocio
LEFT JOIN DW.modelo_capsa.DT_EMPRESA EMP ON F.id_empresa = EMP.id_empresa
LEFT JOIN DW.modelo_capsa.DT_GRUPO_EMPRESA GEM ON F.id_grupo_empresa = GEM.id_compuesto_grempfec
LEFT JOIN DW.modelo_capsa.DT_PROYECTO PROY ON F.id_proyecto = PROY.path_EPM
LEFT JOIN DW.modelo_capsa.DT_ACTIVO ACT ON F.id_activo = ACT.id_activo
LEFT JOIN DW.modelo_capsa.DT_POZO POZ ON F.id_pozo_dw = POZ.id_pozo_dw AND F.id_area_sgo = POZ.id_area AND F.id_pozo_sgo = POZ.cod_pozo  
LEFT JOIN DW.modelo_capsa.DT_CAMPAÑA CAMP ON F.id_campaña = CAMP.id_campaña
LEFT JOIN DW.modelo_capsa.CT_PROCESO CP ON F.id_proceso = CP.id_proceso 
LEFT JOIN DW.modelo_capsa.DT_UBICACION DU ON F.id_ubicacion = DU.id_ubicacion AND DU.id_area = POZ.id_area AND DU.desc_area = POZ.desc_area
where F.id_escenario_version = 'Presupuesto_Final' --datos PPTO
;



/* Inserción de datos de origen Inyección PPTO */
INSERT INTO DW.modelo_capsa.FT_PRODUCCION_OIL_GAS 
(sk_escenario_version, sk_fecha, sk_periodo, sk_unidad_negocio, sk_empresa, sk_grupo_empresa, sk_ubicacion, sk_proyecto, sk_activo, sk_pozo, sk_campaña, sk_proceso, 
PROD_PETROLEO_CIV, PROD_GAS_CIV, PROD_AGUA_CIV, PROD_PETROLEO_CIV_TEP, PROD_PETROLEO_CIV_CALENDARIO, PROD_GAS_CIV_TEP, 
PROD_GAS_CIV_CALENDARIO, PROD_AGUA_CIV_TEP, PROD_AGUA_CIV_CALENDARIO, PROD_BRUTA_CM, PROD_SN_CM, PROD_NETA_CM, PROD_GAS_CM, PROD_AGUA_CM, PROD_BRUTA_CM_TEP, 
PROD_SN_CM_TEP, PROD_NETA_CM_TEP, PROD_GAS_CM_TEP, PROD_AGUA_CM_TEP, PROD_BRUTA_CM_CAL, PROD_SN_CM_CAL, PROD_NETA_CM_CAL, PROD_GAS_CM_CAL, PROD_AGUA_CM_CAL, 
TEP, TEP_DIA, PRONOSTICO_BRUTA, PRONOSTICO_NETA, PROD_GAS9300CIV, PROD_GAS9300CIV_CAL, PROD_GAS9300CIV_TEP, INYECCION_CIV, INYECCION_CIV_TEI, INYECCION_CIV_CAL, 
TEI, PRONOSTICO_INYECCION, PRONOSTICO_EFECTIVO_MES, PRESION_CIV, PRODUCCION_BASE, id_pozo)
select 
	isnull(ESCV.sk_escenario_version,-2) as sk_escenario_version,
	isnull(T.sk_fecha,-2) as sk_fecha,
	isnull(PER.sk_periodo,-2) as sk_periodo, 
	isnull(UN.sk_unidad_negocio,-2) as sk_unidad_negocio,
	isnull(EMP.sk_empresa,-2) as sk_empresa,	
	isnull(GEM.sk_grupo_empresa,-2) as sk_grupo_empresa,
	isnull(DU.sk_ubicacion,-2) as sk_ubicacion, 
	isnull(PROY.sk_proyecto,-2) as sk_proyecto,
	isnull(ACT.sk_activo,-2) as sk_activo,
	isnull(POZ.sk_pozo,-2) as sk_pozo,
	isnull(CAMP.sk_campaña,-2) as sk_campaña, 
	isnull(CP.sk_proceso,-2) as sk_proceso,
	NULL AS  PROD_PETROLEO_CIV,
	NULL AS  PROD_GAS_CIV,
	NULL AS  PROD_AGUA_CIV,
	NULL AS  PROD_PETROLEO_CIV_TEP,
	NULL AS  PROD_PETROLEO_CIV_CALENDARIO,
	NULL AS  PROD_GAS_CIV_TEP,
	NULL AS  PROD_GAS_CIV_CALENDARIO,
	NULL AS  PROD_AGUA_CIV_TEP,
	NULL AS  PROD_AGUA_CIV_CALENDARIO,
	NULL AS  PROD_BRUTA_CM,
	NULL AS  PROD_SN_CM,
	NULL AS  PROD_NETA_CM,
	NULL AS  PROD_GAS_CM,
	NULL AS  PROD_AGUA_CM,
	NULL AS  PROD_BRUTA_CM_TEP,
	NULL AS  PROD_SN_CM_TEP,
	NULL AS  PROD_NETA_CM_TEP,
	NULL AS  PROD_GAS_CM_TEP,
	NULL AS  PROD_AGUA_CM_TEP,
	NULL AS  PROD_BRUTA_CM_CAL,
	NULL AS  PROD_SN_CM_CAL,
	NULL AS  PROD_NETA_CM_CAL,
	NULL AS  PROD_GAS_CM_CAL,
	NULL AS  PROD_AGUA_CM_CAL,
	NULL AS  TEP,
	NULL AS  TEP_DIA,
	NULL AS  PRONOSTICO_BRUTA,
	NULL AS  PRONOSTICO_NETA,
	NULL AS  PROD_GAS9300CIV,
	NULL AS  PROD_GAS9300CIV_CAL,
	NULL AS  PROD_GAS9300CIV_TEP,
	INYECCION_CIV,
	INYECCION_CIV_TEI, 
	INYECCION_CIV_CAL, 
	TEI, 
	PRONOSTICO_INYECCION, 
	PRONOSTICO_EFECTIVO_MES, 
	PRESION_CIV,	
	PRODUCCION_BASE,
	F.ID_POZO
from DW.STO.FT_PRODUCCION_OIL_GAS_INY_2 F
LEFT JOIN DW.modelo_capsa.DT_ESCENARIO_VERSION ESCV ON F.id_escenario_version = ESCV.id_escenario_version
LEFT JOIN DW.modelo_capsa.DT_FECHA T ON F.id_fecha = T.fecha
LEFT JOIN DW.modelo_capsa.DT_PERIODO PER ON F.id_periodo = PER.id_periodo
LEFT JOIN DW.modelo_capsa.DT_UNIDAD_NEGOCIO UN ON F.id_unidad_negocio = UN.id_unidad_negocio
LEFT JOIN DW.modelo_capsa.DT_EMPRESA EMP ON F.id_empresa = EMP.id_empresa
LEFT JOIN DW.modelo_capsa.DT_GRUPO_EMPRESA GEM ON F.id_grupo_empresa = GEM.id_compuesto_grempfec
LEFT JOIN DW.modelo_capsa.DT_PROYECTO PROY ON F.id_proyecto = PROY.id_proyecto
LEFT JOIN DW.modelo_capsa.DT_ACTIVO ACT ON F.id_activo = ACT.id_activo
LEFT JOIN DW.modelo_capsa.DT_POZO POZ ON F.id_pozo_dw = POZ.id_pozo_dw AND F.id_area_sgo = POZ.id_area AND F.id_pozo_sgo = POZ.cod_pozo  
LEFT JOIN DW.modelo_capsa.DT_CAMPAÑA CAMP ON F.id_campaña = CAMP.id_campaña
LEFT JOIN DW.modelo_capsa.CT_PROCESO CP ON F.id_proceso = CP.id_proceso 
LEFT JOIN DW.modelo_capsa.DT_UBICACION DU ON F.id_ubicacion = DU.id_ubicacion AND DU.id_area = POZ.id_area AND DU.desc_area = POZ.desc_area
where F.id_escenario_version = 'Presupuesto_Final' --datos PPTO




END 






