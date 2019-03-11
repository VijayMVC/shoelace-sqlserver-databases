CREATE TYPE [dbo].[collection_upsert_v2] AS TABLE (
    [shopify_id]   BIGINT          NOT NULL,
    [title]        NVARCHAR (1000) NULL,
    [handle]       NVARCHAR (1000) NULL,
    [type]         NVARCHAR (1000) NULL,
    [date_updated] NVARCHAR (32)   NULL);

