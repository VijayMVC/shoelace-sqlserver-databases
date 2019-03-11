
CREATE PROCEDURE [dbo].[load_all_products_by_user_id]
@userMongoId NVARCHAR(50)
AS

-- -- DEBUGING CODE 
-- DECLARE @userMongoId AS NVARCHAR(50);
-- SET @userMongoId  = '5bd7ba4366e5d937d7c71c6a'

DECLARE @userId BIGINT;
DECLARE @shopifyDomain AS NVARCHAR(1024);
DECLARE @domain AS NVARCHAR(1024);

SELECT @userId = id, @shopifyDomain= shop_url, @domain = domain
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
      ,REPLACE([shopify_link], @shopifyDomain, ISNULL(@domain,@shopifyDomain)) AS shopify_link
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
    AND [product].[exclude_from_ads] = 0
    AND [product].[user_id] = @userId