
--de 3629 a 3462
--query carga sto ft
select count(*) from (
	SELECT 
	isnull(UD.id_unidad_negocio,'ND') as id_unidad_negocio
	,A.ID_POZO_DW, PO.ID_POZO_DW, A.ID_AREA_SGO, UD.id_area_sgo, UD.id_gerencia_operativa, PO.id_gerencia_operativa
	FROM DW.staging_in.BISGO_PRODUCCIONCIV A
	LEFT OUTER JOIN DW.STO.DT_POZO PO
	ON A.ID_POZO_DW = PO.ID_POZO_DW AND A.ID_AREA_SGO = PO.id_area
	LEFT OUTER JOIN DW.staging_aux.FIX_AREAS_UNIDADES_NEGOCIOS UD ON UD.id_area_sgo = A.ID_AREA_SGO AND UD.id_gerencia_operativa = PO.id_gerencia_operativa
	WHERE 
	UD.id_unidad_negocio IS NULL
	--and A.ID_POZO_DW = 1107
	) X
;



--** Buscando por ID_POZO_DW solo

--sgo pozos
SELECT distinct ID_POZO_SGO, ID_AREA_SGO, ID_POZO_DW 
FROM DW.staging_in.SGO_POZOS
WHERE ID_POZO_DW = 1107

--prod
SELECT distinct ID_POZO_SGO, ID_AREA_SGO, ID_POZO_DW 
FROM DW.staging_in.BISGO_PRODUCCIONCIV
WHERE ID_POZO_DW = 1107




select *
--into dw.modelo_capsa.tmp_pozos1 --tmp
from dw.modelo_capsa.DT_POZO 
where sk_pozo in (39175,39177,39176)



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
				  

				  
				  
--** Busco en SGO separado
select *
from DW.staging_in.SGO_POZOS_DIADEMA
WHERE ID_POZO_SGO = 10

select *
from DW.staging_in.SGO_POZOS_ADC
WHERE ID_POZO_SGO = 10


--busco en dim (solo Diadema)
select *
from dw.modelo_capsa.DT_POZO
where cod_pozo = 10



