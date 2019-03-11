
CREATE PROCEDURE [dbo].[insert_shopify_caching_history]
		@shopify_entity_id tinyint,
		@shopify_caching_id bigint,
		@user_id bigint,
		@shopify_updated_at_min datetime2(7) =NULL,
		@shopify_updated_at_max datetime2(7) =NULL,
		@message_sequence_number bigint =NULL,
		@last_cached_page bigint = NULL,
		@cached_item_count bigint =NULL,
		@runtime decimal(18,0) NULL,
		@status varchar(50) =NULL
		

As
---- =============================================
---- Author:      <Ali Qaryan>
---- Create Date: <Create Date, , >
---- Description: <Description, , >
---- =============================================

Begin

----Begin test script
----End test script


INSERT INTO [dbo].[shopifyCachingHistory]
           ([shopify_entity_id]
           ,[shopify_caching_id]
           ,[user_id]
           ,[shopify_updated_at_min]
           ,[shopify_updated_at_max]
           ,[message_sequence_number]
           ,[last_cached_page]
           ,[cached_item_count]
           ,[runtime]
           ,[status]
		   ,[row_date_created]
		   ,[row_date_modified])
     VALUES
           (@shopify_entity_id,
		   @shopify_caching_id,
		   @user_id,
		   @shopify_updated_at_min,
		   @shopify_updated_at_max,
		   @message_sequence_number,
		   @last_cached_page,
		   @cached_item_count,
		   @runtime,
		   @status,
		   GETUTCDATE(),
		   GETUTCDATE())

SELECT SCOPE_IDENTITY();

END