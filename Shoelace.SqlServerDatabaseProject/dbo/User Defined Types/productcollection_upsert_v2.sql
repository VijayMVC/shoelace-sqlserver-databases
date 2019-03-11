CREATE TYPE [dbo].[productcollection_upsert_v2] AS TABLE (
    [shopify_id]            BIGINT        NOT NULL,
    [shopify_collection_id] BIGINT        NOT NULL,
    [shopify_product_id]    BIGINT        NOT NULL,
    [date_updated]          NVARCHAR (32) NULL);

