CREATE TABLE [dbo].[shopifyCachingHistory] (
    [id]                      BIGINT        IDENTITY (1, 1) NOT NULL,
    [shopify_entity_id]       TINYINT       NULL,
    [shopify_caching_id]      BIGINT        NULL,
    [user_id]                 BIGINT        NULL,
    [shopify_updated_at_min]  DATETIME2 (7) NULL,
    [shopify_updated_at_max]  DATETIME2 (7) NULL,
    [message_sequence_number] BIGINT        NULL,
    [last_cached_page]        BIGINT        NULL,
    [upserted_items_count]    BIGINT        NULL,
    [cached_item_count]       BIGINT        NULL,
    [runtime]                 DECIMAL (18)  NULL,
    [status]                  VARCHAR (50)  NULL,
    [http_status]             VARCHAR (50)  NULL,
    [fulfillmentLog]          BIT           NULL,
    [row_date_created]        DATETIME2 (7) NULL,
    [row_date_modified]       DATETIME2 (7) NULL,
    CONSTRAINT [PK_shopify_caching_history] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_shopifyCachingHistory_shopifyCachingProcess] FOREIGN KEY ([shopify_caching_id]) REFERENCES [dbo].[shopifyCachingProcess] ([id]) ON DELETE CASCADE
);

