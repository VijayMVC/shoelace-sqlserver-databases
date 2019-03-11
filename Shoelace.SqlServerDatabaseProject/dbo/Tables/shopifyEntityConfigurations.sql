CREATE TABLE [dbo].[shopifyEntityConfigurations] (
    [id]                TINYINT        IDENTITY (1, 1) NOT NULL,
    [entity_name]       VARCHAR (50)   NULL,
    [entity_list_uri]   NVARCHAR (100) NULL,
    [entity_count_uri]  NVARCHAR (100) NULL,
    [entity_single_uri] NVARCHAR (100) NULL,
    [fetch_order]       TINYINT        NULL,
    CONSTRAINT [PK_shopifyEntityConfigurations] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [EntityNameUnique_shopifyEntityConfigurations]
    ON [dbo].[shopifyEntityConfigurations]([entity_name] ASC);

