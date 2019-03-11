CREATE TYPE [dbo].[lineitem_upsert] AS TABLE (
    [order_id]              BIGINT          NOT NULL,
    [shopify_id]            BIGINT          NOT NULL,
    [shopify_product_id]    BIGINT          NULL,
    [shopify_variant_id]    BIGINT          NULL,
    [shopify_product_title] NVARCHAR (1000) NULL,
    [quantity]              BIGINT          NULL,
    [price]                 DECIMAL (18, 2) NULL);

