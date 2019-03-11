CREATE PROCEDURE [dbo].[SP_GET_User_Best_Sellers_By_Period]
@User_Mango_Id AS NVARCHAR(50)

AS

-- -- DEBUGGING CODE
-- DECLARE @User_Mango_Id AS NVARCHAR(50);
-- SET @User_Mango_Id = '5a0381b12d740c36aeabfc9d';

DECLARE @user_Id BIGINT;
DECLARE @shopifyDomain AS NVARCHAR(1024);
DECLARE @domain AS NVARCHAR(1024);

SELECT @user_Id = id, @shopifyDomain= shop_url, @domain = domain
FROM dbo.[user]
WHERE mongo_id = @User_Mango_Id;

DECLARE @CurrentDate AS DATE;
SET @CurrentDate = GETDATE();

WITH
CTE_UserOrders AS 
(
    SELECT [order].id , [order].created_at
    FROM [order] 
    WHERE [order].user_id = @user_Id
        AND [order].cancelled_at IS NULL
        AND [order].financial_status != 'pending' 
), 
CTE_LineItemProducts_Day AS
(
    SELECT
        [lineitem].shopify_product_id,
        MAX(CTE_UserOrders.created_at) AS latestDate,
        SUM ([lineitem].quantity) AS occurrences,
        COUNT(DISTINCT CTE_UserOrders.id) AS orderCount
    FROM CTE_UserOrders 
        INNER JOIN [lineitem] ON CTE_UserOrders.id = [lineitem].order_id
    WHERE CTE_UserOrders.created_at >= CAST(DATEADD(DAY,-1,@CurrentDate) AS DATE)
    GROUP BY [lineitem].shopify_product_id
),
CTE_ProductDetails_Day AS
(
    SELECT
        CTE_LineItemProducts_Day.shopify_product_id,
        CTE_LineItemProducts_Day.occurrences,
        CTE_LineItemProducts_Day.orderCount,
        CTE_LineItemProducts_Day.latestDate,
        [product].title,
        REPLACE([product].[shopify_link], @shopifyDomain, @domain) AS shopify_link,
        [product].price,
        [product].s3_img_url,
        [product].img_url,
        [product].shopify_id,
        [product].shopify_id AS product_id, -- this is added for backward compatibility 
        [product].currency
    FROM [product] 
        INNER JOIN CTE_LineItemProducts_Day ON [product].shopify_id = CTE_LineItemProducts_Day.shopify_product_id
    WHERE [product].date_deleted IS NULL 
        AND [product].availability = 'in stock'
        AND [product].[exclude_from_ads] = 0 -- only return products that are not excluded.
), 
CTE_LineItemProducts_Week AS
(
    SELECT
        [lineitem].shopify_product_id,
        MAX(CTE_UserOrders.created_at) AS latestDate,
        SUM ([lineitem].quantity) AS occurrences,
        COUNT(DISTINCT CTE_UserOrders.id) AS orderCount
    FROM CTE_UserOrders 
        INNER JOIN [lineitem] ON CTE_UserOrders.id = [lineitem].order_id
    WHERE CTE_UserOrders.created_at >= CAST(DATEADD(DAY,-7,@CurrentDate) AS DATE)
    GROUP BY [lineitem].shopify_product_id
),
CTE_ProductDetails_Week AS
(
    SELECT
        CTE_LineItemProducts_Week.shopify_product_id,
        CTE_LineItemProducts_Week.occurrences,
        CTE_LineItemProducts_Week.orderCount,
        CTE_LineItemProducts_Week.latestDate,
        [product].title,
        REPLACE([product].shopify_link, @shopifyDomain,ISNULL(@domain,@shopifyDomain)) AS shopify_link,
        [product].price,
        [product].s3_img_url,
        [product].img_url,
        [product].shopify_id,
        [product].shopify_id AS product_id, -- this is added for backward compatibility 
        [product].currency
    FROM [product] 
        INNER JOIN CTE_LineItemProducts_Week ON [product].shopify_id = CTE_LineItemProducts_Week.shopify_product_id
    WHERE [product].date_deleted IS NULL 
        AND [product].availability = 'in stock'
        AND [product].[exclude_from_ads] = 0 -- only return products that are not excluded.
), 
CTE_LineItemProducts_Month AS
(
    SELECT
        [lineitem].shopify_product_id,
        MAX(CTE_UserOrders.created_at) AS latestDate,
        SUM ([lineitem].quantity) AS occurrences,
        COUNT(DISTINCT CTE_UserOrders.id) AS orderCount
    FROM CTE_UserOrders 
        INNER JOIN [lineitem] ON CTE_UserOrders.id = [lineitem].order_id
    WHERE CTE_UserOrders.created_at >= CAST(DATEADD(DAY,-30,@CurrentDate) AS DATE)
    GROUP BY [lineitem].shopify_product_id
),
CTE_ProductDetails_Month AS
(
    SELECT
        CTE_LineItemProducts_Month.shopify_product_id,
        CTE_LineItemProducts_Month.occurrences,
        CTE_LineItemProducts_Month.orderCount,
        CTE_LineItemProducts_Month.latestDate,
        [product].title,
        REPLACE([product].shopify_link, @shopifyDomain,ISNULL(@domain,@shopifyDomain)) AS shopify_link,
        [product].price,
        [product].s3_img_url,
        [product].img_url,
        [product].shopify_id,
        [product].shopify_id AS product_id, -- this is added for backward compatibility 
        [product].currency
    FROM [product] 
        INNER JOIN CTE_LineItemProducts_Month ON [product].shopify_id = CTE_LineItemProducts_Month.shopify_product_id
    WHERE [product].date_deleted IS NULL 
        AND [product].availability = 'in stock'
        AND [product].[exclude_from_ads] = 0 -- only return products that are not excluded.
), 
CTE_LineItemProducts_Lifetime AS
(
    SELECT
        [lineitem].shopify_product_id,
        MAX(CTE_UserOrders.created_at) AS latestDate,
        SUM ([lineitem].quantity) AS occurrences,
        COUNT(DISTINCT CTE_UserOrders.id) AS orderCount
    FROM CTE_UserOrders 
        INNER JOIN [lineitem] ON CTE_UserOrders.id = [lineitem].order_id
    GROUP BY [lineitem].shopify_product_id
),
CTE_ProductDetails_Lifetime AS
(
    SELECT
        CTE_LineItemProducts_Lifetime.shopify_product_id,
        CTE_LineItemProducts_Lifetime.occurrences,
        CTE_LineItemProducts_Lifetime.orderCount,
        CTE_LineItemProducts_Lifetime.latestDate,
        [product].title,
        REPLACE([product].shopify_link, @shopifyDomain,ISNULL(@domain,@shopifyDomain)) AS shopify_link,
        [product].price,
        [product].s3_img_url,
        [product].img_url,
        [product].shopify_id,
        [product].shopify_id AS product_id, -- this is added for backward compatibility 
        [product].currency
    FROM [product] 
        INNER JOIN CTE_LineItemProducts_Lifetime ON [product].shopify_id = CTE_LineItemProducts_Lifetime.shopify_product_id
    WHERE [product].date_deleted IS NULL 
        AND [product].availability = 'in stock'
        AND [product].[exclude_from_ads] = 0 -- only return products that are not excluded.
)

SELECT * FROM (
    SELECT TOP 30 'day' as 'period', * FROM CTE_ProductDetails_Day ORDER BY occurrences DESC
    UNION
    SELECT TOP 30 'week' as 'period', * FROM CTE_ProductDetails_Week ORDER BY occurrences DESC
    UNION
    SELECT TOP 30 'month' as 'period', * FROM CTE_ProductDetails_Month ORDER BY occurrences DESC
    UNION
    SELECT TOP 30 'lifetime' as 'period', * FROM CTE_ProductDetails_Lifetime ORDER BY occurrences DESC
) AS Blah