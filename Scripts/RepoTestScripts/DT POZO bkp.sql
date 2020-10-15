
/*
 
 ** Método de carga Dim Pozo: **

0) Staging IN/OUT:
   DW.staging_in.SGO_POZOS --> DW.STO.DT_POZO 

*) Tabla Aux para Reprocesos y cambios de IDs
   Se cargan Aux con histórica de BK para usar en reprocesos.

1) Coindide la bk --> UPDATE
   Se actualizan atributos en base a la BK.
   BK: area - pozo - vigencia desde/hasta

2) Nueva bk --> INSERT
   Si no existen las BK. Se insertan nuevos sk en la Dimensión.
   BK: area - pozo - vigencia desde/hasta

3) Purgar los sks en caso de reprocesos:

	A) Si hay hechos (sk existentes) --> se debe reprocesar la fact.
       Implica un reproceso full o bien un script específico que compare por la bk completa.
       El script compara y actualiza sk de la Fact vs sk de la Dimensión por Fecha de vigencia.
   
	B) Si no hay hechos asociados (sk huérfanos) --> se borran de la Dimensión.

*/


/* ################################### STG ################################### */

/* 0) Staging IN/OUT: */

TRUNCATE TABLE DW.STO.DT_POZO

INSERT INTO DW.STO.DT_POZO
SELECT
--top 100
DISTINCT
DENSE_RANK() OVER (ORDER BY  ID_POZO_SGO) AS sk_pozo --generado
, -1 as sk_clase_activo
, A.EQUIPOJDE as id_pozo_jde --ver como obtener este código de JDE?
, A.ID_POZO_SGO as cod_pozo
, A.ID_AREA_SGO
, A.AREA
, NULL as desc_pozo
, A.NOMBRE
, A.DESDE
, A.HASTA
, NULL as actual --no viene en nuevo stg
, A.CAMPAÑA as id_campaña_creacion
, -1 as id_campaña_produccion
, NULL as id_tipo_pozo
, A.TIPO_POZO
, NULL as id_pozo_tipo 
, NULL as desc_pozo_tipo
, NULL as id_etapa
, A.ETAPA
, NULL as id_metodo_extraccion 
, A.METODO_EXTRACCION
, NULL as id_sub_metodo_extraccion
, A.SUBMETODO_EXTRACCION
, NULL as id_tipo_instalacion_inyeccion
, A.TIPOINSTALACIONINYECCION
, NULL as id_clase_perforacion 
, NULL as desc_clase_perforacion 
, NULL as id_profundidad_final 
, NULL as desc_profundidad_final 
, A.COTA
, NULL as id_caracter 
, A.CARACTER
, NULL as id_tipo_producto 
, A.TIPO_PRODUCTO
, A.PRODUCE_PETROLEO
, A.PRODUCE_GAS
, A.PRODUCE_AGUA
, NULL as id_estado_pozo 
, A.ESTADO
, NULL as DuracionDiasEstado
, NULL as id_planta_petroleo 
, A.PLANTA_PETROLEO
, NULL as id_planta_gas 
, A.PLANTA_GAS
, NULL as id_planta_agua 
, A.PLANTA_AGUA
, A.MOTIVO
, NULL as id_faja 
, A.FAJA
, NULL as id_antiguedad 
, A.PROYECTO1
, A.PROYECTO2
, NULL as id_bateria 
, A.BATERIA
, NULL as id_ubicacion 
, NULL as id_cuenta_objeto_pozo 
, NULL as id_Equipo_torre 
, NULL as id_gis 
, NULL as id_fecha_perforacion 
, NULL as id_fecha_terminacion 
FROM DW.staging_in.SGO_POZOS A
--where A.ID_POZO_SGO = '26' and desde = '2000-07-22' and hasta = '2000-08-01'


/* ################################### DIM ################################### */

/* Tabla Aux para Reprocesos y cambios de IDs */

TRUNCATE TABLE DW.modelo_capsa.DT_POZO_REPRO

INSERT INTO DW.modelo_capsa.DT_POZO_REPRO
SELECT sk_pozo, cod_pozo, id_area, vigencia_desde, vigencia_hasta 
FROM DW.modelo_capsa.DT_POZO
--WHERE cod_pozo = 26 and vigencia_desde = '2000-07-22' and vigencia_hasta = '2000-08-01'


-----------------------------------------------------------------------------------

/* 1 - Coindide la bk --> UPDATE */

/* * ACTUALIZAR CON ÚLTIMA VERSIÓN DE STG CAPSA */

UPDATE DW.modelo_capsa.DT_POZO
SET 
 [sk_clase_activo]	=	A.[id_clase_activo]
,[id_pozo]	=	A.[id_pozo_jde]
,[cod_pozo]	=	A.[cod_pozo]
,[id_area]	=	A.[id_area]
,[area]	=	A.[area]
,[desc_pozo]	=	A.[desc_pozo]
,[nombre_pozo]	=	A.[nombre_pozo]
,[vigencia_desde]	=	A.[vigencia_desde]
,[vigencia_hasta]	=	A.[vigencia_hasta]
,[actual]	=	A.[actual]
,[id_campaña_creacion]	=	A.[id_campaña_creacion]
,[id_campaña_produccion]	=	A.[id_campaña_produccion]
,[sk_tipo_pozo]	=	-1
,[id_tipo_pozo]	=	A.[id_tipo_pozo]
,[desc_tipo_pozo]	=	A.[desc_tipo_pozo]
,[sk_pozo_tipo]	=	-1
,[id_pozo_tipo]	=	A.[id_pozo_tipo]
,[desc_pozo_tipo]	=	A.[desc_pozo_tipo]
,[sk_etapa]	=	-1
,[id_etapa]	=	A.[id_etapa]
,[desc_etapa]	=	A.[desc_etapa]
,[sk_metodo_extraccion]	=	-1
,[id_metodo_extraccion]	=	A.[id_metodo_extraccion]
,[desc_metodo_extraccion]	=	A.[desc_metodo_extraccion]
,[sk_sub_metodo_extraccion]	=	-1
,[id_sub_metodo_extraccion]	=	A.[id_sub_metodo_extraccion]
,[desc_sub_metodo_extraccion]	=	A.[desc_sub_metodo_extraccion]
,[sk_tipo_instalacion_inyeccion]	=	-1
,[id_tipo_instalacion_inyeccion]	=	A.[id_tipo_instalacion_inyeccion]
,[desc_tipo_instalacion_inyeccion]	=	A.[desc_tipo_instalacion_inyeccion]
,[sk_clase_perforacion]	=	-1
,[id_clase_perforacion]	=	A.[id_clase_perforacion]
,[desc_clase_perforacion]	=	A.[desc_clase_perforacion]
,[sk_profundidad_final]	=	-1
,[id_profundidad_final]	=	A.[id_profundidad_final]
,[desc_profundidad_final]	=	A.[desc_profundidad_final]
,[cota]	=	A.[cota]
,[sk_caracter]	=	-1
,[id_caracter]	=	A.[id_caracter]
,[desc_caracter]	=	A.[desc_caracter]
,[sk_tipo_producto]	=	-1
,[id_tipo_producto]	=	A.[id_tipo_producto]
,[desc_tipo_producto]	=	A.[desc_tipo_producto]
,[produce_petroleo]	=	A.[produce_petroleo]
,[produce_gas]	=	A.[produce_gas]
,[produce_agua]	=	A.[produce_agua]
,[sk_estado_pozo]	=	-1
,[id_estado_pozo]	=	A.[id_estado_pozo]
,[desc_estado_pozo]	=	A.[desc_estado_pozo]
,[estado_duracion_dias]	=	A.[estado_duracion_dias]
,[sk_planta_petroleo]	=	-1
,[id_planta_petroleo]	=	A.[id_planta_petroleo]
,[desc_planta_petroleo]	=	A.[desc_planta_petroleo]
,[sk_planta_gas]	=	-1
,[id_planta_gas]	=	A.[id_planta_gas]
,[desc_planta_gas]	=	A.[desc_planta_gas]
,[sk_planta_agua]	=	-1
,[id_planta_agua]	=	A.[id_planta_agua]
,[desc_planta_agua]	=	A.[desc_planta_agua]
,[motivo]	=	A.[motivo]
,[sk_faja]	=	-1
,[id_faja]	=	A.[id_faja]
,[faja]	=	A.[faja]
,[id_antiguedad]	=	A.[id_antiguedad]
,[Proyecto_1]	=	A.[Proyecto_1]
,[Proyecto_2]	=	A.[Proyecto_2]
,[sk_bateria]	=	-1
,[id_bateria]	=	A.[id_bateria]
,[desc_bateria]	=	A.[desc_bateria]
,[sk_ubicacion]	=	isnull(A.[id_ubicacion],-1)
,[sk_cuenta_objeto_pozo]	=	A.[id_cuenta_objeto_pozo]
,[sk_Equipo_torre]	=	A.[id_Equipo_torre]
,[id_gis]	=	A.[id_gis]
,[sk_fecha_perforacion]	=	A.[id_fecha_perforacion]
,[sk_fecha_terminacion]	=	A.[id_fecha_terminacion]
FROM DW.STO.DT_POZO A
WHERE EXISTS 
(
	SELECT null FROM DW.modelo_capsa.DT_POZO P
	WHERE A.ID_AREA = P.id_area
	 and A.cod_POZO = P.cod_pozo 
	 and A.vigencia_desde = P.vigencia_desde 
	 and A.vigencia_hasta = P.vigencia_hasta 
)


/* 2 - Cambia la bk --> INSERT INTO DW.DT_POZO*/

--truncate table DW.modelo_capsa.DT_POZO

INSERT INTO DW.modelo_capsa.DT_POZO
SELECT
--top 100
   [id_pozo]
  ,[id_clase_activo]
  ,[id_pozo_jde]
  ,[cod_pozo]
  ,[id_area]
  ,[area]
  ,[desc_pozo]
  ,[nombre_pozo]
  ,[vigencia_desde]
  ,[vigencia_hasta]
  ,[actual]
  ,[id_campaña_creacion]
  ,[id_campaña_produccion]
, -1 AS [sk_tipo_pozo]
  ,[id_tipo_pozo]
  ,[desc_tipo_pozo]
, -1 AS [sk_pozo_tipo]
  ,[id_pozo_tipo]
  ,[desc_pozo_tipo]
 , -1 AS [sk_etapa]
  ,[id_etapa]
  ,[desc_etapa]
, -1 AS [sk_metodo_extraccion]
  ,[id_metodo_extraccion]
  ,[desc_metodo_extraccion]
, -1 AS [sk_sub_metodo_extraccion]
  ,[id_sub_metodo_extraccion]
  ,[desc_sub_metodo_extraccion]
, -1 AS [sk_tipo_instalacion_inyeccion]
  ,[id_tipo_instalacion_inyeccion]
  ,[desc_tipo_instalacion_inyeccion]
, -1 AS [sk_clase_perforacion]
  ,[id_clase_perforacion]
  ,[desc_clase_perforacion]
,-1 AS [sk_profundidad_final]
  ,[id_profundidad_final]
  ,[desc_profundidad_final]
  ,[cota]
, -1 AS [sk_caracter]
  ,[id_caracter]
  ,[desc_caracter]
, -1 AS [sk_tipo_producto]
  ,[id_tipo_producto]
  ,[desc_tipo_producto]
  ,[produce_petroleo]
  ,[produce_gas]
  ,[produce_agua]
,-1 AS [sk_estado_pozo]
  ,[id_estado_pozo]
  ,[desc_estado_pozo]
  ,[estado_duracion_dias]
,-1 AS [sk_planta_petroleo]
  ,[id_planta_petroleo]
  ,[desc_planta_petroleo]
,-1 AS [sk_planta_gas]
  ,[id_planta_gas]
  ,[desc_planta_gas]
, -1 AS [sk_planta_agua]
  ,[id_planta_agua]
  ,[desc_planta_agua]
  ,[motivo]
, -1 AS [sk_faja]
  ,[id_faja]
  ,[faja]
  ,[id_antiguedad]
  ,[Proyecto_1]
  ,[Proyecto_2]
,-1 AS [sk_bateria]
  ,[id_bateria]
  ,[desc_bateria]
  ,-1 AS [id_ubicacion]
  ,-1 AS [id_cuenta_objeto_pozo]
  ,-1 AS [id_Equipo_torre]
  ,-1 AS [id_gis]
  ,-1 AS [id_fecha_perforacion]
  ,-1 AS [id_fecha_terminacion]  
FROM DW.STO.DT_POZO A
WHERE NOT EXISTS 
(
	SELECT null FROM DW.modelo_capsa.DT_POZO P
	WHERE A.ID_AREA = P.id_area
	 and A.cod_POZO = P.cod_pozo 
	 and A.vigencia_desde = P.vigencia_desde 
	 and A.vigencia_hasta = P.vigencia_hasta 
)


--------------------------------------------------------------------------------------------

/* 3 - Purgar los sks  */

/*
A) Si hay hechos (sk existentes) --> se debe reprocesar la fact.
   Implica un reproceso full o bien un script específico que compare por la bk completa.
   El script compara y actualiza sk de la Fact vs sk de la Dimensión por Fecha de vigencia.
*/

UPDATE FT_PRODUCCION FT
SET FT.sk_activo = P.sk_activo
FROM FT
JOIN DW.modelo_capsa.DT_POZO P
ON FT.sk_activo = P.sk_activo
JOIN DW.modelo_capsa.DT_POZO_REPRO REPRO
ON P.sk_activo = REPRO.sk_activo
AND P.cod_pozo = REPRO.cod_pozo 
AND P.id_area = REPRO.id_area
AND P.vigencia_desde = REPRO.vigencia_desde
AND P.vigencia_hasta = REPRO.vigencia_hasta
WHERE EXISTS 
	(--JOIN DE FT = REPRO por sk_activo, vigencia desde/hasta)


/*
 B) Marco en FLAG los sk actualizados en los hechos y que se deberán borrar.
*/	
UPDATE DW.modelo_capsa.DT_POZO
SET FLAG = 1

	
/* 
C) Aquellos sk con FLAG = 1, se borran de la Dimensión.
*/
	
--DELETE
DELETE DW.modelo_capsa.DT_POZO
WHERE FLAG = 1

	














