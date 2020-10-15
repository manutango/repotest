
--select * from [modelo_capsa].[BT_CONVERSION_MONEDA]

--Carga [BT_CONVERSION_MONEDA]
--aa

INSERT INTO [modelo_capsa].[BT_CONVERSION_MONEDA]
           ([sk_moneda_origen]
           ,[sk_moneda_destino]
           ,[sk_escenario]
           ,[sk_version]
           ,[fecha_desde]
           ,[fecha_hasta]
           ,[tipo_tasa]
           ,[tasa])

--Tipo Tasa Diario
select 
--top 100 
MO.sk_moneda as sk_moneda_origen,
--MO.id_moneda,
MD.sk_moneda as [sk_moneda_destino],
--MD.id_moneda,
1 as [sk_escenario],
1 as [sk_version],
fchefectiva as [fecha_desde],
fchefectiva as [fecha_hasta],
'Diaria' as [tipo_tasa],
tpmultiplicador as [tasa]
from [STI].[JDE_CONVERSION_MONEDA] C
join [modelo_capsa].[DT_MONEDA] MO
on C.monedaorigen = MO.id_moneda
join [modelo_capsa].[DT_MONEDA] MD
on C.monedadestino = MD.id_moneda
--where fchefectiva = '2020-08-08'


INSERT INTO [modelo_capsa].[BT_CONVERSION_MONEDA]
           ([sk_moneda_origen]
           ,[sk_moneda_destino]
           ,[sk_escenario]
           ,[sk_version]
           ,[fecha_desde]
           ,[fecha_hasta]
           ,[tipo_tasa]
           ,[tasa])


--Tipo tasa Promedio Mensual
select 
TOP 100000
MO.sk_moneda as sk_moneda_origen,
--MO.id_moneda as monedaorigen,
MD.sk_moneda as [sk_moneda_destino],
--MD.id_moneda as monedadestino,
1 as [sk_escenario],
1 as [sk_version],
min(fchefectiva) as [fecha_desde],
max(fchefectiva) as [fecha_hasta],
'Promedio Mensual' as [tipo_tasa],
avg(tpmultiplicador) as [tasa]
from [STI].[JDE_CONVERSION_MONEDA] C
join [modelo_capsa].[DT_MONEDA] MO
on C.monedaorigen = MO.id_moneda
join [modelo_capsa].[DT_MONEDA] MD
on C.monedadestino = MD.id_moneda
--where left(fchefectiva,7) = '2020-08' and MO.id_moneda = 'ARS' and MD.id_moneda = 'USD'
group by left(fchefectiva,7), MO.sk_moneda, MO.sk_moneda, MO.id_moneda, MD.sk_moneda, MD.id_moneda
order by [fecha_desde]



select * from [modelo_capsa].[BT_CONVERSION_MONEDA]
where tipo_tasa in ('Promedio Mensual') 
and fecha_desde like '%2020-08-01%'










