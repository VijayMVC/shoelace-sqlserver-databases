CREATE PROCEDURE [dbo].[SP_GET_User_Order_Statistics_by_source_by_period]
@User_Mango_Id AS NVARCHAR(50)

AS

-- -- DEBUGGING CODE
-- DECLARE @User_Mango_Id AS NVARCHAR(50);
-- SET @User_Mango_Id = '57c63e91f38844f4459d3db5';

DECLARE @CurrentDate AS DATE;
SET @CurrentDate = GETDATE();

DECLARE @user_Id AS BIGINT;
SELECT @user_Id = id FROM [user] WHERE [user].mongo_id = @User_Mango_Id;

WITH
CTE_UserOrders AS 
(
    SELECT [order].created_at,[order].id, CASE WHEN CHARINDEX(':',[order].source_name) > 0 THEN SUBSTRING([order].source_name,0,CHARINDEX(':',[order].source_name)) ELSE [order].source_name END AS 'source_name'
    FROM [order] 
    WHERE [order].user_id = @user_Id
        AND [order].cancelled_at IS NULL
        AND [order].financial_status != 'pending' 
), 
CTE_LineItemStats_Day AS
(
    SELECT
        [CTE_UserOrders].source_name, 
        SUM([lineitem].quantity) AS productCount,
        COUNT([lineitem].id) AS uniqueProductCount
    FROM CTE_UserOrders INNER JOIN [lineitem] ON CTE_UserOrders.id = [lineitem].order_id
    WHERE CTE_UserOrders.created_at >= CAST(DATEADD(DAY,-1,@CurrentDate) AS DATE)
    GROUP BY [CTE_UserOrders].source_name
),
CTE_OrderStats_Day AS 
(
    SELECT
    [order].source_name, 
    SUM([order].total_price_usd) AS sales,
    COUNT(DISTINCT [order].id) AS count,
    MIN([order].created_at) AS earliestDate,
    MAX([order].created_at) AS latestDate
    FROM [order] INNER JOIN CTE_UserOrders ON CTE_UserOrders.id = [order].id
    WHERE CTE_UserOrders.created_at >= CAST(DATEADD(DAY,-1,@CurrentDate) AS DATE)
    GROUP BY [order].source_name
), 
CTE_LineItemStats_Week AS
(
    SELECT
        [CTE_UserOrders].source_name, 
        SUM([lineitem].quantity) AS productCount,
        COUNT([lineitem].id) AS uniqueProductCount
    FROM CTE_UserOrders INNER JOIN [lineitem] ON CTE_UserOrders.id = [lineitem].order_id
    WHERE CTE_UserOrders.created_at >= CAST(DATEADD(DAY,-7,@CurrentDate) AS DATE)
    GROUP BY [CTE_UserOrders].source_name
),
CTE_OrderStats_Week AS 
(
    SELECT
    [order].source_name, 
    SUM([order].total_price_usd) AS sales,
    COUNT(DISTINCT [order].id) AS count,
    MIN([order].created_at) AS earliestDate,
    MAX([order].created_at) AS latestDate
    FROM [order] INNER JOIN CTE_UserOrders ON CTE_UserOrders.id = [order].id
    WHERE CTE_UserOrders.created_at >= CAST(DATEADD(DAY,-7,@CurrentDate) AS DATE)
    GROUP BY [order].source_name
), 
CTE_LineItemStats_Month AS
(
    SELECT
        [CTE_UserOrders].source_name, 
        SUM([lineitem].quantity) AS productCount,
        COUNT([lineitem].id) AS uniqueProductCount
    FROM CTE_UserOrders INNER JOIN [lineitem] ON CTE_UserOrders.id = [lineitem].order_id
    WHERE CTE_UserOrders.created_at >= CAST(DATEADD(DAY,-30,@CurrentDate) AS DATE)
    GROUP BY [CTE_UserOrders].source_name
),
CTE_OrderStats_Month AS 
(
    SELECT
    [order].source_name, 
    SUM([order].total_price_usd) AS sales,
    COUNT(DISTINCT [order].id) AS count,
    MIN([order].created_at) AS earliestDate,
    MAX([order].created_at) AS latestDate
    FROM [order] INNER JOIN CTE_UserOrders ON CTE_UserOrders.id = [order].id
    WHERE CTE_UserOrders.created_at >= CAST(DATEADD(DAY,-30,@CurrentDate) AS DATE)
    GROUP BY [order].source_name
), 
CTE_LineItemStats_Lifetime AS
(
    SELECT
        [CTE_UserOrders].source_name, 
        SUM([lineitem].quantity) AS productCount,
        COUNT([lineitem].id) AS uniqueProductCount
    FROM CTE_UserOrders INNER JOIN [lineitem] ON CTE_UserOrders.id = [lineitem].order_id
    GROUP BY [CTE_UserOrders].source_name
),
CTE_OrderStats_Lifetime AS 
(
    SELECT
    [order].source_name, 
    SUM([order].total_price_usd) AS sales,
    COUNT(DISTINCT [order].id) AS count,
    MIN([order].created_at) AS earliestDate,
    MAX([order].created_at) AS latestDate
    FROM [order] INNER JOIN CTE_UserOrders ON CTE_UserOrders.id = [order].id
    GROUP BY [order].source_name
)


SELECT 'day' as 'period', CTE_OrderStats_Day.source_name, sales, [count], earliestDate, latestDate, CAST(productCount AS BIGINT) AS productCount, CAST(uniqueProductCount AS BIGINT) AS uniqueProductCount    
FROM CTE_OrderStats_Day  INNER JOIN  CTE_LineItemStats_Day  ON CTE_OrderStats_Day .source_name = CTE_LineItemStats_Day .source_name
UNION
SELECT 'week' as 'period', CTE_OrderStats_Week.source_name, sales, [count], earliestDate, latestDate, CAST(productCount AS BIGINT) AS productCount, CAST(uniqueProductCount AS BIGINT) AS uniqueProductCount    
FROM CTE_OrderStats_Week  INNER JOIN  CTE_LineItemStats_Week  ON CTE_OrderStats_Week.source_name = CTE_LineItemStats_Week.source_name
UNION
SELECT 'month' as 'period', CTE_OrderStats_Month.source_name, sales, [count], earliestDate, latestDate, CAST(productCount AS BIGINT) AS productCount, CAST(uniqueProductCount AS BIGINT) AS uniqueProductCount    
FROM CTE_OrderStats_Month  INNER JOIN  CTE_LineItemStats_Month  ON CTE_OrderStats_Month.source_name = CTE_LineItemStats_Month.source_name
UNION
SELECT 'lifetime' as 'period', CTE_OrderStats_Lifetime.source_name, sales, [count], earliestDate, latestDate, CAST(productCount AS BIGINT) AS productCount, CAST(uniqueProductCount AS BIGINT) AS uniqueProductCount    
FROM CTE_OrderStats_Lifetime  INNER JOIN  CTE_LineItemStats_Lifetime  ON CTE_OrderStats_Lifetime.source_name = CTE_LineItemStats_Lifetime.source_name