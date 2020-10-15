
--Ubicaciones JDE_UBICACIONES 
select DISTINCT
trim(UBI.ID_UBICACION) as id_ubicacion,
UBI.DESC_UBICACION as desc_ubicacion, 
POZO.id_area as id_area,
POZO.area as desc_area, 
FIX.id_gerencia_operativa as id_cuenca,
FIX.desc_gerencia_operativa as desc_cuenca,
'ND' as id_jurisdiccion, 
'ND' as desc_jurisdiccion, 
'ND' as sk_gis_ubicacion, 
'ND' as sk_gis_area, 
'ND' as sk_gis_cuenca, 
'ND' as sk_gis_jurisdiccion
from staging_in.JDE_UBICACIONES UBI
left outer join STO.DT_POZO POZO on POZO.id_pozo_jde = TRIM(UBI.ID_UBICACION) 
left outer join staging_in.FIX_AREAS_UNIDADES_NEGOCIOS FIX on FIX.id_area_sgo = POZO.id_area and FIX.desc_area_sgo = POZO.area 
where 1=1
--and trim(UBI.ID_UBICACION) ='DAPZI157'
;





