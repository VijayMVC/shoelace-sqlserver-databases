
CREATE PROCEDURE [dbo].[order_lineitem_batch_upsert] 
@userMongoId NVARCHAR(50),
@orderUpdateRecords order_upsert READONLY ,
@lineItemUpdateRecords lineitem_upsert READONLY

AS 

DECLARE @User_Id BIGINT;

SELECT @User_Id = [id] FROM [user] WHERE mongo_id like @userMongoId

MERGE INTO [order] AS Target 
USING @orderUpdateRecords AS Source 
ON Target.[shopify_id] = Source.[shopify_id]
WHEN MATCHED THEN 
    UPDATE SET 
        Target.[user_id] = @User_Id,
        Target.[order_number] = Source.[order_number],
        Target.[total_price_usd] = Source.[total_price_usd],
        Target.[discount_codes] = Source.[discount_codes],
        Target.[financial_status] = Source.[financial_status],
        Target.[landing_site] = Source.[landing_site],
        Target.[referring_site] = Source.[referring_site],
        Target.[user_agent] = Source.[user_agent],
        Target.[email] = Source.[email],
        Target.[source_name] = Source.[source_name],
        Target.[created_at] = CAST(Source.[created_at] AS DATETIME2),
        Target.[cancelled_at] = CAST(Source.[cancelled_at] AS DATETIME2)
WHEN NOT MATCHED THEN
    INSERT (
        	[user_id],
            [shopify_id],
            [order_number],
            [total_price_usd],
            [discount_codes],
            [financial_status],
            [landing_site],
            [referring_site],
            [user_agent],
            [email],
            [source_name],
            [created_at],
            [cancelled_at]
     ) 
    VALUES (
        	@User_Id,
            Source.[shopify_id],
            Source.[order_number],
            Source.[total_price_usd],
            Source.[discount_codes],
            Source.[financial_status],
            Source.[landing_site],
            Source.[referring_site],
            Source.[user_agent],
            Source.[email],
            Source.[source_name],
            CAST(Source.[created_at] AS DATETIME2),
            CAST(Source.[cancelled_at] AS DATETIME2)
    ); 

MERGE INTO [lineitem] AS Target 
USING 
    (
        SELECT 
            [order].id AS order_id,
            [lineItemTable].shopify_id,
            [lineItemTable].shopify_product_id,
            [lineItemTable].shopify_variant_id,
            [lineItemTable].shopify_product_title,
            [lineItemTable].quantity,
            [lineItemTable].price
        FROM @lineItemUpdateRecords AS [lineItemTable] 
            INNER JOIN [order] ON [lineItemTable].[order_id] = [order].[shopify_id] 
    ) AS Source 
ON Target.[shopify_id] = Source.[shopify_id]
WHEN MATCHED THEN 
    UPDATE SET 
        Target.[order_id] = Source.[order_id],
        Target.[shopify_product_id] = Source.[shopify_product_id],
        Target.[shopify_variant_id] = Source.[shopify_variant_id],
        Target.[shopify_product_title] = Source.[shopify_product_title],
        Target.[quantity] = Source.[quantity],
        Target.[price] = Source.[price]
WHEN NOT MATCHED THEN
    INSERT (
        	[order_id],
            [shopify_id],
            [shopify_product_id],
            [shopify_variant_id],
            [shopify_product_title],
            [quantity],
            [price]
     ) 
    VALUES (
        	Source.[order_id],
            Source.[shopify_id],
            Source.[shopify_product_id],
            Source.[shopify_variant_id],
            Source.[shopify_product_title],
            Source.[quantity],
            Source.[price]
            );