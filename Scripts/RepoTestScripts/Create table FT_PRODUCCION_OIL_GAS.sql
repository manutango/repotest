
-- Drop table

-- DROP TABLE DW.modelo_capsa.FT_PRODUCCION_OIL_GAS

CREATE TABLE DW.modelo_capsa.FT_PRODUCCION_OIL_GAS (
--base
sk_escenario int NOT NULL,
sk_version int NOT NULL,
sk_fecha int NOT NULL,
sk_periodo int NOT NULL,
--gestión
sk_unidad_negocio int NOT NULL,
sk_empresa int NOT NULL,
sk_grupo_empresa int NOT NULL,
sk_ubicacion int NOT NULL,
--contable
sk_proyecto int NOT NULL,
sk_activo int NOT NULL,
sk_articulo int NOT NULL,
sk_almacen int NOT NULL,
--negocio
sk_pozo int NOT NULL,
sk_campaña int NOT NULL,
sk_proceso int NOT NULL,
--producción
	PROD_PETROLEO_CIV float NULL,
	PROD_GAS_CIV float NULL,
	PROD_AGUA_CIV float NULL,
	PROD_PETROLEO_CIV_TEP float NULL,
	PROD_PETROLEO_CIV_CALENDARIO float NULL,
	PROD_GAS_CIV_TEP float NULL,
	PROD_GAS_CIV_CALENDARIO float NULL,
	PROD_AGUA_CIV_TEP float NULL,
	PROD_AGUA_CIV_CALENDARIO float NULL,
	PROD_BRUTA_CM float NULL,
	PROD_SN_CM float NULL,
	PROD_NETA_CM float NULL,
	PROD_GAS_CM float NULL,
	PROD_AGUA_CM float NULL,
	PROD_BRUTA_CM_TEP float NULL,
	PROD_SN_CM_TEP float NULL,
	PROD_NETA_CM_TEP float NULL,
	PROD_GAS_CM_TEP float NULL,
	PROD_AGUA_CM_TEP float NULL,
	PROD_BRUTA_CM_CAL float NULL,
	PROD_SN_CM_CAL float NULL,
	PROD_NETA_CM_CAL float NULL,
	PROD_GAS_CM_CAL float NULL,
	PROD_AGUA_CM_CAL float NULL,
	TEP float NULL,
	TEP_DIA float NULL,
	PRONOSTICO_BRUTA float NULL,
	PRONOSTICO_NETA float NULL,
	PROD_GAS9300CIV float NULL,
	PROD_GAS9300CIV_CAL float NULL,
	PROD_GAS9300CIV_TEP float NULL,
--inyección
	INYECCION_CIV float NULL,
	INYECCION_CIV_TEI float NULL,
	INYECCION_CIV_CAL float NULL,
	TEI float NULL,
	PRONOSTICO_INYECCION float NULL,
	PRONOSTICO_EFECTIVO_MES float NULL,
	PRESION_CIV float NULL
)
