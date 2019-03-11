CREATE TABLE [dbo].[order] (
    [id]                          BIGINT          IDENTITY (1, 1) NOT NULL,
    [user_id]                     BIGINT          NOT NULL,
    [shopify_id]                  BIGINT          NOT NULL,
    [order_number]                BIGINT          NOT NULL,
    [total_price_usd]             DECIMAL (18, 2) NULL,
    [discount_codes]              NVARCHAR (1000) NULL,
    [financial_status]            NVARCHAR (1000) NULL,
    [landing_site]                NVARCHAR (4000) NULL,
    [referring_site]              NVARCHAR (4000) NULL,
    [user_agent]                  NVARCHAR (1000) NULL,
    [email]                       NVARCHAR (1000) NULL,
    [source_name]                 NVARCHAR (1000) NULL,
    [created_at]                  DATETIME2 (7)   NULL,
    [cancelled_at]                DATETIME2 (7)   NULL,
    [buyer_accepts_marketing]     BIT             NULL,
    [fulfillment_status]          NVARCHAR (16)   NULL,
    [currency]                    NVARCHAR (3)    NULL,
    [last_fulfillment_updated_at] DATETIME2 (7)   NULL,
    [customer_accepts_marketing]  BIT             NULL,
    [total_price]                 DECIMAL (18, 2) NULL,
    [subtotal_price]              DECIMAL (18, 2) NULL,
    [customer_id]                 BIGINT          NULL,
    [customer_email]              NVARCHAR (1000) NULL,
    [customer_order_count]        INT             NULL,
    [date_updated]                DATETIME2 (7)   NULL,
    [row_date_created]            DATETIME2 (7)   NULL,
    [row_date_modified]           DATETIME2 (7)   NULL,
    CONSTRAINT [PK_order] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_order_user] FOREIGN KEY ([user_id]) REFERENCES [dbo].[user] ([id]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_order_userId]
    ON [dbo].[order]([user_id] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_order_shopifyId]
    ON [dbo].[order]([shopify_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_order_createdAt]
    ON [dbo].[order]([created_at] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_order_financial_status]
    ON [dbo].[order]([financial_status] ASC);

