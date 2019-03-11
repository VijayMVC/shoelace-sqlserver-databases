CREATE TYPE [dbo].[productcollection_upsert] AS TABLE (
    [shopify_id]            BIGINT NOT NULL,
    [shopify_collection_id] BIGINT NOT NULL,
    [shopify_product_id]    BIGINT NOT NULL);

