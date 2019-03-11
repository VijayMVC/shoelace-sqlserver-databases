
CREATE PROCEDURE [dbo].[get_caching_process_by_user]
		@mongo_id varchar(50)
				

As
-- =============================================
-- Author:      <Ali Qaryan>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================

SELECT 
	shopifyCachingProcess.[id]
   ,[user_id]
   ,[user].[mongo_id] AS user_mongo_id
   ,[last_cached_shopify_entity_id]
   ,[last_update_start_date]
   ,[last_cached_page]
   ,[cached_entity_count]
   ,[runtime]
   ,[status]
   ,[http_status]
   ,[dev_notes]
   ,[shopify_updated_at_min]
   ,[shopify_updated_at_max]
   ,[shopify_partial_updated_at_min]
   ,[shopify_partial_updated_at_max]
   ,[previous_updated_date]
   ,[is_updated_min_max_equal]
   ,[message_sequence_number]
   ,row_date_modified
FROM [dbo].[shopifyCachingProcess]
LEFT JOIN [user] ON shopifyCachingProcess.[user_id] = [user].id
WHERE [mongo_id] = @mongo_id
