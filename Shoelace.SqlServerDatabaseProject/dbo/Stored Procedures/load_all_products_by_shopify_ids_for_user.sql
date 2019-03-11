CREATE PROCEDURE [dbo].[load_all_products_by_shopify_ids_for_user]
@userMongoId NVARCHAR(50),
@productShopifyIds product_shopify_ids READONLY

AS

-- -- DEBUGING CODE 
-- DECLARE @userMongoId AS NVARCHAR(50);
-- SET @userMongoId  = '5c7ff3a00444e37fe9441bee'

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
      ,[row_date_created]
      ,[row_date_modified]
      ,[secondary_img_id]
      ,[secondary_img_url]
      ,[compare_at_price]
      ,[gender]
      ,shopify_id AS product_id 
    FROM [product] 
    WHERE [product].[date_deleted] IS NULL
    AND [product].[exclude_from_ads] = 0
    AND [product].[shopify_id] IN (SELECT shopify_id FROM @productShopifyIds)