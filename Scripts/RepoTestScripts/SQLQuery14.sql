




SELECT
distinct 
--     [sk_unidad_contable] --OK
--     ,[sk_cuenta] --OK
--     ,[sk_unidad_contable_origen] --OK
--      ,[sk_activo] --
--      ,[sk_activo_tipo] -- -3
--       [sk_articulo] OK
--      ,[sk_ente] OK
--      ,[sk_unidad_medida_origen] OK
--      ,[sk_unidad_medida_unificada] OK
--      ,[sk_tipo_doc_oc]
from DW.STO.tmp_ftge
order by 1



select *
from [modelo_capsa].[DT_ARTICULO]