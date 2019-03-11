
CREATE PROCEDURE [dbo].[get_user_info_by_user_id]
@userMongoId NVARCHAR(50)
AS
-- =============================================
-- Author:      <Ali Qaryan>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================

-- -- DEBUGING CODE 
-- DECLARE @userMongoId NVARCHAR(50);
-- SET @userMongoId = '5a0f7222ecb0e67b0adfa3de';

SELECT
	[id]
   ,[mongo_id]
   ,[fbacc_id]
   ,[shop_url]
   ,[access_token]
   ,[is_syncing]
   ,[last_prod_sync_date]
   ,[do_crop]
   ,[date_created]
   ,[date_updated]
   ,[date_deleted]
   ,[domain]
   ,[currency]
   ,[shop_name]
   ,[img_position]
   ,CASE
		WHEN ISNULL([is_available], 1) = 1 AND
			date_deleted IS NULL THEN 1
		ELSE 0
	END AS is_available
FROM [dbo].[user]
WHERE mongo_id = @userMongoId