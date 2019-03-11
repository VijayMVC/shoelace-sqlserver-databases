
CREATE PROCEDURE [dbo].[product_batch_upsert_v2] 
@userMongoId NVARCHAR(50),
@productUpdateRecords product_upsert_v3 READONLY 

AS 

DECLARE @User_Id BIGINT;

SELECT @User_Id = [id] FROM [user] WHERE mongo_id like @userMongoId

SELECT      
    newProducts.[shopify_id],
    newProducts.[img_id],
    newProducts.[img_url],
    newProducts.[s3_img_url],
    newProducts.[price],
    newProducts.[currency],
    newProducts.[title],
    newProducts.[description],
    newProducts.[tags],
    newProducts.[brand],
    newProducts.[shopify_link],
    newProducts.[published_at],
    newProducts.[availability] ,
    newProducts.[has_multiple_prices],
    ISNULL(oldProducts.should_transform, 1) AS [should_transform], -- if image has not changed keep old state
    newProducts.[date_created],
    newProducts.[date_updated],
    newProducts.[date_deleted],
    newProducts.[exclude_from_ads],
	newProducts.[secondary_img_id],
    newProducts.[secondary_img_url],
	newProducts.[compare_at_price],
	newProducts.[gender]
INTO #tempNewProducts 
FROM  @productUpdateRecords AS newProducts
    LEFT JOIN [product] AS oldProducts ON newProducts.shopify_id = oldProducts.shopify_id 
        AND newProducts.img_id = oldProducts.img_id
        AND oldProducts.user_id = @user_id;

BEGIN TRANSACTION

MERGE INTO [product] AS Target 
USING #tempNewProducts AS Source 
ON Target.[shopify_id] = Source.[shopify_id]
WHEN MATCHED THEN 
    UPDATE SET 
        Target.[user_id] = @User_Id,
        Target.[img_id] = Source.[img_id],
        Target.[img_url] = Source.[img_url],
        Target.[s3_img_url] = Source.[s3_img_url],
        Target.[price] = Source.[price],
        Target.[currency] = Source.[currency],
        Target.[title] = Source.[title],
        Target.[description] = Source.[description],
        Target.[tags] = Source.[tags],
        Target.[brand] = Source.[brand],
        Target.[shopify_link] = Source.[shopify_link],
        Target.[published_at] = CAST(Source.[published_at] AS DATETIME2),
        Target.[availability] = Source.[availability],
        Target.[has_multiple_prices] = Source.[has_multiple_prices],
        Target.[should_transform] = Source.[should_transform],
        Target.[date_created] = CAST(Source.[date_created] AS DATETIME2),
        Target.[date_updated] = CAST(Source.[date_updated] AS DATETIME2),
        Target.[date_deleted] = CAST(Source.[date_deleted] AS DATETIME2),
        Target.[exclude_from_ads] = Source.[exclude_from_ads],
		Target.[row_date_modified] = GETUTCDATE(),
		Target.[secondary_img_id] = Source.[secondary_img_id],
        Target.[secondary_img_url] = Source.[secondary_img_url],
		Target.[compare_at_price] = Source.[compare_at_price],
        Target.[gender] = Source.[gender]
WHEN NOT MATCHED THEN
    INSERT (
        	[user_id],
            [shopify_id],
            [img_id] ,
            [img_url] ,
            [s3_img_url],
            [price],
            [currency] ,
            [title] ,
            [description] ,
            [tags],
            [brand] ,
            [shopify_link] ,
            [published_at],
            [availability] ,
            [has_multiple_prices],
            [should_transform] ,
            [date_created] ,
            [date_updated] ,
            [date_deleted] ,
            [exclude_from_ads],
			[row_date_created],
			[row_date_modified],
			[secondary_img_id],
			[secondary_img_url],
			[compare_at_price],
			[gender]
     ) 
    VALUES (
        	@User_Id,
            Source.[shopify_id],
            Source.[img_id] ,
            Source.[img_url] ,
            Source.[s3_img_url],
            Source.[price],
            Source.[currency] ,
            Source.[title] ,
            Source.[description] ,
            Source.[tags],
            Source.[brand] ,
            Source.[shopify_link] ,
            CAST(Source.[published_at] AS DATETIME2),
            Source.[availability] ,
            Source.[has_multiple_prices],
            Source.[should_transform] ,
            CAST(Source.[date_created] AS DATETIME2) ,
            CAST(Source.[date_updated] AS DATETIME2) ,
            CAST(Source.[date_deleted] AS DATETIME2) ,
            Source.[exclude_from_ads],
			GETUTCDATE(),
			GETUTCDATE(),
			Source.[secondary_img_id],
			Source.[secondary_img_url],
			Source.[compare_at_price],
			Source.[gender]
    ); 

UPDATE [user] SET last_prod_sync_date = GETDATE() WHERE id = @User_Id; 

COMMIT TRANSACTION