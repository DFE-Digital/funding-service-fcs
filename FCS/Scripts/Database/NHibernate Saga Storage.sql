/****** Object:  Table [dbo].[BulkUploadSagaData]    Script Date: 27/04/2015 20:55:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BulkUploadSagaData](
	[Id] [uniqueidentifier] NOT NULL,
	[Originator] [nvarchar](255) NULL,
	[OriginalMessageId] [nvarchar](255) NULL,
	[BatchId] [nvarchar](255) NULL,
	[FileName] [nvarchar](255) NULL,
	[NumItemsToProcess] [int] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
UNIQUE NONCLUSTERED 
(
	[BatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO



/****** Object:  Table [dbo].[ContractRequestResults]    Script Date: 27/04/2015 20:55:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ContractRequestResults](
	[BulkUploadSagaData_id] [uniqueidentifier] NOT NULL,
	[SerializedContractRequestResult] [varbinary](max) NULL
)

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ContractRequestResults]  WITH CHECK ADD  CONSTRAINT [FK7690B7DD1E50987E] FOREIGN KEY([BulkUploadSagaData_id])
REFERENCES [dbo].[BulkUploadSagaData] ([Id])
GO

ALTER TABLE [dbo].[ContractRequestResults] CHECK CONSTRAINT [FK7690B7DD1E50987E]
GO

/****** Object:  Table [dbo].[ContractRequests]    Script Date: 27/04/2015 20:55:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ContractRequests](
	[BulkUploadSagaData_id] [uniqueidentifier] NOT NULL,
	[SerializedContractRequest] [varbinary](max) NULL
)

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ContractRequests]  WITH CHECK ADD  CONSTRAINT [FK9E5269721E50987E] FOREIGN KEY([BulkUploadSagaData_id])
REFERENCES [dbo].[BulkUploadSagaData] ([Id])
GO

ALTER TABLE [dbo].[ContractRequests] CHECK CONSTRAINT [FK9E5269721E50987E]
GO

/****** Object:  Table [dbo].[FileWatcherTaskSagaData]    Script Date: 27/04/2015 20:56:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FileWatcherTaskSagaData](
	[Id] [uniqueidentifier] NOT NULL,
	[Originator] [nvarchar](255) NULL,
	[OriginalMessageId] [nvarchar](255) NULL,
	[TaskName] [nvarchar](255) NULL,
	[SagaRunning] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
UNIQUE NONCLUSTERED 
(
	[TaskName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO

/****** Object:  Table [dbo].[LocationMapping]    Script Date: 27/04/2015 20:56:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LocationMapping](
	[BulkUploadSagaData_id] [uniqueidentifier] NOT NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[Sheet] [nvarchar](255) NULL,
	[Row] [int] NULL,
	[ParentId] [nvarchar](255) NULL,
	[ContractRequestId] [nvarchar](255) NULL
)

GO

ALTER TABLE [dbo].[LocationMapping]  WITH CHECK ADD  CONSTRAINT [FKED06E2E11E50987E] FOREIGN KEY([BulkUploadSagaData_id])
REFERENCES [dbo].[BulkUploadSagaData] ([Id])
GO

ALTER TABLE [dbo].[LocationMapping] CHECK CONSTRAINT [FKED06E2E11E50987E]
GO

/****** Object:  Table [dbo].[NewContractSagaData]    Script Date: 27/04/2015 20:56:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[NewContractSagaData](
	[Id] [uniqueidentifier] NOT NULL,
	[Originator] [nvarchar](255) NULL,
	[OriginalMessageId] [nvarchar](255) NULL,
	[ProcessId] [nvarchar](255) NULL,
	[ContractRequestContract] [varbinary](max) NULL,
	[IsTimeoutAlreadyScheduled] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
UNIQUE NONCLUSTERED 
(
	[ProcessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO

SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[UpdateDraftContractSagaData]    Script Date: 27/04/2015 20:56:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[UpdateDraftContractSagaData](
	[Id] [uniqueidentifier] NOT NULL,
	[Originator] [nvarchar](255) NULL,
	[OriginalMessageId] [nvarchar](255) NULL,
	[ProcessId] [nvarchar](255) NULL,
	[ContractRequestContract] [varbinary](max) NULL,
	[CorporateContract] [varbinary](max) NULL,
	[BatchId] [nvarchar](255) NULL,
	[StatusInt] [int] NULL,
	[IsTimeoutAlreadyScheduled] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
UNIQUE NONCLUSTERED 
(
	[ProcessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO

SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[UpdateOrganisationSagaData]    Script Date: 27/04/2015 20:56:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UpdateOrganisationSagaData](
	[Id] [uniqueidentifier] NOT NULL,
	[Originator] [nvarchar](255) NULL,
	[OriginalMessageId] [nvarchar](255) NULL,
	[ProcessId] [nvarchar](255) NULL,
	[IsTimeoutAlreadyScheduled] [bit] NULL,
	[State] [int] NULL,
	[Organisations] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
UNIQUE NONCLUSTERED 
(
	[ProcessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO

