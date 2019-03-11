CREATE TABLE [dbo].[product] (
    [id]                  BIGINT          IDENTITY (1, 1) NOT NULL,
    [user_id]             BIGINT          NOT NULL,
    [shopify_id]          BIGINT          NOT NULL,
    [img_id]              BIGINT          NULL,
    [img_url]             NVARCHAR (1000) NULL,
    [s3_img_url]          NVARCHAR (1000) NULL,
    [price]               DECIMAL (18, 2) NULL,
    [currency]            NVARCHAR (1000) NULL,
    [title]               NVARCHAR (1000) NULL,
    [description]         NVARCHAR (4000) NULL,
    [tags]                NVARCHAR (MAX)  NULL,
    [brand]               NVARCHAR (1000) NULL,
    [shopify_link]        NVARCHAR (1000) NULL,
    [published_at]        DATETIME2 (7)   NULL,
    [availability]        VARCHAR (12)    NOT NULL,
    [has_multiple_prices] BIT             NULL,
    [should_transform]    BIT             CONSTRAINT [DF_product_should_transform] DEFAULT ((0)) NOT NULL,
    [date_created]        DATETIME2 (7)   NOT NULL,
    [date_updated]        DATETIME2 (7)   NULL,
    [date_deleted]        DATETIME2 (7)   NULL,
    [exclude_from_ads]    BIT             DEFAULT ((0)) NULL,
    [row_date_created]    DATETIME2 (7)   NULL,
    [row_date_modified]   DATETIME2 (7)   NULL,
    [secondary_img_id]    BIGINT          NULL,
    [secondary_img_url]   NVARCHAR (1000) NULL,
    [compare_at_price]    DECIMAL (18, 2) NULL,
    [gender]              NVARCHAR (1000) NULL,
    CONSTRAINT [PK_product] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_product_user] FOREIGN KEY ([user_id]) REFERENCES [dbo].[user] ([id]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_product_userId]
    ON [dbo].[product]([user_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_product_shouldTransform]
    ON [dbo].[product]([should_transform] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_product_shopifyId]
    ON [dbo].[product]([shopify_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Product_ShopifyId_Deleted_Availability]
    ON [dbo].[product]([shopify_id] ASC, [date_deleted] ASC, [availability] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_product_availability]
    ON [dbo].[product]([availability] ASC);

