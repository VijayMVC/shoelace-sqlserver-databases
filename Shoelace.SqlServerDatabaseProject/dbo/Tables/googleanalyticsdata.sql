CREATE TABLE [dbo].[googleanalyticsdata] (
    [id]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [mongo_id]       NVARCHAR (30)  NOT NULL,
    [google_view_id] NVARCHAR (30)  NOT NULL,
    [event_name]     NVARCHAR (128) NULL,
    [event_value]    BIGINT         NULL,
    [event_date]     DATE           NULL,
    CONSTRAINT [PK__googleanalyticsdata] PRIMARY KEY CLUSTERED ([id] ASC) WITH (STATISTICS_NORECOMPUTE = ON),
    CONSTRAINT [sync_once_per_day] UNIQUE NONCLUSTERED ([event_date] ASC, [event_name] ASC, [google_view_id] ASC, [mongo_id] ASC) WITH (STATISTICS_NORECOMPUTE = ON)
);


GO
CREATE NONCLUSTERED INDEX [IX_googleanalyticsdata_googleViewId_mongoId_date]
    ON [dbo].[googleanalyticsdata]([google_view_id] ASC, [mongo_id] ASC, [event_date] ASC)
    INCLUDE([event_value]);


GO
CREATE NONCLUSTERED INDEX [IX_googleanalyticsdata_mongoId]
    ON [dbo].[googleanalyticsdata]([mongo_id] ASC)
    INCLUDE([event_value]);

