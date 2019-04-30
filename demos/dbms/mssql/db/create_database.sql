CREATE DATABASE [dbxoodbc]
ON PRIMARY
  ( NAME = [dbxoodbc],
    FILENAME = 'C:\delphi\projects\personal\dbxoodbc\dev\dbxoodbc\demos\dbms\mssql\db\dbxoodbc.mdf',
    SIZE = 3 MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10 % )
COLLATE Cyrillic_General_BIN
GO

ALTER DATABASE [dbxoodbc]
SET RECOVERY FULL
GO
