CREATE TABLE [dbo].[shopifyCachingProcess] (
    [id]                             BIGINT         IDENTITY (1, 1) NOT NULL,
    [user_id]                        BIGINT         NOT NULL,
    [last_cached_shopify_entity_id]  TINYINT        NULL,
    [last_update_start_date]         DATETIME2 (7)  NULL,
    [last_cached_page]               BIGINT         NULL,
    [cached_entity_count]            BIGINT         NULL,
    [runtime]                        DECIMAL (18)   NULL,
    [status]                         VARCHAR (50)   NULL,
    [http_status]                    VARCHAR (50)   NULL,
    [dev_notes]                      NVARCHAR (MAX) NULL,
    [shopify_partial_updated_at_min] DATETIME2 (7)  NULL,
    [shopify_partial_updated_at_max] DATETIME2 (7)  NULL,
    [shopify_updated_at_min]         DATETIME2 (7)  NULL,
    [shopify_updated_at_max]         DATETIME2 (7)  NULL,
    [previous_updated_date]          DATETIME2 (7)  NULL,
    [is_updated_min_max_equal]       BIT            NULL,
    [message_sequence_number]        BIGINT         NULL,
    [row_date_created]               DATETIME2 (7)  NULL,
    [row_date_modified]              DATETIME2 (7)  NULL,
    CONSTRAINT [PK_shopifyCachingProcess] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [nci_wi_shopifyCachingProcess_user_id_dependencies]
    ON [dbo].[shopifyCachingProcess]([user_id] ASC)
    INCLUDE([cached_entity_count], [dev_notes], [http_status], [is_updated_min_max_equal], [last_cached_page], [last_cached_shopify_entity_id], [last_update_start_date], [message_sequence_number], [previous_updated_date], [row_date_modified], [runtime], [shopify_partial_updated_at_max], [shopify_partial_updated_at_min], [shopify_updated_at_max], [shopify_updated_at_min], [status]);

