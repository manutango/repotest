/* DT_UBICACION 
  
Ubicación --> Zona
Area --> Area
Cuenca --> Gerencia operativa

BK: id_ubicacion + id_area + id_cuenca

*/


/* ################################### STG ################################### */

/* 0) Staging IN/OUT: */

TRUNCATE TABLE DW.STO.DT_UBICACION

INSERT INTO DW.STO.DT_UBICACION
(id_ubicacion, desc_ubicacion, id_area, desc_area, id_cuenca, desc_cuenca, 
id_jurisdiccion, desc_jurisdiccion, id_gis_ubicacion, id_gis_area, id_gis_cuenca, id_gis_jurisdiccion)

SELECT
top 10000
	ID_ZONA as id_ubicacion,
	DESC_ZONA as desc_ubicacion,
	ID_AREA as id_area,
	DESC_AREA as desc_area,
	ID_GERENCIA_OPERATIVA as id_cuenca,
	DESC_GERENCIA_OPERATIVA as desc_cuenca,
	null as id_jurisdiccion, 
	null as desc_jurisdiccion, 
	-2 as id_gis_ubicacion, 
	-2 as id_gis_area, 
	-2 as id_gis_cuenca, 
	-2 as id_gis_jurisdiccion	
FROM DW.staging_in.SGO_ZONAS A
order by 1


-----------------------------------------------------------------------------------

/* 1 - Coindide la bk --> UPDATE */

/* * ACTUALIZAR CON ÚLTIMA VERSIÓN DE STG CAPSA */

UPDATE D
SET
desc_ubicacion = A.desc_ubicacion,
desc_area = A.desc_area,
desc_cuenca = A.desc_cuenca,
id_jurisdiccion = A.id_jurisdiccion,
desc_jurisdiccion = A.desc_jurisdiccion
FROM DW.modelo_capsa.DT_UBICACION D
INNER JOIN DW.STO.DT_UBICACION A
ON
	     A.id_ubicacion = D.id_ubicacion
 	 and A.id_area = D.id_area
	 and A.id_cuenca = D.id_cuenca



/* 2 - Cambia la bk --> DW.modelo_capsa.DT_UBICACION*/

--delete from DW.modelo_capsa.DT_UBICACION where sk_ubicacion not in (-1,-2)

INSERT INTO DW.modelo_capsa.DT_UBICACION 
(sk_ubicacion, id_ubicacion, desc_ubicacion, id_area, desc_area, id_cuenca, desc_cuenca, 
id_jurisdiccion, desc_jurisdiccion, sk_gis_ubicacion, sk_gis_area, sk_gis_cuenca, sk_gis_jurisdiccion)

SELECT
DENSE_RANK() OVER (ORDER BY CAST(id_ubicacion AS VARCHAR) + '-' + CAST(id_area AS VARCHAR) + '-' + CAST(id_cuenca AS VARCHAR)) AS sk_ubicacion,
id_ubicacion,
desc_ubicacion,
id_area,
desc_area,
id_cuenca,
desc_cuenca,
id_jurisdiccion,
desc_jurisdiccion,
id_gis_ubicacion,
id_gis_area,
id_gis_cuenca,
id_gis_jurisdiccion
FROM DW.STO.DT_UBICACION A
WHERE NOT EXISTS 
(
	SELECT null FROM DW.modelo_capsa.DT_UBICACION U
	WHERE 
	     A.id_ubicacion = U.id_ubicacion
 	 and A.id_area = U.id_area
	 and A.id_cuenca = U.id_cuenca 
)

/*
--Agrego Planta ADC
insert into DW.modelo_capsa.DT_UBICACION
("sk_ubicacion","id_ubicacion","desc_ubicacion","id_area","desc_area","id_cuenca","desc_cuenca","id_jurisdiccion","desc_jurisdiccion","sk_gis_ubicacion","sk_gis_area","sk_gis_cuenca","sk_gis_jurisdiccion")
select 48,Planta ADC,Planta ADC,"1",Agua del Cajón,"1",Comahue,,,-2,-2,-2,-2
*/


/*
 
--chequeo dups
select sk_ubicacion, count(*)
from DW.modelo_capsa.DT_UBICACION
group by sk_ubicacion
having count(*)>1

*/






