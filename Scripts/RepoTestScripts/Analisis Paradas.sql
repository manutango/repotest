


select distinct DESDE, HASTA 
FROM DW.staging_in.SGO_PARADAS_PRODUCCION
;



--Evento en mismo bk
select count(*), id_evento from 
(
	SELECT
	cast(ID_AREA_DW as varchar) +'-'+ cast(ID_POZO_DW as varchar) +'-'+ substring(cast(ID_FECHA as varchar),1,10) +'-'+ cast(ID_MOTIVO as varchar) +'-'+ cast(ID_CAUSA as varchar)+ '-' +
	cast(ROW_NUMBER() OVER(ORDER BY ID_AREA_DW, ID_POZO_DW, ID_FECHA , ID_MOTIVO , ID_CAUSA) as varchar) as id_evento
	FROM DW.staging_in.SGO_PARADAS_PRODUCCION
) x
group by id_evento 
having count(*)>1
;



--Evento en mismo bk
SELECT
cast(ID_AREA_DW as varchar) +'-'+ cast(ID_POZO_DW as varchar) +'-'+ substring(cast(ID_FECHA as varchar),1,10) +'-'+ cast(ID_MOTIVO as varchar) +'-'+ cast(ID_CAUSA as varchar)+ '-' +
cast(ROW_NUMBER() OVER(ORDER BY ID_AREA_DW, ID_POZO_DW, ID_FECHA , ID_MOTIVO , ID_CAUSA) as varchar)
,ID_AREA_DW, ID_POZO_DW, ID_FECHA , ID_MOTIVO , ID_CAUSA
,*
FROM DW.staging_in.SGO_PARADAS_PRODUCCION
where ID_POZO_DW = 12277 and ID_FECHA = '2011-06-22 00:00:00' and ID_MOTIVO = 8 and ID_CAUSA = 1
;


--Paradas Producción
select count(*), ID_AREA_DW, ID_POZO_DW, ID_FECHA , ID_MOTIVO , ID_CAUSA 
FROM DW.staging_in.SGO_PARADAS_PRODUCCION
group by ID_AREA_DW, ID_POZO_DW, ID_FECHA , ID_MOTIVO , ID_CAUSA
having count(*)>1
;



SELECT distinct DESDE, HASTA 
FROM DW.staging_in.SGO_PARADAS_PRODUCCION
order by 1
;

select 
FROM DW.staging_in.SGO_PARADAS_PRODUCCION
where ID_POZO_DW 


--Paradas Inyección
select * FROM DW.staging_in.SGO_PARADAS_INYECCION;

SELECT count(distinct ID_FECHA), min(ID_FECHA), max(ID_FECHA) 
FROM DW.staging_in.SGO_PARADAS_INYECCION
order by 1
;


select *
FROM DW.staging_in.SGO_PARADAS_INYECCION
where ID_POZO_DW = 4016
order by ID_FECHA 
;





