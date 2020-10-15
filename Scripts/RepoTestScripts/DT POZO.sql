
ALTER procedure modelo_capsa.SP_DT_POZO
as

begin
	
/*****************************************************************************************************************/
/** SP que carga la tabla DT_POZO con datos de SGO SGO_POZOS y SGO_ZONAS                                        **/
/*****************************************************************************************************************/

/*
sk_pozo =  id area sgo + id pozo sgo + desde/hasta + id_pozo_dw
*/


/* ################################### STG ################################### */

--Cargo tabla de Staging OUT
TRUNCATE TABLE DW.STO.DT_POZO;

INSERT INTO DW.STO.DT_POZO
SELECT
DISTINCT
  trim(CAST(A.ID_AREA_SGO AS VARCHAR) + '-' + CAST(A.ID_POZO_SGO AS VARCHAR)) as id_pozo
, A.EQUIPOJDE as id_pozo_jde
, A.ID_POZO_SGO as cod_pozo
, A.ID_AREA_SGO
, A.area as desc_area
, A.NOMBRE as desc_pozo
, A.NOMBRE as nombre_pozo 
, A.DESDE as vigencia_desde 
, A.HASTA as vigencia_hasta 
, NULL as actual --no viene en nuevo stg
, A.CAMPAÑA as id_campaña_creacion
, -1 as id_campaña_produccion
, A.TIPO_POZO as id_tipo_pozo
, A.TIPO_POZO
, NULL as id_pozo_tipo 
, NULL as desc_pozo_tipo
, A.ETAPA as id_etapa
, A.ETAPA
, A.METODO_EXTRACCION as id_metodo_extraccion 
, A.METODO_EXTRACCION
, A.SUBMETODO_EXTRACCION as id_sub_metodo_extraccion
, A.SUBMETODO_EXTRACCION
, A.TIPOINSTALACIONINYECCION as id_tipo_instalacion_inyeccion
, A.TIPOINSTALACIONINYECCION
, NULL as id_clase_perforacion 
, NULL as desc_clase_perforacion 
, NULL as id_profundidad_final 
, NULL as desc_profundidad_final 
, A.COTA
, A.CARACTER as id_caracter 
, A.CARACTER
, A.TIPO_PRODUCTO as id_tipo_producto 
, A.TIPO_PRODUCTO
, A.PRODUCE_PETROLEO
, A.PRODUCE_GAS
, A.PRODUCE_AGUA
, A.ESTADO as id_estado_pozo 
, A.ESTADO
, NULL as DuracionDiasEstado
, A.PLANTA_PETROLEO as id_planta_petroleo 
, A.PLANTA_PETROLEO
, A.PLANTA_GAS as id_planta_gas 
, A.PLANTA_GAS
, A.PLANTA_AGUA as id_planta_agua 
, A.PLANTA_AGUA
, A.MOTIVO
, A.FAJA as id_faja 
, A.FAJA as desc_faja
, NULL as id_antiguedad 
, A.PROYECTO1
, A.PROYECTO2
, A.ID_ZONA_SGO
, A.ZONA as desc_zona_sgo
, A.YACIMIENTO
, A.JOBJDE 
, A.BATERIA as id_bateria 
, A.BATERIA
, -1 as id_ubicacion 
, A.LATITUD
, A.LONGITUD 
, NULL as cuenta_objeto_pozo 
, NULL as Equipo_torre 
, NULL as id_gis 
, NULL as fecha_perforacion 
, NULL as fecha_terminacion
, A.ID_POZO_DW 
, z.id_gerencia_operativa 
, z.desc_gerencia_operativa 
FROM DW.staging_in.SGO_POZOS A
LEFT JOIN DW.staging_in.SGO_ZONAS Z
ON A.ID_ZONA_SGO = Z.ID_ZONA AND A.AREA = Z.DESC_AREA 
--where id_pozo_dw = 12770
;


--Actualización de atributos:
UPDATE D
SET 
 id_pozo_jde = A.id_pozo_jde
,desc_area	=	A.desc_area
,desc_pozo	=	A.desc_pozo
,nombre_pozo	=	A.nombre_pozo
,actual	=	A.actual
,id_campaña_creacion	=	A.id_campaña_creacion
,id_campaña_produccion	=	A.id_campaña_produccion
,id_tipo_pozo	=	A.id_tipo_pozo
,desc_tipo_pozo	=	A.desc_tipo_pozo
,id_pozo_tipo	=	A.id_pozo_tipo
,desc_pozo_tipo	=	A.desc_pozo_tipo
,id_etapa	=	A.id_etapa
,desc_etapa	=	A.desc_etapa
,id_metodo_extraccion	=	A.id_metodo_extraccion
,desc_metodo_extraccion	=	A.desc_metodo_extraccion
,id_sub_metodo_extraccion	=	A.id_sub_metodo_extraccion
,desc_sub_metodo_extraccion	=	A.desc_sub_metodo_extraccion
,id_tipo_instalacion_inyeccion	=	A.id_tipo_instalacion_inyeccion
,desc_tipo_instalacion_inyeccion	=	A.desc_tipo_instalacion_inyeccion
,id_clase_perforacion	=	A.id_clase_perforacion
,desc_clase_perforacion	=	A.desc_clase_perforacion
,id_profundidad_final	=	A.id_profundidad_final
,desc_profundidad_final	=	A.desc_profundidad_final
,cota	=	A.cota
,id_caracter	=	A.id_caracter
,desc_caracter	=	A.desc_caracter
,id_tipo_producto	=	A.id_tipo_producto
,desc_tipo_producto	=	A.desc_tipo_producto
,produce_petroleo	=	A.produce_petroleo
,produce_gas	=	A.produce_gas
,produce_agua	=	A.produce_agua
,id_estado_pozo	=	A.id_estado_pozo
,desc_estado_pozo	=	A.desc_estado_pozo
,estado_duracion_dias	=	A.estado_duracion_dias
,id_planta_petroleo	=	A.id_planta_petroleo
,desc_planta_petroleo	=	A.desc_planta_petroleo
,id_planta_gas	=	A.id_planta_gas
,desc_planta_gas	=	A.desc_planta_gas
,id_planta_agua	=	A.id_planta_agua
,desc_planta_agua	=	A.desc_planta_agua
,motivo	=	A.motivo
,id_faja	=	A.id_faja
,desc_faja	=	A.desc_faja
,id_antiguedad  = A.id_antiguedad
,Proyecto_1	=	A.Proyecto_1
,Proyecto_2	=	A.Proyecto_2
,id_zona_sgo = A.id_zona_sgo
,desc_zona_sgo = A.desc_zona_sgo
,yacimiento = A.yacimiento
,job_jde = A.job_jde
,id_bateria	=	A.id_bateria
,desc_bateria	=	A.desc_bateria
,sk_ubicacion	=	isnull(A.id_ubicacion,-1)
,latitud = A.latitud
,longitud = A.longitud
,cuenta_objeto_pozo	=	A.cuenta_objeto_pozo
,Equipo_torre	=	A.Equipo_torre
,id_gis	=	A.id_gis
,fecha_perforacion	=	A.fecha_perforacion
,fecha_terminacion	=	A.fecha_terminacion
,id_pozo_dw = A.id_pozo_dw
,id_gerencia_operativa = a.id_gerencia_operativa
,desc_gerencia_operativa = a.desc_gerencia_operativa
FROM DW.modelo_capsa.DT_POZO D
INNER JOIN DW.STO.DT_POZO A
ON 	 D.id_pozo = A.id_pozo
 and D.ID_AREA = A.id_area
 and D.cod_POZO = A.cod_pozo 
 and D.vigencia_desde = A.vigencia_desde 
 and D.vigencia_hasta = A.vigencia_hasta
 and D.id_pozo_dw = A.id_pozo_dw 
;


--Inserción de deltas
INSERT INTO DW.modelo_capsa.DT_POZO (sk_pozo, id_pozo, id_pozo_jde, cod_pozo, id_area, desc_area, desc_pozo, nombre_pozo, vigencia_desde, vigencia_hasta, actual, 
id_campaña_creacion, id_campaña_produccion, id_tipo_pozo, desc_tipo_pozo, id_pozo_tipo, desc_pozo_tipo, id_etapa, desc_etapa, id_metodo_extraccion, desc_metodo_extraccion, 
id_sub_metodo_extraccion, desc_sub_metodo_extraccion, id_tipo_instalacion_inyeccion, desc_tipo_instalacion_inyeccion, id_clase_perforacion, desc_clase_perforacion, 
id_profundidad_final, desc_profundidad_final, cota, id_caracter, desc_caracter, id_tipo_producto, desc_tipo_producto, produce_petroleo, produce_gas, produce_agua, 
id_estado_pozo, desc_estado_pozo, estado_duracion_dias, id_planta_petroleo, desc_planta_petroleo, id_planta_gas, desc_planta_gas, id_planta_agua, desc_planta_agua, 
motivo, id_faja, desc_faja, id_antiguedad, Proyecto_1, Proyecto_2, id_zona_sgo, desc_zona_sgo, yacimiento, job_jde, id_bateria, desc_bateria, sk_ubicacion, latitud, longitud, cuenta_objeto_pozo, 
Equipo_torre, id_gis, fecha_perforacion, fecha_terminacion, id_pozo_dw, sk_activo, id_gerencia_operativa, desc_gerencia_operativa)
SELECT
DISTINCT
(SELECT case when isnull(MAX(sk_pozo),0) < 0 then 0 else isnull(MAX(sk_pozo),0) end FROM dw.modelo_capsa.DT_POZO) +
DENSE_RANK() OVER (ORDER BY CAST(ID_AREA AS VARCHAR) + '-' + CAST(cod_pozo AS VARCHAR) + '-' + CAST(A.vigencia_desde AS VARCHAR)  + '-' + CAST(A.vigencia_hasta AS VARCHAR) + CAST(A.id_pozo_dw AS VARCHAR)) AS sk_pozo
  ,id_pozo
  ,id_pozo_jde
  ,cod_pozo
  ,id_area
  ,desc_area
  ,desc_pozo
  ,nombre_pozo
  ,vigencia_desde
  ,vigencia_hasta
  ,actual
  ,id_campaña_creacion
  ,id_campaña_produccion
  ,id_tipo_pozo
  ,desc_tipo_pozo
  ,id_pozo_tipo
  ,desc_pozo_tipo
  ,id_etapa
  ,desc_etapa
  ,id_metodo_extraccion
  ,desc_metodo_extraccion
  ,id_sub_metodo_extraccion
  ,desc_sub_metodo_extraccion
  ,id_tipo_instalacion_inyeccion
  ,desc_tipo_instalacion_inyeccion
  ,id_clase_perforacion
  ,desc_clase_perforacion
  ,id_profundidad_final
  ,desc_profundidad_final
  ,cota
  ,id_caracter
  ,desc_caracter
  ,id_tipo_producto
  ,desc_tipo_producto
  ,produce_petroleo
  ,produce_gas
  ,produce_agua
  ,id_estado_pozo
  ,desc_estado_pozo
  ,estado_duracion_dias
  ,id_planta_petroleo
  ,desc_planta_petroleo
  ,id_planta_gas
  ,desc_planta_gas
  ,id_planta_agua
  ,desc_planta_agua
  ,motivo
  ,id_faja
  ,desc_faja
  ,id_antiguedad
  ,Proyecto_1
  ,Proyecto_2
  , id_zona_sgo  
  ,desc_zona_sgo
  ,yacimiento
  ,job_jde
  ,id_bateria
  ,desc_bateria
  ,id_ubicacion
  ,latitud
  ,longitud
  ,-2 AS cuenta_objeto_pozo
  ,-2 AS Equipo_torre
  ,-2 AS id_gis
  ,-2 AS fecha_perforacion
  ,-2 AS fecha_terminacion 
  , A.id_pozo_dw
  , -2 AS sk_activo
  , id_gerencia_operativa
  , desc_gerencia_operativa  
FROM DW.STO.DT_POZO A
WHERE NOT EXISTS 
(
	SELECT null FROM DW.modelo_capsa.DT_POZO P
	WHERE 
	     A.id_pozo = P.id_pozo
 	 and A.ID_AREA = P.id_area
	 and A.cod_POZO = P.cod_pozo 
	 and A.vigencia_desde = P.vigencia_desde 
	 and A.vigencia_hasta = P.vigencia_hasta 
	 and P.id_pozo_dw = A.id_pozo_dw 	 
)
--and A.id_pozo_dw = 12770
;


--Obtengo sk activo desde DT_ACTIVO
UPDATE P
SET P.sk_activo = A.sk_activo 
FROM DW.modelo_capsa.DT_POZO P
INNER JOIN DW.modelo_capsa.DT_ACTIVO A
ON P.id_pozo_jde = A.nombre_activo
;


--Ajustes posteriores Datos Mapas (lat/long)

--FIX Problema: tienen latitud y longitud en 0.
UPDATE P 
set latitud = -45.700020, longitud = -67.456020
from dw.modelo_capsa.DT_POZO P 
where desc_pozo = 'KMA-605' and desc_area = 'KM 20';

UPDATE P set latitud = -45.700030, longitud = -67.456030
from dw.modelo_capsa.DT_POZO P 
where desc_pozo = 'KMAE-714' and desc_area = 'KM 20';

--FIX Problema: su longitud se va a Chile con -74,8233333.
UPDATE P 
set longitud = -67.82333333
from dw.modelo_capsa.DT_POZO P 
where desc_pozo = 'E-191' and desc_area = 'Diadema';



end






