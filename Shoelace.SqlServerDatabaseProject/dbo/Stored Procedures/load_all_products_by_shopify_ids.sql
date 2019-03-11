CREATE PROCEDURE [dbo].[load_all_products_by_shopify_ids]
@productShopifyIds product_shopify_ids READONLY

AS

SELECT *, shopify_id AS product_id 
    FROM [product] 
    WHERE [product].[date_deleted] IS NULL
    AND [product].[exclude_from_ads] = 0
    AND [product].[shopify_id] IN (SELECT shopify_id FROM @productShopifyIds)