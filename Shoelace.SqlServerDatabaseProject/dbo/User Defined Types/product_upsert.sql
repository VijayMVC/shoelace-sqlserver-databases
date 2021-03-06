﻿CREATE TYPE [dbo].[product_upsert] AS TABLE (
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
    [published_at]        NVARCHAR (32)   NULL,
    [availability]        NVARCHAR (12)   NOT NULL,
    [has_multiple_prices] BIT             NULL,
    [should_transform]    BIT             NOT NULL,
    [date_created]        NVARCHAR (32)   NOT NULL,
    [date_updated]        NVARCHAR (32)   NULL,
    [date_deleted]        NVARCHAR (32)   NULL,
    [exclude_from_ads]    BIT             DEFAULT ((0)) NULL);

