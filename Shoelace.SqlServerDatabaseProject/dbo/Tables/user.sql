CREATE TABLE [dbo].[user] (
    [id]                  BIGINT          IDENTITY (1, 1) NOT NULL,
    [mongo_id]            VARCHAR (50)    NOT NULL,
    [fbacc_id]            NVARCHAR (500)  NULL,
    [shop_url]            NVARCHAR (500)  NOT NULL,
    [access_token]        NVARCHAR (500)  NULL,
    [is_syncing]          BIT             NULL,
    [last_prod_sync_date] DATETIME2 (7)   NULL,
    [do_crop]             BIT             NOT NULL,
    [date_created]        DATETIME2 (7)   NOT NULL,
    [date_updated]        DATETIME2 (7)   NULL,
    [date_deleted]        DATETIME2 (7)   NULL,
    [domain]              NVARCHAR (1000) NULL,
    [currency]            VARCHAR (10)    NULL,
    [shop_name]           NVARCHAR (500)  NULL,
    [img_position]        TINYINT         CONSTRAINT [DF_user_img_position] DEFAULT ((0)) NULL,
    [is_available]        BIT             NULL,
    [industry]            NVARCHAR (256)  NULL,
    CONSTRAINT [PK_user] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_user_mongoId]
    ON [dbo].[user]([mongo_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_user_isSyncing]
    ON [dbo].[user]([is_syncing] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_user_lastProdSyncDate]
    ON [dbo].[user]([last_prod_sync_date] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_user_shopUrl]
    ON [dbo].[user]([shop_url] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_user_fbacc_id]
    ON [dbo].[user]([fbacc_id] ASC);

