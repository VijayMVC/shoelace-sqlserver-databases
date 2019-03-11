
CREATE PROCEDURE [dbo].[productcollection_batch_upsert] 
@userMongoId NVARCHAR(50),
@productCollectionUpdateRecords productcollection_upsert READONLY 

AS 

DECLARE @User_Id BIGINT;

SELECT @User_Id = [id] FROM [user] WHERE mongo_id like @userMongoId

BEGIN TRANSACTION;  

DELETE FROM [productcollection] WHERE [productcollection].[id] IN (
    SELECT [productcollection].[id] 
    FROM [productcollection] 
        INNER JOIN @productCollectionUpdateRecords AS validProductCollections 
            ON [productcollection].[shopify_product_id] = validProductCollections.[shopify_product_id]

    WHERE [productcollection].[user_id] = @User_Id 
);

MERGE INTO [productcollection] AS Target 
USING @productCollectionUpdateRecords AS Source 
ON Target.[shopify_id] = Source.[shopify_id]
WHEN MATCHED THEN 
    UPDATE SET 
        Target.[user_id] = @User_Id,
        Target.[shopify_collection_id] = Source.[shopify_collection_id],
        Target.[shopify_product_id] = Source.[shopify_product_id]
WHEN NOT MATCHED THEN
    INSERT (
        	[user_id],
            [shopify_id],
            [shopify_collection_id],
            [shopify_product_id]
     ) 
    VALUES (
        	@User_Id,
            Source.[shopify_id],
            Source.[shopify_collection_id],
            Source.[shopify_product_id]
    ); 

COMMIT TRANSACTION;