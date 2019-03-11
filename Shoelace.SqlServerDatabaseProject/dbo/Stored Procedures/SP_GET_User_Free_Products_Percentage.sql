
CREATE PROCEDURE [dbo].[SP_GET_User_Free_Products_Percentage]
		@User_Mango_Id varchar(50)
		
As
---- =============================================
---- Author:      <Ali Qaryan>
---- Create Date: <Create Date, , >
---- Description: <Description, , >
---- =============================================


BEGIN
DECLARE @allProducts bigint
DECLARE @freeProducts bigint

SELECT
	@allProducts = COUNT(*)
FROM product p
LEFT JOIN [user] u
	ON p.[user_id] = u.id
WHERE u.mongo_id = @User_Mango_Id


SELECT
	@freeProducts = COUNT(*)
FROM product p
LEFT JOIN [user] u
	ON p.[user_id] = u.id
WHERE u.mongo_id = @User_Mango_Id
AND p.price = 0

IF (@allProducts = 0)
    BEGIN
        SELECT 0 AS result
    END
ELSE
    BEGIN
        SELECT CONVERT(DECIMAL(3, 3), CAST(@freeProducts AS DECIMAL) / CAST(@allProducts AS DECIMAL)) AS result
    END

END