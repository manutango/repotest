
ALTER PROC modelo_capsa.SP_FT_CONTROLES_OIL_GAS_INY AS

BEGIN


/*****************************************************************************************************************/
/** SP que carga la tabla FT_CONTROLES_OIL_GAS con datos de Inyección provenientes de SGO CIV 				    **/
/*****************************************************************************************************************/

--Borro proceso de CONTROLES Inyección
DELETE DW.modelo_capsa.FT_CONTROLES_OIL_GAS
WHERE sk_proceso = 47 ;



/* Inserción de datos de origen SGO_CONTROLES_INYECCION */
INSERT INTO DW.modelo_capsa.FT_CONTROLES_OIL_GAS
(
sk_escenario_version, sk_fecha, sk_periodo, sk_unidad_negocio, sk_empresa, sk_grupo_empresa, sk_ubicacion, sk_activo, sk_pozo, sk_campaña, sk_proceso, id_pozo, id_control, 
inyeccion_caudal_agua_inyectada, inyeccion_capitulo_iv, inyeccion_neta_asociada, inyeccion_dias_sin_control, 
inyeccion_diferencia_control_anterior, inyeccion_diferencia_agua_inyectada_programada, inyeccion_presion_satelite, inyeccion_presion_boca_pozo, 
inyeccion_presion_casing, inyeccion_caudal_objetivo, inyeccion_caudal_programado
)	
select 
	isnull(ESCV.sk_escenario_version,-2) as sk_escenario_version,
	isnull(T.sk_fecha,-2) as sk_fecha,
	isnull(PER.sk_periodo,-2) as sk_periodo, 
	isnull(UN.sk_unidad_negocio,-2) as sk_unidad_negocio,
	isnull(EMP.sk_empresa,-2) as sk_empresa,	
	isnull(GEM.sk_grupo_empresa,-2) as sk_grupo_empresa,
	isnull(DU.sk_ubicacion,-2) as sk_ubicacion,
	isnull(ACT.sk_activo,-2) as sk_activo,	
	isnull(POZ.sk_pozo,-2) as sk_pozo,
	isnull(CAMP.sk_campaña,-2) as sk_campaña, 
	isnull(CP.sk_proceso,-2) as sk_proceso, 	
	F.id_pozo,
	F.id_control,	
	F.caudal_agua_inyectada,
	F.capitulo_iv,
	F.neta_asociada,
	F.dias_sin_control,
	F.diferencia_control_anterior,
	F.diferencia_agua_inyectada_programada,
	F.presion_satelite,
	F.presion_boca_pozo,
	F.presion_casing,
	F.caudal_objetivo,
	F.caudal_programado		
from DW.STO.FT_CONTROLES_OIL_GAS_INY F
LEFT JOIN DW.modelo_capsa.DT_ESCENARIO_VERSION ESCV ON F.id_escenario_version = ESCV.id_escenario_version
LEFT JOIN DW.modelo_capsa.DT_FECHA T ON F.id_fecha = T.fecha
LEFT JOIN DW.modelo_capsa.DT_PERIODO PER ON F.id_periodo = PER.id_periodo
LEFT JOIN DW.modelo_capsa.DT_UNIDAD_NEGOCIO UN ON F.id_unidad_negocio = UN.id_unidad_negocio
LEFT JOIN DW.modelo_capsa.DT_EMPRESA EMP ON F.id_empresa = EMP.id_empresa
LEFT JOIN DW.modelo_capsa.DT_GRUPO_EMPRESA GEM ON F.id_grupo_empresa = GEM.id_compuesto_grempfec
LEFT JOIN DW.modelo_capsa.DT_ACTIVO ACT ON F.id_activo = ACT.id_activo
LEFT JOIN DW.modelo_capsa.DT_POZO POZ ON F.id_pozo_dw = POZ.id_pozo_dw AND F.id_area_dw = POZ.id_area AND F.id_pozo_sgo = POZ.cod_pozo   
LEFT JOIN DW.modelo_capsa.DT_CAMPAÑA CAMP ON F.id_campaña = CAMP.id_campaña
LEFT JOIN DW.modelo_capsa.CT_PROCESO CP ON F.id_proceso = CP.id_proceso 
LEFT JOIN DW.modelo_capsa.DT_UBICACION DU ON F.id_ubicacion = DU.id_ubicacion AND DU.id_area = POZ.id_area AND DU.desc_area = POZ.desc_area
WHERE F.id_escenario_version = 'Real_Final'
;

END 






