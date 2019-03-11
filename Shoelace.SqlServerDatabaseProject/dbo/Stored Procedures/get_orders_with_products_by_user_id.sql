
CREATE PROCEDURE [dbo].[get_orders_with_products_by_user_id]
@userMongoId NVARCHAR(50)
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

SELECT
    [order].id as order_id,
    [order].order_number as order_number,
    [order].total_price_usd as total_price_usd,
    [order].discount_codes as discount_codes,
    [order].financial_status as financial_status,
    [order].landing_site as landing_site,
    [order].referring_site as referring_site,
    [order].source_name as source_name,
    [order].created_at as created_at,
    [order].cancelled_at as cancelled_at,
    [lineitem].shopify_product_id AS shopify_product_id,
    [lineitem].price AS lineitem_price,
    [lineitem].quantity AS quantity,
    [product].title AS product_title,
    [product].description AS product_description,
    [product].currency AS currency,
    REPLACE([shopify_link], @shopifyDomain, ISNULL(@domain,@shopifyDomain)) AS shopify_link
FROM [order]
    INNER JOIN [lineitem] on [order].id = [lineitem].order_id
    LEFT JOIN [product] on [product].shopify_id = [lineitem].shopify_product_id
WHERE [order].user_id = @userId