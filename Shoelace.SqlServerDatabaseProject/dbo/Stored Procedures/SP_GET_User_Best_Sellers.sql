CREATE PROCEDURE [dbo].[SP_GET_User_Best_Sellers]
@User_Mango_Id AS NVARCHAR(50),
@Created_At_Cutoff AS DATE = '1900-1-1'

AS

-- -- DEBUGGING CODE
-- DECLARE @User_Mango_Id AS NVARCHAR(50);
-- DECLARE @Created_At_Cutoff AS DATE;
-- SET @User_Mango_Id = '5a0381b12d740c36aeabfc9d';
-- SET @Created_At_Cutoff = '1900-01-01'

DECLARE @user_Id BIGINT;
DECLARE @shopifyDomain AS NVARCHAR(1024);
DECLARE @domain AS NVARCHAR(1024);

SELECT @user_Id = id, @shopifyDomain= shop_url, @domain = domain
FROM dbo.[user]
WHERE mongo_id = @User_Mango_Id;

WITH
CTE_UserOrders AS 
(
    SELECT [order].id , MAX([order].created_at) AS latestDate
    FROM [order] 
    WHERE [order].user_id = @user_Id
        AND [order].cancelled_at IS NULL
        AND [order].financial_status != 'pending' 
        AND [order].created_at >= @Created_At_Cutoff
    GROUP BY [order].id
), 
CTE_LineItemProducts AS
(
    SELECT
        [lineitem].shopify_product_id,
        MAX(CTE_UserOrders.latestDate) AS latestDate,
        SUM ([lineitem].quantity) AS occurrences,
        COUNT(DISTINCT CTE_UserOrders.id) AS orderCount
   
    FROM CTE_UserOrders 
        INNER JOIN [lineitem] ON CTE_UserOrders.id = [lineitem].order_id
    GROUP BY [lineitem].shopify_product_id
),
CTE_ProductDetails AS
(
    SELECT
        CTE_LineItemProducts.shopify_product_id,
        CTE_LineItemProducts.occurrences,
        CTE_LineItemProducts.orderCount,
        CTE_LineItemProducts.latestDate,
        [product].title,
        REPLACE([product].[shopify_link], @shopifyDomain, @domain) AS shopify_link,
        [product].price,
        [product].s3_img_url,
        [product].img_url,
        [product].shopify_id,
        [product].shopify_id AS product_id, -- this is added for backward compatibility 
        [product].currency
    FROM [product] 
        INNER JOIN CTE_LineItemProducts ON [product].shopify_id = CTE_LineItemProducts.shopify_product_id
    WHERE [product].date_deleted IS NULL 
        AND [product].availability = 'in stock'
        AND [product].[exclude_from_ads] = 0 -- only return products that are not excluded.
)


SELECT TOP 30 * FROM CTE_ProductDetails
ORDER BY occurrences DESC