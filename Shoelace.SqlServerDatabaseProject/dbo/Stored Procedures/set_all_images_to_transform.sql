CREATE PROCEDURE [dbo].[set_all_images_to_transform]
@userMongoId NVARCHAR(50),
@shouldCrop BIT

AS

DECLARE @userId BIGINT;

SELECT @userId = [id]
    FROM [user]
    WHERE mongo_id = @userMongoId

UPDATE 
    [dbo].[product]
SET
    [product].[s3_img_url] = NULL,
    [product].[should_transform] = @shouldCrop
WHERE
    [product].[user_id] = @userId