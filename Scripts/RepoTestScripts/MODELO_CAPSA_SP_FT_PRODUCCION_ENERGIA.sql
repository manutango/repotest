
ALTER PROC modelo_capsa.SP_FT_PRODUCCION_ENERGIA AS

BEGIN

	
/**************************************************************************************************************************/
/** SP que carga la tabla FT_PRODUCCION_ENERGIA con datos de Producción provenientes de staging_in.SGP_CIERRE_DIARIO_CT	 **/
/**************************************************************************************************************************/

--Borro proceso de Producción
DELETE DW.modelo_capsa.FT_PRODUCCION_ENERGIA
WHERE sk_proceso = 44 ; --CARGA_REAL_PRODUCCION_ENERGIA


/* Inserción de datos de origen staging_in.SGP_CIERRE_DIARIO_CT y SGP_CIERRE_DIARIO_CT_PLANTA */
INSERT INTO DW.modelo_capsa.FT_PRODUCCION_ENERGIA
(sk_escenario_version, sk_fecha, sk_periodo, sk_unidad_negocio, sk_empresa, sk_grupo_empresa, sk_ubicacion, sk_centro, sk_activo, sk_proyecto, sk_campaña, 
sk_unidad_generadora_ct, sk_proceso, potencia_bruta_MW, consumo_gas_energia_M3, energia_bruta_MWh, consumo_auxiliar_MWh, energia_neta_SMEC_MWh, 
energia_neta_sinconsumos_MWh, potencia_neta_SMEC_MW, consumo_auxiliar_hora_KWh,
consumo_yacimiento_MWh, consumo_generales_ct_MWh, perdidas_linea_MWh, energia_neta_MWh, potencia_neta_MW
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
	isnull(UG.sk_unidad_generadora_ct,-2) as sk_unidad_generadora_ct,
	isnull(CP.sk_proceso,-2) as sk_proceso,
	--Medidas nivel UGeneradora
	potencia_bruta_MW, 
	consumo_gas_energia_M3, 
	energia_bruta_MWh, 
	consumo_auxiliar_MWh, 
	energia_neta_SMEC_MWh, 
	energia_neta_sinconsumos_MWh, 
	potencia_neta_SMEC_MW, 
	consumo_auxiliar_hora_KWh,
	--Medidas nivel Planta
	consumo_yacimiento_MWh, 
	consumo_generales_ct_MWh, 
	perdidas_linea_MWh, 
	energia_neta_MWh, 
	potencia_neta_MW	
from DW.STO.FT_PRODUCCION_ENERGIA F
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
LEFT JOIN DW.modelo_capsa.DT_UNIDAD_GENERADORA_CT UG ON F.id_unidad_generadora_ct = UG.nombre_unidad_generadora_ct --Viene mal desde origen debería ser el ID
LEFT JOIN DW.modelo_capsa.CT_PROCESO CP ON F.id_proceso = CP.id_proceso 
WHERE F.id_escenario_version = 'Real_Final'
;

END


