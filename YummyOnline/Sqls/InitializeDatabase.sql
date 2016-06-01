SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getDineId](@n INT) RETURNS nvarchar(MAX) AS 
BEGIN 
	DECLARE @nowDate NVARCHAR(6), @oldId NVARCHAR(max), @newId int
	SELECT @nowDate = CONVERT(NVARCHAR(6), CURRENT_TIMESTAMP, 12)
	SELECT @oldId = ISNULL(MAX(Id),0) FROM Dines WITH(XLOCK,PAGLOCK)
	if left(@oldId,6) = @nowDate
		set @newId = 1 + RIGHT(@oldId, @n)
	else
		set @newId = 1
	RETURN @nowDate + RIGHT(REPLICATE('0',@n) + CAST(@newId AS NVARCHAR(MAX)),@n) 
END


GO
/****** Object:  Table [dbo].[Areas]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Areas](
	[Id] [nvarchar](3) NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](128) NULL,
	[Usable] [bit] NOT NULL,
	[DepartmentReciptId] [int] NULL,
	[DepartmentServeId] [int] NULL,
 CONSTRAINT [PK_dbo.Areas] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customers]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[Id] [nvarchar](20) NOT NULL,
	[Points] [int] NOT NULL,
	[VipLevelId] [int] NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Departments]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Usable] [bit] NOT NULL,
	[PrinterId] [int] NULL,
 CONSTRAINT [PK_Departments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Desks]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Desks](
	[Id] [nvarchar](4) NOT NULL,
	[QrCode] [nvarchar](5) NULL,
	[Name] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](128) NULL,
	[Status] [int] NOT NULL,
	[Order] [int] NOT NULL,
	[HeadCount] [int] NOT NULL,
	[MinPrice] [decimal](11, 2) NOT NULL,
	[Usable] [bit] NOT NULL,
	[AreaId] [nvarchar](3) NOT NULL,
 CONSTRAINT [PK_Desks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DineMenuRemarks]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DineMenuRemarks](
	[DineMenu_Id] [int] NOT NULL,
	[Remark_Id] [int] NOT NULL,
 CONSTRAINT [PK_DineMenuRemarks] PRIMARY KEY CLUSTERED 
(
	[DineMenu_Id] ASC,
	[Remark_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DineMenus]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DineMenus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DineId] [nvarchar](14) NOT NULL,
	[MenuId] [nvarchar](6) NOT NULL,
	[Status] [int] NOT NULL,
	[Count] [int] NOT NULL,
	[OriPrice] [decimal](11, 2) NOT NULL,
	[Price] [decimal](11, 2) NOT NULL,
	[RemarkPrice] [decimal](11, 2) NOT NULL,
	[ReturnedWaiterId] [nvarchar](8) NULL,
 CONSTRAINT [PK_DineMenus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DinePaidDetails]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DinePaidDetails](
	[DineId] [nvarchar](14) NOT NULL,
	[PayKindId] [int] NOT NULL,
	[Price] [decimal](11, 2) NOT NULL,
	[RecordId] [nvarchar](max) NULL,
 CONSTRAINT [PK_DinePaidDetails] PRIMARY KEY CLUSTERED 
(
	[DineId] ASC,
	[PayKindId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DineRemarks]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DineRemarks](
	[Dine_Id] [nvarchar](14) NOT NULL,
	[Remark_Id] [int] NOT NULL,
 CONSTRAINT [PK_DineRemarks] PRIMARY KEY CLUSTERED 
(
	[Dine_Id] ASC,
	[Remark_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Dines]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dines](
	[Id] [nvarchar](14) NOT NULL,
	[Status] [int] NOT NULL,
	[Type] [int] NOT NULL,
	[HeadCount] [int] NOT NULL,
	[OriPrice] [decimal](11, 2) NOT NULL,
	[Price] [decimal](11, 2) NOT NULL,
	[Discount] [float] NOT NULL,
	[DiscountName] [nvarchar](50) NULL,
	[DiscountType] [int] NOT NULL,
	[IsPaid] [bit] NOT NULL,
	[IsInvoiced] [bit] NOT NULL,
	[Invoice] [nvarchar](20) NULL,
	[Footer] [nvarchar](20) NULL,
	[BeginTime] [datetime] NOT NULL,
	[IsOnline] [bit] NOT NULL,
	[ClerkId] [nvarchar](8) NULL,
	[WaiterId] [nvarchar](8) NULL,
	[UserId] [nvarchar](10) NULL,
	[DeskId] [nvarchar](4) NULL,
 CONSTRAINT [PK_Dines] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Index [IX_DateTime]    Script Date: 2016/6/1 9:42:22 ******/
CREATE CLUSTERED INDEX [IX_DateTime] ON [dbo].[Dines]
(
	[BeginTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HotelConfigs]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HotelConfigs](
	[Id] [int] NOT NULL,
	[NeedCodeImg] [bit] NOT NULL,
	[PointsRatio] [int] NOT NULL,
	[TrimZero] [int] NOT NULL,
	[HasAutoPrinter] [bit] NOT NULL,
 CONSTRAINT [PK_HotelConfigs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Logs]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Logs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Level] [int] NOT NULL,
	[Message] [nvarchar](max) NULL,
 CONSTRAINT [PK_Logs] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Index [IX_DateTime]    Script Date: 2016/6/1 9:42:22 ******/
CREATE CLUSTERED INDEX [IX_DateTime] ON [dbo].[Logs]
(
	[DateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuClasses]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuClasses](
	[Id] [nvarchar](6) NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[IsShow] [bit] NOT NULL,
	[Usable] [bit] NOT NULL,
	[IsLeaf] [bit] NOT NULL,
	[Level] [int] NULL,
	[ParentMenuClassId] [nvarchar](6) NULL,
 CONSTRAINT [PK_MenuClasses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MenuClassMenus]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuClassMenus](
	[MenuClass_Id] [nvarchar](6) NOT NULL,
	[Menu_Id] [nvarchar](6) NOT NULL,
 CONSTRAINT [PK_MenuClassMenus] PRIMARY KEY CLUSTERED 
(
	[MenuClass_Id] ASC,
	[Menu_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MenuOnSales]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuOnSales](
	[Id] [nvarchar](6) NOT NULL,
	[OnSaleWeek] [int] NOT NULL,
	[Price] [decimal](11, 2) NOT NULL,
 CONSTRAINT [PK_MenuOnSales] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[OnSaleWeek] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MenuPrices]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuPrices](
	[Id] [nvarchar](6) NOT NULL,
	[ExcludePayDiscount] [bit] NOT NULL,
	[Price] [decimal](11, 2) NOT NULL,
	[Discount] [float] NOT NULL,
	[Points] [int] NOT NULL,
 CONSTRAINT [PK_MenuPrices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MenuRemarks]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuRemarks](
	[Remark_Id] [int] NOT NULL,
	[Menu_Id] [nvarchar](6) NOT NULL,
 CONSTRAINT [PK_dbo.RemarkMenus] PRIMARY KEY CLUSTERED 
(
	[Remark_Id] ASC,
	[Menu_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Menus]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menus](
	[Id] [nvarchar](6) NOT NULL,
	[Status] [int] NOT NULL,
	[Code] [nvarchar](10) NULL,
	[Name] [nvarchar](30) NOT NULL,
	[NameAbbr] [nvarchar](15) NOT NULL,
	[PicturePath] [nvarchar](max) NULL,
	[IsFixed] [bit] NOT NULL,
	[SupplyDate] [int] NOT NULL,
	[Unit] [nvarchar](3) NULL,
	[MinOrderCount] [int] NOT NULL,
	[Ordered] [int] NOT NULL,
	[SourDegree] [int] NOT NULL,
	[SweetDegree] [int] NOT NULL,
	[SaltyDegree] [int] NOT NULL,
	[SpicyDegree] [int] NOT NULL,
	[Usable] [bit] NOT NULL,
	[IsSetMeal] [bit] NOT NULL,
	[DepartmentId] [int] NOT NULL,
 CONSTRAINT [PK_Menus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MenuSetMeals]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuSetMeals](
	[MenuSetId] [nvarchar](6) NOT NULL,
	[MenuId] [nvarchar](6) NOT NULL,
	[Count] [int] NOT NULL,
 CONSTRAINT [PK_MenuSetMeals] PRIMARY KEY CLUSTERED 
(
	[MenuSetId] ASC,
	[MenuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PayKinds]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayKinds](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[Type] [int] NOT NULL,
	[Description] [nvarchar](128) NULL,
	[Usable] [bit] NOT NULL,
	[Discount] [float] NOT NULL,
	[RedirectUrl] [nvarchar](128) NULL,
	[CompleteUrl] [nvarchar](128) NULL,
	[NotifyUrl] [nvarchar](128) NULL,
 CONSTRAINT [PK_PayKinds] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PrinterFormats]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrinterFormats](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Font] [nvarchar](10) NULL,
	[IsCenter] [bit] NOT NULL,
	[PaperSize] [int] NOT NULL,
 CONSTRAINT [PK_PrinterFormats] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Printers]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Printers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Usable] [bit] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[IpAddress] [nvarchar](15) NULL,
 CONSTRAINT [PK_Printers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Remarks]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Remarks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](10) NOT NULL,
	[Price] [decimal](11, 2) NOT NULL,
 CONSTRAINT [PK_Remarks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Reserves]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reserves](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PhoneNumber] [nvarchar](128) NULL,
	[HeadCount] [int] NOT NULL,
	[Time] [datetime] NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[DeskId] [nvarchar](4) NOT NULL,
 CONSTRAINT [PK_Reserves] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StaffRoles]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StaffRoles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_StaffRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StaffRoleSchemas]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StaffRoleSchemas](
	[StaffRoleId] [int] NOT NULL,
	[Schema] [int] NOT NULL,
 CONSTRAINT [PK_StaffRoleSchemas] PRIMARY KEY CLUSTERED 
(
	[StaffRoleId] ASC,
	[Schema] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Staffs]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staffs](
	[Id] [nvarchar](8) NOT NULL,
	[Name] [nvarchar](10) NULL,
	[DineCount] [int] NOT NULL,
	[DinePrice] [decimal](11, 2) NOT NULL,
	[WorkTimeFrom] [time](7) NOT NULL,
	[WorkTimeTo] [time](7) NOT NULL,
 CONSTRAINT [PK_Staffs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StaffStaffRoles]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StaffStaffRoles](
	[Staff_Id] [nvarchar](8) NOT NULL,
	[StaffRole_Id] [int] NOT NULL,
 CONSTRAINT [PK_StaffStaffRoles] PRIMARY KEY CLUSTERED 
(
	[Staff_Id] ASC,
	[StaffRole_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TakeOuts]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TakeOuts](
	[Id] [nvarchar](14) NOT NULL,
	[Address] [nvarchar](128) NULL,
	[PhoneNumber] [nvarchar](11) NULL,
 CONSTRAINT [PK_TakeOuts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TimeDiscounts]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimeDiscounts](
	[From] [time](7) NOT NULL,
	[To] [time](7) NOT NULL,
	[Week] [int] NOT NULL,
	[Discount] [float] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TimeDiscounts] PRIMARY KEY CLUSTERED 
(
	[From] ASC,
	[To] ASC,
	[Week] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[VipDiscounts]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VipDiscounts](
	[Id] [int] NOT NULL,
	[Discount] [float] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_VipDiscounts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[VipLevels]    Script Date: 2016/6/1 9:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VipLevels](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_VipLevels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Index [IX_DepartmentId]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_DepartmentId] ON [dbo].[Areas]
(
	[DepartmentReciptId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_VipLevelId]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_VipLevelId] ON [dbo].[Customers]
(
	[VipLevelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Departments]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_Departments] ON [dbo].[Departments]
(
	[PrinterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_AreaId]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_AreaId] ON [dbo].[Desks]
(
	[AreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DineMenuRemarks]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_DineMenuRemarks] ON [dbo].[DineMenuRemarks]
(
	[DineMenu_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Remark_Id]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_Remark_Id] ON [dbo].[DineMenuRemarks]
(
	[Remark_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_DineId]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_DineId] ON [dbo].[DineMenus]
(
	[DineId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MenuId]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_MenuId] ON [dbo].[DineMenus]
(
	[MenuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_DineId]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_DineId] ON [dbo].[DinePaidDetails]
(
	[DineId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayKindId]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_PayKindId] ON [dbo].[DinePaidDetails]
(
	[PayKindId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Dine_Id]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_Dine_Id] ON [dbo].[DineRemarks]
(
	[Dine_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Remark_Id]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_Remark_Id] ON [dbo].[DineRemarks]
(
	[Remark_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_DeskId]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_DeskId] ON [dbo].[Dines]
(
	[DeskId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ParentMenuClassId]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_ParentMenuClassId] ON [dbo].[MenuClasses]
(
	[ParentMenuClassId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Menu_Id]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_Menu_Id] ON [dbo].[MenuClassMenus]
(
	[Menu_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MenuClass_Id]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_MenuClass_Id] ON [dbo].[MenuClassMenus]
(
	[MenuClass_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Id]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_Id] ON [dbo].[MenuOnSales]
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Id]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_Id] ON [dbo].[MenuPrices]
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Menu_Id]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_Menu_Id] ON [dbo].[MenuRemarks]
(
	[Menu_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Remark_Id]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_Remark_Id] ON [dbo].[MenuRemarks]
(
	[Remark_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DepartmentId]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_DepartmentId] ON [dbo].[Menus]
(
	[DepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MenuId]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_MenuId] ON [dbo].[MenuSetMeals]
(
	[MenuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MenuSetId]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_MenuSetId] ON [dbo].[MenuSetMeals]
(
	[MenuSetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_DeskId]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_DeskId] ON [dbo].[Reserves]
(
	[DeskId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Staff_Id]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_Staff_Id] ON [dbo].[StaffStaffRoles]
(
	[Staff_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StaffRole_Id]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_StaffRole_Id] ON [dbo].[StaffStaffRoles]
(
	[StaffRole_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Id]    Script Date: 2016/6/1 9:42:22 ******/
CREATE NONCLUSTERED INDEX [IX_Id] ON [dbo].[TakeOuts]
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dines] ADD  CONSTRAINT [DF_Dines_Id]  DEFAULT ([dbo].[getDineId]((8))) FOR [Id]
GO
ALTER TABLE [dbo].[Dines] ADD  CONSTRAINT [DF_Dines_BeginTime]  DEFAULT (getdate()) FOR [BeginTime]
GO
ALTER TABLE [dbo].[Logs] ADD  CONSTRAINT [DF_Logs_DateTime]  DEFAULT (getdate()) FOR [DateTime]
GO
ALTER TABLE [dbo].[Areas]  WITH CHECK ADD  CONSTRAINT [FK_Areas_DepartmentRecipts] FOREIGN KEY([DepartmentReciptId])
REFERENCES [dbo].[Departments] ([Id])
GO
ALTER TABLE [dbo].[Areas] CHECK CONSTRAINT [FK_Areas_DepartmentRecipts]
GO
ALTER TABLE [dbo].[Areas]  WITH CHECK ADD  CONSTRAINT [FK_Areas_DepartmentServes] FOREIGN KEY([DepartmentServeId])
REFERENCES [dbo].[Departments] ([Id])
GO
ALTER TABLE [dbo].[Areas] CHECK CONSTRAINT [FK_Areas_DepartmentServes]
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD  CONSTRAINT [FK_Customers_VipLevels] FOREIGN KEY([VipLevelId])
REFERENCES [dbo].[VipLevels] ([Id])
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [FK_Customers_VipLevels]
GO
ALTER TABLE [dbo].[Departments]  WITH CHECK ADD  CONSTRAINT [FK_Printers_Departments] FOREIGN KEY([PrinterId])
REFERENCES [dbo].[Printers] ([Id])
GO
ALTER TABLE [dbo].[Departments] CHECK CONSTRAINT [FK_Printers_Departments]
GO
ALTER TABLE [dbo].[Desks]  WITH CHECK ADD  CONSTRAINT [FK_Desks_Areas] FOREIGN KEY([AreaId])
REFERENCES [dbo].[Areas] ([Id])
GO
ALTER TABLE [dbo].[Desks] CHECK CONSTRAINT [FK_Desks_Areas]
GO
ALTER TABLE [dbo].[DineMenuRemarks]  WITH CHECK ADD  CONSTRAINT [FK_DineMenuRemarks_DineMenus] FOREIGN KEY([DineMenu_Id])
REFERENCES [dbo].[DineMenus] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DineMenuRemarks] CHECK CONSTRAINT [FK_DineMenuRemarks_DineMenus]
GO
ALTER TABLE [dbo].[DineMenuRemarks]  WITH CHECK ADD  CONSTRAINT [FK_DineMenuRemarks_Remarks] FOREIGN KEY([Remark_Id])
REFERENCES [dbo].[Remarks] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DineMenuRemarks] CHECK CONSTRAINT [FK_DineMenuRemarks_Remarks]
GO
ALTER TABLE [dbo].[DineMenus]  WITH CHECK ADD  CONSTRAINT [FK_DineMenus_Dines] FOREIGN KEY([DineId])
REFERENCES [dbo].[Dines] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DineMenus] CHECK CONSTRAINT [FK_DineMenus_Dines]
GO
ALTER TABLE [dbo].[DineMenus]  WITH CHECK ADD  CONSTRAINT [FK_DineMenus_Menus] FOREIGN KEY([MenuId])
REFERENCES [dbo].[Menus] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DineMenus] CHECK CONSTRAINT [FK_DineMenus_Menus]
GO
ALTER TABLE [dbo].[DinePaidDetails]  WITH CHECK ADD  CONSTRAINT [FK_DinePaidDetails_Dines] FOREIGN KEY([DineId])
REFERENCES [dbo].[Dines] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DinePaidDetails] CHECK CONSTRAINT [FK_DinePaidDetails_Dines]
GO
ALTER TABLE [dbo].[DinePaidDetails]  WITH CHECK ADD  CONSTRAINT [FK_DinePaidDetails_PayKinds] FOREIGN KEY([PayKindId])
REFERENCES [dbo].[PayKinds] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DinePaidDetails] CHECK CONSTRAINT [FK_DinePaidDetails_PayKinds]
GO
ALTER TABLE [dbo].[DineRemarks]  WITH CHECK ADD  CONSTRAINT [FK_DineRemarks_Dines] FOREIGN KEY([Dine_Id])
REFERENCES [dbo].[Dines] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DineRemarks] CHECK CONSTRAINT [FK_DineRemarks_Dines]
GO
ALTER TABLE [dbo].[DineRemarks]  WITH CHECK ADD  CONSTRAINT [FK_DineRemarks_Remarks] FOREIGN KEY([Remark_Id])
REFERENCES [dbo].[Remarks] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DineRemarks] CHECK CONSTRAINT [FK_DineRemarks_Remarks]
GO
ALTER TABLE [dbo].[Dines]  WITH CHECK ADD  CONSTRAINT [FK_Dines_Desks] FOREIGN KEY([DeskId])
REFERENCES [dbo].[Desks] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Dines] CHECK CONSTRAINT [FK_Dines_Desks]
GO
ALTER TABLE [dbo].[MenuClasses]  WITH CHECK ADD  CONSTRAINT [FK_MenuClasses_MenuClasses_ParentMenuClassId] FOREIGN KEY([ParentMenuClassId])
REFERENCES [dbo].[MenuClasses] ([Id])
GO
ALTER TABLE [dbo].[MenuClasses] CHECK CONSTRAINT [FK_MenuClasses_MenuClasses_ParentMenuClassId]
GO
ALTER TABLE [dbo].[MenuClassMenus]  WITH CHECK ADD  CONSTRAINT [FK_MenuClassMenus_MenuClasses] FOREIGN KEY([MenuClass_Id])
REFERENCES [dbo].[MenuClasses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MenuClassMenus] CHECK CONSTRAINT [FK_MenuClassMenus_MenuClasses]
GO
ALTER TABLE [dbo].[MenuClassMenus]  WITH CHECK ADD  CONSTRAINT [FK_MenuClassMenus_Menus] FOREIGN KEY([Menu_Id])
REFERENCES [dbo].[Menus] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MenuClassMenus] CHECK CONSTRAINT [FK_MenuClassMenus_Menus]
GO
ALTER TABLE [dbo].[MenuOnSales]  WITH CHECK ADD  CONSTRAINT [FK_MenuOnSales_Menus] FOREIGN KEY([Id])
REFERENCES [dbo].[Menus] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MenuOnSales] CHECK CONSTRAINT [FK_MenuOnSales_Menus]
GO
ALTER TABLE [dbo].[MenuPrices]  WITH CHECK ADD  CONSTRAINT [FK_MenuPrices_Menus] FOREIGN KEY([Id])
REFERENCES [dbo].[Menus] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MenuPrices] CHECK CONSTRAINT [FK_MenuPrices_Menus]
GO
ALTER TABLE [dbo].[MenuRemarks]  WITH CHECK ADD  CONSTRAINT [FK_RemarkMenus_Menus] FOREIGN KEY([Menu_Id])
REFERENCES [dbo].[Menus] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MenuRemarks] CHECK CONSTRAINT [FK_RemarkMenus_Menus]
GO
ALTER TABLE [dbo].[MenuRemarks]  WITH CHECK ADD  CONSTRAINT [FK_RemarkMenus_Remarks] FOREIGN KEY([Remark_Id])
REFERENCES [dbo].[Remarks] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MenuRemarks] CHECK CONSTRAINT [FK_RemarkMenus_Remarks]
GO
ALTER TABLE [dbo].[Menus]  WITH CHECK ADD  CONSTRAINT [FK_Menus_Departments] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Departments] ([Id])
GO
ALTER TABLE [dbo].[Menus] CHECK CONSTRAINT [FK_Menus_Departments]
GO
ALTER TABLE [dbo].[MenuSetMeals]  WITH CHECK ADD  CONSTRAINT [FK_dbo.MenuSetMeals_Menus_MenuSetId] FOREIGN KEY([MenuSetId])
REFERENCES [dbo].[Menus] ([Id])
GO
ALTER TABLE [dbo].[MenuSetMeals] CHECK CONSTRAINT [FK_dbo.MenuSetMeals_Menus_MenuSetId]
GO
ALTER TABLE [dbo].[MenuSetMeals]  WITH CHECK ADD  CONSTRAINT [FK_MenuSetMeals_Menus] FOREIGN KEY([MenuId])
REFERENCES [dbo].[Menus] ([Id])
GO
ALTER TABLE [dbo].[MenuSetMeals] CHECK CONSTRAINT [FK_MenuSetMeals_Menus]
GO
ALTER TABLE [dbo].[Reserves]  WITH CHECK ADD  CONSTRAINT [FK_Reserves_Desks] FOREIGN KEY([DeskId])
REFERENCES [dbo].[Desks] ([Id])
GO
ALTER TABLE [dbo].[Reserves] CHECK CONSTRAINT [FK_Reserves_Desks]
GO
ALTER TABLE [dbo].[StaffRoleSchemas]  WITH CHECK ADD  CONSTRAINT [FK_StaffRoleSchemas_StaffRoles] FOREIGN KEY([StaffRoleId])
REFERENCES [dbo].[StaffRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StaffRoleSchemas] CHECK CONSTRAINT [FK_StaffRoleSchemas_StaffRoles]
GO
ALTER TABLE [dbo].[StaffStaffRoles]  WITH CHECK ADD  CONSTRAINT [FK_StaffStaffRoles_StaffRoles] FOREIGN KEY([StaffRole_Id])
REFERENCES [dbo].[StaffRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StaffStaffRoles] CHECK CONSTRAINT [FK_StaffStaffRoles_StaffRoles]
GO
ALTER TABLE [dbo].[StaffStaffRoles]  WITH CHECK ADD  CONSTRAINT [FK_StaffStaffRoles_Staffs] FOREIGN KEY([Staff_Id])
REFERENCES [dbo].[Staffs] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StaffStaffRoles] CHECK CONSTRAINT [FK_StaffStaffRoles_Staffs]
GO
ALTER TABLE [dbo].[TakeOuts]  WITH CHECK ADD  CONSTRAINT [FK_TakeOuts_Dines] FOREIGN KEY([Id])
REFERENCES [dbo].[Dines] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TakeOuts] CHECK CONSTRAINT [FK_TakeOuts_Dines]
GO
ALTER TABLE [dbo].[VipDiscounts]  WITH CHECK ADD  CONSTRAINT [FK_VipDiscounts_VipLevels] FOREIGN KEY([Id])
REFERENCES [dbo].[VipLevels] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VipDiscounts] CHECK CONSTRAINT [FK_VipDiscounts_VipLevels]
GO