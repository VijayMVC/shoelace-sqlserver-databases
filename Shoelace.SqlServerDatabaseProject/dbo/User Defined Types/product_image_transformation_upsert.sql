CREATE TYPE [dbo].[product_image_transformation_upsert] AS TABLE (
    [id]               BIGINT          NOT NULL,
    [s3_img_url]       NVARCHAR (1000) NULL,
    [should_transform] BIT             NOT NULL);

