
--Dim Pozos SGO
select top 100 'DA' as origen, idpozo+'-'+'DA' as bk_pozo, *
from [STI].[SGO_DimPozo_202008271804_DA]
where codigopozo = 4
union all
select top 10 'AC' as origen, idpozo+'-'+'AC' as bk_pozo, *
from [STI].[SGO_DimPozo_202008271814_AC]
where codigopozo = 4
order by desde



--Ejemplo
select 'AC' as origen, idpozo+'-'+'AC' as bk_pozo, *
from [STI].[SGO_DimPozo_202008271814_AC]
where codigopozo = '1080'
order by desde

