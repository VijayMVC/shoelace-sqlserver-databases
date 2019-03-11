CREATE PROCEDURE [dbo].[SP_GET_User_Order_Statistics_by_source]
@User_Mango_Id AS NVARCHAR(50),
@Created_At_Cutoff AS DATE = '1900-1-1'

AS

-- -- DEBUGGING CODE
-- DECLARE @User_Mango_Id AS NVARCHAR(50);
-- DECLARE @Created_At_Cutoff AS DATE;
-- SET @User_Mango_Id = '57c63e91f38844f4459d3db5';
-- SET @Created_At_Cutoff = '1900-05-01'

DECLARE @user_Id AS BIGINT;
SELECT @user_Id = id FROM [user] WHERE [user].mongo_id = @User_Mango_Id;

WITH
CTE_UserOrders AS 
(
    SELECT [order].id, CASE WHEN CHARINDEX(':',[order].source_name) > 0 THEN SUBSTRING([order].source_name,0,CHARINDEX(':',[order].source_name)) ELSE [order].source_name END AS 'source_name'
    FROM [order] 
    WHERE [order].user_id = @user_Id
        AND [order].cancelled_at IS NULL
        AND [order].financial_status != 'pending' 
        AND [order].created_at >= @Created_At_Cutoff
), 
CTE_LineItemStats AS
(
    SELECT
        [CTE_UserOrders].source_name, 
        SUM([lineitem].quantity) AS productCount,
        COUNT([lineitem].id) AS uniqueProductCount
    FROM CTE_UserOrders INNER JOIN [lineitem] ON CTE_UserOrders.id = [lineitem].order_id
    GROUP BY [CTE_UserOrders].source_name
),
CTE_OrderStats AS 
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

SELECT CTE_OrderStats.source_name, sales, [count], earliestDate, latestDate, CAST(productCount AS BIGINT) AS productCount, CAST(uniqueProductCount AS BIGINT) AS uniqueProductCount    
FROM CTE_OrderStats INNER JOIN  CTE_LineItemStats ON CTE_OrderStats.source_name = CTE_LineItemStats.source_name