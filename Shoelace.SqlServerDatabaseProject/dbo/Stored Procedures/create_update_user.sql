
CREATE PROCEDURE [dbo].[create_update_user]
		@mongo_id varchar(50),
		@fbacc_id  nvarchar(500) = NULL,
		@shop_url   nvarchar(500),
		@access_token   nvarchar(500) NULL,
		@is_syncing   bit = NULL,
		@last_prod_sync_date  datetime2(7) = NULL,
		@do_crop  bit = true,
		@date_deleted  datetime2(7) = NULL,
		@domain  nvarchar(1000) = NULL,
		@currency  varchar(10) =NULL,
		@shop_name  nvarchar(500) = NULL,
		@img_position tinyint = NULL,
		@is_available bit = NULL,
		@industry NVARCHAR(256) = NULL
As
---- =============================================
---- Author:      <Ali Qaryan>
---- Create Date: <Create Date, , >
---- Description: <Description, , >
---- =============================================

Begin

----Begin test script

----End test script


IF EXISTS (SELECT
		id
	FROM [user]
	WHERE [mongo_id] = @mongo_id)

UPDATE [dbo].[user]
	SET [fbacc_id] = ISNULL(@fbacc_id, fbacc_id)
	   ,[shop_url] = ISNULL(@shop_url, shop_url)
	   ,[access_token] = ISNULL(@access_token, access_token)
	   ,[is_syncing] = ISNULL(@is_syncing, is_syncing)
	   ,[last_prod_sync_date] = ISNULL(@last_prod_sync_date, last_prod_sync_date)
	   ,[do_crop] = ISNULL(@do_crop, 1)
	   ,[date_updated] = GETUTCDATE()
	   ,[date_deleted] = ISNULL(@date_deleted, date_deleted)
	   ,[domain] = ISNULL(@domain, domain)
	   ,[currency] = ISNULL(@currency, currency)
	   ,[shop_name] = ISNULL(@shop_name, shop_name)
	   ,[img_position] = ISNULL(@img_position, img_position)
	   ,[industry] = ISNULL(@industry, industry)
	WHERE mongo_id = @mongo_id

ELSE

INSERT INTO [dbo].[user]
           ([mongo_id]
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
		   ,[industry])
     VALUES
          ( @mongo_id
           ,@fbacc_id
           ,@shop_url
           ,@access_token
           ,@is_syncing
           ,@last_prod_sync_date
           ,ISNULL(@do_crop, 1)
           ,GETUTCDATE()
           ,GETUTCDATE()
           ,NULL
           ,@domain
           ,@currency
           ,@shop_name
           ,@img_position
		   ,@industry)
End


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
   ,ISNULL([is_available],1) AS [is_available]
   ,[industry]
FROM [dbo].[user]
WHERE mongo_id = @mongo_id