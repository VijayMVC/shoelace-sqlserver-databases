
CREATE PROCEDURE [dbo].[load_products_by_user_id]
@userMongoId NVARCHAR(50)
AS

-- -- DEBUGING CODE 
-- DECLARE @userMongoId NVARCHAR(50);
-- SET @userMongoId = '5a0f7222ecb0e67b0adfa3de';

DECLARE @userId BIGINT;

SELECT @userId = id
FROM dbo.[user]
WHERE mongo_id = @userMongoId

SELECT [id]
      ,[user_id]
      ,[shopify_id]
      ,[img_id]
      ,[img_url]
      ,[s3_img_url]
      ,[price]
      ,[currency]
      ,[title]
      ,[description]
      ,[tags]
      ,[brand]
      ,[shopify_link]
      ,[published_at]
      ,[availability]
      ,[has_multiple_prices]
      ,[should_transform]
      ,[date_created]
      ,[date_updated]
      ,[date_deleted]
      ,[exclude_from_ads]
      ,[shopify_id] AS product_id 
FROM [product] 
WHERE [product].[date_deleted] IS NULL
    AND [product].[availability] = 'in stock'
    AND [product].[exclude_from_ads] = 0
    AND [product].[user_id] = @userId