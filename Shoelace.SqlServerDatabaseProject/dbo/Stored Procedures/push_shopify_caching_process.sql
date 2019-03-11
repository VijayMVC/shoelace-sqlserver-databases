
CREATE PROCEDURE [dbo].[push_shopify_caching_process]
		@user_id bigint,
		@mongo_id varchar(50),
		@last_cached_shopify_entity_id tinyInt,
		@last_update_start_date datetime2(7) = NULL,
		@last_cached_page bigint = NULL,
		@cached_entity_count bigint = NULL,
		@upserted_items_count bigint = NULL,
		@runtime decimal(18,0) = NULL,
		@status varchar(50) = NULL,
		@http_status varchar(50) = NULL,
		@dev_notes nvarchar(max) = NULL,
		@shopify_updated_at_min datetime2(7) = NULL,
		@shopify_updated_at_max datetime2(7) = NULL,
		@shopify_partial_updated_at_min datetime2(7) = NULL,
		@shopify_partial_updated_at_max datetime2(7) = NULL,
		@previous_updated_date nvarchar(max) = NULL,
		@is_updated_min_max_equal bit = NULL,
		@message_sequence_number bigint = NULL,
		@is_fulfillment_log bit = NULL

As
---- =============================================
---- Author:      <Ali Qaryan>
---- Create Date: <Create Date, , >
---- Description: <Description, , >
---- =============================================

Begin

----Begin test script
	--Declare	@user_id bigint
	--Declare	@last_cached_shopify_entity_id int
	--Declare	@last_update_start_date datetime 
	--Declare	@last_cached_page bigint 
	--Declare	@cached_entity_count bigint 
	--Declare	@runtime decimal(18,0) 
	--Declare	@status varchar(50) 
	--Declare	@dev_notes varchar(250) 
	--Declare @shopify_updated_at_min datetime2(7) = NULL
 --   Declare	@shopify_updated_at_max datetime2(7) = NULL

	--Set	@user_id  = 1003
	--Set	@last_cached_shopify_entity_id  = 1
	--Set	@last_update_start_date  = getDate()
	--Set	@last_cached_page  = 2
	--Set	@cached_entity_count  = 250
	--Set	@runtime  = 20
	--Set	@status  = 'pending'
	--Set	@dev_notes  = '{"Notes":"","ProductNotes":{"ShopifyEntityCount":0,"FetchedFromShopify":250,"UpsertedToDb":0,"CachingRuntime":1889.0,"CachingStarted":null,"Comments":"currently running"},"CollectNotes":{"ShopifyEntityCount":0,"FetchedFromShopify":0,"UpsertedToDb":0,"CachingRuntime":0.0,"CachingStarted":null,"Comments":null},"OrderNotes":{"ShopifyEntityCount":0,"FetchedFromShopify":0,"UpsertedToDb":0,"CachingRuntime":0.0,"CachingStarted":null,"Comments":null},"CustomCollectionNotes":{"ShopifyEntityCount":0,"FetchedFromShopify":0,"UpsertedToDb":0,"CachingRuntime":0.0,"CachingStarted":null,"Comments":null},"SmartCollectionNotes":{"ShopifyEntityCount":0,"FetchedFromShopify":0,"UpsertedToDb":0,"CachingRuntime":0.0,"CachingStarted":null,"Comments":null}}'

----End test script

IF EXISTS (SELECT id  FROM   shopifyCachingProcess WHERE  [user_id] = @user_id)

BEGIN
UPDATE [dbo].[shopifyCachingProcess]
		SET [last_cached_shopify_entity_id] = ISNULL(@last_cached_shopify_entity_id, last_cached_shopify_entity_id) 
		   ,[last_update_start_date] = ISNULL(@last_update_start_date, last_update_start_date)
		   ,[last_cached_page] = @last_cached_page
		   ,[cached_entity_count] = ISNULL(@cached_entity_count, cached_entity_count)
		   ,[runtime] = ISNULL(@runtime, runtime)
		   ,[status] = CASE	WHEN @status LIKE 'None' THEN NULL ELSE ISNULL(@status,status) END
		   ,[http_status] = @http_status
		   ,[dev_notes] = ISNULL(CONVERT(NVARCHAR(MAX), @dev_notes), dev_notes)
		   ,[shopify_updated_at_min] = @shopify_updated_at_min
		   ,[shopify_updated_at_max] = @shopify_updated_at_max
		   ,[shopify_partial_updated_at_min] = @shopify_partial_updated_at_min
		   ,[shopify_partial_updated_at_max] = @shopify_partial_updated_at_max
		   ,[previous_updated_date] = @previous_updated_date
		   ,[is_updated_min_max_equal] = @is_updated_min_max_equal
		   ,[row_date_modified] = GETUTCDATE()  
		WHERE [user_id] = @user_id		

END
ELSE

BEGIN
INSERT INTO [dbo].[shopifyCachingProcess]
           ([user_id]
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
		   ,[row_date_created]
		   ,[row_date_modified]
		    )
	VALUES (@user_id,
		    @last_cached_shopify_entity_id,
		    @last_update_start_date,
		    @last_cached_page,
		    @cached_entity_count,
		    @runtime,
		    @status,
			@http_status,
		    CONVERT(NVARCHAR(MAX), @dev_notes),
			@shopify_updated_at_min,
			@shopify_updated_at_max,
			@shopify_partial_updated_at_min,
			@shopify_partial_updated_at_max,
			@previous_updated_date,
			@is_updated_min_max_equal,
			GETUTCDATE(),
			GETUTCDATE()
			)
END

Declare @shopify_caching_id bigint;

SELECT @shopify_caching_id = id from shopifyCachingProcess WHERE user_id = @user_id

INSERT INTO [dbo].[shopifyCachingHistory]
           ([shopify_entity_id]
           ,[shopify_caching_id]
           ,[user_id]
           ,[shopify_updated_at_min]
           ,[shopify_updated_at_max]
		   ,[message_sequence_number]
           ,[last_cached_page]
           ,[cached_item_count]
		   ,[upserted_items_count]
           ,[runtime]
           ,[status]
		   ,[http_status]
		   ,[fulfillmentLog]
		   ,[row_date_created]
		   ,[row_date_modified])
     VALUES
           (@last_cached_shopify_entity_id,
		   @shopify_caching_id,
		   @user_id,
		   @shopify_partial_updated_at_min,
		   @shopify_partial_updated_at_max,
		   @message_sequence_number,
		   @last_cached_page,
		   @cached_entity_count,
		   @upserted_items_count,
		   @runtime,
		   @status,
		   @http_status,
		   @is_fulfillment_log,
		   GETUTCDATE(),
		   GETUTCDATE())

End

EXEC	[dbo].[get_caching_process_by_user]
		@mongo_id = @mongo_id