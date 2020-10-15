
--QUERY CONTROL PRODUCCIÓN
SELECT COUNT(*), P.sk_proceso, P.id_proceso
FROM DW.modelo_capsa.FT_PRODUCCION_OIL_GAS F
INNER JOIN DW.modelo_capsa.CT_PROCESO P
ON F.sk_proceso = P.sk_proceso 
GROUP BY P.sk_proceso, P.id_proceso
;
