
CREATE PROCEDURE [dbo].[sp_product_image_transformation_update] 
@updateRecords product_image_transformation_upsert READONLY 
AS 

UPDATE
    [product]
SET
    [product].s3_img_url = updatedProducts.s3_img_url,
    [product].should_transform = updatedProducts.should_transform
FROM
    [product]
    INNER JOIN @updateRecords AS updatedProducts
        ON [product].id = updatedProducts.id