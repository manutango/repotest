
alter procedure modelo_capsa.SP_DT_ACTIVO
as

begin
	
/*****************************************************************************************************************/
/** SP que carga la tabla DT_ACTIVO con datos de JDE JDE_ACTIVOS                                                **/
/*****************************************************************************************************************/

/*
sk_activo =  id_activo
*/

/* ################################### STG ################################### */

--Cargo tabla de Staging OUT
TRUNCATE TABLE DW.STO.DT_ACTIVO;

INSERT INTO STO.DT_ACTIVO
           (id_activo
           ,nombre_activo
           ,desc_activo
           ,id_empresa
           ,id_centro
           ,id_rubro
           ,desc_rubro
           ,id_subrubro
           ,desc_subrubro
           ,id_marca
           ,desc_marca
           ,id_modelo
           ,desc_modelo
           ,id_familia
           ,desc_familia
           ,id_tipo_activo
           ,desc_tipo_activo
           ,id_activo_equipo
           ,desc_activo_equipo
           ,id_ubicacion
           ,latitud
           ,longitud
           ,cota
           ,id_gis
           ,id_activo_padre
           ,id_unidad_generadora_ct
           ,id_clase_activo
           ,desc_clase_activo
           ,id_pozo
           ,id_instalacion)  
SELECT
DISTINCT
A.ID_ACTIVO,
TRIM(AM.FAAPID) as nombre_activo,
TRIM(A.DESC_ACTIVO) as desc_activo,
RIGHT('0'+TRIM(AM.FACO),2) as id_empresa,
'ND' AS ID_CENTRO,
A.id_rubro,
A.desc_rubro,
A.id_subrubro,
A.desc_subrubro,
A.id_marca,
A.desc_marca,
trim(A.id_modelo) as id_modelo,
A.desc_modelo,
A.id_familia,
A.desc_familia,
A.id_tipo_activo,
A.desc_tipo_activo,
A.id_activo_equipo,
A.desc_activo_equipo,
'ND' as id_ubicacion,
A.latitud,
A.longitud,
A.cota,
-1 as id_gis,
A.id_activo_padre,
NULL as id_unidad_generadora_ct,
'ND' as id_clase_activo,
'Clase Activo N/D' as desc_clase_activo,
NULL as id_pozo,
trim(A.ID_UBICACIÓN) as id_instalacion
FROM DW.staging_in.JDE_ACTIVOS A
LEFT OUTER JOIN DW.STI.PVW_LK_ASSETMASTER AM
ON A.ID_ACTIVO = TRIM(AM.FANUMB) AND trim(AM.FANUMB) not in (' ','"')
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
;


--Actualizo clase activo, id_pozo, latitud/longitud
UPDATE D
SET 
	id_clase_activo = CASE WHEN P.id_pozo IS NOT NULL THEN 1 ELSE -1 END, --clase_activo
	desc_clase_activo = CASE WHEN P.id_pozo IS NOT NULL THEN 'Pozo' ELSE NULL END,
	id_pozo = isnull(P.id_pozo,'NA'),
	latitud = isnull(D.latitud, P.latitud),
	longitud = isnull(D.longitud, P.longitud)
FROM DW.STO.DT_ACTIVO D
LEFT OUTER JOIN (SELECT DISTINCT id_pozo_jde, id_pozo, latitud, longitud FROM DW.STO.DT_POZO WHERE id_pozo_jde is not null) P
ON D.nombre_activo = P.id_pozo_jde
;


--Actualización de atributos:
UPDATE D
SET
nombre_activo = A.nombre_activo,
desc_activo = A.desc_activo, 
sk_empresa = isnull(EMP.sk_empresa,-3),
sk_centro = isnull(CEN.sk_centro,-3),
id_rubro = A.id_rubro, 
desc_rubro = A.desc_rubro, 
id_subrubro = A.id_subrubro, 
desc_subrubro = A.desc_subrubro, 
id_marca = A.id_marca, 
desc_marca = A.desc_marca, 
id_modelo = A.id_modelo, 
desc_modelo = A.desc_modelo, 
id_familia = A.id_familia,
desc_familia = A.desc_familia, 
id_tipo_activo = A.id_tipo_activo, 
desc_tipo_activo = A.desc_tipo_activo, 
id_activo_equipo = A.id_activo_equipo, 
desc_activo_equipo = A.desc_activo_equipo, 
sk_ubicacion = isnull(UBI.sk_ubicacion,-3),
latitud = A.latitud,
longitud = A.longitud, 
cota = A.cota,
id_gis = A.id_gis,
id_activo_padre = A.id_activo_padre,
sk_unidad_generadora_ct = isnull(GEN.sk_unidad_generadora_ct,-3),
id_clase_activo = A.id_clase_activo,
desc_clase_activo = A.desc_clase_activo,
id_pozo = A.id_pozo,
id_instalacion = A.id_instalacion
FROM DW.modelo_capsa.DT_ACTIVO D
INNER JOIN DW.STO.DT_ACTIVO A
ON D.id_activo = A.id_activo
LEFT OUTER JOIN dw.modelo_capsa.DT_EMPRESA EMP
ON A.id_empresa = EMP.id_empresa 
LEFT OUTER JOIN DW.modelo_capsa.DT_CENTRO CEN
ON A.id_centro = CEN.id_centro 
LEFT OUTER JOIN DW.modelo_capsa.DT_UBICACION UBI
ON A.id_ubicacion = UBI.id_ubicacion
LEFT OUTER JOIN DW.modelo_capsa.DT_UNIDAD_GENERADORA_CT GEN
ON A.id_unidad_generadora_ct = GEN.id_unidad_generadora_ct 
;


--Inserción de deltas
INSERT INTO modelo_capsa.DT_ACTIVO
(sk_activo, id_activo, nombre_activo, desc_activo, sk_empresa, sk_centro, id_rubro, desc_rubro, id_subrubro, desc_subrubro, id_marca, 
desc_marca, id_modelo, desc_modelo, id_familia, desc_familia, id_tipo_activo, desc_tipo_activo, id_activo_equipo, desc_activo_equipo, 
sk_ubicacion, latitud, longitud, cota, id_gis, id_activo_padre, sk_unidad_generadora_ct, id_clase_activo, desc_clase_activo, id_pozo, id_instalacion)         
select
(SELECT case when isnull(MAX(sk_activo),0) < 0 then 0 else isnull(MAX(sk_activo),0) end FROM dw.modelo_capsa.DT_ACTIVO) + ROW_NUMBER() OVER (ORDER BY id_activo) AS sk_activo,
A.id_activo,
A.nombre_activo,
A.desc_activo,
isnull(EMP.sk_empresa,-3) as sk_empresa,
isnull(CEN.sk_centro,-3) as sk_centro,
A.id_rubro,
A.desc_rubro,
A.id_subrubro,
A.desc_subrubro,
A.id_marca,
A.desc_marca, 
A.id_modelo, 
A.desc_modelo, 
A.id_familia, 
A.desc_familia, 
A.id_tipo_activo, 
A.desc_tipo_activo, 
A.id_activo_equipo, 
A.desc_activo_equipo, 
isnull(UBI.sk_ubicacion,-2) as sk_ubicacion,
A.latitud, 
A.longitud, 
A.cota,
A.id_gis,
A.id_activo_padre,
isnull(GEN.sk_unidad_generadora_ct,-2) as sk_unidad_generadora_ct,
A.id_clase_activo, 
A.desc_clase_activo, 
A.id_pozo, 
A.id_instalacion
from DW.STO.DT_ACTIVO A
LEFT OUTER JOIN dw.modelo_capsa.DT_EMPRESA EMP
ON A.id_empresa = EMP.id_empresa 
LEFT OUTER JOIN DW.modelo_capsa.DT_CENTRO CEN
ON A.id_centro = CEN.id_centro 
LEFT OUTER JOIN DW.modelo_capsa.DT_UBICACION UBI
ON A.id_ubicacion = UBI.id_ubicacion
LEFT OUTER JOIN DW.modelo_capsa.DT_UNIDAD_GENERADORA_CT GEN
ON A.id_unidad_generadora_ct = GEN.id_unidad_generadora_ct 
WHERE NOT EXISTS 
(
	SELECT null FROM DW.modelo_capsa.DT_ACTIVO D
	WHERE A.id_activo = D.id_activo
)
;


end

























