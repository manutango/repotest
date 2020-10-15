
--ACTIVOS CON DUPLICADO NOMBRE_ACTIVO --AFECTA JOIN CON DT_POZOS
SELECT *
FROM DW.modelo_capsa.DT_ACTIVO da 
WHERE da.nombre_activo IN (
		SELECT DISTINCT nombre_activo 
		FROM DW.STO.DT_ACTIVO 
		GROUP BY nombre_activo
		HAVING COUNT(*)>1
							)
ORDER BY nombre_activo


--EJEMPLO ACTIVO
SELECT *
FROM DW.modelo_capsa.DT_ACTIVO da 
WHERE nombre_activo = 'DAPZF244'

--EJEMPLO EN SGO POZOS
SELECT *
FROM DW.staging_in.SGO_POZOS sp
WHERE EQUIPOJDE = 'DAPZF244'
