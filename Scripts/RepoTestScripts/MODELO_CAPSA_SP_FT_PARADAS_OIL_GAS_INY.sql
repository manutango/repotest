
ALTER PROC modelo_capsa.SP_FT_PARADAS_OIL_GAS_INY AS

BEGIN


/*****************************************************************************************************************/
/** SP que carga la tabla FT_PARADAS_OIL_GAS con datos de Inyección provenientes de SGO CIV 				    **/
/*****************************************************************************************************************/

--Borro proceso de PARADAS Inyección
DELETE DW.modelo_capsa.FT_PARADAS_OIL_GAS
WHERE sk_proceso = 42 ;


/* Inserción de datos de origen SGO_PARADAS_INYECCIÓN */
INSERT INTO DW.modelo_capsa.FT_PARADAS_OIL_GAS
(
sk_escenario_version, sk_fecha, sk_periodo, sk_unidad_negocio, sk_empresa, sk_grupo_empresa, sk_ubicacion, sk_activo, sk_proyecto, sk_pozo, sk_campaña, sk_proceso, 
id_evento, id_motivo, codigo_motivo, descripcion_motivo, id_causa, descripcion_causa, programa, evento, rubro, responsable, utilidad, afecta_controles, duracion, 
prod_perdida_localizada_bruta, prod_perdida_localizada_sn, prod_perdida_localizada_neta, prod_perdida_localizada_gas, inyeccion_perdida_localizada, 
inyeccion_perdida_neta_asociada, id_pozo
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
	isnull(PROY.sk_proyecto,-2) as sk_proyecto,
	isnull(POZ.sk_pozo,-2) as sk_pozo,
	isnull(CAMP.sk_campaña,-2) as sk_campaña, 
	isnull(CP.sk_proceso,-2) as sk_proceso, 		
	F.id_evento,
	F.id_motivo,
	F.codigo_motivo,
	F.descripcion_motivo,
	F.id_causa,
	F.descripcion_causa,
	F.programa,
	F.evento,
	F.rubro,
	F.responsable,
	F.utilidad,
	F.afecta_controles,
	F.duracion,
	NULL as perdida_localizada_bruta, 
	NULL as perdida_localizada_sn, 
	NULL as perdida_localizada_neta, 
	NULL as perdida_localizada_gas, 
	F.perdida_localizada as inyeccion_perdida_localizada, 
	F.perdida_neta_asociada as inyeccion_perdida_neta_asociada,	
	F.id_pozo
from DW.STO.FT_PARADAS_OIL_GAS_INY F
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
WHERE F.id_escenario_version = 'Real_Final'
;

END 






