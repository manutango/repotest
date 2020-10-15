
--1 STI a STO
--2 STO Update
--3 STO Insert
--4 DT actualizo atributos de POZOS

/*
 *
##################
BK = FANUMB

sk_activo - FANUMB
id_activo - FANUMB
nombre_activo - FAAPID (Unit or Tag Number)
compañía_jde - FACO (Company)
*
*/

--1 STI a STO
truncate table DW.STO.DT_ACTIVO;

INSERT INTO [STO].[DT_ACTIVO]
           ([id_activo]
           ,[nombre_activo]
           ,[compañía_jde]
           ,[desc_activo]
           ,[rubro_activo]
           ,[rubro_activo_desc]
           ,[subrubro_activo]
           ,[subrubro_activo_desc]
           ,[id_clase_activo]
           ,[desc_clase_activo]
           ,[id_categoria_activo_contable]
           ,[id_pozo]
           ,[latitud]
           ,[longitud]
           ,[id_ubicación]
           ,[ubicación]
           ,[ciclo_combinado]
           ,[id_gis]
           ,[familia]
           ,[modelo]
           ,[tipo_activo]
           ,[tipo_activo_desc]
           ,[id_centro]
           ,id_activo_padre
           ,id_unidad_generadora_ct)

select
trim(FANUMB) as id_activo,
trim(FAAPID) as nombre_activo,
trim(FACO) as compañía_jde, 
trim(FADL01) as desc_activo,
FAACL1 as rubro_activo,
RU.DRDL01 as rubro_activo_desc,
FAACL2 as subrubro_activo,
SUBRU.DRDL01 as subrubro_activo_desc,
-1  as id_clase_activo,
NULL desc_clase_activo,
-1 as id_categoria_activo_contable, --consultar Germán
-1 as id_pozo,
NULL as latitud,
NULL as longitud,
-1 as id_ubicación, ---renombrar a id_ubicación
NULL as ubicación, --sk_ubicacion
NULL ciclo_combinado, ----ciclo_combinado
-1  id_gis,
NULL familia,
FAACL3 as modelo,
FAACL4 tipo_activo,
TAC.DRDL01 as tipo_activo_desc, --agregar
-1  as id_centro,
trim(FAAAID) as id_activo_padre,
NULL id_unidad_generadora_ct
from DW.STI.PVW_LK_ASSETMASTER A
left outer join (select DRDL01, DRKY from DW.STI.CodCat where DRSY = '12' and DRRT = 'C1') RU --Subrubro
ON A.FAACL1 = RU.DRKY 
left outer join (select DRDL01, DRKY from DW.STI.CodCat where DRSY = '12' and DRRT = 'C2') SUBRU --Subrubro
ON A.FAACL2 = SUBRU.DRKY 
left outer join (select DRDL01, DRKY from DW.STI.CodCat where DRSY = '12' and DRRT = 'C4') TAC --TipoActivo
ON A.FAACL4 = TAC.DRKY 
where trim(FANUMB) not in (' ','"') and trim(FACO) <> ' '
;


--Carga Jerarquía Unidad Generadora CT

UPDATE A
SET A.id_unidad_generadora_ct = isnull(JERA.id_activo_padre,'ND') 
FROM DW.STO.DT_ACTIVO A
INNER JOIN 
	(
		SELECT DISTINCT id_activo_padre, id_activo
		FROM (
			SELECT L1.id_activo_padre, L1.id_activo 
			FROM DW.STO.DT_ACTIVO L1
			join STO.DT_UNIDAD_GENERADORA_CT UGCT ON L1.id_activo_padre = UGCT.id_unidad_generadora_ct
			UNION ALL
			SELECT L1.id_activo_padre, L2.id_activo 
			FROM DW.STO.DT_ACTIVO L1
			join STO.DT_UNIDAD_GENERADORA_CT UGCT ON L1.id_activo_padre = UGCT.id_unidad_generadora_ct
			left outer join DW.STO.DT_ACTIVO L2 on L1.id_activo = L2.id_activo_padre
			UNION ALL
			SELECT L1.id_activo_padre, L3.id_activo 
			FROM DW.STO.DT_ACTIVO L1
			join STO.DT_UNIDAD_GENERADORA_CT UGCT ON L1.id_activo_padre = UGCT.id_unidad_generadora_ct
			left outer join DW.STO.DT_ACTIVO L2 on L1.id_activo = L2.id_activo_padre
			left outer join DW.STO.DT_ACTIVO L3 on L2.id_activo = L3.id_activo_padre
			UNION ALL
			SELECT L1.id_activo_padre, L4.id_activo 
			FROM DW.STO.DT_ACTIVO L1
			join STO.DT_UNIDAD_GENERADORA_CT UGCT ON L1.id_activo_padre = UGCT.id_unidad_generadora_ct
			left outer join DW.STO.DT_ACTIVO L2 on L1.id_activo = L2.id_activo_padre
			left outer join DW.STO.DT_ACTIVO L3 on L2.id_activo = L3.id_activo_padre
			left outer join DW.STO.DT_ACTIVO L4 on L3.id_activo = L4.id_activo_padre
			UNION ALL
			SELECT L1.id_activo_padre, L5.id_activo 
			FROM DW.STO.DT_ACTIVO L1
			join STO.DT_UNIDAD_GENERADORA_CT UGCT ON L1.id_activo_padre = UGCT.id_unidad_generadora_ct
			left outer join DW.STO.DT_ACTIVO L2 on L1.id_activo = L2.id_activo_padre
			left outer join DW.STO.DT_ACTIVO L3 on L2.id_activo = L3.id_activo_padre
			left outer join DW.STO.DT_ACTIVO L4 on L3.id_activo = L4.id_activo_padre
			left outer join DW.STO.DT_ACTIVO L5 on L4.id_activo = L5.id_activo_padre
		)A
		WHERE 1=1
		AND id_activo IS NOT NULL
	) JERA
ON A.id_activo = JERA.id_activo


--Actualizo unidades generadoras restantes
UPDATE A
SET A.id_unidad_generadora_ct = 'ND' 
FROM DW.STO.DT_ACTIVO A
WHERE id_unidad_generadora_ct IS NULL


--Actualizo clase activo y id_pozo
UPDATE D
SET 
	id_clase_activo = CASE WHEN P.id_pozo IS NOT NULL THEN 1 ELSE -1 END, --clase_activo
	desc_clase_activo = CASE WHEN P.id_pozo IS NOT NULL THEN 'Pozo' ELSE NULL END,
	id_pozo = isnull(P.id_pozo,-1)
FROM DW.STO.DT_ACTIVO D
LEFT OUTER JOIN (SELECT DISTINCT id_pozo_jde, id_pozo FROM DW.STO.DT_POZO) P
ON D.nombre_activo = P.id_pozo_jde
--WHERE D.nombre_activo = 'SA-1005'
;

--Actualizo latitud/longitud
UPDATE D
SET 
	latitud = P.latitud,
	longitud = P.longitud
FROM DW.STO.DT_ACTIVO D
LEFT OUTER JOIN (SELECT DISTINCT id_pozo_jde, id_pozo, latitud, longitud FROM DW.STO.DT_POZO) P
ON D.nombre_activo = P.id_pozo_jde
--WHERE D.nombre_activo = 'SA-1005'
;




--2 STO Update ########################
--***********

UPDATE D
SET
 nombre_activo = A.nombre_activo
,compañía_jde = A.compañía_jde
,desc_activo = A.desc_activo
,rubro_activo = A.rubro_activo
,rubro_activo_desc = A.rubro_activo_desc
,subrubro_activo = A.subrubro_activo
,subrubro_activo_desc = A.subrubro_activo_desc
,id_clase_activo = A.id_clase_activo 
,desc_clase_activo = A.desc_clase_activo
,sk_categoria_activo_contable = -1
,id_pozo = A.id_pozo
,latitud = A.latitud
,longitud = A.longitud
,id_instalación = -1
,sk_ubicacion = A.ubicación
,ciclo_combinado = A.ciclo_combinado
,id_gis = A.id_gis
,familia = A.familia
,modelo = A.modelo
,tipo_activo = A.tipo_activo
,tipo_activo_desc = A.tipo_activo_desc
,id_centro = -1 
,id_activo_padre = A.id_activo_padre
,sk_unidad_generadora_ct = isnull(GEN.sk_unidad_generadora_ct,-3)
FROM DW.modelo_capsa.DT_ACTIVO D
INNER JOIN DW.STO.DT_ACTIVO A
ON D.id_activo = A.id_activo
LEFT OUTER JOIN DW.modelo_capsa.DT_UNIDAD_GENERADORA_CT GEN
ON A.id_unidad_generadora_ct = GEN.id_unidad_generadora_ct 
--and A.nombre_activo = 'Sa-1005'
;



--3 STO Insert

--truncate table DW.modelo_capsa.[DT_ACTIVO]

INSERT INTO [modelo_capsa].[DT_ACTIVO]
           ([sk_activo]
           ,[id_activo]
           ,[nombre_activo]
           ,[compañía_jde]
           ,[desc_activo]
           ,[rubro_activo]
           ,[rubro_activo_desc]
           ,[subrubro_activo]
           ,[subrubro_activo_desc]
           ,[id_clase_activo]
           ,[desc_clase_activo]
           ,[sk_categoria_activo_contable]
           ,[id_pozo]
           ,[latitud]
           ,[longitud]
           ,[id_instalación]
           ,[sk_ubicacion]
           ,[ciclo_combinado]
           ,[id_gis]
           ,[familia]
           ,[modelo]
           ,[tipo_activo]
           ,[tipo_activo_desc]
           ,[id_centro]
           ,id_activo_padre
           ,sk_unidad_generadora_ct)

select
distinct DENSE_RANK() OVER (ORDER BY id_activo) AS sk_activo,
A.id_activo,
A.nombre_activo,
A.compañía_jde,
A.desc_activo,
A.rubro_activo,
A.rubro_activo_desc,
A.subrubro_activo,
A.subrubro_activo_desc,
A.id_clase_activo,	
A.desc_clase_activo,	
-1 as sk_categoria_activo_contable,
A.id_pozo,
A.latitud,
A.longitud,
-1 as id_instalación,
-1 as sk_ubicacion,
A.ciclo_combinado,
A.id_gis,
A.familia,
A.modelo,
A.tipo_activo,
A.tipo_activo_desc,
-1 as id_centro,
A.id_activo_padre,
isnull(GEN.sk_unidad_generadora_ct,-3) as sk_unidad_generadora_ct
from DW.STO.DT_ACTIVO A
LEFT OUTER JOIN DW.modelo_capsa.DT_UNIDAD_GENERADORA_CT GEN
ON A.id_unidad_generadora_ct = GEN.id_unidad_generadora_ct 
WHERE NOT EXISTS 
(
	SELECT null FROM DW.modelo_capsa.[DT_ACTIVO] D
	WHERE A.id_activo = D.id_activo
)
--and id_activo = 'Sa-1005' --and A.id_activo <> ''
;






/*
--activo
select * FROM DW.modelo_capsa.[DT_ACTIVO] 	
where nombre_activo in ('Sa-1005','DAPZK331')
  
--pozo
SELECT DISTINCT id_pozo_jde, id_pozo FROM DW.modelo_capsa.DT_POZO
where id_pozo_jde = 'Sa-1005'

--select count(*) from DW.modelo_capsa.[DT_ACTIVO] --32697

--chequeo dups en assetmaster
select count(*), FAAPID as id_activo
from DW.STI.PVW_LK_ASSETMASTER A
group by FAAPID
having count(*)>1

select count(*), FAAPID as id_activo
from DW.STI.PVW_LK_ASSETMASTER A
group by FAAPID
having count(*)>1

--chequeo caso dup en assetmaster
select *
from DW.STI.PVW_LK_ASSETMASTER
where FAAPID = '5'
	
	
select id_activo from dw.modelo_capsa.DT_ACTIVO 
group by id_Activo having count(*)>1;

	
--chequeo dups
select sk_activo, id_activo, count(*)
from DW.modelo_capsa.[DT_ACTIVO]
group by sk_activo, id_activo	
having count(*)>1


select * from [modelo_capsa].[DT_ACTIVO] where sk_activo = '1984'


select count(distinct (FAAPID +'-'+ FADL01))
from DW.STI.PVW_LK_ASSETMASTER A


select * from DW.modelo_capsa.DT_POZO
select * from DW.modelo_capsa.DT_ACTIVO


--Asset master FAAPID dup
select *
from DW.STI.PVW_LK_ASSETMASTER A
where FAAPID in ('4','5','6',' ')
order by FAAPID

*/


























