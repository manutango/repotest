
ALTER PROC modelo_capsa.SP_FT_CONTROLES_OIL_GAS_PROD AS

BEGIN


/*****************************************************************************************************************/
/** SP que carga la tabla FT_CONTROLES_OIL_GAS con datos de Producción provenientes de SGO CIV 				    **/
/*****************************************************************************************************************/

--Borro proceso de CONTROLES Producción
DELETE DW.modelo_capsa.FT_CONTROLES_OIL_GAS
WHERE sk_proceso = 46 ;



/* Inserción de datos de origen SGO_CONTROLES_PRODUCCIÓN */
INSERT INTO DW.modelo_capsa.FT_CONTROLES_OIL_GAS
(
sk_escenario_version, sk_fecha, sk_periodo, sk_unidad_negocio, sk_empresa, sk_grupo_empresa, sk_ubicacion, sk_activo, sk_pozo, sk_campaña, sk_proceso, id_pozo, 
id_antiguedad, id_control, prod_duracion_control_petroleo, prod_tipo_control_petroleo, prod_produccion_bruto, prod_produccion_semi_neto, prod_produccion_agua, prod_procentaje_agua, 
prod_duracion_control_gas, prod_tipo_control_gas, prod_duracion_control_gas_lift, prod_tipo_control_gas_lift, prod_caudal_gas_lift, prod_duracion_control_asistencia_agua, 
prod_tipo_control_asistencia_agua, prod_caudal_asistencia_agua, prod_produccion_gas, prod_capitulo_iv, prod_control_gas_coordinado_petroleo, 
prod_control_gas_lift_coordinado_petroleo, prod_potencial_bruto, prod_potencial_semi_neto, prod_potencial_gas, prod_potencial_gas_lift, prod_potencial_sugerido_bruto, 
prod_potencial_sugerido_semi_neto, prod_potencial_bruto_agua, prod_dias_sin_control, prod_diferencia_bruto_produccion_potencial, prod_diferencia_semi_neto_produccion_potencial, 
prod_diferencia_gas_produccion_potencial, prod_metodo_control
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
	F.id_antiguedad,
	F.id_control,	
	F.duracion_control_petroleo,
	F.tipo_control_petroleo,
	F.produccion_bruto,
	F.produccion_semi_neto,
	F.produccion_agua,
	F.procentaje_agua,
	F.duracion_control_gas,
	F.tipo_control_gas,
	F.duracion_control_gas_lift,
	F.tipo_control_gas_lift,
	F.caudal_gas_lift,
	F.duracion_control_asistencia_agua,
	F.tipo_control_asistencia_agua,
	F.caudal_asistencia_agua,
	F.produccion_gas,
	F.capitulo_iv,
	F.control_gas_coordinado_petroleo,
	F.control_gas_lift_coordinado_petroleo,
	F.potencial_bruto,
	F.potencial_semi_neto,
	F.potencial_gas,
	F.potencial_gas_lift,
	F.potencial_sugerido_bruto,
	F.potencial_sugerido_semi_neto,
	F.potencial_bruto_agua,
	F.dias_sin_control,
	F.diferencia_bruto_produccion_potencial,
	F.diferencia_semi_neto_produccion_potencial,
	F.diferencia_gas_produccion_potencial,
	F.metodo_control	
from DW.STO.FT_CONTROLES_OIL_GAS_PROD F
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






