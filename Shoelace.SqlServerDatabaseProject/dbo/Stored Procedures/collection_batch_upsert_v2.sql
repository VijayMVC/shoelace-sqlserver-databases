


CREATE PROCEDURE [dbo].[collection_batch_upsert_v2] 
@userMongoId NVARCHAR(50),
@collectionUpdateRecords collection_upsert_v2 READONLY 

AS 

DECLARE @User_Id BIGINT;

SELECT @User_Id = [id] FROM [user] WHERE mongo_id like @userMongoId

MERGE INTO [collection] AS Target 
USING @collectionUpdateRecords AS Source 
ON Target.[shopify_id] = Source.[shopify_id]
WHEN MATCHED THEN 
    UPDATE SET 
        Target.[user_id] = @User_Id,
        Target.[title] = Source.[title],
        Target.[handle] = Source.[handle],
        Target.[type] = Source.[type],
        Target.[date_updated] = CAST(Source.[date_updated] AS DATETIME2),
		Target.[row_date_modified] = GETUTCDATE()
WHEN NOT MATCHED THEN
    INSERT (
        	[user_id],
            [shopify_id],
            [title],
            [handle],
            [type],
			[date_updated],
			[row_date_created],
			[row_date_modified]
     ) 
    VALUES (
        	@User_Id,
            Source.[shopify_id],
            Source.[title],
            Source.[handle],
            Source.[type],
			CAST(Source.[date_updated] AS DATETIME2),
			GETUTCDATE(),
			GETUTCDATE()
    );
