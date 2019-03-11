CREATE TABLE [dbo].[productcollectionHistory] (
    [id]                    BIGINT        IDENTITY (1, 1) NOT NULL,
    [shopify_id]            BIGINT        NOT NULL,
    [shopify_collection_id] BIGINT        NOT NULL,
    [shopify_product_id]    BIGINT        NOT NULL,
    [user_id]               BIGINT        NULL,
    [date_updated]          DATETIME2 (7) NULL,
    [row_date_created]      DATETIME2 (7) NULL,
    [row_date_modified]     DATETIME2 (7) NULL
);

