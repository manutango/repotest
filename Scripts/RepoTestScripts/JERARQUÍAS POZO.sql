/*
Jerarquías de pozo
Pozo > Zona > Area (gestión)
Pozo Productor > Bateria > Yacimiento > Area (confirmar)
Pozo Inyector > Satelite > Planta (confirmar) > Yacimiento? > Area (confirmar)
*/

--## 1 Pozo > Zona > Area (gestión)
SELECT ID_POZO_SGO, ID_ZONA_SGO, ZONA, ID_AREA_SGO, AREA
,*
FROM DW.staging_in.SGO_POZOS
WHERE ID_POZO_SGO = '3476'
;

--DT_POZO
SELECT cod_pozo, id_zona_sgo, zona, id_area, area, *
FROM DW.modelo_capsa.DT_POZO dp 
WHERE cod_pozo = '3476'


--## 2 Pozo Productor > Bateria > Yacimiento > Area (confirmar)
SELECT ID_POZO_SGO, BATERIA, YACIMIENTO, AREA, *
FROM DW.staging_in.SGO_POZOS
WHERE TIPO_POZO = 'Productor'


--## 3 Pozo Inyector > Satelite > Planta (confirmar) > Yacimiento? > Area (confirmar)

SELECT ID_POZO_SGO, C.ID_DESTINO_SGO as id_satelite, C.DESTINO_NOMBRE as nombre_satelite, C.DESTINO_CLASE as clase_satelite, PLANTA_PETROLEO, YACIMIENTO, AREA, *
FROM DW.staging_in.SGO_POZOS P
LEFT OUTER JOIN dw.staging_in.SGO_CONEXIONES_PETROLEO C
ON C.ID_ORIGEN_SGO = P.ID_POZO_SGO
WHERE TIPO_POZO = 'Inyector' AND C.DESTINO_CLASE = 'Satelite'


------------------------------------------------
-- Otras jerarquías:
------------------------------------------------

--Pozo --> Batería --> Planta --> Oleoducto

SELECT ID_POZO_SGO, BATERIA, PLANTA_GAS, PLANTA_AGUA, PLANTA_PETROLEO, C.ID_DESTINO_SGO AS ID_OLEODUCTO, C.DESTINO_NOMBRE AS NOMBRE_OLEODUCTO, C.DESTINO_CLASE AS CLASE_OLEODUCTO
FROM DW.staging_in.SGO_POZOS P
INNER JOIN dw.staging_in.SGO_CONEXIONES_PETROLEO C
ON P.BATERIA = C.ORIGEN_NOMBRE --BATERIA
AND C.DESTINO_CLASE = 'Oleoducto'
;


--Pozo - Conexiones - Batería
SELECT ID_POZO_SGO, C.DESTINO_NOMBRE, C.DESTINO_CLASE, PLANTA_PETROLEO, YACIMIENTO, AREA, *
FROM dw.staging_in.SGO_CONEXIONES_PETROLEO C
INNER JOIN DW.staging_in.SGO_POZOS P
ON C.ID_ORIGEN_SGO = P.ID_POZO_SGO
and P.NOMBRE = 'F-258'



--Q1
--Alter VIEW modelo_capsa.vw_jera1 as
SELECT scp.ORIGEN_NOMBRE as ORIGEN_NOMBRE_C, scp.ORIGEN_CLASE as ORIGEN_CLASE_C, 
scp.ORIGEN_NOMBRE + ' | ' + scp.ORIGEN_CLASE as ORIGEN_NOMBRE_CLASE_C, scp.DESTINO_NOMBRE AS DESTINO_NOMBRE_C, scp.DESTINO_CLASE AS DESTINO_CLASE_C, 
sp.*
from DW.staging_in.SGO_CONEXIONES_PETROLEO scp 
left outer join 
(
	select distinct ID_POZO_SGO, NOMBRE, ID_AREA_SGO, AREA, ID_ZONA_SGO, ZONA, DESDE, HASTA 
	from dw.staging_in.SGO_POZOS --4785
) as sp 
on scp.ID_ORIGEN_SGO = sp.ID_POZO_SGO 
and scp.DESDE = sp.DESDE and scp.HASTA = sp.HASTA
;





SELECT top 10000 * FROM modelo_capsa.vw_jera1


--Pozos
select *
from dw.staging_in.SGO_POZOS
where NOMBRE = 'E-173'
;

--Conexiones
select *
from DW.staging_in.SGO_CONEXIONES_PETROLEO scp 
where ORIGEN_NOMBRE = 'E-173'








--Pozo
SELECT ID_POZO_SGO, PLANTA_PETROLEO, YACIMIENTO, AREA, *
FROM DW.staging_in.SGO_POZOS P
WHERE TIPO_POZO = 'Inyector'
and P.NOMBRE = 'F-258'

--Satelite
select top 100 * 
from dw.staging_in.SGO_CONEXIONES_PETROLEO  
where DESTINO_CLASE = 'Oleoducto'


--Pozo -- Conexiones
SELECT C.*
FROM (SELECT DISTINCT ID_POZO_SGO FROM DW.staging_in.SGO_POZOS) P
LEFT OUTER JOIN dw.staging_in.SGO_CONEXIONES_PETROLEO C
ON C.ID_ORIGEN_SGO = P.ID_POZO_SGO
WHERE P.ID_POZO_SGO  = 3476


select * 
from dw.staging_in.SGO_POZOS sp
where  ID_POZO_SGO  = 3476

select *
from dw.staging_in.SGO_POZOS sp
where nombre in ('F-258','PC-3009')



--obtengo combinaciones conexiones
SELECT DISTINCT ORIGEN_CLASE, DESTINO_CLASE 
FROM DW.staging_in.SGO_CONEXIONES_PETROLEO C
ORDER BY 1



select COUNT(*), ID_BATERIA, DESC_BATERIA 
from dw.staging_in.SGO_BATERIAS
group by ID_BATERIA, DESC_BATERIA
HAVING COUNT(*) >1








--TABLAS
select top 100 * from dw.staging_in.SGO_BATERIAS
select top 100 * from dw.staging_in.SGO_CONEXIONES_PETROLEO
select top 100 * from dw.staging_in.SGO_POZOS
select top 100 * from dw.staging_in.SGO_ZONAS
--select top 100 * from dw.staging_in.SGO_INSTALACIONES



--pozo ejemplo
--cod_pozo = '3476'

