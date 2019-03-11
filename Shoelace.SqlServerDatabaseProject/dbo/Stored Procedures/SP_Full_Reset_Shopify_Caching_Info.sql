
CREATE PROCEDURE [dbo].[SP_Full_Reset_Shopify_Caching_Info]
@userMongoIds user_mongo_ids READONLY

AS

UPDATE dbo.shopifyCachingProcess
SET last_cached_shopify_entity_id = NULL
   ,last_update_start_date = NULL
   ,last_cached_page = NULL
   ,shopifyCachingProcess.[status] = NULL
   ,cached_entity_count = NULL
   ,shopify_partial_updated_at_min = NULL
   ,shopify_partial_updated_at_max = NULL
   ,shopify_updated_at_min = NULL
   ,shopify_updated_at_max = NULL
WHERE dbo.shopifyCachingProcess.[user_id] IN (SELECT
		u.id
	FROM @userMongoIds AS input
	LEFT JOIN [user] u
		ON u.mongo_id = input.mongo_id)