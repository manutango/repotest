
ALTER PROC modelo_capsa.SP_FT_PRODUCCION_LPG AS

BEGIN

	
/**************************************************************************************************************************/
/** SP que carga la tabla FT_PRODUCCION_LPG con datos de Producción provenientes de staging_in.SGO_CIERRE_DIARIO_LPG	 **/
/**************************************************************************************************************************/

--Borro proceso de Producción LPG
DELETE DW.modelo_capsa.FT_PRODUCCION_LPG
WHERE sk_proceso = 48 ; --CARGA_REAL_PRODUCCION_LPG


/* Inserción de datos de origen staging_in.SGO_CIERRE_DIARIO_LPG */
INSERT INTO DW.modelo_capsa.FT_PRODUCCION_LPG
(
sk_escenario_version, sk_fecha, sk_periodo, sk_unidad_negocio, sk_empresa, sk_grupo_empresa, sk_ubicacion, sk_centro, sk_activo, sk_proyecto, sk_campaña, 
sk_proceso, id_area_sgo, estado, tipo_producto, tipo_medicion_concepto_codigo, butano_entrega_masa, butano_entrega_recupero_operativa, butano_produccion_planta_masa, 
butano_produccion_planta_recupero_operativa, butano_produccion_planta_stock_inicial, butano_produccion_planta_stock_final, butano_produccion_planta_disponible, 
butano_produccion_planta_reproceso, butano_produccion_planta_recupero_stock, gas_consumo_volumen, gas_consumo_volumen_9300, gas_consumo_poder_calorifico_promedio_simple, 
gas_consumo_volumen_ajustado, gas_consumo_volumen_9300_ajustado, gas_recepcion_interna_volumen, gas_recepcion_interna_volumen_9300, 
gas_recepcion_interna_poder_calorifico_promedio_simple, gas_recepcion_interna_volumen_ajustado, gas_recepcion_interna_volumen_9300_ajustado, 
gas_residual_volumen, gas_residual_volumen_9300, gas_residual_poder_calorifico_promedio_simple, gas_residual_volumen_ajustado, gas_residual_volumen_9300_ajustado, 
gas_venteo_volumen, gas_venteo_volumen_9300, gas_venteo_poder_calorifico_promedio_simple, gas_venteo_volumen_ajustado, gas_venteo_volumen_9300_ajustado, 
gasolina_entrega_interna_masa, gasolina_entrega_interna_volumen, gasolina_entrega_interna_densidad, gasolina_entrega_interna_recupero_operativa, 
gasolina_produccion_planta_masa, gasolina_produccion_planta_volumen, gasolina_produccion_planta_densidad, gasolina_produccion_planta_recupero_operativa, 
gasolina_produccion_planta_stock_inicial, gasolina_produccion_planta_stock_final, gasolina_produccion_planta_disponible, gasolina_produccion_planta_reproceso, 
gasolina_produccion_planta_recupero_stock, propano_entrega_masa, propano_entrega_recupero_operativa, propano_produccion_planta_masa, 
propano_produccion_planta_recupero_operativa, propano_produccion_planta_stock_inicial, propano_produccion_planta_stock_final, propano_produccion_planta_disponible, 
propano_produccion_planta_reproceso, propano_produccion_planta_recupero_stock
)
select 
	isnull(ESCV.sk_escenario_version,-2) as sk_escenario_version,
	isnull(T.sk_fecha,-2) as sk_fecha,
	isnull(PER.sk_periodo,-2) as sk_periodo, 
	isnull(UN.sk_unidad_negocio,-2) as sk_unidad_negocio,
	isnull(EMP.sk_empresa,-2) as sk_empresa,	
	isnull(GEM.sk_grupo_empresa,-2) as sk_grupo_empresa,
	isnull(DU.sk_ubicacion,-2) as sk_ubicacion, 
	isnull(CEN.sk_centro,-2) as sk_centro,
	isnull(ACT.sk_activo,-2) as sk_activo,
	isnull(PROY.sk_proyecto,-2) as sk_proyecto,
	isnull(CAMP.sk_campaña,-2) as sk_campaña, 
	isnull(CP.sk_proceso,-2) as sk_proceso,
	F.id_area_sgo, 
	F.estado, 
	F.tipo_producto, 
	F.tipo_medicion_concepto_codigo, 		
 	F.butano_entrega_masa,
	F.butano_entrega_recupero_operativa,
	F.butano_produccion_planta_masa,
	F.butano_produccion_planta_recupero_operativa,
	F.butano_produccion_planta_stock_inicial,
	F.butano_produccion_planta_stock_final,
	F.butano_produccion_planta_disponible,
	F.butano_produccion_planta_reproceso,
	F.butano_produccion_planta_recupero_stock,
	F.gas_consumo_volumen,
	F.gas_consumo_volumen_9300,
	F.gas_consumo_poder_calorifico_promedio_simple,
	F.gas_consumo_volumen_ajustado,
	F.gas_consumo_volumen_9300_ajustado,
	F.gas_recepcion_interna_volumen,
	F.gas_recepcion_interna_volumen_9300,
	F.gas_recepcion_interna_poder_calorifico_promedio_simple,
	F.gas_recepcion_interna_volumen_ajustado,
	F.gas_recepcion_interna_volumen_9300_ajustado,
	F.gas_residual_volumen,
	F.gas_residual_volumen_9300,
	F.gas_residual_poder_calorifico_promedio_simple,
	F.gas_residual_volumen_ajustado,
	F.gas_residual_volumen_9300_ajustado,
	F.gas_venteo_volumen,
	F.gas_venteo_volumen_9300,
	F.gas_venteo_poder_calorifico_promedio_simple,
	F.gas_venteo_volumen_ajustado,
	F.gas_venteo_volumen_9300_ajustado,
	F.gasolina_entrega_interna_masa,
	F.gasolina_entrega_interna_volumen,
	F.gasolina_entrega_interna_densidad,
	F.gasolina_entrega_interna_recupero_operativa,
	F.gasolina_produccion_planta_masa,
	F.gasolina_produccion_planta_volumen,
	F.gasolina_produccion_planta_densidad,
	F.gasolina_produccion_planta_recupero_operativa,
	F.gasolina_produccion_planta_stock_inicial,
	F.gasolina_produccion_planta_stock_final,
	F.gasolina_produccion_planta_disponible,
	F.gasolina_produccion_planta_reproceso,
	F.gasolina_produccion_planta_recupero_stock,
	F.propano_entrega_masa,
	F.propano_entrega_recupero_operativa,
	F.propano_produccion_planta_masa,
	F.propano_produccion_planta_recupero_operativa,
	F.propano_produccion_planta_stock_inicial,
	F.propano_produccion_planta_stock_final,
	F.propano_produccion_planta_disponible,
	F.propano_produccion_planta_reproceso,
	F.propano_produccion_planta_recupero_stock
from DW.STO.FT_PRODUCCION_LPG F
LEFT JOIN DW.modelo_capsa.DT_ESCENARIO_VERSION ESCV ON F.id_escenario_version = ESCV.id_escenario_version
LEFT JOIN DW.modelo_capsa.DT_FECHA T ON F.id_fecha = T.fecha
LEFT JOIN DW.modelo_capsa.DT_PERIODO PER ON F.id_periodo = PER.id_periodo
LEFT JOIN DW.modelo_capsa.DT_UNIDAD_NEGOCIO UN ON F.id_unidad_negocio = UN.id_unidad_negocio
LEFT JOIN DW.modelo_capsa.DT_EMPRESA EMP ON F.id_empresa = EMP.id_empresa
LEFT JOIN DW.modelo_capsa.DT_GRUPO_EMPRESA GEM ON F.id_grupo_empresa = GEM.id_compuesto_grempfec
LEFT JOIN DW.modelo_capsa.DT_UBICACION DU ON F.id_ubicacion = DU.id_ubicacion
LEFT JOIN DW.modelo_capsa.DT_CENTRO CEN ON F.id_centro = CEN.id_centro
LEFT JOIN DW.modelo_capsa.DT_ACTIVO ACT ON F.id_activo = ACT.id_activo
LEFT JOIN DW.modelo_capsa.DT_PROYECTO PROY ON F.id_proyecto = PROY.path_EPM
LEFT JOIN DW.modelo_capsa.DT_CAMPAÑA CAMP ON F.id_campaña = CAMP.id_campaña
LEFT JOIN DW.modelo_capsa.CT_PROCESO CP ON F.id_proceso = CP.id_proceso 
WHERE F.id_escenario_version = 'Real_Final'
;

END



