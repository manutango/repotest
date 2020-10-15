


CREATE TABLE [modelo_capsa].[TEST_Table]( -----Create table statement
	[C1] [NCHAR](10) NULL
)


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Test' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TEST_Table', @level2type=N'COLUMN',@level2name=N'C1' -----Add extended property for column, this is missing when you script out the table.
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Test_Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TEST_Table'
GO ----Add extended property for table, this is not missing when you script out the table.

SELECT *
FROM sys.extended_properties
WHERE OBJECT_ID('dbo.TEST_Table') = major_id; ----Verify that extended properties exists in your database.