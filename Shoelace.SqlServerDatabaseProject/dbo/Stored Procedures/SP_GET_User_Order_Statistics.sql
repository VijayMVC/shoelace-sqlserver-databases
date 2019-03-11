CREATE PROCEDURE [dbo].[SP_GET_User_Order_Statistics]
@User_Mango_Id AS NVARCHAR(50),
@Created_At_Cutoff AS DATE = '1900-1-1'

AS

-- -- DEBUGGING CODE
-- DECLARE @User_Mango_Id AS NVARCHAR(50);
-- DECLARE @Created_At_Cutoff AS DATE;
-- SET @User_Mango_Id = '57c63e91f38844f4459d3db5';
-- SET @Created_At_Cutoff = '1900-1-1'

DECLARE @user_Id AS BIGINT;
SELECT @user_Id = id FROM [user] WHERE [user].mongo_id = @User_Mango_Id;

WITH
CTE_UserOrders AS 
(
    SELECT [order].id
    FROM [order] 
    WHERE [order].user_id = @user_Id
        AND [order].cancelled_at IS NULL
        AND [order].source_name = 'web'
        AND [order].financial_status != 'pending' 
        AND [order].created_at >= @Created_At_Cutoff
), 
CTE_LineItemStats AS
(
    SELECT
        SUM([lineitem].quantity) AS productCount,
        COUNT([lineitem].id) AS uniqueProductCount
    FROM CTE_UserOrders INNER JOIN [lineitem] ON CTE_UserOrders.id = [lineitem].order_id
),
CTE_OrderStats AS 
(
    SELECT
    SUM([order].total_price_usd) AS sales,
    COUNT(DISTINCT [order].id) AS count,
    MIN([order].created_at) AS earliestDate,
    MAX([order].created_at) AS latestDate
    FROM [order] INNER JOIN CTE_UserOrders ON CTE_UserOrders.id = [order].id
)

SELECT sales, [count], earliestDate, latestDate, CAST(productCount AS BIGINT) AS productCount, CAST(uniqueProductCount AS BIGINT) AS uniqueProductCount    
FROM CTE_OrderStats, CTE_LineItemStats

-- CREATE NONCLUSTERED INDEX IX_Order_UserId_Cancelation_SourceName_FinancialStatus 
-- ON [ORDER] (user_id, cancelled_at, source_name, financial_status)

-- DROP INDEX IX_Order_UserId_Cancelation_SourceName_FinancialStatus ON [ORDER]