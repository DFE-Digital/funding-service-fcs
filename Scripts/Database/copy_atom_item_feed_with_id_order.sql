CREATE TABLE [ContractManagement].[AtomFeedItem_Copy](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Identifier] [uniqueidentifier] NOT NULL,
	[ItemType] [int] NOT NULL,
	[BusinessKey] [nvarchar](100) NULL,
	[AtomFeedItemXml] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ContractManagement.AtomFeedItem_Copy] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

insert into [ContractManagement].[AtomFeedItem_Copy]
select
[Identifier],
[ItemType],
[BusinessKey],
[AtomFeedItemXml],
[CreatedDate]
 from 
[ContractManagement].[AtomFeedItem]
order by [CreatedDate] asc

ALTER TABLE [ContractManagement].[AtomFeedItem_Copy]
DROP CONSTRAINT [PK_ContractManagement.AtomFeedItem_Copy];

drop table [ContractManagement].[AtomFeedItem];

ALTER TABLE [ContractManagement].[AtomFeedItem_Copy]
ADD CONSTRAINT [PK_ContractManagement.AtomFeedItem] PRIMARY KEY CLUSTERED (Id);

exec sp_rename '[ContractManagement].[AtomFeedItem_Copy]', 'AtomFeedItem';

CREATE NONCLUSTERED INDEX [IX_AtomFeedItem_ItemType] ON [ContractManagement].[AtomFeedItem]
(
	[ItemType] ASC
);

ALTER TABLE [ContractManagement].[AtomFeedItem] ADD  CONSTRAINT [DF_ContractManagement.AtomFeedItem_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate];

CREATE UNIQUE NONCLUSTERED INDEX [IX_AtomFeedItem_ItemTypeBusinessKey] ON [ContractManagement].[AtomFeedItem]
(
	[ItemType] ASC,
	[BusinessKey] ASC
);