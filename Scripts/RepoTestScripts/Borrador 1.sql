

SELECT *
FROM DW.modelo_capsa.CT_PROCESO
order by 1


/*
--dims
exec modelo_capsa.SP_DT_POZO;
exec modelo_capsa.SP_DT_UNIDAD_GENERADORA_CT;
*/

--Producción
exec STO.SP_FT_PRODUCCION_OIL_GAS_PROD;
exec STO.SP_FT_PRODUCCION_OIL_GAS_INYECCION;
exec STO.SP_FT_PRODUCCION_OIL_GAS_PPTO;

exec modelo_capsa.SP_FT_PRODUCCION_OIL_GAS_PROD;
exec modelo_capsa.SP_FT_PRODUCCION_OIL_GAS_INYECCION;
exec modelo_capsa.SP_FT_PRODUCCION_OIL_GAS_PPTO;


--QUERY CONTROL PRODUCCIÓN
--385515/392925 y 93514/95415
SELECT COUNT(*), P.sk_proceso, P.id_proceso, F.sk_escenario_version, ESC.desc_escenario_version 
FROM DW.modelo_capsa.FT_PRODUCCION_OIL_GAS F
INNER JOIN DW.modelo_capsa.CT_PROCESO P
ON F.sk_proceso = P.sk_proceso 
INNER JOIN DW.modelo_capsa.DT_ESCENARIO_VERSION ESC
ON F.sk_escenario_version = ESC.sk_escenario_version 
GROUP BY P.sk_proceso, P.id_proceso, F.sk_escenario_version, ESC.desc_escenario_version
order by P.sk_proceso
;


--Paradas
exec STO.SP_FT_PARADAS_OIL_GAS_PROD;
exec STO.SP_FT_PARADAS_OIL_GAS_INY;

exec modelo_capsa.SP_FT_PARADAS_OIL_GAS_PROD;
exec modelo_capsa.SP_FT_PARADAS_OIL_GAS_INY;


--QUERY CONTROL PARADAS
--1999902/2028953 y  188053/194063
SELECT COUNT(*), P.sk_proceso, P.id_proceso, F.sk_escenario_version, ESC.desc_escenario_version 
FROM DW.modelo_capsa.FT_PARADAS_OIL_GAS F
INNER JOIN DW.modelo_capsa.CT_PROCESO P
ON F.sk_proceso = P.sk_proceso 
INNER JOIN DW.modelo_capsa.DT_ESCENARIO_VERSION ESC
ON F.sk_escenario_version = ESC.sk_escenario_version 
GROUP BY P.sk_proceso, P.id_proceso, F.sk_escenario_version, ESC.desc_escenario_version
order by P.sk_proceso
;


--Producción Energía
exec STO.SP_FT_PRODUCCION_ENERGIA;
exec modelo_capsa.SP_FT_PRODUCCION_ENERGIA;

exec STO.SP_FT_PRODUCCION_ENERGIA_PPTO_REPRO
exec modelo_capsa.SP_FT_PRODUCCION_ENERGIA_PPTO_REPRO


--QUERY CONTROL ENERGÍA
--28637/28637 (Cierre Diario) + 2044/2044 (Cierre Diario Planta) = 30681/30681
SELECT COUNT(*), P.sk_proceso, P.id_proceso, F.sk_escenario_version, ESC.desc_escenario_version 
FROM DW.modelo_capsa.FT_PRODUCCION_ENERGIA F
INNER JOIN DW.modelo_capsa.CT_PROCESO P
ON F.sk_proceso = P.sk_proceso 
INNER JOIN DW.modelo_capsa.DT_ESCENARIO_VERSION ESC
ON F.sk_escenario_version = ESC.sk_escenario_version 
GROUP BY P.sk_proceso, P.id_proceso, F.sk_escenario_version, ESC.desc_escenario_version
order by P.sk_proceso
;

select max(fecha) FROM DW.staging_in.SGP_CIERRE_DIARIO_CT --28637
select max(fecha) FROM DW.staging_in.SGP_CIERRE_DIARIO_CT_PLANTA --2044


select *
from dw.modelo_capsa.FT_PRODUCCION_ENERGIA
where sk_unidad_generadora_ct = 9 --ID_UNIDAD_GENERADORA = 'C' SGP_CIERRE_DIARIO_CT_PLANTA


--Controles
exec STO.SP_FT_CONTROLES_OIL_GAS_PROD;
exec STO.SP_FT_CONTROLES_OIL_GAS_INY;

exec modelo_capsa.SP_FT_CONTROLES_OIL_GAS_PROD;
exec modelo_capsa.SP_FT_CONTROLES_OIL_GAS_INY;


--QUERY CONTROL CONTROLES
--191592/191592 y 221502/221502
SELECT COUNT(*), P.sk_proceso, P.id_proceso, F.sk_escenario_version, ESC.desc_escenario_version 
FROM DW.modelo_capsa.FT_CONTROLES_OIL_GAS F
INNER JOIN DW.modelo_capsa.CT_PROCESO P
ON F.sk_proceso = P.sk_proceso 
INNER JOIN DW.modelo_capsa.DT_ESCENARIO_VERSION ESC
ON F.sk_escenario_version = ESC.sk_escenario_version 
GROUP BY P.sk_proceso, P.id_proceso, F.sk_escenario_version, ESC.desc_escenario_version
order by P.sk_proceso
;

select count(*) FROM DW.staging_in.SGO_CONTROLES_PRODUCCION
select count(*) FROM DW.staging_in.SGO_CONTROLES_INYECCION


DW.modelo_capsa.FT_PRODUCCION_ENERGIA
DW.modelo_capsa.DT_UNIDAD_GENERADORA_CT












select distinct sk_ubicacion
from dw.modelo_capsa.DT_ACTIVO da 

--PRODUCCIÓN
select count(*) from dw.staging_in.BISGO_PRODUCCIONCIV;
select count(*) from dw.staging_in.BISGO_INYECCIONCIV;

--PARADAS
select count(*) from dw.staging_in.SGO_PARADAS_PRODUCCION;
select count(*) from dw.staging_in.SGO_PARADAS_INYECCION;




select * from DW.STO.FT_PRODUCCION_ENERGIA_PP_FICTICIO;
select * from DW.STO.FT_PRODUCCION_ENERGIA_REPRO_FICTICIO;














--Caso error de origen con ID_ZONA_SGO en NULL
select *
from dw.staging_in.SGO_POZOS
where id_pozo_dw = 3489
;


--Caso 2 error de origen con ID_ZONA_SGO en NULL
select *
from dw.staging_in.SGO_POZOS
where id_pozo_dw = 1165

select * from DW.staging_aux.FIX_AREAS_UNIDADES_NEGOCIOS 

select * from dw.sto.DT_POZO
where id_pozo_dw = 1165
;


select * from dw.modelo_capsa.FT_PRODUCCION_OIL_GAS




select * from DW.modelo_capsa.FT_PARADAS_OIL_GAS







--id_pozo_dw + Area que no están en SGO Pozos
select distinct A.ID_POZO_DW, A.ID_AREA_DW 
FROM DW.staging_in.SGO_PARADAS_PRODUCCION A
where id_pozo_dw = 3489
and exists (select null from DW.staging_in.SGO_POZOS P
				  where A.ID_POZO_DW = P.ID_POZO_DW and A.ID_AREA_DW = P.ID_AREA_SGO )			  
;				  
				  




----------------------
--182
--Pozo + Area que no están en SGO Pozos
select distinct A.ID_POZO_SGO, A.ID_AREA_SGO
FROM DW.staging_in.BISGO_PRODUCCIONCIV A
where not exists (select distinct ID_POZO_SGO, ID_AREA_SGO from DW.staging_in.SGO_POZOS P
				  where A.ID_POZO_SGO = P.ID_POZO_SGO
				  and A.ID_AREA_SGO = P.ID_AREA_SGO)


--265
--id_pozo_dw + Area que no están en SGO Pozos
select distinct A.ID_POZO_DW, A.ID_AREA_SGO
FROM DW.staging_in.BISGO_PRODUCCIONCIV A
where not exists (select distinct ID_POZO_SGO, ID_AREA_SGO from DW.staging_in.SGO_POZOS P
				  where A.ID_POZO_DW = P.ID_POZO_DW and A.ID_AREA_SGO = P.ID_AREA_SGO )				  
				  


select ( (ROUND( ( (RAND(CAST( NEWID() AS varbinary ))*(2) )-1 ), 4) /10) +1);

















				  
				  