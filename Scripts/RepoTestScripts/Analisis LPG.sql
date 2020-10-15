
select distinct estado
from DW.staging_in.SGO_CIERRE_DIARIO_LPG

----

/*
LPG Análisis previo:
- Group by por producto y tipo de producto para ver con que medidas cruza antes de crearlas (solo producto) sobre las dos tablas para entender que métricas van.
*/

--*** SGO_CIERRE_DIARIO_LPG ***

--Group by Producto
select producto, 
sum(masa) as masa,
sum(volumen) as volumen,
sum(volumen_9300) as volumen_9300,
sum(poder_calorifico_promedio_simple) as poder_calorifico_promedio_simple,
sum(volumen_ajustado) as volumen_ajustado,
sum(volumen_9300_ajustado) as volumen_9300_ajustado,
sum(densidad) as densidad,
sum(recupero_operativa) as recupero_operativa,
sum(stock_inicial) as stock_inicial,
sum(stock_final) as stock_final,
sum(disponible) as disponible,
sum(reproceso) as reproceso,
sum(recupero_stock) as recupero_stock,
sum(almacenaje_disponible) as almacenaje_disponible
from DW.staging_in.SGO_CIERRE_DIARIO_LPG
group by producto
order by 1;

--Group by Producto, Tipo Producto
select producto, tipo_producto,
sum(masa) as masa,
sum(volumen) as volumen,
sum(volumen_9300) as volumen_9300,
sum(poder_calorifico_promedio_simple) as poder_calorifico_promedio_simple,
sum(volumen_ajustado) as volumen_ajustado,
sum(volumen_9300_ajustado) as volumen_9300_ajustado,
sum(densidad) as densidad,
sum(recupero_operativa) as recupero_operativa,
sum(stock_inicial) as stock_inicial,
sum(stock_final) as stock_final,
sum(disponible) as disponible,
sum(reproceso) as reproceso,
sum(recupero_stock) as recupero_stock,
sum(almacenaje_disponible) as almacenaje_disponible
from DW.staging_in.SGO_CIERRE_DIARIO_LPG
group by producto, tipo_producto 
order by 1,2;


--Group by Producto, Concepto
select producto, concepto, 
sum(masa) as masa,
sum(volumen) as volumen,
sum(volumen_9300) as volumen_9300,
sum(poder_calorifico_promedio_simple) as poder_calorifico_promedio_simple,
sum(volumen_ajustado) as volumen_ajustado,
sum(volumen_9300_ajustado) as volumen_9300_ajustado,
sum(densidad) as densidad,
sum(recupero_operativa) as recupero_operativa,
sum(stock_inicial) as stock_inicial,
sum(stock_final) as stock_final,
sum(disponible) as disponible,
sum(reproceso) as reproceso,
sum(recupero_stock) as recupero_stock,
sum(almacenaje_disponible) as almacenaje_disponible
from DW.staging_in.SGO_CIERRE_DIARIO_LPG
group by producto, concepto  
order by 1,2;



--*** SGO_CIERRE_MENSUAL_LPG ***

--Group by Producto
select producto,
sum(produccion) as produccion,
sum(stock_inicial) as stock_inicial,
sum(stock_final) as stock_final,
sum(stock_densidad) as stock_densidad,
sum(masa) as masa,
sum(volumen) as volumen,
sum(volumen_9300) as volumen_9300,
sum(ajuste_volumen) as ajuste_volumen,
sum(poder_calorifico_promedio) as poder_calorifico_promedio,
sum(ajuste_poder_calorifico_promedio) as ajuste_poder_calorifico_promedio
from dw.staging_in.SGO_CIERRE_MENSUAL_LPG
group by producto
order by 1;

--Group by Producto, Tipo Producto
select producto, tipo_producto,
sum(produccion) as produccion,
sum(stock_inicial) as stock_inicial,
sum(stock_final) as stock_final,
sum(stock_densidad) as stock_densidad,
sum(masa) as masa,
sum(volumen) as volumen,
sum(volumen_9300) as volumen_9300,
sum(ajuste_volumen) as ajuste_volumen,
sum(poder_calorifico_promedio) as poder_calorifico_promedio,
sum(ajuste_poder_calorifico_promedio) as ajuste_poder_calorifico_promedio
from dw.staging_in.SGO_CIERRE_MENSUAL_LPG
group by producto, tipo_producto
order by 1,2;


--Group by Producto, Tipo Producto, Concepto
select producto, tipo_producto, concepto,
sum(produccion) as produccion,
sum(stock_inicial) as stock_inicial,
sum(stock_final) as stock_final,
sum(stock_densidad) as stock_densidad,
sum(masa) as masa,
sum(volumen) as volumen,
sum(volumen_9300) as volumen_9300,
sum(ajuste_volumen) as ajuste_volumen,
sum(poder_calorifico_promedio) as poder_calorifico_promedio,
sum(ajuste_poder_calorifico_promedio) as ajuste_poder_calorifico_promedio
from dw.staging_in.SGO_CIERRE_MENSUAL_LPG
group by producto, tipo_producto, concepto 
order by 1,2;




