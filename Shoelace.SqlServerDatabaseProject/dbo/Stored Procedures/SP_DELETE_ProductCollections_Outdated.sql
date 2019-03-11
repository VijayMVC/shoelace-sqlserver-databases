


CREATE PROCEDURE [dbo].[SP_DELETE_ProductCollections_Outdated] 
@userId bigint

AS

DELETE FROM [productcollection]
WHERE [user_id] = @userId
	AND DATEDIFF(HOUR, ISNULL(row_date_modified, DATEADD(HOUR, -24, GETUTCDATE())), GETUTCDATE()) > 24