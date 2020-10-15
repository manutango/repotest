
ALTER PROC STO.SP_FT_PRODUCCION_ENERGIA AS

BEGIN


/*****************************************************************************************************************/
/** SP que carga la tabla de STO para datos de Energía provenientes de staging_in.SGP_CIERRE_DIARIO_CT			**/
/*****************************************************************************************************************/

	
/* Limpieza de tabla de STO */
TRUNCATE table DW.STO.FT_PRODUCCION_ENERGIA;


/* Inserción de datos de origen staging_in.SGP_CIERRE_DIARIO_CT */
INSERT INTO DW.STO.FT_PRODUCCION_ENERGIA
(id_escenario_version, id_fecha, id_periodo, id_unidad_negocio, id_empresa, id_grupo_empresa, id_ubicacion, id_centro, id_activo, id_proyecto, id_campaña, 
id_unidad_generadora_ct, id_proceso, potencia_bruta_MW, consumo_gas_energia_M3, energia_bruta_MWh, consumo_auxiliar_MWh, energia_neta_SMEC_MWh, 
energia_neta_sinconsumos_MWh, potencia_neta_SMEC_MW, consumo_auxiliar_hora_KWh)
SELECT 
	'Real_Final' as id_escenario_version,
	DF.id_fecha as id_fecha,
	isnull(PER.id_periodo,'ND') as id_periodo,
	'0202ACT' as id_unidad_negocio,
	isnull(UN.id_empresa,'ND') as id_empresa,
	isnull(GEMP.id_compuesto_grempfec,'ND') as id_grupo_empresa,
	'Planta ADC' as id_ubicacion,
	'ND' as id_centro,
	isnull(UG.id_unidad_generadora_ct,'ND') as id_activo,
	'ND' id_proyecto,
	isnull(CASE WHEN left(REPLACE(PER.id_ejercicio_grupo,'Ej',''),2) in ('18','19') THEN 'ND' ELSE 'C'+right(REPLACE(PER.id_ejercicio_grupo,'Ej',''),2) END,'ND') as id_campaña,
	A.ID_UNIDAD_CT as id_unidad_generadora_ct,
	'CARGA_REAL_PRODUCCION_ENERGIA' as id_proceso,
	A.potencia_bruta as potencia_bruta_MW,
	A.consumo_gas as consumo_gas_energia_M3,
	A.generacion_bruta as energia_bruta_MWh,
	A.consumo_auxiliar_MWh,
	A.generacion_neta_SMEC as energia_neta_SMEC_MWh,
	A.produccion_neta_total as energia_neta_sinconsumos_MWh,
	A.potencia_neta as potencia_neta_SMEC_MW,
	A.consumo_auxiliar_hora_KWh
FROM staging_in.SGP_CIERRE_DIARIO_CT A
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
LEFT OUTER JOIN (select * from dw.sto.DT_UNIDAD_GENERADORA_CT WHERE nombre_unidad_generadora_ct NOT IN ('A','C')) UG
ON A.id_unidad_CT = UG.nombre_unidad_generadora_ct
;


/* Inserción de datos de origen staging_in.SGP_CIERRE_DIARIO_CT_PLANTA **** Datos de Planta ****/

INSERT INTO DW.STO.FT_PRODUCCION_ENERGIA
(id_escenario_version, id_fecha, id_periodo, id_unidad_negocio, id_empresa, id_grupo_empresa, id_ubicacion, id_centro, id_activo, id_proyecto, id_campaña, 
id_unidad_generadora_ct, id_proceso, consumo_yacimiento_MWh, consumo_generales_ct_MWh, perdidas_linea_MWh, energia_neta_MWh, potencia_neta_MW)
SELECT 
	'Real_Final' as id_escenario_version,
	DF.id_fecha as id_fecha,
	isnull(PER.id_periodo,'ND') as id_periodo,
	'0202ACT' as id_unidad_negocio,
	isnull(UN.id_empresa,'ND') as id_empresa,
	isnull(GEMP.id_compuesto_grempfec,'ND') as id_grupo_empresa,
	'Planta ADC' as id_ubicacion,
	'ND' as id_centro,
	isnull(UG.id_unidad_generadora_ct,'ND') as id_activo,
	'ND' id_proyecto,
	isnull(CASE WHEN left(REPLACE(PER.id_ejercicio_grupo,'Ej',''),2) in ('18','19') THEN 'ND' ELSE 'C'+right(REPLACE(PER.id_ejercicio_grupo,'Ej',''),2) END,'ND') as id_campaña,
	'C' as id_unidad_generadora_ct,
	'CARGA_REAL_PRODUCCION_ENERGIA' as id_proceso,
	A.consumo_auxiliar_TRAYac_total as consumo_yacimiento_MWh,	
	A.consumo_auxiliar_TR14CT_total as consumo_generales_ct_MWh,
	A.perdidas_de_lineas_por_dia as perdidas_linea_MWh,
	A.ventas_al_MEM as energia_neta_MWh,
	A.ventas_al_MEM_potencia as potencia_neta_MW
FROM staging_in.SGP_CIERRE_DIARIO_CT_PLANTA A
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
LEFT OUTER JOIN (select * from dw.sto.DT_UNIDAD_GENERADORA_CT WHERE nombre_unidad_generadora_ct = 'C') UG
ON 'C' = UG.nombre_unidad_generadora_ct --Fijo en GENERAL DE PLANTA 'C'
;


end




	
	
	
	