CREATE PROCEDURE [dbo].[order_deletion_by_order_number]
@orderNumbers shopify_order_numbers READONLY

AS

DELETE FROM "order" WHERE "order".order_number IN (SELECT order_number FROM @orderNumbers);