
ALTER PROC STO.SP_FT_PRODUCCION_LPG AS

BEGIN


/*****************************************************************************************************************/
/** SP que carga la tabla de STO para datos de LPG provenientes de staging_in.SGO_CIERRE_DIARIO_LPG 			**/
/*****************************************************************************************************************/

	
/* Limpieza de tabla de STO */
TRUNCATE table DW.STO.FT_PRODUCCION_LPG;


/* Inserción de datos de origen staging_in.SGP_CIERRE_DIARIO_LPG */
INSERT INTO DW.STO.FT_PRODUCCION_LPG
(
id_escenario_version, id_fecha, id_periodo, id_unidad_negocio, id_empresa, id_grupo_empresa, id_ubicacion, id_centro, id_activo, id_proyecto, id_campaña, id_proceso,
id_area_sgo, estado, tipo_producto, tipo_medicion_concepto_codigo,
butano_entrega_masa, butano_entrega_recupero_operativa, butano_produccion_planta_masa, butano_produccion_planta_recupero_operativa, butano_produccion_planta_stock_inicial, 
butano_produccion_planta_stock_final, butano_produccion_planta_disponible, butano_produccion_planta_reproceso, butano_produccion_planta_recupero_stock, gas_consumo_volumen, 
gas_consumo_volumen_9300, gas_consumo_poder_calorifico_promedio_simple, gas_consumo_volumen_ajustado, gas_consumo_volumen_9300_ajustado, gas_recepcion_interna_volumen, 
gas_recepcion_interna_volumen_9300, gas_recepcion_interna_poder_calorifico_promedio_simple, gas_recepcion_interna_volumen_ajustado, gas_recepcion_interna_volumen_9300_ajustado, 
gas_residual_volumen, gas_residual_volumen_9300, gas_residual_poder_calorifico_promedio_simple, gas_residual_volumen_ajustado, gas_residual_volumen_9300_ajustado, 
gas_venteo_volumen, gas_venteo_volumen_9300, gas_venteo_poder_calorifico_promedio_simple, gas_venteo_volumen_ajustado, gas_venteo_volumen_9300_ajustado, 
gasolina_entrega_interna_masa, gasolina_entrega_interna_volumen, gasolina_entrega_interna_densidad, gasolina_entrega_interna_recupero_operativa, gasolina_produccion_planta_masa, 
gasolina_produccion_planta_volumen, gasolina_produccion_planta_densidad, gasolina_produccion_planta_recupero_operativa, gasolina_produccion_planta_stock_inicial, 
gasolina_produccion_planta_stock_final, gasolina_produccion_planta_disponible, gasolina_produccion_planta_reproceso, gasolina_produccion_planta_recupero_stock, 
propano_entrega_masa, propano_entrega_recupero_operativa, propano_produccion_planta_masa, propano_produccion_planta_recupero_operativa, propano_produccion_planta_stock_inicial, 
propano_produccion_planta_stock_final, propano_produccion_planta_disponible, propano_produccion_planta_reproceso, propano_produccion_planta_recupero_stock
)
SELECT 
	'Real_Final' as id_escenario_version,
	DF.id_fecha as id_fecha,
	isnull(PER.id_periodo,'ND') as id_periodo,
	'0202ACT' as id_unidad_negocio,
	isnull(UN.id_empresa,'ND') as id_empresa,
	isnull(GEMP.id_compuesto_grempfec,'ND') as id_grupo_empresa,
	'Planta ADC' as id_ubicacion,
	'ND' as id_centro,
	'ND' as id_activo, --Falta asignar en DT_ACTIVO
	'ND' id_proyecto,
	isnull(CASE WHEN left(REPLACE(PER.id_ejercicio_grupo,'Ej',''),2) in ('18','19') THEN 'ND' ELSE 'C'+right(REPLACE(PER.id_ejercicio_grupo,'Ej',''),2) END,'ND') as id_campaña,
	'CARGA_REAL_PRODUCCION_LPG' as id_proceso, 	
	id_area_sgo,
	estado,
	tipo_producto,
	tipo_medicion_concepto_codigo,
	case when producto = 'Butano' and concepto = 'Entrega' then masa  else null end as butano_entrega_masa,
	case when producto = 'Butano' and concepto = 'Entrega' then recupero_operativa  else null end as butano_entrega_recupero_operativa,
	case when producto = 'Butano' and concepto = 'Producción de Planta' then masa  else null end as butano_produccion_planta_masa,
	case when producto = 'Butano' and concepto = 'Producción de Planta' then recupero_operativa  else null end as butano_produccion_planta_recupero_operativa,
	case when producto = 'Butano' and concepto = 'Producción de Planta' then stock_inicial  else null end as butano_produccion_planta_stock_inicial,
	case when producto = 'Butano' and concepto = 'Producción de Planta' then stock_final  else null end as butano_produccion_planta_stock_final,
	case when producto = 'Butano' and concepto = 'Producción de Planta' then disponible  else null end as butano_produccion_planta_disponible,
	case when producto = 'Butano' and concepto = 'Producción de Planta' then reproceso  else null end as butano_produccion_planta_reproceso,
	case when producto = 'Butano' and concepto = 'Producción de Planta' then recupero_stock  else null end as butano_produccion_planta_recupero_stock,
	case when producto = 'Gas' and concepto = 'Consumo' then volumen  else null end as gas_consumo_volumen,
	case when producto = 'Gas' and concepto = 'Consumo' then volumen_9300  else null end as gas_consumo_volumen_9300,
	case when producto = 'Gas' and concepto = 'Consumo' then poder_calorifico_promedio_simple  else null end as gas_consumo_poder_calorifico_promedio_simple,
	case when producto = 'Gas' and concepto = 'Consumo' then volumen_ajustado  else null end as gas_consumo_volumen_ajustado,
	case when producto = 'Gas' and concepto = 'Consumo' then volumen_9300_ajustado  else null end as gas_consumo_volumen_9300_ajustado,
	case when producto = 'Gas' and concepto = 'Recepción Interna' then volumen  else null end as gas_recepcion_interna_volumen,
	case when producto = 'Gas' and concepto = 'Recepción Interna' then volumen_9300  else null end as gas_recepcion_interna_volumen_9300,
	case when producto = 'Gas' and concepto = 'Recepción Interna' then poder_calorifico_promedio_simple  else null end as gas_recepcion_interna_poder_calorifico_promedio_simple,
	case when producto = 'Gas' and concepto = 'Recepción Interna' then volumen_ajustado  else null end as gas_recepcion_interna_volumen_ajustado,
	case when producto = 'Gas' and concepto = 'Recepción Interna' then volumen_9300_ajustado  else null end as gas_recepcion_interna_volumen_9300_ajustado,
	case when producto = 'Gas' and concepto = 'Residual' then volumen  else null end as gas_residual_volumen,
	case when producto = 'Gas' and concepto = 'Residual' then volumen_9300  else null end as gas_residual_volumen_9300,
	case when producto = 'Gas' and concepto = 'Residual' then poder_calorifico_promedio_simple  else null end as gas_residual_poder_calorifico_promedio_simple,
	case when producto = 'Gas' and concepto = 'Residual' then volumen_ajustado  else null end as gas_residual_volumen_ajustado,
	case when producto = 'Gas' and concepto = 'Residual' then volumen_9300_ajustado  else null end as gas_residual_volumen_9300_ajustado,
	case when producto = 'Gas' and concepto = 'Venteo' then volumen  else null end as gas_venteo_volumen,
	case when producto = 'Gas' and concepto = 'Venteo' then volumen_9300  else null end as gas_venteo_volumen_9300,
	case when producto = 'Gas' and concepto = 'Venteo' then poder_calorifico_promedio_simple  else null end as gas_venteo_poder_calorifico_promedio_simple,
	case when producto = 'Gas' and concepto = 'Venteo' then volumen_ajustado  else null end as gas_venteo_volumen_ajustado,
	case when producto = 'Gas' and concepto = 'Venteo' then volumen_9300_ajustado  else null end as gas_venteo_volumen_9300_ajustado,
	case when producto = 'Gasolina' and concepto = 'Entrega Interna' then masa  else null end as gasolina_entrega_interna_masa,
	case when producto = 'Gasolina' and concepto = 'Entrega Interna' then volumen  else null end as gasolina_entrega_interna_volumen,
	case when producto = 'Gasolina' and concepto = 'Entrega Interna' then densidad  else null end as gasolina_entrega_interna_densidad,
	case when producto = 'Gasolina' and concepto = 'Entrega Interna' then recupero_operativa  else null end as gasolina_entrega_interna_recupero_operativa,
	case when producto = 'Gasolina' and concepto = 'Producción de Planta' then masa  else null end as gasolina_produccion_planta_masa,
	case when producto = 'Gasolina' and concepto = 'Producción de Planta' then volumen  else null end as gasolina_produccion_planta_volumen,
	case when producto = 'Gasolina' and concepto = 'Producción de Planta' then densidad  else null end as gasolina_produccion_planta_densidad,
	case when producto = 'Gasolina' and concepto = 'Producción de Planta' then recupero_operativa  else null end as gasolina_produccion_planta_recupero_operativa,
	case when producto = 'Gasolina' and concepto = 'Producción de Planta' then stock_inicial  else null end as gasolina_produccion_planta_stock_inicial,
	case when producto = 'Gasolina' and concepto = 'Producción de Planta' then stock_final  else null end as gasolina_produccion_planta_stock_final,
	case when producto = 'Gasolina' and concepto = 'Producción de Planta' then disponible  else null end as gasolina_produccion_planta_disponible,
	case when producto = 'Gasolina' and concepto = 'Producción de Planta' then reproceso  else null end as gasolina_produccion_planta_reproceso,
	case when producto = 'Gasolina' and concepto = 'Producción de Planta' then recupero_stock  else null end as gasolina_produccion_planta_recupero_stock,
	case when producto = 'Propano' and concepto = 'Entrega' then masa  else null end as propano_entrega_masa,
	case when producto = 'Propano' and concepto = 'Entrega' then recupero_operativa  else null end as propano_entrega_recupero_operativa,
	case when producto = 'Propano' and concepto = 'Producción de Planta' then masa  else null end as propano_produccion_planta_masa,
	case when producto = 'Propano' and concepto = 'Producción de Planta' then recupero_operativa  else null end as propano_produccion_planta_recupero_operativa,
	case when producto = 'Propano' and concepto = 'Producción de Planta' then stock_inicial  else null end as propano_produccion_planta_stock_inicial,
	case when producto = 'Propano' and concepto = 'Producción de Planta' then stock_final  else null end as propano_produccion_planta_stock_final,
	case when producto = 'Propano' and concepto = 'Producción de Planta' then disponible  else null end as propano_produccion_planta_disponible,
	case when producto = 'Propano' and concepto = 'Producción de Planta' then reproceso  else null end as propano_produccion_planta_reproceso,
	case when producto = 'Propano' and concepto = 'Producción de Planta' then recupero_stock  else null end as propano_produccion_planta_recupero_stock
FROM staging_in.SGO_CIERRE_DIARIO_LPG A
LEFT OUTER JOIN DW.STO.DT_FECHA DF
ON A.FECHA = DF.FECHA
LEFT OUTER JOIN dw.sto.DT_UNIDAD_NEGOCIO UN
ON '0202ACT' = UN.id_unidad_negocio 
LEFT OUTER JOIN DW.STO.DT_EMPRESA EMP
ON UN.id_empresa = EMP.id_empresa
LEFT OUTER JOIN (SELECT id_mes, id_periodo, tipo_ejercicio, id_ejercicio_grupo FROM DW.STO.DT_PERIODO WHERE id_ejercicio_subgrupo is null) PER
ON PER.id_mes = DF.añomes AND PER.tipo_ejercicio = EMP.tipo_ejercicio
LEFT OUTER JOIN DW.STO.DT_GRUPO_EMPRESA GEMP
ON GEMP.id_empresa = EMP.id_empresa AND A.FECHA BETWEEN GEMP.fecha_desde and isnull(GEMP.fecha_hasta,getdate())
;


END
