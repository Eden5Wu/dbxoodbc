CREATE TABLE [dbo].[table4] (
  [i1] int NOT NULL,
  [i2] int NULL,
  CONSTRAINT [pk_tab4_i1] PRIMARY KEY CLUSTERED ([i1])
)
ON [PRIMARY]
GO



CREATE TABLE [dbo].[tbl_obj] (
  [objno] varchar(12) NOT NULL,
  [objnm] varchar(128) NULL,
  CONSTRAINT [pk_imp1] PRIMARY KEY CLUSTERED ([objno])
)
ON [PRIMARY]
GO
