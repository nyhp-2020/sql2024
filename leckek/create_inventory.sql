USE [MyDB]
GO

/****** Object:  Table [dbo].[Inventory]    Script Date: 2024. 11. 21. 15:47:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Inventory](
	[ID] [int] NOT NULL,
	[Shelf] [nvarchar](10) NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductCount] [smallint] NOT NULL,
	[ProductLeft] [smallint] NOT NULL,
 CONSTRAINT [PK_Inventory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Inventory]  WITH CHECK ADD  CONSTRAINT [FK_Inventory_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO

ALTER TABLE [dbo].[Inventory] CHECK CONSTRAINT [FK_Inventory_Product]
GO

ALTER TABLE [dbo].[Inventory]  WITH CHECK ADD  CONSTRAINT [CK_ProductCount] CHECK  (([ProductCount]>(0)))
GO

ALTER TABLE [dbo].[Inventory] CHECK CONSTRAINT [CK_ProductCount]
GO

ALTER TABLE [dbo].[Inventory]  WITH CHECK ADD  CONSTRAINT [CK_ProductLeft] CHECK  (([ProductLeft]>=(0) AND [ProductLeft]<=[ProductCount]))
GO

ALTER TABLE [dbo].[Inventory] CHECK CONSTRAINT [CK_ProductLeft]
GO


