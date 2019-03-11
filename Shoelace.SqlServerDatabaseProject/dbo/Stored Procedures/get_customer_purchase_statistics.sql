CREATE PROCEDURE [dbo].[get_customer_purchase_statistics]
    @lastNDays AS INT,
    @userMongoId AS NVARCHAR(50)
AS 

-- -- debugging code
-- DECLARE @lastNDays AS INT;
-- DECLARE @userMongoId AS NVARCHAR(50)
-- SET @lastNDays = 90;
-- SET @userMongoId = '57c63e91f38844f4459d3db5';

DECLARE @user_id AS BIGINT
SELECT @user_id = id FROM [user] where mongo_id = @userMongoId
DECLARE @ToDayDate AS DATETIME;
SET @ToDayDate = CONVERT(date, GETDATE());

WITH CTE_Customer_Order_Count AS
(
    SELECT customer_id, count(*) AS order_count
    FROM [order] 
    WHERE user_id = @user_id 
        AND created_at > DATEADD(day, (@lastNDays * -1), @ToDayDate)
    GROUP BY customer_id
),
CTE_TotalCustomerCount AS 
( 
    SELECT COUNT(*) AS total_customer_count FROM CTE_Customer_Order_Count
),
CTE_RepeatCustomerCount AS 
( 
    SELECT COUNT(*) AS repeat_customer_count FROM CTE_Customer_Order_Count WHERE order_count > 1
)

SELECT CTE_TotalCustomerCount.total_customer_count, CTE_RepeatCustomerCount.repeat_customer_count FROM CTE_TotalCustomerCount,CTE_RepeatCustomerCount