CREATE TABLE [dbo].[collection] (
    [id]                BIGINT          IDENTITY (1, 1) NOT NULL,
    [user_id]           BIGINT          NOT NULL,
    [shopify_id]        BIGINT          NOT NULL,
    [title]             NVARCHAR (1000) NULL,
    [handle]            NVARCHAR (1000) NULL,
    [type]              NVARCHAR (1000) NULL,
    [date_updated]      DATETIME2 (7)   NULL,
    [row_date_created]  DATETIME2 (7)   NULL,
    [row_date_modified] DATETIME2 (7)   NULL,
    CONSTRAINT [PK_collection] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_collection_user] FOREIGN KEY ([user_id]) REFERENCES [dbo].[user] ([id]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_collection_shopifyId]
    ON [dbo].[collection]([shopify_id] ASC);

