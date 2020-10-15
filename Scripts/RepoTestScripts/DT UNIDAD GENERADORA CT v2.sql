

alter proc modelo_capsa.SP_DT_UNIDAD_GENERADORA_CT
as

begin
	
/*****************************************************************************************************************/
/** SP que carga la tabla DT_UNIDAD_GENERADORA_CT con datos de staging_in.JDE_UNIDADES_GENERADORAS_CT 			 */
/*****************************************************************************************************************/

/*
sk_unidad_generadora_ct = id_unidad_generadora_ct
*/

/* ################################### STG ################################### */

--Cargo tabla de Staging OUT
TRUNCATE TABLE STO.DT_UNIDAD_GENERADORA_CT;

INSERT INTO STO.DT_UNIDAD_GENERADORA_CT 
SELECT top 1000
A.ID_UNIDAD_CT as id_unidad_generadora_ct,
A.NRO_UNIDAD as nombre_unidad_generadora_ct, 
'ND' as empresa_jde, 
A.DESCRIP as desc_unidad_generadora_ct,
A.ID_TIPO_MODELO as id_tipo_unidad_generadora_ct, 
A.DESC_TIPO_MODELO as desc_tipo_unidad_generadora_ct,
'ND' as fase,
'ND' as capacidad, 
'ND'contruccion,
A.ID_MODELO as id_modelo,
A.DESC_MODELO as modelo,
A.UBICACION as ubicacion,
'ND'as ciclo_combinado,
A.ID_RUBRO as id_rubro,
A.DESC_RUBRO as desc_rubro,
A.ID_SUBRUBRO as id_subrubro,
A.DESC_SUBRUBRO as desc_subrubro,
A.ID_FAMILIA as id_familia,
A.DESC_FAMILIA as desc_familia
FROM dw.staging_in.JDE_UNIDADES_GENERADORAS_CT A
order by 1
;

--Actualización de atributos:
UPDATE TARGET 
SET 
TARGET.nombre_unidad_generadora_ct = S1.nombre_unidad_generadora_ct, 
TARGET.sk_empresa = ISNULL(S2.sk_empresa,-2), 
TARGET.desc_unidad_generadora_ct = S1.desc_unidad_generadora_ct,
TARGET.id_tipo_unidad_generadora_ct = S1.id_tipo_unidad_generadora_ct,
TARGET.tipo_unidad_generadora_ct = S1.tipo_unidad_generadora_ct,
TARGET.fase = S1.fase,
TARGET.capacidad = S1.capacidad,
TARGET.contruccion = S1.contruccion,
TARGET.id_modelo = S1.id_modelo,
TARGET.modelo = S1.modelo,
TARGET.ubicacion = S1.ubicacion,
TARGET.ciclo_combinado = S1.ciclo_combinado,
TARGET.id_rubro = S1.id_rubro,
TARGET.desc_rubro = S1.desc_rubro,
TARGET.id_subrubro = S1.id_subrubro,
TARGET.desc_subrubro = S1.desc_subrubro,
TARGET.id_familia = S1.id_familia,
TARGET.desc_familia = S1.desc_familia
FROM  modelo_capsa.DT_UNIDAD_GENERADORA_CT AS TARGET
INNER JOIN STO.DT_UNIDAD_GENERADORA_CT AS S1 ON TARGET.id_unidad_generadora_ct = S1.id_unidad_generadora_ct 
LEFT OUTER JOIN modelo_capsa.DT_EMPRESA S2 on S1.empresa_jde = S2.id_empresa
;

--Inserción de deltas
INSERT INTO modelo_capsa.DT_UNIDAD_GENERADORA_CT
SELECT 
ROW_NUMBER() OVER(ORDER BY A.id_unidad_generadora_ct) as sk_unidad_generadora_ct, 
A.id_unidad_generadora_ct, 
A.nombre_unidad_generadora_ct, 
ISNULL(B.sk_empresa,-2) as sk_empresa, 
A.desc_unidad_generadora_ct, 
A.id_tipo_unidad_generadora_ct,
A.tipo_unidad_generadora_ct, 
A.fase, 
A.capacidad, 
A.contruccion,
A.id_modelo,
A.modelo, 
A.ubicacion, 
A.ciclo_combinado,
A.id_rubro,
A.desc_rubro,
A.id_subrubro,
A.desc_subrubro,
A.id_familia,
A.desc_familia
FROM STO.DT_UNIDAD_GENERADORA_CT A
LEFT OUTER JOIN modelo_capsa.DT_EMPRESA B on B.id_empresa = A.empresa_jde 
WHERE NOT EXISTS 
(
	SELECT null FROM  modelo_capsa.DT_UNIDAD_GENERADORA_CT C
	WHERE 
	     A.id_unidad_generadora_ct = C.id_unidad_generadora_ct
);

end