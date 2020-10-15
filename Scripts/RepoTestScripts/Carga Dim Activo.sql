


INSERT INTO DW.modelo_capsa.DT_ACTIVO

select
DENSE_RANK() OVER (ORDER BY  FAAPID) AS sk_activo,
FAAPID as id_activo,
FADL01 as desc_activo,
-1 as sk_clase_activo,
null id_clase_activo,
null desc_clase_activo,
-1 as sk_categoria_activo_contable,
NULL latitud,
NULL longitud,
-1 as sk_instalación,
NULL ubicación,
NULL ciclo_de_vida,
NULL id_gis,
NULL familia,
NULL modelo,
NULL tipo_activo,
-1 as sk_centro
from DW.STI.PVW_LK_ASSETMASTER
where FAAPID <> ''
--and FAAPID = 'PDCPZ1162'





















