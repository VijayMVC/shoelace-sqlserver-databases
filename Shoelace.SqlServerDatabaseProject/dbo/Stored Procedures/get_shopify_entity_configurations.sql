
CREATE PROCEDURE [dbo].[get_shopify_entity_configurations]
AS
-- =============================================
-- Author:      <Ali Qaryan>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================

SELECT
	[id]
   ,[entity_name]
   ,[entity_list_uri]
   ,[entity_count_uri]
   ,[entity_single_uri]
   ,[fetch_order]
FROM [dbo].[shopifyEntityConfigurations]