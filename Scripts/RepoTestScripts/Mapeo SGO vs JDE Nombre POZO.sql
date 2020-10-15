
--Mapeo SGO vs JDE Nombre POZO

--4779
SELECT *
FROM DW.staging_in.SGO_POZOS A
where A.ID_POZO_SGO = '26' and desde = '2000-07-22' and hasta = '2000-08-01'

--3584
SELECT count(*)
FROM DW.staging_in.SGO_POZOS
where NOMBRE in
(
	SELECT  
	--distinct,
	*,
	trim(replace(replace(trim(FADL01),'POZO',''),'ASTRA',''))
	FROM DW.STI.PVW_LK_ASSETMASTER A
	WHERE FADL01 LIKE 'POZO%' and FADL01 like '%A-120'
)







EXEC DW.sys.sp_addextendedproperty 'MS_Description', 'qrwrwqrw', 'schema', 'modelo_capsa', 'table', 'DT_CAMPAÑA', 'column', 'desc_campaña'



