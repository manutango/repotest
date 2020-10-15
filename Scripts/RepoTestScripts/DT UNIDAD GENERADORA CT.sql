TRUNCATE TABLE STO.DT_UNIDAD_GENERADORA_CT;

--9
INSERT INTO STO.DT_UNIDAD_GENERADORA_CT 
SELECT 
A.ID_ACTIVO as id_unidad_generadora_ct,
TRIM(B.FAAPID) as nombre_unidad_generadora_ct, 
RIGHT('0'+TRIM(B.FACO),2) as empresa_jde, 
TRIM(A.DESC_ACTIVO) as desc_unidad_generadora_ct,
TRIM(A.DESC_TIPO_ACTIVO) as tipo_unidad_generadora_ct,
'ND' as fase,
'ND' as capacidad, 
'ND'contruccion,
'ND'modelo,
'ND'ubicacion,
'ND'ciclo_combinado
FROM staging_in.JDE_ACTIVOS A
LEFT OUTER JOIN STI.PVW_LK_ASSETMASTER B on A.ID_ACTIVO = TRIM(B.FANUMB) AND TRIM(B.FANUMB) not in (' ','"')
WHERE 1=1 
AND TRIM(A.ID_TIPO_ACTIVO) IN ('674','675')
AND TRIM(A.DESC_ACTIVO) NOT LIKE '%REVALUO%' 
AND TRIM(A.DESC_ACTIVO) NOT LIKE 'UG7-ALABES L-0'
;

----

TRUNCATE TABLE modelo_capsa.DT_UNIDAD_GENERADORA_CT;

INSERT INTO modelo_capsa.DT_UNIDAD_GENERADORA_CT
SELECT 
ROW_NUMBER() OVER(ORDER BY A.id_unidad_generadora_ct) as sk_unidad_generadora_ct, 
A.id_unidad_generadora_ct, 
A.nombre_unidad_generadora_ct, 
ISNULL(B.sk_empresa,-3) as sk_empresa, 
A.desc_unidad_generadora_ct, 
A.tipo_unidad_generadora_ct, 
A.fase, 
A.capacidad, 
A.contruccion, 
A.modelo, 
A.ubicacion, 
A.ciclo_combinado
FROM STO.DT_UNIDAD_GENERADORA_CT A
LEFT OUTER JOIN modelo_capsa.DT_EMPRESA B on B.id_empresa = A.empresa_jde 
WHERE 1=1
;

select * from modelo_capsa.DT_UNIDAD_GENERADORA_CT;
-------------

UPDATE TARGET 
SET 
TARGET.nombre_unidad_generadora_ct = S1.nombre_unidad_generadora_ct, 
TARGET.sk_empresa = ISNULL(S2.sk_empresa,-3), 
TARGET.desc_unidad_generadora_ct = S1.desc_unidad_generadora_ct,
TARGET.tipo_unidad_generadora_ct = S1.tipo_unidad_generadora_ct,
TARGET.fase = S1.fase,
TARGET.capacidad = S1.capacidad,
TARGET.contruccion = S1.contruccion,
TARGET.modelo = S1.modelo,
TARGET.ubicacion = S1.ubicacion,
TARGET.ciclo_combinado = S1.ciclo_combinado
FROM  modelo_capsa.DT_UNIDAD_GENERADORA_CT AS TARGET
INNER JOIN STO.DT_UNIDAD_GENERADORA_CT AS S1 ON TARGET.id_unidad_generadora_ct = S1.id_unidad_generadora_ct 
LEFT OUTER JOIN modelo_capsa.DT_EMPRESA S2 on S1.empresa_jde = S2.id_empresa
;