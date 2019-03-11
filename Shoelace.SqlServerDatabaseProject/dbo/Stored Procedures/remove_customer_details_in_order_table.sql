CREATE PROCEDURE [dbo].[remove_customer_details_in_order_table]
@mongoUserId [varchar](50)

AS

UPDATE "order"
SET "order".customer_id = null,
"order".customer_email =null,
"order".landing_site = null,
"order".referring_site = null,
"order".user_agent = null,
"order".email = null,
"order".customer_accepts_marketing = null,
"order".customer_order_count = null
WHERE "order".user_id = (SELECT id FROM [dbo].[user] WHERE [dbo].[user].[mongo_id] = @mongoUserId);