
CREATE PROCEDURE [dbo].[SP_Reset_Shopify_Caching_Info_To_Last_Time]
@userMongoIds user_mongo_ids READONLY,
@hoursAgo int NULL = 12

AS



UPDATE dbo.shopifyCachingProcess
SET last_update_start_date =
	CASE
		WHEN last_update_start_date IS NOT NULL THEN DATEADD(HOUR, -@hoursAgo, last_update_start_date)
		ELSE last_update_start_date
	END
   ,shopify_partial_updated_at_min = NULL
   ,shopify_partial_updated_at_max = NULL
   ,shopify_updated_at_max = NULL
   ,shopify_updated_at_min = NULL
WHERE dbo.shopifyCachingProcess.[user_id] IN (SELECT
		u.id
	FROM @userMongoIds AS input
	LEFT JOIN [user] u
		ON u.mongo_id = input.mongo_id)