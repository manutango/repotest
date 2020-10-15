ALTER PROC [STO].[SP_FT_PRODUCCION_OIL_GAS_PPTO] AS

BEGIN


/*****************************************************************************************************************/
/** SP que carga datos ficticios de PPTO en STO para datos de Producci�n e Inyecci�n                         	**/
/*****************************************************************************************************************/

/* Limpieza de tablas de STO Producci�n e Inyecci�n FICTICIO*/
TRUNCATE TABLE DW.STO.FT_PRODUCCION_OIL_GAS_PROD_1_FICTICIO;
TRUNCATE TABLE DW.STO.FT_PRODUCCION_OIL_GAS_INY_2_FICTICIO;


/* #################### SEGMENTO PRODUCCI�N #################### */

/* Genero Random de datos de origen para PPTO PRODUCCI�N*/
INSERT INTO DW.STO.FT_PRODUCCION_OIL_GAS_PROD_1_FICTICIO
(
id_escenario_version, id_fecha, id_periodo, id_unidad_negocio, id_empresa, id_grupo_empresa, id_ubicacion, id_proyecto, id_activo, id_pozo_sgo, id_pozo_dw, 
ID_AREA_SGO, id_campa�a, id_proceso,
PROD_PETROLEO_CIV, PROD_GAS_CIV, PROD_AGUA_CIV, PRODUCCION_BASE, ID_POZO, PROD_BRUTA_CIV
)
SELECT
--top 100
	'Presupuesto_Final' as id_escenario_version, -- PRESUPUESTO - Final
	eomonth(id_fecha) as id_fecha, -- CUANDO ES PRESUPUESTO, SE CARGA EN EL ULTIMO DIA DEL MES
	id_periodo,
	id_unidad_negocio,
	id_empresa,
	id_grupo_empresa,
	id_ubicacion,
	id_proyecto,
	id_activo,
	A.ID_POZO_SGO,
	A.ID_POZO_DW,
	A.ID_AREA_SGO,
	id_campa�a,
	'CARGA_PP_FICTICIO_PRODUCCION_E_INY' as id_proceso,	
	PROD_PETROLEO_CIV * ( (ROUND( ( (RAND(CAST( NEWID() AS varbinary ))*(2) )-1 ), 4) /10) +1) as PROD_PETROLEO_CIV,
	PROD_GAS_CIV * ( (ROUND( ( (RAND(CAST( NEWID() AS varbinary ))*(2) )-1 ), 4) /10) +1) as PROD_GAS_CIV,
	PROD_AGUA_CIV * ( (ROUND( ( (RAND(CAST( NEWID() AS varbinary ))*(2) )-1 ), 4) /10) +1) as PROD_AGUA_CIV,
	-1 as PRODUCCION_BASE,
	ID_POZO,
	PROD_BRUTA_CIV * ( (ROUND( ( (RAND(CAST( NEWID() AS varbinary ))*(2) )-1 ), 4) /10) +1) as PROD_BRUTA_CIV
FROM DW.STO.FT_PRODUCCION_OIL_GAS_PROD_1 A
where id_escenario_version = 'Real_Final'
;

-- Limpieza de registros PPTO
DELETE DW.STO.FT_PRODUCCION_OIL_GAS_PROD_1 
where id_escenario_version = 'Presupuesto_Final'


/* Inserto Random de datos de origen para PPTO en STO PRODUCCI�N*/
INSERT INTO DW.STO.FT_PRODUCCION_OIL_GAS_PROD_1
(id_escenario_version, id_fecha, id_periodo, id_unidad_negocio, id_empresa, id_grupo_empresa, id_ubicacion, id_proyecto, id_activo, id_pozo_sgo, id_pozo_dw, id_area_sgo, 
id_campa�a, id_proceso, PROD_PETROLEO_CIV, PROD_GAS_CIV, PROD_AGUA_CIV, PROD_PETROLEO_CIV_TEP, PROD_PETROLEO_CIV_CALENDARIO, PROD_GAS_CIV_TEP, PROD_GAS_CIV_CALENDARIO, 
PROD_AGUA_CIV_TEP, PROD_AGUA_CIV_CALENDARIO, PROD_BRUTA_CM, PROD_SN_CM, PROD_NETA_CM, PROD_GAS_CM, PROD_AGUA_CM, PROD_BRUTA_CM_TEP, PROD_SN_CM_TEP, PROD_NETA_CM_TEP, 
PROD_GAS_CM_TEP, PROD_AGUA_CM_TEP, PROD_BRUTA_CM_CAL, PROD_SN_CM_CAL, PROD_NETA_CM_CAL, PROD_GAS_CM_CAL, PROD_AGUA_CM_CAL, TEP, TEP_DIA, PRONOSTICO_BRUTA, PRONOSTICO_NETA, 
PROD_GAS9300CIV, PROD_GAS9300CIV_CAL, PROD_GAS9300CIV_TEP, PRODUCCION_BASE, ID_ANTIGUEDAD, ID_POZO, PROD_BRUTA_CIV)
SELECT * FROM DW.STO.FT_PRODUCCION_OIL_GAS_PROD_1_FICTICIO;



/* #################### SEGMENTO INYECCI�N #################### */

/* Genero Random de datos de origen para PPTO INYECCI�N*/
INSERT INTO DW.STO.FT_PRODUCCION_OIL_GAS_INY_2_FICTICIO
(
id_escenario_version, id_fecha, id_periodo, id_unidad_negocio, id_empresa, id_grupo_empresa, id_ubicacion, id_proyecto, id_activo, id_pozo_sgo, id_pozo_dw, 
ID_AREA_SGO, id_campa�a, id_proceso, INYECCION_CIV, PRODUCCION_BASE, ID_POZO
)
SELECT
--top 100
	'Presupuesto_Final' as id_escenario_version, -- PRESPUESTO - Final
	eomonth(id_fecha) as id_fecha, -- CUANDO ES PRESUPUESTO, SE CARGA EN EL ULTIMO DIA DEL MES
	id_periodo,
	id_unidad_negocio,
	id_empresa,
	id_grupo_empresa,
	id_ubicacion,
	id_proyecto,
	id_activo,
	A.ID_POZO_SGO,
	A.ID_POZO_DW,
	A.ID_AREA_SGO,
	id_campa�a,
	'CARGA_PP_FICTICIO_PRODUCCION_INY' as id_proceso,	
	INYECCION_CIV * ( (ROUND( ( (RAND(CAST( NEWID() AS varbinary ))*(2) )-1 ), 4) /10) +1) as INYECCION_CIV,
	-1 as PRODUCCION_BASE,
	ID_POZO
FROM DW.STO.FT_PRODUCCION_OIL_GAS_INY_2 A
where id_escenario_version = 'Real_Final'
;

-- Limpieza de registros PPTO
DELETE DW.STO.FT_PRODUCCION_OIL_GAS_INY_2 
where id_escenario_version = 'Presupuesto_Final'

/* Inserto Random de datos de origen para PPTO en STO INYECCI�N*/
INSERT INTO DW.STO.FT_PRODUCCION_OIL_GAS_INY_2
(id_escenario_version, id_fecha, id_periodo, id_unidad_negocio, id_empresa, id_grupo_empresa, id_ubicacion, id_proyecto, id_activo, id_pozo_sgo, id_pozo_dw, id_area_sgo, 
id_campa�a, id_proceso, INYECCION_CIV, INYECCION_CIV_TEI, INYECCION_CIV_CAL, TEI, PRONOSTICO_INYECCION, PRONOSTICO_EFECTIVO_MES, PRESION_CIV, PRODUCCION_BASE, ID_POZO)
SELECT * FROM DW.STO.FT_PRODUCCION_OIL_GAS_INY_2_FICTICIO;


END

/*
select * from DW.STO.FT_PRODUCCION_OIL_GAS_PROD_1_FICTICIO
select * from DW.STO.FT_PRODUCCION_OIL_GAS_PROD_1 where id_escenario_version = 'Presupuesto_Final'
select * from DW.STO.FT_PRODUCCION_OIL_GAS_INY_2_FICTICIO
select * from DW.STO.FT_PRODUCCION_OIL_GAS_INY_2 where id_escenario_version = 'Presupuesto_Final'
*/



