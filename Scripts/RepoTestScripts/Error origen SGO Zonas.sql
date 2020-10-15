
--Caso de prueba
--> Zona "Dorcazberr"
SELECT *
FROM [DW].[sgo].[DimPozo]
where idpozo = 154
order by IdPozo


--Query con Join entre DimPozo y Zonas KO
SELECT P.IdPozo AS Id_Pozo_DW, P.CodigoPozo AS Id_Pozo_SGO, P.Nombre AS Nombre, P.Caracter AS Caracter, P.Etapa AS Etapa, P.TipoPozo AS Tipo_Pozo, 
P.ProducePetroleo AS Produce_Petroleo, P.ProduceGas AS Produce_Gas, P.ProduceAgua AS Produce_Agua, P.Proyecto1 AS Proyecto1, P.Proyecto2 AS Proyecto2, 
P.Zona AS Zona, P.Yacimiento AS Yacimiento, P.MetodoExtraccion AS Metodo_Extraccion, P.SubMetodoExtraccion AS SubMetodo_Extraccion, P.Estado AS Estado, 
P.Motivo AS Motivo, P.TipoProducto AS Tipo_Producto, P.Desde AS Desde, P.Hasta AS Hasta, P.Bateria AS Bateria, P.PlantaGas AS Planta_Gas, P.PlantaAgua AS Planta_Agua, PlantaPetroleo AS Planta_Petroleo, P.Area AS Area, P.AreaId AS Id_Area_SGO, P.TipoInstalacionInyeccion AS TipoInstalacionInyeccion, P.Campaña AS Campaña, P.Latitud AS Latitud, P.Longitud AS Longitud, P.Cota AS Cota, P.Faja AS Faja, EquipoJDE AS EquipoJDE, JobJDE AS JobJDE, Z.Id AS id_zona_sgo 
FROM DW.sgo.DimPozo P 
INNER JOIN Stagingarea.sgo.Instalaciones I 
ON P.CodigoPozo = I.Id 
INNER JOIN Stagingarea.sgo.Zonas Z 
ON P.Zona = Z.Nombre and P.Areaid = Z.AreaId --Error
where P.idpozo = 154

--Zonas que no están entrando en dimpozo
SELECT distinct P.Zona
FROM [DW].[sgo].[DimPozo] P
where P.Zona not in (select distinct nombre from Stagingarea.sgo.Zonas Z)