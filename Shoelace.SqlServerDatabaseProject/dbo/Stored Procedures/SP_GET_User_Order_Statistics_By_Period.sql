CREATE PROCEDURE [dbo].[SP_GET_User_Order_Statistics_By_Period]
@User_Mango_Id AS NVARCHAR(50)

AS

-- -- DEBUGGING CODE
-- DECLARE @User_Mango_Id AS NVARCHAR(50);
-- SET @User_Mango_Id = '5a83447240e35713bbd91cae';


DECLARE @CurrentDate AS DATE;
SET @CurrentDate = GETDATE();
DECLARE @user_Id AS BIGINT;
SELECT @user_Id = id FROM [user] WHERE [user].mongo_id LIKE @User_Mango_Id;

WITH
CTE_UserOrders AS 
(
    SELECT [order].id, [order].created_at
    FROM [order] 
    WHERE [order].user_id = @user_Id
        AND [order].cancelled_at IS NULL
        AND [order].source_name = 'web'
        AND [order].financial_status != 'pending' 
), 
CTE_LineItemStats_Day AS
(
    SELECT
        SUM([lineitem].quantity) AS productCount,
        COUNT([lineitem].id) AS uniqueProductCount
    FROM CTE_UserOrders INNER JOIN [lineitem] ON CTE_UserOrders.id = [lineitem].order_id
    WHERE CTE_UserOrders.created_at >= CAST(DATEADD(DAY,-1,@CurrentDate) AS DATE)
),
CTE_OrderStats_Day AS 
(
    SELECT
        SUM([order].total_price_usd) AS sales,
        COUNT(DISTINCT [order].id) AS count,
        MIN([order].created_at) AS earliestDate,
        MAX([order].created_at) AS latestDate
    FROM [order] INNER JOIN CTE_UserOrders ON CTE_UserOrders.id = [order].id
    WHERE CTE_UserOrders.created_at >= CAST(DATEADD(DAY,-1,@CurrentDate) AS DATE)
), 
CTE_LineItemStats_Week AS
(
    SELECT
        SUM([lineitem].quantity) AS productCount,
        COUNT([lineitem].id) AS uniqueProductCount
    FROM CTE_UserOrders INNER JOIN [lineitem] ON CTE_UserOrders.id = [lineitem].order_id
    WHERE CTE_UserOrders.created_at >= CAST(DATEADD(DAY,-7,@CurrentDate) AS DATE)
),
CTE_OrderStats_Week AS 
(
    SELECT
        SUM([order].total_price_usd) AS sales,
        COUNT(DISTINCT [order].id) AS count,
        MIN([order].created_at) AS earliestDate,
        MAX([order].created_at) AS latestDate
    FROM [order] INNER JOIN CTE_UserOrders ON CTE_UserOrders.id = [order].id
    WHERE CTE_UserOrders.created_at >= CAST(DATEADD(DAY,-7,@CurrentDate) AS DATE)
), 
CTE_LineItemStats_Month AS
(
    SELECT
        SUM([lineitem].quantity) AS productCount,
        COUNT([lineitem].id) AS uniqueProductCount
    FROM CTE_UserOrders INNER JOIN [lineitem] ON CTE_UserOrders.id = [lineitem].order_id
    WHERE CTE_UserOrders.created_at >= CAST(DATEADD(DAY,-30,@CurrentDate) AS DATE)
),
CTE_OrderStats_Month AS 
(
    SELECT
        SUM([order].total_price_usd) AS sales,
        COUNT(DISTINCT [order].id) AS count,
        MIN([order].created_at) AS earliestDate,
        MAX([order].created_at) AS latestDate
    FROM [order] INNER JOIN CTE_UserOrders ON CTE_UserOrders.id = [order].id
    WHERE CTE_UserOrders.created_at >= CAST(DATEADD(DAY,-30,@CurrentDate) AS DATE)
), 
CTE_LineItemStats_Lifetime AS
(
    SELECT
        SUM([lineitem].quantity) AS productCount,
        COUNT([lineitem].id) AS uniqueProductCount
    FROM CTE_UserOrders INNER JOIN [lineitem] ON CTE_UserOrders.id = [lineitem].order_id
),
CTE_OrderStats_Lifetime AS 
(
    SELECT
        SUM([order].total_price_usd) AS sales,
        COUNT(DISTINCT [order].id) AS count,
        MIN([order].created_at) AS earliestDate,
        MAX([order].created_at) AS latestDate
    FROM [order] INNER JOIN CTE_UserOrders ON CTE_UserOrders.id = [order].id
)

SELECT 'day' as 'period', sales, [count], earliestDate, latestDate, CAST(productCount AS BIGINT) AS productCount, CAST(uniqueProductCount AS BIGINT) AS uniqueProductCount    
FROM CTE_OrderStats_Day, CTE_LineItemStats_Day
UNION
SELECT 'week' as 'period', sales, [count], earliestDate, latestDate, CAST(productCount AS BIGINT) AS productCount, CAST(uniqueProductCount AS BIGINT) AS uniqueProductCount    
FROM CTE_OrderStats_Week, CTE_LineItemStats_Week
UNION
SELECT 'month' as 'period', sales, [count], earliestDate, latestDate, CAST(productCount AS BIGINT) AS productCount, CAST(uniqueProductCount AS BIGINT) AS uniqueProductCount    
FROM CTE_OrderStats_Month, CTE_LineItemStats_Month
UNION
SELECT 'lifetime' as 'period', sales, [count], earliestDate, latestDate, CAST(productCount AS BIGINT) AS productCount, CAST(uniqueProductCount AS BIGINT) AS uniqueProductCount    
FROM CTE_OrderStats_Lifetime, CTE_LineItemStats_Lifetime