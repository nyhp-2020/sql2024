USE [MyDB]
GO

/****** Object:  Table [dbo].[Product]    Script Date: 2024. 11. 21. 15:47:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Product](
	[ProductID] [int] NOT NULL,
	[ProductName] [nvarchar](100) NOT NULL,
	[ListPrice] [decimal](10, 4) NOT NULL,
	[Color] [nvarchar](10) NULL,
	[Size] [decimal](8, 2) NULL,
	[CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [CK_ListPrice] CHECK  (([ListPrice]>(0)))
GO

ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [CK_ListPrice]
GO


