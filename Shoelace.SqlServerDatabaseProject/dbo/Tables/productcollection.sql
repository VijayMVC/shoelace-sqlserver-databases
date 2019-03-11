CREATE TABLE [dbo].[productcollection] (
    [id]                    BIGINT        IDENTITY (1, 1) NOT NULL,
    [shopify_id]            BIGINT        NOT NULL,
    [shopify_collection_id] BIGINT        NOT NULL,
    [shopify_product_id]    BIGINT        NOT NULL,
    [user_id]               BIGINT        NULL,
    [date_updated]          DATETIME2 (7) NULL,
    [row_date_created]      DATETIME2 (7) NULL,
    [row_date_modified]     DATETIME2 (7) NULL,
    CONSTRAINT [PK_productioncollection] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_productcollection_productcollection] FOREIGN KEY ([id]) REFERENCES [dbo].[productcollection] ([id]),
    CONSTRAINT [FK_productcollection_user] FOREIGN KEY ([user_id]) REFERENCES [dbo].[user] ([id]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_productcollection_product_collection_ids]
    ON [dbo].[productcollection]([shopify_collection_id] ASC, [shopify_product_id] ASC, [shopify_id] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_productcollection_product_collection_ids_for_user]
    ON [dbo].[productcollection]([user_id] ASC, [shopify_collection_id] ASC, [shopify_product_id] ASC);

