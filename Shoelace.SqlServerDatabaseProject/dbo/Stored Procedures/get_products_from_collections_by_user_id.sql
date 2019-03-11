-- CREATE TYPE [dbo].[collection_handles] AS TABLE(
-- 	[handle] NVARCHAR(1000) NOT NULL
-- )
-- GO

-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO

CREATE PROCEDURE [dbo].[get_products_from_collections_by_user_id]
@userMongoId NVARCHAR(50),
@collectionHandles collection_handles READONLY
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


SELECT [product].[id]
      ,[product].[user_id]
      ,[product].[shopify_id]
      ,[product].[img_id]
      ,[product].[img_url]
      ,[product].[s3_img_url]
      ,[product].[price]
      ,[product].[currency]
      ,[product].[title]
      ,[product].[description]
      ,[product].[tags]
      ,[product].[brand]
      ,REPLACE([product].[shopify_link], @shopifyDomain, ISNULL(@domain,@shopifyDomain)) AS shopify_link
      ,[product].[published_at]
      ,[product].[availability]
      ,[product].[has_multiple_prices]
      ,[product].[should_transform]
      ,[product].[date_created]
      ,[product].[date_updated]
      ,[product].[date_deleted]
      ,[product].[exclude_from_ads]
      , [collection].handle, [collection].title as collectiontitle
    FROM [product]
    INNER JOIN [productcollection] ON [productcollection].shopify_product_id = [product].shopify_id
    LEFT JOIN [collection] ON [collection].shopify_id = [productcollection].shopify_collection_id
    WHERE
        [product].user_id = @userId
        AND [collection].handle IN (SELECT handle FROM @collectionHandles)
        AND [product].[exclude_from_ads] = 0 
        AND [product].date_deleted IS NULL 
        AND [product].availability = 'in stock'