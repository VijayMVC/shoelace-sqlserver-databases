CREATE TABLE [dbo].[lineitem] (
    [id]                    BIGINT          IDENTITY (1, 1) NOT NULL,
    [order_id]              BIGINT          NOT NULL,
    [shopify_id]            BIGINT          NOT NULL,
    [shopify_product_id]    BIGINT          NULL,
    [shopify_variant_id]    BIGINT          NULL,
    [shopify_product_title] NVARCHAR (1000) NULL,
    [quantity]              BIGINT          NULL,
    [price]                 DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_lineitem] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_lineitem_order] FOREIGN KEY ([order_id]) REFERENCES [dbo].[order] ([id]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_lineitem_shopifyProductId]
    ON [dbo].[lineitem]([shopify_product_id] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_lineitem_shopifyId]
    ON [dbo].[lineitem]([shopify_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_lineitem_orderId]
    ON [dbo].[lineitem]([order_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_LineItem_OrderId_ShopifyProductId]
    ON [dbo].[lineitem]([order_id] ASC, [shopify_product_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_lineitem_order_id_quantity]
    ON [dbo].[lineitem]([order_id] ASC, [quantity] ASC);


GO
CREATE NONCLUSTERED INDEX [nci_wi_lineitem_ED68C53282657033FDB70F6146BD6F6F]
    ON [dbo].[lineitem]([order_id] ASC)
    INCLUDE([quantity], [shopify_product_id]);

