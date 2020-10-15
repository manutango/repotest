

--Carga FIX_AREAS_UNIDADES_NEGOCIOS

truncate table DW.staging_aux.FIX_AREAS_UNIDADES_NEGOCIOS

insert into DW.staging_aux.FIX_AREAS_UNIDADES_NEGOCIOS
(id_area_sgo , desc_area_sgo , cod_area_sgo , ID_GERENCIA_OPERATIVA, DESC_GERENCIA_OPERATIVA, COD_GERENCIA_OPERATIVA)

select DISTINCT top 100 ID_AREA , DESC_AREA, COD_AREA, ID_GERENCIA_OPERATIVA, DESC_GERENCIA_OPERATIVA, COD_GERENCIA_OPERATIVA
FROM DW.staging_in.SGO_ZONAS
order by ID_AREA asc









