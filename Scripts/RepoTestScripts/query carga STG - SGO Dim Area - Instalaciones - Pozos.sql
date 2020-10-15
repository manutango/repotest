
--Script de STG -- análisis SGO DA y AC
--Dim Area
--Dim Instalaciones
--Dim Pozos

--Dim Area SGO
select 'DA' as origen, idarea+'-'+'DA' as bk_area, *
from [STI].[SGO_DimArea_202008271803_DA]
union all
select 'AC' as origen, idarea+'-'+'AC' as bk_area,*
from [STI].[SGO_DimArea_202008271807_AC]
order by origen, idarea

--Dim Instalaciones SGO
select top 10 'DA' as origen, idinstalacion+'-'+'DA' as bk_instalacion, *
from [STI].[SGO_DimInstalaciones_202008271804_DA]
union all
select top 10 'AC' as origen, idinstalacion+'-'+'AC' as bk_instalacion, *
from [STI].[SGO_DimInstalaciones_202008271807_AC]

--Dim Pozos SGO
select top 10 'DA' as origen, idpozo+'-'+'DA' as bk_pozo, *
from [STI].[SGO_DimPozo_202008271804_DA]
union all
select top 10 'AC' as origen, idpozo+'-'+'AC' as bk_pozo, *
from [STI].[SGO_DimPozo_202008271814_AC]




select count(*)
from [STI].[SGO_DimPozo_202008271804_DA]